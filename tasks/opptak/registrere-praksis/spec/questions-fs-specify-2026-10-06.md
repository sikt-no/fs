# Spørsmål og svar — `fs-specify` (2026-10-06)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Oppgavemappe

**Spørsmål:** Hvilken oppgavemappe skal spesifikasjonen skrives i?

**Alternativer:**
- opptak/registrere-praksis (Recommended) — Gjenopprett slugen fra den slettede kjøringen: tasks/opptak/registrere-praksis/spec/. oppgave.md lages med fs-oppgave.
- Annen ny oppgave — Oppgi domene og slug selv.
- Eksisterende oppgave i opptak — F.eks. opprette-og-vedlikeholde-opptak, plasstildeling, regelverk, utdanningstilbud, vedtaksformidling.

**Svar:** opptak/registrere-praksis (Recommended)

---

## 2. Finnes det skisser?

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?

**Alternativer:**
- Ja — Jeg oppgir Figma-lenke(r) eller lokale filer.
- Nei — Ingen skisse. Jeg spør om grunnen.

**Svar:** Ja

---

## 3. Skissetype

**Spørsmål:** Hva slags skisser er det? Lim inn lenken eller stien under «Other» hvis det er enklest.

**Alternativer:**
- Figma-lenke(r) — Hentes og lagres via Figma MCP.
- Lokal fil (bilde/PDF) — Kopieres til krav-input/sketches/.
- Begge — Både Figma og lokale filer.

**Svar:** Figma-lenke(r)

Lenke oppgitt i chat: https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803&m=dev

---

## 4. Avvik 1: feilmelding under omfangsfeltet

**Spørsmål:** Avvik 1 av 4: I skissen «Nyeste skisser» (05, ugyldig dato) står feilmeldingen «Oppgi en gyldig dato, for eksempel 01.07.2022.» under feltet «Omfang (Stillingsprosent)». Kravet «Stillingsprosent utenfor 0–100 % kan ikke lagres» sier at feilmeldingen skal være at stillingsprosenten må være mellom 0 og 100 %. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert eller har en kopifeil. Teksten for stillingsprosent tas inn i implementasjonsdetaljene.
- Skissen er riktig — Kravene mangler noe. Blir et åpent spørsmål for fs-krav.
- Begge riktige, ulikt scope — Skissen viser noe annet enn kravet.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Skissen er riktig

---

## 5. Avvik 2: timevarianten er ikke skissert

**Spørsmål:** Avvik 2 av 4: Skissen viser bare dialogen med «Stillingsprosent» valgt. Varianten «Timer i perioden» er ikke skissert. Kravet har felt for antall timer og antall timer per årsverk (forhåndsutfylt 1 650), og feilmeldinger for manglende timer, 0 eller færre timer, og timer som gir mer praksis enn kalendertiden. Hva skal vi gjøre?

**Alternativer:**
- Begge riktige, ulikt scope — Skissen dekker bare stillingsprosent. Timevarianten bygges fra kravet og implementasjonsdetaljene.
- Kravene er riktige — Skissen er ufullstendig/utdatert. Kravet gjelder.
- Skissen er riktig — Kravene mangler noe. Blir et åpent spørsmål for fs-krav.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 6. Avvik 3: «Oppgitt relevant praksis»

**Spørsmål:** Avvik 3 av 4: Summkortet i skissen heter «Oppgitt relevant praksis». Kravet bruker «sum av oppgitte perioder», og markeringen heter «Inkluder», ikke «relevant», etter endringen 02.10.2026. Det andre kortet, «Justert for overlapp», stemmer. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen bruker det gamle ordet. Ledeteksten avklares i implementasjonsdetaljene (f.eks. «Oppgitt praksis»).
- Skissen er riktig — «Oppgitt relevant praksis» beholdes. Åpent spørsmål for fs-krav om terminologien.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 7. Avvik 4: egen side, ikke på saken

