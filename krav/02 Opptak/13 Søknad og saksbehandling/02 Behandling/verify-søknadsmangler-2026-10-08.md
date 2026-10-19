# Verifisering: søknadsmangler.feature

- **Dato:** 2026-10-08
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature`
- **Kode:** `fs-plattform` (`568a3fb`), `fs-admin` (`6d80804`), `min-kompetanse` (`e24e3d7`), lest fra `origin/main`

Verifisert uansett status: kravet står som `@planned`. Ingen skjermbilder. Brukerens vurdering: «Kunne ikke verifisere».

Forkortelser i bevisene: `MS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SakMangelService.java`, `MT` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/MangeltypeService.java`, `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`, `MC` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard`, `MK` = `fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkodeDetails/MangelkodeDetails.tsx`.

## Oppsummering

- Retagget til `@implemented`: 0
- Deler i leverte krav som er levert (`@in-progress` fjernet): 0
- Ikke levert (står som `@planned`): 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

Gating-settet er 31 scenarioer: 9 funnet, 13 usikre, 9 ikke funnet.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Opprette mangelkode | funnet | `MT:30` oppretter mangeltype med kode, kategori, navn, aktiv, sperrerOpptak og tekst; `MK:200` sender feltene |
| `@OPT-BEH-BEH-008` | Tilgjengelige kategorier for mangelkoder | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:37` har de fire kategoriene; `MK:132` henter dem |
| `@OPT-BEH-BEH-008` | Stopper for opptak kan <tillatt> settes på en mangelkode i kategorien <kategori> | ikke funnet | `MT:48` og `MT:87` setter sperrerOpptak uansett kategori; `MK:377` viser bryteren alltid |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | usikker | RLS på MODIFISERE_REGELVERK for eier av samlingen (`MIG/V264__soknadsmangel_kodeverk.sql:61`); koblingen mellom opptakets forvalter og samlingens eier er ikke lest; `MK:265` har `canModify` hardkodet |
| `@OPT-BEH-BEH-008` | Mangel på generelle krav hindrer kvalifisering til alle søknadsalternativene i saken | ikke funnet | Søkt etter SAK_MANGEL og mangel i kvalifiseringen; ingen kode leser mangler der |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav hindrer kvalifisering bare til søknadsalternativene med kompetanseregelverket | ikke funnet | Kompetanseregelverket lagres (`MS:120`), men brukes ikke i kvalifiseringen |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> hindrer ikke kvalifisering | usikker | Oppfylt bare fordi ingen mangel hindrer kvalifisering; ingen regel per kategori |
| `@OPT-BEH-BEH-008` | Saken kan behandles ferdig selv om den har mangler | usikker | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/EndreStatusService.java:29` setter status uten sjekk av mangler; fs-admin kaller ikke `endreSaksbehandlingsstatusV3` |
| `@OPT-BEH-BEH-008` | Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen | ikke funnet | `sperrer_opptak` leses ikke i plasstildeling eller tilbudskjøring |
| `@OPT-BEH-BEH-008` | Registrere mangel på spesielle krav | usikker | Backend tar imot kompetanseregelverk og tekst (`MS:41`); `MC/ManglerCard.tsx:70` sender bare sak og mangeltype |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken | ikke funnet | `MS:426` sjekker bare samme regelverkssamling; ingen valg i fs-admin |
| `@OPT-BEH-BEH-008` | Registrere mangel på kvote | usikker | Backend lagrer kvotespørsmål (`MS:434`); ingen valg i fs-admin (`MC/ManglerCard.tsx:70`) |
| `@OPT-BEH-BEH-008` | En mangel i kategorien <kategori> <kobling> | usikker | Backend avviser ugyldig kobling (`MS:421`, `MIG/V264__soknadsmangel_kodeverk.sql:13`); ingen kobling i fs-admin |
| `@OPT-BEH-BEH-008` | Kommentaren til søkeren er valgfri | funnet | `MS:122` lagrer tekst som kan være null; `MC/ManglerCard.tsx:70` registrerer uten kommentar |
| `@OPT-BEH-BEH-008` | En sak kan ha flere mangler | funnet | `MS:113` lager én rad per mangel; `MC/ManglerCard.tsx:46` viser flere |
| `@OPT-BEH-BEH-008` | Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | usikker | «ikke»-radene: unik indeks og `MS:496` avviser duplikat; «også»-radene kan ikke gjøres i fs-admin, siden regelverk og kvotespørsmål ikke kan velges |
| `@OPT-BEH-BEH-008` | Slette mangel som er registrert ved en feil | funnet | `MS:315` sletter og logger; `MC/Mangel/Mangel.tsx:87` har sletting med bekreftelse |
| `@OPT-BEH-BEH-008` | Saksloggen viser at saksbehandleren <hendelse> | funnet | `MS:104`, `MS:189`, `MS:351`, `MS:324` logger alle fire; «utsjekket = true» godtatt av brukeren; test `SakMangelEndringsloggIT.java:169` |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | usikker | `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:148` viser «Ny dokumentasjon», men merket er ikke koblet til mangler |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen | usikker | `MS:204` setter `erUtsjekket`; fs-admin har ingen handling for å sjekke ut |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut hindrer ikke kvalifisering | usikker | Oppfylt bare fordi ingen mangel hindrer kvalifisering |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser om søkeren har sett mangelen | ikke funnet | Backend setter `STATUS_LEST_AV_SOKER` (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/ManglerPresentertService.java:55`); min-kompetanse kaller ikke `manglerPresentertForSoker`, og fs-admin viser ikke `erLestAvSoker` |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | funnet | `MIG/V368__soknadsmangel_view_og_manglende_krav.sql:160`; `min-kompetanse/src/components/application-requirements/application-requirements.tsx:50` |
| `@OPT-BEH-BEH-008` | Søkeren ser kravene i kompetanseregelverket mangelen gjelder | usikker | Teksten til mangelkoden vises (`min-kompetanse/src/components/soknadsmangel/mangel-list.tsx:26`); kravelementene er ikke koblet til en registrert mangel |
| `@OPT-BEH-BEH-008` | Søkeren ser kommentaren fra saksbehandleren | funnet | `min-kompetanse/src/components/soknadsmangel/mangel-list.tsx:27` viser `saksbehandlerTekst` |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> vises øverst på dokumentasjonssiden | usikker | Poeng og Kvote blir mangler på søknaden (`MIG/V368__soknadsmangel_view_og_manglende_krav.sql:141`) og vises i panelet øverst (`min-kompetanse/src/components/soknadsmangel/soknad-mangler-panel.tsx`); ingen test for Poeng |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut vises ikke for søkeren | funnet | `MIG/V368__soknadsmangel_view_og_manglende_krav.sql:143` og `:192`; test `SoknadsmangelRLSIT.java:122` |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ikke funnet | Backend tillater lesing (`MIG/V291__saksbehandling_skjema.sql:1715`); fs-admin viser bare manglene i én sak (`MC/ManglerCard.tsx:36`) |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | usikker | Backend avviser endring (`MIG/V291__saksbehandling_skjema.sql:1725`, test `SakMangelRLSIT.java:146`); fs-admin skjuler ikke handlingene (`MC/Mangel/Mangel.tsx:131`) |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene | ikke funnet | Ingen visning i fs-admin av mangler på tvers av sakene |
| `@OPT-BEH-BEH-008` | Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | ikke funnet | Ingen visning i fs-admin; om tilbyderen får lese viewet, er ikke avklart |

## Retagget til @implemented

| Feature-ID | Egenskap | Fil | Gating funnet |
| --- | --- | --- | --- |

## Deler levert

| Feature-ID | Del | Fil | Gating funnet |
| --- | --- | --- | --- |

## Ikke levert

- **`@OPT-BEH-BEH-008` — Søknadsmangler**: 9 ikke funnet og 13 usikre (se tabellen). Brukeren: «Kunne ikke verifisere».

## Slettet

Ingenting.

## @deprecated som fortsatt finnes i koden

Ingenting.

## Oppfølging

- Ingen step definitions for mangler i `tester/steps/`.
- Krav utenfor scope: tre regler i `søknadsmangler.feature` er `@draft @openquestion` (publisering og melding, frist, automatikk). De går til `fs-krav`.
