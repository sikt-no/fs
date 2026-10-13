# Spec log

History of skill invocations for this spec. Append-only — never edit past entries.

## Invocations

- 2026-10-05 — `fs-specify` started — spec/spec-appadmin-etter-design-review.md (5 krav fra FS Kravforvaltning)
- 2026-10-05 — `fs-specify` ended (success) — wrote spec-appadmin-etter-design-review.md, 5 .feature files (alle @implemented, endres), 20 deler retagget @planned → @in-progress, 14 @deprecated-deler skal fjernes, 3 @draft-deler utenfor scope, 1 Figma-skisse (11 rammer) lagret, 4 skisseavvik og 1 uavklart som åpne spørsmål
- 2026-10-05 — `fs-krav` ended (success) — skisseavvik 1–3 avklart: Service-ID → Tjeneste-ID, FS vises som «FS (Maskinbruker)», regelen om FS-brukernavn avklart og satt @draft → @in-progress etter beskjed fra brukeren
- 2026-10-05 — `fs-krav` ended (success) — nytt scenario «FS-brukernavnet skiller mellom store og små bokstaver» under @in-progress-regelen for FS-brukernavn; skisseavvik 4 avklart: sortering på navn forblir @draft
- 2026-10-05 — `fs-specify` ended (success) — uavklart skisse for passord per miljø avklart (skisseres ikke); alle åpne spørsmål i spec-en er lukket
- 2026-10-05 — `fs-krav` ended (success) — konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse og settes til «ukjent» (BAT-270); regelen i opprette_applikasjon endret på stedet (@in-progress), scenarioet i se_detaljer slettet
- 2026-10-13 — `fs-krav` ended (success) — merge av main inn i krav/opprette-maskinbruker-sikt: opprette_applikasjon har Sikt-only-regler for FS-opprettelse som @draft @openquestion (ikke i spec-en); «Velge identitetsleverandør ved opprettelse, inkludert FS» @in-progress → @deprecated; 5 deler satt som levert (@in-progress fjernet) etter søk i fs-plattform og fs-admin; FS-brukernavn, konsument «ukjent» og visningsnavn på tvers fortsatt @in-progress
- 2026-10-13 — `fs-verify` started — 14 @in-progress-deler, 5 deler uansett status (levert ved merge), 15 @deprecated-deler
- 2026-10-13 — `fs-verify` ended (success) — verify-2026-10-13-1449.md: 11 funnet, 12 ikke funnet, 3 usikker av 26; 2 regler i passordbytte levert (@in-progress fjernet); 6 @deprecated-deler slettet (se_detaljer 1, passordbytte 2, opprette_applikasjon 3); 9 @deprecated finnes fortsatt i koden; @in-progress satt tilbake på 2 autentiserings-scenarioer i opprette_applikasjon etter beskjed fra brukeren
