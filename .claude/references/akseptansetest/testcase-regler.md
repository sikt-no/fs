# Regler for testcasene

Gjelder testcasene i fase 2, 3 og 4 i teststrategien (forslag): den agentiske funksjonstesten (`fs-testcaser-cdp`), den interne akseptansetesten (`fs-testcaser-intern`) og den eksterne (`fs-testcaser-ekstern`). Reglene er sjekklista før et utkast vises fram. Målet er at den som kjører testcasen (agenten eller testeren) kommer til forventet resultat uten å kjenne løsningen fra før.

Reglene bygger på [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) og erfaringene fra de første akseptansetestene (praksiskalkulatoren og opprette og vedlikeholde opptak, oktober 2026).

## Hva hver fase tester

Hver fase bygger på den forrige og gjentar den ikke. Derfor gjelder ikke alle reglene i alle fasene.

| Fase | Hva testcasene er | Reglene |
|---|---|---|
| 2. Agentisk funksjonstest | Ett scenario (eller en utledet testcase) per testcase: positive og negative, med gyldige og ugyldige data, og feltvalidering | R1–R9, R12–R16 |
| 3. Intern akseptansetest | Flyter og avhengigheter: oppgaver i arbeidsprosessen, gjennom flere scenarioer | R1–R8, R10–R16. R9 bare når en feilsituasjon er en del av flyten |
| 4. Ekstern akseptansetest | Flytforslag til partene, som eier testcasene sine | R1–R4, R6–R8, R10, R11, R14 og R16 |

Feltvalidering, grenseverdier, obligatoriske felt og feilsituasjoner testes i fase 2, og testes ikke på nytt i fase 3 og 4. Det lages ikke egne testcaser for roller og tilganger: `fs-verify` har verifisert i koden i fase 1 at de er laget slik kravet sier, og at datakonsistensen holder. Scenarioene i kravet, også om synlighet, testes som de står.

## Kolonnene

`Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status`

- **Faktisk resultat:** det testeren (eller agenten) så, som fritekst. Står tomt i utkastet.
- **Status:** `Bestått`, `Ikke bestått` eller `Ikke testet`. «Ikke testet» får en kort begrunnelse i «Faktisk resultat». Står tomt i utkastet. Det er denne kolonnen `fs-testrapport` teller. Agenten i fase 2 skriver et forslag til status, og testansvarlig bekrefter (se *Menneskelig kontroll* i strategien).

## R1. Testbrukeren står i testcasen

Testplanen har nummererte testbrukere. Første steg sier hvem som kjører testen, med nummer, navn, rolle og organisasjon: `1. Logg inn som testbruker 4 (Ordentlig Rundskriv, opptaksforvalter ved HK-dir).` Ikke «testbruker 4» alene: testeren skal ikke måtte slå opp i testplanen. I fase 2 er testbrukeren en nøkkel (`opptaksforvalter-hk-dir`), som slås opp i testplanen ved kjøring (se `roller-og-testdata.md`).

Bytte av testbruker er et eget nummerert steg. Første gang det skjer, sies det også hvordan man bytter.

## R2. Hvor man starter

Første steg etter innloggingen sier hvor testen starter: en URL, eller menyveien fra forsiden med navnene i skjermen. `2. Gå til «Opptak», og velg opptaket «Samordna opptak 2027 (test)».` Ligger funksjonen et sted man ikke finner uten å vite det, si hvor.

## R3. Nummererte steg, én handling per steg

Steg skrives som en nummerert liste i imperativ: «Gå til», «Velg», «Skriv inn», «Kryss av», «Lagre», «Logg inn som». Én handling per steg. Ikke «Opprett et opptak med alle innstillinger»: skriv hvert felt.

## R4. Ordene fra skjermen

