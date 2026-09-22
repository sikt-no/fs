<!--
Mal for lagplan. Kopier til tasks/<domene>/<slug>/<lag>/plan-<slug>.md
— altså INNE i lagets egen undermappe, ikke i oppgave-rota.
Eksempler på lag: spec (krav), tester, backend, frontend, subgraph, db, dokumentasjon.

Hvorfor undermappe: BAT-verktøyene globber `plan-*.md` i oppgave-rota for å avgjøre
om plansteget er ferdig. En plan som ligger i rota blir lest som et fullført BAT-steg.
Se ../../README.md, regel 1 og 2.
-->

# Plan (<lag>): <Oppgavetittel>

Lenker: [oppgave.md](../oppgave.md) · [design.md](../design.md) · [issue](https://github.com/sikt-no/fs/issues/NNNN)

## Omfang for dette laget

Hva skal endres i <lag> som følge av designet? Skriv kort og konkret.

## Forutsetninger

Hva må være på plass før vi starter (avhengigheter til andre lag, klargjort miljø, tilganger).

## Arbeidsoppgaver

Konkrete, avkryssbare oppgaver. Oppdateres underveis i utviklingsfasen.

- [ ] Oppgave 1
- [ ] Oppgave 2
- [ ] Oppgave 3

## Testing

Hvordan verifiserer vi at dette laget leverer det det skal? Lenk til relevante `.feature`-filer eller testscenarioer.

## Rollout / migrering

Hva må til for å ta endringen i bruk? Feature flags, dataflytting, rekkefølge mellom lag, kommunikasjon til brukere.

## Åpne spørsmål

Ting vi må avklare underveis.
