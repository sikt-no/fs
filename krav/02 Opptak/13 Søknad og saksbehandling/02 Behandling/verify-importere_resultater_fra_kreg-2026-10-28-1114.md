# Verifisering: importere_resultater_fra_kreg.feature

- **Dato:** 2026-10-28 11:14
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/importere_resultater_fra_kreg.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (main, f5231b229f, oppdatert), `fs-admin` (main, e7c91f629, oppdatert)
- **Åpne MR-er:** 13 MR-er i fs-plattform, 0 i fs-admin (1 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SBJ` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `HVS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/HentVgsVitnemaalService.java`
- `KVP` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/KregVgsParser.java`
- `VLS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsLagringService.java`

## Oppsummering

- Scenarioer: 11 funnet, 4 ikke funnet, 0 usikker, av 15
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |

Avhengigheter: 0 på nivå 1. Kravet har ingen `@depends-on-`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-029` | Resultatene hentes når søkeren sender inn søknaden | funnet | `SKS:765` `leverSoknadskladdSoker` → `leverSoknadskladd`, som registrerer SOKNAD-hendelsen (`SKS:898-903`); `SBJ:311-318` fordeler og legger søkeren i `tildelte`; `SBJ:126-135` og `SBJ:394` henter fra KREG etter commit; `HVS:108-131` lagrer |
| `@OPT-BEH-BEH-029` | Resultatene hentes når søknaden registreres på vegne av søkeren | funnet | `SKS:774` `leverSoknadskladdPaVegneAvSoker` → samme `leverSoknadskladd` og hendelse (`SKS:898-903`); samme jobb som over |
| `@OPT-BEH-BEH-029` | Resultatene hentes på nytt når søkeren endrer søknaden | funnet | `SKS:1003-1012` `oppdaterSoknadFraSoknadskladd` registrerer SOKNAD-hendelsen hver gang; ny fordeling (`SBJ:311-318`) gir ny henting (`SBJ:129-135`); nytt dokumentnummer settes inn (`VLS:49-52`, `VLS:71-103`) |
| `@OPT-BEH-BEH-029` | Resultatene hentes før søknaden er fordelt | ikke funnet | `SBJ:298-305` og `SBJ:319-325` utsetter hendelsen når opptaket mangler regel, og søkeren kommer ikke i `tildelte`; `SBJ:126` henter bare for `tildelte`. Ingen andre kallere av `HentVgsVitnemaalService` — søkt etter «HentVgsVitnemaalService», «hentOgLagre», «hentKompetanseoppnaelse» i fs-plattform. Også i MR !6080 hentes resultatene først etter fordelingen |
| `@OPT-BEH-BEH-029` | Det importerte vitnemålet har opplysningene saksbehandlingen trenger | funnet | `KVP:99-104` reform, utstedelsesdato, førstegangsvitnemål, avgangsår og påstand om GSK; `KVP:111` merknader; `KVP:203-238` fag med standpunkt- og eksamenskarakter; `KVP:243-258` programområder; `VLS:71-101` lagrer dokument, fag, programområder og merknader |
| `@OPT-BEH-BEH-029` | Søker med flere vitnemål får alle importert | funnet | `KVP:70-77` ett resultat per vitnemål; `HVS:116-131` lagrer hvert |
| `@OPT-BEH-BEH-029` | Kompetansebevis importeres | funnet | `KVP:70-77` filtrerer ikke på dokumenttype, `KVP:98` lagrer `vgdoktypekode` (VM eller KB, `fs-plattform/kreg/kreg-graphql/src/main/resources/schema/features/experimental/schema.graphql:345-346`); KB leses fra `vgs_dokument` i `VgsDokumentVitnemaalService.java:52` |
| `@OPT-BEH-BEH-029` | Vitnemål som er importert fra før, importeres ikke på nytt | funnet | `VLS:49-56` eksisterende dokumentnummer gir `FANTES_FRA_FOER` uten skriving |
| `@OPT-BEH-BEH-029` | Annullert vitnemål importeres som annullert | funnet | `KVP:107` setter annullert når status er `ANNULLERT`; `VLS:84` og `VLS:97` lagrer flagget |
| `@OPT-BEH-BEH-029` | Vitnemål som annulleres etter importen, blir annullert | funnet | `VLS:53-63` setter `ANNULLERT` når dokumentet er annullert i KREG og ikke lagret som annullert |
| `@OPT-BEH-BEH-029` | Vitnemålet blir stående som annullert når KREG opphever annulleringen | funnet | `VLS:38-39` (javadoc: «håndteres bevisst ikke») og `VLS:53-56`: annullert lagret dokument endres ikke |
| `@OPT-BEH-BEH-029` | Søker uten fødselsnummer får ingen resultater importert | funnet | `HVS:59-71` slår bare opp `FØDSELSNUMMER`, og hopper over med «søkeren mangler fødselsnummer» |
| `@OPT-BEH-BEH-029` | Resultatene hentes når KREG svarer igjen | ikke funnet | ikke funnet på main — finnes i MR !6080 (utkast, fs-plattform, `feature/soknadshendelser-utboks`): `opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/vgs/VitnemaalJobb.java:43-47` — VITNEMAAL-jobben prøver igjen med doblet ventetid og gir aldri opp. På main logger `SBJ:410-411` feilen, og hendelsen er alt kvittert (`SBJ:315`) — søkt etter «retry», «prøv igjen», «forsok», «utsett» i opptak |
| `@OPT-BEH-BEH-029` | Nytt vitnemål i KREG importeres uten at søkeren endrer søknaden | ikke funnet | ingen abonnement: KREG-skjemaet har bare `Query` og `Mutation`; ingen `@Scheduled` i opptak henter fra KREG uten SOKNAD-hendelse — søkt etter «abonnement», «subscription», «webhook», «endringslogg», «varsel» i kreg/ og opptak/, «kreg» i batch/, og «kreg», «hentVitnemal», «importer» i fs-admin; heller ikke i MR !6080 |
| `@OPT-BEH-BEH-029` | Annullering i KREG importeres uten at søkeren endrer søknaden | ikke funnet | som over; annulleringen tas bare inn ved en ny henting etter en SOKNAD-hendelse (`VLS:53-63`) |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6080 TAKE-398: Jobbkø i opptak for søknadshendelsene](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6080) (`feature/soknadshendelser-utboks`) | utkast | `@OPT-BEH-BEH-029` | 1/4 | bak main (18 commits); nye forsøk mot KREG, ikke abonnement |
| `fs-plattform` | `solov/STEK-433-vgs-lagring-jobbpool` | branch uten MR | `@OPT-BEH-BEH-029` | 0/4 | usikker kobling; utdatert, rører `AutomatiskSaksbehandlingService`, som ikke henter fra KREG på main |
| `fs-plattform` | !6428, !6423, !6411, !6409, !6399, !6387, !6380, !6065, !6309, !6369, !6343, !6211 (KREG-teamet) | åpen / utkast | – | 0/4 | rører bare `kreg/`, ikke importen i opptak |
| `fs-admin` | `opptak/vise-elektroniske-vitnemal`, `miudv/fix-errors-vitnemal` | branch uten MR | – | 0/4 | bare visning av vitnemål |

## Kontroll

Kontrollen endret ingen resultater.

Kontrollen rettet linjene i bevisene (innsending er `SKS:765` og `SKS:898-903`, ikke `SKS:527`), og fant MR !6080, som manglet i lista den fikk.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-029` — Importere resultater fra KREG (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/importere_resultater_fra_kreg.feature`, `@draft` → `@in-progress`, 11/15 funnet) — `@implemented` på: Regel: Alle vitnemål og kompetansebevis søkeren har i KREG, importeres (linje 58), Regel: Et vitnemål som er annullert i KREG, er annullert i opptaket (linje 90), Scenario: Resultatene hentes når søkeren sender inn søknaden (linje 26), Scenario: Resultatene hentes når søknaden registreres på vegne av søkeren (linje 31), Scenario: Resultatene hentes på nytt når søkeren endrer søknaden (linje 37), Scenario: Søker uten fødselsnummer får ingen resultater importert (linje 117)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-029` | Importere resultater fra KREG | `@draft` | 11/15 | 4 ikke funnet, 0 usikker. Brukeren valgte å beholde `@draft` |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Nye forsøk mot KREG er på vei:** MR !6080 (utkast) gir hentingen nye forsøk når KREG ikke svarer (`VitnemaalJobb.java:43-47` på `feature/soknadshendelser-utboks`). Merges den, kan «Resultatene hentes når KREG svarer igjen» verifiseres på nytt.
- **Ny henting ved flere søknadshendelser:** SOKNAD-hendelsen registreres også fra `UtdanningsbakgrunnOverstyringService.java:226` og `SokTidligOpptakService.java:80`, så resultatene hentes på nytt også da. Kravet nevner bare innsending, registrering på vegne av søkeren og endring av søknaden.
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Resultatene hentes på nytt når søkeren endrer søknaden» — Koden henter resultatene på nytt hver gang søknaden fordeles på nytt, også når søkeren endrer søknaden. Skal resultatene hentes på nytt når søknaden endres, eller er det nok med abonnementet?
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Resultatene hentes før søknaden er fordelt» — Skal resultatene hentes uansett, også når opptaket mangler regler for å fordele søknadene?
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Vitnemålet blir stående som annullert når KREG opphever annulleringen» — Koden gjør dette med vilje. Er det riktig, eller skal opphevingen tas inn?
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Søker uten fødselsnummer får ingen resultater importert» — Skal søkere med D-nummer slås opp i KREG?
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Resultatene hentes når KREG svarer igjen» — Skal hentingen prøves igjen av seg selv? Skal saksbehandleren se at importen feilet?
- **Åpent spørsmål:** `@OPT-BEH-BEH-029` «Endringer i KREG importeres gjennom et abonnement» — Hvordan abonnementet skal virke, hvilke søkere og hvor lenge, og hvilke endringer som skal komme, er ikke avklart (KREG-teamet).
- **Ikke sjekket:** min-kompetanse er ikke blant kodeklonene. Importen skjer i fs-plattform, så det har ingen betydning for resultatet.
