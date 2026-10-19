# Mal: Intern akseptansetest (trinn 2)

For domeneekspertene (testansvarlig og andre testere). Den er fullstendig: alle testbare scenarioer i gating-settet, også feilsituasjoner og grensetilfeller, og alt testansvarlig trenger for å beslutte.

Siden er for testerne. Det de ikke trenger for å teste, står på kvalitetssikringssiden (`mal-kvalitetssikring.md`), ikke her: saker i GitHub og Jira, kravfilene, Feature-ID-er og tagger, hva som er endret i kravene, «berører andre team», tekniske forhold (flagg, branch, kodeverdier), avvik mellom eksemplene i kravene og testdataene, sporingen fra testtilfelle til krav, og åpne spørsmål. Ikke ta med helhetsrunde, regresjon eller universell utforming (se T14 i `teststeg.md`).

Testbrukeren og testdataene står i hvert testtilfelle (kolonnene «Testbruker» og «Testdata»), ikke i egne tabeller (T1 og T13 i `teststeg.md`).

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`, og punkter i «Dette kan du ikke gjøre i testen» som `- …` skilt med `<br>`. Ved publisering blir de lister i cella, og tabellene får full bredde (se `confluence.md`).

Fila skrives til `tasks/<domene>/<slug>/tester/akseptansetest-intern-<slug>.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Intern akseptansetest – <navn på saken>

- **Nivå**: intern (trinn 2)
- **Oppgave**: [tasks/<domene>/<slug>](../oppgave.md)
- **Krav**: <Feature-ID-er>, commit `<sha>` (<dato>). Sporingen står på kvalitetssikringssiden
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-akseptansetest

---

Intern akseptansetest av «<navn>». Felt med gul bakgrunn fylles ut av teamet før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er laget | <2–4 setninger: hva brukeren kan gjøre, og hvor i løsningen. Bruk navnene på seksjonene i skjermen> |
| Brukerhistorie | <fra kravet> |
| Hvor du tester | [<url>](<url>) |
| Kvalitetssikring i teamet | [<tittel>](kvalitetssikring-<slug>.md) |
| Dette kan du ikke gjøre i testen | - <kort: hva testeren ikke kan gjøre eller se, og hvorfor i få ord> <br>- <…> |
| Kontaktperson i teamet | <navn> |
| Testansvarlig | <navn> |
| Andre testere | <navn, og hvem som tar hvilke deler> |
| Tid | <dato og klokkeslett>. Beregnet tid: <N> minutter |
| Spørsmål underveis | Slack-tråden «Akseptansetesting <navn>» i <kanal> |

## Slik tester du

- Ta delene og testtilfellene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Kolonnen «Testbruker» sier hvem du skal være. Kolonnen «Testdata» sier hva du bruker, og hva du lager som senere testtilfeller trenger.
- Fyll ut «Faktisk resultat» med det du så, og «Bestått?» med Ja, Nei eller Delvis.
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Funn skrives i «Funn»: hva du gjorde, hva du forventet, hva du fikk.
- Mer i [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting).

## Testgjennomføring

### Del 1: <hva delen gjør> (ca. <N> minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 1.1 | <navn>, <rolle> ved <organisasjon> | <scenariotittel med vanlige ord> | **Bruker:** <data som må finnes, med navn og hvor>. <br>**Lager:** <data som lages her, og hvilke testtilfeller som trenger dem> | 1. Logg inn som … <br>2. Gå til … <br>3. Skriv inn «…» i «…» <br>4. Lagre <br>5. Gå ut av …, og åpne … igjen | <det testeren ser> | | |
| | | | | *Gjør klar til neste test: …* | | | |

### Del 2: …

## Bestått i forrige runde

<Bare ved ny runde: det som ble bestått og ikke er endret, med nummeret i forrige runde.>

## Ikke testbart nå

| # | Hvorfor | Når det kan testes |
|---|---|---|

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <med vanlige ord> | <kort, uten tagger: testes sammen med …, er ikke avklart ennå, kommer senere> |

## Funn

| # | Testtilfelle | Hva gjorde du | Hva forventet du | Hva skjedde | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

Alvorlighetsgrad: **Stopper** (kritisk feil, stopper systemet eller har alvorlige konsekvenser), **Må fikses før innføring** (vesentlig feil, men det finnes en midlertidig løsning) eller **Kan fikses senere** (mindre feil, skrivefeil, visuelle avvik, forbedringer til backlog).

## Andre funn og erfaringer

Det du oppdager som ikke gjelder testtilfellene, f.eks. brukervennlighet. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et testtilfelle, skriv det her.

| Hva gjorde du? | Hvor gjorde du det? | Hva vil du melde om? |
|---|---|---|
| | | |

## Beslutning

| Felt | Innhold |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Kjente mangler og avtalt retting | |
| Besluttet av og dato | |

## Læring

Fylles ut i et kort møte mellom testerne og teamet etter testen.

- Hvilke feil burde vært fanget før akseptansetesten?
- Hva i testdokumentet var uklart (steg, testbrukere, testdata, begreper)?
- Hva bør inn i sjekklista for trinn 1, og hva bør ut?
```
