# Spec: Opprette og vedlikeholde opptak

## Kilde

- **Oppgave:** `tasks/opptak/opprette-og-vedlikeholde-opptak/`
- **Kilde-mappe:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/`
- **GitHub:** [#577](https://github.com/sikt-no/fs/issues/577), [#578](https://github.com/sikt-no/fs/issues/578), [#579](https://github.com/sikt-no/fs/issues/579)
- **Hentet:** 2026-09-30 14:14

## Krav

- **`opprett_opptak.feature`** (`@OPT-OVO-GRU-001`) — opptaksforvalter oppretter et opptak (samordnet eller lokalt) med navn, regelverkssamling og opptakstype. Navn angis på bokmål, nynorsk, engelsk og samisk, der bokmål og nynorsk er obligatorisk. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/01%20Opptak/opprett_opptak.feature))

- **`samordnet_opptak.feature`** (`@OPT-OVO-SAM-001`) — opptaksforvalter ved forvaltende organisasjon inviterer læresteder til samordnet opptak, begrenser på lærestedstype, og setter saksbehandlertildelingsregler. Kun forvaltende organisasjon kan endre innstillinger. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/02 Samordning/samordnet_opptak.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/02%20Samordning/samordnet_opptak.feature))

- **`innstillinger.feature`** (`@OPT-OVO-INN-001`) — opptaksforvalter setter innstillinger: opptakstype, regelverkssamling, standard poenglikhetsregel (med mulighet for overstyring per utdanningstilbud), startnummer, maks søknadsalternativer, tak for tilbud per tildelingsrunde, utdanningsbakgrunner, aktivering av tidlig opptak, ledige studieplasser og dokumentasjonsopplasting. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/03%20Innstillinger/innstillinger.feature))

- **`frister_og_hendelser.feature`** (`@OPT-OVO-FRI-001`) — opptaksforvalter ved forvaltende organisasjon setter generelle frister: redigering av utdanningstilbud, søkeperiode, omprioriteringsfrist, sletting av søknadsalternativer, dokumentasjonsfrister, tidlig opptak (søknadsfrist, dokumentasjonsfrist, frist for poenggrenser), ledige studieplasser, frist for endring av utdanningsbakgrunn, og informasjonsdatoer for opptaksresultat (publiseringsdato og første svarfrist). I tillegg: legge til utdanningsbakgrunner med avvikende søknads- og dokumentasjonsfrister. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/04%20Frister/frister_og_hendelser.feature))

### Utenfor scope (`@draft`)

- **`opprett_opptak.feature` — Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak** — venter på: Hva kopieres og hva kopieres ikke?
- **`opprett_opptak.feature` — Regel: Opptaksforvalter kan deaktivere et opptak** — utkast, utsatt til senere iterasjon.

### Relaterte krav som ikke er med (`@draft`)

- `fellestekster.feature` (`@OPT-OVO-TEK-001`, `@wont @draft`) — informasjon til søker i søknadsprosessen
- `svarmeldingsmal.feature` (`@OPT-OVO-TEK-002`, `@wont @draft`) — svarmeldingsmal for opptak
- `hendelseslogg.feature` (`@OPT-OVO-LOG-001`, `@should @draft`) — hendelseslogg for opptak, venter på generell løsning
- `opprette_plasstildelingsrunde.feature` (`@OPT-PLA-RUN-001`, `@draft`) i `krav/02 Opptak/14 Plasstildeling/01 Runder/` — kravet om at første plasstildelingsrunde opprettes fra publiseringsdatoen og første svarfrist

## Skisser

### Skisse: Opprett opptak — hele siden

- **Type:** `figma`
- **Referanse:** <https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20606-117530&m=dev> (`fileKey` `LmoNQlmAuE2FlE0fUo5GoO`, `nodeId` `20606:117530`, siden «Opprett nytt Samordna opptak»)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/screenshot.png), [sub-frames/](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/) (01-informasjon, 02-samordning, 03-innstillinger, 04-frister, 05-utdanningsbakgrunner-avvikende-frister), [design-context.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/design-context.md), [variables.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/variables.md)
- **Dekker krav:** alle fire feature-filer. Seksjonene i skissen mapper til kravfilene:
  - **01 Navn** → `opprett_opptak.feature` (opprette med navn på flere språk)
  - **02 Samordning** → `samordnet_opptak.feature` (invitere organisasjoner)
  - **03 Innstillinger** → `innstillinger.feature` (opptakstype, regelverkssamling, utdanningsbakgrunner, startnummer, poenglikhetsregel m.m.)
  - **04 Generelle frister** → `frister_og_hendelser.feature` (alle fristgrupper)
  - **05 Utdanningsbakgrunner med avvikende frister** → `frister_og_hendelser.feature` (siste regel: legge til utdanningsbakgrunner med egne frister)
- **Valideringsstatus:** `OK` med merknader:
  1. **Navn-seksjonen** sier «Alle felter må fylles», men kravet sier kun bokmål og nynorsk er obligatorisk. Teksten kan bety «alle påkrevde felt» snarere enn «alle fire språk». Ingen blokkerende avvik — avklares i implementasjon.
  2. **«Krav til studierett for å søke»** vises som avkryssingsboks i Innstillinger, men regelen er tagget `@wont` i kravet (ikke relevant for samordna opptak). Designet inkluderer den for fullstendighet. Ikke et avvik — implementasjonen følger MoSCoW-prioriteringen.
  3. **Samordning**: «Utdanninger: N»-badges vises per organisasjon — ekstra informasjon som ikke står i kravene, men som ikke er i konflikt.
  4. **Frister**: Alle grupper og felt i designet samsvarer med kravene. Seksjon 05 (utdanningsbakgrunner med avvikende frister) er ny siden forrige kjøring og matcher regelen i `frister_og_hendelser.feature`.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature` | `@OPT-OVO-GRU-001 @must @planned` | `@OPT-OVO-GRU-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/02 Samordning/samordnet_opptak.feature` | `@OPT-OVO-SAM-001 @must @planned` | `@OPT-OVO-SAM-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature` | `@OPT-OVO-INN-001 @must @planned` | `@OPT-OVO-INN-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature` | `@OPT-OVO-FRI-001 @must @planned` | `@OPT-OVO-FRI-001 @must @in-progress` |

## Endringer etter innhenting

Kravene er `@in-progress`, og endres på stedet. Endringene står her, så den som implementerer, ser dem.

- **2026-10-09, `@OPT-OVO-INN-001`:** Nytt scenario «Sette lenke til informasjon om tidlig opptak» under regelen «Opptaksforvalter kan åpne for tidlig opptak». Opptaksforvalteren setter én lenke per opptak til informasjon om tidlig opptak, og søkerne ser den i Min kompetanse («Les mer»). Kom fra reviewen av PR #654 (oppgaven `tasks/opptak/tidlig-opptak`), og ønsket i STEK-267. Lenken var før beskrevet per utdanningstilbud i `opptaksinnstillinger_utdanningstilbud.feature`. Koden har ikke noe felt for lenken i dag.

## Åpne spørsmål

Ingen åpne spørsmål.
