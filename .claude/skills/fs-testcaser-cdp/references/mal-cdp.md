# Maler: CDP-tester

Tre filer: testfila (`<test>.feature`), `README.md` i mappa («Krever» og «Ikke kjørbart»), og resultatet av en kjøring (`resultat.md`). Konvensjonene står i [`cdp-tester/README.md`](../../../../cdp-tester/README.md).

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
      Og <testdata> «<testdata-nøkkel>» finnes
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

    Scenariomal: <tittelen i kravet>
      Gitt …
      Når jeg velger «<verdi>» i «<felt>»
      Så ser jeg «<resultat>»

      Eksempler:
        | verdi | resultat |
        | …     | …        |
```

- `@TST-…`: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti (neste ledige løpenummer i mappa), `@TST-<prosess>-<test>-NNN` for `_Løp`.
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
- **Krav**: commit `<sha>`
- **Kjørt av**: <agent> for <bruker>
- **Hoppet over**: <N> `@endrer-data`, <N> med `[Fylles ut]`, <N> ikke kjørbare

---

| Test (`@TST-…`) | Regel | Scenario | Foreslått status | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|
| `@TST-BRU-PER-GRU-001` | <regel> | <scenario> | Bestått / Ikke bestått / Ikke testet | <det agenten så: tekst, antall> | <de konkrete stegene> | <tekst fra siden, og skjermbilde `<fil>.png` (lokalt, ikke i git)> |

## Funn

<Det som ikke stemte, med scenario, hva agenten så, og hva kravet sier. En tester gir alvorlighetsgrad.>

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den før `fs-testrapport` teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten.
```

- «Foreslått status» bruker de samme tre verdiene som testcasene: `Bestått`, `Ikke bestått` og `Ikke testet` (med en kort begrunnelse i «Faktisk resultat»).
- Nøkkelen `Test | Regel | Scenario` er den samme som i referansene til kravene, så `fs-testrapport` kan telle per krav og regel.
