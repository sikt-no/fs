# Mal: Intern akseptansetest (trinn 2)

For domeneekspertene (testansvarlig og andre testere). Den er fullstendig: alle testbare scenarioer i gating-settet, også feilsituasjoner og grensetilfeller, og alt testansvarlig trenger for å beslutte.

Ikke ta med: seksjonen om kvalitetssikring i teamet (bare én linje i testbeskrivelsen), helhetsrunde, regresjon eller universell utforming (se T14 i `teststeg.md`).

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `tasks/<domene>/<slug>/tester/akseptansetest-intern-<slug>.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Intern akseptansetest – <navn på saken>

- **Nivå**: intern (trinn 2)
- **Oppgave**: [tasks/<domene>/<slug>](../oppgave.md)
- **Krav**: <feature-filer med Feature-ID og status>, commit `<sha>` (<dato>)
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-akseptansetest

---

Testbeskrivelse og testgjennomføring for den interne akseptansetesten av «<navn>». Siden følger rutinen [Kvalitetssikring og akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953/Kvalitetssikring+og+akseptansetesting), og er laget fra kravene i commit `<sha>` (<dato>). Felt merket **[Fylles ut]** fylles ut av teamet før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Sak | <GitHub-issue> · <Jira> |
| Krav | <lenke til hver feature-fil> (`<Feature-ID>`, `<status>`) |
| Hva er laget | <3–5 setninger: hva brukeren kan gjøre, og hvor i løsningen> |
| Brukerhistorie | <fra kravet> |
| Hvor testes det | Miljø: <navn>. URL: <url> |
| Kvalitetssikring i teamet | <Gjennomført dato, lenke til `tester/kvalitetssikring-<slug>.md`> |
| Berører andre team | <fra `design.md` / `utforing.md`> |
| Kjente begrensninger | <det testeren må vite for ikke å melde feil som er kjent: flagg, kode som ikke er merget, regler som virker annerledes enn man tror> |
| Kontaktperson i teamet | <navn> |
| Testansvarlig | <navn> |
| Andre testere | <navn, og hvem som tar hvilke deler> |
| Tid | <dato og klokkeslett>. Beregnet tid: <N> minutter |
| Spørsmål underveis | Slack-tråden «Akseptansetesting <navn>» i <kanal> |

### Testbrukere

| Rolle (fra kravene) | Testbruker | Organisasjon | Brukes i |
|---|---|---|---|
| Opptaksforvalter ved forvaltende organisasjon | <navn> | <org> | Del 1, 2 |

### Testdata

| Hva | Verdi | Hvor du finner det | Brukes i |
|---|---|---|---|
| <Opptak med utdanningstilbud> | <navn> | <lenke eller menyvei> | 3.3 |

### Viktige endringer fra FS-klienten

<Valgfri. Det som gir et annet resultat enn i dagens løsning, så testeren ikke melder det som feil.>

## Åpne spørsmål

<Valgfri. Spørsmål som avgjør forventet resultat. Fra `@openquestion` som gjelder et scenario i testen, eller fra verify-rapporten.>

| # | Spørsmål | Testtilfeller | Svar (navn og dato) |
|---|---|---|---|

## Slik tester du

- Ta delene og testtilfellene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Bestått?» med Ja, Nei eller Delvis.
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Funn skrives i «Funn»: hva du gjorde, hva du forventet, hva du fikk.
- Mer i [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting).

## Testgjennomføring

### Del 1: <hva delen gjør>

**Logg inn som:** <rolle> (<testbruker>, <organisasjon>)
**Forutsetter:** <data som må finnes, eller «ingenting»>
**Tid:** ca. <N> minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 1.1 | `<Feature-ID>` <scenariotittel> | 1. Gå til … <br>2. Velg … <br>3. Skriv inn «…» i «…» <br>4. Lagre <br>5. Gå ut av …, og åpne … igjen | <det testeren ser> | | |
| | | *Gjør klar til neste test: …* | | | |

### Del 2: …

## Ikke testbart nå

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| `<Feature-ID>` <tittel> | <koden mangler / virkningen er i Min kompetanse, som ikke leser innstillingen ennå / testdata finnes ikke> | <sak eller hendelse> |

## Ikke med i denne testen

| Scenario | Begrunnelse |
|---|---|
| <tittel> | <`@draft @openquestion`: …, `@wont`, egen oppgave, …> |

## Funn

| # | Testtilfelle | Hva gjorde du | Hva forventet du | Hva skjedde | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

Alvorlighetsgrad: **Stopper** (kritisk feil, stopper systemet eller har alvorlige konsekvenser), **Må fikses før innføring** (vesentlig feil, men det finnes en midlertidig løsning) eller **Kan fikses senere** (mindre feil, skrivefeil, visuelle avvik, forbedringer til backlog).

## Andre funn og erfaringer

Det du oppdager som ikke gjelder kravene, f.eks. brukervennlighet. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et scenario, skriv det her.

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
