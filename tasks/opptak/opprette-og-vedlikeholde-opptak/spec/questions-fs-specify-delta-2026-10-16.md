# Spørsmål og svar — `fs-specify-delta` (2026-10-16)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Kodekloner bak origin/main

**Spørsmål:** Kodeklonene er bak origin/main (fs-admin 4, fs-plattform 32, min-kompetanse 3 commits). Skal jeg hente med git pull --ff-only før kodesjekken (og verifiseringen etterpå)?

**Alternativer:**
- Ja, hent alle tre (Recommended) — git pull --ff-only i fs-admin, fs-plattform og min-kompetanse
- Nei, bruk dem som de er — Kodesjekken og verifiseringen ser ikke de siste commitene

**Svar:** Ja, hent alle tre (Recommended)

---

## 2. Skisser

**Spørsmål:** Finnes det nye skisser for endringene, eller holder skissene som allerede står i spesifikasjonene (Figma «Opprett opptak» og «Min kompetanse – tidlig opptak»)?

**Alternativer:**
- Bruk de eksisterende (Recommended) — Delta-spec-ene lenker til skissene i spec-ene, ingen ny henting
- Ja, nye skisser — Jeg sender lenke eller fil
- Ingen skisse — Endringene er regler uten ny UI

**Svar:** Ja, nye skisser

---

## 3. Skisseavvik: lenke til informasjon om tidlig opptak

**Spørsmål:** Skissen «Opprett opptak» ser ut til å avvike fra kravene: innstillinger.feature krever at lenken til informasjon om tidlig opptak må være satt når tidlig opptak er aktivert (én lenke for alle språk), men skissen har ikke noe felt for lenken. Den har bare avkrysningen «Kan søke på tidlig opptak». Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, skissen er utdatert — Skissen markeres som utdatert for lenken. Utviklerne bygger feltet fra kravet og implementasjonsdetaljene.
- Skissen er riktig, kravet mangler — Åpent spørsmål for fs-krav
- Ulikt scope — Lenken skal stå et annet sted enn i skissen, f.eks. i et eget panel. Skissen dekker ikke hele kravet.
- Vet ikke — Åpent spørsmål uten beslutning

**Svar:** Kravet er riktig, skissen er utdatert

---

## 4. Kodeavvik (fire spørsmål i ett kall)

**Spørsmål 1:** Kravet @OPT-OVO-INN-001 sier at søker og saksbehandler bare ser løpenummeret, ikke opptakskoden (Q18). Koden lager søknadskoden {opptakKode}-{søknadsnummer} (fs-plattform opptak-service/.../soknad/Soknadskode.java:9-17), og startnummeret leses ikke (nummeret kommer fra SOKNADSNUMMER_SEQ). Hva skal vi gjøre?

**Svar:** Vet ikke

**Spørsmål 2:** Den nye regelen i @OPT-OVO-FRI-001 sier at en frist for når noe stenger, ikke begrenser handlingen når den ikke er satt. Koden stenger når SØKNADSFRIST_ORDINÆR eller FRIST_ETTERSENDING mangler, og kaster «Opptak mangler frist for …» (fs-plattform Opptaksfrister.java:160-171). Hva skal vi gjøre?

**Svar:** Kravet er riktig

**Spørsmål 3:** Kravet @OPT-OVO-INN-001 sier at søkerne kan laste opp dokumentasjon som standard, og at innstillingen alltid har en verdi (Q1). Koden har kanLasteOppDokumenter nullable. fs-admin bruker false for et nytt opptak (utils/emptyObjectGenerators.ts:26), og ingen kode leser flagget. Hva skal vi gjøre?

**Svar:** Kravet er riktig

**Spørsmål 4:** Kravet @OPT-OVO-FRI-001 sier at bare søknadsfristen og dokumentasjonsfristen kan overstyres per utdanningsbakgrunn (Q9). fs-admin følger det, men backend godtar enhver hendelsestype (fs-plattform HendelseInputValidering.java:29-41, OpptakUtdanningsbakgrunner.java:42-45). Hva skal vi gjøre?

**Svar:** Kravet er riktig

**Alternativer (alle fire):**
- Kravet er riktig — Koden skal endres. Avviket står under Kodesjekk.
- Kravet må endres — Åpent spørsmål for fs-krav
- Vet ikke — Åpent spørsmål

---

## 5. Implementasjonsdetaljer

**Spørsmål:** innstillinger.feature og frister_og_hendelser.feature har ingen implementasjonsdetaljer (.design.md), og endringen har nye tekster: «lenken til informasjon om tidlig opptak må være satt», «søkere har valgt utdanningsbakgrunnen» og informasjonen om den ordinære dokumentasjonsfristen. Skal jeg kjøre fs-implementasjonsdetaljer nå?

**Alternativer:**
- Vent, legg det under åpne spørsmål (Recommended) — Delta-spec-ene skrives nå, og verifiseringen kan kjøres etterpå. Det samme ble gjort i tidlig opptak 08.10.
- Kjør nå — fs-implementasjonsdetaljer for begge filene, én om gangen, med skissen fra i dag

**Svar:** Vent, legg det under åpne spørsmål (Recommended)

---

## 6. Etter delta-spec-en

**Spørsmål:** Delta-spec-ene er skrevet. Det står to åpne spørsmål i opprette-og-vedlikeholde-opptak: søknadsnummeret (Q18 mot koden) og implementasjonsdetaljene, som venter. Hva vil du gjøre nå?

**Alternativer:**
- Verifiser Opptak nå (Recommended) — Stopp her og kjør fs-verify-agent-teams på de 10 @in-progress-filene i krav/02 Opptak. Søknadsnummeret blir stående åpent.
- Gå gjennom åpne spørsmål — Søknadsnummeret først, én om gangen, og så verifisering
- Stopp her — Ingen verifisering nå

**Svar:** Verifiser Opptak nå (Recommended)

---
