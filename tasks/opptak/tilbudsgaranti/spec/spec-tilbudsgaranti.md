# Spec: Tilbudsgaranti

## Kilde

- **Oppgave:** `tasks/opptak/tilbudsgaranti/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling`
- **Scope:** scope-tilbudsgaranti-2027
- **GitHub:** [#512](https://github.com/sikt-no/fs/issues/512)
- **Hentet:** `2026-10-22 08:46`

## Omfang

Saksbehandler, tilbyder og opptaksforvalter setter, endrer og fjerner tilbudsgaranti på et søknadsalternativ, hver i sitt felt og med tilbudsgarantitypene opptaket har for rollen. Saksbehandlerne ser tilbudsgarantiene fra alle rollene, og i endringsloggen hvem som har satt og fjernet dem, og på hvilket søknadsalternativ. Tilbudsgarantien følger søknadsalternativet når prioriteten endres og når det flyttes til en annen saksbehandlende organisasjon, faller bort når søknadsalternativet fjernes, og gjelder igjen når det legges inn igjen. Spesifikasjonen dekker ikke tidligopptaket (`@OPT-BEH-BEH-007`), hvordan plasstildelingen gir tilbud (`@OPT-PLA-TIL-002`), eller forvaltning av tilbudsgarantitypene (typene legges inn i databasen per opptak).

## Krav

- **`gi_tilbudsgaranti.feature`** (`@OPT-BEH-BEH-010`) — manuell tilbudsgaranti fra saksbehandler, tilbyder og opptaksforvalter, sporing i endringsloggen, og at tilbudsgarantien følger søknadsalternativet. ([krav/…/gi_tilbudsgaranti.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature))

## Skisser

### Skisse: Skuffen, fanen «Søknadsalternativ»

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=9348-84214 (fra designeren 2026-10-22)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/skuff-soknadsalternativ/screenshot.png), [design-context.md](krav-input/sketches/figma/skuff-soknadsalternativ/design-context.md)
- **Dekker krav:** `gi_tilbudsgaranti.feature` (regelen «Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt»)
  - 1. Biologi: tilbudsgaranti brukeren kan sette og endre, som nedtrekksmeny («Tilbudsgaranti», verdien «KLA»).
  - 2. Informatikk: tilbudsgaranti brukeren ikke kan endre, som tekst («TILBUDSGARANTI», «FOR», «UiB, 12. april 2026 (12:03)»).
- **Valideringsstatus:** `Avvik: skissen viser én tilbudsgaranti per søknadsalternativ, for en bruker med én rolle. Kravet har tre felt, ett for saksbehandler, tilbyder og opptaksforvalter, og fs-admin viser ett felt per rolle når brukeren har flere roller. Skissen viser organisasjonen og tidspunktet der kravet og fs-admin viser rollen, og typen som kode («KLA», «FOR»).`
- **Beslutning ved avvik:** Begge er riktige, ulikt scope — skissen viser hvordan tilbudsgarantien ser ut for en bruker med én rolle. Den dekker ikke en bruker med flere roller, eller flere tilbudsgarantier på samme søknadsalternativ. Kravet står som det er. Om teksten viser organisasjon og tidspunkt eller rolle, og kode eller navn på typen, hører til implementasjonsdetaljene. Erstatter skissen «Søknadsalternativ i saksbehandlingen» (Figma `9840:223140`), som var utdatert.

## Kodesjekk

- **Sjekket:** fs-plattform `main` (`bcccf964d5`, med STEK-627), fs-admin `main` (`a05c9f696d`, 9 commits bak origin). Verifiseringen 2026-10-21 12:47 (`verify-gi_tilbudsgaranti-2026-10-21-1247.md` ved siden av kravet) fant 13 av 17 scenarioer. STEK-627 er merget etterpå.
- `@OPT-BEH-BEH-010`, sporing: kravet sier at saksbehandlerne ser hvem som har satt og fjernet tilbudsgarantien på søknadsalternativet. Løst i STEK-627 (fs-plattform `0d1241968a`): endringsloggen viser «Behandler satte tilbudsgarantien [type] på [utdanningstilbud]», «… endret …» og «… fjernet tilbudsgarantien på [utdanningstilbud]» (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/TilbudsgarantiEndringstekst.java:31-40`). Fs-admin viser teksten som den er. At loggen skiller endret fra satt, er greit: kravet har ikke et eget scenario for endret.
- `@OPT-BEH-BEH-010`, flytting: kravet sier at tilbudsgarantien fra saksbehandler følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (avklart med domeneekspert 2026-10-21). Koden kopierer bare tilbudsgarantien fra tilbyder og opptaksforvalter (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java:466-481`), og testen `BehandlertildelingServiceIT.omfordelingNullstillerBehandlereidTilstand` sikrer det. Koden skal endres i STEK-626.
- `@OPT-BEH-BEH-010`, typer: fs-admin viser også inaktive tilbudsgarantityper i valglisten, og backend godtar dem (`SettTilbudsgarantitypeService.java:76-86`). Kravet sier ingenting om aktive typer, så det er ikke et avvik. Sjekkes når `fs-verify` kjøres.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/gi_tilbudsgaranti.feature` | `@OPT-BEH-BEH-010 @must @planned @scope-tilbudsgaranti-2027` | `@OPT-BEH-BEH-010 @must @in-progress @scope-tilbudsgaranti-2027` |

Retagget 2026-10-21. Kjøringen 2026-10-22 (ny skisse) fant kravet `@in-progress` fra før, og retagget ikke.

## Åpne spørsmål

- [ ] Implementasjonsdetaljer mangler for `gi_tilbudsgaranti.feature` (`gi_tilbudsgaranti.design.md`). Tekstene står i den nye skissen og i fs-admin. Koden er levert, så de venter til før testcasene lages (2026-10-22).

## Rute

fs-plattform → fs-admin
