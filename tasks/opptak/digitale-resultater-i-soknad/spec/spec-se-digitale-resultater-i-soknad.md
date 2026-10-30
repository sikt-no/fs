# Spec: Se digitale resultater i søknaden

## Kilde

- **Oppgave:** `tasks/opptak/digitale-resultater-i-soknad/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/`
- **Scope:** scope-digitale-resultater-i-soknad
- **GitHub:** [#604](https://github.com/sikt-no/fs/issues/604)
- **Hentet:** `2026-10-14 16:01`

## Omfang

Søkeren ser i steget «Dokumentasjon» i søknadsflyten i Min kompetanse hvilke digitale resultater systemet allerede har om hen, før opplastingen. Resultatene grupperes på utdanningsnivå, med tittel, utsteder, semester og kompetansen eller graden vitnemålet gir, og merkelappen «Hentet automatisk». «Enkeltemner» er lukket som standard, og vises ikke når søkeren ikke har enkeltemner. Søkeren uten resultater, eller der hentingen feiler, får én samlet forklaring. Spesifikasjonen dekker ikke hva søkeren må laste opp (`@OPT-SØK-SØK-003`, #572), resultatvisningen i Min kompetanse, eller et resultat der bare utstederen er kjent (`@draft`).

## Krav

- **`se_digitale_resultater_i_søknad.feature`** (`@OPT-SØK-SØK-004`) — søkeren ser de digitale resultatene i steget «Dokumentasjon» i søknaden. ([krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_digitale_resultater_i_søknad.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_digitale_resultater_i_s%C3%B8knad.feature))

### Endringer etter at kravet ble hentet inn

- **2026-10-15:** nytt scenario `Andre resultater vises ikke uten andre resultater`. Har søkeren bare vitnemål og grader, vises ikke «Andre resultater» i steget, heller ikke som en tom accordion. Implementasjonsdetaljene er oppdatert.
- **2026-10-26:** «Andre resultater» heter nå «Enkeltemner», og viser bare enkeltemner, ikke øvrig dokumentasjon. Scenarioene heter `Enkeltemner er lukket som standard`, `Se enkeltemnene` (med tittel, utsteder og semester) og `Enkeltemner vises ikke når søkeren ikke har enkeltemner`. Skissen (node `3920:14210`) viser kortet åpnet (node `4931:4291`), og implementasjonsdetaljene er oppdatert. Artefaktene i `krav-input/` er fra før endringen.
- **2026-10-26:** vitnemål vises med semester, ikke utstedelsesdato (`Se opplysninger om et resultat`). Kodesjekken om `GradRad.utstedtDato` under er derfor ikke lenger relevant for visningen. Implementasjonsdetaljene er oppdatert.

### Utenfor scope (`@draft`)

- **`se_digitale_resultater_i_søknad.feature` — scenario `Se et resultat der bare utstederen er kjent`** — venter på: Hvilke opplysninger vet vi alltid om et resultat: utsteder og utdanningsnivå, eller mer? (Kodesjekken: et lærested som feilet, ligger i dag som `KompetanseFeil` med bare studiestedet, ikke som en `Kompetanse`-rad. Se *Kodesjekk*.)

## Skisser

### Skisse: Konsept dokumentopplastning

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=3920-14210
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/konsept-dokumentopplastning/screenshot.png), [sub-frames/](krav-input/sketches/figma/konsept-dokumentopplastning/sub-frames/), [design-context.md](krav-input/sketches/figma/konsept-dokumentopplastning/design-context.md), [variables.md](krav-input/sketches/figma/konsept-dokumentopplastning/variables.md)
- **Dekker krav:** `se_digitale_resultater_i_søknad.feature` (alle scenarioene i regelen, unntatt manglende resultater og «Andre resultater» åpnet)
- **Valideringsstatus:** `Avvik: skissen kaller steget «3. Last opp dokumentasjon», koden og kravet «Dokumentasjon». Skissen mangler «Andre resultater» åpnet.`
- **Beslutning ved avvik:** stegnavnet: kravet er rettet til «Dokumentasjon» (se *Kodesjekk*). «Andre resultater» åpnet: kravene er riktige, og tilstanden er et åpent designspørsmål i implementasjonsdetaljene.

### Skisse: Konsept dokumentopplastning, ingen resultater

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=4401-18141
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/konsept-dokumentopplastning-ingen-resultater/screenshot.png), [design-context.md](krav-input/sketches/figma/konsept-dokumentopplastning-ingen-resultater/design-context.md)
- **Dekker krav:** `se_digitale_resultater_i_søknad.feature` (scenariomal: `Samme forklaring vises uansett årsak til manglende resultater`)
- **Valideringsstatus:** `Avvik: kravet sier at søkeren får vite at all dokumentasjon må lastes opp manuelt, skissen at søkeren kan laste opp resultater som ikke vises, eller kontakte lærestedet.`
- **Beslutning ved avvik:** begge er riktige — samme budskap med ulik ordlyd. Teksten står ordrett fra skissen i implementasjonsdetaljene.