Bruk ordene slik de står i løsningen, i «»: menyer, faner, knapper, felt, valg i nedtrekk og feilmeldinger. Hent dem fra koden (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren), fra `<feature>.design.md` eller fra skissene. Bruker kravet et annet ord enn skjermen, bruk skjermens ord i stegene og kravets ord i «Scenario». Finner du ikke ordet, merk steget `[Sjekk begrep]`.

## R5. Alle verdiene står i stegene

Skriv verdien for hvert felt som skal fylles ut: navn, datoer, tall og valg. Ta med alle obligatoriske felt, også de scenarioet ikke handler om, ellers kan ikke testen lagre. Finn de obligatoriske feltene i koden (lag lista eksplisitt, for eksempel `missingFields` i `src/common/messages/nb/opptak.json` i fs-admin) eller i `<feature>.design.md`.

Eksemplene i Gherkin («NTNU», en dato) er eksempler, ikke testdata. Testbrukerne og testdataene kommer fra testplanen. Passer et eksempel i kravet ikke med testdataene, følg rollen i kravet og testdataene i testplanen. Mangler testdata, skriv `[Fylles ut: <hva som trengs>]`.

**Forhåndsutfylte felt.** Sjekk om feltet har en standardverdi (i koden, for eksempel `emptyObjectGenerators.ts` i fs-admin). Skal et forhåndsutfylt felt være tomt, skriv `Fjern tallet i «Tilbud per tildelingsrunde» (forhåndsutfylt med 1).`, ikke «La stå tom».

## R6. Hele veien til resultatet

Stegene går helt til der det forventede resultatet kan ses. Skal resultatet ses et annet sted (hos søkeren, i saksbehandlingen, som en annen testbruker), står stegene dit i testcasen. Kan det ikke ses i testmiljøet, er testcasen ikke testbar nå (se *Ikke testbart nå* i malen). I `cdp-tester/` lages testen likevel, og kjøringen viser at den ikke kan tas.

## R7. Forventet resultat kan ses

Forventet resultat er noe som kan ses: en verdi i et felt, en rad i en liste, en melding med teksten, et valg som ikke finnes. Ikke «Reglene gjelder for opptaket». Skriv aldri «(ikke testbart: …)» i forventet resultat.

## R8. Sjekk at det er lagret

Når scenarioet lagrer noe, slutter stegene med å forlate siden, åpne den igjen og se at verdiene står der. En melding om at noe er lagret, er ikke nok.

## R9. Feilsituasjoner sier hva som skjer, og tester ett felt (fase 2)

En testcase for en feilsituasjon sier hva som prøves, og hva som skjer: `Opptaket lagres ikke, og meldingen «Navn på nynorsk må fylles ut» vises ved feltet.` Hent teksten fra `<feature>.design.md` eller koden. Finnes den ikke, skriv hva meldingen skal handle om, og merk den `[Sjekk begrep]`.

- **Én ting per testcase.** Alle de andre obligatoriske feltene er fylt ut, så det er feltet testcasen handler om, som stopper lagringen. Forventet resultat sier det: `«Lagre» kan ikke velges. «Opptakstype» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der.` Er løsningen slik at flere meldinger vises samtidig av andre grunner, skriv hva som vises, og at feltet er blant dem.
- **Obligatoriske felt** testes tomt, med bare mellomrom og med for lang verdi, og feilmeldingen kontrolleres.
- **Negativ testing:** ugyldige verdier, feil format, handlinger i feil rekkefølge og handlinger på data som ikke finnes eller er slettet.
- **Teknikken** står i testcasen: grenseverdianalyse (min, maks, like over og like under, tomt felt), ekvivalensklasser, beslutningstabeller for regler med flere betingelser, eller tilstandsoverganger.
- **Svakheter i kravet** (et scenario som lagrer uten alle de obligatoriske feltene, eller en feilsituasjon som ikke sier at resten er fylt ut) rettes ikke bare i stegene. De meldes til `fs-krav`, med `fil:linje`.

## R10. Avhengigheter står i testcasen

