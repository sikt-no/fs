# Verifisering: tildele_saksbehandlende_organisasjon.feature

- **Dato:** 2026-10-08
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` (`@OPT-BEH-BEH-007`), og regelen «Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud» i `opptaksinnstillinger_utdanningstilbud.feature` (`@OPT-OPT-UTD-004`)
- **Kode:** `fs-plattform` (origin/main `5a8929a09d`), `fs-admin` (origin/main `4f5e65514`)

Kartlegging av et krav som er `@draft`, ikke en retagging. Mye av funksjonaliteten er bygget før kravet ble skrevet (STEK-492), så kartleggingen viser hva som er bygget, hva som er bygget annerledes enn kravet, og hva som mangler. Den er grunnlaget for `fs-specify`. Ingen tagger er endret.

I tabellen er «bygget annerledes» ført som `ikke funnet`, med avviket i beviset.

Forkortelser i bevisene:

- `ALG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingAlgoritme.java`
- `BTS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java`
- `MUT` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/BehandlertildelingsregelMutations.java`
- `OPPMUT` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `EDIT` = `fs-admin/src/domains/opptak/features/Behandlertildelingsregler/components/BehandlertildelingsregelEditor.tsx`
- `CONV` = `fs-admin/src/domains/opptak/features/Behandlertildelingsregler/utils/convertDataToInput.ts`

