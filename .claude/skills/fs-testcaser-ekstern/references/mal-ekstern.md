# Mal: Ekstern akseptansetest

For erfarne brukere fra lærestedene og andre eksterne parter, for eksempel HK-dir i opptak. De gjennomfører testen, og Sikt legger til rette og leder. Den er lettere enn den interne med vilje: testerne skal komme raskt i gang, og skal ikke trenge bakgrunnen for leveransen.

Fra [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), fase 4:

- **Mål:** de eksterne partene bekrefter at de kan gjøre jobben sin i flytene leveransen skal understøtte: at hvert steg virker, og at stegene henger sammen.
- **Grunnlag:** kravene våre for flytene som testes. Sikt går gjennom de relevante kravene med partene i et møte før testen, eller sender dem skriftlig informasjon. Testen vurderer ikke om kravene er riktige: behov kravene ikke dekker, er endringsforslag. Partene kan legge til egne testcaser når de har egne krav, for eksempel HK-dir.
- **Før testen:** leveransen er godkjent internt og lagt ut i testmiljøet. Kravene er gått gjennom med partene. Testbeskrivelsen er klar. Testdataene er laget på forhånd, i tilstanden flytene forutsetter, og testmiljøet nullstilles ikke i testperioden. Hvem som beslutter, er avtalt med partene. Klart når kontaktpersonen har logget inn som hver testbruker og ser testdataene.
- **Sikt leverer:** gjennomgangen av kravene for flytene, i møte eller skriftlig. Informasjonsskrivet til eksterne testere. Testbeskrivelsen. Testmiljø, testdata og testbrukere. Flytene, laget med fs-testcaser-ekstern. Rapportene fra fase 2 og 3, slik at partene ser hva som er testet.
- **Hvilke scenarioer:** flytene i `krav/_Flyter` som leveransen inngår i, laget ut fra flyttestene i fase 3. Sikt velger flytene sammen med partene.
- **Hvor grundig:** hvert steg i flyten skal virke, og stegene skal henge sammen: endringen er lagret, står der når saken åpnes igjen, og blir brukt i neste steg. Enkeltfunksjoner, feltvalidering og feilmeldinger testes ikke, utenom det som er en del av flyten. Roller og tilgang er verifisert i fase 1. Universell utforming og regresjon testes ikke her.
- **Rekkefølge:** rekkefølgen i arbeidsprosessen. Testeren går videre til neste steg når det forrige virker.
- **Gjennomføring:** samme maler og alvorlighetsgrader som i den interne testen. Testerne svarer Ja, Nei eller Delvis per steg. Kontaktpersonen fører det som bestått (Ja) eller ikke bestått med funn (Nei og Delvis). Et steg testeren ikke kom fram til, føres som ikke testet, med begrunnelse.
- **Funn:** **Feil**, der flyten ikke lar testeren gjøre jobben, eller løsningen avviker fra kravene Sikt har gått gjennom, og **Endringsforslag**, behov flyten ikke dekker. Testerne trenger ikke finne årsaken. Observasjoner utenfor testens omfang merkes slik.

Og:

- **Ordene stemmer med [informasjonsskrivet](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155815432)**: flyt, steg, Ja/Nei/Delvis, feil, endringsforslag, kontaktperson, og de tre utfallene.
- **Ingen intern informasjon:** Feature-ID-er, scope-id-er, tagger, commits, Jira, GitHub, kodeverdier og verify-resultater. Feature-flagg står bare i testbeskrivelsen. Sporingen står i metadataene.
- **Kort.** Sikt mot høyst 10 testcaser og under én time. Blir det mer, foreslå å dele i flere økter.

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `akseptansetest/<testplan-slug>/testcaser-ekstern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Flytbeskrivelsene og gjennomgangen av kravene står i en egen fil, `flytbeskrivelser-ekstern.md` (malen står under).

```markdown
# Ekstern akseptansetest – <leveranse>

- **Nivå**: ekstern (fase 4)
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …]
- **Krav**: <N> feature-filer, commit `<sha>` (<YYYY-MM-DD>)
- **Flyter**: `@FLY-PRO-FLY-NNN`[, …], valgt sammen med <partene>
- **Bygger på**: [intern akseptansetest](testcaser-intern.md), [testrapport](testrapport-intern-<dato>.md): <utfall>, [agentisk testrapport](testrapport-agentisk-<dato>.md)
- **Flytbeskrivelser og krav**: [flytbeskrivelser-ekstern.md](flytbeskrivelser-ekstern.md)
- **Gjennomgang av kravene**: møte <dato> | skriftlig, sendt <dato> | [Fylles ut]
- **Testere**: <HK-dir, læresteder>
- **Kontaktperson**: <navn, normalt testansvarlig>
- **Hvem beslutter**: <avtalt med partene> | [Fylles ut: avtales med partene før testen]
- **Testmiljøet**: nullstilles ikke i testperioden <fra–til>, avtalt med <drift> | [Fylles ut: avtalt med drift]
- **Testdata som må lages før testen**:

  | Testdata | Tilstand | Brukes i | Lages av | Laget |
  |---|---|---|---|---|
  | <opptak, søker, søknad> | <tilstanden flyten forutsetter> | 1a | <navn> | |

