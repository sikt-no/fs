# Mal: Kvalitetssikring i teamet (trinn 1)

Sjekklista «Klar for akseptansetest» fra rutinen. Den gjelder hver sak før den går til intern akseptansetest, og er teamets eget ansvar. Minst én annen person enn den som utviklet saken, i teamet eller i et annet team, går gjennom lista.

Sjekklista er ikke for testerne. Den interne testen viser til den med én linje («Kvalitetssikring i teamet»).

Siden samler også det teamet og testansvarlig trenger, men ikke testerne (seksjonen «Saken og kravene»): sakene i GitHub og Jira, kravfilene med Feature-ID og status, hva som er endret i kravene, «berører andre team», tekniske forhold, avvik mellom eksemplene i kravene og testdataene, viktige endringer fra FS-klienten (til introen i testmøtet), sporingen fra testtilfelle til krav, og det som ikke er med i testene, med taggen og det åpne spørsmålet.

Status i hver rad er én av: `OK`, `Mangler`, `Ikke relevant: <grunn>`, `[Fylles ut av teamet]`. «Kilde» sier hvor skillen fant svaret. Det skillen ikke kan se fra repoet, står som `[Fylles ut av teamet]`.

Fila skrives til `tasks/<domene>/<slug>/tester/kvalitetssikring-<slug>.md`:

```markdown
# Kvalitetssikring i teamet – <navn på saken>

- **Oppgave**: [tasks/<domene>/<slug>](../oppgave.md)
- **Krav**: <feature-filer med Feature-ID og status>, commit `<sha>` (<dato>)
- **Laget**: <YYYY-MM-DD> av fs-akseptansetest
- **Gått gjennom av**: [Fylles ut av teamet] (en annen enn den som utviklet saken)

## Saken og kravene

Informasjon til teamet og testansvarlig. Den står ikke på testsidene.

| Felt | Innhold |
|---|---|
| Sak | <GitHub-issue> · <Jira> |
| Krav | <lenke til hver feature-fil> (`<Feature-ID>`, `<status>`), commit `<sha>` |
| Endret siden forrige runde | <bare ved ny runde> |
| Berører andre team | <fra `design.md` / `utforing.md`> |
| Teknisk | <flagg, kode som ikke er merget, kodeverdier> |
| Testdata mot kravene | <der eksemplene i kravene og testdataene er ulike> |

### Viktige endringer fra FS-klienten

<Til introen i testmøtet. Det som gir et annet resultat enn i dagens løsning.>

### Åpne spørsmål

<Spørsmål som avgjør forventet resultat i et testtilfelle. Skriv spørsmålet så det kan leses uten kravfila, hvilket testtilfelle det gjelder, og hva som skjer med testtilfellet til det er besvart. Står det ingen, utelates seksjonen.>

### Sporing fra testtilfelle til krav

| Intern | Ekstern | Krav | Scenario |
|---|---|---|---|
| 1.1 | 1 | `<Feature-ID>` | <scenariotittel fra kravet> |

Ikke med i testene: <scenarioer utenfor gating-settet, med taggen og det åpne spørsmålet>.

## 1. Kravene er dekket (funksjonell test)

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 1.1 | Hvert scenario i kravet er gått gjennom og bekreftet, f.eks. med `fs-verify` (rapport med `fil:linje` per scenario) | <N av M funnet, X usikre> | `spec/verify-<dato>-<HHMM>.md` |
| 1.2 | Ingen `@openquestion` gjenstår. Det som er bevisst utsatt, står beskrevet: hva som er «bra nok nå», og hva som fikses senere | | `Grep @openquestion` |
| 1.3 | `@draft`-delene som ikke skal testes nå, er kjent for testansvarlig | | |

## 2. Helheten virker fortsatt (ende-til-ende-test)

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 2.1 | Teamet har kjørt den faste «gylne stien» med testdata: forberede opptak → søknadsregistrering → søknadsbehandling → etterbehandling | [Fylles ut av teamet] | |
| 2.2 | Det er sjekket hva saken påvirker hos andre team, og de berørte teamene er informert | | `utforing.md`, `design.md` |
| 2.3 | Kontrakter og grensesnitt mellom komponentene (GraphQL-skjema, API) er uendret, eller endringen er avklart med teamene som bruker dem | | `utforing.md` (Overlevering) |

## 3. Relevante brukergrupper er sjekket

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 3.1 | Funksjonen er testet med hver rolle i kravene: <rollene> | [Fylles ut av teamet] | rollene fra kravene |
| 3.2 | Feilsituasjoner og grensetilfeller er prøvd: manglende data, frister og datoer, ugyldig input | [Fylles ut av teamet] | |

## 4. Teknisk grunnmur

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 4.1 | Automatiske tester er grønne i CI, og det er lagt til tester for det nye | [Fylles ut av teamet] | PR-ene i `utforing.md` |
| 4.2 | Saken er deployet til miljøet der akseptansetesten kjøres, og virker der | [Fylles ut av teamet] | |
| 4.3 | Testbrukere og testdata er klare for hvert testtilfelle (kolonnene «Testbruker» og «Testdata» i den interne testen) | | `tester/akseptansetest-intern-<slug>.md` |
| 4.4 | Universell utforming er sjekket der det er nytt grensesnitt (tastatur, skjermleser) | [Fylles ut av teamet] | |

## 5. Overlevering

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 5.1 | Testdokumentet for intern akseptansetest er laget og kvalitetssikret (fs-akseptansetest, modus D) | | |
| 5.2 | Siden er opprettet i Confluence | | |
| 5.3 | Statusen i GitHub og Jira er oppdatert, og det står hvor i utviklingsmodellen saken er | [Fylles ut av teamet] | |
| 5.4 | Designer har sett over løsningen der det er relevant | [Fylles ut av teamet] | |

## Oppsummering

- **Klar for akseptansetest**: Ja / Nei / Ja, med forbehold
- **Mangler før testen**: <liste>
- **Det testerne ikke kan gjøre**: <kort liste, går til «Dette kan du ikke gjøre i testen» i testene>
```
