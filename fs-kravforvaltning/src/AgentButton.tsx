import { useEffect, useRef, useState } from 'preact/hooks';
import { useClaudeTarget } from './claudeBridge';
import { useCopy } from './useCopy';

interface Props {
  /** Prompten, laget først når knappen trykkes */
  prompt: () => string;
  /** Teksten på knappen når prompten kopieres */
  copyLabel: string;
  /** Hjelpeteksten når prompten kopieres */
  copyTitle: string;
}

/**
 * «Kopier agent-prompt». Er Claude-panelet åpent, blir knappen «Send til Claude Code», og prompten
 * sendes som ny melding i samtalen som er åpen (eller en ny, hvis ingen er det).
 */
export function AgentButton({ prompt, copyLabel, copyTitle }: Props) {
  const claude = useClaudeTarget();
  const [copied, copy] = useCopy();
  const [sent, setSent] = useState(false);
  const timer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(timer.current), []);

  if (claude.ready)
    return (
      <button
        class={'agentbtn' + (sent ? ' on' : '')}
        disabled={claude.busy}
        title={claude.busy ? 'Claude jobber i samtalen; vent til svaret er ferdig' : 'Sender prompten som melding i samtalen som er åpen i Claude-panelet'}
        onClick={async () => {
          await claude.send(prompt());
          setSent(true);
          clearTimeout(timer.current);
          timer.current = setTimeout(() => setSent(false), 1800);
        }}
      >
        <span class="agentmark" />
        {claude.busy ? 'Claude jobber …' : sent ? 'Sendt' : 'Send til Claude Code'}
      </button>
    );
  return (
    <button class={'agentbtn' + (copied ? ' on' : '')} onClick={() => copy(prompt())} title={copyTitle}>
      <span class="agentmark" />
      {copied ? 'Kopiert' : copyLabel}
    </button>
  );
}
