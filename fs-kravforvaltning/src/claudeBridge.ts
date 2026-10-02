// Forbindelsen mellom Claude-panelet og resten av vieweren. Panelet melder seg på når det er åpent,
// og andre visninger kan da sende en prompt rett inn i samtalen som er åpen (Avvik, Oppgaver),
// eller legge tekst i inputfeltet (markert tekst i feature-visningen).
import { useEffect, useState } from 'preact/hooks';

interface Target {
  /** Sender teksten som ny melding i samtalen som er åpen */
  send: (text: string) => Promise<void>;
  /** Legger teksten til i inputfeltet; brukeren sender selv */
  insert: (text: string) => void;
}

let sender: Target | null = null;
let busy = false;
const listeners = new Set<() => void>();
const changed = () => listeners.forEach(l => l());

/** Panelet melder seg på (og av med `null`) */
export function registerClaude(s: Target | null) {
  sender = s;
  changed();
}

/** Panelet melder om Claude jobber i samtalen som er åpen */
export function setClaudeBusy(b: boolean) {
  if (b === busy) return;
  busy = b;
  changed();
}

/** Er panelet åpent (`ready`), jobber Claude (`busy`), send en prompt som ny melding i samtalen, eller legg tekst i inputfeltet */
export function useClaudeTarget() {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    return () => void listeners.delete(l);
  }, []);
  return {
    ready: sender !== null,
    busy,
    send: (text: string) => (sender ? sender.send(text) : Promise.resolve()),
    insert: (text: string) => sender?.insert(text),
  };
}
