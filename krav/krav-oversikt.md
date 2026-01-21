# Kravoversikt

Generert oversikt over alle BDD-krav i prosjektet.


## 01 Forberede studier

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Timeplanlegge Utdanningsaktiviteter | 11 Planlegge undervisning |  |  | [timeplanlegge_utdanningsaktiviteter.feature](01%20Forberede%20studier/11%20Planlegge%20undervisning/timeplanlegge_utdanningsaktiviteter.feature) |
|  | Oppnevne Sensor | 12 Planlegge vurdering |  |  | [oppnevne_sensor.feature](01%20Forberede%20studier/12%20Planlegge%20vurdering/oppnevne_sensor.feature) |
|  | Planlegge Vurdering | 12 Planlegge vurdering |  |  | [planlegge_vurdering.feature](01%20Forberede%20studier/12%20Planlegge%20vurdering/planlegge_vurdering.feature) |
|  | Avtale om Utdanningstilbud |  |  |  | [avtale_om_utdanningstilbud.feature](01%20Forberede%20studier/avtale_om_utdanningstilbud.feature) |
|  | Endre eksisterende utdanning |  |  |  | [endre_utdanning.feature](01%20Forberede%20studier/endre_utdanning.feature) |
|  | Evaluere og Vedlikeholde Utdanning |  |  |  | [evaluere_og_vedlikeholde_utdanning.feature](01%20Forberede%20studier/evaluere_og_vedlikeholde_utdanning.feature) |
|  | Forberede Betaling |  |  |  | [forberede_betaling.feature](01%20Forberede%20studier/forberede_betaling.feature) |
|  | Informasjon om Organisasjon |  |  |  | [informasjon_om_organisasjon.feature](01%20Forberede%20studier/informasjon_om_organisasjon.feature) |
|  | Opprette kull |  |  |  | [opprette_kull.feature](01%20Forberede%20studier/opprette_kull.feature) |
|  | Opprette utdanning |  |  |  | [opprette_utdanning.feature](01%20Forberede%20studier/opprette_utdanning.feature) |
|  | Søk etter utdanninger |  |  |  | [søk_etter_utdanninger.feature](01%20Forberede%20studier/søk_etter_utdanninger.feature) |
|  | Tilby utdanning |  |  |  | [tilby_utdanning.feature](01%20Forberede%20studier/tilby_utdanning.feature) |

