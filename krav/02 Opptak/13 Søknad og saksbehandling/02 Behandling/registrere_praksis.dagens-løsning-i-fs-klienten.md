# Praksisberegning i FS-klienten i dag

Referansenotat for `registrere_praksis.feature` (`@OPT-BEH-BEH-003`).

Notatet beskriver **dagens** løsning, ikke kravet. Hvilke deler av adferden
som videreføres og hvilke som ikke gjør det, står i `.feature`-filen — hver
avklaring der viser tilbake hit.

Alle påstandene under er lest ut av kildekoden i
`gitlab.sikt.no/fs/fs-klient`, branch `master`, commit `64d1e0b`
(PowerBuilder). Filreferanser er oppgitt slik at de kan etterprøves.

## Hvor funksjonen ligger

Vinduet **«Spesiell søknad samlebilde [spessoknad]»** —
`ws_objects/fsb10c.pbl.src/w_spesiellsoknad.srw`.

Vinduet har ti faner. Tre av dem er relevante:

| Fane | Datavindu | Innhold |
|------|-----------|---------|
| Praksis | `dm_person_personpraksis` | praksisperiodene og summene |
| Fagprofil | `dm_person_fagprofil_spesiell` | `kravelementkode` + `status_bestatt` |
| Spesiell vurdering søknad / søknadsalt | `dm_person_soknadspesvurd` / `dm_person_soknadsaltspesvurd` | vurderingsstatus |

Praksis-fanen har også en egen knapp **«&Timereg»** som åpner dialogen
«Omgjøring fra time- til månedsverk [praksisberegn]».

Samme datamodell vedlikeholdes også fra `w_personpraksis`
(`ws_objects/fsb40.pbl.src/w_personpraksis.srw`) — et rent
tabellvedlikeholdsvindu uten beregning.

## Datamodell: `FS.PERSONPRAKSIS`

Nøkkelen er **personen** (`fodselsdato`, `personnr`, `lopenr`) — ikke søknad
og ikke sak.

| Kolonne | Merknad |
|---------|---------|
| `praksistypekode` | Obligatorisk. Oppslag mot `FS.PRAKSISTYPE`. |
| `dato_fra` | Obligatorisk. |
| `dato_til` | **Valgfri.** |
| `prosenttall_av_heltid` | Stillingsprosent. |
| `tall_varighet` | Beregnet varighet. Skrives av kalkulatoren. |
| `tidsenhet_varighet` | Kalkulatoren setter alltid `'MÅNEDER'`. |
| `status_relevant` | J/N. Styrer «Sum relevant praksis». |
| `status_inngar_gsk_grunnlag` | Om praksisen inngår i GSK-grunnlaget. |
| `dokumentnr` | Peker til `FS.DOKUMENTARKIV`. |
| `merknadtekst` | Fritekst, 250 tegn. Brukes også som styringsflagg — se under. |
| `varsel` | Beregnet kolonne i datavinduet, ikke i basen. Overlappsvarsel. |
| `saksbehinit_opprettet` / `_endret`, `dato_opprettet` / `_endret` | Sporbarhet. |

Obligatoriske felt er kun `praksistypekode` og `dato_fra`
(`w_spesiellsoknad.srw:890-895`). En praksisperiode kan altså lagres uten
sluttdato, og da beregnes ingen varighet.

`FS.PRAKSISTYPE` har i tillegg `dokumenttypekode`, `status_gjelder_soker`,
`status_gjelder_student` og `status_valgbar_sokere`
(`ws_objects/fskoder2.pbl.src/d_praksistype.srd`).

## Beregning fra stillingsprosent

`w_spesiellsoknad.srw:2223-2247`, i `itemchanged` på praksis-datavinduet:

```
varighet = truncate( MONTHS_BETWEEN(dato_til + 1, dato_fra) * prosent / 100, 1 )
tidsenhet_varighet = 'MÅNEDER'
```

- `MONTHS_BETWEEN` er Oracles funksjon, kjørt mot `DUAL`. Den gir et
  desimaltall der brøkdelen regnes som dager delt på 31.
- `dato_til + 1` gjør sluttdatoen inklusiv.
- Er `prosenttall_av_heltid` tom, settes den til `100`.
- `truncate(..., 1)` — **avkorting** til én desimal, ikke avrunding.
  1,99 måneder blir 1,9.
- Beregningen kjøres på nytt hver gang `dato_fra`, `dato_til` eller
  `prosenttall_av_heltid` endres.
- Beregningen **hoppes over** hvis `merknadtekst` inneholder strengen
  `"Antall timer:"`. Det er slik timebaserte perioder skjermes mot å bli
  overskrevet av prosentberegningen.

## Beregning fra timer

Dialogen `w_praksistimeberegning`
(`ws_objects/fsb10c.pbl.src/w_praksistimeberegning.srw`), tittel «Omgjøring
fra time- til månedsverk». Felter: praksisperiode fra/til, «Antall timer»,
«Antall timer pr måned».

