# Spec: Tidlig opptak

## Kilde

- **Oppgave:** `tasks/opptak/tidlig-opptak/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/` og `krav/02 Opptak/11 Opptak/06 Tidlig opptak/`
- **GitHub:** [#456](https://github.com/sikt-no/fs/issues/456), [#525](https://github.com/sikt-no/fs/issues/525)
- **Jira:** STEK-188 «Forvalte og behandle tidligopptak», med underoppgaver
- **Hentet:** 2026-10-08 13:30

## Omfang

Hele prosessen for tidlig opptak: søkeren ber om tidlig opptak med en begrunnelse, saksbehandleren finner og vurderer søknadene, opptaksforvalteren gjennomfører tidligopptaket og deler ut tilbudsgarantier, og svaret publiseres og sendes til søkeren. Spec-en dekker også manuell tilbudsgaranti fra behandler, tilbyder og opptaksforvalter, og at tilbudsgarantien gjelder i hovedopptaket. Den dekker ikke opptaksinnstillingene for tidlig opptak (aktivering, frister og poenggrense per utdanningstilbud), forvaltning av kodeverkene (begrunnelser, konklusjoner og tilbudsgarantityper, som legges inn i databasen per opptak), eller hvordan plasstildelingen leser tilbudsgarantiene (STEK-263).

## Krav

- **`søke_om_tidlig_opptak.feature`** (`@OPT-SØK-SØK-011`) — søkeren ber om tidlig opptak fra søknadsdetaljene etter at søknaden er sendt, velger begrunnelse, og ser lenke og tidspunkt. Søkeren kan ikke trekke ønsket, og bytte begrunnelse er ikke et krav (endret etter innhentingen, se _Endringer etter innhenting_). ([krav/…/søke_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature))
- **`finne_søknader_om_tidlig_opptak.feature`** (`@OPT-BEH-BEH-009`) — filtre i sakslisten på om søkeren har søkt om tidlig opptak, og på konklusjonen for tidlig opptak, som kan kombineres med de andre filtrene (endret etter innhentingen, se _Endringer etter innhenting_). ([krav/…/finne_søknader_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature))
- **`vurdere_søknad_om_tidlig_opptak.feature`** (`@OPT-BEH-BEH-013`) — saksbehandleren velger én av opptakets konklusjoner per organisasjon, som sier om søkeren deltar (endret etter innhentingen, se _Endringer etter innhenting_). Konklusjonen kan endres også etter gjennomføringen. ([krav/…/vurdere_søknad_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature))
- **`gi_tilbudsgaranti_ved_tidlig_opptak.feature`** (`@OPT-BEH-BEH-007`) — opptaksforvalteren prøvekjører og gjennomfører tidligopptaket og ser utfallet. Manuell tilbudsgaranti fra B-, T- og F-rolle. Tilbudsgarantien gjelder i hovedopptaket. ([krav/…/gi_tilbudsgaranti_ved_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature))
- **`publisere_svar_på_tidlig_opptak.feature`** (`@OPT-OPT-TID-001`) — svaret publiseres når tidligopptaket gjennomføres, uten egen publiseringsdato (endret etter innhentingen, se _Endringer etter innhenting_), og én melding til søkerne med forhåndsvisning. ([krav/…/publisere_svar_på_tidlig_opptak.feature](../../../../krav/02%20Opptak/11%20Opptak/06%20Tidlig%20opptak/publisere_svar_p%C3%A5_tidlig_opptak.feature))
- **`se_svar_på_tidlig_opptak.feature`** (`@OPT-SØK-SØK-012`) — søkeren ser utfallet per søknadsalternativ og et samlet svar, på språket søkeren har valgt. ([krav/…/se_svar_på_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_svar_p%C3%A5_tidlig_opptak.feature))

## Skisser

### Skisse: Min kompetanse – tidlig opptak

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=2769-1614
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/min-kompetanse-tidlig-opptak/screenshot.png), [sub-frames/](krav-input/sketches/figma/min-kompetanse-tidlig-opptak/sub-frames/), [design-context.md](krav-input/sketches/figma/min-kompetanse-tidlig-opptak/design-context.md)
- **Dekker krav:** `søke_om_tidlig_opptak.feature`, `publisere_svar_på_tidlig_opptak.feature`, `se_svar_på_tidlig_opptak.feature`
  - «Egen flyt for tidlig opptak» og «Kvittering» dekker `søke_om_tidlig_opptak.feature`.
  - «Svar på tidlig opptak» (meldingen i Mine meldinger) dekker `publisere_svar_på_tidlig_opptak.feature`.
  - Variantene av søknadsdetaljene («Fikk tidlig opptak …», «avslag …», «Reservert») dekker `se_svar_på_tidlig_opptak.feature`.