## 02 Opptak

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  |  | 01 Forberede opptak | 01 Regelverk og grunnlag |  | [grunnlag.feature](02%20Opptak/01%20Forberede%20opptak/01%20Regelverk%20og%20grunnlag/grunnlag.feature) |
|  | Kompetanseregelverk | 01 Forberede opptak | 01 Regelverk og grunnlag | @opptakspilot @opptakspilotkritisk @fsadmin @ci | [kompetanseregelverk.feature](02%20Opptak/01%20Forberede%20opptak/01%20Regelverk%20og%20grunnlag/kompetanseregelverk.feature) |
|  | Kvoter | 01 Forberede opptak | 01 Regelverk og grunnlag |  | [kvoterregelverk.feature](02%20Opptak/01%20Forberede%20opptak/01%20Regelverk%20og%20grunnlag/kvoterregelverk.feature) |
|  |  | 01 Forberede opptak | 01 Regelverk og grunnlag |  | [rangeringsregelverk.feature](02%20Opptak/01%20Forberede%20opptak/01%20Regelverk%20og%20grunnlag/rangeringsregelverk.feature) |
| OPT-REG-GRU-001 | Opprette et opptak | 01 Forberede opptak |  | @opptakspilot @fsadmin @ci @OPT-REG-GRU-001 | [opprette_opptak.feature](02%20Opptak/01%20Forberede%20opptak/opprette_opptak.feature) |
|  | Opprette søknad for person | 02 Registrere søknader |  | @opptak @skip @nih | [opprette_søknad_for_person.feature](02%20Opptak/02%20Registrere%20søknader/opprette_søknad_for_person.feature) |
|  | Søke på opptak | 02 Registrere søknader |  | @opptakspilot @ci | [søke_på_opptak.feature](02%20Opptak/02%20Registrere%20søknader/søke_på_opptak.feature) |
|  | Saksbehandler behandler søknader | 03 Søknadsbehandling |  | @skip @opptakspilot @ci @focus | [behandle_søknad.feature](02%20Opptak/03%20Søknadsbehandling/behandle_søknad.feature) |
|  | Kort om søknad | 03 Søknadsbehandling |  | @skip @søknad @opptak | [kort_om_søknad.feature](02%20Opptak/03%20Søknadsbehandling/kort_om_søknad.feature) |
|  |  | 03 Søknadsbehandling |  |  | [saksbehandlertildeling.feature](02%20Opptak/03%20Søknadsbehandling/saksbehandlertildeling.feature) |
|  | Plasstildeling | 04 Opptakskjøring |  |  | [plasstildeling_main.feature](02%20Opptak/04%20Opptakskjøring/plasstildeling_main.feature) |
|  | Samordning av et opptak | 04 Opptakskjøring |  |  | [samordning.feature](02%20Opptak/04%20Opptakskjøring/samordning.feature) |
|  | Svare på tilbud | 04 Opptakskjøring |  |  | [svare_på_tilbud.feature](02%20Opptak/04%20Opptakskjøring/svare_på_tilbud.feature) |
|  | Tilbudsgaranti | 04 Opptakskjøring |  |  | [tilbudsgaranti.feature](02%20Opptak/04%20Opptakskjøring/tilbudsgaranti.feature) |

## 03 Gjennomføre studier

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Følge opp studenter |  |  | @skip | [følge_opp_studenter.feature](03%20Gjennomføre%20studier/følge_opp_studenter.feature) |
|  | Planlegge Vurdering |  |  | @skip | [gjennomføre_vurdering.feature](03%20Gjennomføre%20studier/gjennomføre_vurdering.feature) |
|  | Kort om studieprogram |  |  | @ci | [kort_om_studieprogram.feature](03%20Gjennomføre%20studier/kort_om_studieprogram.feature) |
|  | Opplysninger om betalt semesteravgift |  |  | @skip @ci | [opplysninger_betalt_semesteravgift.feature](03%20Gjennomføre%20studier/opplysninger_betalt_semesteravgift.feature) |
|  | Registrering av politiattest |  |  | @skip | [registrering_av_politattest.feature](03%20Gjennomføre%20studier/registrering_av_politattest.feature) |
|  | Registrert inneværende semester |  |  | @ci @studieadministrasjon | [registrert_student.feature](03%20Gjennomføre%20studier/registrert_student.feature) |
|  | Oversikt over samtykker og informasjon om datadeling |  |  | @skip @støtteprosesser | [samtykker_person.feature](03%20Gjennomføre%20studier/samtykker_person.feature) |
|  | Studentopplysninger til Lånekassen |  |  | @lånekassen @fs @fsgraphql | [studentopplysninger_lånekassen_har_behov_for.feature](03%20Gjennomføre%20studier/studentopplysninger_lånekassen_har_behov_for.feature) |
|  | Utdanningsoversikt for person |  |  | @skip @studieadministrasjon | [utdanningsoversikt.feature](03%20Gjennomføre%20studier/utdanningsoversikt.feature) |

