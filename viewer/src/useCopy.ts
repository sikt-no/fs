import { useEffect, useRef, useState } from 'preact/hooks';

/** Kopierer tekst til utklippstavla, med fallback for når Clipboard API ikke er tilgjengelig. `copied` er sann i 1,8 s etterpå. */
export function useCopy(): [boolean, (text: string) => void] {
  const [copied, setCopied] = useState(false);
  const timer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(timer.current), []);
  const copy = (text: string) => {
    const done = () => {
      setCopied(true);
      clearTimeout(timer.current);
      timer.current = setTimeout(() => setCopied(false), 1800);
    };
    const fallback = () => {
      const t = document.createElement('textarea');
      t.value = text;
      t.style.position = 'fixed';
      t.style.opacity = '0';
      document.body.appendChild(t);
      t.select();
      try {
        document.execCommand('copy');
      } catch {
        /* utilgjengelig utklippstavle */
      }
      t.remove();
      done();
    };
    try {
      navigator.clipboard.writeText(text).then(done, fallback);
    } catch {
      fallback();
    }
  };
  return [copied, copy];
}
