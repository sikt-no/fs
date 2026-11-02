# Spørsmål og svar — `fs-specify` (2026-10-26)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Rangering i stedet for tall (@OPT-REG-KVO-004)

**Spørsmål:** Kravet beskriver kvoteprioriteten som tall og avviser 0, 4 og 2,5. Utkastet rangerer med dra og «Flytt opp/ned», og mocken tillater 1 til antall rangerte, mens kravet sier 1 til antall kvotetyper i regelverkssamlingen. Hva gjelder?

**Alternativer:**
- Kravet er riktig (Recommended)
- Kravet må endres
- Vet ikke

**Svar:** Kravet er riktig (Recommended)

---

## 2. Ny kvotetype og tall fra før (@OPT-REG-KVO-004)

**Spørsmål:** opprettKvotetypeV2 tar imot kvoteprioritetDefault, og V189 kopierte kvoteprioritet_default. Det går mot at en ny kvotetype kommer inn uten kvoteprioritet, og at kvotetypene står uten kvoteprioritet første gang. Hva gjelder?

**Alternativer:**
- Kravet er riktig, koden endres (Recommended)
- Tallene som finnes, skal nullstilles
- Kravet må endres

**Svar:** Kravet er riktig, koden endres (Recommended)

---

## 3. Hvor varselet står (@OPT-REG-KVO-004, @OPT-REG-KVO-003)

**Spørsmål:** Utkastet viser varselet bare i fanen «Kvoteprioritet og plassflyt», og i redigering av plassflyten har raden ingen tagg. Hvor skal varselet stå?

**Alternativer:**
- I fanen er nok (Recommended)
- Også på fanen Kvotetyper
- Vet ikke

**Svar:** I fanen er nok (Recommended)

---

## 4. SPEV som hovedkvote eller mottaker (@OPT-REG-KVO-003)

**Spørsmål:** Utkastet lar en SPEV-kvote velges som hovedkvote, og som mottaker for andre kvoter. Kravet sier ikke noe om det. Hva gjelder?

**Alternativer:**
- Ingen av delene er lov (Recommended)
- Kravet er nok som det står
- Vet ikke

**Svar:** Ingen av delene er lov (Recommended)

---

## 5. Eksempelet på ring (@OPT-REG-KVO-003)

**Spørsmål:** «Sirkulær plassflyt» setter en mottaker på hovedkvoten, som ikke er mulig. Skal eksempelet byttes til en ring mellom to kvoter som ikke er hovedkvote, for eksempel NN og SAM?

**Alternativer:**
- Ja, bytt eksempelet (Recommended)
- Nei, behold det

**Svar:** Ja, bytt eksempelet (Recommended)

---

## 6. Skrive endringene i sette_plassflyt.feature

**Spørsmål:** Skal jeg skrive endringene i sette_plassflyt.feature nå: ny regel om at en SPEV-kvote ikke kan være hovedkvote eller mottaker, med to scenarioer, og et nytt eksempel på ring?

**Alternativer:**
- Skriv, og hent inn begge (Recommended)
- Skriv som @draft
- Bare KVO-004 nå

**Svar:** Skriv, og hent inn begge (Recommended)

---

## 7. Forklaring under «Kvoteprioritet» (fs-implementasjonsdetaljer)

**Spørsmål:** Figma-skissen har en forklaring under overskriften, utkastet har ingen. Skal forklaringen være med?

**Alternativer:**
- Ja, med ny ordlyd (Recommended) — «Søkere som konkurrerer i flere kvoter på samme utdanningstilbud, får først tilbud i kvoten med høyest prioritet. 1 er høyest.»
- Ja, som i Figma
- Nei, som i utkastet

**Svar:** Ja, med ny ordlyd (Recommended)

---

## 8. Hjelpetekster i «Standard plassflyt» (fs-implementasjonsdetaljer)

**Spørsmål:** Figma-skissen har to hjelpetekster som utkastet ikke har. Skal de være med?

**Alternativer:**
- Ja, med ordene i kravet (Recommended)
- Ja, som i Figma
- Nei, som i utkastet

**Svar:** Ja, med ordene i kravet (Recommended)
