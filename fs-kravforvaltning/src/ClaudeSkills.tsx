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
let loaded = false;
const load = () => {
  if (loaded || transport.kind === 'static') return;
  loaded = true;
  transport.call('claudeSkills').then(
    s => {
      remember(s.other);
      // Bare de som kan velges (CLAUDE_SKILLS), i fast rekkefølge, og bare de som finnes i repoet
      choices = CLAUDE_SKILLS.flatMap(n => s.project.filter(p => p.name === n));
      changed();
    },
    () => (loaded = false),
  );
};

/** Skills vieweren kjenner fra før, til `claudeRun`, så backenden kan avvise dem */
export const knownSkills = () => known;

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
}

/**
 * Hvilken skill samtalen bruker, rett over inputfeltet (en av `CLAUDE_SKILLS`). Den valgte lastes med
 * neste melding (`/<skill>`), men er bare et forslag: Claude kan også bruke de andre skillene som er
 * tillatt her, når oppgaven krever det. Alle andre skills avvises. Med `preselect` er det alltid én valgt;
 * uten kan brukeren velge «Ingen», og da lastes ingen på forhånd.
 */
export function SkillPicker({ value, onChange, allowed, hint, preselect, disabled }: Props) {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    load();
    return () => void listeners.delete(l);
  }, []);
  if (!choices.length) return null;

  return (
    <div class="cskills" role="radiogroup" aria-label="Skill for samtalen">
      <span class="cskills-label">Skill</span>
      {!preselect && (
        <button
          class="cskill"
          role="radio"
          aria-checked={value === null}
          disabled={disabled}
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
            disabled={disabled || !ok}
            title={ok ? c.description : `${c.name}: ${hint(c.name)}`}
            onClick={() => onChange(!preselect && value === c.name ? null : c.name)}
          >
            {c.name}
          </button>
        );
      })}
    </div>
  );
}
