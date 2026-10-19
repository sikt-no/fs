// Skal fs-verify ta skjermbilder? Valget ved «Verifiser» huskes i localStorage, og står i prompten (`screenshotLine`),
// så fs-verify ikke spør. Adressen (test-fsadmin) står i skillen, ikke her.
import { useState } from 'preact/hooks';

const KEY = 'kravforvaltning:verifyScreenshots';

function read(): boolean {
  try {
    return localStorage.getItem(KEY) !== '0';
  } catch {
    return true;
  }
}

/** Valget «Ta skjermbilder», med ja som standard */
export function useVerifyScreenshots(): [boolean, (on: boolean) => void] {
  const [on, setOn] = useState(read);
  return [
    on,
    (v: boolean) => {
      setOn(v);
      try {
        localStorage.setItem(KEY, v ? '1' : '0');
      } catch {
        /* ignorer */
      }
    },
  ];
}
