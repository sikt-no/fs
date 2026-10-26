# Maler: CDP-tester

Tre filer (fase 2, den agentiske funksjonstesten): testfila (`<test>.feature`), `README.md` i mappa («Krever» og «Ikke kjørbart»), og resultatet av en kjøring (`resultat.md`). Konvensjonene står i [`cdp-tester/README.md`](../../../../cdp-tester/README.md).

## Testfila

`cdp-tester/<kravets sti under krav/>/<samme filnavn som kravet>.feature`

```gherkin
# language: no
# Generert av fs-testcaser-cdp <YYYY-MM-DD> fra akseptansetest/<slug>/testplan.md | manuelt
# Krav: krav/<sti>/<fil>.feature @ <commit> (blob <hash>)
@TST-<DOM>-<SUB>-<KAP>-NNN @depends-on-<Feature-ID>
Egenskap: <tittelen i kravet>
  <samme beskrivelse som i kravet, eller en linje om hva testene sjekker>

  Regel: <tittelen i kravet>

    # Testcase: <Nr, når scenarioet bygger på en testcase>
    Scenario: <tittelen i kravet>
      Gitt jeg er logget inn som «<testbruker-nøkkel>»
      Og jeg har åpnet «<menyvei eller URL>»
      Og <testdata> «<testdata-nøkkel>» er opprettet
      Når jeg <én handling, skjermens ord i «»>
      Og jeg <neste handling>
      Så ser jeg «<tekst eller antall agenten kan se>»
      Og <noe synlig eller ikke synlig>

    @endrer-data
    Scenario: <tittelen i kravet>
      Gitt …
      Når jeg lagrer
      Og jeg åpner siden på nytt
      Så står «<verdien>» der
      # Setter tilbake:
      Og jeg <avsluttende steg som setter tilbake>

    # Teknikk: grenseverdianalyse (tomt, bare mellomrom, maks lengde, maks + 1)
    @utledet
    Scenario: <tittelen på regelen>: «<felt>» <hva som prøves, for eksempel står tomt>
      Gitt …
      Når jeg fyller ut alle andre obligatoriske felt, og lar «<felt>» stå tomt
      Og jeg velger «Lagre»
      Så ser jeg «<feilmeldingen>» ved «<felt>»
      Og «<felt>» er det eneste feltet under «<overskriften over feilene>»

    Scenariomal: <tittelen i kravet>
      Gitt …
      Når jeg velger «<verdi>» i «<felt>»
      Så ser jeg «<resultat>»

      Eksempler:
        | verdi | resultat |
        | …     | …        |
```

- **`@utledet`** er en testcase agenten har utledet fra regelen, ikke fra et scenario i kravet. Tittelen er regelens tittel, kolon, og hva som prøves. `# Teknikk:` over scenarioet sier hvilken teknikk som er brukt (grenseverdianalyse, ekvivalensklasser, beslutningstabell eller tilstandsoverganger). Scenarioene fra kravet har ingen `# Teknikk:`.
- **Én feilsituasjon prøver én ting:** alle andre obligatoriske felt er fylt ut, så det er feltet testcasen handler om som stopper lagringen. Et forhåndsutfylt felt tømmes («Fjern tallet i «<felt>»»), det «står» ikke tomt.
- **Testdata:** `Gitt` sier hvilken tilstand dataene har (utgangstilstanden i `Krever` og i testplanen). Hvordan de lages, står ikke i testen. Data scenarioet selv lager, har et unikt navn per kjøring når de ikke kan slettes.
- `@TST-…`: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti (neste ledige løpenummer i mappa), `@TST-<prosess>-<test>-NNN` for `_Løp`.
- **En flyt** (`_Løp/<NN Prosess>/<samme filnavn som flyten>.feature`): `# Flyt: krav/_Flyter/<NN Prosess>/<fil>.feature @ <commit> (blob <hash>)` i stedet for `# Krav:`, `@depends-on-FLY-…` på `Egenskap:`, og fasens `@depends-on-` på hver `Regel:`. `Gitt` har tilstanden som en testdata-nøkkel: `Og søknaden «<testdata-nøkkel>» har fått tilbudsgaranti i tidligopptaket`.
- `@depends-on-<Feature-ID>` (uten `@` i ID-en) på `Egenskap:`. Bygger en `Regel:` eller et `Scenario:` også på et annet krav, får delen en egen tagg. `@ref-<Feature-ID>` for et krav testen bare bruker som forutsetning.
- Ingen `@draft`, `@planned`, `@in-progress`, `@implemented`, `@deprecated` eller `@scope-`.
- Ingen navn, Feide-ID, `testbruker <nr>`, passord eller URL til miljøet.