### Skisse: Resultat der bare utstederen er kjent

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=4274-43654
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/resultat-der-bare-utstederen-er-kjent/screenshot.png), [design-context.md](krav-input/sketches/figma/resultat-der-bare-utstederen-er-kjent/design-context.md)
- **Dekker krav:** `se_digitale_resultater_i_søknad.feature` (scenario: `Se et resultat der bare utstederen er kjent`, `@draft`, utenfor scope)
- **Valideringsstatus:** `OK`

## Implementasjonsdetaljer

- **`se_digitale_resultater_i_søknad.feature`** — [se_digitale_resultater_i_søknad.design.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_digitale_resultater_i_s%C3%B8knad.design.md) (3 åpne designspørsmål)

## Kodesjekk

- **Sjekket:** min-kompetanse (`7d0e6ccf`), fs-plattform (`313ea12bb5`), begge på oppdatert `main`
- `@OPT-SØK-SØK-004`: kravet sa steget «Last opp dokumentasjon», koden kaller steg 3 «Dokumentasjon» (`min-kompetanse/messages/files/nb.json:99`, `:180`). Kravet er rettet til «Dokumentasjon» før retaggingen.
- `@OPT-SØK-SØK-004`: steget viser ingen resultater i dag. Siden har bare `ChecklistSection` og `UploadSection` (`min-kompetanse/src/components/soknad-dokumentasjon/soknad-dokumentasjon-step-page.tsx:25-28`), og queryen henter ingen kompetansedata (`query-soknad-dokumentasjon-step-page.ts:10-32`). Koden skal endres.
- `@OPT-SØK-SØK-004`: resultatvisningen på «Mine resultater» (`min-kompetanse/src/app/[locale]/resultater/mine-resultater/mine-resultater.tsx:57-70`) viser høyere utdanning før videregående. Kravet vil ha videregående først. Gjelder gjenbruk av komponenten.
- `@OPT-SØK-SØK-004`: ved feil viser «Mine resultater» en egen seksjon, «Resultater vi ikke fikk hentet» (`mine-resultater.tsx:71-79`). Kravet vil ha én samlet forklaring når hentingen feiler. Gjelder gjenbruk av komponenten.
- `@OPT-SØK-SØK-004`: kompetansen et videregående vitnemål gir, hentes i dag fra det utfasede `studiekompetanseNotat` (`min-kompetanse/src/app/[locale]/resultater/_queries/mine-kompetanser-query.ts:165`). Schemaet har `VideregaendeGradInfo.studiekompetanseNotater` (GSK, YRKESKOMPETANSE, FAGOPPLAERING) (`fs-plattform/kompetanse/kompetanse-subgraph/src/main/resources/schema/features/experimental/schema.graphql:524-526`).
- `@OPT-SØK-SØK-004`: utstedelsesdato for høyere utdanning finnes i schemaet (`GradRad.utstedtDato`, `schema.graphql:487`), men hentes ikke i dag. Det finnes ikke noe eget «grad»-felt; det nærmeste er `tittel` og `studieprogram`.
- **Begreper:** kravets «resultat», «utsteder», «vitnemål/grad» og «enkeltemner» heter `Kompetanse`, `studiested`, `grader` (`GradRad`) og `kurs` (`KursRad`) i schemaet. «Andre resultater» finnes i fs-plattform bare som gruppen `NO_GROUP` for kurs uten gruppe (`fs-plattform/kompetanse/kompetanse-worker/src/main/java/no/sikt/kompetanse/view/Categories.java:34`), med en annen betydning.
- **Schema:** hele kompetansemodellen ligger i experimental-schemaet, ikke i stable (`schema/features/experimental/schema.graphql`).

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/01 Søknad/se_digitale_resultater_i_søknad.feature` | `@OPT-SØK-SØK-004 @must @planned @scope-digitale-resultater-i-soknad` | `@OPT-SØK-SØK-004 @must @in-progress @scope-digitale-resultater-i-soknad` |

Scenarioet `Se et resultat der bare utstederen er kjent` beholder `@draft @openquestion`.

## Åpne spørsmål

Ingen kravspørsmål. Designspørsmålene står i implementasjonsdetaljene, og `@draft`-scenarioet under *Utenfor scope*.

## Rute

min-kompetanse

Visningen er i min-kompetanse, og kompetansedataene finnes allerede i kompetanse-subgrafen. Trengs det endringer i schemaet (f.eks. at kompetansemodellen flyttes til stable), blir ruta `fs-plattform → min-kompetanse`.