- **Valideringsstatus:** `Avvik: skissen mangler trekk av ønsket og lenken til lærestedets side, og viser at tidlig opptak søkes fra søknadsdetaljene etter at søknaden er sendt (ikke i kravet).`
- **Beslutning ved avvik:** Kravet er riktig for trekk og lenke, og skissen må oppdateres. (Endret 09.10.2026: trekk er tatt ut av kravet, så skissen er riktig der.) At tidlig opptak søkes etter at søknaden er sendt, er lagt til i kravet (regelen «Søkeren ber om tidlig opptak etter at søknaden er sendt»).

### Skisse: Min kompetanse – svar på tidlig opptak

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=2777-5267
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/min-kompetanse-svar-pa-tidlig-opptak/screenshot.png)
- **Dekker krav:** `se_svar_på_tidlig_opptak.feature`
- **Valideringsstatus:** `Avvik: skissen viser poengberegning og poenggrense også på søknadsalternativet der søkeren er innvilget.`
- **Beslutning ved avvik:** Kravene er riktige, og skissen er utdatert på dette punktet. Poengsum og poenggrense vises bare der søkeren deltok uten å nå opp.

### Skisse: FS-Admin – tidlig opptak

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18561-132717
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/fs-admin-tidlig-opptak/screenshot.png), [sub-frames/](krav-input/sketches/figma/fs-admin-tidlig-opptak/sub-frames/), [design-context.md](krav-input/sketches/figma/fs-admin-tidlig-opptak/design-context.md)
- **Dekker krav:** `vurdere_søknad_om_tidlig_opptak.feature`, `gi_tilbudsgaranti_ved_tidlig_opptak.feature`
  - «Søknadsbehandling» og «Tidlig opptak behandling» dekker `vurdere_søknad_om_tidlig_opptak.feature` og den manuelle tilbudsgarantien i `gi_tilbudsgaranti_ved_tidlig_opptak.feature` (eget felt per rolle, de andre rollenes garanti vises som tekst).
  - «Kjør tidligopptak?»-dialogen dekker gjennomføringen i `gi_tilbudsgaranti_ved_tidlig_opptak.feature`.
  - Skissen dekker ikke `finne_søknader_om_tidlig_opptak.feature` (filtrene).
  - «Tidlig opptak» (poenggrenser per studium) gjelder opptaksinnstillingene, som er utenfor denne spec-en.
- **Valideringsstatus:** `Avvik: skissen har én konklusjon («KFF – Kan få tidlig opptak, har godkjent grunn»), uten eget steg for om begrunnelsen er dokumentert.`
- **Beslutning ved avvik:** Kravet er endret før det ble hentet inn: «ikke dokumentert» registreres som en mangel som søkeren får beskjed om, og etter det konkluderer saksbehandleren fritt. Vurderingen er fortsatt et eget steg, så skissen må få det.
- **Ny beslutning 2026-10-09:** Skissen er riktig. Vurderingen og konklusjonen er ett steg, og kravet er endret (se _Endringer etter innhenting_). Avviket er borte.

## Kodesjekk

- **Sjekket:** fs-plattform `main` (`bd8091d49c`), modulen `opptak`. Brukergrensesnittet (fs-admin og Min kompetanse) er ikke sjekket.
- **Obs:** den nyeste versjonen av gjennomføringen og svaret til søkeren ligger på branchen `STEK-503_sett_sammen_tidligopptak_konklusjoner_for_soker` (34 commits foran `main` 08.10.2026), som ikke er sjekket her. Avvikene under kan være løst der. Kjør kodesjekken mot den branchen, eller mot `main` når den er merget.
- **Ingen av kravene er helt implementert**, så ingen kan få `@implemented` nå.

