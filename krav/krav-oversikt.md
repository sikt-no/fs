# Kravoversikt

Generert oversikt over alle BDD-krav i prosjektet.


## 01 Forberede studier

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| FOR-ADM-UTD-002 | Endre eksisterende utdanning | 10 Administrere utdanning | 01 Utdanning | @FOR-ADM-UTD-002 | [endre_utdanning.feature](01%20Forberede%20studier/10%20Administrere%20utdanning/01%20Utdanning/endre_utdanning.feature) |
| FOR-ADM-UTD-001 | Opprette utdanning | 10 Administrere utdanning | 01 Utdanning | @FOR-ADM-UTD-001 | [opprette_utdanning.feature](01%20Forberede%20studier/10%20Administrere%20utdanning/01%20Utdanning/opprette_utdanning.feature) |
| FOR-ADM-UTD-004 | Søk etter utdanninger | 10 Administrere utdanning | 01 Utdanning | @FOR-ADM-UTD-004 | [søk_etter_utdanninger.feature](01%20Forberede%20studier/10%20Administrere%20utdanning/01%20Utdanning/søk_etter_utdanninger.feature) |
| FOR-ADM-TIL-002 | Opprette kull | 10 Administrere utdanning | 02 Utdanningstilbud | @FOR-ADM-TIL-002 | [opprette_kull.feature](01%20Forberede%20studier/10%20Administrere%20utdanning/02%20Utdanningstilbud/opprette_kull.feature) |
| FOR-ADM-TIL-001 | Tilby utdanning | 10 Administrere utdanning | 02 Utdanningstilbud | @FOR-ADM-TIL-001 | [tilby_utdanning.feature](01%20Forberede%20studier/10%20Administrere%20utdanning/02%20Utdanningstilbud/tilby_utdanning.feature) |

## 02 Opptak

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| OPT-REG-KRA-001 | Kompetanseregelverk | 10 Regelverk | 02 Krav | @OPT-REG-KRA-001 @opptakspilot @opptakspilotkritisk @fsadmin @ci | [kompetanseregelverk.feature](02%20Opptak/10%20Regelverk/02%20Krav/kompetanseregelverk.feature) |
| OPT-REG-KVO-001 | Kvoter | 10 Regelverk | 04 Kvoter | @OPT-REG-KVO-001 | [kvoterregelverk.feature](02%20Opptak/10%20Regelverk/04%20Kvoter/kvoterregelverk.feature) |
| OPT-OPT-OPT-001 | Opprette et opptak | 11 Opptak | 01 Opptak | @OPT-OPT-OPT-001 @opptakspilot @fsadmin @ci | [opprette_opptak.feature](02%20Opptak/11%20Opptak/01%20Opptak/opprette_opptak.feature) |
| OPT-SØK-SØK-002 | Opprette søknad for person | 12 Registrere søknad | 01 Søknad | @OPT-SØK-SØK-002 @opptak @skip @nih | [opprette_søknad_for_person.feature](02%20Opptak/12%20Registrere%20søknad/01%20Søknad/opprette_søknad_for_person.feature) |
| OPT-SØK-SØK-001 | Søke på opptak | 12 Registrere søknad | 01 Søknad | @OPT-SØK-SØK-001 @opptakspilot @ci | [søke_på_opptak.feature](02%20Opptak/12%20Registrere%20søknad/01%20Søknad/søke_på_opptak.feature) |
| OPT-BEH-BEH-001 | Saksbehandler behandler søknader | 13 Søknadsbehandling | 01 Behandling | @OPT-BEH-BEH-001 @skip @opptakspilot @ci @focus | [behandle_søknad.feature](02%20Opptak/13%20Søknadsbehandling/01%20Behandling/behandle_søknad.feature) |
| OPT-BEH-BEH-002 | Kort om søknad | 13 Søknadsbehandling | 01 Behandling | @OPT-BEH-BEH-002 @skip @søknad @opptak | [kort_om_søknad.feature](02%20Opptak/13%20Søknadsbehandling/01%20Behandling/kort_om_søknad.feature) |