- **Klar til test** (krysses av av kontaktpersonen):
  - [ ] Leveransen er godkjent internt og lagt ut i testmiljøet
  - [ ] Kravene er gått gjennom med partene
  - [ ] Testbeskrivelsen er klar
  - [ ] Testdataene er laget, og testmiljøet nullstilles ikke i testperioden
  - [ ] Hvem som beslutter, er avtalt med partene
  - [ ] Kontaktpersonen har logget inn som hver testbruker og ser testdataene
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-ekstern
- **Sporing**:

  | Nr | Steg i flyten | Feature-ID | Scenario | Intern |
  |---|---|---|---|---|
  | 1 | a | `@DOM-SUB-KAP-NNN` | <scenariotittel fra kravet> | 1.1 |
  | 1 | b | `@FLY-PRO-FLY-NNN` | <fasen>: <scenariotittel fra flyten> | 4.1 |

---

Velkommen til akseptansetesten av <leveranse>. I testen sjekker du om du kan gjøre jobben din i flytene løsningen skal understøtte: at hvert steg virker, og at stegene henger sammen. Les [Informasjonsskriv til eksterne testere](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155815432) før du starter. Hva løsningen skal gjøre, står i [kravene for flytene](<url til flytbeskrivelsene>), som Sikt har gått gjennom med dere.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | <2–3 setninger med vanlige ord: hva du kan gjøre, og hvor i løsningen> |
| Versjon | <versjonen i testmiljøet> |
| Flytene som testes | - <flyten med vanlige ord> <br>- <…> |
| Hvor du tester | <miljø>: [<url>](<url>) |
| Feature-flagg som er slått på | <navnet testerne ser, eller «Ingen»> |
| Testbrukere og roller | - Testbruker <nr>: <navn>, <rolle> ved <organisasjon> <br>- <…> |
| Testdata | - <hva som finnes, og i hvilken tilstand> <br>- <…> |
| Avhengigheter | <integrasjoner eller batchjobber flytene trenger, og når de kjører, eller «Ingen»> |
| Dette kan du ikke gjøre i testen | - <kort> <br>- <…> |
| Tid | Ca. <N> minutter. Frist: <dato> |
| Kontaktperson | <navn>. Spørsmål underveis tas på <e-post / telefon / møte>, som avtalt |
| Hvem beslutter | <avtalt med partene> |

Mangler en testbruker eller testdata, si fra til kontaktpersonen før du starter.

## Slik fyller du ut

1. Følg hver flyt steg for steg, slik du ville gjort det i arbeidet. Gå videre til neste steg først når det forrige virker.
2. Svar på om steget fungerte som forventet: **Ja**, **Nei** eller **Delvis**. Sjekk at endringen er lagret, at den står der når du åpner saken igjen, og at neste steg bruker det du registrerte.
3. Virker ikke et steg, eller lar flyten deg ikke gjøre jobben, er det et funn. Prøv deg fram på en annen måte bare hvis det er nødvendig for å komme videre, og skriv ned hva du gjorde. Kom du ikke fram til et steg, la svaret stå tomt, og skriv hvorfor.
4. Ved Nei eller Delvis: skriv i «Funn» hva du gjorde, hva du forventet og hva du fikk, så en annen kan gjøre det samme og se det samme. Ta skjermbilde hvis du kan, og gi funnet en alvorlighetsgrad. Velg «Feil» når flyten ikke lar deg gjøre jobben, eller løsningen avviker fra det Sikt har informert om, og «Endringsforslag» når flyten ikke dekker et behov du har. Du trenger ikke finne årsaken. Er du usikker på om noe er feil, beskriv det, og la kontaktpersonen vurdere det.
5. Ser du andre ting underveis, for eksempel om brukervennlighet, skriv dem i «Andre funn», merket som utenfor testens omfang.
6. «Status» fylles ut av kontaktpersonen.

## Testcaser

### <Nr>. <Flyten med vanlige ord> (ca. <N> minutter)

**Hensikt:** <hva testeren skal få gjort, og hvorfor det er viktig i arbeidsprosessen>

**Testdata:** testbruker <nr> (<navn>, <rolle> ved <organisasjon>). Finnes fra før: <data og tilstand>. Lager: <data de neste stegene bruker>.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| <Nr>a | <med vanlige ord> | 1. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>2. Gå til «…». <br>3. … | <det du ser, og at det står der når du åpner saken igjen> | | | |
| <Nr>b | <med vanlige ord> | 4. … <br>5. … | <det du ser, og at det du registrerte i <Nr>a, er brukt> | | | |

## Testcaser fra partene

<Tom ved utsendelse. Partene som har egne krav, legger inn egne testcaser her, med samme tabell og kolonner som over.>

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Enkeltfunksjoner, feltvalidering og feilmeldinger | Testet tidligere, i teamets egen testing og i Sikts interne akseptansetest |
| Roller og tilganger | Kontrollert i koden før testen |
| Universell utforming og regresjon | Gjøres på andre måter |
| <med vanlige ord> | <kommer senere / gjelder ikke dere> |

