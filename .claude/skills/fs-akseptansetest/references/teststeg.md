# Regler for testtilfeller

Reglene gjelder intern og ekstern akseptansetest, og er sjekklista i modus D. De bygger på tilbakemeldingene fra de første testene (praksiskalkulatoren 14. og 16.10.2026, og opprette og vedlikeholde opptak 19.10.2026): testeren skal kunne gjennomføre testtilfellet og komme til forventet resultat uten å kjenne løsningen fra før.

## T1. Testbrukeren står i testtilfellet

Hvert testtilfelle sier hvilken testbruker testeren er: rollen fra kravet, og testbrukeren med organisasjon.

- Kolonnen «Logg inn som» (intern), eller overskriften på delen (ekstern): `Opptaksforvalter ved forvaltende organisasjon (testbruker 1: Ordentlig Rundskriv, HK-dir)`.
- Bytte av testbruker er et eget nummerert steg: `3. Bytt rolle til Ansvarsfull Fotkrem (opptaksforvalter, NTNU).` Si hvordan man bytter, første gang det skjer.
- Ikke «testbruker 3» alene. Testeren skal ikke måtte slå opp i en tabell.

## T2. Hvor man starter

Første steg sier hvor testeren starter: en URL, eller menyveien fra forsiden med navnene i skjermen. `1. Gå til «Opptak», og velg opptaket «Samordna opptak 2027 (test)».` Ligger funksjonen et sted man ikke finner uten å vite det, si det: `Knappen «Praksiskalkulator» står under «Dokumenter» nederst i panelet til venstre.`

## T3. Nummererte steg, én handling per steg

Steg skrives som en nummerert liste i imperativ: «Gå til», «Velg», «Skriv inn», «Kryss av», «Lagre», «Logg inn som». Én handling per steg. Ikke «Opprett et opptak med alle innstillinger»: skriv hvert felt.

## T4. Begrepene fra skjermen

Bruk ordene slik de står i løsningen, i «»: menyer, faner, knapper, felt, valg i nedtrekk og feilmeldinger. Hent dem fra koden (fs-admin, min-kompetanse), `<feature>.design.md` eller skissene. Bruker kravet et annet ord enn skjermen («Steinerskole» i kravet, «Videregående steinerskole» i skjermen), bruk skjermens ord i steget og kravets ord i «Scenario». Noter avviket i den interne testen. Finner du ikke ordet, merk steget `[Sjekk begrep]`.

## T5. Alle verdiene står i steget

Skriv verdien for hvert felt testeren må fylle ut: navn, datoer, klokkeslett, tall, valg. Ta med alle obligatoriske felt, også de scenarioet ikke handler om, ellers kan ikke testeren lagre («Får ikke lagret. Det finnes flere obligatoriske felter»). Finn de obligatoriske feltene i koden eller `<feature>.design.md`. Ikke «en organisasjon som ikke finnes i utdanningsregisteret»: skriv hvilken.

## T6. Hele veien til resultatet

Stegene går helt til der det forventede resultatet kan ses. Skal resultatet ses et annet sted (hos søkeren, i saksbehandlingen, som en annen testbruker), står stegene dit i testtilfellet: `6. Logg inn i Min kompetanse som søker Dyp Mygg. 7. Åpne søknaden, og prøv å laste opp et dokument.` Kan det ikke ses i miljøet, er testtilfellet ikke testbart (se B2 i SKILL.md).

## T7. Forventet resultat kan ses

Forventet resultat er noe testeren ser: en verdi i et felt, en rad i en liste, en melding med teksten, et valg som ikke finnes. Ikke «Reglene gjelder for opptaket» eller «er tilgjengelig for søknad og saksbehandling». Når et steg er «velg», sier forventet resultat hva som skjer når man har valgt.

## T8. Sjekk at det er lagret

Når scenarioet lagrer noe, slutter stegene med å forlate siden, åpne den igjen og se at verdiene står der. Det holder ikke at det kommer en melding om at noe er lagret.

## T9. Feilsituasjoner sier hva som skjer

Negative testtilfeller sier hva testeren prøver, og hva som skjer: `Opptaket lagres ikke, og meldingen «Navn på nynorsk må fylles ut» vises ved feltet.` Hent teksten fra `<feature>.design.md` eller koden. Finnes den ikke, skriv hva meldingen skal handle om.

## T10. Én ting per testtilfelle

Et `Scenariomal:` blir ett testtilfelle per eksempelrad (`2.1a`, `2.1b`), med verdiene fra raden. Et scenario som prøver flere ting, kan deles, men vis til det samme scenarioet.

## T11. Ingen duplikater

To scenarioer som gjør det samme i løsningen, blir ett testtilfelle, med begge scenarioene i «Scenario». (I opprette og vedlikeholde opptak var 2.1 og 2.6 det samme.)

## T12. Rekkefølge uten hopp

Testtilfellene står i rekkefølgen testeren gjør dem: samlet per testbruker, og innenfor testbrukeren etter hvor i løsningen (se B4 i SKILL.md). Testtilfeller på samme side står etter hverandre. Det som lager data, står før det som bruker dataene. Avhengigheter står i testtilfellet: «Bruker opptaket fra 1.1».

## T13. Forutsetninger og opprydding

Det som må finnes før testtilfellet, står først: `Forutsetter: et opptak med minst ett utdanningstilbud (testdata: «Opptak med tilbud (test)»).` Det som må ryddes før neste testtilfelle, står som egen rad: «Gjør klar til neste test: slett periodene du har lagt inn».

## T14. Riktig nivå

- Bare scenarioer fra kravene. Ingen helhetsrunde, regresjon eller universell utforming i akseptansetesten. Mangler et scenario, er det en kommentar til kontaktpersonen, ikke et nytt testtilfelle.
- Intern: Feature-ID og scenariotittel i «Scenario». Tekniske forhold (flagg, branch, kodeverdi) bare i «Kjente begrensninger».
- Ekstern: ingen Feature-ID-er, tagger, kodeverdier, GraphQL, Jira eller feature-flagg. «Hva du tester» med vanlige ord.
- Ikke «(ikke testbart: …)» i forventet resultat. Det som ikke kan testes, står i egen tabell.