## 04 Kompetanse

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Dele egne kompetansebevis |  |  | @skip | [dele_egne_kompetansebevis.feature](04%20Kompetanse/dele_egne_kompetansebevis.feature) |
|  | Få studentbevis |  |  | @skip | [få_studentbevis.feature](04%20Kompetanse/få_studentbevis.feature) |
|  | Hente resultater |  |  | @skip | [hente_resultater.feature](04%20Kompetanse/hente_resultater.feature) |
|  | Se egne resultater |  |  |  | [se_egne_resultater.feature](04%20Kompetanse/se_egne_resultater.feature) |
|  |  |  |  |  | [sensur.feature](04%20Kompetanse/sensur.feature) |
|  |  |  |  |  | [tildele_kompetansebevis.feature](04%20Kompetanse/tildele_kompetansebevis.feature) |
|  |  |  |  |  | [tildele_kvalifikasjon.feature](04%20Kompetanse/tildele_kvalifikasjon.feature) |
|  |  |  |  |  | [tildele_resultat.feature](04%20Kompetanse/tildele_resultat.feature) |

## 05 Opplysninger om person

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Personsøk |  |  | @støtteprosesser | [01 personsøk.feature](05%20Opplysninger%20om%20person/01%20personsøk.feature) |
|  | Gruppesøk |  |  |  | [02 gruppesøk.feature](05%20Opplysninger%20om%20person/02%20gruppesøk.feature) |
|  | Se og endre egne kontaktopplysninger |  |  | @skip @personopplysning | [03 kontaktopplysningerFelles.feature](05%20Opplysninger%20om%20person/03%20kontaktopplysningerFelles.feature) |
|  | Se og endre egne personopplysninger |  |  | @skip @personopplysning | [03 personopplysningerFelles.feature](05%20Opplysninger%20om%20person/03%20personopplysningerFelles.feature) |
|  | Personprofil |  |  |  | [03 personprofil fsadmin.feature](05%20Opplysninger%20om%20person/03%20personprofil%20fsadmin.feature) |
|  | Se og endre egne person- og kontaktopplysninger |  |  | @skip @personopplysning | [03 personprofil personflate.feature](05%20Opplysninger%20om%20person/03%20personprofil%20personflate.feature) |
|  | Se og endre egne samtykker |  |  | @skip @personopplysninger | [05 samtykker.feature](05%20Opplysninger%20om%20person/05%20samtykker.feature) |
|  | Integrasjon mot folkeregisteret for å oppdatere personopplysninger for læresteder |  |  | @skip @personopplysning | [06 folkeregisterintegrasjon.feature](05%20Opplysninger%20om%20person/06%20folkeregisterintegrasjon.feature) |

## 07 Tilgangstyring

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Søker logger inn i brukerflaten med egenopprettet bruker |  |  |  | [egenopprettet_bruker_pålogging.feature](07%20Tilgangstyring/egenopprettet_bruker_pålogging.feature) |
|  | Feide |  |  | @opptakspilot @focus @ci @opplysning | [feide_pålogging.feature](07%20Tilgangstyring/feide_pålogging.feature) |
|  | ID-porten |  |  | @opptakspilot | [idporten_pålogging.feature](07%20Tilgangstyring/idporten_pålogging.feature) |
|  | Opprettelse av personbruker |  |  | @skip @personopplysninger | [Opprette bruker.feature](07%20Tilgangstyring/Opprette%20bruker.feature) |
|  | Organisasjonsinstansvalg for brukere med flere tilganger |  |  | @tilgangsstyring @organisasjonsinstansvalg | [organisasjonsinstansvalg_for_brukere_med_flere_tilganger.feature](07%20Tilgangstyring/organisasjonsinstansvalg_for_brukere_med_flere_tilganger.feature) |
|  | Tilgangskontroll |  |  | @skip @støtteprosesser @sikkerhet | [tilgangskontroll.feature](07%20Tilgangstyring/tilgangskontroll.feature) |
|  | Tilgangsstyring ansatt-bruker |  |  | @skip @støtteprosesser @sikkerhet | [tilgangsstyring_ansattbruker.feature](07%20Tilgangstyring/tilgangsstyring_ansattbruker.feature) |
|  | Tilgangsstyring - Oversikt over API-tilganger |  |  | @skip @støtteprosesser @sikkerhet | [tilgangsstyring_api-tilganger_oversikt.feature](07%20Tilgangstyring/tilgangsstyring_api-tilganger_oversikt.feature) |
|  | Tilgangsstyring - Oversikt over API-brukere |  |  | @skip @støtteprosesser @sikkerhet | [tilgangsstyring_maskinbruker_oversikt.feature](07%20Tilgangstyring/tilgangsstyring_maskinbruker_oversikt.feature) |
|  | Tilgangsstyringsprosess |  |  | @skip @støtteprosesser @sikkerhet | [tilgangsstyring_prosess.feature](07%20Tilgangstyring/tilgangsstyring_prosess.feature) |
|  | Tilgangstyring av saksbehandler |  |  |  | [tilgangsstyring_saksbehandler.feature](07%20Tilgangstyring/tilgangsstyring_saksbehandler.feature) |