## Funn

| # | Testcase | Fase funnet | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|
| | | 4. Ekstern | <Feil / Endringsforslag> | | | | | | |

<Tabellene «Funntype» (radene for fase 4) og «Alvorlighetsgrad» fra `alvorlighetsgrad.md`, ordrett. Et endringsforslag går til kravarbeidet, der Sikt vurderer om det skal følges opp raskt eller vente, og har ikke alvorlighetsgrad «Stopper» uten at partene sier det.>

## Andre funn (utenfor testens omfang)

Her skriver du det du ser som ikke er en del av flytene, for eksempel om brukervennlighet. Kontaktpersonen vurderer hvor det følges opp.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |

## Når testen er ferdig

Dere konkluderer med ett av tre utfall: **godkjent**, **godkjent med forbehold** eller **ikke godkjent**, vurdert mot flytene og kravene. Godkjent med forbehold betyr at kjente mangler listes med ansvarlig og frist. Ikke godkjent betyr at leveransen går tilbake til teamet med funnene. Kontaktpersonen går gjennom resultatet med dere.
```

## Nummerering

- Testcasene nummereres fra 1, én per flyt (eller del av en flyt). Stegene i flyten (ett scenario hver) får bokstav: `1a`, `1b`, `1c`.
- Stegene i «Slik gjør du det» løper gjennom hele testcasen, så `1b` fortsetter der `1a` slapp.
- Delene står i rekkefølgen i flyten. Scenarioet i flyten er en egen del, og står i sporingen med flyt-ID-en og fasen.
- Sporingen har en rad per del. Feature-ID-ene står bare i metadataene, ikke på siden til partene.

## Status fra svaret

Kontaktpersonen fyller ut «Status» fra svaret til testeren. `fs-testrapport` teller «Status», og bruker svaret når «Status» er tom:

| Svar fra testeren | Status |
|---|---|
| Ja | Bestått |
| Nei | Ikke bestått, med funn |
| Delvis | Ikke bestått, med funn |
| Tomt, testeren kom ikke fram til steget | Ikke testet, med begrunnelsen i «Hva du gjorde og så» |

## Flytbeskrivelser og kravene til partene

Gjennomgangen av kravene for flytene, i skriftlig form, og oversikten over hva Sikt har testet. Den gis til partene før testen, og er underlaget når gjennomgangen er et møte. Fila skrives til `akseptansetest/<testplan-slug>/flytbeskrivelser-ekstern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Siden har ingen Feature-ID-er, scope-id-er, tagger, Jira-saker eller kodeverdier.

```markdown
# Flytbeskrivelser til partene – <leveranse>

- **Nivå**: ekstern (fase 4), vedlegg til testcaser-ekstern.md
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Bygger på**: [testcaser-intern.md](testcaser-intern.md), flytene i «Flyter» i testplanen, kravene flytene bygger på, og rapportene: [verifisering](<fil>), [agentisk](testrapport-agentisk-<dato>.md), [intern](testrapport-intern-<dato>.md)
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-ekstern
- **Sporing**:

  | Beskrivelse | Flyt | Krav | Testcase intern |
  |---|---|---|---|
  | <tittel på siden> | `@FLY-PRO-FLY-NNN` | `@DOM-SUB-KAP-NNN`[, …] | 1 |

---

Flytbeskrivelser og krav for <leveranse>. Her ser du hvilke flyter som testes, hva løsningen skal gjøre i hvert steg, og hva Sikt allerede har testet. Testen vurderer ikke om kravene er riktige: mener du at kravene mangler noe, er det et endringsforslag. Er du usikker på noe i kravene, si fra til kontaktpersonen før du begynner.

## <Flyten med vanlige ord, f.eks. «Fra opprettet opptak til tilbud»>

**Hva flyten handler om:** <2–3 setninger med vanlige ord>

| Steg | Hvem | Hva skjer | Hva neste steg bruker |
|---|---|---|---|
| 1 | <rolle med vanlige ord> | <hva brukeren gjør og ser> | <det som er laget, og som neste steg bruker> |

**Hva løsningen skal gjøre:**

| Steg | Kravet med vanlige ord |
|---|---|
| 1 | <én linje per regel i kravet steget bygger på> |

**Dette kan du ikke gjøre i testen:** <kjente mangler som berører flyten, uten saksnummer, eller «Ingen»>

## Hva Sikt har testet

| Fase | Hva | Utfall | Funn som står igjen |
|---|---|---|---|
| Kontroll av at alt er laget | <N> av <N> funksjoner funnet i løsningen, og roller og tilganger kontrollert | <klar / ikke klar> | <kort, eller «Ingen»> |
| Funksjonstest (agent) | <N> testcaser, med gyldige og ugyldige data, og feilmeldinger | <utfall> | <kort, eller «Ingen»> |
| Intern akseptansetest | <N> flyter og arbeidsoppgaver testet av domeneekspertene | <utfall> | <kort, eller «Ingen»> |

Rapportene: [funksjonstesten](<url>), [den interne testen](<url>).
```