**Spørsmål:** Avvik 4 av 4: Skissen viser praksiskalkulatoren som en egen side, «Praksiskalkulator», med brødsmuler til opptaket («Samordna opptak 2025»). Den viser ikke hvilken søker eller sak praksisen gjelder. Ifølge kravet hører praksisperiodene til saken (Bakgrunn: «jeg behandler en sak på søknaden til en søker»), og fs-admin har allerede saksvisningen opptak/[id]/soknadsbehandling/sak/[sakId]. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Kalkulatoren hører til saken. Plassering i saksvisningen avklares i implementasjonsdetaljene.
- Begge riktige, ulikt scope — Skissen viser bare innholdet, ikke plasseringen. Kravet gjelder for tilknytningen til saken.
- Skissen er riktig — Kravene mangler noe. Åpent spørsmål for fs-krav.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Skissen er riktig

---

## 8. Kodesjekk: rollenavn

**Spørsmål:** Kodesjekk: kravet `@OPT-BEH-BEH-003` sier at bare brukere med rollen «opptakssaksbehandler» kan registrere og se praksis. Koden har ingen slik rolle. I opptak heter rollen «Søknadsbehandler» (`SØKNADSBEHANDLER`, fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V12__tilgangskontroll_grunndata.sql:65), og fs-admin har `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` (fs-admin/src/common/types/generated/tilgangsroller.ts:67). Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig — Koden skal endres. Kravet hentes inn, og avviket står under Kodesjekk for kode-repoene.
- Kravet må endres — Kravet retagges ikke og blir stående som @planned. Rollenavnet rettes med fs-krav først.
- Vet ikke — Som «Kravet må endres»: holdes tilbake til det er avklart.

**Svar:** Kravet må endres

---

## 9. Status for et krav som allerede er @in-progress

**Spørsmål:** @OPT-BEH-BEH-003 står allerede som @in-progress (satt 24.09, men den spec-en er slettet). Nå holdes kravet tilbake fordi rollenavnet må endres. Hva skal skje med taggen?

**Alternativer:**
- Sett tilbake til @planned (Recommended) — Samsvarer med at kravet holdes tilbake. Kravet kan da endres på stedet med fs-krav, og fs-specify kjøres på nytt etterpå.
- La stå som @in-progress — Kravet regnes som hentet inn. Endringen av rollenavnet noteres i spesifikasjonen, slik README sier for @in-progress-krav som endres.

**Svar:** Sett tilbake til @planned (Recommended)

---

## 10. Implementasjonsdetaljer

**Spørsmål:** Implementasjonsdetaljene (registrere_praksis.design.md) mangler. Skal jeg kjøre fs-implementasjonsdetaljer nå med skissene, eller skal det vente til rollenavnet og de åpne spørsmålene er avklart?

**Alternativer:**
- Vent (Recommended) — Kravet holdes uansett tilbake. Noteres som åpent spørsmål, og kjøres når fs-specify kjøres på nytt.
- Kjør nå — Starter fs-implementasjonsdetaljer for registrere_praksis.feature med skissene fra denne kjøringen.

**Svar:** Kjør nå

---

## 11. Tekster i implementasjonsdetaljene (fs-implementasjonsdetaljer)

Fire spørsmål i ett kall.

**Spørsmål:** Overlappsvarselet i skissen er: «Du har to perioder som overlapper med et samlet omfang >100% (01.07.2022–31.12.2022). Omfang over 100% blir ikke tatt med i beregningen.» Kravet varsler også overlapp som til sammen er 100 % eller mindre («Overlappende praksisperioder varsles»). Hvilken tekst skal brukes da?

**Alternativer:**
- Foreslått tekst — «Du har {antall} perioder som overlapper ({fra}–{til}).», og varianten over når summen er over 100 %. {antall} skrives med bokstaver (to, tre …).
- La stå åpen — Noteres under Åpne designspørsmål.

**Svar:** Foreslått tekst

**Spørsmål:** Summkortet «Oppgitt relevant praksis» skal ikke bruke «relevant» (beslutning 3). Hva skal kortet hete?

**Alternativer:**
- «Oppgitt praksis» — Kort, og passer med «Justert for overlapp».
- «Sum av oppgitte perioder» — Samme ordlyd som kravet.
- La stå åpen — Noteres under Åpne designspørsmål.

**Svar:** «Sum av oppgitte perioder»

