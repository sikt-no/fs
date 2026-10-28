# Brukertest med HK-dir: plasstildeling

Notatene fra to brukertester med HK-dir (oktober 2026), sortert og sett opp mot kravene i `krav/02 Opptak/14 Plasstildeling`, `krav/02 Opptak/10 Regelverk/06 Rundetyper` og `krav/_kravanalyser/hk-dir-krav-dekning.md`.

## 1. Funksjonalitet

### Bekrefter kravene

| Tilbakemelding | Krav |
|---|---|
| Rundetypene er stabile, og bør forvaltes ett sted, gjerne i regelverkssamlingen | `@OPT-REG-RUN-001` |
| Antall tilbud bør settes på runden, ikke på opptaket | `@OPT-PLA-INN-001` (per runde og utdanningskvote) |
| Hovedtildelingen må komme først | `@OPT-PLA-RUN-001` (Bare én i opptaket, Bygger på forrige) |
| Vil legge inn alle rundene på forhånd | `@OPT-PLA-RUN-001` (flere runder i opptaket) |
| Svarfristen må kunne flyttes | `@OPT-PLA-RUN-001` (navn og svarfrist kan alltid endres) |
| Lærestedet ser resultatet før det publiseres | `@OPT-PLA-RES-001` (avklart 2026-10-14) |
| Sammenligning av plasstildelinger: «kult å se hva som er endret» | `@OPT-PLA-RES-001` (sammenligne to plasstildelinger) |
| Vil se forskjellen på plasstildeling 1 og 2 før publisering | `@OPT-PLA-RES-002` (velge hvilken som publiseres) |
| Filter på utdanningstilbud som mangler antall tilbud («vis de som mangler») | `@OPT-PLA-INN-001` (filter for antall tilbud) |
| Vil se hvor mange som har tilbudsgaranti | `@OPT-PLA-INN-001` (Antall søkere med tilbudsgaranti) |

### Endringer i kravene

| Tilbakemelding | Krav i dag | Forslag |
|---|---|---|
| Påminnelse om svarfrist med klokkeslett | `@OPT-PLA-RUN-001`: bare dato (`"2027-07-18"`) | Påminnelsen får tidspunkt |
| Periode for å endre antall tilbud med klokkeslett | `@OPT-PLA-RUN-001`, `@OPT-PLA-INN-001`: bare datoer | Perioden får tidspunkt |
| Tilbudsgaranti vinner over antall tilbud som skal gis | `@OPT-PLA-TIL-002`: `@openquestion` på «Tilbudsgaranti tas fra markert utdanningskvote» | Svaret kan lukke spørsmålet. Sjekk om garantien kommer i tillegg, eller fortrenger den lavest rangerte (se også HK-11411) |
| Når svarfristen flyttes, må det være tydelig for søkeren | Ikke beskrevet | Nytt scenario: søkere med tilbud får melding når svarfristen endres |

### Åpne spørsmål

**Runder**

- Rundetypen kan ikke endres (`@OPT-PLA-RUN-001`), men HK-9759 sier at den skal kunne det. HK-dir sa i testen at rundetypene er stabile. Trenger de å endre rundetypen på en runde, eller holder det å slette og legge til runden på nytt?
- Rundetypene i regelverkssamlingen: må de kunne kopieres, eller legges ved siden av, når regelverkssamlingen kopieres?
- Én påminnelse holder i samordna opptak. Trenger lokale opptak flere?
- Hvor mange tilbud kan en søker få i runden? Ved ledige studieplasser i UHG gis det inntil 10 tilbud. Skal søkere kunne få plass flere steder? (`@openquestion` i `@OPT-PLA-RUN-001` og `@OPT-PLA-TIL-002`)
- I SODB var det bare én runde om gangen, fordi lærestedene ikke fant riktig runde når alle rundene lå der. Skal lærestedene bare se runden som er aktiv for dem?

**Antall tilbud som skal gis**

- Settes antall tilbud for hovedtildelingen på utdanningstilbudet og hentes derfra, og justeres det bare i de neste rundene?
- HK-10158 ønsker ett samlet mål for aksepterte tilbud gjennom alle runder. Kravet har ett tall per runde. Er det fortsatt et behov?

**HK-dirs kontroll før plasstildelingen** (ikke i kravene)