Bruker en testcase data som en tidligere testcase har laget, står det i stegene: `Bruk opptaket fra 1.2.` Det som må ryddes før neste testcase, står som en egen rad: `Gjør klar til neste test: slett periodene du har lagt inn.` Gjelder ikke i fase 2: der er testcasene uavhengige (R13).

## R11. Riktig nivå

- Bare scenarioer fra kravene, og i fase 2 testcaser utledet fra reglene (også regler i koden uten scenario, fra verify-rapporten). Ingen helhetsrunde, regresjon (utenom i fase 3, se under) eller test av universell utforming. Mangler et viktig tilfelle, legges det inn i kravet med `fs-krav`, ikke bare i testen. Utleder agenten et tilfelle som kravet ikke sier noe om, og løsningen oppfører seg uventet, er det et funn av typen «Kravet dekker ikke» (`alvorlighetsgrad.md`).
- **Fase 2 (agentisk):** alle scenarioer i gating-settet som er `@implemented`, og en scenariomal gir én testcase per eksempelrad (`1.3a`, `1.3b`). Pluss positive og negative testcaser utledet fra reglene (R9). Flyter på tvers og avhengigheter testes ikke her. Har scenarioet et åpent spørsmål (`@openquestion` uten `@draft`), testes det som det står.
- **Fase 3 (intern):** flyter og avhengigheter, ikke ett scenario per testcase. Hver testcase er én flyt (oppgaver i arbeidsprosessen, i den rekkefølgen brukerne jobber, ikke i rekkefølgen i feature-fila), gjennom flere scenarioer, med hensikt, testdata og forventet resultat, og avhengighetene som sjekkes underveis. Hvert scenario i flyten får eget resultat. Bare scenarioene som inngår i flytene, ikke alle. Regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på. Feltvalidering, grenseverdier og obligatoriske felt testes ikke på nytt. Har et scenario i flyten et åpent spørsmål (`@openquestion` uten `@draft`), står spørsmålet med vanlige ord under tabellen: `Åpent spørsmål til 1.3: Løsningen godtar 0–9999. Dekker det alle utdanningstilbud?` Testeren kan svare i en kommentar, men svaret endrer ikke status på testcasen.
- **Fase 4 (ekstern):** partene eier testcasene sine, ut fra sine egne krav. Det Sikt lager, er flytforslag: oppgaver i arbeidsprosessen, bare hovedflyten. Ingen Feature-ID-er, scope-id-er, tagger, kodeverdier, GraphQL, Jira eller feature-flagg.

## R12. Felles utfylling har navn

Fyller flere testcaser ut det samme skjemaet, står utfyllingen én gang, øverst i delen, med et navn og alle feltene med verdier: «**Utfylling A: gyldig samordna opptak**». Testcasene viser til den med navnet og det som er annerledes: `2. Fyll ut som i Utfylling A, men la «Opptakstype» stå tom.` Ikke vis til stegnumre i en annen testcase («som i 1.1, steg 4–8»): det er lett å bomme på numrene, og en endring i en testcase forskyver alle henvisningene.

## R13. Testen kan kjøres på nytt

Det gjelder både en ny testrunde og kjøringer med flere agenter.