| Krav | Scenarioer | Finnes | Delvis | Mangler |
|---|---|---|---|---|
| `@OPT-SØK-SØK-011` Søke om tidlig opptak | 15 | 8 | 2 | 3 (+2 ikke sjekket, UI) |
| `@OPT-BEH-BEH-009` Finne søknader om tidlig opptak | 4 | 0 | 0 | 4 |
| `@OPT-BEH-BEH-013` Vurdere søknad om tidlig opptak | 17 | 6 | 4 | 7 |
| `@OPT-BEH-BEH-007` Gi tilbudsgaranti ved tidlig opptak | 30 | 20 | 4 | 6 |
| `@OPT-OPT-TID-001` Publisere svar på tidlig opptak | 10 | 1 | 4 | 5 |
| `@OPT-SØK-SØK-012` Se svar på tidlig opptak | 22 | 0 | 6 | 16 |

Alle avvikene under er besluttet som **kravet er riktig, koden skal endres**. Mangler som bare er «ikke bygget ennå», står ikke her.

- `@OPT-BEH-BEH-007`: kravet sier at søkeren må være kvalifisert, og at opptaksforvalteren ser når kvalifiseringen ikke er vurdert. Koden sjekker kvalifisering bare indirekte via poengsummen, og rapporterer `MANGLER_POENGSUM` («er poengberegningen kjørt?»). Utfallet `IKKE_KVALIFISERT` betyr «poengsum under grensen» (fs-plattform `opptak/opptak-service/…/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java:505-523`).
- `@OPT-BEH-BEH-007`: kravet sier at tilbudsgarantien flyttes til det høyere prioriterte søknadsalternativet ved ny gjennomføring. Koden lar den gamle stå (`TidligopptakTilbudsgarantiService.java:396-399`).
- `@OPT-BEH-BEH-007`: kravet sier at tilbudsgarantien gir tilbud i hovedopptaket, faller bort når søknadsalternativet fjernes eller søknaden trekkes, og gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen. Plasstildelingen leser ikke `tilbudsgarantitype_kode_fra_*`. (At garantien ikke er knyttet til prioritet, er ikke lenger et avvik, se _Endringer etter innhenting_.) (`opptak/opptak-service/…/plasstildeling/service/RangeringService.java:267`, `OpptakskjoringService.java:263-268`, `V291__saksbehandling_skjema.sql:125-135`). Avhenger av STEK-263.
- `@OPT-BEH-BEH-013`: kravet skjuler steget for tidlig opptak når søkeren ikke har søkt (brukergrensesnittet, ikke sjekket). Koden har én konklusjonskode, som kan settes og endres fritt, som kravet sier. (Vurdering som eget steg og mangel med beskjed er ikke lenger i kravet, se _Endringer etter innhenting_.) (`opptak/opptak-service/…/saksbehandling/SettTidligopptakKonklusjonService.java:29-65`, `V291__saksbehandling_skjema.sql:76`).
- `@OPT-OPT-TID-001`: kravet sier at budskapet og språket i meldingen følger søkerens utfall og språk. Meldingstjenesten tar tittel og innhold som fri tekst fra kalleren (`opptak/opptak-service/…/kommunikasjon/TidligOpptakMeldingService.java:29-33`), og NKR-navn mangler nordsamisk (`V398__tidlig_opptak_melding.sql:75-77`).
- `@OPT-SØK-SØK-012`: kravet skiller «innvilget», «ikke innvilget», «høyere prioritet», «deltar ikke» og «tilbyr ikke». Meldingssnapshotet har bare `TILBUD`/`AVSLAG` (`V398__tidlig_opptak_melding.sql:52,58`), og lagrer poeng for alle alternativer.
- `@OPT-OPT-TID-001` og `@OPT-SØK-SØK-012` (lagt til 2026-10-09): kravet har ingen egen publiseringsdato for tidlig opptak. Svaret blir synlig når tidligopptaket gjennomføres. Branchen `STEK-503_sett_sammen_tidligopptak_konklusjoner_for_soker` viser svaret først når hendelsen `PUBLISERING_TIDLIG_OPPTAK` på opptaket har passert (`opptak/docs/tidligopptak-status.md`, «Publisering» og «Tilgangen»), og må endres. Vinduet som lukkes når hovedopptaket er publisert (`PUBLISERING_RESULTAT`), er ikke berørt.
- `@OPT-BEH-BEH-007` (lagt til 2026-10-09): kravet sier at opptaksforvalter kan gjennomføre tidligopptaket mer enn én gang, og at en ny gjennomføring tar med saker som er blitt ferdig behandlet siden sist. Dokumentasjonen til `antallSakerIkkeFerdigbehandlet` i `tidligopptak-tilbudsgaranti-automatikk.graphqls` på branchen STEK-503 sier at det kjøres «for ekte én gang» og at det «kommer ingen ny sjanse». Koden ser ut til å tåle en ny gjennomføring, så det er dokumentasjonen som må rettes.
- Sidefunn, utenfor kravene: `BehandlertildelingService.java:448-461` kopierer tilbudsgarantien fra tilbyder og opptaksforvalter, men ikke fra behandler, når søknadsalternativet flyttes til en annen behandler.