## 08 Teknisk

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | 08 Teknisk: Gi tilbakemelding |  |  | @skip @støtteprosesser | [gi_tilbakemelding.feature](08%20Teknisk/gi_tilbakemelding.feature) |
|  | 08 Teknisk: API-brukerprofil |  |  | @skip @støtteprosesser @sikkerhet | [maskinbrukerprofil.feature](08%20Teknisk/maskinbrukerprofil.feature) |
|  | 08 Teknisk: Snarveismeny |  |  | @skip @støtteprosesser @kurs @ci | [snarveismeny.feature](08%20Teknisk/snarveismeny.feature) |

## 10 Felleskrav

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | 10 Felleskrav: Språkvalg påvirker søk og resultat | Sprakvalg |  |  | [sprakvalg_sok_resultat.feature](10%20Felleskrav/Sprakvalg/sprakvalg_sok_resultat.feature) |
|  | 10 Felleskrav: Eksport | Tabellvisninger |  |  | [eksport.feature](10%20Felleskrav/Tabellvisninger/eksport.feature) |
|  | 10 Felleskrav: Filter | Tabellvisninger |  | @fsadmin | [filter.feature](10%20Felleskrav/Tabellvisninger/filter.feature) |

## 99 Demo

| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |
|----|---------|------------|-------------|------|-----|
|  | Filtrere og søke i studiekatalogen | 01 Studiekatalog | 01 Søk og filter | @demo @should | [studiekatalog_filtrering.feature](99%20Demo/01%20Studiekatalog/01%20Søk%20og%20filter/studiekatalog_filtrering.feature) |
|  | Feide-innlogging | 02 Innlogging | 01 Feide | @demo | [feide_innlogging.feature](99%20Demo/02%20Innlogging/01%20Feide/feide_innlogging.feature) |
|  | Opprette opptak via API | 03 Opptak | 01 Opptaksdemo | @demo @integration @planned @should | [opptak_demo_api.feature](99%20Demo/03%20Opptak/01%20Opptaksdemo/opptak_demo_api.feature) |
|  | Opprette et opptak | 03 Opptak | 01 Opptaksdemo | @demo @implemented @must | [opptak_demo.feature](99%20Demo/03%20Opptak/01%20Opptaksdemo/opptak_demo.feature) |
|  | GraphQL API integrasjon | 04 API | 01 GraphQL | @demo @integration @implemented @must | [graphql_integrasjon.feature](99%20Demo/04%20API/01%20GraphQL/graphql_integrasjon.feature) |
|  | Personsøk | 05 Personsøk | 01 Personsøk | @demo | [personsok.feature](99%20Demo/05%20Personsøk/01%20Personsøk/personsok.feature) |
|  | Organisasjonssøk | 06 Organisasjonssøk | 01 Organisasjonssøk | @demo | [organisasjonssok.feature](99%20Demo/06%20Organisasjonssøk/01%20Organisasjonssøk/organisasjonssok.feature) |

## Statistikk

- Totalt: 75
- Levert: 4
- Skip: 28
