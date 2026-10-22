# Regler for testcasene

Gjelder testcasene for intern og ekstern akseptansetest (`fs-testcaser-intern` og `fs-testcaser-ekstern`), og er sjekklista før et utkast vises fram. Målet er at testeren kommer til forventet resultat uten å kjenne løsningen fra før.

Reglene bygger på [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) og erfaringene fra de første akseptansetestene (praksiskalkulatoren og opprette og vedlikeholde opptak, oktober 2026).

## Kolonnene

`Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status`

- **Faktisk resultat:** det testeren så, som fritekst. Står tomt i utkastet.
- **Status:** `Bestått`, `Ikke bestått` eller `Ikke testet`. «Ikke testet» får en kort begrunnelse i «Faktisk resultat». Står tomt i utkastet. Det er denne kolonnen `fs-testrapport` teller.

## R1. Testbrukeren står i testcasen

Testplanen har nummererte testbrukere. Første steg sier hvem testeren er, med nummer, navn, rolle og organisasjon: `1. Logg inn som testbruker 4 (Ordentlig Rundskriv, opptaksforvalter ved HK-dir).` Ikke «testbruker 4» alene: testeren skal ikke måtte slå opp i testplanen.

Bytte av testbruker er et eget nummerert steg. Første gang det skjer, sies det også hvordan man bytter.

## R2. Hvor man starter

Første steg etter innloggingen sier hvor testeren starter: en URL, eller menyveien fra forsiden med navnene i skjermen. `2. Gå til «Opptak», og velg opptaket «Samordna opptak 2027 (test)».` Ligger funksjonen et sted man ikke finner uten å vite det, si hvor.

## R3. Nummererte steg, én handling per steg

Steg skrives som en nummerert liste i imperativ: «Gå til», «Velg», «Skriv inn», «Kryss av», «Lagre», «Logg inn som». Én handling per steg. Ikke «Opprett et opptak med alle innstillinger»: skriv hvert felt.

## R4. Ordene fra skjermen

Bruk ordene slik de står i løsningen, i «»: menyer, faner, knapper, felt, valg i nedtrekk og feilmeldinger. Hent dem fra koden (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren), fra `<feature>.design.md` eller fra skissene. Bruker kravet et annet ord enn skjermen, bruk skjermens ord i stegene og kravets ord i «Scenario». Finner du ikke ordet, merk steget `[Sjekk begrep]`.

## R5. Alle verdiene står i stegene

Skriv verdien for hvert felt testeren må fylle ut: navn, datoer, tall og valg. Ta med alle obligatoriske felt, også de scenarioet ikke handler om, ellers kan ikke testeren lagre. Finn de obligatoriske feltene i koden eller i `<feature>.design.md`.

Eksemplene i Gherkin («NTNU», en dato) er eksempler, ikke testdata. Testdataene og testbrukerne kommer fra testplanen. Passer et eksempel i kravet ikke med testdataene, følg rollen i kravet og testdataene i testplanen. Mangler testdata, skriv `[Fylles ut: <hva som trengs>]`.

## R6. Hele veien til resultatet

Stegene går helt til der det forventede resultatet kan ses. Skal resultatet ses et annet sted (hos søkeren, i saksbehandlingen, som en annen testbruker), står stegene dit i testcasen. Kan det ikke ses i testmiljøet, er testcasen ikke testbar nå (se *Ikke testbart nå* i malen).

## R7. Forventet resultat kan ses

Forventet resultat er noe testeren ser: en verdi i et felt, en rad i en liste, en melding med teksten, et valg som ikke finnes. Ikke «Reglene gjelder for opptaket». Skriv aldri «(ikke testbart: …)» i forventet resultat.

## R8. Sjekk at det er lagret

Når scenarioet lagrer noe, slutter stegene med å forlate siden, åpne den igjen og se at verdiene står der. En melding om at noe er lagret, er ikke nok.

## R9. Feilsituasjoner sier hva som skjer

En testcase for en feilsituasjon sier hva testeren prøver, og hva som skjer: `Opptaket lagres ikke, og meldingen «Navn på nynorsk må fylles ut» vises ved feltet.` Hent teksten fra `<feature>.design.md` eller koden. Finnes den ikke, skriv hva meldingen skal handle om, og merk den `[Sjekk begrep]`.

## R10. Avhengigheter står i testcasen

Bruker en testcase data som en tidligere testcase har laget, står det i stegene: `Bruk opptaket fra 1.2.` Det som må ryddes før neste testcase, står som en egen rad: `Gjør klar til neste test: slett periodene du har lagt inn.`

## R11. Riktig nivå

- Bare scenarioer fra kravene. Ingen helhetsrunde, regresjon eller test av universell utforming. Scenarioene i flytene i testplanen («Flyter») er med: de tester overleveringen mellom to krav, og er ikke en helhetsrunde. Mangler et viktig tilfelle, legges det inn i kravet med `fs-krav`, ikke bare i testen.
- **Intern:** én testcase per scenario, og én per eksempelrad i en `Scenariomal:` (`1.3a`, `1.3b`). Feilsituasjoner er med når de står i kravet. Rekkefølgen i feature-fila.
- **Ekstern:** testcasen er en oppgave i arbeidsprosessen, gjennom flere scenarioer. Bare hovedflyten. Ingen Feature-ID-er, scope-id-er, tagger, kodeverdier, GraphQL, Jira eller feature-flagg.

## Sjekkliste før utkastet vises

| # | Sjekk |
|---|---|
| 1 | Hvert scenario i gating-settet har en testcase, eller står i «Ikke testbart nå» eller «Ikke med i denne testen». Det gjelder også scenarioene i fasene i «Flyter» som er med i testen |
| 2 | Ingen testcase svarer til noe som ikke står i kravene |
| 3 | R1–R11 er fulgt i hver testcase |
| 4 | «Faktisk resultat» og «Status» er tomme |
| 5 | Det som må fylles ut, er merket `[Fylles ut …]` eller `[Sjekk begrep]`, og står i oppsummeringen til brukeren |
