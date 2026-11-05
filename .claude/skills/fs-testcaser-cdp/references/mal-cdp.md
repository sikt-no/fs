# Maler: CDP-tester

Fire filer (fase 2, den agentiske funksjonstesten): testfila (`<test>.feature`), oppsettet (`_Oppsett/<sti>/oppsett.feature`), `README.md` i mappa («Krever»), og resultatet av en kjøring (`resultat.md`). Konvensjonene står i [`cdp-tester/README.md`](../../../../cdp-tester/README.md).

## Testfila

`cdp-tester/<kravets sti under krav/>/<samme filnavn som kravet>.feature`

```gherkin
# language: no
# Generert av fs-testcaser-cdp <YYYY-MM-DD>
# Krav: krav/<sti>/<fil>.feature @ <commit> (blob <hash>)
@TST-<DOM>-<SUB>-<KAP>-NNN @depends-on-<Feature-ID>
Egenskap: <tittelen i kravet>
  <samme beskrivelse som i kravet, eller en linje om hva testene sjekker>

  Regel: <tittelen i kravet>

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
- **Testdata:** `Gitt` sier hvilken tilstand dataene har, med nøkkelen. Dataene lages av oppsettet i kjøringen (eller er grunndata i miljøfila), og hvordan de lages, står ikke i testen. Data scenarioet selv lager, har `{KJØRING}` i navnet.
- `@TST-…`: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti (neste ledige løpenummer i mappa), `@TST-<prosess>-<test>-NNN` for `_Løp`.
- **En flyt** (`_Løp/<NN Prosess>/<samme filnavn som flyten>.feature`): `# Flyt: krav/_Flyter/<NN Prosess>/<fil>.feature @ <commit> (blob <hash>)` i stedet for `# Krav:`, `@depends-on-FLY-…` på `Egenskap:`, og fasens `@depends-on-` på hver `Regel:`. `Gitt` har tilstanden som en testdata-nøkkel: `Og søknaden «<testdata-nøkkel>» har fått tilbudsgaranti i tidligopptaket`.
- `@depends-on-<Feature-ID>` (uten `@` i ID-en) på `Egenskap:`. Bygger en `Regel:` eller et `Scenario:` også på et annet krav, får delen en egen tagg. `@ref-<Feature-ID>` for et krav testen bare bruker som forutsetning.
- Ingen `@draft`, `@planned`, `@in-progress`, `@implemented`, `@deprecated` eller `@scope-`.
- Ingen navn, Feide-ID, `testbruker <nr>`, passord eller URL til miljøet.
- Organisasjoner i stegene som `{ORG:<nøkkel>}`, `{ORGNAVN:<nøkkel>}` eller `{ORGKODE:<nøkkel>}`, slått opp i miljøfila: `Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}»`.
- Bare det som varer: ingen kravstatus, kjente mangler, saker med status, datoer fra verifiseringen eller kjøringer, henvisninger til en testplan eller testcaser i den, eller verdier fra ett miljø (se «Bare det som varer» i `cdp-tester/README.md`).

## Oppsettet

`cdp-tester/_Oppsett/<samme sti som testene>/oppsett.feature`. Ett scenario per testdata-nøkkel testene i mappa bruker.

```gherkin
# language: no
# Oppsett for testene i cdp-tester/<sti>/ (samme sti under _Oppsett/)
#
# Kjøres først i hver kjøring. Lager testdataene gjennom løsningen, med {KJØRING} i navnene. Agenten skriver
# navnet og URL-en til det som er laget, i «Kjøringens testdata» i resultat.md. Feiler et scenario, får nøkkelen
# ingen verdi, og testene som bruker den, blir «Ikke testet».
# {DATO:+N} er datoen N dager etter dagen kjøringen starter, og {DATO:-N} N dager før.
#
# Utfylling O: <det felles skjemaet, med alle feltene og verdiene>
@OPPSETT-<DOM>-<SUB> @ref-<Feature-ID>
Egenskap: Oppsett for <kapabiliteten eller sub-domenet>
  Lager <dataene> testene for <…> bruker, i utgangstilstanden testene forutsetter.

  Scenario: <testdata-nøkkel>
    Gitt jeg er logget inn som «<testbruker-nøkkel>»
    Når jeg fyller ut som i Utfylling O, med navnet «<navn> (test {KJØRING})»
    Og <de andre stegene som gir utgangstilstanden>
    Så <noe agenten ser, som viser at tilstanden er riktig>
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «<testdata-nøkkel>»
```

- Tittelen på scenarioet er nøkkelen. Beskrivelsen av utgangstilstanden er stegene, og står ikke i miljøfila.
- Bytter scenarioet testbruker, bytter det tilbake til slutt.
- Data oppsettet ikke kan lage gjennom løsningen, står som nøkkel i miljøfila (`[Fylles ut]`), med en kommentar i oppsettet om hvorfor.

## README.md i mappa

`cdp-tester/<sti>/README.md`. Ikke noe mer enn dette: det som gjelder alle testene, står i `cdp-tester/README.md`, og hva nøklene krever, står i miljøfila.

```markdown
# CDP-tester: <kapabiliteten>

Tester for kravet [<fil>.feature](<relativ lenke til kravfila>) (`@<Feature-ID>`), i `<fil>.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `<rolle>-<relasjon>` | testbruker | alle scenarioer / «<scenario>» |
| `<nøkkel>` | testdata (oppsett) | «<scenario>» |
| `<nøkkel>` | testdata | «<scenario>» (grunndata, eller data testene ikke kan lage) |
```

## Resultat av en kjøring

Der den som starter kjøringen sier, ellers `cdp-tester/<mappa med testene>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (se *Kjøring og resultat* i `cdp-tester/README.md`). Skjermbilder i samme mappe, men ignorert av git (`.gitignore`): bare `resultat.md` committes, så «Bevis» viser til bildene som «lokalt, ikke i git».

```markdown
# Kjøring <YYYY-MM-DD HH:MM>: <leveranse eller kapabilitet>

- **Startet av**: <hvem, og hva som valgte testene: en testplan, en mappe, en liste>
- **Miljøfil**: [<miljø>.md](<sti>), personaer sist sjekket <dato>
- **Miljø**: <URL, versjon, flagg>   (fra miljøfila)
- **Kravstatus**: <Feature-ID: status, når et krav ikke er `@implemented`> | Alle `@implemented`
- **Utdaterte tester**: <testfil: blob-hashen er ulik kravfila> | Ingen
- **Tester**: <filene i cdp-tester/ som er kjørt>
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat»
- **Kjente mangler**: <sak: status sjekket <dato>, testcasene> | Ingen   (R16, bare når den som starter kjøringen har gitt en liste)
- **Krav**: commit `<sha>`
- **Kjørt av**: <agent> for <bruker>
- **Oppsett**: <_Oppsett/<sti>/oppsett.feature>, kjørt <tidspunkt>. <N av N nøkler laget> | <nøkkel: feilet, grunnen>
- **Hoppet over**: <N> `@endrer-data` (bare når miljøet ikke kan settes tilbake) | Ingen
- **Endringer i miljøfila**: <nøkkel: verdien som ikke stemte, og forslaget> | Ingen

## Kjøringens testdata

Fra oppsettet. Testene i kjøringen slår opp nøklene her.

| Nøkkel | Navn | URL | Laget av |
|---|---|---|---|
| `<testdata-nøkkel>` | «<navn> (test <KJØRING>)» | <URL> | `<testbruker-nøkkel>` |

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
