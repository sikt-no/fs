# Verifisering: @OPT-BEH-BEH-007 — Gi tilbudsgaranti ved tidlig opptak (to scenarioer)

- **Dato:** 2026-11-13 15:00
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, a6a60fc203, lest fra origin/main: lokal branch er STEK-267-tidligopptak-er-aktiv-filter), `fs-admin` (origin/main, 001905df5, lest fra origin/main: lokal main er 156 bak)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 1 MR i fs-admin, 0 i fs-plattform (0 med kode for scenarioene)
- **Omfang:** to scenarioer, uansett status: «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» og «Se antall utdanningstilbud med mangelfulle innstillinger» (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5194317873

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `TTS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `UV2` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak-tilbudsgaranti-automatikk.graphqls`
- `KTB` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx`
- `TRM` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx`
- `MSG` = `fs-admin/src/common/messages/nb/plasstildeling.json`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 2 funnet, 0 ikke funnet, 0 usikker, av 2
- Mangler: fs-plattform 0 scenarioer, fs-admin 0
- Forslag: 1 kan leveres, 0 delvis levert, 0 kan slettes, 0 kan leveres når det er avklart, 0 blir stående
- Tilgang og datakonsistens: 1 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 1
- Regler i koden uten scenario: 6
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 6 utenfor gating (`@draft`)
- Endringer gjort: 1 krav og 0 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Kan leveres**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`): `@in-progress` → `@implemented`, 2/2 funnet i denne kjøringen, og de andre 27 scenarioene i gating-settet er `@implemented` fra før; `@implemented` fjernes fra delene `[P ✓ · A ✓]` — bygger på `@OPT-OPT-UTD-004`, som er `@draft`

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | `@in-progress` → `@implemented`, og `@implemented` fjernet fra 6 deler | ja i kjøringen |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 2/2 | 0 | 0 | |

Ingen av kravene mangler noe.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense | funnet | P ✓ · A ✓ — `TTS:323-326`, `UV2:85-101`, `TTS:389`, `TTS:136`, `KTB:101-106`, `TRM:130-142`, `MSG:348` |
| `@OPT-BEH-BEH-007` | Se antall utdanningstilbud med mangelfulle innstillinger | funnet | P ✓ · A ✓ — `TTS:383-440`, `KTB:101-106`, `TRM:130-142`, `MSG:348`. Kjent unøyaktighet: tallet teller avvik, ikke utdanningstilbud (se `## Regler uten scenario`) |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

Ingen.

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter hos forvalteren prøvekjører og gjennomfører tidligopptaket | stemmer | `TTS:104-108`, `KTB:42-47`, `KTB:72-78` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | «Feilkonfigurerte utdanningstilbud» teller avvik, ikke utdanningstilbud: et utdanningstilbud med flere mangler telles én gang per mangel, og overskredet kvote (`KVOTEANDEL_OVERSKREDET`) telles med. Kjent unøyaktighet, akseptert: det viktigste er at tallet ikke er 0 når noe mangler | annet | `TTS:383-440`, `TTS:428-436`, `TRM:140` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Merket «Konfigurasjonsavvik» står ved tallet når det er over 0: advarsel i prøvekjøringen, kritisk etter gjennomføringen | annet | `TRM:135-139`, `MSG:351` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Dialogen blir stående med resultatet etter gjennomføringen («Resultat for tidligopptak»), med «Lukk» og uten knapp for å kjøre igjen | tilstandsovergang | `TRM:182-188`, `TRM:223-225`, `MSG:359` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Med poenggrenser som ikke er lagret, blir det ingen prøvekjøring: dialogen ber opptaksforvalter lagre dem først, og «Kjør tidligopptak» er inaktiv | validering | `KTB:101-106`, `TRM:174-178`, `TRM:194-197`, `MSG:362` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud gir ingen avvik | annet | `TTS:363` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Bare utdanningstilbud som tilbyr tidlig opptak, sjekkes for mangler | annet | `TTS:362` | testes i fase 2 |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 0 av 2 | 0 av 2 | 6 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3419 feat(plasstildeling): STEK-489 tidlig opptak poenggrenser in EditList (`patsle/STEK-489-feat-tidlig-opptak-editlist`) | åpen | `@OPT-BEH-BEH-007` | 0/2 | usikker kobling: gjelder redigeringen av poenggrensene, ikke de to scenarioene. Endringene i resultatdialogen er allerede på main (`ef7611a9e`) |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet dekker ikke | `@OPT-BEH-BEH-007` | «Se antall utdanningstilbud med mangelfulle innstillinger» (`krav/…:442`) | Tallet er antall avvik, ikke antall utdanningstilbud, og tar med overskredet kvote, `TTS:383-440`, `TRM:140`. Akseptert som kjent unøyaktighet |
| Kontrollen endret | `@OPT-BEH-BEH-007` | `## Tilgang og datakonsistens` | ingen rad → 1 rad: prøvekjøringen som begge scenarioene bruker, har tilgangssjekk (`TTS:104-108`, `KTB:42-47`) |
| Kontrollen endret | `@OPT-BEH-BEH-007` | `## Regler uten scenario` | 3 regler lagt til: ulagrede poenggrenser, kansellerte utdanningstilbud, og bare utdanningstilbud som tilbyr tidlig opptak |
| Bygger på krav som ikke er levert | `@OPT-BEH-BEH-007` | – | bygger på `@OPT-OPT-UTD-004` (`@draft`) |
| Merknad | `@OPT-BEH-BEH-007` | «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» (`krav/…:409`) | Overskredet kvote telles med i tallet (`TTS:428-436`). Får utdanningstilbudet med median tilbudsgarantier over varselandelen av kvoten, også fra en tidligere gjennomføring, viser tallet 1. Testdataene må ta høyde for det |
| Merknad | `@OPT-BEH-BEH-007` | «Se antall utdanningstilbud med mangelfulle innstillinger» (`krav/…:442`) | Tallet blir 1 bare når utdanningstilbudet har rangeringsregelverk, kompetanseregelverk og kvote. Scenarioet sier bare at de andre utdanningstilbudene er i orden |
| Merknad | `@OPT-BEH-BEH-007` | «Reservert studieplass fra opptaksforvalter blir erstattet» og «Tidligopptakstilbud fra tilbyder gjelder også uten søknad om tidlig opptak» | Lagt til 2026-11-13 under den leverte regelen «Opptaksforvalter gjennomfører tidligopptaket». Reglene ble funnet i koden og bekreftet av kontrollen i verifiseringen 2026-11-09 (regler uten scenario), og er ikke verifisert på nytt her |
| Merknad | – | `GQL:119` | Schemaet ligger under `features/experimental/`. Ikke sjekket om det er med i supergrafen i alle miljøer |