## 03 Gjennomføre studier

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| GJE-STU-STA-002 | Opplysninger om betalt semesteravgift | 10 Studentstatus | 01 Status | @GJE-STU-STA-002 @skip @ci | [opplysninger_betalt_semesteravgift.feature](03%20Gjennomføre%20studier/10%20Studentstatus/01%20Status/opplysninger_betalt_semesteravgift.feature) |
| GJE-STU-STA-001 | Registrert inneværende semester | 10 Studentstatus | 01 Status | @GJE-STU-STA-001 @ci @studieadministrasjon | [registrert_student.feature](03%20Gjennomføre%20studier/10%20Studentstatus/01%20Status/registrert_student.feature) |
| GJE-STR-STR-001 | Kort om studieprogram | 11 Studierett | 01 Studierett | @GJE-STR-STR-001 @ci | [kort_om_studieprogram.feature](03%20Gjennomføre%20studier/11%20Studierett/01%20Studierett/kort_om_studieprogram.feature) |
| GJE-STR-STR-002 | Utdanningsoversikt for person | 11 Studierett | 01 Studierett | @GJE-STR-STR-002 @skip @studieadministrasjon | [utdanningsoversikt.feature](03%20Gjennomføre%20studier/11%20Studierett/01%20Studierett/utdanningsoversikt.feature) |
| GJE-DAT-INT-002 | Oversikt over samtykker og informasjon om datadeling | 12 Datadeling | 01 Integrasjoner | @GJE-DAT-INT-002 @skip @støtteprosesser | [samtykker_person.feature](03%20Gjennomføre%20studier/12%20Datadeling/01%20Integrasjoner/samtykker_person.feature) |
| GJE-DAT-INT-001 | Studentopplysninger til Lånekassen | 12 Datadeling | 01 Integrasjoner | @GJE-DAT-INT-001 @lånekassen @fs @fsgraphql | [studentopplysninger_lånekassen_har_behov_for.feature](03%20Gjennomføre%20studier/12%20Datadeling/01%20Integrasjoner/studentopplysninger_lånekassen_har_behov_for.feature) |

## 04 Kompetanse

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| KOM-RES-RES-001 | Se egne resultater | 10 Resultater | 01 Resultater | @KOM-RES-RES-001 | [se_egne_resultater.feature](04%20Kompetanse/10%20Resultater/01%20Resultater/se_egne_resultater.feature) |

## 05 Opplysninger om person

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| OPP-SØK-SØK-002 | Gruppesøk | 10 Søk | 01 Søk | @OPP-SØK-SØK-002 | [gruppesøk.feature](05%20Opplysninger%20om%20person/10%20Søk/01%20Søk/gruppesøk.feature) |
| OPP-SØK-SØK-001 | Personsøk | 10 Søk | 01 Søk | @OPP-SØK-SØK-001 @støtteprosesser | [personsøk.feature](05%20Opplysninger%20om%20person/10%20Søk/01%20Søk/personsøk.feature) |
| OPP-PRO-PRO-004 | Se og endre egne kontaktopplysninger | 11 Personprofil | 01 Profil | @OPP-PRO-PRO-004 @skip @personopplysning | [kontaktopplysninger_felles.feature](05%20Opplysninger%20om%20person/11%20Personprofil/01%20Profil/kontaktopplysninger_felles.feature) |
| OPP-PRO-PRO-003 | Se og endre egne personopplysninger | 11 Personprofil | 01 Profil | @OPP-PRO-PRO-003 @skip @personopplysning | [personopplysninger_felles.feature](05%20Opplysninger%20om%20person/11%20Personprofil/01%20Profil/personopplysninger_felles.feature) |
| OPP-PRO-PRO-001 | Personprofil | 11 Personprofil | 01 Profil | @OPP-PRO-PRO-001 | [personprofil_fsadmin.feature](05%20Opplysninger%20om%20person/11%20Personprofil/01%20Profil/personprofil_fsadmin.feature) |
| OPP-PRO-PRO-002 | Se og endre egne person- og kontaktopplysninger | 11 Personprofil | 01 Profil | @OPP-PRO-PRO-002 @skip @personopplysning | [personprofil_personflate.feature](05%20Opplysninger%20om%20person/11%20Personprofil/01%20Profil/personprofil_personflate.feature) |
| OPP-SAM-SAM-001 | Se og endre egne samtykker | 12 Samtykker | 01 Samtykker | @OPP-SAM-SAM-001 @skip @personopplysninger | [samtykker.feature](05%20Opplysninger%20om%20person/12%20Samtykker/01%20Samtykker/samtykker.feature) |
| OPP-INT-FOL-001 | Integrasjon mot folkeregisteret for å oppdatere personopplysninger for læresteder | 13 Integrasjoner | 01 Folkeregister | @OPP-INT-FOL-001 @skip @personopplysning | [folkeregisterintegrasjon.feature](05%20Opplysninger%20om%20person/13%20Integrasjoner/01%20Folkeregister/folkeregisterintegrasjon.feature) |

