// Promptene til fs-verify fra knappene i vieweren. Rene funksjoner, testet i verifyPrompt.test.ts.

/** Linja om skjermbilder: fs-verify spør ikke når den står i prompten. Adressen (test-fsadmin) står i skillen */
export const screenshotLine = (on: boolean) => (on ? 'Ta skjermbilder av scenarioene som har en skjerm.' : 'Ingen skjermbilder.');
