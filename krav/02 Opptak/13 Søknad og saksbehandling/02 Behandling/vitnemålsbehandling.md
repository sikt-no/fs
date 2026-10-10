# Vitnemålsbehandling

Initiativ [#607](https://github.com/sikt-no/fs/issues/607). Felles bakgrunn for de seks kravspesifikasjonene som til sammen utgjør vitnemålsbehandleren i FS Admin. Team overkomplisert lager vitnemålsbehandleren. Team Puff eier poengberegningen, og vitnemålsbehandleren kaller endepunktene deres.

Kravet var én fil (`vitnemålsbehandling.feature`, `@OPT-BEH-BEH-004`) fram til 08.10.2026. Da var oppdelingen i leveranser besluttet, og hver leveranse fikk sin egen kravspesifikasjon.

## Leveransene

| Leveranse | Kravspesifikasjon | Feature-ID | Issue | Bygger på | Størrelse | Status |
|---|---|---|---|---|---|---|
| L1 Vise vitnemålene | [vise_elektroniske_vitnemål.feature](vise_elektroniske_vitnemål.feature) | `@OPT-BEH-BEH-005` | #613 | — | liten | `@planned` |
| L2 Velge ett vitnemål for hele saken | [velge_vitnemål_som_grunnlag.feature](velge_vitnemål_som_grunnlag.feature) | `@OPT-BEH-BEH-004` | #608 | L1 | middels | `@draft` |
| L3 Fagvalg per poengvariant | [velge_fag_per_poengvariant.feature](velge_fag_per_poengvariant.feature) | `@OPT-BEH-BEH-007` | #609 | L2 | middels | `@draft` |
| L4 Manuell inntasting og endring av fag | [legge_inn_og_endre_fag.feature](legge_inn_og_endre_fag.feature) | `@OPT-BEH-BEH-008` | #610 | L2, L3 | stor | `@draft` |
| L5 Sammenligning av vitnemål | [sammenligne_vitnemål.feature](sammenligne_vitnemål.feature) | `@OPT-BEH-BEH-009` | #611 | L1 | liten | `@draft` |
| L6 Varsel ved nytt vitnemål fra NVB | [varsle_om_nytt_vitnemål.feature](varsle_om_nytt_vitnemål.feature) | `@OPT-BEH-BEH-010` | #612 | L2 | liten | `@draft` |

L2 beholder Feature-ID-en til den opprinnelige fila, fordi den er kjernen i initiativet.

Kuttet er gjort etter avhengighet og risiko, ikke etter hvilke skjermbilder som ligner hverandre. Hver leveranse gir noe brukbart alene. Det som styrer kuttet: hullet initiativet skal fylle er lite. Automatikken stopper på `FlereVitnemaalException`, og det å peke ut ett vitnemål løser det. Resten er forbedringer rundt den kjernen.

**MVP: L1 + L2.** Det er alt som trengs for at automatikken slutter å stoppe.

### Hvis tiden blir knapp, kutt L4 og L5, i den rekkefølgen

- **L4** har en fungerende reserveløsning allerede i drift: `lagreVitnemalUtregning` med fagløse karakterrader. Den dekker karakterpoeng, men ikke realfagspoeng, språkpoeng eller kravelementer. Saksbehandleren må da sette de tre siste for hånd. Det er tungvint, men mulig, og det er slik det gjøres i dag.
- **L5** er ren gevinst. Ingenting er avhengig av den, og designet er det minst modne i initiativet. Confluence har «1. versjon av design».

L1, L2, L3 og L6 bør ikke kuttes. L1 og L2 er selve hullet. Uten L3 er fagvalget borte, og da er det lite igjen av vitnemålsbehandlingen. L6 er liten, og uten den kan et låst grunnlag bli stille utdatert. Det er en feil som rammer søkeren, og som ingen oppdager.

## Hvorfor kravet trengs

Den automatiske saksbehandlingen stopper når søkeren har flere vitnemål. `vurderKravelementerAutomatisk` hopper over hele saken «uten entydig vitnemål», og `beregnPoengAutomatisk` har samme forutsetning (`FlereVitnemaalException`). For generell studiekompetanse er dette allerede løst semi-automatisk med `settGskKonklusjonFraVitnemaal`, der saksbehandleren peker ut ett `vgdoknr`. For poengberegning og kravelementvurdering finnes ingen tilsvarende inngang. Det er hullet initiativet fyller.

Vitnemålsbehandling er ikke nødvendig for alle søknader. Har søkeren ett elektronisk vitnemål uten forbedringer, klarer automatikken seg selv. Behovet oppstår når søkeren har flere vitnemål, har forbedret fag, eller har dokumentert fag som ikke finnes elektronisk.

Saksbehandlingen består av tre valg som henger sammen: hvilket vitnemål som legges til grunn (L2, L3), hvilke fag på det vitnemålet som skal telle (L3), og hvilke fag som må legges inn eller endres fordi de ikke står riktig på det elektroniske vitnemålet (L4). Til sammen utgjør de tre valgene beregningsgrunnlaget. Der reglene gir et valg, skal saksbehandleren velge det som gir søkeren best uttelling. Saksbehandleren kan ikke sette sammen et vitnemål søkeren ikke har.

## Kilder og etterprøvbarhet

Kravene erstatter to funksjoner i FS-klienten: vitnemålsbehandling (FS143.001 Vg.dokument, `w_vitnemalsbehandling.srw`) og vitnemålskalkulatoren (`w_vitnemalskalkulatur.srw`), begge i fsb10c, gitlab.sikt.no/fs/fs-klient. Referanser til tabeller, kolonner og tjenesteklasser står i kravene for at påstandene skal kunne etterprøves, aldri som føring for datamodell eller teknologi. Ny funksjonalitet bygges i FS Admin.

- **Designgrunnlag:** Confluence PFS 4582014995 «Vitnemål og kvalifikasjoner (Steg 2 - sekvensiell saksbehandling)», med designskisser i Figma (FS-Admin - Seksjon Opptak, node 10119-38734). Jira-initiativ SOPP-184.
- **Ny stack:** opptak-subgraph (experimental) har allerede `beregnPoengAutomatisk`, `vurderKravelementerAutomatisk`, `settGskKonklusjonFraVitnemaal` og `lagreVitnemalUtregning`. VGS-resultatene kommer fra KREG/NVB (`kompetansebevisByNasjonalId`).
- **Team Puff (07.10.2026):** Når en sak opprettes, hentes vitnemålet fra KREG, og vitnemålsnummeret og alle fagene lagres i tabellen `vgs_dokument_fag` i Team Puffs database. Fagene sendes ett og ett til kontrollmotoren. En rad har blant annet `terminkode`, `aar`, `fagstatuskode`, `fordypningsfag`, `kilde_kode` (f.eks. `KREG`), `tid_registrert` og `tid_oppdatert`.
- **Samordna opptaks wiki** (lest 07.10.2026): sidene «Poengberegning norske søkere», «Realfagspoeng», «Språkpoeng», «Tilleggspoeng», «Kvoter», «Spesielle opptakskrav», «Forkurs» og «Individuell vurdering (HUP)». Brukt til å avgjøre hva saksbehandleren må kunne velge, legge til og endre, ikke som beregningsregler.

## Avklaringer

- **21.09.2026:** Ti åpne spørsmål ble besluttet i gjennomgang med produkteier. Beslutningene står som `AVKLART`-kommentarer ved scenarioet de gjelder.
- **07.–08.10.2026:** Input fra Samordna opptaks wiki og Team Puff ble gått gjennom. Avklart:
  - Poengberegningen eies av Team Puff.
  - Saksbehandleren kan bare endre grunnlaget slik en regel tillater.
  - Tilleggsfag teller bare i ordinær kvote, med unntak.
  - Ulik poengsum per søknadsalternativ håndteres med fagvalget per poengvariant.
  - Søkere med HUP har ingen poeng å behandle.
  - Endringer avvises når beregningen feiler.
  - Skjemaet håndhever ikke karaktertyper for manuelt innlagte fag.
  - Hvilken leveranse hvert scenario hører til.

  Ingen spørsmål står åpne.
- **08.10.2026:** Oppdelingen i leveranser er besluttet, og hver leveranse har fått sin egen kravspesifikasjon.

## Avgrensninger: bevisst utenfor kravene

- **Poengberegningen.** Selve beregningen eies av Team Puff, og vitnemålsbehandleren kaller endepunktene deres. Kravene dekker grunnlaget saksbehandleren velger, legger til og endrer, og visningen av resultatet. Hvilke karakterer som teller, avrunding, satser for realfags- og språkpoeng, tak og kvotetilhørighet hører hos Team Puff.
- **Resultater fra høyere utdanning.** Kravene dekker bare VGS-resultater fra KREG/NVB. Resultater fra høyere utdanning finnes i dag bare som en umodellert JSON-streng fra Vitnemålsportalen (`Soker.vitnemal: String`, i ELMO-format, se `VitnemalService` i opptak-service). Å vise fag derfra, og la dem telle, forutsetter at ELMO modelleres i GraphQL først. Initiativ #319 slår fast at «høyere utdanning er ikke viktig for 2026».
- **Kobling mellom manuelt innlagt fag og opplastet dokumentasjon.** Besluttet 21.09.2026 å holdes utenfor første leveranse. Behovet er reelt: et manuelt innlagt fag bygger på saksbehandlerens vurdering av et dokument, og med fagkode teller det også i realfagspoeng og kravelementer. Men koblingen belaster ikke 2026-leveransen. Samme spørsmål står åpent for praksisperioder i `registrere_praksis.feature` (Jira ADMI-45). De to bør løses sammen når de tas.
- **Valg av grunnlag (GSK).** Valg av kvalifikasjonsgrunnlag er en egen kapabilitet med eget API (`gsk.graphqls`: `opprettGskVedtakV3`, `endreGskVedtakV3`, `settGskKonklusjonFraVitnemaal`). Vitnemålsbehandleren forutsetter grunnlaget som gitt.
  - Avklart 08.10.2026: HUP og VES kan ikke gjelde samtidig for samme søker, heller ikke når søkeren kunne vært poengberegnet til noen søknadsalternativer og vurdert individuelt til andre. Hvilket av dem som gjelder, avgjøres i valget av grunnlag. Har søkeren HUP, er det ingen poeng å behandle i vitnemålsbehandleren.
- **Fagprofil og kravelementvurdering.** Om søkeren oppfyller de spesielle opptakskravene, vurderes mot kompetanseregelverket og styres av `vurderKravelementerAutomatisk`. Vitnemålsbehandleren leverer grunnlaget den vurderingen bygger på, men vurderingen selv hører i et eget krav.
- **Tverrgående moduler i steg 2.** Progress-bar, dokumentseksjonen, høyreskuffen med søknadsalternativer og merknader er beskrevet i Confluence PFS 4582014995, men gjelder hele sekvensen, ikke vitnemålsbehandlingen.
- **Automatisk valg av beste kombinasjon.** #562 «Automatisk velge det vitnemålet eller den fagkombinasjonen som er til gunst for søker» er komplementært: vitnemålsbehandleren er det saksbehandleren gjør når automatikken ikke kan eller ikke bør avgjøre. Når #562 bygges, må forholdet til låsingen avklares. En automatikk som velger fagkombinasjon, vil møte poengrader saksbehandleren har låst.
- **Fagkonvertering mellom reformer.** FS-klienten har `w_fagkonverterer` for å mappe fagkoder fra en tidligere reform til gjeldende. Om den funksjonen skal videreføres, er ikke vurdert.
- **UI-detaljer.** Plassering, accordion-oppførsel, antall rader i skjemaet, kolonnebredder, utforming av varsler og vindushåndtering hører i `<feature>.design.md` for hver leveranse, jf. skillen `fs-implementasjonsdetaljer`.

## Oppfølging utenfor initiativet

- **Aktørbetegnelse.** Kravene beskriver tilgang med rettighetene `SE_SØKNADSBEHANDLING` og `MODIFISERE_SØKNADSBEHANDLING`, fordi det er slik autorisasjonen faktisk virker. `registrere_praksis.feature` (`@OPT-BEH-BEH-003`) bruker rollenavnet «opptakssaksbehandler», og `behandle_søknad.feature` (`@OPT-BEH-BEH-001`) bruker «saksbehandler for opptak». Aktørlisten i `krav/README.md` lister bare «saksbehandler». Det er tre ulike måter å beskrive det samme på. Det bør samordnes i en egen endring, og spørsmålet er prinsipielt: skal krav beskrive tilgang med rollenavn eller med rettigheter?
- **`behandle_søknad.feature`** har to skisselinjer som vitnemålsbehandleren overtar: «Så skal administrator se resultater fra videregående skole» og «Så skal administrator se resultater fra høyere utdanning». Den første er dekket, og den andre er avgrenset ut. Linjene bør fjernes fra `behandle_søknad.feature`.
- **`registrere_praksis.feature`** har to åpne spørsmål som er besvart her og bør lukkes likt: koblingen til opplastet dokumentasjon (utenfor første leveranse) og synlighet uten registreringsrettighet (lesetilgang gir innsyn, og endringsmuligheten skjules).
