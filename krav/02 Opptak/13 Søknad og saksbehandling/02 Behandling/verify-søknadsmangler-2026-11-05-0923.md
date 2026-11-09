# Verifisering: søknadsmangler.feature

- **Dato:** 2026-11-05 09:23
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, dd28ba2809, oppdatert), `fs-admin` (main, 551e8e6dd, oppdatert), `min-kompetanse` (main, 8f200fd2, oppdatert)
- **Åpne MR-er:** ingen funnet
- **Omfang:** `@in-progress` (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei (chrome-devtools-MCP er ikke installert)

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `SDL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MC` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard`
- `MK` = `fs-admin/src/domains/regelverk/features/Mangelkoder`
- `SB` = `fs-admin/src/domains/soknadsbehandling/features`
- `MKO` = `min-kompetanse/src`

## Oppsummering

- Scenarioer: 20 funnet, 19 ikke funnet, 0 usikker, av 39
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 0 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 9 stemmer, 7 avviker, 0 ikke funnet, 1 usikker, av 17
- Regler i koden uten scenario: 26
- Åpne spørsmål: 2 regler og 0 scenarioer i gating-settet, 9 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 7 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

*Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-008` — Søknadsmangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature`, 20/39 funnet): `@implemented` på Scenario: Registrering av mangel publiserer ikke mangelen (linje 232), Scenario: Saksbehandleren publiserer mangelen (linje 237), Scenario: Søkeren får én melding om manglene som publiseres i saken (linje 308), Scenario: Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler (linje 313), Scenario: Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket (linje 381), Scenario: Søkeren ser kommentaren fra saksbehandleren (linje 395), Scenario: Mangel som er sjekket ut vises ikke for søkeren (linje 415)

**Blir stående**

- `@OPT-BEH-BEH-008` — Søknadsmangler (`@in-progress`, 20/39 funnet): 19 ikke funnet — fristen for en mangel regnes ikke ut (5), søkeren ser ikke kravene i kompetanseregelverket, ingen advarsel eller publisering når saken settes til «Behandlet» (3), kvotemangler kan ikke registreres i fs-admin (4), utsjekk og «lest av søker» mangler i fs-admin (2), saksloggen fylles ikke, og manglene på tvers av organisasjoner (3)

## Oppfølging

- **Ikke funnet:** `@OPT-BEH-BEH-008` «Søkeren åpner meldingen om mangel» (`søknadsmangler.feature:318`) — `SVC/kommunikasjon/MangelMeldingService.java:54` lager meldingen med frist `null`, så `MKO/app/[locale]/mine-meldinger/[meldingId]/_components/mangel/mangel-melding-content.tsx:94-96` viser aldri en frist. Teksten og lenken til dokumentasjonssiden finnes
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Fristen for en mangel publisert <publisert> når <situasjon>» (`:327`), «Meldingen viser fristen for hvert søknadsalternativ med mangler» (`:346`), «Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket» (`:355`), «Mangel på <kategori> har ettersendingsfristen» (`:363`) — ingen utregning av fristen i fs-plattform, og `SDL/kommunikasjon/kommunikasjon.graphqls:106-109` har én frist per melding, ikke per søknadsalternativ
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Søkeren ser kravene i kompetanseregelverket mangelen gjelder» (`:389`) — `MKO/components/application-requirements/application-regelverk.tsx:49` viser bare mangelkortet når søknadsalternativet har mangler, så kravelementene i regelverket skjules
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Saksbehandleren blir advart om mangler som ikke er publisert» (`:291`), «Publisere manglene når saken settes til ferdig behandlet» (`:296`), «Avbryte når saken har mangler som ikke er publisert» (`:303`) — `SB/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42-44` og statusvalget i `SB/PersonaliaCard/PersonaliaCard.tsx:130-134` setter «Behandlet» uten advarsel, og `SVC/saksbehandling/EndreStatusService.java:31-34` publiserer ikke. `publiserMangler` finnes i API-et, men fs-admin bruker den ikke
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Registrere mangel på kvote» (`:131`), «Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken» (`:135`), «En mangel i kategorien <kategori> <kobling>» (`:141`), «Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken» (`:163`) — API-et har `kvotesporsmalId` (`SDL/saksbehandling/mangel.graphqls:58`), men fs-admin sender det ikke (`MC/ManglerCard.tsx:72-78`). Spesielle krav kan også registreres uten kompetanseregelverk (`MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:82`)
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Saksloggen viser at saksbehandleren <hendelse>» (`:181`) — `MIG/V480__stopp_endringslogg.sql:13-28` stoppet endringsloggen i saksbehandling
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Saksbehandleren sjekker ut mangelen» (`:205`), «Saksbehandleren ser om søkeren har lest mangelen» (`:211`) — API-et har `erUtsjekket` og `erLestAvSoker` (`SDL/saksbehandling/mangel.graphqls:79,160`), men fs-admin har ingen handling eller visning (`MC/queries.ts:25-52`)
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon» (`:442`) — manglene kan leses på tvers (`MIG/V291__saksbehandling_skjema.sql:1715-1718`), men fs-admin viser bare saken som er åpen (`MC/queries.ts:3-22`)
- **Ikke funnet:** `@OPT-BEH-BEH-008` «Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon» (`:448`), «Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet» (`:459`) — databasen stopper skrivingen (`MIG/V291__saksbehandling_skjema.sql:1720-1738`), men fs-admin viser «Legg til», «Slett», kommentaren og «Oppdater Min kompetanse» (`MC/ManglerCard.tsx:139-208`, `MC/Mangel/Mangel.tsx:143-156`)
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler registrerer mangel med mangelkode fra en annen regelverkssamling — kravet sier at bare mangelkodene i regelverkssamlingen til opptaket kan velges, koden sjekker det bare i fs-admin, `SVC/saksbehandling/SakMangelService.java:65-96`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler knytter mangel til kompetanseregelverk eller kvotespørsmål utenfor saken — backend krever bare samme regelverkssamling, `SVC/saksbehandling/SakMangelService.java:424-446,450-460`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` opptaksforvalter ved en annen organisasjon ser «Endre» og «Deaktiver» på mangelkoden — `MK/MangelkodeDetails/MangelkodeDetails.tsx:279` sjekker ikke organisasjon. Backend avviser
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler uten skrivetilgang til saken ser handlingene på manglene — `MC/ManglerCard.tsx:137-209`, `MC/Mangel/Mangel.tsx:143-218`. Backend avviser
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler ved en annen organisasjon leser manglene — kravet sier at manglene i alle sakene på søknaden vises, fs-admin viser bare saken som er åpen, `MC/queries.ts:3-22`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler ved en annen organisasjon eller tilbyder legger til, endrer eller sletter — kravet sier at muligheten ikke vises, fs-admin viser den, `MC/ManglerCard.tsx:139-208`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler setter saken til «Behandlet» — kravet sier at det ikke går uten at manglene publiseres, koden setter statusen uten sjekk, `SVC/saksbehandling/EndreStatusService.java:31-34`
- **Tilgang usikker:** `@OPT-BEH-BEH-008` opptaksforvalter oppretter og endrer mangelkode — kravet sier organisasjonen som forvalter opptaket, RLS krever `MODIFISERE_REGELVERK` for organisasjonen som eier regelverkssamlingen (`MIG/V264__soknadsmangel_kodeverk.sql:61-95`). Et opptak kan bruke en regelverkssamling en annen organisasjon eier. Kontrollen: kravet bør si hvem som eier mangelkodene
- **Kravet er bak koden:** `@OPT-BEH-BEH-008` kategorien heter «Kvoter» i koden, kravet sier «Kvote», `MIG/V264__soknadsmangel_kodeverk.sql:40`
- **Kravet er bak koden:** `@OPT-BEH-BEH-008` mangelmeldingen er generell, og nevner ikke mangelkoden («Det mangler noe i søknaden din»), `SVC/kommunikasjon/MangelMeldingService.java:17-19`
- **Kontrollen endret:** `@OPT-BEH-BEH-008` tilgangsraden «opptaksforvalter oppretter og endrer mangelkode» — stemmer → usikker: tilgangen følger eieren av regelverkssamlingen, ikke forvalteren av opptaket
- **Kontrollen endret:** `@OPT-BEH-BEH-008` to regler uten scenario fjernet (Spesielle krav uten kompetanseregelverk, og «Kvoter»): de dekkes av scenarioer koden avviker fra. Sju regler og to tilgangsrader lagt til
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Søkeren laster opp dokumentasjon for manglene» (`:421`, `@draft`) — knyttes dokumentasjonen til en bestemt mangel, og hva skjer etter fristen?
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Saksbehandleren finner sakene med en bestemt mangelkode» (`:467`, `@draft`) — skal utsjekkede tas med, og kan flere mangelkoder velges?
- **Ikke sjekket:** skjermbilder, fordi chrome-devtools-MCP ikke er installert
- **Delvis levert, men ikke i en spesifikasjon:** `@OPT-BEH-BEH-008` — hent det inn med `fs-specify`
- **Kan ikke testes fra start til slutt:** `@OPT-BEH-BEH-008` «Mangel som er sjekket ut vises ikke for søkeren» — koden som skjuler mangelen finnes, men utsjekking er ikke laget i fs-admin (STEK-567)
- **I arbeid:** `@OPT-BEH-BEH-008` advarselen og publiseringen ved «Behandlet» — branchen `mahj/behandlet-statuskode` i fs-plattform og fs-admin (STEK-253)

## Kravet er endret etter kjøringen

Endret 2026-11-06 i samme PR, før akseptansetesten. Endringene er ikke verifisert.

- «Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket» er slettet. Den dekkes av de andre frist-scenarioene.
- «Meldingen viser fristen for hvert søknadsalternativ med mangler» heter nå «Meldingen viser ettersendingsfristen og de tidligere fristene som gjelder manglene», og skiller ettersendingsfristen fra den tidlige dokumentasjonsfristen.
- Alle mangler vises under søknadsalternativene (Ingrid Grimstad Helset, 2026-11-05): ny scenariomal «Mangel på <kategori> vises under alle søknadsalternativene i saken» (Generelle krav, Poeng) og nytt scenario «Mangel på kvote vises under søknadsalternativene med kvoten». Scenariomalen «Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ» (`@draft`) er slettet. Dette er en endring i koden: i dag gjelder mangler uten kompetanseregelverk hele søknaden (`MIG/V457__soknadsmangel_bare_publiserte.sql:51-93`).

## Jira-sakene for det som ikke er levert

| Scenario | Jira |
| --- | --- |
| Søkeren åpner meldingen om mangel | [TOT-2223](https://sikt.atlassian.net/browse/TOT-2223) Avklare hvordan vi skal håndheve frister relatert til studiekurv/søknadakladder |
| Fristen for en mangel publisert <publisert> når <situasjon> | [TOT-2223](https://sikt.atlassian.net/browse/TOT-2223) |
| Meldingen viser ettersendingsfristen og de tidligere fristene som gjelder manglene | [TOT-2223](https://sikt.atlassian.net/browse/TOT-2223) |
| Mangel på <kategori> har ettersendingsfristen | [TOT-2223](https://sikt.atlassian.net/browse/TOT-2223) |
| Søkeren ser kravene i kompetanseregelverket mangelen gjelder | [TOT-2469](https://sikt.atlassian.net/browse/TOT-2469) Finne ut av hvordan vi skal presentere krav og mangler per studiealternativ |
| Mangel på <kategori> vises under alle søknadsalternativene i saken | ---- Task ikke Funnet ----- |
| Mangel på kvote vises under søknadsalternativene med kvoten | ---- Task ikke Funnet ----- |
| Saksbehandleren blir advart om mangler som ikke er publisert | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) (Automatisk) setting av behandlingsstatus (behandlet) |
| Publisere manglene når saken settes til ferdig behandlet | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) |
| Avbryte når saken har mangler som ikke er publisert | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) |
| Registrere mangel på kvote | ---- Task ikke Funnet ----- |
| Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken | ---- Task ikke Funnet ----- |
| En mangel i kategorien <kategori> <kobling> | ---- Task ikke Funnet ----- |
| Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | ---- Task ikke Funnet ----- |
| Saksbehandleren sjekker ut mangelen | [STEK-567](https://sikt.atlassian.net/browse/STEK-567) Flagg bare mangler som fantes da søkeren fikk dem presentert |
| Saksbehandleren ser om søkeren har lest mangelen | [STEK-421](https://sikt.atlassian.net/browse/STEK-421) Håndtere ny hendelse «Søker har lest mangler» |
| Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ---- Task ikke Funnet ----- |
| Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | [STEK-672](https://sikt.atlassian.net/browse/STEK-672) Lesemodus i saken: skjul det brukeren ikke har lov til å gjøre |
| Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | [STEK-672](https://sikt.atlassian.net/browse/STEK-672) |
| Saksloggen viser at saksbehandleren <hendelse> | ---- Task ikke Funnet ----- (BAT) |

## Endringer

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Scenario: Registrering av mangel publiserer ikke mangelen | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Saksbehandleren publiserer mangelen | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Søkeren får én melding om manglene som publiseres i saken | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Søkeren ser kommentaren fra saksbehandleren | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-008` | Scenario: Mangel som er sjekket ut vises ikke for søkeren | `@implemented` på delen | ja i kjøringen |

## Avhengigheter

Avhengighetene får aldri ny status i denne kjøringen.

`@OPT-BEH-BEH-008` har ingen `@depends-on-`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Opprette mangelkode | funnet | `SVC/regelverk/MangeltypeService.java:44-64`, `MK/MangelkodeDetails/MangelkodeDetails.tsx:210-222` |
| `@OPT-BEH-BEH-008` | Tilgjengelige kategorier for mangelkoder | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:37-40`, `MK/MangelkodeDetails/MangelkodeDetails.tsx:139-143` |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:61-95` |
| `@OPT-BEH-BEH-008` | Søkeren er kvalifisert selv om saken har en mangel i kategorien <kategori> | funnet | ingen kode under `SVC/regelverk/kvalifisering/` leser `sak_mangel` |
| `@OPT-BEH-BEH-008` | Saken kan behandles ferdig selv om den har mangler | funnet | `SVC/saksbehandling/EndreStatusService.java:22-41` |
| `@OPT-BEH-BEH-008` | Registrere mangel på spesielle krav | funnet | `SVC/saksbehandling/SakMangelService.java:65-119`, `MC/ManglerCard.tsx:72-81` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket | funnet | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:13-30,62` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken | funnet | `MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:20-41,73-87` |
| `@OPT-BEH-BEH-008` | Registrere mangel på kvote | ikke funnet | API-et har `kvotesporsmalId` (`SDL/saksbehandling/mangel.graphqls:58`, `SVC/saksbehandling/SakMangelService.java:433-446`), men `MC/ManglerCard.tsx:72-78` sender det ikke — søkt etter «kvotesporsmal» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken | ikke funnet | ingen velger for kvotespørsmål i `MC/` — søkt som over |
| `@OPT-BEH-BEH-008` | En mangel i kategorien <kategori> <kobling> | ikke funnet | Generelle krav og Poeng avvises med kobling (`SVC/saksbehandling/SakMangelService.java:419-422,434-437`). Spesielle krav kan registreres uten kompetanseregelverk (`MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:82`). Kvote finnes ikke i fs-admin |
| `@OPT-BEH-BEH-008` | Kommentaren til søkeren er valgfri | funnet | `SDL/saksbehandling/mangel.graphqls:60`, `MC/ManglerCard.tsx:72-78` |
| `@OPT-BEH-BEH-008` | En sak kan ha flere mangler | funnet | `MIG/V291__saksbehandling_skjema.sql:514`, `MC/ManglerCard.tsx:48-64,175-191` |
| `@OPT-BEH-BEH-008` | Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | ikke funnet | `MIG/V291__saksbehandling_skjema.sql:548-551` og `SVC/saksbehandling/SakMangelService.java:494-518` dekker Generelle krav, Spesielle krav og Poeng. Kvote-raden kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Slette mangel som er registrert ved en feil | funnet | `SVC/saksbehandling/SakMangelService.java:351-367`, `MC/Mangel/Mangel.tsx:94-111,143-195` |
| `@OPT-BEH-BEH-008` | Saksloggen viser at saksbehandleren <hendelse> | ikke funnet | `MIG/V480__stopp_endringslogg.sql:13-28` fjernet audit-triggerne i saksbehandling — søkt etter «sakslogg», «sakshistorikk», «sak_hendelse», «audit» i migrasjonene etter V480 og i `fs-plattform/opptak` |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | funnet | `SB/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:176-181` |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen | ikke funnet | API-et har `erUtsjekket` (`SDL/saksbehandling/mangel.graphqls:79`, `SVC/saksbehandling/SakMangelService.java:217-219`), men fs-admin har ingen handling for å sjekke ut — søkt etter «erUtsjekket», «utsjekk», «sjekkUt» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser om søkeren har lest mangelen | ikke funnet | API-et har `erLestAvSoker` (`SDL/saksbehandling/mangel.graphqls:160`), men `MC/queries.ts:25-52` henter det ikke — søkt etter «erLestAvSoker», «lestAvSoker» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Registrering av mangel publiserer ikke mangelen | funnet | P · A — `SVC/saksbehandling/SakMangelService.java:109,116-118`, `MC/ManglerCard.tsx:72-79`, `MIG/V457__soknadsmangel_bare_publiserte.sql:81,131` |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer mangelen | funnet | P · A · M — `MC/ManglerCard.tsx:96-100,194-208`, `SVC/saksbehandling/SakMangelService.java:214-216`, `MKO/components/soknadsmangel/soknad-mangler-panel.tsx:25-34`, `MKO/components/application-requirements/application-requirements.tsx:50-69` |
| `@OPT-BEH-BEH-008` | Saksbehandleren blir advart om mangler som ikke er publisert | ikke funnet | `SB/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42-44` og `SB/PersonaliaCard/PersonaliaCard.tsx:130-134` setter «Behandlet» uten advarsel — søkt etter «ikkePublisert», «upubliser», «ikke publisert», «kanPubliseres» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Publisere manglene når saken settes til ferdig behandlet | ikke funnet | `SVC/saksbehandling/EndreStatusService.java:31-34` publiserer ikke. `publiserMangler` (`SVC/saksbehandling/SakMangelService.java:283-331`) brukes ikke av fs-admin — søkt etter «publiserMangler» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Avbryte når saken har mangler som ikke er publisert | ikke funnet | ingen advarsel å avbryte i `MerkSomBehandletButton.tsx` eller `PersonaliaCard.tsx` — søkt som over |
| `@OPT-BEH-BEH-008` | Søkeren får én melding om manglene som publiseres i saken | funnet | P · A · M — `SVC/saksbehandling/SakMangelService.java:127,139-141,147-164`, `MC/ManglerCard.tsx:100`, `MKO/app/[locale]/mine-meldinger/[meldingId]/_components/melding-type-content.tsx:23-24` |
| `@OPT-BEH-BEH-008` | Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler | funnet | P · M — `SVC/saksbehandling/SakMangelService.java:166-168`, `SVC/kommunikasjon/MangelMeldingService.java:31-54` |
| `@OPT-BEH-BEH-008` | Søkeren åpner meldingen om mangel | ikke funnet | `SVC/kommunikasjon/MangelMeldingService.java:54` sender frist `null`, så `MKO/app/[locale]/mine-meldinger/[meldingId]/_components/mangel/mangel-melding-content.tsx:94-96` viser aldri fristen. Teksten og lenken finnes (`:89-109`) — søkt etter «fristForOpplasting», «frist_for_opplasting», «MangelInnhold(» i fs-plattform |
| `@OPT-BEH-BEH-008` | Fristen for en mangel publisert <publisert> når <situasjon> | ikke funnet | ingen utregning av ettersendingsfristen eller den tidlige dokumentasjonsfristen; fristen er `null` (`SVC/kommunikasjon/MangelMeldingService.java:54`) — søkt etter «frist» i `SVC/saksbehandling/*Mangel*` og `SVC/kommunikasjon/` |
| `@OPT-BEH-BEH-008` | Meldingen viser fristen for hvert søknadsalternativ med mangler | ikke funnet | `SDL/kommunikasjon/kommunikasjon.graphqls:106-109` har én frist per melding, og `MKO/.../mangel/mangel-frist.tsx:13-31` viser én frist |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket | ikke funnet | én frist per melding, og den er `null` — søkt som over |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> har ettersendingsfristen | ikke funnet | fristen er `null` (`SVC/kommunikasjon/MangelMeldingService.java:54`) — søkt som over |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | funnet | P · M — `MIG/V457__soknadsmangel_bare_publiserte.sql:32-50,97-131`, `MKO/app/[locale]/soknader/[soknadId]/documentation/_utils/get-soknad-kompetanseregelverk.ts:19-25`, `MKO/components/application-requirements/application-requirements.tsx:50-63` |
| `@OPT-BEH-BEH-008` | Søkeren ser kravene i kompetanseregelverket mangelen gjelder | ikke funnet | `MKO/components/application-requirements/application-regelverk.tsx:49` viser bare mangelkortet når søknadsalternativet har mangler, og kravene i regelverket (`:21-35`) skjules. Informasjonen til søker for mangelkoden vises (`MKO/components/soknadsmangel/mangel-list.tsx:26`) — søkt etter «Kompetanseregelverk_Fragment», «ApplicationRegelverk» i `min-kompetanse/src` |
| `@OPT-BEH-BEH-008` | Søkeren ser kommentaren fra saksbehandleren | funnet | P · M — `MIG/V457__soknadsmangel_bare_publiserte.sql:65,111`, `MKO/components/soknadsmangel/mangel-list.tsx:27-32` |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut vises ikke for søkeren | funnet | P · M — `MIG/V457__soknadsmangel_bare_publiserte.sql:79-80,130` |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ikke funnet | manglene kan leses på tvers (`MIG/V291__saksbehandling_skjema.sql:1715-1718`), men fs-admin henter bare manglene i saken som er åpen (`MC/queries.ts:3-22`) — søkt etter «mangler {», «SakMangel», «soknadsmangler» i `fs-admin/src` |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | ikke funnet | databasen stopper skrivingen (`MIG/V291__saksbehandling_skjema.sql:1720-1738`), men fs-admin viser handlingene (`MC/ManglerCard.tsx:139-208`, `MC/Mangel/Mangel.tsx:143-156`) — søkt etter «kanEndre», «useKanSaksbehandle», «readOnly» i `SB/SakDrawer/` |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene | funnet | `MIG/V501__tilbyderoppslag_per_sak.sql:41-42`, `MIG/V291__saksbehandling_skjema.sql:1715-1718`, `MC/ManglerCard.tsx:38-46` |
| `@OPT-BEH-BEH-008` | Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | ikke funnet | lesingen finnes (`MIG/V501__tilbyderoppslag_per_sak.sql:43-52`), men fs-admin skjuler ikke «Legg til», «Slett» og kommentaren (`MC/ManglerCard.tsx:139-208`, `MC/Mangel/Mangel.tsx:137-216`) |

## Tilgang og datakonsistens

Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter oppretter og endrer mangelkode | usikker | kravet sier organisasjonen som forvalter opptaket (Scenariomal: Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak>), koden krever `MODIFISERE_REGELVERK` for organisasjonen som eier regelverkssamlingen — `MIG/V264__soknadsmangel_kodeverk.sql:61-95` |
| `@OPT-BEH-BEH-008` | tilgang | alle leser mangelkoder | stemmer | `MIG/V264__soknadsmangel_kodeverk.sql:56-59` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler oppretter, endrer, sjekker ut og sletter mangel i saken sin | stemmer | `MIG/V291__saksbehandling_skjema.sql:1720-1738` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler leser mangler | stemmer | `MIG/V291__saksbehandling_skjema.sql:1715-1718` |
| `@OPT-BEH-BEH-008` | konsistens | saksbehandler registrerer mangel med mangelkode fra en annen regelverkssamling | avviker | kravet sier at bare mangelkodene i regelverkssamlingen til opptaket kan velges, koden sjekker det bare i fs-admin, og backend godtar også inaktive koder — `SVC/saksbehandling/SakMangelService.java:65-96` |
| `@OPT-BEH-BEH-008` | konsistens | saksbehandler knytter mangel til kompetanseregelverk eller kvotespørsmål utenfor saken | avviker | kravet sier regelverkene og kvotespørsmålene til søknadsalternativene i saken, backend krever bare samme regelverkssamling — `SVC/saksbehandling/SakMangelService.java:424-446,450-460` |
| `@OPT-BEH-BEH-008` | konsistens | opptaksforvalter deaktiverer mangelkode | stemmer | `MK/MangelkodeDetails/MangelkodeDetails.tsx:241-261`, `MIG/V291__saksbehandling_skjema.sql:518-519` |
| `@OPT-BEH-BEH-008` | organisasjon | opptaksforvalter ved en annen organisasjon endrer og deaktiverer mangelkode | avviker | ikke beskrevet, koden viser knappene uten sjekk av organisasjon, og backend avviser — `MK/MangelkodeDetails/MangelkodeDetails.tsx:279`, `SVC/regelverk/MangeltypeService.java:100-105` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler uten skrivetilgang til saken registrerer, sletter, kommenterer og publiserer | avviker | ikke beskrevet, koden viser handlingene for alle som åpner saken, og backend avviser — `MC/ManglerCard.tsx:137-209`, `MC/Mangel/Mangel.tsx:143-218` |
| `@OPT-BEH-BEH-008` | tilgang | søker leser manglene | stemmer | `MIG/V457__soknadsmangel_bare_publiserte.sql:15,80-81,130-131` |
| `@OPT-BEH-BEH-008` | tilgang | søker markerer manglene som sett | stemmer | `SVC/soknad/mangel/SettManglerPresentertForSokerService.java:32-39`, `MKO/app/[locale]/mine-meldinger/[meldingId]/_components/mangel/mangel-melding-content.tsx:60-85` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler publiserer manglene | stemmer | `SVC/saksbehandling/SakMangelService.java:340-349`, `MIG/V291__saksbehandling_skjema.sql:1725-1733` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler ved annen organisasjon leser manglene | avviker | kravet sier at manglene i alle sakene på søknaden vises, fs-admin viser bare saken som er åpen — `MC/queries.ts:3-22` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler ved annen organisasjon eller tilbyder legger til, endrer eller sletter | avviker | kravet sier at muligheten ikke vises, fs-admin viser den, og databasen avviser — `MC/ManglerCard.tsx:139-208`, `MIG/V291__saksbehandling_skjema.sql:1720-1738` |
| `@OPT-BEH-BEH-008` | organisasjon | opptaksforvalter leser manglene | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:41-42` |
| `@OPT-BEH-BEH-008` | konsistens | saksbehandler setter saken til «Behandlet» | avviker | kravet sier at saken ikke kan settes til «Behandlet» uten at manglene publiseres, koden setter statusen uten sjekk — `SVC/saksbehandling/EndreStatusService.java:31-34`, `SB/PersonaliaCard/PersonaliaCard.tsx:130-134` |
| `@OPT-BEH-BEH-008` | konsistens | behandler av saken skifter | stemmer | `MIG/V457__soknadsmangel_bare_publiserte.sql:82-93` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Bare aktive mangelkoder kan velges i saken (backend godtar også inaktive) | validering | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:30`, `SVC/saksbehandling/SakMangelService.java:65-96` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Høyst 200 mangelkoder i nedtrekkslisten | grense | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:30` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kommentaren kan ha høyst 4000 tegn og saneres som Markdown | validering | `SDL/saksbehandling/mangel.graphqls:60,75`, `SVC/saksbehandling/SakMangelService.java:53-55` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Navnet på mangelkoden kan ha høyst 100 tegn, og koden er unik i regelverkssamlingen | validering | `SDL/saksbehandling/mangel.graphqls:107,244-251` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kode er påkrevd og kan ikke endres etter opprettelse | obligatorisk felt | `MK/MangelkodeDetails/MangelkodeDetails.tsx:165-170,305-312` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kategori og kort beskrivelse er obligatoriske, og navnet trimmes | obligatorisk felt | `MK/MangelkodeDetails/MangelkodeDetails.tsx:171-172,202,215` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | «Stopper for opptak» er Nei som standard | standardverdi | `SVC/regelverk/MangeltypeService.java:51`, `MK/MangelkodeDetails/MangelkodeDetails.tsx:76` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | En deaktivert mangelkode kan ikke aktiveres igjen i fs-admin (backend kan) | tilstandsovergang | `MK/MangelkodeDetails/MangelkodeDetails.tsx:197-207,284`, `SVC/regelverk/MangeltypeService.java:89-91` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Teksten til søker på mangelkoden saneres som Markdown | validering | `SVC/regelverk/MangeltypeService.java:34,70` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Endring av en mangelkode en annen organisasjon eier, gir «Fant ingen mangeltype med oppgitt id» | tilgangssjekk | `SVC/regelverk/MangeltypeService.java:100-105` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Bare én mangelkode per regelverkssamling kan merkes for GSK som fullføres i vår, i Generelle krav og stopper for opptak | validering | `SVC/regelverk/MangeltypeService.java:119-141` | uklart om ønsket (kan høre til `@OPT-BEH-BEH-036`) |
| `@OPT-BEH-BEH-008` | Å registrere, endre, slette eller publisere en mangel flytter saken fra «Ubehandlet» til «Under behandling» | tilstandsovergang | `SVC/saksbehandling/SakMangelService.java:115,275,327,365,392-398` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Automatisk registrerte mangler har ingen slett-knapp | annet | `MC/Mangel/Mangel.tsx:143` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Ny tekst eller kobling, eller å angre utsjekk, nullstiller «lest av søker», uten ny melding | tilstandsovergang | `SVC/saksbehandling/SakMangelService.java:209-219,262-268` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | «Lest av søker» settes per søknad, bare når saken er «Under behandling» eller «Behandlet», og bare for publiserte mangler som ikke er sjekket ut | annet | `SVC/saksbehandling/ManglerPresentertService.java:38-69` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | En mangel kan knyttes til høyst ett kompetanseregelverk eller ett kvotespørsmål | validering | `MIG/V291__saksbehandling_skjema.sql:524-525` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Søkeren ser manglene bare når saken er aktiv og «Under behandling» eller «Behandlet», ikke «Ubehandlet» | tilstandsovergang | `MIG/V457__soknadsmangel_bare_publiserte.sql:12-14` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Manglene fra en organisasjon som ikke lenger behandler noe søknadsalternativ, vises ikke for søkeren | annet | `MIG/V457__soknadsmangel_bare_publiserte.sql:82-93` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Den automatiske mangelteksten vises bare når søkeren ikke kvalifiserer på noe grunnlag i regelverket, én gang per regelverk og søknadsalternativ | annet | `MIG/V457__soknadsmangel_bare_publiserte.sql:135-183` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Publiseres bare mangler som er sjekket ut eller alt publisert, får søkeren ingen melding | annet | `SVC/saksbehandling/SakMangelService.java:145-164,287-294` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Mangelmeldingen har fast tittel og innhold («Det mangler noe i søknaden din»), og Min kompetanse har en egen tittel («Du mangler dokumentasjon i søknaden») | standardverdi | `SVC/kommunikasjon/MangelMeldingService.java:17-19`, `min-kompetanse/messages/files/nb.json` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Et søknadsalternativ med mangler er åpent som standard på dokumentasjonssiden, og merket «Mangler dokumentasjon» | standardverdi | `MKO/components/application-requirements/application-requirements.tsx:51-63`, `MKO/components/soknadsmangel/use-mangel-tags.ts:12-21` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Manglene vises også på søknadssiden og i dokumentasjonssteget i søknadskladden (ikke lest i detalj av kontrollen) | annet | `MKO/app/[locale]/soknader/[soknadId]/_components/soknad-details/soknadsalternativ.tsx:113-166`, `MKO/components/soknad-dokumentasjon/checklist/soknad-mangler.tsx:15-19` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Manglene for hele søknaden vises i et eget panel, «Manglende dokumentasjon for søknaden», over søknadsalternativene | annet | `MKO/components/soknadsmangel/soknad-mangler-panel.tsx:20-36` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | En mangel uten standardtekst og uten kommentar på språket til brukeren vises ikke | annet | `MKO/components/soknadsmangel/use-mangel-tekster.ts:27-30`, `SDL/soknad/soknadsmangel.graphqls:32-36` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Mangler søkeren ikke har sett, markeres som sett når mangelmeldingen åpnes, ikke når dokumentasjonssiden åpnes | tilstandsovergang | `MKO/app/[locale]/mine-meldinger/[meldingId]/_components/mangel/mangel-melding-content.tsx:60-85` | testes i fase 2 |

## Åpne spørsmål

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Søknadsmangler | 2 av 10 | 0 av 39 | 9 |
