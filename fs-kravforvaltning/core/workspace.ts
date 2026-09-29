import { EventEmitter } from 'node:events';
import { existsSync, readdirSync, readFileSync, statSync, watch, type FSWatcher } from 'node:fs';
import { join, relative, sep } from 'node:path';
import type { Entry, GitInfo, Snapshot, UpdateEvent } from '../shared/model.ts';
import type { TasksSnapshot } from '../shared/tasks.ts';
import { buildEntry } from '../server/parse.ts';
import { readTasks } from '../server/tasks.ts';
import type { Vcs } from './vcs.ts';

export const isKravFile = (p: string) => p.endsWith('.feature') || p.endsWith('.md');

/** Hendelsene en arbeidsflate sender. Navnene er de samme som over Vites websocket og Electrons IPC. */
export interface WorkspaceEvents {
  'krav:update': UpdateEvent;
  'krav:git': GitInfo | null;
  'krav:tasks': TasksSnapshot;
}
export type WorkspaceEvent = keyof WorkspaceEvents;

/**
 * krav/ (og tasks/ i Oppgaver-modus) lest og parset i minnet, med git-status fra en `Vcs`.
 * Ren Node: Vite-pluginen og Electrons main-prosess mater filhendelser inn med `onFs`
 * (eller `watch()`), og videresender hendelsene til sin egen transport.
 */
export class Workspace {
  readonly kravDir: string;
  readonly tasksDir: string;
  readonly entries: Snapshot = {};
  git: GitInfo | null = null;
  tasks: TasksSnapshot | null = null;
  private readonly emitter = new EventEmitter();
  private gitTimer: ReturnType<typeof setTimeout> | undefined;
  private tasksTimer: ReturnType<typeof setTimeout> | undefined;
  private watchers: FSWatcher[] = [];

  readonly repoRoot: string;
  readonly vcs: Vcs | null;
  readonly opts: { oppgaver?: boolean };

  constructor(repoRoot: string, vcs: Vcs | null, opts: { oppgaver?: boolean } = {}) {
    this.repoRoot = repoRoot;
    this.vcs = vcs;
    this.opts = opts;
    this.kravDir = join(repoRoot, 'krav');
    this.tasksDir = join(repoRoot, 'tasks');
  }

  rel(abs: string) {
    return relative(this.repoRoot, abs).split(sep).join('/');
  }

  on<E extends WorkspaceEvent>(event: E, fn: (data: WorkspaceEvents[E]) => void) {
    this.emitter.on(event, fn);
    return () => void this.emitter.off(event, fn);
  }

  private emit<E extends WorkspaceEvent>(event: E, data: WorkspaceEvents[E]) {
    this.emitter.emit(event, data);
  }

  private load(abs: string): Entry {
    const path = this.rel(abs);
    this.entries[path] = buildEntry(path, readFileSync(abs, 'utf8'), statSync(abs).mtimeMs, this.entries[path]);
    return this.entries[path];
  }

  /** Leser hele krav/ (og tasks/) på nytt. `withGit: false` i statisk bygg, der git-data utelates. */
  async readAll({ withGit = true } = {}) {
    for (const k of Object.keys(this.entries)) delete this.entries[k];
    if (existsSync(this.kravDir)) {
      for (const f of readdirSync(this.kravDir, { recursive: true, encoding: 'utf8' })) {
        if (isKravFile(f)) this.load(join(this.kravDir, f));
      }
    }
    this.tasks = this.opts.oppgaver ? readTasks(this.repoRoot) : null;
    this.git = withGit && this.vcs ? await this.vcs.info() : null;
  }

  /** En fil under repoet er lagt til, endret eller slettet */
  onFs(event: 'add' | 'change' | 'unlink', abs: string) {
    if (abs.startsWith(this.tasksDir + sep)) return this.opts.oppgaver ? this.refreshTasks() : undefined;
    if (!abs.startsWith(this.kravDir + sep) || !isKravFile(abs)) return;
    let data: UpdateEvent;
    if (event === 'unlink') {
      delete this.entries[this.rel(abs)];
      data = { path: this.rel(abs), entry: null };
    } else {
      try {
        data = { path: this.rel(abs), entry: this.load(abs) };
      } catch {
        return; // filen forsvant mellom hendelse og lesing
      }
    }
    this.emit('krav:update', data);
    this.refreshGit();
  }

  /** En mappe under tasks/ er lagt til eller fjernet */
  onDir(abs: string) {
    if (this.opts.oppgaver && abs.startsWith(this.tasksDir + sep)) this.refreshTasks();
  }

  /** Oppgavemappene er små, så hele tasks/ leses på nytt ved hver endring */
  refreshTasks() {
    clearTimeout(this.tasksTimer);
    this.tasksTimer = setTimeout(() => {
      try {
        this.tasks = readTasks(this.repoRoot);
      } catch {
        return; // en fil forsvant mens mappa ble lest; neste hendelse leser på nytt
      }
      this.emit('krav:tasks', this.tasks);
    }, 300);
  }

  /** Les git-status på nytt når krav-filer eller git (commit, stage, checkout) endres */
  refreshGit() {
    if (!this.vcs) return;
    clearTimeout(this.gitTimer);
    this.gitTimer = setTimeout(async () => {
      const next = await this.vcs!.info();
      if (JSON.stringify(next) === JSON.stringify(this.git)) return;
      this.git = next;
      this.emit('krav:git', this.git);
    }, 300);
  }

  /**
   * Vite overvåker ikke .git/, så følg HEAD, index og reflog direkte. Git bytter filene ut
   * atomisk (via .lock + rename), derfor overvåkes mappene og ikke filene.
   */
  async watchGit() {
    const dir = await this.vcs?.gitDir();
    if (!dir) return;
    const targets: [string, string[]][] = [
      [dir, ['HEAD', 'index']],
      [join(dir, 'logs'), ['HEAD']],
    ];
    for (const [d, names] of targets) {
      try {
        this.watchers.push(watch(d, (_e, f) => f && names.includes(f) && this.refreshGit()));
      } catch {
        /* mappa finnes ikke (f.eks. ingen reflog i en fersk klone) */
      }
    }
  }

  /** Egen filovervåking for når ingen Vite-server gjør det (Electron) */
  watch() {
    const dirs = [this.kravDir, ...(this.opts.oppgaver ? [this.tasksDir] : [])];
    for (const dir of dirs) {
      if (!existsSync(dir)) continue;
      this.watchers.push(
        watch(dir, { recursive: true }, (_e, f) => {
          if (!f) return;
          const abs = join(dir, f.toString());
          let isDir = false;
          let exists = true;
          try {
            isDir = statSync(abs).isDirectory();
          } catch {
            exists = false;
          }
          if (isDir) this.onDir(abs);
          else this.onFs(exists ? 'change' : 'unlink', abs);
        }),
      );
    }
    void this.watchGit();
  }

  close() {
    this.watchers.forEach(w => w.close());
    this.watchers = [];
    clearTimeout(this.gitTimer);
    clearTimeout(this.tasksTimer);
  }
}
