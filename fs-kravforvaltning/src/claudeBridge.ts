// Forbindelsen mellom Claude-panelet og resten av vieweren. Panelet melder seg på når det er åpent,
// og andre visninger (Avvik, Oppgaver) kan da sende en prompt rett inn i samtalen som er åpen.
import { useEffect, useState } from 'preact/hooks';

type Sender = (text: string) => Promise<void>;

let sender: Sender | null = null;
let busy = false;
const listeners = new Set<() => void>();
const changed = () => listeners.forEach(l => l());

/** Panelet melder seg på (og av med `null`) */
export function registerClaude(s: Sender | null) {
  sender = s;
  changed();
}

/** Panelet melder om Claude jobber i samtalen som er åpen */
export function setClaudeBusy(b: boolean) {
  if (b === busy) return;
  busy = b;
  changed();
}

/** Er panelet åpent (`ready`), jobber Claude (`busy`), og send en prompt som ny melding i samtalen */
export function useClaudeTarget() {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    return () => void listeners.delete(l);
  }, []);
  return { ready: sender !== null, busy, send: (text: string) => (sender ? sender(text) : Promise.resolve()) };
}