```
ant_maned = truncate( ant_timer / timer_pr_maaned, 1 )
```

- **«Antall timer pr måned» skrives inn av saksbehandleren selv.** Det finnes
  ingen systemkonstant. Verdien lagres i brukerprofilen som
  `PRAKSIS_MNDTIME` (kategori `XRAPPORT`) og forhåndsfylles neste gang samme
  bruker åpner dialogen (`w_praksistimeberegning.srw`, `open`/`close`).
- Validering: både antall timer og timer pr måned må oppgis, og timer pr
  måned må være større enn 0.
- Ved «Bruk» (`w_spesiellsoknad.srw:3256-3281`) skrives resultatet tilbake på
  raden: `dato_fra`, `dato_til`, `tall_varighet = ant_maned`,
  `tidsenhet_varighet = 'MÅNEDER'`, og `merknadtekst` får påført
  `"Antall timer: <N>"`.

## Summering

Footeren i `dm_person_personpraksis`
(`ws_objects/fsb10.pbl.src/dm_person_personpraksis.srd`) har to beregnede
felt:

```
compute_1:  'Sum relevant praksis: ' + sum( If(status_relevant = 'J', tall_varighet, 0) for all )
compute_2:  'Sum totalt: '           + sum( tall_varighet for all )
```

Begge i **måneder**. Ingen omregning til år noe sted.

Merk at det summeres over *alle* rader i datavinduet, uavhengig av
praksistype, søknad eller opptak.

## Overlappende perioder

`wf_praksisvarsel()`, `w_spesiellsoknad.srw:541-795`. Kalles etter hver
endring av dato eller prosent, og fra `ue_insertrow`-flyten
(`w_spesiellsoknad.srw:1973`).

1. Tidslinjen deles opp i sammenhengende delperioder ut fra alle registrerte
   fra- og til-datoer.
2. For hver delperiode summeres `prosenttall_av_heltid` for alle rader som
   overlapper delperioden.
3. Er summen **over 100**, settes `varsel = 1` på hver rad som overlapper
   delperioden.

Tomme datoer erstattes i beregningen: `dato_fra` med 01.01.1900, `dato_til`
med 01.01.2200.

**Varigheten justeres ikke.** Overlappende perioder telles i sin helhet i
begge summene — systemet varsler, men korrigerer ikke. To samtidige
50 %-stillinger gir ikke varsel (sum = 100). To samtidige 60 %-stillinger
gir varsel, og teller som 120 % i summen.

## Kobling til kravelement: finnes ikke

Det er **ingen kode** som knytter praksisperioder eller summene til
`kravelementkode`, `status_bestatt`, `vurderingsstatuskode` eller
søknadsalternativ. Praksis-fanen og Fagprofil-fanen i `w_spesiellsoknad` er
uavhengige datavinduer i samme vindu. Saksbehandleren leser footer-summen og
setter `status_bestatt` manuelt på Fagprofil-fanen.

Dette er verifisert ved å søke etter felles forekomster av `kravelement` og
`personpraksis` i hele kodebasen; `w_spesiellsoknad.srw` er den eneste
kildefilen som nevner begge, og der er de i separate faner uten kobling.

### Konsekvens for løsningsforslaget

Løsningsforslaget (Confluence PFS 4996071435) beskriver dagens FS slik:

> «Så regner FS ut hvor mange års praksis det tilsvarer til sammen og sjekker
> om søker oppfyller opptakskravet eller opptakskravene som krever praksis.»

To feil i den setningen:

1. FS regner i **måneder**, ikke år.
2. FS **sjekker ikke** om søkeren oppfyller opptakskravet. Det gjør
   saksbehandleren.

Automatisk godkjenning av kravelement er derfor **ny funksjonalitet**, ikke en
videreføring. Det flytter `@OPT-BEH-PRA-002` fra «erstatte det som finnes» til
«bygge noe nytt», med tilhørende behov for avklaring.

## Hva som ikke er undersøkt

- Om det finnes beregningslogikk i databasen (triggere, pakker, views).
  `fs-klient` er klienten; databasekoden ligger et annet sted.
- `dm_e_studieprogm_praksiskrag` (`ws_objects/fsb20.pbl.src/`) holder
  praksiskrav per studieprogram i **`tall_uker`**. Det gjelder studiepraksis i
  et utdanningsløp, ikke opptakskrav, og er ikke koblet til
  `PERSONPRAKSIS`. Bør likevel sjekkes før man velger enhet i ny løsning —
  FS bruker i dag tre enheter for praksis: måneder, uker og timer.
- EVU-modulens praksisbehandling (`fsb42`,
  `f_oppdater_deltakerpraksis.srf`) er en egen mekanisme for
  kursdeltakelse. Jira DIN-523 gjelder den, ikke denne.