## 07 Tilgangstyring

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| TIL-PÅL-PÅL-001 | Feide | 10 Pålogging | 01 Pålogging | @TIL-PÅL-PÅL-001 @opptakspilot @focus @ci @opplysning | [feide_pålogging.feature](07%20Tilgangstyring/10%20Pålogging/01%20Pålogging/feide_pålogging.feature) |
| TIL-PÅL-PÅL-002 | ID-porten | 10 Pålogging | 01 Pålogging | @TIL-PÅL-PÅL-002 @opptakspilot | [idporten_pålogging.feature](07%20Tilgangstyring/10%20Pålogging/01%20Pålogging/idporten_pålogging.feature) |
| TIL-TIL-TIL-001 | Tilgangskontroll | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-001 @skip @støtteprosesser @sikkerhet | [tilgangskontroll.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangskontroll.feature) |
| TIL-TIL-TIL-003 | Tilgangsstyring ansatt-bruker | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-003 @skip @støtteprosesser @sikkerhet | [tilgangsstyring_ansattbruker.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangsstyring_ansattbruker.feature) |
| TIL-TIL-TIL-005 | Tilgangsstyring - Oversikt over API-tilganger | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-005 @skip @støtteprosesser @sikkerhet | [tilgangsstyring_api-tilganger_oversikt.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangsstyring_api-tilganger_oversikt.feature) |
| TIL-TIL-TIL-004 | Tilgangsstyring - Oversikt over API-brukere | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-004 @skip @støtteprosesser @sikkerhet | [tilgangsstyring_maskinbruker_oversikt.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangsstyring_maskinbruker_oversikt.feature) |
| TIL-TIL-TIL-006 | Tilgangsstyringsprosess | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-006 @skip @støtteprosesser @sikkerhet | [tilgangsstyring_prosess.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangsstyring_prosess.feature) |
| TIL-TIL-TIL-002 | Tilgangstyring av saksbehandler | 11 Tilganger | 01 Tilganger | @TIL-TIL-TIL-002 | [tilgangsstyring_saksbehandler.feature](07%20Tilgangstyring/11%20Tilganger/01%20Tilganger/tilgangsstyring_saksbehandler.feature) |
| TIL-BRU-BRU-001 | Opprettelse av personbruker | 12 Brukere | 01 Brukere | @TIL-BRU-BRU-001 @skip @personopplysninger | [opprette_bruker.feature](07%20Tilgangstyring/12%20Brukere/01%20Brukere/opprette_bruker.feature) |
| TIL-BRU-BRU-002 | Organisasjonsinstansvalg for brukere med flere tilganger | 12 Brukere | 01 Brukere | @TIL-BRU-BRU-002 @tilgangsstyring @organisasjonsinstansvalg | [organisasjonsinstansvalg_for_brukere_med_flere_tilganger.feature](07%20Tilgangstyring/12%20Brukere/01%20Brukere/organisasjonsinstansvalg_for_brukere_med_flere_tilganger.feature) |

