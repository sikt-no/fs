import { useEffect, useState } from 'preact/hooks';
import { CLAUDE_SKILLS, type ClaudeEvent, type ClaudeSkill } from '../shared/api';
import { transport } from './transport';

// Skillene Claude har utenom de som kan velges (plugins, personlige). Lista huskes, så de kan avvises
// også før Claude har startet og meldt dem i denne økta. Oppdateres hver gang Claude starter.
const OTHER = 'kravforvaltning:claudeSkillsOther';
const read = <T,>(key: string, fallback: T): T => {
  try {
    return (JSON.parse(localStorage.getItem(key) ?? 'null') as T) ?? fallback;
  } catch {
    return fallback;
  }
};
const write = (key: string, value: unknown) => {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch {
    /* utilgjengelig lagring */
  }
};

let known: string[] = read<string[]>(OTHER, []);
let choices: ClaudeSkill[] = [];
const listeners = new Set<() => void>();
const changed = () => listeners.forEach(l => l());

const remember = (names: string[] | null) => {
  if (!names?.length) return;
  known = names;
  write(OTHER, known);
};
transport.on('krav:claude', ({ event }: { event: ClaudeEvent }) => {
  if (event.kind === 'init') remember(event.skills);
});
// Versjonen av hver skill i repoet (hash over filene). Endres den, er skillen utdatert i samtaler som lastet den før.
let hashes: Record<string, string> = {};
let loading: Promise<void> | null = null;

/**
 * Henter skillene fra backenden på nytt: ved første visning, etter «Hent siste», når vinduet får fokus
 * og før hver melding, så en endret skill blir sett uten omlasting.
 */
export const refreshSkills = (): Promise<void> => {
  if (transport.kind === 'static') return Promise.resolve();
  loading ??= transport.call('claudeSkills').then(
    s => {
      loading = null;
      remember(s.other);
      // Bare de som kan velges (CLAUDE_SKILLS), i fast rekkefølge, og bare de som finnes i repoet
      const next = CLAUDE_SKILLS.flatMap(n => s.project.filter(p => p.name === n));
      const nextHashes = Object.fromEntries(s.project.map(p => [p.name, p.hash]));
      if (JSON.stringify(next) === JSON.stringify(choices) && JSON.stringify(nextHashes) === JSON.stringify(hashes)) return;
      choices = next;
      hashes = nextHashes;
      changed();
    },
    () => {
      loading = null;
    },
  );
  return loading;
};
if (typeof addEventListener === 'function') addEventListener('focus', () => void refreshSkills());

/** Skills vieweren kjenner fra før, til `claudeRun`, så backenden kan avvise dem */
export const knownSkills = () => known;

/** Versjonen av skillene på disk, sist de ble hentet */
export const skillHashes = () => hashes;

/** Versjonen av skillene, og tegner på nytt når de endres */
export function useSkillHashes(): Record<string, string> {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    void refreshSkills();
    return () => void listeners.delete(l);
  }, []);
  return hashes;
}

interface Props {
  value: string | null;
  onChange: (skill: string | null) => void;
  /** Skillene som kan velges her; de andre vises, men er deaktivert */
  allowed: string[];
  /** Hvorfor en skill ikke kan velges her */
  hint: (skill: string) => string;
  /** Én skill er alltid valgt (Krav, Avvik). Uten: «Ingen» kan velges, og da kan Claude bruke alle de tillatte (Oppgaver) */
  preselect: boolean;
  disabled?: boolean;
  /** Skillen er oppdatert siden den ble lastet: et bytte ville lastet den nye versjonen inn i den gamle samtalen */
  locked?: boolean;
}

/**
 * Hvilken skill samtalen bruker, rett over inputfeltet (en av `CLAUDE_SKILLS`). Den valgte lastes med
 * neste melding (`/<skill>`), men er bare et forslag: Claude kan også bruke de andre skillene som er
 * tillatt her, når oppgaven krever det. Alle andre skills avvises. Med `preselect` er det alltid én valgt;
 * uten kan brukeren velge «Ingen», og da lastes ingen på forhånd.
 */
export function SkillPicker({ value, onChange, allowed, hint, preselect, disabled, locked }: Props) {
  useSkillHashes();
  if (!choices.length) return null;
  const off = disabled || locked;

  return (
    <div class={'cskills' + (locked ? ' locked' : '')} role="radiogroup" aria-label="Skill for samtalen">
      <span class="cskills-label">Skill</span>
      {!preselect && (
        <button
          class="cskill"
          role="radio"
          aria-checked={value === null}
          disabled={off}
          title={`Ingen valgt: Claude kan bruke ${allowed.join(', ')} når det passer`}
          onClick={() => onChange(null)}
        >
          Ingen
        </button>
      )}
      {choices.map(c => {
        const ok = allowed.includes(c.name);
        return (
          <button
            key={c.name}
            class="cskill"
            role="radio"
            aria-checked={value === c.name}
            disabled={off || !ok}
            title={ok ? c.description : `${c.name}: ${hint(c.name)}`}
            onClick={() => onChange(!preselect && value === c.name ? null : c.name)}
          >
            {c.name}
          </button>
        );
      })}
      {locked && <span class="cskills-hint">Start en ny samtale for å bytte skill</span>}
    </div>
  );
}
