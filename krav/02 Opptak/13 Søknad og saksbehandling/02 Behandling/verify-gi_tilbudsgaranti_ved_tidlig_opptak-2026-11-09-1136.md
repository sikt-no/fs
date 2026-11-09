# Verifisering: Gi tilbudsgaranti ved tidlig opptak

- **Dato:** 2026-11-09 11:36
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, 1f07615d7a, lest fra origin/main: lokal main er 36 bak og har 19 endringer som ikke er committet), `fs-admin` (origin/main, 7df232046, lest fra origin/main: lokal main er 78 bak)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** ingen med kode for kravet (sjekket i fs-plattform og fs-admin)
- **Omfang:** `@in-progress` (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei (spørsmålet ble hoppet over)
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180653598

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `TTS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `UV2` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak-tilbudsgaranti-automatikk.graphqls`
- `STS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java`
- `OKA` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/algoritme/Opptakskjoringsalgoritme.java`
- `KTB` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx`
- `TRM` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx`
- `TGS` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx`
- `MSG` = `fs-admin/src/common/messages/nb/plasstildeling.json`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 25 funnet, 2 ikke funnet, 0 usikker, av 27
- Mangler: fs-plattform 0 scenarioer, fs-admin 2 (0 usikker)
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 0 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 4 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 4
- Regler i koden uten scenario: 12
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 6 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 5 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`, 25/27 funnet): `@implemented` på Regel: Opptaksforvalter gjennomfører tidligopptaket (linje 170, og `@implemented` fjernes fra Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak, linje 346), Scenario: Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak (linje 362), Scenario: Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak (linje 380), Scenario: Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon (linje 410), Scenario: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (linje 485) `[P ✓ · A ✓]` — bygger på `@OPT-OPT-UTD-004`, som er `@draft`. Regelen «Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket» er `@implemented` fra før.

**Blir stående**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`@in-progress`, 25/27 funnet): 2 ikke funnet: «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» og «Se antall utdanningstilbud med mangelfulle innstillinger». Prøvekjøringen i fs-admin viser ikke avvikene · mangler i fs-admin (2)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Regel: Opptaksforvalter gjennomfører tidligopptaket | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | `@implemented` fjernet (dekket av regelen) | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | `@implemented` på delen | ja i kjøringen |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 25/27 | 0 | 2 | fs-admin: antall utdanningstilbud med mangelfulle innstillinger i prøvekjøringen |

Mangler: fs-plattform 0 scenarioer i 0 krav, fs-admin 2 i 1 krav (0 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P` og `A` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Avhengigheter

Kravene som kravene i scope bygger på (`@depends-on-`), med statusen deres. Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | `@OPT-BEH-BEH-013` Vurdere søknad om tidlig opptak | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-007` | `@OPT-OPT-UTD-004` Opptaksinnstillinger på utdanningstilbudet | 1 | `@draft` | – | ikke levert |
| `@OPT-BEH-BEH-007` | `@OPT-BEH-BEH-010` Gi tilbudsgaranti | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-007` | `@OPT-OPT-UTD-010` Registrere poengopplysninger | 1 | `@implemented` | – | Regel: Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt |

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense | ikke funnet | P ✓ · A ✗ — `TTS:389-395` gir ikke avviket når medianen finnes; fs-admin henter avvikene i prøvekjøringen (`KTB:26-43`, `KTB:103`), men dialogen viser dem ikke (`TRM:28-38`, `TRM:172`). Meldingen etter gjennomføringen (`KTB:129-134`) vises bare når antallet er over 0, så «0» vises aldri; søkt etter «konfigurasjonsavvik», «avvikstype», «MANGLER_POENGGRENSE», «mangelful», «feilkonfigur», «innstillinger» i fs-admin |
| `@OPT-BEH-BEH-007` | Se antall utdanningstilbud med mangelfulle innstillinger | ikke funnet | P ✓ · A ✗ — `TTS:383-420` gir avvikene per utdanningstilbud og type; prøvekjøringen i fs-admin viser dem ikke (`TRM:28-38`, `TRM:172`). Meldingen etter gjennomføringen (`KTB:129-134`, `MSG:342`) teller avvik, ikke utdanningstilbud, tar med overskredet kvote, og kommer etter den ekte gjennomføringen; søkt som over |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen | funnet | P ✓ · A ✓ — `TTS:776-786`, `KTB:111-114` |
| `@OPT-BEH-BEH-007` | Søkere som ikke deltar får ikke tilbudsgaranti | funnet | P ✓ · A ✓ — `TTS:678-686` |
| `@OPT-BEH-BEH-007` | Søknader uten konklusjon er ikke med i tidligopptaket | funnet | P ✓ · A ✓ — `TTS:668-676` |
| `@OPT-BEH-BEH-007` | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | funnet | P ✓ · A ✓ — `TTS:718-726` |
| `@OPT-BEH-BEH-007` | Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti | funnet | P ✓ · A ✓ — `TTS:709-715`, `TTS:727-735` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti på det høyest prioriterte søknadsalternativet | funnet | P ✓ · A ✓ — `TTS:870`, `TTS:599-619`, `TTS:776-786` |
| `@OPT-BEH-BEH-007` | Bare ferdig behandlede saker er med i tidligopptaket | funnet | P ✓ · A ✓ — `TTS:655-663` |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten poenggrense | funnet | P ✓ · A ✓ — `TTS:688-695` |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten kvalifisering | funnet | P ✓ · A ✓ — `TTS:692`, `TTS:699-735` |
| `@OPT-BEH-BEH-007` | Den høyeste poengsummen til søknadsalternativet gjelder | funnet | P ✓ · A ✓ — `TTS:899-928` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet | funnet | P ✓ · A ✓ — `TTS:1085-1090`, `TTS:1028-1030` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet | funnet | P ✓ · A ✓ — `TTS:1085-1090`, `TTS:1025-1027` |
| `@OPT-BEH-BEH-007` | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | funnet | P ✓ · A ✓ — `TTS:625-653`, `TTS:1093-1098` |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder går foran poengsummen | funnet | P ✓ · A ✓ — `TTS:638-642`, `TTS:602-619` |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum | funnet | P ✓ · A ✓ — `TTS:520-545`, `TTS:638-642` |
| `@OPT-BEH-BEH-007` | Prøvekjøre tidligopptaket | funnet | P ✓ · A ✓ — `TTS:110-117`, `TTS:149-150`, `KTB:96-104`, `TRM:110-113`, `MSG:348` |
| `@OPT-BEH-BEH-007` | En ny gjennomføring fjerner ikke tilbudsgarantien | funnet | P ✓ · A ✓ — `TTS:627-636` |
| `@OPT-BEH-BEH-007` | Ny gjennomføring tar med en sak som er blitt ferdig behandlet | funnet | P ✓ · A ✓ — `TTS:540-547`, `TTS:655-663` |
| `@OPT-BEH-BEH-007` | Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring | funnet | P ✓ · A ✓ — `TTS:602-604`, `TTS:1048-1078` |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | funnet | P ✓ · A – — `OKA:202-211` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak | funnet | P ✓ · A ✓ — `TTS:323-326`, `UV2:80-96`, `TTS:776-786` |
| `@OPT-BEH-BEH-007` | Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak | funnet | P ✓ · A ✓ — `TTS:736-744`, `UV2:93-96` |
| `@OPT-BEH-BEH-007` | Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | funnet | P ✓ · A ✓ — `TTS:178-183`, `TTS:221-224`, `TRM:82-97` |
| `@OPT-BEH-BEH-007` | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | funnet | P ✓ · A ✓ — `TTS:281-293`, `GQL:365-394`, `KTB:91-94`, `TRM:150-154`, `TRM:177-185` |
| `@OPT-BEH-BEH-007` | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | funnet | P ✓ · A ✓ — `STS:55-103`, `TGS:99-116` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

Ingen.

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter gjennomfører og prøvekjører tidligopptaket | stemmer | `TTS:104-108`, `KTB:45-54`, `KTB:86-88` |
| `@OPT-BEH-BEH-007` | organisasjon | gjennomføringen avvises uten forvaltertilgang, så RLS ikke gir en delvis kjøring | stemmer | `TTS:102-108`, `TTS:970-977`, `TTS:1005-1012` |
| `@OPT-BEH-BEH-007` | konsistens | hele gjennomføringen er én transaksjon, og rulles tilbake ved feil og ved prøvekjøring | stemmer | `TTS:110-117`, `TTS:149-150`, `TTS:1005-1012` |
| `@OPT-BEH-BEH-007` | konsistens | resultatene for søkerne tømmes og skrives på nytt i samme transaksjon | stemmer | `TTS:549-566` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten poengsum i garantikvoten gir ikke tilbudsgaranti | annet | `TTS:765-775` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kvoter eller kompetanseregelverk gir ikke tilbudsgaranti | validering | `TTS:699-708`, `TTS:745-763` | dekkes av `@draft`-scenario: Se hva som mangler for hvert utdanningstilbud med mangelfulle innstillinger (bare visningen) |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med i tidligopptaket | annet | `TTS:362-363` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i og som tilbudet har, og fra grunnlag rangeringsregelverket åpner for | annet | `TTS:922-927`, `TTS:937-960` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kvalifiseringen: ett kvalifisert grunnlag holder. Søkeren er ikke kvalifisert bare når alle grunnlagene er vurdert til nei, ellers er kvalifiseringen ikke vurdert | annet | `TTS:790-813` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Trukne søknadsalternativer og saker som ikke er aktive, er ikke med | annet | `TTS:534`, `TTS:544`, `TTS:868-869` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | En søker som ikke har søkt tidlig opptak, men har et tidligopptakstilbud på et søknadsalternativ, er med og får tilbudsgaranti fra tidligopptaket | tilstandsovergang | `TTS:520-545`, `GQL:22-23` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket | tilstandsovergang | `TTS:692-694`, `TTS:1022-1024`, `GQL:227-231` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Treffer en skriving ingen rad, stoppes hele gjennomføringen og rulles tilbake | tilstandsovergang | `TTS:1005-1012` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Gjennomføringen er sperret i fs-admin til prøvekjøringen har gitt en oppsummering, når poenggrenser ikke er lagret, og når prøvekjøringen gir feil | validering | `TRM:150-154`, `TRM:162-165` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Antallet i meldingen etter gjennomføringen teller avvik (ett utdanningstilbud kan ha flere), tar med overskredet kvote, og vises bare når det er over 0 | annet | `KTB:129-134`, `TTS:383-437` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kvotevarselet er 30 prosent når grensen ikke er angitt | standardverdi | `TTS:96-97`, `GQL:73` | dekkes av `@draft`-scenario: Kvotevarsel ved 30 prosent når grensen ikke er angitt |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 0 av 4 | 1 av 27 | 6 |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kontrollen endret | `@OPT-BEH-BEH-007` | `## Regler uten scenario` | 4 regler lagt til: kvalifiseringen med flere grunnlag (`TTS:790-813`), trukne søknadsalternativer og saker som ikke er aktive (`TTS:534`, `TTS:544`, `TTS:868-869`), tidligopptakstilbud uten søknad om tidlig opptak (`TTS:520-545`), og reservert studieplass som erstattes (`TTS:692-694`, `TTS:1022-1024`). Ingen scenarioer eller tilgangsrader er endret |
| Åpent spørsmål | `@OPT-BEH-BEH-007` | «Reservert studieplass gir tilbudsgaranti uten kvalifisering» (`krav/…/gi_tilbudsgaranti_ved_tidlig_opptak.feature:245`) | Gir reservert studieplass (RSO eller RES) tilbudsgaranti også når søkeren ikke er kvalifisert, eller kvalifiseringen ikke er vurdert? Fagperson svarte ja 13.10.2026, men har sendt spørsmålet videre til en annen domeneekspert, så svaret er foreløpig. Koden gjør det (STEK-582) |
| Bygger på krav som ikke er levert | `@OPT-BEH-BEH-007` | – | bygger på `@OPT-OPT-UTD-004` (`@draft`) |
| Ikke sjekket | – | min-kompetanse | Ingen scenarioer i gating-settet gjelder det søkeren ser |
| Merknad | `@OPT-BEH-BEH-007` | «Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon» (`krav/…:410`) | Tallet er riktig, men etiketten i fs-admin er «Har saker som ikke er behandlet» (`MSG:346`) og sier ikke at saker uten konklusjon telles med. Sjekkes i designet eller i fase 2 |
| Merknad | `@OPT-BEH-BEH-007` | «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak» (`krav/…:485`) | Feilmeldingen fs-admin viser, er den tekniske meldingen fra fs-plattform, med kategori og RLS (`TTS:281-293`) |
| Merknad | `@OPT-BEH-BEH-007` | «Se antall utdanningstilbud med mangelfulle innstillinger» (`krav/…:416`) | Når fs-admin retter dette, bør antallet være utdanningstilbud, ikke avvik, og overskredet kvote bør ikke telles med (`KTB:129-134`). Kommentert på STEK-489 |
| Merknad | `@OPT-BEH-BEH-007` | `tasks/opptak/tidlig-opptak/spec/spec-tidlig-opptak.md` | Avviket om medianen i «Avvik der koden skal endres» (STEK-676) er rettet: gjennomføringen bruker medianen når poenggrensen ikke er satt (`TTS:323-326`) |