- **Testcasene i fase 2 er uavhengige.** Hver testcase bygger på testdataene i testplanen, i utgangstilstanden der (se *Testdata* i `roller-og-testdata.md`), og ikke på data fra en annen testcase. Hvordan testdataene lages og settes tilbake, er utenfor teststrategien. Er testcasen `@endrer-data`, eller lager scenarioet selv data som ikke kan slettes, rydder eller tilbakestiller testcasen etterpå.
- Lager testen data som ikke kan slettes, og som finnes igjen på navn, har navnet en del som skiller kjøringene: `«Samordna opptak 2027 (test {KJØRING})»`. Øverst står det hva `{KJØRING}` byttes ut med (for eksempel dato og klokkeslett når testen starter).
- Endrer en testcase noe som andre testcaser eller en senere kjøring bygger på, settes det tilbake, og verdien noteres i et eget steg før den endres: `sett «Planlagte studieplasser» tilbake til verdien du noterte i steg 2`. I fase 3 står det som en egen rad (R10): `Gjør klar til neste test: …`.
- Testdata som bare kan brukes én gang (for eksempel et utdanningstilbud som legges til i et opptak), står som `[Fylles ut: …, ikke det samme som i en tidligere kjøring]`.
- Kan en testcase ved en kjent mangel lage data testen ikke regnet med, har dataene et eget navn, så de ikke blandes med resten.
- Tilstander som bygger på datoer er sanne bare i et vindu. Fristene står i forhold til dagen testen kjøres (se `roller-og-testdata.md`).

## R14. Følg stegene slik de står

Virker ikke et steg, eller finnes ikke en verdi i testmiljøet, er det et funn. Ikke prøv deg fram en annen vei. Testcasen blir «Ikke testet», med det som ble sett i «Faktisk resultat», og det står i «Andre funn» om det er testdataene eller løsningen. Den som kjører testen kan foreslå en vei rundt i «Faktisk resultat», men går den ikke. Unntaket er når testansvarlig har sagt at nærmeste verdi kan brukes: det står da i «Faktisk resultat», og statusen settes ut fra det kravet sier, ikke ut fra verdien i stegene. Gjelder agenten i fase 2 like mye som testeren i fase 3 og 4.

## R15. Testdata finnes, eller merkes

Sjekk at testdataene i testplanen finnes i testmiljøet før testcasene skrives: verdiene i nedtrekkslistene (regelverkssamling, poenglikhetsregel, kodeverk) og opptakene i testplanen. Finnes ikke en verdi, bruk verdien som finnes, og si det i oppsummeringen. Kan det ikke sjekkes, merk verdien `[Sjekk testdata]`.

## R16. Kjent mangel har en kilde, og sjekkes

En testcase merket «Kjent mangel (<sak>)» har saken fra verify-rapporten eller fra teamet, aldri en antakelse. Før testen starter, og hver gang skillen kjøres på nytt, sjekkes saken (Jira-status, eller endringsloggen i kodeklonen). Er saken levert, fjernes merket, testcasen testes som de andre, og regelen foreslås til `fs-verify`. Sjekket står i oppsummeringen: `TAKE-431: levert i fs-admin 0.61.0 (2026-10-22), merket fjernet fra 1.5c og 1.5d.`

## Sjekkliste før utkastet vises

| # | Sjekk |
|---|---|
| 1 | Hvert scenario i gating-settet har en testcase (fase 2), eller står i «Ikke testbart nå» eller «Ikke med i denne testen» (i `cdp-tester/` blir alle tester). I fase 3 er alle scenarioene i fasene i «Flyter» som er med i testen, dekket |
| 2 | Ingen testcase svarer til noe som ikke står i kravene, eller (fase 2) til en utledet regel som er merket som det |
| 3 | Reglene for fasen (tabellen over) er fulgt i hver testcase |
| 4 | «Faktisk resultat» og «Status» er tomme |
| 5 | Det som må fylles ut, er merket `[Fylles ut …]`, `[Sjekk begrep]` eller `[Sjekk testdata]`, og står i oppsummeringen til brukeren |
| 6 | Følg stegene bokstavelig, med lista over obligatoriske felt fra koden ved siden av: Når testen forventet resultat? Mangler et obligatorisk felt i en testcase som skal lagre? Mangler noe annet enn feltet som testes, i en feilsituasjon? Gir en henvisning (`som i Utfylling A`) det testcasen trenger? |
| 7 | Fase 2: hver testcase er uavhengig, rydder etter seg og kan kjøres på nytt (R13) |
| 8 | Hver «Kjent mangel» har en sak, og saken er sjekket (R16) |
