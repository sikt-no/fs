# Verifisering: tildele_saksbehandlende_organisasjon.feature og flyten saksbehandlertildeling.feature

- **Dato:** 2026-11-04 13:17
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` og `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature` (2 feature-filer)
- **Kode:** `fs-plattform` (main, 6a60a0b6a2, oppdatert), `fs-admin` (main, 52a3d0745, oppdatert), `min-kompetanse` (main, 19111241, oppdatert)
- **Åpne MR-er:** 2 MR-er i fs-plattform, 1 i fs-admin, 1 i min-kompetanse (1 med kode for kravene: min-kompetanse !994)
- **Omfang:** alle krav uansett status, flyter (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170364465/Verifisering+Saksbehandlertildeling+runde+2+2026-11-04+13+17

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Søkerens visning (`@OPT-BEH-BEH-011` «Søkeren ser saksbehandlende organisasjon, men ikke sakene») er verifisert på branchen `stek-664-vis-saksbehandlende-organisasjon` i min-kompetanse (MR !994, utkast). Brukeren har sagt at MR-en regnes som implementert mens den venter på merge. Resultatet er derfor `funnet`, med branchen i beviset.

Stiene er forkortet:

- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `IT` = `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak`
- `TST` = `fs-plattform/opptak/opptak-service/src/test/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingAlgoritmeTest.java`
- `ADM` = `fs-admin/src/domains/opptak/features/Behandlertildelingsregler`
- `SB` = `fs-admin/src/domains/soknadsbehandling`
- `MK664` = `min-kompetanse` på `origin/stek-664-vis-saksbehandlende-organisasjon` (cb70d818), `src/app/[locale]/soknader/[soknadId]`

## Oppsummering

- Scenarioer: 65 funnet, 3 ikke funnet, 1 usikker, av 69
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 28 stemmer, 2 avviker, 0 ikke funnet, 3 usikker, 1 ikke beskrevet, av 34
- Regler i koden uten scenario: 29
- Åpne spørsmål: 3 regler og 5 scenarioer i gating-settet (alle i `@FLY-OPT-SAK-001`), 0 utenfor gating

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Behandlertildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`, ingen anker), `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Opptaksforvalteren … setter opp behandlertildelingsreglene levert, Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket ikke tagget levert) | nei |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får behandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast levert) | ja |
| `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@in-progress`, `@implemented` etter denne kjøringen: Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen og Regel: Tilbyderen ser saksbehandlingen … levert), `@OPT-BEH-BEH-010` (`@implemented`) | ja |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn ikke `@implemented`), `@OPT-BEH-BEH-011` (Regel: Søknadsalternativene flyttes … levert) | nei |

`@FLY-OPT-SAK-001`: 2 av 5 faser levert (fasen «Den saksbehandlende organisasjonen ser saken» ble levert da `@OPT-BEH-BEH-011` ble `@implemented` i denne kjøringen).

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Opprette behandlertildelingsregel | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:41-62,152-165` — lagrer kode, navn, fordeling (SEKTOR = «Tilbydere i samme sektor») og aktiv. UI `ADM/components/BehandlertildelingsregelEditor.tsx:342-377,424-470` (feltet heter «Navn», kravet sier «Beskrivelse») |
| `@OPT-BEH-BEH-011` | Nytt opptak får standard behandlertildelingsregel med «Alle som deltar i opptaket» | funnet | `SVC/opptak/OpprettOpptakMutations.java:113-114,358-368` — nytt opptak får regelen «ORD» med `behandlesAvAlle=true`, aktiv |
| `@OPT-BEH-BEH-011` | Bytte standard behandlertildelingsregel | funnet | `SVC/opptak/OpprettOpptakMutations.java:389-433` setter standardregelen; `SVC/saksbehandling/BehandlertildelingService.java:164-188` bruker den for tilbud uten egen regel. UI `ADM/components/BehandlertildelingsregelStandard.tsx:116-155` |
| `@OPT-BEH-BEH-011` | Opptaket kan bare ha én aktiv behandlertildelingsregel med «Alle som deltar i opptaket» | funnet | `MIG/V395__behandlertildelingsregel_per_opptak.sql:88-90` — unik delvis indeks på `behandles_av_alle AND er_aktiv`; feilen vises som snackbar `ADM/components/BehandlertildelingsregelEditor.tsx:312-316` |
| `@OPT-BEH-BEH-011` | Se hvilke utdanningstilbud som er knyttet til behandlertildelingsregelen | funnet | `SVC/regelverk/RegelverkBrukService.java:238-290` teller; `ADM/components/BehandlertildelingsregelEditor.tsx:231-252` viser «knyttet til N studiealternativer» med lenke |
| `@OPT-BEH-BEH-011` | Slette behandlertildelingsregel som ikke er knyttet til utdanningstilbud | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:132-149` sletter; UI `ADM/components/BehandlertildelingsregelEditor.tsx:522-541` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes | funnet | `ADM/components/BehandlertildelingsregelEditor.tsx:233,522` skjuler «Slett»; FK uten cascade `MIG/V395__behandlertildelingsregel_per_opptak.sql:104-108` gir `IBrukError` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel som <bruk> kan ikke deaktiveres | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:89-92,208-225` — avviser både standard og knyttet til utdanningstilbud; UI `ADM/components/BehandlertildelingsregelEditor.tsx:399-403` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak | funnet | `fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:33-35` gir notFound når opptaket ikke er samordna; `SVC/regelverk/BehandlertildelingsregelMutations.java:242` avviser |
| `@OPT-BEH-BEH-011` | Deltakende lærested kan ikke endre behandlertildelingsreglene | funnet | `ADM/components/BehandlertildelingsregelEditor.tsx:164-166,330` lesevisning; `ADM/components/BehandlertildelingsreglerResultList.tsx:72-77` skjuler «Opprett»; RLS `MIG/V395__behandlertildelingsregel_per_opptak.sql:130-136` (`har_forvaltertilgang`) |
| `@OPT-BEH-BEH-011` | Lærestedet på første prioritet saksbehandler hele søknaden | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:257-283` — fase 3 i prioritetsrekkefølge og spredning; `TST:37` |
| `@OPT-BEH-BEH-011` | Søknadsalternativ med egen behandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:227-231,285-291` — ISOLERT fyller bare eget alternativ og tas ut av AV_ALLE; `TST:92` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:242-244` — TILBYDER setter eget alternativ og sprer til AV_ALLE; `TST:51` |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:236-244` — i prioritetsrekkefølge, første tilbyder vinner spredningen |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:227-231,257-267`; `TST:92` |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | funnet | `SVC/saksbehandling/BehandlertildelingService.java:187` gir standardregelen; `SVC/saksbehandling/BehandlertildelingAlgoritme.java:227-231` (ISOLERT) |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:246-252` — første SEKTOR-alternativ avgjør; `TST:105` |
| `@OPT-BEH-BEH-011` | Organisasjonen som er valgt på behandlertildelingsregelen saksbehandler hele sektoren | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:248-252,317-323` — `organisasjonskodeSektor` brukes; `TST:120` |
| `@OPT-BEH-BEH-011` | Søknadsalternativer i ulike sektorer fordeles hver for seg | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:318-321` — tildeling lagres per regelkode; `TST:379` |
| `@OPT-BEH-BEH-011` | Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:236-253,318` — sektoren er felles regelkode; `SVC/opptak/UtdanningstilbudMutations.java:366-395` lar deltakeren velge regelen |
| `@OPT-BEH-BEH-011` | Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:233-254` — tilbyder- og sektorregler i felles prioritetsrekkefølge; `TST:64,78` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:250-258` — deltaker eller opptakets organisasjon; UI `ADM/components/BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:81-85` |
| `@OPT-BEH-BEH-011` | Organisasjonen for sektoren må delta i opptaket | funnet | `ADM/components/BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:81-95` viser bare opptakets organisasjon og deltakerne; `SVC/regelverk/BehandlertildelingsregelMutations.java:250-258` avviser |
| `@OPT-BEH-BEH-011` | Legge til unntak for utdanningsbakgrunn | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:167-202` lagrer ett unntak per bakgrunn; `SVC/saksbehandling/BehandlertildelingService.java:315-330` leser dem |
| `@OPT-BEH-BEH-011` | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn> | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:172-205` — alle alternativer til unntaksorganisasjonen; `TST:210`. I grunndata heter «Rudolf Steinerskole» «Videregående steinerskole» (STEINER) |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse | funnet | `SVC/saksbehandling/BehandlertildelingService.java:111-112,294-313` (`alleTilTilbyder`); `MIG/V407__utdanningsbakgrunn_behandles_tilbyder.sql:15-17`; `TST:190` |
| `@OPT-BEH-BEH-011` | Unntaket går foran behandlertildelingsregel der bare tilbyderen saksbehandler | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:150-155,238-240,289` — unntakshåndterte alternativer tas ut av fase 1–3; `TST:226` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:179-182` — unntak slås opp per regelkode; `TST:366,493` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass | funnet | `SVC/soknad/StudiekurvService.java:1369-1403` merker alternativet; `SVC/saksbehandling/BehandlertildelingAlgoritme.java:161-170`; `TST:241` |
| `@OPT-BEH-BEH-011` | Ledig studieplass går foran unntak for utdanningsbakgrunn | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:153-154,174-178`; `TST:254` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren | funnet | `SVC/soknad/StudiekurvService.java:1100-1146` — samme synkronisering på vegne av søkeren; `SVC/opptak/Opptaksfrister.java:127-139` |
| `@OPT-BEH-BEH-011` | Legge til unntak for lærested | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:57-59,105-112,260-281`; `MIG/V478__behandlertildelingsregel_pa_vegne_av.sql:6-33`; UI `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:172-223,295-310` |
| `@OPT-BEH-BEH-011` | Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:307-315` (`byttPaVegneAv`); `TST:583` |
| `@OPT-BEH-BEH-011` | Unntaket for lærested gjelder også når <tilfelle> | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:229,309` (bare tilbyderen), `:184-195` (realkompetanse), `:168,309` (ledig studieplass); `TST:615` |
| `@OPT-BEH-BEH-011` | Organisasjonene i unntaket for lærested må delta i opptaket | funnet | `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:90-105` — «På vegne av» bare deltakere, «Saksbehandles av» deltakere og opptakets organisasjon; `SVC/regelverk/BehandlertildelingsregelMutations.java:287-304` avviser |
| `@OPT-BEH-BEH-011` | Forvaltende organisasjon kan saksbehandle på vegne av et lærested | funnet | `SVC/regelverk/BehandlertildelingsregelMutations.java:300` tillater opptakets organisasjon; `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:98-105` |
| `@OPT-BEH-BEH-011` | Lærestedet kan bare ha ett unntak for lærested per behandlertildelingsregel | funnet | avgjort av brukeren: deaktivert er godt nok, og steget er rettet til «kan ikke velge». `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:126-133` — lærestedet vises deaktivert i «På vegne av»; sperren `SVC/regelverk/BehandlertildelingsregelMutations.java:269-271` og PK `MIG/V478__behandlertildelingsregel_pa_vegne_av.sql:13-14` finnes |
| `@OPT-BEH-BEH-011` | Nytt unntak for lærested gjelder bare søknadsalternativer som ikke er fordelt | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:297-311` — en satt behandler byttes aldri, og lagring av regelen refordeler ikke; `TST:699` |
| `@OPT-BEH-BEH-011` | Organisasjon i et unntak for lærested kan ikke tas ut av opptaket | funnet | `SVC/opptak/OpprettOpptakMutations.java:576,642-690` — avviser uttak av lærested eller overtaker i par på aktiv regel eller regel i bruk |
| `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når <hendelse> | funnet | `SVC/soknad/StudiekurvService.java:953,1063,1148` registrerer SOKNAD-hendelse ved innsending, endring og på vegne av søkeren; `SVC/saksbehandling/BehandlertildelingService.java:78-137` fordeler bare alternativer uten behandler |
| `@OPT-BEH-BEH-011` | Søknaden får én sak per saksbehandlende organisasjon | funnet | `SVC/saksbehandling/BehandlertildelingService.java:441-468` (`sikreSaker`); PK `sak(soker_id, opptak_kode, organisasjonskode)` `MIG/V291__saksbehandling_skjema.sql:79` |
| `@OPT-BEH-BEH-011` | Tilbyder som ikke er saksbehandlende organisasjon får ingen sak | funnet | `SVC/saksbehandling/BehandlertildelingService.java:354,394` — saker opprettes bare for behandlerne |
| `@OPT-BEH-BEH-011` | Ny prioritering endrer ikke saksbehandlende organisasjon | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:298-311` — eksisterende behandler overstyres aldri |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:219-225` (`folgTidligereFordeling`, STEK-656); `TST:163` |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:233-245,276` — spredningen hopper over alternativer med behandler |
| `@OPT-BEH-BEH-011` | Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene | funnet | `SVC/saksbehandling/BehandlertildelingService.java:181,333-340` — slettede alternativer holdes utenfor, de andre beholder tildelingen |
| `@OPT-BEH-BEH-011` | Søkeren bytter til utenlandsk utdanningsbakgrunn | funnet | `SVC/soknad/StudiekurvService.java:1040-1063`; `SVC/saksbehandling/BehandlertildelingAlgoritme.java:172-205`; `SVC/saksbehandling/BehandlertildelingService.java:385-429` flytter |
| `@OPT-BEH-BEH-011` | Søkeren bytter til realkompetanse | funnet | `MIG/V407__utdanningsbakgrunn_behandles_tilbyder.sql`; `SVC/saksbehandling/BehandlertildelingAlgoritme.java:184-195` |
| `@OPT-BEH-BEH-011` | Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | funnet | `SVC/saksbehandling/BehandlertildelingAlgoritme.java:194` — flytter bare når bakgrunnen har `omfordel_b_rolle` (NORSK har ikke) |
| `@OPT-BEH-BEH-011` | Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn> | funnet | `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:44-76`; REAL og DISP uten frist `SVC/opptak/Utdanningsbakgrunnsfrist.java:32-34` |
| `@OPT-BEH-BEH-011` | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist> | funnet | `SVC/opptak/Utdanningsbakgrunnsfrist.java:27-38` — innenfor fristen gjelder overstyringen i tildelingen, etter fristen ikke; `SVC/saksbehandling/BehandlertildelingService.java:283-290` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | funnet | `SVC/opptak/Utdanningsbakgrunnsfrist.java:37`; RLS `MIG/V502__opptaksforvalter_overstyrer_uten_saksbehandlingstilgang.sql:15-44` (STEK-658) |
| `@OPT-BEH-BEH-011` | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til | funnet | `SVC/saksbehandling/BehandlertildelingService.java:405-427` — ny koblingsrad hos ny organisasjon, alle tre tilbudsgarantiene kopieres, resultatet nullstilles |
| `@OPT-BEH-BEH-011` | Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak | funnet | `SVC/saksbehandling/BehandlertildelingService.java:394` (`sikreSaker`) setter ingen status, så standard `UBEHANDLET` gjelder `MIG/V291__saksbehandling_skjema.sql:75` |
| `@OPT-BEH-BEH-011` | Interne merknader blir igjen hos organisasjonen søknadsalternativet flyttes fra | funnet | `SVC/saksbehandling/BehandlertildelingService.java:385-429` rører ikke merknadene; INTERN vises bare for merknadens organisasjon `MIG/V493__tilbyder_ser_saksbehandlingen.sql:69-87` |
| `@OPT-BEH-BEH-011` | Saksbehandleren ser bare saken hos organisasjonen sin | funnet | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` — `har_orgtilgang` på sakens organisasjon; lista er RLS-styrt `SVC/saksbehandling/SakService.java:140-144` |
| `@OPT-BEH-BEH-011` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | funnet | `MIG/V504__soker_saksbehandlende_organisasjon.sql:15-26`; `GQL/saksbehandling/sak.graphqls:921`; branchen `MK664/_components/contact-information/contact-information.tsx:121-166` og `MK664/_utils/group-by-saksbehandler.ts:26` — én boks per organisasjon med studiene, ingen sak-felt (MR !994, regnes som implementert etter brukerens beskjed) |
| `@OPT-BEH-BEH-011` | Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon | funnet | `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35` — forvaltergrenen krever `MODIFISERE_OPPTAK`; `IT/…/ForvalterLeserSakerRLSIT.java:132` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | funnet | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` (`opptak_der_bruker_er_opptaksforvalter()`); `IT/…/ForvalterLeserSakerRLSIT.java:99,110` |
| `@OPT-BEH-BEH-011` | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler | funnet | `MIG/V501__tilbyderoppslag_per_sak.sql:22-72` — tilbyderen ser saken, søknadsdelen og egne alternativer; saken står i «Saker i opptak» (`SB/features/SakOverviewView/SakOverviewView.queries.ts:15-23`, RLS) og vises i lesemodus `SB/hooks/useKanSaksbehandle.ts:30-42` |
| `@OPT-BEH-BEH-011` | Tilbyderen setter tilbudsgaranti | funnet | `SVC/saksbehandling/SettTilbudsgarantitypeService.java:55-58,82-96`; RLS `MIG/V346__kolonnevern_tilbudsgaranti.sql:91-108`; UI `SB/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:240-249` |
| `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen | funnet | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:69-87` skjuler interne merknader, `:89-175` krever `MODIFISERE_SØKNADSBEHANDLING` for sakens organisasjon; UI `SB/hooks/useKanSaksbehandle.ts:30-42` |
| `@FLY-OPT-SAK-001` | Lærestedene kan velge behandlertildelingsregelen opptaket har satt opp | ikke funnet | fasen er ikke levert: `@OPT-OVO-SAM-001` er `@in-progress` — ikke søkt |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får behandlertildelingsregelen fra opptaket | ikke funnet | fasen er ikke levert: `@OPT-OPT-UTD-004` er `@draft` — ikke søkt |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | usikker | lages: `SVC/opptak/UtdanningstilbudMutations.java:395` (regelen på utdanningstilbudet) · brukes: `SVC/saksbehandling/BehandlertildelingService.java:173,187` → `:356-363,458-465` — overleveringen finnes, men «SPE» sprer til alle alternativer uten egen regel (`SVC/saksbehandling/BehandlertildelingAlgoritme.java:241-245`), så koden gir én sak hos NTNU, ikke UiO + NTNU. «Så» stemmer med «UVH» (åpent spørsmål i flyten) |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | funnet | lages: `SVC/regelverk/BehandlertildelingsregelMutations.java:274-279` (`behandlertildelingsregel_pa_vegne_av`) · brukes: `SVC/saksbehandling/BehandlertildelingService.java:193-208` → `SVC/saksbehandling/BehandlertildelingAlgoritme.java:313-315` → sak hos OsloMet `SVC/saksbehandling/BehandlertildelingService.java:458-465` |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | funnet | lages: `SVC/saksbehandling/BehandlertildelingService.java:458-465` (sak per organisasjon) · brukes: `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` og `sakerV2` `GQL/saksbehandling/sak.graphqls:9` — samme `sak`-rad |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | funnet | lages: `SVC/saksbehandling/BehandlertildelingService.java:356-363` (`sak_soknadsalternativ` med behandleren) · brukes: `SVC/saksbehandling/SettTilbudsgarantitypeService.java:82-96` oppdaterer samme rad (`fra_tilbyder`) |
| `@FLY-OPT-SAK-001` | Saksbehandlertildelingen bruker fristen opptaket har satt | ikke funnet | fasen er ikke levert: regelen om fristen i `@OPT-OVO-FRI-001` er ikke `@implemented` — ikke søkt |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | tilgang | opptaksforvalter ved forvaltende organisasjon oppretter, endrer og sletter behandlertildelingsregel | opptaksforvalteren ved forvaltende organisasjon setter opp reglene | tillatt med `MODIFISERE_OPPTAK` for opptakets organisasjon | stemmer | `MIG/V395__behandlertildelingsregel_per_opptak.sql:130-136`; `IT/regelverk/BehandlertildelingsregelRLSIT.java:58,86` |
| `@OPT-BEH-BEH-011` | tilgang | opptaksforvalter ved forvaltende organisasjon oppretter, endrer og fjerner unntak for lærested | opptaksforvalteren legger til unntaket | via opprett/oppdater med `paVegneAv`, samme skrivepolicy som regelen | stemmer | `MIG/V478__behandlertildelingsregel_pa_vegne_av.sql:48-54`; `IT/regelverk/BehandlertildelingsregelRLSIT.java:208` |
| `@OPT-BEH-BEH-011` | tilgang | opptaksforvalter ved deltakende lærested oppretter, endrer og sletter regel og unntak | kan ikke (Deltakende lærested kan ikke endre behandlertildelingsreglene) | avvist i RLS; UI viser lesevisning | stemmer | `IT/regelverk/BehandlertildelingsregelRLSIT.java:66,101,142,182,221`; `ADM/components/BehandlertildelingsregelEditor.tsx:164-166,330` |
| `@OPT-BEH-BEH-011` | tilgang | alle innloggede leser regler og unntak for lærested | ikke beskrevet | lesing er åpen | ikke beskrevet | `MIG/V395__behandlertildelingsregel_per_opptak.sql:128-129`; `MIG/V478__behandlertildelingsregel_pa_vegne_av.sql:46-47` |
| `@OPT-BEH-BEH-011` | tilgang | bruker med rolle i en annen organisasjon åpner «opprett»-siden direkte | ikke beskrevet | UI viser skrivbart skjema (rollesjekk uten organisasjon på opprett-siden), backend avviser lagringen | usikker | `ADM/components/BehandlertildelingsregelEditor.tsx:164-166` |
| `@OPT-BEH-BEH-011` | organisasjon | «Saksbehandles av» i unntak for lærested | må delta i opptaket, eller være forvaltende organisasjon | deltaker eller opptakets organisasjon | stemmer | `SVC/regelverk/BehandlertildelingsregelMutations.java:300` |
| `@OPT-BEH-BEH-011` | organisasjon | «På vegne av» i unntak for lærested | må delta i opptaket | må være deltaker | stemmer | `SVC/regelverk/BehandlertildelingsregelMutations.java:296-299` |
| `@OPT-BEH-BEH-011` | organisasjon | «Fordeles til» i unntak for utdanningsbakgrunn | ikke beskrevet | ikke begrenset til deltakere | stemmer | `ADM/components/BehandlertildelingsregelUnntak.tsx:80-90`; `SVC/regelverk/BehandlertildelingsregelMutations.java:191-201` |
| `@OPT-BEH-BEH-011` | konsistens | opptaksforvalter sletter regel som er i bruk eller er standard | kan ikke slettes | FK avviser, UI skjuler knappen | stemmer | `MIG/V395__behandlertildelingsregel_per_opptak.sql:97-108` |
| `@OPT-BEH-BEH-011` | konsistens | opptaksforvalter sletter regel som søknader er tildelt etter | ikke beskrevet | FK avviser, men brukstallet teller ikke slike søknader, så «Slett» vises og feiler ved lagring | avviker | `MIG/V395__behandlertildelingsregel_per_opptak.sql:119-122`; `ADM/components/BehandlertildelingsregelEditor.tsx:264-266` |
| `@OPT-BEH-BEH-011` | konsistens | opptaksforvalter deaktiverer regel som er standard eller knyttet til utdanningstilbud | avvises | avvises | stemmer | `SVC/regelverk/BehandlertildelingsregelMutations.java:208-225` |
| `@OPT-BEH-BEH-011` | konsistens | opptaksforvalter tar lærested eller overtaker i et unntak for lærested ut av opptaket | avvises | avvises når regelen er aktiv eller i bruk | stemmer | `SVC/opptak/OpprettOpptakMutations.java:576,642-690` |
| `@OPT-BEH-BEH-011` | konsistens | opptaksforvalter tar ut deltaker som er «Fordeles til» i unntak for utdanningsbakgrunn | ikke beskrevet | ingen sperre; unntaket kan peke på en organisasjon som ikke deltar | avviker | `SVC/opptak/OpprettOpptakMutations.java:642-690` sjekker bare sektor og unntak for lærested |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler leser sak | ser bare saken hos organisasjonen sin | `har_orgtilgang` på sakens organisasjon | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler endrer grunnlag og poeng | ikke beskrevet | krever `MODIFISERE_SØKNADSBEHANDLING` for sakens organisasjon | stemmer | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:89-95`; `SB/hooks/useKanSaksbehandle.ts:30-42` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler overstyrer utdanningsbakgrunn | kan, bundet av fristen | lagres alltid, flytter bare innenfor fristen | stemmer | `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:44-76`; `SVC/opptak/Utdanningsbakgrunnsfrist.java:27-38` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler flytter sak direkte | ikke beskrevet (flyttes av utdanningsbakgrunnen) | ingen mutasjon; bare tildelingsjobben flytter | stemmer | `SVC/saksbehandling/BehandlertildelingService.java:381-384` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder leser sak og egne alternativer | ser søknadsalternativet og saksbehandlingen | ser saken, søknadsdelen, praksisperioder og bare egne alternativer | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:22-72`; `IT/saksbehandling/TilbyderSerSakenRLSIT.java:119-145` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder finner saken i «Saker i opptak» | ikke beskrevet | ja: `sakerV2` har ikke organisasjonsfilter, RLS slipper tilbyderen inn | stemmer | `SVC/saksbehandling/SakService.java:140-144`; `SB/features/SakOverviewView/SakOverviewView.queries.ts:15-23` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder leser interne merknader | ser ikke | ser `ALLE`, ikke `INTERN` | stemmer | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:69-87`; `IT/saksbehandling/TilbyderSerSakenRLSIT.java:175` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder leser dokumentene i saken | ser ikke dokumentene (AVKLART 04.11.2026, avgjort av brukeren) | får ikke dokumentet: lesing krever tilgang i saksdokumentets organisasjon | stemmer | `MIG/V499__dokument_rls_via_sak.sql:21-24` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder endrer grunnlag, poeng og kvote | kan ikke | avvist i RLS | stemmer | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:89-150`; `IT/saksbehandling/TilbyderSerSakenRLSIT.java:259-300` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder setter tilbudsgaranti | kan | `fra_tilbyder`, krever `OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD` | stemmer | `MIG/V346__kolonnevern_tilbudsgaranti.sql:91-108` |
| `@OPT-BEH-BEH-011` | tilgang | saksbehandler ved tilbyder overstyrer utdanningsbakgrunn | kan bare sette tilbudsgaranti | backend avviser, men velgeren i UI er aktiv for alle | usikker | `SB/features/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx:301-308`; `MIG/V502__opptaksforvalter_overstyrer_uten_saksbehandlingstilgang.sql:15-44` |
| `@OPT-BEH-BEH-011` | organisasjon | saksbehandler ved urelatert organisasjon leser sak | ser ingenting | 0 rader | stemmer | `IT/saksbehandling/TilbyderSerSakenRLSIT.java:154-161` |
| `@OPT-BEH-BEH-011` | organisasjon | saksbehandler ved annen organisasjon leser grunnlag, poeng og kvote på radnivå | bare saker hos organisasjonen | lesepolicyene sjekker rolle uten organisasjon; grensen ligger i at saken er RLS-styrt | usikker | `MIG/V291__saksbehandling_skjema.sql:1600-1603,1791-1794`; `MIG/V493__tilbyder_ser_saksbehandlingen.sql:6-7` |
| `@OPT-BEH-BEH-011` | tilgang | opptaksforvalter ved forvaltende organisasjon leser alle sakene | ser alle | ja | stemmer | `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35`; `IT/…/ForvalterLeserSakerRLSIT.java:99,110` |
| `@OPT-BEH-BEH-011` | tilgang | opptaksforvalter overstyrer utdanningsbakgrunn og flytter saken | ikke bundet av fristen | ja, uten egen sak | stemmer | `SVC/opptak/Utdanningsbakgrunnsfrist.java:37`; `MIG/V502__opptaksforvalter_overstyrer_uten_saksbehandlingstilgang.sql:15-34` |
| `@OPT-BEH-BEH-011` | tilgang | søker leser sak | ser ikke sakene | ingen søkergren i sak-policyene | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52`; `IT/…/SokerSaksbehandlendeOrganisasjonRLSIT.java:110-132` |
| `@OPT-BEH-BEH-011` | tilgang | søker leser saksbehandlende organisasjon | ser organisasjonen for hvert søknadsalternativ | view med bare egne, fordelte alternativer | stemmer | `MIG/V504__soker_saksbehandlende_organisasjon.sql:15-26` |
| `@OPT-BEH-BEH-011` | konsistens | flytting: gammel sak | interne merknader blir igjen | blir stående med merknader, dokumenter og grunnlag; inaktiv når den er tom | stemmer | `SVC/saksbehandling/BehandlertildelingService.java:375-378,583-602` |
| `@OPT-BEH-BEH-011` | konsistens | flytting: ny sak | ubehandlet sak | `UBEHANDLET`, saksnummer `soknadsnr-løpenr` | stemmer | `MIG/V291__saksbehandling_skjema.sql:75`; `SVC/saksbehandling/BehandlertildelingService.java:441-468` |
| `@OPT-BEH-BEH-011` | konsistens | flytting: tilbudsgarantier | følger med | alle tre kopieres | stemmer | `SVC/saksbehandling/BehandlertildelingService.java:416-424` |
| `@OPT-BEH-BEH-011` | konsistens | flytting: mottaker har allerede en sak for søknaden | ikke beskrevet | eksisterende sak gjenbrukes med status og innhold | stemmer | `SVC/saksbehandling/BehandlertildelingService.java:445-457,554-568` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Kode: 1–40 tegn, store bokstaver, tall og `_:,.-+`, unik i opptaket, påkrevd, kan ikke endres etter opprettelse | validering | `MIG/V395__behandlertildelingsregel_per_opptak.sql:71`; `ADM/components/BehandlertildelingsregelEditor.tsx:352` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Navn er påkrevd, maks 100 tegn | obligatorisk felt | `ADM/components/BehandlertildelingsregelEditor.tsx:284-286` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Fordelingen («Hvem skal saksbehandle?») er påkrevd, nøyaktig én av fire | obligatorisk felt | `ADM/components/BehandlertildelingsregelEditor.tsx:286` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Ny regel er aktiv som standard | standardverdi | `SVC/regelverk/BehandlertildelingsregelMutations.java:51` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Standardregelen må være aktiv; lista over valg viser bare aktive regler | validering | `SVC/opptak/OpprettOpptakMutations.java:418-422`; `ADM/components/BehandlertildelingsregelStandard.tsx:37` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | API-et lar standardregelen settes til ingen; tildelingen stopper da | annet | `SVC/opptak/OpprettOpptakMutations.java:395-398`; `SVC/saksbehandling/BehandlertildelingService.java:95-98` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Utdanningstilbud kan ikke velge en inaktiv regel eller en regel fra et annet opptak | validering | `SVC/opptak/UtdanningstilbudMutations.java:361-385` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Høyst ett unntak per utdanningsbakgrunn; realkompetanse og dispensasjon kan ikke ha unntak (vises deaktivert med forklaring) | validering | `SVC/regelverk/BehandlertildelingsregelMutations.java:171-190`; `ADM/components/BehandlertildelingsregelUnntak.tsx:107-120` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Organisasjonen i unntak for utdanningsbakgrunn trenger ikke delta i opptaket; tom organisasjon betyr tilbyderen | annet | `SVC/regelverk/BehandlertildelingsregelMutations.java:197-199`; `ADM/components/BehandlertildelingsregelUnntak.tsx:80-90` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Organisasjon for sektoren er valgfri (tom betyr tilbyderen søkeren har prioritert høyest) og gjelder bare «Tilbydere i samme sektor» | standardverdi | `ADM/utils/convertDataToInput.ts:41-47` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Unntak for lærested: begge kolonner er påkrevd, og lærestedet kan ikke saksbehandle på vegne av seg selv | validering | `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:46-47,126-135`; `MIG/V478__behandlertildelingsregel_pa_vegne_av.sql:31-32` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | «Legg til unntak» for lærested er skjult når opptaket ikke har deltakere, og deaktivert når alle deltakerne er brukt | annet | `ADM/components/BehandlertildelingsregelPaVegneAv.tsx:136-138,289-309` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Regelen kan ikke lagres (heller ikke en endring av navnet på en inaktiv regel) mens en organisasjon i unntaket for lærested eller sektoren ikke deltar i opptaket | validering | `SVC/regelverk/BehandlertildelingsregelMutations.java:86-87,113-127` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Bare én aktiv regel med «Alle som deltar i opptaket» gjelder også når en inaktiv regel aktiveres | validering | `MIG/V395__behandlertildelingsregel_per_opptak.sql:88-90` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Et opptak kan bare gjøres lokalt når det ikke har deltakere eller andre regler enn standardregelen | validering | `SVC/opptak/OpprettOpptakMutations.java:329-346` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Fordelingen er asynkron (hendelsesjobben), og venter når opptaket mangler standardregel | annet | `SVC/saksbehandling/SoknadshendelseJobb.java:287-313` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Tom sak blir inaktiv (slettes ikke) og vises ikke i «Saker i opptak»; den aktiveres igjen når den får et alternativ | tilstandsovergang | `SVC/saksbehandling/BehandlertildelingService.java:554-602`; `GQL/saksbehandling/sak.graphqls:2-8` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Saksnummeret er `søknadsnummer-løpenummer`, og løpenummeret fortsetter fra det høyeste | annet | `SVC/saksbehandling/BehandlertildelingService.java:441-468,604-616` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Ved flytting blir grunnlag, poeng og kvote igjen i den gamle saken; flyttes alternativet tilbake, kan de gamle radene dukke opp igjen | tilstandsovergang | `SVC/saksbehandling/BehandlertildelingService.java:375-378,411-427` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Mottakerens eksisterende sak for søknaden gjenbrukes uten å nullstille status eller innhold | tilstandsovergang | `SVC/saksbehandling/BehandlertildelingService.java:445-457` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Tildelt saksbehandler blir stående på den gamle saken; den nye saken har ingen | annet | `SVC/saksbehandling/BehandlertildelingService.java:458-465` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Saksbehandlerens overstyring lagres alltid, men flytter bare når den gjelder i tildelingen; opptaksforvalteren kan da velge «Flytt saken» | tilstandsovergang | `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:44-76,109-124`; `SB/features/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx:227-247` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Saksbehandleren kan ikke fjerne eller endre en overstyring opptaksforvalteren har gjort | tilgangssjekk | `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:126-149` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Fristen kan ikke omgås ved å endre søknaden på vegne av søkeren | validering | `SVC/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:150-176` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Er fristen ikke satt, regnes den som gått ut for saksbehandleren | standardverdi | `SVC/opptak/Utdanningsbakgrunnsfrist.java:35-37` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Søkeren ser opptakets organisasjon som kontakt når søknadsalternativet ikke er fordelt ennå | standardverdi | `MK664/_utils/group-by-saksbehandler.ts:26-28` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser de interne merknadene hos alle organisasjonene i opptaket, også etter flytting | tilgangssjekk | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:69-87` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Tilbyderen ser praksisperiodene i saken | tilgangssjekk | `MIG/V501__tilbyderoppslag_per_sak.sql:75-90` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Tilbyderen ser bare sakene der den har et søknadsalternativ, ikke de andre sakene i søknaden | tilgangssjekk | `MIG/V501__tilbyderoppslag_per_sak.sql:22-35` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | 3 av 5 | 5 av 7 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `min-kompetanse` | !994 Draft: feat(soknad): vis saksbehandlende organisasjon i kontakt seksjon (`stek-664-vis-saksbehandlende-organisasjon`) | utkast | `@OPT-BEH-BEH-011` | 1/1 | Brukeren har sagt at MR-en regnes som implementert, så scenarioet står som `funnet` |
| `fs-plattform` | !6556 STEK-651: Oppdater saker etter endring i regelverk (`mahj/STEK-651`) | åpen | – | 0 | usikker kobling: gjelder regelverk, ikke saksbehandlertildeling |
| `fs-admin` | !3329 Draft: oppdater saker etter endring i regelverk (`mahj/STEK-651`) | utkast | – | 0 | usikker kobling, som over |