## README.md i mappa

`cdp-tester/<sti>/README.md`

```markdown
# CDP-tester: <kapabiliteten>

Tester for <kravene i mappa>. Kravene: [<fil>.feature](<relativ lenke til kravfila>) (`@<Feature-ID>`).

## Krever

| Nøkkel | Type | Beskrivelse | Brukes av |
|---|---|---|---|
| `<nøkkel>` | testbruker | <rolle og organisasjon som beskrivelse, ikke navn> | alle scenarioer / «<scenario>» |
| `<nøkkel>` | testdata | <utgangstilstand, for eksempel «minst 51 personbrukere synlige for testbrukeren»> | «<scenario>» |

## Ikke kjørbart

| Scenario | Grunn | Kan kjøres når |
|---|---|---|
| «<tittel i kravet>» | <ikke synlig i skjermen / mangler testdata / ikke funnet i verifiseringen / …> | <hva som må på plass> |

Ingen.      <når tabellen er tom>
```

## Resultat av en kjøring

`akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (med leveranse), eller `cdp-tester/<sti>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (uten). Skjermbilder i samme mappe, men ignorert av git (`.gitignore`): bare `resultat.md` committes, så «Bevis» viser til bildene som «lokalt, ikke i git».

```markdown
# Kjøring <YYYY-MM-DD HH:MM>: <leveranse eller kapabilitet>

- **Testplan**: [testplan.md](<sti>) | –
- **Miljø**: <URL, versjon, flagg>   (fra testplanen eller oppgitt av brukeren)
- **Tester**: <filene i cdp-tester/ som er kjørt>
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat»
- **Kjente mangler**: <sak: status sjekket <dato>, testcasene> | Ingen   (R16)
- **Krav**: commit `<sha>`
- **Kjørt av**: <agent> for <bruker>
- **Testdata**: <hva som ble opprettet (manuelt/API), og at det er ryddet / satt tilbake>
- **Hoppet over**: <N> med `[Fylles ut]`, <N> ikke kjørbare, <N> `@endrer-data` (bare når miljøet ikke kan settes tilbake)

---

| Test (`@TST-…`) | Regel | Scenario | Teknikk | Foreslått status | Input | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|---|---|
| `@TST-BRU-PER-GRU-001` | <regel> | <scenario> | – (fra kravet) / <teknikken for `@utledet`> | Bestått / Ikke bestått / Ikke testet | <verdiene som ble skrevet inn> | <det agenten så: tekst, antall> | <de konkrete stegene> | <tekst fra siden, og skjermbilde `<fil>.png` (lokalt, ikke i git)> |

## Funn

| Nr | Test | Type | Hva skjedde | Forventet | Steg for å gjenskape | Bevis |
|---|---|---|---|---|---|---|
| F1 | `@TST-…` | Feil / Kravet dekker ikke | <det agenten så> | <hva kravet sier, eller «kravet sier ikke noe om tilfellet»> | <stegene> | <bevis> |

«Kravet dekker ikke» er en `@utledet` testcase der løsningen oppfører seg uventet, og kravet ikke sier noe om tilfellet. Det avklares i kravet (`fs-krav`), ikke bare i testen. «Fase funnet» er 2. En tester gir alvorlighetsgrad (`alvorlighetsgrad.md`).

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene før `fs-testrapport` (agentisk) teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten, og kan ikke godkjenne leveransen.
```

- «Foreslått status» bruker de samme tre verdiene som testcasene: `Bestått`, `Ikke bestått` og `Ikke testet` (med en kort begrunnelse i «Faktisk resultat»).
- Bevisene per testcase er steg, input, faktisk resultat og skjermbilde eller logg, så et menneske kan etterprøve resultatet. Tekst og DOM er primærbevis.
- Nøkkelen `Test | Regel | Scenario` er den samme som i referansene til kravene, så `fs-testrapport` kan telle per krav og regel.