**Spørsmål:** Ingen skisse viser feilmeldingen for stillingsprosent utenfor 0–100 % («Stillingsprosent utenfor 0–100 % kan ikke lagres»). Hvilken tekst skal brukes?

**Alternativer:**
- Foreslått tekst — «Oppgi en stillingsprosent fra 0 til 100.»
- La stå åpen — Henger sammen med åpent spørsmål 1 om feilmeldingen under omfangsfeltet.

**Svar:** La stå åpen

**Spørsmål:** Ingen skisse viser feilmeldingene for timer. Hvilke tekster skal brukes?

**Alternativer:**
- Foreslåtte tekster — Mangler: «Oppgi antall timer i perioden.» • 0 eller mindre: «Antall timer må være mer enn 0.» • For mange: «Antall timer kan ikke gi mer praksis enn perioden fra startdato til sluttdato.»
- La stå åpen — Noteres under Åpne designspørsmål.

**Svar:** Foreslåtte tekster

---

## 12. Etter spec-en

**Spørsmål:** Spesifikasjonen er skrevet. Den er ikke klar til utvikling: kravet er holdt tilbake, og det er tre åpne spørsmål. Hva vil du gjøre nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Ett om gangen, med beslutning og begrunnelse.
- Stopp her — Avslutt med en oppsummering.

**Svar:** Gå gjennom åpne spørsmål

---

## 13. Åpent spørsmål 1: rollenavn

**Spørsmål:** Åpent spørsmål 1 av 3: Kravet bruker rollen «opptakssaksbehandler», mens koden har «Søknadsbehandler» (SØKNADSBEHANDLER i opptak, FS-ADMIN_OPPTAK_SØKNADSBEHANDLER i fs-admin). Hva skal rollen hete i kravet?

**Alternativer:**
- «søknadsbehandler» — Kravet bruker rollenavnet fra koden. Rettes med fs-krav i registrere_praksis.feature (og i oppfølgingskommentaren).
- Vet ikke ennå — Spørsmålet står åpent. Kravet holdes tilbake.

**Svar:** «søknadsbehandler»

---

## 14. Åpent spørsmål 2: feilmelding under omfangsfeltet

**Spørsmål:** Åpent spørsmål 2 av 3: Skisse 05 viser «Oppgi en gyldig dato, for eksempel 01.07.2022.» under omfangsfeltet (Stillingsprosent), og du sa at skissen er riktig. Hva betyr det for kravet?

**Alternativer:**
- Kopifeil i skissen — Kravet gjelder (0–100 %). Teksten avklares i implementasjonsdetaljene, f.eks. «Oppgi en stillingsprosent fra 0 til 100.»
- Nytt krav: ugyldig verdi — Kravet mangler et scenario for ugyldig verdi i omfangsfeltet (f.eks. bokstaver). Legges inn med fs-krav.
- Vet ikke ennå — Spørsmålet står åpent.

**Svar:** Kopifeil i skissen

---

## 15. Tekst for stillingsprosent og åpent spørsmål 3: egen side

To spørsmål i ett kall.

**Spørsmål:** Skal feilmeldingen for stillingsprosent utenfor 0–100 % være «Oppgi en stillingsprosent fra 0 til 100.»?

**Alternativer:**
- Ja — Legges inn i Tekster i registrere_praksis.design.md.
- La stå åpen — Teksten står som åpent designspørsmål.

**Svar:** Ja

**Spørsmål:** Åpent spørsmål 3 av 3: Skissen viser praksiskalkulatoren som en egen side med brødsmuler til opptaket, uten søker eller sak. Kravet sier at praksisperiodene hører til saken. Hvordan henger det sammen?

**Alternativer:**
- Egen side, åpnes fra saken — Kalkulatoren er en egen side for én sak, og åpnes fra saksvisningen. Siden viser hvilken søker og sak den gjelder. Kravet står, og det noteres i implementasjonsdetaljene.
- Fane/del av saksvisningen — Kalkulatoren ligger i saksvisningen (som Grunnlag, Poengberegning). Skissen viser bare innholdet.
- Vet ikke ennå — Spørsmålet står åpent.

**Svar:** Egen side, åpnes fra saken

---