I koden heter tildelingsregelen «behandlertildelingsregel». Fordelingene er `AV_ALLE` («Alle som deltar i opptaket»), `TILBYDER` («Bare tilbyderen – også for studieønsker uten egen regel»), `ISOLERT` («Bare tilbyderen – bare dette studieønsket») og `SEKTOR` («Tilbydere i samme sektor»).

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (kravet er `@draft`)
- Scenarioer kartlagt: 60
- Bygget som beskrevet: 41
- Bygget annerledes: 15
- Ikke bygget: 2
- Usikker: 2 (søkerflaten ligger ikke i disse repoene, og tilbyderens tilgang er ikke lest fullt ut)

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Opprette tildelingsregel | funnet | `MUT:32-56`, `EDIT:62-83` |
| `@OPT-BEH-BEH-007` | Nytt opptak får standard tildelingsregel med «Alle som deltar i opptaket» | funnet | `OPPMUT:57,117-118,315-327` (regelen «ORD», `AV_ALLE`, aktiv) |
| `@OPT-BEH-BEH-007` | Bytte standard tildelingsregel | ikke funnet | Bygget annerledes: bare i API-et (`OPPMUT:372-411`, `settBehandlertildelingsregelDefault`). Ikke i fs-admin |
| `@OPT-BEH-BEH-007` | Opptaket kan bare ha én aktiv tildelingsregel med «Alle som deltar i opptaket» | funnet | `MIG/V395__behandlertildelingsregel_per_opptak.sql:87-90` (unik indeks) |
| `@OPT-BEH-BEH-007` | Se hvilke utdanningstilbud som er knyttet til tildelingsregelen | ikke funnet | Bygget annerledes: antallet vises (`EDIT:218-223`), men ikke hvilke utdanningstilbud |
| `@OPT-BEH-BEH-007` | Slette tildelingsregel som ikke er knyttet til utdanningstilbud | funnet | `MUT:109-127`, `EDIT:225-252` |
| `@OPT-BEH-BEH-007` | Tildelingsregel som er knyttet til utdanningstilbud kan ikke slettes | ikke funnet | Bygget annerledes: backend avviser, men sletteknappen er deaktivert, ikke skjult (`EDIT:466`) |
| `@OPT-BEH-BEH-007` | Tildelingsregel som <bruk> kan ikke deaktiveres | funnet | `MUT:80-83,175-196`, `EDIT:304` |
| `@OPT-BEH-BEH-007` | Tildelingsreglene er ikke tilgjengelige i lokale opptak | ikke funnet | Bygget annerledes: bare lenken er skjult (`fs-admin/src/domains/opptak/features/OpptakManagement/Samordning/Samordning.tsx:47-60`). Siden og API-et sjekker ikke om opptaket er samordnet |
| `@OPT-BEH-BEH-007` | Deltakende lærested kan ikke endre tildelingsreglene | funnet | `MIG/V395__behandlertildelingsregel_per_opptak.sql:128-146`, `EDIT:159-161` |
| `@OPT-OPT-UTD-004` | Velge saksbehandlertildelingsregel for et utdanningstilbud | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java:195-241`, `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:571-586` |
| `@OPT-OPT-UTD-004` | Utdanningstilbud uten egen saksbehandlertildelingsregel følger opptakets standardregel | funnet | `BTS:204-224`, `UtdanningstilbudDetails.tsx:571-573` |
| `@OPT-OPT-UTD-004` | Kun aktive saksbehandlertildelingsregler i opptaket kan velges | ikke funnet | Bygget annerledes: bare UI-et filtrerer på aktive regler. `UtdanningstilbudMutations.java:195-241` godtar en inaktiv regel |
| `@OPT-BEH-BEH-007` | Lærestedet på første prioritet saksbehandler hele søknaden | funnet | `ALG:224-250` |
| `@OPT-BEH-BEH-007` | Søknadsalternativ med egen tildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden | funnet | `ALG:189-193` |
| `@OPT-BEH-BEH-007` | Tilbyderen saksbehandler søknadsalternativene uten egen tildelingsregel | funnet | `ALG:195-211` |
| `@OPT-BEH-BEH-007` | Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen tildelingsregel | funnet | `ALG:197-209` (når `prioritetsnrTilbyder` er lik, og UI-et setter alltid 1, `CONV:41-44`) |
| `@OPT-BEH-BEH-007` | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | funnet | `ALG:189-193` |
| `@OPT-BEH-BEH-007` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | funnet | `BTS:201-226`, `ALG:189-193` (standardregelen kan bare settes via API-et) |
| `@OPT-BEH-BEH-007` | Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren | funnet | `ALG:213-222,280-286` |
| `@OPT-BEH-BEH-007` | Organisasjonen som er valgt på tildelingsregelen saksbehandler hele sektoren | ikke funnet | Bygget annerledes: virker i backend (`ALG:217`), men fs-admin har ikke feltet (`CONV:45`, `TODO(STEK-492)`) |
| `@OPT-BEH-BEH-007` | Søknadsalternativer i ulike sektorer fordeles hver for seg | funnet | `ALG:216-221` |
| `@OPT-BEH-BEH-007` | Sektoren er lærestedene som har utdanningstilbud med samme tildelingsregel | funnet | `BTS:201-226` (sektoren er alternativene med samme regelkode) |
| `@OPT-BEH-BEH-007` | Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen tildelingsregel | ikke funnet | Bygget annerledes: `TILBYDER` kjøres før `SEKTOR` (`ALG:134-144`), så SPE vinner uansett søkerens prioritering |
| `@OPT-BEH-BEH-007` | Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren | ikke funnet | Bygget annerledes: bare i API-et (`MUT:46`). Ikke i fs-admin (`CONV:45`) |
| `@OPT-BEH-BEH-007` | Organisasjonen for sektoren må delta i opptaket | ikke funnet | Ingen sjekk av deltakelse i `MUT:32-56,129-150`, bare fremmednøkkel mot `organisasjon` |
| `@OPT-BEH-BEH-007` | Legge til unntak for utdanningsbakgrunn | funnet | `MUT:96-103,152-173`, `fs-admin/src/domains/opptak/features/Behandlertildelingsregler/components/BehandlertildelingsregelUnntak.tsx:165-246` |
| `@OPT-BEH-BEH-007` | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn> | funnet | `ALG:157-187` (unntaket må ligge på hver regel søknaden bruker) |
| `@OPT-BEH-BEH-007` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse | ikke funnet | Bygget annerledes: virker bare når forvalteren har lagt unntaket på regelen (`ALG:169`). Nye opptak får ingen unntak (`OPPMUT:315-327`) |
| `@OPT-BEH-BEH-007` | Unntaket går foran tildelingsregel der bare tilbyderen saksbehandler | funnet | `ALG:138-139,157-174,195-199` |
| `@OPT-BEH-BEH-007` | Tildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig | funnet | `ALG:164-167` |
| `@OPT-BEH-BEH-007` | Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass | ikke funnet | Bygget annerledes: krever avkrysningen `fordelTilbyderEtterFrist` på regelen (`ALG:146-155`). Har `@openquestion` |
| `@OPT-BEH-BEH-007` | Ledig studieplass går foran unntak for utdanningsbakgrunn | funnet | `ALG:137-139,159-163` (når avkrysningen er satt) |
| `@OPT-BEH-BEH-007` | Tilbyderen saksbehandler ledig studieplass også etter at perioden for ledige studieplasser er stengt | ikke funnet | Bygget annerledes: stengt periode spiller ingen rolle (`BTS:228-239`), men avkrysningen på regelen er påkrevd. Har `@openquestion` |
| `@OPT-BEH-BEH-007` | Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket | ikke funnet | Bygget annerledes: egen mutasjon i API-et (`OPPMUT:419-459`). Ikke i fs-admin |
| `@OPT-BEH-BEH-007` | Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene | funnet | `BTS:125,137,275-283` |
| `@OPT-BEH-BEH-007` | Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket | funnet | `OPPMUT:438-452` (bare API-et) |
| `@OPT-BEH-BEH-007` | Endret valg gjelder bare søknadsalternativer som ikke er fordelt | funnet | `ALG:274-278` |
| `@OPT-BEH-BEH-007` | Søknadsalternativene fordeles når <hendelse> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java:870,978,1063`, `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:312` |
| `@OPT-BEH-BEH-007` | Søknaden får én sak per saksbehandlende organisasjon | funnet | `BTS:377-398,477-506` |
| `@OPT-BEH-BEH-007` | Tilbyder som ikke er saksbehandlende organisasjon får ingen sak | funnet | `BTS:386` |
| `@OPT-BEH-BEH-007` | Ny prioritering endrer ikke saksbehandlende organisasjon | funnet | `ALG:274-293` |
| `@OPT-BEH-BEH-007` | Nytt søknadsalternativ uten egen tildelingsregel får samme saksbehandlende organisasjon som før | funnet | `ALG:224-233,280-286` |
| `@OPT-BEH-BEH-007` | Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt | funnet | `ALG:189-193,274-278` |
| `@OPT-BEH-BEH-007` | Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene | funnet | `BTS:218,634-654`, `ALG:274-278` |
| `@OPT-BEH-BEH-007` | Søkeren bytter til utenlandsk utdanningsbakgrunn | funnet | `MIG/V400__hendelser_pa_utdanningstilbud_og_utdanningsbakgrunn.sql` (`omfordel_b_rolle`), `ALG:157-187`, `BTS:421-465` |
| `@OPT-BEH-BEH-007` | Søkeren bytter til realkompetanse | funnet | `MIG/V348__refordeling_b_rolle_ved_endret_utdanningsbakgrunn.sql:24`, `ALG:169-177` (krever unntaket på regelen) |
| `@OPT-BEH-BEH-007` | Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | funnet | `ALG:176` (`omfordel_b_rolle` er false for norsk) |
| `@OPT-BEH-BEH-007` | Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/UtdanningsbakgrunnOverstyringService.java:46-98` |
| `@OPT-BEH-BEH-007` | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Utdanningsbakgrunnsfrist.java:28-39` (frist som ikke er satt, regnes som utløpt) |
| `@OPT-BEH-BEH-007` | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | funnet | `Utdanningsbakgrunnsfrist.java:38` |
| `@OPT-BEH-BEH-007` | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til | ikke funnet | Bygget annerledes: tilbudsgaranti fra forvalter og tilbyder følger med, men garanti satt av organisasjonen saken flyttes fra, nullstilles (`BTS:440-462`) |
| `@OPT-BEH-BEH-007` | Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til | ikke funnet | Ingen status «Overført» i fs-plattform eller fs-admin. Har `@openquestion` |
| `@OPT-BEH-BEH-007` | Saksbehandleren ser bare saken hos organisasjonen sin | funnet | `MIG/V329__forvalter_leser_saker_i_eget_opptak.sql:62` (RLS på `sak.organisasjonskode`) |
| `@OPT-BEH-BEH-007` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | usikker | Søkeren har ingen tilgang til sakene (`V329`). Visningen for søkeren hører til `@OPT-SØK-SØK-005` (PR #623), og ligger ikke i disse repoene |
| `@OPT-BEH-BEH-007` | Saksbehandleren ved forvaltende organisasjon ser bare sakene hos forvaltende organisasjon | ikke funnet | Bygget annerledes: SE_SØKNADSBEHANDLING for forvaltende organisasjon gir lesetilgang til alle sakene i opptaket (`MIG/V329__forvalter_leser_saker_i_eget_opptak.sql:8-9,65`, beskrevet som et bevisst personvernvalg) |
| `@OPT-BEH-BEH-007` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | funnet | `MIG/V329__forvalter_leser_saker_i_eget_opptak.sql:65,74` |
| `@OPT-BEH-BEH-007` | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler | ikke funnet | Bygget annerledes: tilbyderen kan lese raden i `sak_soknadsalternativ` (`MIG/V346__kolonnevern_tilbudsgaranti.sql`), men ikke saken eller saksbehandlingen, og ingen side i fs-admin viser den |
| `@OPT-BEH-BEH-007` | Tilbyderen setter tilbudsgaranti | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java`, `MIG/V346__kolonnevern_tilbudsgaranti.sql` |
| `@OPT-BEH-BEH-007` | Tilbyderen kan ikke endre saksbehandlingen | usikker | Kolonnevern i `V346` og merknader i `MIG/V401__merknad_synlighet.sql` tyder på det, men ikke alle tabellpolicyer er lest. Har `@openquestion` |

## Avvik som må inn i spesifikasjonen

Koden må endres der kravet er avklart:

- SPE og JOU: søkerens prioritering skal avgjøre, ikke rekkefølgen i algoritmen.
- Realkompetanse skal alltid saksbehandles av tilbyderen, uten unntak på regelen.
- Saksbehandleren ved HK-dir skal bare se sakene HK-dir saksbehandler. Det går imot et bevisst valg i `V329`, og må avklares med dem som tok det.
- Tilbudsgaranti ved flytting: avklar om garantien fra organisasjonen saken flyttes fra skal følge med. Ellers må kravet presiseres.

Mangler i fs-admin: bytte standardregel, velge organisasjon for sektoren, velge organisasjon som saksbehandler på vegne av et lærested.

Mangler i backend: sjekk av at organisasjonen for sektoren deltar i opptaket, og sjekk av at en valgt tildelingsregel er aktiv.

UI som avviker fra mønsteret i `.claude/rules/design-patterns-for-krav.md`: sletteknappen er deaktivert i stedet for skjult. Lokale opptak: siden og API-et er tilgjengelige selv om lenken er skjult.

## Oppfølging

- Funnet i koden, men ikke beskrevet i kravet: en deaktivert regel fordeler fortsatt (`er_aktiv` leses ikke av fordelingen). Fordelingen skjer i en bakgrunnsjobb (`SoknadshendelseJobb`), og mangler opptaket standardregel, venter søknadene.
- UI-tekstene i fs-admin bruker «institusjon» (`fs-admin/src/common/messages/nb/opptak.json:436,442,467`), mot terminologien i `krav/README.md`.
- Funksjonen ligger bak et feature flag i fs-admin (`fs-admin/.changeset/stek-492-behandlertildelingsregler.md`).
- Krav utenfor scope: `se_saksbehandlende_organisasjon.feature` (`@OPT-SØK-SØK-005`, `@draft`, PR #623).
