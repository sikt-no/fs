// Forbindelsen mellom Claude-panelet og resten av vieweren. Panelet melder seg på når det er åpent,
// og andre visninger kan da sende en prompt rett inn i samtalen som er åpen (Avvik, Oppgaver),
// eller legge tekst i inputfeltet (markert tekst i feature-visningen).
import { useEffect, useState } from 'preact/hooks';
import type { ExecuteTarget } from '../shared/api';

interface Target {
  /** Sender teksten som ny melding i samtalen som er åpen */
  send: (text: string) => Promise<void>;
  /** Starter en ny samtale som utførekjøring i kode-repoet, med teksten som første melding */
  execute: (text: string, target: ExecuteTarget, title: string) => Promise<void>;
  /** Starter en ny samtale med skillen `skill` (f.eks. fs-verify fra «Verifiser»), med teksten som første melding */
  withSkill: (text: string, skill: string) => Promise<void>;
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

/** Venter (høyst `ms`) på at panelet har meldt seg på, f.eks. rett etter at det er åpnet */
export function whenClaudeReady(ms = 3000): Promise<Target | null> {
  if (sender) return Promise.resolve(sender);
  return new Promise(ok => {
    const l = () => {
      if (!sender) return;
      listeners.delete(l);
      clearTimeout(t);
      ok(sender);
    };
    const t = setTimeout(() => {
      listeners.delete(l);
      ok(null);
    }, ms);
    listeners.add(l);
  });
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
    execute: (text: string, target: ExecuteTarget, title: string) => (sender ? sender.execute(text, target, title) : Promise.resolve()),
    withSkill: (text: string, skill: string) => (sender ? sender.withSkill(text, skill) : Promise.resolve()),
    insert: (text: string) => sender?.insert(text),
  };
}
