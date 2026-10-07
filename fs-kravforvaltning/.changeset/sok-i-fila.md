---
"krav-viewer": minor
---

Søk i fila med Cmd+F / Ctrl+F: søkefeltet ligger øverst i innholdspanelet, og treffene markeres i fila og listes per regel og scenario. Søket er fuzzy med Fuse.js, som søket i treet, og tåler skrivefeil (`'ord` gir bare eksakt treff). Med flere ord må alle treffe i samme tekst, så en innlimt scenariotittel gir ett treff på tittelen. Scenarioer som er foldet sammen, åpnes når de har treff. Enter og Shift+Enter (eller Cmd/Ctrl+G) går mellom treffene, og visningen hopper til treffet. Innholdspanelet kan vises og skjules med en egen knapp i toppfeltet, også når Claude-panelet er åpent, og Claude-knappen har fått et panelikon. Også desktop-appen, der Cmd+F ikke gjorde noe før.
