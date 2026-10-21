# Spec: Tilbudsgaranti

## Kilde

- **Oppgave:** `tasks/opptak/tilbudsgaranti/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling`
- **Scope:** scope-tilbudsgaranti-2027
- **GitHub:** [#512](https://github.com/sikt-no/fs/issues/512)
- **Hentet:** `2026-10-21 15:42`

## Omfang

Saksbehandler, tilbyder og opptaksforvalter setter, endrer og fjerner tilbudsgaranti på et søknadsalternativ, hver i sitt felt og med tilbudsgarantitypene opptaket har for rollen. Saksbehandlerne ser tilbudsgarantiene fra alle rollene, og i endringsloggen hvem som har satt og fjernet dem, og på hvilket søknadsalternativ. Tilbudsgarantien følger søknadsalternativet når prioriteten endres og når det flyttes til en annen saksbehandlende organisasjon, faller bort når søknadsalternativet fjernes, og gjelder igjen når det legges inn igjen. Spesifikasjonen dekker ikke tidligopptaket (`@OPT-BEH-BEH-007`), hvordan plasstildelingen gir tilbud (`@OPT-PLA-TIL-002`), eller forvaltning av tilbudsgarantitypene (typene legges inn i databasen per opptak).

## Krav

- **`gi_tilbudsgaranti.feature`** (`@OPT-BEH-BEH-010`) — manuell tilbudsgaranti fra saksbehandler, tilbyder og opptaksforvalter, sporing i endringsloggen, og at tilbudsgarantien følger søknadsalternativet. ([krav/…/gi_tilbudsgaranti.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature))

## Skisser

### Skisse: Søknadsalternativ i saksbehandlingen

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=9840-220112 (tilbudsgarantien står i rammen `9840:223140` «studiealternativ v2»)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/soknadsalternativ-i-saksbehandlingen/screenshot.png)
- **Dekker krav:** `gi_tilbudsgaranti.feature` (regelen «Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt»)
- **Valideringsstatus:** `Avvik: skissen viser tilbudsgaranti som én avkrysningsboks «Ja», uten tilbudsgarantityper og uten roller. Kravet har tre felt, ett for saksbehandler, tilbyder og opptaksforvalter, med typene for rollen. Et felt for en rolle brukeren ikke har, viser bare verdien.`
- **Beslutning ved avvik:** Kravet er riktig, skissen er utdatert — fs-admin er bygget etter kravet, med tre felt («Tilbudsgaranti fra behandler/tilbyder/forvalter»). Skissen er blant de eldste rammene i fila. Lenken i scope-fila til skuffen med nedtrekksmenyen for tilbudsgaranti (node `16945:72343`) finnes ikke lenger. Designeren er spurt om en nyere skisse (2026-10-21). Kommer det en lenke, kjøres `fs-specify` på nytt.

## Kodesjekk

- **Sjekket:** fs-plattform `main` (`bcccf964d5`, med STEK-627), fs-admin `main` (`a05c9f696d`, 9 commits bak origin). Verifiseringen 2026-10-21 12:47 (`verify-gi_tilbudsgaranti-2026-10-21-1247.md` ved siden av kravet) fant 13 av 17 scenarioer. STEK-627 er merget etterpå.
- `@OPT-BEH-BEH-010`, sporing: kravet sier at saksbehandlerne ser hvem som har satt og fjernet tilbudsgarantien på søknadsalternativet. Løst i STEK-627 (fs-plattform `0d1241968a`): endringsloggen viser «Behandler satte tilbudsgarantien [type] på [utdanningstilbud]», «… endret …» og «… fjernet tilbudsgarantien på [utdanningstilbud]» (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/TilbudsgarantiEndringstekst.java:31-40`). Fs-admin viser teksten som den er. At loggen skiller endret fra satt, er greit: kravet har ikke et eget scenario for endret.
- `@OPT-BEH-BEH-010`, flytting: kravet sier at tilbudsgarantien fra saksbehandler følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (avklart med domeneekspert 2026-10-21). Koden kopierer bare tilbudsgarantien fra tilbyder og opptaksforvalter (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java:466-481`), og testen `BehandlertildelingServiceIT.omfordelingNullstillerBehandlereidTilstand` sikrer det. Koden skal endres i STEK-626.
- `@OPT-BEH-BEH-010`, typer: fs-admin viser også inaktive tilbudsgarantityper i valglisten, og backend godtar dem (`SettTilbudsgarantitypeService.java:76-86`). Kravet sier ingenting om aktive typer, så det er ikke et avvik. Sjekkes når `fs-verify` kjøres.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/gi_tilbudsgaranti.feature` | `@OPT-BEH-BEH-010 @must @planned @scope-tilbudsgaranti-2027` | `@OPT-BEH-BEH-010 @must @in-progress @scope-tilbudsgaranti-2027` |

## Åpne spørsmål

- [ ] Implementasjonsdetaljer mangler for `gi_tilbudsgaranti.feature` (`gi_tilbudsgaranti.design.md`). Skissen er utdatert, så tekstene må hentes fra kravet og fs-admin. Venter til det er avklart om designeren har en nyere skisse.

## Rute

fs-plattform → fs-admin