## Kontroll

To kontrollører (`fs-verify-kontroll`) delte rapporten: den ene tok oppsett, fordeling og unntak for lærested, den andre endring, innsyn og flyten. De leste alle radene som var nye siden forrige levering (unntak for lærested, flytting, tilbyderen og søkeren), og alle radene med `usikker` eller `avviker`. For 25 rader i reglene som var levert fra før (oppsett, fordeling og unntak for utdanningsbakgrunn), tok de bare stikkprøver av algoritmen og testene, og avkreftet ingen av dem.

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | scenario | Lærestedene kan velge behandlertildelingsregelen opptaket har satt opp | ikke funnet | ikke funnet | Kontrollen fant koden (`SVC/opptak/UtdanningstilbudMutations.java:355-395`), men fasen er ikke levert, og da er scenarioet `ikke funnet` uten søk (*Verifisere flyt* i `fs-verify`). Blir funnet når `@OPT-OVO-SAM-001` er levert |
| `@FLY-OPT-SAK-001` | scenario | Utdanningstilbudet får behandlertildelingsregelen fra opptaket | ikke funnet | ikke funnet | Som over: kontrollen fant `SVC/opptak/UtdanningstilbudMutations.java:361-395`, men `@OPT-OPT-UTD-004` er `@draft` |
| `@FLY-OPT-SAK-001` | scenario | Saksbehandlertildelingen bruker fristen opptaket har satt | ikke funnet | ikke funnet | Som over: kontrollen fant `SVC/opptak/Utdanningsbakgrunnsfrist.java:27-38`, men regelen om fristen i `@OPT-OVO-FRI-001` er ikke `@implemented` |
| `@OPT-BEH-BEH-011` | regel | Regelen kan ikke lagres mens en organisasjon i unntaket for lærested eller sektoren ikke deltar | «kan ikke aktiveres» | «kan ikke lagres» | `SVC/regelverk/BehandlertildelingsregelMutations.java:86-87,113-127` sjekker ved enhver oppdatering, ikke bare ved aktivering |
| `@OPT-BEH-BEH-011` | regel | Opptaksforvalteren ser interne merknader hos alle, tilbyderen ser praksisperiodene, tilbyderen ser bare saker med egne alternativer | – | lagt til | `MIG/V493__tilbyder_ser_saksbehandlingen.sql:69-87`; `MIG/V501__tilbyderoppslag_per_sak.sql:22-35,75-90` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-011` — Tildele saksbehandlende organisasjon (`@in-progress`, 61/62 funnet) — «Lærestedet kan bare ha ett unntak for lærested per behandlertildelingsregel» (`krav/…/tildele_saksbehandlende_organisasjon.feature:324`) er usikker: lærestedet vises deaktivert, ikke skjult. Avgjør brukeren at scenarioet er funnet, kan kravet bli `@implemented`
- `@FLY-OPT-SAK-001` — Saksbehandlertildeling (`@planned`, 3/7 funnet) — 4 av 5 faser var ikke levert (3 etter denne kjøringen), og «Søknaden blir én sak hos hver saksbehandlende organisasjon» bruker «SPE» der koden krever «UVH»

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Tildele saksbehandlende organisasjon | `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` | `@in-progress` | 62/62 |

`@implemented` er fjernet fra de 11 delene som hadde det (9 regler og 2 scenarioer). Brukeren godkjente samtidig tre endringer i teksten: steget i «Lærestedet kan bare ha ett unntak …» er nå «kan ikke velge», kommentaren under «Tilbyderen kan ikke endre saksbehandlingen» sier at tilbyderen ikke ser dokumentene, og den utdaterte kommentaren om SPE er fjernet.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | `@planned` | 3/7 | 3 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Tilbyderen kan velge utdanningsbakgrunn i UI:** velgeren i `SB/features/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx:301-308` er ikke rollestyrt; backend avviser lagringen
- **Slett vises for regel søknader er tildelt etter:** brukstallet teller ikke `soknad_behandlertildeling`, så sletting feiler først ved lagring, `ADM/components/BehandlertildelingsregelEditor.tsx:264-266`
- **Organisasjon i «Fordeles til» kan tas ut av opptaket:** `SVC/opptak/OpprettOpptakMutations.java:642-690` sjekker bare sektor og unntak for lærested
- **Grunnlag, poeng og kvote er ikke organisasjonsavgrenset på radnivå:** grensen er at saken er RLS-styrt, `MIG/V493__tilbyder_ser_saksbehandlingen.sql:6-7`
- **Kravteksten:** feltet heter «Navn» i FS Admin, kravet sier «Beskrivelse» (linje 43); grunndata har «Videregående steinerskole», kravet sier «Rudolf Steinerskole»; «Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig» (linje 243) mangler et `Gitt`-steg om at standardregelen har unntaket for «Utenlandsk». Rettes med `fs-krav`
- **Det gamle valget per deltaker finnes fortsatt:** `settSamordnaDeltakerBehandler`, `SVC/opptak/OpprettOpptakMutations.java:437-476`, følges opp i STEK-668
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Behandlertildelingsreglene settes for opptaket» — skal flyten bruke «UVH», så testdataene betyr det samme i flyten og i kravet? Koden bekrefter at «Søknaden blir én sak hos hver saksbehandlende organisasjon» bare stemmer med «UVH»
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Utdanningstilbudet får behandlertildelingsregel» — skal fase 1 og 2 slås sammen?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon» — holder det med de to siste stegene?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Den saksbehandlende organisasjonen ser saken» — skal tilbudsgarantien være en egen fase, og hvilken overlevering skal fasen vise?
- **Ikke valgt i denne kjøringen:** avhengighetene (`@OPT-OVO-SAM-001`, `@OPT-OPT-UTD-004`, `@OPT-OVO-FRI-001`, `@OPT-BEH-BEH-010`) er lest fra taggene, ikke verifisert
