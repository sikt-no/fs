---
"krav-viewer": minor
---

Ny visning: Spesifikasjoner, som slås på med `npm run dev:spesifikasjoner` / `npm run app:dev:spesifikasjoner` (eller `SPESIFIKASJONER=1`). En tavle over spesifikasjonene fra fs-specify, med én kolonne per kode-repo (fs-plattform, fs-admin) på veien fra Utkast og Klart til utvikling til Til verifisering og Verifisert. I detaljpanelet kan du redigere omfang, krav (hele krav plukkes med søk i filer og mapper), skisser, åpne spørsmål, ruta og stegene per repo (status, tatt av, PR, overlevering og blokkering). Kort kan dras mellom kolonnene, og «Kolonner» lar deg gi nytt navn, skjule, flytte og legge til repo-kolonner. Endringene lagres i spesifikasjonen og i `utforing.md` i oppgavemappa, og sendes med «Lag PR». «Utfør i <repo>» starter en samtale i Claude-panelet som kjører i den lokale klonen av repoet, med repoets egne skills. Den kan bygge, teste og committe lokalt, men ikke pushe. «Kopier prompt til <repo>» gir samme oppdrag til en egen Claude Code-økt.