## 08 Teknisk

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | 08 Teknisk: Gi tilbakemelding | 10 Brukergrensesnitt | 01 UI | @TEK-BRU-UI-003 @skip @støtteprosesser | [gi_tilbakemelding.feature](08%20Teknisk/10%20Brukergrensesnitt/01%20UI/gi_tilbakemelding.feature) |
|  | 08 Teknisk: API-brukerprofil | 10 Brukergrensesnitt | 01 UI | @TEK-BRU-UI-001 @skip @støtteprosesser @sikkerhet | [maskinbrukerprofil.feature](08%20Teknisk/10%20Brukergrensesnitt/01%20UI/maskinbrukerprofil.feature) |
|  | 08 Teknisk: Snarveismeny | 10 Brukergrensesnitt | 01 UI | @TEK-BRU-UI-002 @skip @støtteprosesser @kurs @ci | [snarveismeny.feature](08%20Teknisk/10%20Brukergrensesnitt/01%20UI/snarveismeny.feature) |

## 10 Felleskrav

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| FEL-TAB-TAB-002 | 10 Felleskrav: Eksport | 10 Tabellvisninger | 01 Tabeller | @FEL-TAB-TAB-002 | [eksport.feature](10%20Felleskrav/10%20Tabellvisninger/01%20Tabeller/eksport.feature) |
| FEL-TAB-TAB-001 | 10 Felleskrav: Filter | 10 Tabellvisninger | 01 Tabeller | @FEL-TAB-TAB-001 @fsadmin | [filter.feature](10%20Felleskrav/10%20Tabellvisninger/01%20Tabeller/filter.feature) |
| FEL-SPR-SPR-001 | 10 Felleskrav: Språkvalg påvirker søk og resultat | 11 Språk | 01 Språkvalg | @FEL-SPR-SPR-001 | [sprakvalg_sok_resultat.feature](10%20Felleskrav/11%20Språk/01%20Språkvalg/sprakvalg_sok_resultat.feature) |

## 99 Demo

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
| DEM-STU-SØK-001 | Filtrere og søke i studiekatalogen | 01 Studiekatalog | 01 Søk og filter | @DEM-STU-SØK-001 @demo @should | [studiekatalog_filtrering.feature](99%20Demo/01%20Studiekatalog/01%20Søk%20og%20filter/studiekatalog_filtrering.feature) |
| DEM-INN-FEI-001 | Feide-innlogging | 02 Innlogging | 01 Feide | @DEM-INN-FEI-001 @demo | [feide_innlogging.feature](99%20Demo/02%20Innlogging/01%20Feide/feide_innlogging.feature) |
| DEM-OPT-OPT-002 | Opprette opptak via API | 03 Opptak | 01 Opptaksdemo | @DEM-OPT-OPT-002 @demo @integration @planned @should | [opptak_demo_api.feature](99%20Demo/03%20Opptak/01%20Opptaksdemo/opptak_demo_api.feature) |
| DEM-OPT-OPT-001 | Opprette et opptak | 03 Opptak | 01 Opptaksdemo | @DEM-OPT-OPT-001 @demo @implemented @must | [opptak_demo.feature](99%20Demo/03%20Opptak/01%20Opptaksdemo/opptak_demo.feature) |
| DEM-API-GRA-001 | GraphQL API integrasjon | 04 API | 01 GraphQL | @DEM-API-GRA-001 @demo @integration @implemented @must | [graphql_integrasjon.feature](99%20Demo/04%20API/01%20GraphQL/graphql_integrasjon.feature) |
| DEM-PER-PER-001 | Personsøk | 05 Personsøk | 01 Personsøk | @DEM-PER-PER-001 @demo | [personsok.feature](99%20Demo/05%20Personsøk/01%20Personsøk/personsok.feature) |
| DEM-ORG-ORG-001 | Organisasjonssøk | 06 Organisasjonssøk | 01 Organisasjonssøk | @DEM-ORG-ORG-001 @demo | [organisasjonssok.feature](99%20Demo/06%20Organisasjonssøk/01%20Organisasjonssøk/organisasjonssok.feature) |

## Statistikk

- Totalt: 50
- Levert: 4
- Skip: 22
