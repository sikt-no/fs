# FS Kravforvaltning: regler for Claude

Beskrivelsen av appen står i [`../CLAUDE.md`](../CLAUDE.md). Denne fila har reglene som gjelder når Claude jobber i `fs-kravforvaltning/`.

## Prosesser

Stopp aldri prosesser etter navn eller mønster: ikke `pkill -f vite`, `pkill node`, `killall electron` eller lignende. Brukeren har som regel sine egne dev-servere og Electron-apper i gang, også FS Kravforvaltning som desktop-app, og de stoppes da også.

- Stopp bare prosesser du har startet selv: den bakgrunnsoppgaven du startet (stopp oppgaven), eller PID-en du fikk da du startet den (`kill <pid>`).
- Er porten opptatt (5173 for dev-serveren, 5273 for desktop-appen i dev, begge med `strictPort`), er det brukerens server. Bruk den, eller spør. Stopp den ikke.
- Ikke stopp prosesser ut fra en port (`lsof -ti :5173 | xargs kill`). Porten kan tilhøre brukeren.