- Etter fristen sjekker HK-dir at tallene gir mening: alle kvalifiserte får tilbud, antall tilbud mot studieplassene, antall som mangler. Trengs en kontrollvisning eller egne filtre for dette (for eksempel «tilbud til alle kvalifiserte»)?
- Hva er «for høyt»? Trengs en terskel for antall tilbud mot planlagte studieplasser?

**Lærestedenes kontroll etter plasstildelingen**

- HK-10162: lærestedene godkjenner eller avviser. `@OPT-PLA-RES-001` har tatt det ut med vilje. I dag svarer lærestedene «kontrollert» eller melder avvik på e-post, og HK-dir ville heller markere enkeltforekomster enn å få en status. Hva trenger HK-dir å vite for å være trygge før publisering? Holder en infotekst med kontaktinfo og frist?
- Trengs en frist for lærestedets kontroll?
- Etter perioden for antall tilbud må lærestedet be HK-dir om å endre. Skal HK-dir kunne åpne for endring for ett lærested, for eksempel som en oppgave etter kontrollen? (Maciek)

**Varsler og oppgaver til lærestedene** (ikke i kravene, se også HK-9307)

- Hvor lever varslene: bare i FS Admin, eller også på e-post?
- Hvem får dem: opptaksansvarlig eller stedfortreder ved lærestedet. HK-dir har lister over kontaktpersonene. Skal kontaktpunktene for opptak ligge i løsningen (eventuelt i `09 Organisasjon`)?
- Skal HK-dir kunne varsle ett og ett lærested, og varsle på nytt?

**Publisering og det søkeren ser**

- Hva skjer med utsendingen av svar når HK-dir publiserer? (åpne spørsmål i `@OPT-PLA-RES-002`)
- HK-dir vil se det søkeren ser før publisering: resultatet og svarbrevet, for stikkprøver og for en liste med «sære» søkere. Ingen krav dekker dette (se HK-13784). Skal det med?
- Etter publisering tar HK-dir stikkprøver: endringer i ventelisten, riktig vedtak, justeringer etter nye runder. Holder `@OPT-PLA-RES-003`, eller trengs mer?

**Diagnoser** (ikke i kravene, se HK-10976)

- Hvilke diagnoser trengs? «Tidspunkt for søknad» er nevnt, men kriteriene er uklare.
- Ved ventelistenummer manglet søknadstidspunktet. Skal det vises?

**Utenfor plasstildelingen**

- Møttregistrering (KD vil ha statistikk, DBH-rapportering): HK-10199, HK-10200, HK-10201, HK-10818. Ikke dekket.

## 2. Brukervennlighet og implementasjonsdetaljer

Hører hjemme i skissene og i `<feature>.design.md` (`fs-implementasjonsdetaljer`).

**Det som fungerte**

- Lett å lese, og bedre oversikt enn i test i dag. Listen er rask å klikke seg gjennom.
- Infoteksten om rundetypen når runden legges til (se HK-9751).
- «0 av 9» for antall tilbud, og statusene akseptert og venter på svar.
- «De får varsel når …»: «Det hadde vært en drøm!»
- Varselet «Mange kvalifiserte (445) mot 12 ledige plasser», og varsel om overskredet antall plasser.
- Filter på lærested og studiested, sortering på utdanningstilbud, søk på navn og sortering i kontrollen.
- Rekkefølgen på fanene passer med hvordan HK-dir jobber i dag.
- Varsler og oppgaver er mye enklere enn e-post.

**Det som må bli bedre**

- Begrepene må være entydige og forklart:
  - «Etter runden»: er det overbooking eller kontroll?
  - «Nye tilbud»
  - «HK-dirs kontroll» og «Lærestedets kontroll»: kontroll av hva?
- For mye informasjon: vanskelig å se hva som er viktig, og hvilke oppgaver som løses hvor og av hvem. Hva må jeg ta stilling til?
- Diagnosene bør være lukket fra start. Taggene og advarslene er nyttige.
- Tall er viktigere enn grafen.
- Usikker på om kontroll og endringer skal ligge på samme side. Endringen kan vises bare før fristen, eller når lærestedet har fått en oppgave (Maciek).
- Infoboks til lærestedet: «Har du oppdaget feil, kontakt HK-dir på … innen …».
- Bekreftelse før publisering (Maciek).
- Sette antall tilbud per kvote, også «tilbud til alle kvalifiserte», direkte i listen.
- Tidspunkt-velger på svarfrist, påminnelse og periode.
