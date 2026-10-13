# Spørsmål og svar — `fs-specify` (2026-10-13)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Oppgavemappe, Feature-ID og skisser

**Spørsmål:** Spesifikasjonen gjelder automatisk_gsk_konklusjon.feature (#723). Det finnes ingen oppgave for den under tasks/opptak/. Hvilken oppgavemappe skal spesifikasjonen skrives i?

**Alternativer:**
- Ny: automatisk-gsk-konklusjon (Recommended) — tasks/opptak/automatisk-gsk-konklusjon/, tittel «Automatisk GSK-konklusjon», issue #723, eier –, uten scope. Samme navn som branchen.
- Annen ny oppgave — Oppgi domene, slug, tittel og eier under Other.
- Eksisterende oppgave — F.eks. tidlig-opptak eller registrere-praksis. Skriv navnet under Other.

**Svar:** Ny: automatisk-gsk-konklusjon (Recommended)

**Spørsmål:** @OPT-BEH-BEH-009 står også på finne_søknader_om_tidlig_opptak.feature, som tidlig-opptak har hentet inn (@in-progress). Spesifikasjonen, fs-verify og tavla slår opp på Feature-ID. Skal jeg bytte ID-en på GSK-kravet?

**Alternativer:**
- Ja, bytt til 015 (Recommended) — @OPT-BEH-BEH-015 er neste ledige og er ikke brukt noe sted i repoet. GSK-kravet fikk 009 sist (2026-10-13). Bare tag-linja endres, og verify-rapporten fra i dag får samme ID.
- Nei, la stå — Spesifikasjonen skrives med 009, men fs-verify og tavla vil melde duplisert feature-ID til det er rettet.

**Svar:** Ja, bytt til 015 (Recommended)

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spesifikasjonen?

**Alternativer:**
- Ja — Jeg oppgir Figma-lenke(r) eller lokale filer.
- Nei: mest backend — Skrives som «Ingen skisse: automatikken er i fs-plattform; endringene i fs-admin er i GSK-kortet som finnes».
- Nei, annen grunn — Skriv grunnen under Other.

**Svar:** Other

**Fritekst:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?t=uLQ3hi7gkGANbu0f-0

---

## 2. Skisse uten Figma-artefakter, og utløseren for automatikken

**Spørsmål:** Figma-MCP stoppet etter sidelista (grensen for kall på View-setet), og WebFetch får 403. Du har «Saksbehandling sekvens V2» (9840:220112) markert i fila. Hva gjør vi med skissen?

**Alternativer:**
- Registrer uten artefakter (Recommended) — Skissen lenkes med 9840:220112 «Saksbehandling sekvens V2» som ramme, får status Uavklart, og et åpent spørsmål om å kjøre skissesteget på nytt når Figma-kallene er tilbake. Riktig node under Other hvis det er feil ramme.
- Jeg beskriver skissen — Beskriv under Other hva skissen viser for GSK-konklusjonen (kilde, annullering, valgene).
- Stopp, kjør senere — Avslutter nå uten retagging. ID-byttet til 015 og oppgavemappa blir stående.

**Svar:** Registrer uten artefakter (Recommended)

**Spørsmål:** Kravet @OPT-BEH-BEH-015 sier i beskrivelsen at systemet ser etter grunnlag for GSK «når en søknad kommer inn». Koden kjører GSK-automatikken som første steg i den automatiske saksbehandlingen (fs-plattform AutomatiskSaksbehandlingService.java:112-114), og den startes bare av mutasjonen behandleSakAutomatisk (experimental, automatisk-saksbehandling.graphqls:52), fra knappen «Behandle sak automatisk» i fs-admin. Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden endres — Automatikken skal kjøre når søknaden kommer inn, uten knappen. Står under Kodesjekk som noe fs-plattform må vite.
- Ikke et avvik — Scenarioene sier «når søknaden behandles automatisk». Når den automatiske saksbehandlingen starter, er utenfor kravet. Står som informasjon under Kodesjekk.
- Kravet må endres — Kravet holdes tilbake som @planned, og avviket blir et spørsmål for fs-krav.
- Vet ikke — Som «Kravet må endres»: kravet holdes tilbake.

**Svar:** Ikke et avvik

---

## 3. Vitnemål og kompetansebevis

**Spørsmål:** Kravet @OPT-BEH-BEH-015 sier at søknaden får positiv konklusjon når søkeren har ett vitnemål som ikke er annullert («Vitnemål som gir generell studiekompetanse»). Koden krever at søkeren har nøyaktig ett VGS-dokument som ikke er annullert, og at det er et vitnemål (fs-plattform GskVedtakAutoService.java:77-83). Har søkeren også et kompetansebevis, blir det ingen konklusjon. Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden endres — Ett vitnemål gir konklusjon også når søkeren har kompetansebevis i tillegg. Står under Kodesjekk som noe fs-plattform må vite.
- Kravet må endres — F.eks. «vitnemålet er søkerens eneste dokument». Kravet holdes tilbake som @planned til fs-krav har rettet det.
- Vet ikke — Som «Kravet må endres»: kravet holdes tilbake.

**Svar:** Kravet er riktig, koden endres

---

## 4. Avsluttet opptak

**Spørsmål:** Kravet @OPT-BEH-BEH-015 bruker «avsluttet opptak»: konklusjoner i avsluttede opptak trekkes ikke tilbake, og gjenbruk ser på konklusjoner fra avsluttede opptak. Koden har ikke noe slikt begrep: opptaksstatus er PUBLISERT, UPUBLISERT eller ARKIVERT (fs-plattform V280__opptak_v2_skjema.sql:1583-1586), og ingen opptakshendelse heter avsluttet. Hva skal vi gjøre?

**Alternativer:**
- Avsluttet betyr ARKIVERT — Kravet er riktig. Under Kodesjekk står det at avsluttet opptak er opptak med status ARKIVERT.
- Kravet er riktig, koden må få begrepet — fs-plattform må avgjøre hva et avsluttet opptak er (status, dato eller hendelse). Står under Kodesjekk.
- Kravet må presiseres — Kravet holdes tilbake som @planned til fs-krav har sagt hva avsluttet betyr.
- Vet ikke — Som «Kravet må presiseres»: kravet holdes tilbake.

**Svar:** Avsluttet betyr ARKIVERT

---

## 5. Implementasjonsdetaljer og omfang

**Spørsmål:** Kravet har skjermbilder i fs-admin (bare positive valg, annullering, hva konklusjonen bygger på), men det finnes ingen automatisk_gsk_konklusjon.design.md. fs-implementasjonsdetaljer henter tekstene fra skissen, og den kan jeg ikke lese nå. Skal jeg kjøre den nå?

**Alternativer:**
- Vent (Recommended) — Står under Åpne spørsmål: «Implementasjonsdetaljer mangler», kjøres sammen med skissesteget når Figma-kallene er tilbake.
- Kjør nå uten skisse — fs-implementasjonsdetaljer skriver design.md fra kravet og GSK-kortet som finnes, og spør deg om tekstene.

**Svar:** Vent (Recommended)

**Spørsmål:** Forslag til Omfang: «Spesifikasjonen dekker automatisk GSK-konklusjon på søknaden: positiv konklusjon fra vitnemålet eller gjenbrukt fra et tidligere opptak, at automatikken bare setter positive konklusjoner der ingen finnes, saksbehandlerens endringer, ny vurdering ved nytt vitnemål, tilbakekalling når vitnemålet annulleres, og at saksbehandleren ser hva konklusjonen bygger på. Vitnemålsveien og manuell endring finnes; gjenbruk, ny vurdering ved nytt vitnemål, sjekken av arkiverte opptak og visningen i fs-admin mangler. Gjenbruk fra FS-klienten og oppdagelse av annullering uten søknadshendelse venter på åpne spørsmål. Det søkeren ser, er ikke med.» Stemmer det?

**Alternativer:**
- Stemmer — Teksten brukes som den er.
- Endre — Skriv teksten du vil ha under Other.

**Svar:** Stemmer

---

## 6. Videre

**Spørsmål:** Spesifikasjonen er skrevet, med 6 åpne spørsmål. Vil du gå gjennom dem nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Ett om gangen. Beslutningen skrives ved spørsmålet i spesifikasjonen, og det merkes [x].
- Stopp her — Avslutter med en oppsummering.

**Svar:** Stopp her

---
