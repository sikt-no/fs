import { useEffect, useRef, useState } from 'preact/hooks';
import { useVerifyScreenshots } from './verifyScreenshots';

interface Props {
  /** Hva som verifiseres, til hjelpeteksten: «egenskapen», «regelen» */
  what: string;
  /** Starter verifiseringen i Claude-panelet, med valget «Ta skjermbilder» */
  onVerify: (screenshots: boolean) => void;
  /** Starter fs-verify-agent-teams i terminalen; utelatt der det ikke gir mening (en regel) */
  onTerminal?: (screenshots: boolean) => void;
}

/**
 * «Verifiser» på en egenskap eller en regel: en liten meny med «Ta skjermbilder (test-fsadmin)» og
 * «Verifiser i Claude-panelet». Verifiseringen går uansett status (fs-verify, *Verifisere uansett status*).
 */
export function VerifyMenu({ what, onVerify, onTerminal }: Props) {
  const [open, setOpen] = useState(false);
  const [shots, setShots] = useVerifyScreenshots();
  const ref = useRef<HTMLSpanElement>(null);

  useEffect(() => {
    if (!open) return;
    const close = (e: Event) => {
      if (e instanceof KeyboardEvent ? e.key === 'Escape' : !ref.current?.contains(e.target as Node)) setOpen(false);
    };
    addEventListener('mousedown', close);
    addEventListener('keydown', close);
    return () => {
      removeEventListener('mousedown', close);
      removeEventListener('keydown', close);
    };
  }, [open]);

  return (
    <span class="vmenu" ref={ref}>
      <button
        class={'smallbtn editbtn vmenu-btn' + (open ? ' on' : '')}
        aria-expanded={open}
        title={`Verifiser ${what} mot koden med fs-verify, uansett status`}
        onClick={() => setOpen(o => !o)}
      >
        Verifiser
      </button>
      {open && (
        <div class="vmenu-pop" role="dialog" aria-label={`Verifiser ${what}`}>
          <div class="vmenu-h">Verifiser {what} mot koden</div>
          <div class="vmenu-sub muted">fs-verify i Claude-panelet, uansett status. Er alt funnet, foreslår Claude ny status.</div>
          <label class="spd-check">
            <input type="checkbox" checked={shots} onChange={e => setShots((e.currentTarget as HTMLInputElement).checked)} />
            Ta skjermbilder (test-fsadmin)
          </label>
          <button
            class="primbtn"
            onClick={() => {
              setOpen(false);
              onVerify(shots);
            }}
          >
            Verifiser i Claude-panelet
          </button>
          {onTerminal && (
            <button
              class="smallbtn"
              title="fs-verify-agent-teams: interaktiv Claude Code med agent teams i en terminal i Claude-panelet"
              onClick={() => {
                setOpen(false);
                onTerminal(shots);
              }}
            >
              I terminal med agent team
            </button>
          )}
        </div>
      )}
    </span>
  );
}
