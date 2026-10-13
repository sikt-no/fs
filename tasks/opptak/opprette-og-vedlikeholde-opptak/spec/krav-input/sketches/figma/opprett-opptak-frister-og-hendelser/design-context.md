# Design context — Opprett opptak NY

Hentet 2026-09-30 fra Figma MCP, node `20606:117530` (siden «Opprett nytt Samordna opptak»).
Figma-URL: <https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20606-117530&m=dev>

## Sidestruktur

Siden er et skjema med seksjonene:

1. **Navn** (node `20606:117537`) — 4 språkfelt: Bokmål, Nynorsk, Engelsk, Samisk. Tekst: «Alle felter må fylles».
2. **Samordning** (node `20606:117565`) — Forvalter av opptaket (HK-Dir), knapp «Inviter organisasjoner til samordningen», rutenett med 27 samordnede organisasjoner (forkortelse, fullt navn, antall utdanninger, fjern-knapp). Knapp «Avbryt».
3. **Innstillinger for opptaket** (node `20606:117589`) — Velg opptakstype (dropdown), Velg regelverksamling (dropdown), Godkjente utdanningsbakgrunner (chip-liste med fjern), Startnummer for søknader, Antall søknadsalternativer, Tilbud per tildelingsrunde, Poenglikhetsregel (dropdown, Loddtrekning), checkbox «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet». Høyre side: avkryssinger «Ledige studieplasser», «Kan søke på tidlig opptak», «Søker kan laste opp dokumenter», «Krav til studierett for å søke».
4. **Generelle frister** (node `20606:117632`) — Grupper: Redigering av studier (åpner/stenger), Søkeperiode (åpner/ordinær søknadsfrist), Endre søknad (omprioriteringsfrist/slette søknadsalternativer), Dokumentasjon (ordinær frist/ettersendingsfrist), Tidlig opptak (søknadsfrist/dokumentasjonsfrist/frist for poenggrenser), Ledige studieplasser (publiseres/åpner/stenger), Saksbehandlertildeling (endre utdanningsbakgrunn), Hovedopptak (publiseringsdato/svarfrist).
5. **Utdanningsbakgrunner med avvikende frister** (node `21171:97060`) — Knapp «Legg til ny utdanningsbakgrunn», kort per utdanningsbakgrunn (Realkompetanse, Nordisk videregående skole) med søknadsfrist og frist dokumentasjon, fjern-knapp. Hjelpetekst: «Avvikende frister for ulike utdanningsbakgrunner defineres her.» og «(Egne frister for enkelte utdanningstilbud settes opp på utdanningstilbudets detaljside)».

## Bunntekst

Knapper «Avbryt» og «Opprett» (primærknapp).