## Retagging

Alle seks kravene ble hentet inn. Ingen ble holdt tilbake.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 …/01 Søknad/søke_om_tidlig_opptak.feature` | `@OPT-SØK-SØK-011 @must @planned` | `@OPT-SØK-SØK-011 @must @in-progress` |
| `krav/02 Opptak/13 …/02 Behandling/finne_søknader_om_tidlig_opptak.feature` | `@OPT-BEH-BEH-009 @must @planned` | `@OPT-BEH-BEH-009 @must @in-progress` |
| `krav/02 Opptak/13 …/02 Behandling/vurdere_søknad_om_tidlig_opptak.feature` | `@OPT-BEH-BEH-013 @must @planned` | `@OPT-BEH-BEH-013 @must @in-progress` |
| `krav/02 Opptak/13 …/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` | `@OPT-BEH-BEH-007 @must @planned` | `@OPT-BEH-BEH-007 @must @in-progress` |
| `krav/02 Opptak/11 Opptak/06 Tidlig opptak/publisere_svar_på_tidlig_opptak.feature` | `@OPT-OPT-TID-001 @must @planned` | `@OPT-OPT-TID-001 @must @in-progress` |
| `krav/02 Opptak/13 …/01 Søknad/se_svar_på_tidlig_opptak.feature` | `@OPT-SØK-SØK-012 @must @planned` | `@OPT-SØK-SØK-012 @must @in-progress` |

`søke_om_tidlig_opptak.feature` og `vurdere_søknad_om_tidlig_opptak.feature` ble endret på stedet før retaggingen, etter skissevalideringen (se _Skisser_).

## Endringer etter innhenting

Kravene er `@in-progress`, og endres på stedet. Endringene står her, så den som implementerer, ser dem.

- **2026-10-08, `@OPT-BEH-BEH-009`:** Filteret «Ikke vurdert for tidlig opptak» heter nå «Tidlig opptak ikke ferdig behandlet», og så før bare på konklusjonen. Nå viser det sakene der søkeren har søkt om tidlig opptak, og der saksbehandleren ikke har konkludert, eller har konkludert med «deltar», men saken ikke er ferdig behandlet. Saker med «deltar ikke» er ikke med. Grunnen er at bare ferdig behandlede saker er med i tidligopptaket (`@OPT-BEH-BEH-007`), så en sak med «deltar» som ikke er ferdig behandlet, ville falt ut uten å vises i filteret. Scenarioet «Filtrere på saker der tidlig opptak ikke er ferdig behandlet» har en tabell med alle kombinasjonene.
  - Hint til fs-plattform: alt som trengs, finnes allerede. Søkt er `soknad.tidligopptak_begrunnelsetype_kode` (ikke null), konklusjonen er `sak.tidligopptak_konklusjon_kode`, og ferdig behandlet er `SakStatusKode.FERDIG_BEHANDLET`. Filteret kan legges i `SakFilterV2Input` som de andre, med en `@condition` i `SakService`.
  - Forslag til tekst ved avkrysningsboksen (skal inn i implementasjonsdetaljene): «Søkeren har søkt om tidlig opptak, men er ikke med ennå. Saken mangler konklusjon, eller konklusjonen er «deltar», men saken er ikke ferdig behandlet.»

- **2026-10-08, `@OPT-SØK-SØK-011`:** «trekke søknaden om tidlig opptak» heter nå «trekke ønsket om tidlig opptak», i regelen, scenarioene og stegene. Betydningen er den samme: søknaden blir en vanlig søknad, uten ønske om tidlig opptak. Ordet er byttet fordi «trekke søknaden» ellers betyr å trekke hele søknaden (`trekke_søknad.feature`, og `visTrukneSoknader` og `SoknadErTrukketService` i koden). Step definitions som bruker den gamle ordlyden, må oppdateres.
- **2026-10-08, `@OPT-BEH-BEH-007`:** Tilbudsgarantien følger søknadsalternativet, uansett prioritet. Den faller ikke lenger bort når søkeren flytter søknadsalternativet ned, eller når et nytt søknadsalternativ legges over. Garantien betyr at søkeren aldri blir forbigått på søknadsalternativet. Prioriteten avgjør bare hvilket tilbud søkeren får. Scenarioet «Tilbudsgarantien faller bort når søknadsalternativet flyttes ned» er erstattet av «Tilbudsgarantien følger søknadsalternativet når prioriteten endres», og «Søkeren blir ikke forbigått på søknadsalternativet med tilbudsgaranti» er lagt til. Legger søkeren søknadsalternativet inn igjen før søknadsfristen, gjelder garantien igjen uansett prioritet: scenarioet «Tilbudsgarantien gjelder ikke når søknadsalternativet legges inn på en annen prioritet» er fjernet, og «gjelder igjen» er en `Scenariomal:` med prioritet 1 og 2. Koden gjør allerede dette, så avviket om nedprioritering er borte.
- **2026-10-08, `@OPT-BEH-BEH-007`:** Et tidligopptakstilbud fra tilbyder (FOP) teller i gjennomføringen, etter review fra fagperson i STEK-269 (30.09.2026). Søkeren får tidligopptakstilbud på det høyest prioriterte søknadsalternativet som har et tidligopptakstilbud fra før eller oppfyller kravene, og ingen søknadsalternativer under får tilbudsgaranti. Et tidligopptakstilbud fra før gjelder uansett konklusjon, status og poengsum. To nye scenarioer: «Tidligopptakstilbud fra tilbyder går foran poengsummen» og «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum». `main` leser bare garantien fra forvalter, men branchen `STEK-503_sett_sammen_tidligopptak_konklusjoner_for_soker` har det (`c9b3690`, `TidligopptakTilbudsgarantiService.behandleSoker`).
- **2026-10-09, `@OPT-BEH-BEH-013`:** Vurderingen og konklusjonen er ett steg, etter review av PR #654. Saksbehandleren velger én konklusjon blant konklusjonene opptaket har, og hver konklusjon sier om søkeren deltar (`deltar_i_tidligopptak`). Systemet oppretter ingen mangel: saksbehandleren oppretter en vanlig søknadsmangel når dokumentasjonen mangler. Regelen «Saksbehandler vurderer om begrunnelsen er dokumentert» og scenarioene om mangel og «kan ikke konkludere før begrunnelsen er vurdert» er fjernet. Nye scenarioer: «Velge blant konklusjonene opptaket har» og «Konkludere om søkeren deltar i tidligopptaket». Stemmer med koden og skissen i FS-Admin.
- **2026-10-09, `@OPT-BEH-BEH-013`:** Har søkeren ikke søkt om tidlig opptak, er hele steget for tidlig opptak skjult i saksbehandlingen. «Kan ikke konkludere når søkeren ikke har søkt om tidlig opptak» er erstattet av «Søknad uten ønske om tidlig opptak viser ikke tidlig opptak».
- **2026-10-09, `@OPT-BEH-BEH-013`:** Konklusjonen låses ikke når tidligopptaket er gjennomført. Saksbehandleren kan sette og endre den etterpå, uten at tilbudsgarantier som alt er gitt, eller svaret søkeren har fått, endres. En ny gjennomføring tar den med. «Låst etter at tidligopptaket er gjennomført» og «Kan ikke konkludere etter at tidligopptaket er gjennomført» er erstattet av «Endre konklusjonen etter at tidligopptaket er gjennomført». Stemmer med koden.
- **2026-10-09, `@OPT-BEH-BEH-013`:** Kvalifiseringen er ikke en del av steget for tidlig opptak. Den vurderes i den ordinære søknadsbehandlingen og sjekkes når tidligopptaket gjennomføres (`@OPT-BEH-BEH-007`). Scenarioet «Konkludere før kvalifiseringen er vurdert» og regelen «Kvalifisering hentes fra den ordinære søknadsbehandlingen» er fjernet.
- **2026-10-09, `@OPT-BEH-BEH-013`:** «Se dokumentasjon søkeren har levert» er fjernet. Det er en generell funksjon i saksbehandlingen (`behandle_søknad.feature`). I «Konklusjon per organisasjon» sier utfallet nå hvilke søknadsalternativer som er med i tidligopptaket, ikke at søkeren «deltar i tidligopptaket ved» en organisasjon.
- **2026-10-09, `@OPT-BEH-BEH-009`:** Erstatter endringen fra 08.10. Kravet beskriver hva saksbehandleren kan filtrere på, ikke hva filtrene heter, etter review av PR #654. Det er to filtre som kan kombineres med de andre i sakslisten: om søkeren har søkt om tidlig opptak, og konklusjonen for tidlig opptak (ingen, deltar eller deltar ikke). Ingen av dem tar med andre betingelser i det skjulte. Filteret «Tidlig opptak ikke ferdig behandlet» og forslaget til tekst ved avkrysningsboksen gjelder ikke lenger. Sakene som faller ut av tidligopptaket, finnes med to kombinasjoner: konklusjonen «ingen», og konklusjonen «deltar» sammen med statusfilteret (ikke ferdig behandlet). Scenariomalen «Finne saker som faller ut av tidligopptaket» viser begge.
  - Hint til fs-plattform: `soktTidligOpptak: Boolean` (`soknad.tidligopptak_begrunnelsetype_kode` ikke null) og et filter på konklusjonen i `SakFilterV2Input`, f.eks. `harTidligopptakKonklusjon: Boolean` og `deltarITidligopptak: Boolean` (`tidligopptak_konklusjon.deltar_i_tidligopptak`). Statusfilteret (`statuskoder`) finnes.
- **2026-10-09, `@OPT-SØK-SØK-011`:** Søkeren kan ikke trekke ønsket om tidlig opptak i første versjon, etter review av PR #654 («fire and forget», avklart med fagperson, og skissene viser det ikke). Regelen «Søkeren kan trekke ønsket om tidlig opptak innen fristen» og de to scenarioene er fjernet. Avviket om at det ikke finnes en mutation for å trekke, er borte. Endringen av ordlyden fra 08.10 gjelder ikke lenger.
- **2026-10-09, `@OPT-SØK-SØK-011`:** Lenken til informasjon om tidlig opptak hører til opptaket, og settes av opptakseieren, ikke per utdanningstilbud (review av PR #654, og ønsket i STEK-267). Søkeren ser én lenke for opptaket. «Se lærestedets side om tidlig opptak» er erstattet av «Se informasjon om tidlig opptak i opptaket». Scenarioet om å sette lenken er flyttet fra `opptaksinnstillinger_utdanningstilbud.feature` til `innstillinger.feature` (`@OPT-OVO-INN-001`), som er hentet inn i oppgaven `opprette-og-vedlikeholde-opptak`. Den oppgaven har fått en merknad.
- **2026-10-09, `@OPT-SØK-SØK-011`:** Å bytte begrunnelse er ikke et krav i første versjon (review av PR #654, skissene viser det ikke). Koden tillater det i dag, og det kan bli stående. «Bytte begrunnelse før fristen» er fjernet, og «Se når søknaden om tidlig opptak sist ble endret» er erstattet av «Se når søkeren søkte om tidlig opptak». Scenarioet om begrunnelsen «Ingen begrunnelse» er fjernet, fordi det er konfigurasjon av opptaket.
- **2026-10-09, `@OPT-SØK-SØK-011`:** «Se hva som må dokumenteres for begrunnelsen» er slått sammen med «Se begrunnelsene søkeren kan velge»: søkeren ser begrunnelsene med hva som må dokumenteres for hver av dem, og velger én. Kravet sier ikke i hvilken rekkefølge, eller når dokumentasjonskravet vises (avklart med Daniel). «Forklaringen på begrunnelsen» er tatt ut.
- **2026-10-09, `@OPT-SØK-SØK-011`:** Kommentar om at ønsket om tidlig opptak blir stående når søkeren fjerner alle søknadsalternativene som tilbyr tidlig opptak. Søkeren kan da ikke få tilbudsgaranti, og svaret viser at søknadsalternativene ikke tilbyr tidlig opptak. Ingen ny regel.
- **2026-10-09, `@OPT-BEH-BEH-007` og `@OPT-SØK-SØK-012`:** Kommentar om at «tilbudsgarantien gjelder igjen» er ett tilfelle av en generell oppførsel: å fjerne et søknadsalternativ eller trekke søknaden er en deaktivering, ikke en sletting (`soknadsalternativ.slettet`). Det finnes ikke noe generelt krav for det ennå (påpekt i review av PR #654). Det generelle kravet er utenfor denne oppgaven.
- **2026-10-09, alle kravene:** «tidlig tilbud» heter nå «tilbyr tidlig opptak» (f.eks. «"Sykepleie, høst 2027" tilbyr tidlig opptak», «poenggrense for tidlig opptak»), som i koden (`utdanningstilbud.tilbyr_tidlig_opptak`) og skissen, etter review av PR #654. Gjelder også `opptaksinnstillinger_utdanningstilbud.feature` og `listevisning_utdanningstilbud.feature`. Issuet #578 bruker fortsatt «tidlig tilbud».
- **2026-10-09, `@OPT-OPT-TID-001`, `@OPT-SØK-SØK-012` og `@OPT-BEH-BEH-007`:** Det er ingen egen publiseringsdato for tidlig opptak, etter review av PR #654. Svaret blir synlig for søkerne når opptaksforvalter gjennomfører tidligopptaket, ikke ved prøvekjøring, og en ny gjennomføring endrer det søkerne ser med en gang. Meldingen sendes i et eget steg etterpå. Regelen om å sette publiseringsdatoen er fjernet. Regelene om når svaret publiseres, er skrevet om i begge kravene, og «Gjennomføring før publisering sender ingen melding» heter nå «Gjennomføring sender ingen melding». Branchen STEK-503 må endres (se _Kodesjekk_).
- **2026-10-09, `@OPT-BEH-BEH-013`:** Feature-ID-en til `vurdere_søknad_om_tidlig_opptak.feature` er endret fra `@OPT-BEH-BEH-008` til `@OPT-BEH-BEH-013`, fordi `søknadsmangler.feature` (PR #700) også bruker 008. ID-en er byttet overalt i spec-en, også i tabellene over.
- **2026-10-09, `@OPT-BEH-BEH-007`:** Rapporten og parameterne for gjennomføringen er utdypet etter STEK-489 og branchen STEK-503: nytt scenario «Angi grensen for kvotevarsel» (standard er hele kvoten), nytt scenario «Se antall saker som ikke er ferdig behandlet», og «Se utfallet for hver søker» viser også antall søkere som er vurdert og antall tilbudsgarantier som er satt. Rapporter fra tidligere gjennomføringer er ikke et krav.
- **2026-10-09, `@OPT-BEH-BEH-007`:** Nytt scenario «Ny gjennomføring tar med en sak som er blitt ferdig behandlet», og en avklaring om at tidligopptaket kan gjennomføres mer enn én gang.

## Åpne spørsmål

- [ ] Implementasjonsdetaljer mangler for `søke_om_tidlig_opptak.feature`, `vurdere_søknad_om_tidlig_opptak.feature`, `gi_tilbudsgaranti_ved_tidlig_opptak.feature`, `publisere_svar_på_tidlig_opptak.feature` og `se_svar_på_tidlig_opptak.feature`. Tekstene i skissene (statusmerker, «Hvem kan søke tidlig opptak?», meldingsteksten, samlet svar) må inn i `<feature>.design.md` med `fs-implementasjonsdetaljer`.
- [ ] Skissene må oppdateres: lenke til opptakets side om tidlig opptak (Min kompetanse), ingen poeng og grense når søkeren er innvilget (Min kompetanse).
- [ ] Det finnes ingen skisse for filtrene i sakslisten (`finne_søknader_om_tidlig_opptak.feature`).

## Rute

fs-plattform → fs-admin → Min kompetanse
