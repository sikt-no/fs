import { useEffect, useState } from 'preact/hooks';
import { CLAUDE_SKILLS, type ClaudeEvent, type ClaudeSkill } from '../shared/api';
import { transport } from './transport';

// Skillene Claude har utenom de som kan velges (plugins, personlige). Lista huskes, så de kan avvises
// også før Claude har startet og meldt dem i denne økta. Oppdateres hver gang Claude starter.
const OTHER = 'kravforvaltning:claudeSkillsOther';
/** Skillen en ny samtale starter med: den som sist ble valgt */
const LAST = 'kravforvaltning:claudeSkill';
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
let loaded = false;
const load = () => {
  if (loaded || transport.kind === 'static') return;
  loaded = true;
  transport.call('claudeSkills').then(
    s => {
      remember(s.other);
      // Bare de tre som kan velges, i fast rekkefølge, og bare de som finnes i repoet
      choices = CLAUDE_SKILLS.flatMap(n => s.project.filter(p => p.name === n));
      changed();
    },
    () => (loaded = false),
  );
};

/** Skills vieweren kjenner fra før, til `claudeRun`, så backenden kan avvise dem */
export const knownSkills = () => known;
export const lastSkill = (): string | null => {
  const s = read<string | null>(LAST, null);
  return s && CLAUDE_SKILLS.includes(s) ? s : null;
};

interface Props {
  value: string | null;
  onChange: (skill: string) => void;
  /** Skillene som kan velges her; de andre vises, men er deaktivert */
  allowed: string[];
  /** Hvorfor de andre ikke kan velges */
  hint: string;
  disabled?: boolean;
}

/**
 * Hvilken skill samtalen bruker, rett over inputfeltet: fs-krav, fs-specify eller fs-specify-delta.
 * Det er alltid én, og bare én, valgt. Den lastes med neste melding (`/<skill>`), og alle andre skills avvises.
 */
export function SkillPicker({ value, onChange, allowed, hint, disabled }: Props) {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    load();
    return () => void listeners.delete(l);
  }, []);
  if (!choices.length) return null;

  const pick = (s: string) => {
    write(LAST, s);
    onChange(s);
  };
  return (
    <div class="cskills" role="radiogroup" aria-label="Skill for samtalen">
      <span class="cskills-label">Skill</span>
      {choices.map(c => {
        const ok = allowed.includes(c.name);
        return (
          <button
            key={c.name}
            class="cskill"
            role="radio"
            aria-checked={value === c.name}
            disabled={disabled || !ok}
            title={ok ? c.description : `${c.name}: ${hint}`}
            onClick={() => pick(c.name)}
          >
            {c.name}
          </button>
        );
      })}
    </div>
  );
}
