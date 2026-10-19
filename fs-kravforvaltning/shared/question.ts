// Spørsmål fra Claude med AskUserQuestion: kallet kommer til `approve` (core/approve.ts), og svaret går tilbake som
// `updatedInput: { questions, answers }`. Rene funksjoner, felles for backenden og vieweren.

export interface QuestionOption {
  label: string;
  description: string;
  /** Forhåndsvisning (kodesnutt, skisse) som vises når valget er markert */
  preview?: string;
}

export interface Question {
  question: string;
  /** Kort etikett over spørsmålet («Skjermbilder») */
  header: string;
  options: QuestionOption[];
  multiSelect: boolean;
}

/** Svarene, med spørsmålsteksten som nøkkel: label for valget, labels skilt med «, » ved flervalg, eller fritekst */
export type Answers = Record<string, string>;

/** Det brukeren har valgt på kortet for ett spørsmål: labelene som er krysset av, og teksten i «Annet» */
export interface Pick {
  labels: string[];
  other: string;
}

const str = (v: unknown, max: number): string | null => (typeof v === 'string' && v.trim() ? v.slice(0, max) : null);

/**
 * Spørsmålene fra `input` til AskUserQuestion, eller `null` når de ikke har formen verktøyet beskriver:
 * 1–4 spørsmål med 2–4 valg hvert, og med spørsmålstekst, etikett og label på hvert valg.
 */
export function parseQuestions(input: unknown): Question[] | null {
  const qs = (input as { questions?: unknown } | null)?.questions;
  if (!Array.isArray(qs) || qs.length < 1 || qs.length > 4) return null;
  const out: Question[] = [];
  for (const q of qs) {
    if (!q || typeof q !== 'object') return null;
    const r = q as Record<string, unknown>;
    const question = str(r.question, 1000);
    const opts = r.options;
    if (!question || !Array.isArray(opts) || opts.length < 2 || opts.length > 4) return null;
    const options: QuestionOption[] = [];
    for (const o of opts) {
      const label = str((o as Record<string, unknown> | null)?.label, 200);
      if (!label) return null;
      const or = o as Record<string, unknown>;
      const preview = str(or.preview, 4000);
      options.push({ label, description: typeof or.description === 'string' ? or.description.slice(0, 1000) : '', ...(preview ? { preview } : {}) });
    }
    out.push({ question, header: str(r.header, 40) ?? '', options, multiSelect: r.multiSelect === true });
  }
  // Svarene har spørsmålsteksten som nøkkel, så den må være unik
  return new Set(out.map(q => q.question)).size === out.length ? out : null;
}

/** Svaret på ett spørsmål, eller `null` når ingenting er valgt. «Annet» med tekst kommer etter valgene */
export function answerFor(q: Question, p: Pick | undefined): string | null {
  if (!p) return null;
  const labels = q.options.map(o => o.label).filter(l => p.labels.includes(l));
  const other = p.other.trim();
  const parts = q.multiSelect ? [...labels, ...(other ? [other] : [])] : other ? [other] : labels.slice(0, 1);
  return parts.length ? parts.join(', ') : null;
}

/** Svarene på alle spørsmålene, eller `null` så lenge ett av dem mangler svar */
export function answersFor(qs: Question[], picks: Record<string, Pick>): Answers | null {
  const out: Answers = {};
  for (const q of qs) {
    const a = answerFor(q, picks[q.question]);
    if (a === null) return null;
    out[q.question] = a;
  }
  return out;
}

/** Svarene fra vieweren, sjekket mot spørsmålene: én tekst per spørsmål, og ikke noe annet */
export function validAnswers(qs: Question[], answers: unknown): Answers | null {
  if (!answers || typeof answers !== 'object') return null;
  const a = answers as Record<string, unknown>;
  const out: Answers = {};
  for (const q of qs) {
    const v = a[q.question];
    if (typeof v !== 'string' || !v.trim()) return null;
    out[q.question] = v.slice(0, 4000);
  }
  return out;
}
