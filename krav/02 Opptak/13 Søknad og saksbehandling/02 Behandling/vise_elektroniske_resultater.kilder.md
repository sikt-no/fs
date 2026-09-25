# Kilder for elektroniske resultater

Sidecar til [`vise_elektroniske_resultater.feature`](vise_elektroniske_resultater.feature) (`@OPT-BEH-BEH-005`, #613).

Kravet er skrevet kildeuavhengig: det sier hva saksbehandleren skal se, ikke hvor opplysningene hentes fra. Dette dokumentet holder kartleggingen av kilder, slik at kravet ikke binder et implementasjonsvalg som ikke er tatt.

**Oppdater dette dokumentet når kildevalget tas — ikke kravet.** Endrer et felt seg fra «må hentes» til «tilgjengelig», er det en endring her, ikke i `.feature`-filen.

Sist oppdatert 25.09.2026.

## Kildevalget er ikke tatt

Tre kilder kan levere deler av grunnlaget:

| Kilde | Dekker | Merknad |
|---|---|---|
| **KREG** (kompetansebevis) | Videregående opplæring | Rik på VGS-spesifikke opplysninger. Kan brukes direkte, eller indirekte via ELMO. |
| **ELMO** fra Vitnemålsportalen | Alt personen har | Felles, standardisert modell. Eneste kilde for læresteder som ikke bruker FS. |
| **SIS-subgrafen** | Høyere utdanning og fagskole | Dekker mesteparten av det FS-læresteder har. En rest må uansett hentes fra ELMO. |

Åpne valg:

- **VG-vitnemål: direkte fra KREG, eller fra KREG via ELMO?** Ikke besluttet.
- **Høyere utdanning og fagskole: SIS-subgrafen eller ELMO?** SIS dekker mesteparten; læresteder utenfor FS må komme fra ELMO uansett. Trolig en kombinasjon.
- **Øvrig dokumentasjon: hvilken kilde?** Ikke kjent. Se *Åpne spørsmål* nederst.

## Feltdekning

Kolonnene sier hva som er **verifisert tilgjengelig** i kilden, ikke hva som er valgt. `?` betyr ikke undersøkt.

### Vitnemål, felles felter

| Felt i kravet | ELMO | KREG | SIS |
|---|---|---|---|
| Tittel | ✓ | ✓ | ? |
| Omfang | ✓ | ✓ | ? |
| Utstedelsesdato | ✓ i modellen | ✓ | ? |
| Status | — | ✓ | ? |

Utstedelsesdato finnes i ELMO-modellen for alle vitnemål, men hentes i dag bare for videregående i Min kompetanse. Det er en utelatelse i spørringen, ikke en mangel i kilden.

### Vitnemål fra fagskole og høyere utdanning

| Felt i kravet | ELMO | KREG | SIS |
|---|---|---|---|
| Studieprogram | ✓ | n/a | ? |

Fagskole leses inn og lagres i ELMO-løypa, men vises ikke i Min kompetanse i dag — spørringen ber bare om videregående og høyere utdanning. Feltene for fagskole er derfor ikke verifisert i praksis.

### Vitnemål fra videregående skole

| Felt i kravet | ELMO | KREG |
|---|---|---|
| Vitnemålsnummer | ✓ | ? |
| Førstegangsvitnemål | ✓ | ✓ |
| Påstand om GSK | ✓ | ✓ |
| Orden | ✓ | ? |
| Atferd | ✓ | ? |
| Merknader på vitnemålet | ✓ | ✓ |
| Reform | — | ✓ |
| Dispensasjon | — | ✓ |

Reform og dispensasjon finnes bare i KREG. Velges ELMO som eneste kilde for VGS, må disse to hentes ved siden av — eller kravet må endres, som er en produktbeslutning.

### Fag på vitnemålet

| Felt i kravet | ELMO | KREG |
|---|---|---|
| Fagkode | ✓ | ✓ |
| Fagnavn | ✓ | ✓ |
| Omfang | ✓ | ✓ |
| År | ✓ | ✓ |
| Standpunktkarakter | ✓ | ✓ |
| Eksamenskarakter med eksamensform | ✓ | ✓ |
| Fagstatus | — | ✓ |
| Merknader | ✓ | ✓ |

Seks av åtte er verifisert tilgjengelig fra ELMO i dag. Fagstatus finnes bare i KREG.

### Enkeltemne

| Felt i kravet | ELMO | SIS |
|---|---|---|
| Emnekode | ✓ | ? |
| Tittel | ✓ | ? |
| Omfang | ✓ | ? |
| Termin | ✓ | ? |
| Karakter | ✓ | ? |
| Karakterskala | ✓ i modellen | ? |
| Beskrivelse | ✓ | ? |

Karakterskalaen finnes i ELMO-modellen som «ordning» på resultatet, men Min kompetanse henter den ikke for enkeltemner — bare for eksamensresultater på VGS-fag.

## Verifisert mot Min kompetanse 24.09.2026

Min kompetanse (`gitlab.sikt.no:fs/min-kompetanse`, Next.js) viser de samme resultatene til søkeren selv. Gjennomgangen av `src/app/[locale]/resultater/` ga:

- Hele siden henter fra **personens egen siste innhentingsbestilling**, med to filtrerte snitt: høyere utdanning og videregående. Ingen andre nivåer spørres om.
- To helt separate komponenttrær med ulike feltsett — det finnes ikke én felles resultatvisning å gjenbruke.
- Høyere utdanning vises først, fordi innlesingen sorterer på nivå med høyeste først. Kravet avviker bevisst og setter videregående øverst.
- Innenfor et nivå: én gruppe per studiested, vitnemål før enkeltemner. Kravet følger dette.
- `karakterfordeling` finnes i modellen men hentes ikke. Kravet har besluttet at den ikke skal vises.

### Innlesingen kaster ingenting

ELMO-dokumentet inneholder alt en person har. Ved innlesing bøttes det på **(utdanningsnivå × institusjon)**, der nivået utledes fra EQF-nivået i dokumentet:

| EQF | Nivå |
|---|---|
| 6 og over | Høyere utdanning (master og doktorgrad havner her) |
| 5 | Fagskole |
| 4 | Videregående |
| 1–3 | Grunnskole |
| ellers, eller manglende | Ukjent |

Konsekvens: at fagskole, grunnskole og ukjent nivå ikke vises i Min kompetanse er et spørsmål om hva løsningen spør om, ikke om hva som finnes. Dataen er sannsynligvis allerede lagret.

## Inngangspunktet finnes ikke

Dette er den største terskelen, og den handler ikke om felter.

- Min kompetanse henter resultatene fra personens **egen** bestilling. Det finnes ingen inngang som gir resultatene for en oppgitt person.
- Opptak har autorisasjonen på plass: spørringen som henter vitnemål for en gitt søker krever `SE_SØKNADSBEHANDLING`. Men den leverer ELMO-dokumentet uparsert.

Kravet kan ikke innfris før en person-scoped inngang finnes, uavhengig av hvilken kilde som velges.

## Åpne spørsmål

- **Hvilken kilde leverer øvrig dokumentasjon?** Norskkurs og godkjenning av utenlandsk utdanning er ikke funnet modellert noe sted. Hypotesen er at de kommer i ELMO-dokumentet og havner på ukjent nivå, siden innlesingen ikke kaster noe. Ikke verifisert — ingen har spurt om de nivåene. **Avgjøres ved å spørre om fagskole, grunnskole og ukjent nivå for en testperson.**
- **Skal underliggende dokumenter kunne åpnes?** Et resultat kan ha flere — en oppnådd grad og en godkjenning av utenlandsk utdanning kommer ofte med to hver. Merket `@openquestion` i kravet.
- **Feltene for fagskolevitnemål er ikke verifisert.** Antatt samme form som høyere utdanning.

## Bakgrunn i FS-klienten

Kravet erstatter oversiktsdelen av vitnemålsbehandlingen i FS-klienten (bilde FS143.001 Vg.dokument, `gitlab.sikt.no/fs/fs-klient`).

- Annullerte vitnemål vises der i lista uten å skjules. Kravet er strammere: det skjuler raden når resultatet ikke har vært i bruk i dette opptaket.
- Forbedrede karakterer vises som kolonneparet «Opprinnelig / Forbedret». Kravet viderefører det.
- Tilordning av saksbehandler er ikke en tilgangsgrense i ny stack: ingen tjeneste i tjenestelaget sjekker tilordnet bruker før en endring.

## Funn som hører andre steder

Kartlagt 24.–25.09.2026 under arbeidet med kravet. Ingen av punktene er krav i denne fila; de er notert her fordi de kom fram i samme gjennomgang og ellers ville gått tapt.

### Ser ut som feil i eksisterende løsning

**`er_kvalifisert` reberegnes ikke når et vitnemål annulleres.** `GskVedtakTilbakekallingService` setter GSK-vedtaket til `KVALIFISERT_MEN_ANNULLERT`, men kaller ikke propageringen. Javadoc-en sier det selv: *«Er søkeren under aktiv automatisk saksbehandling, reberegnes kvalifiseringen ved neste `propagerFraGrunnlag`-kall; ellers står den gjeldende kvalifiseringen inntil saken behandles på nytt.»* En sak som ikke er under aktiv behandling kan altså stå som kvalifisert på et annullert vitnemål.

**Annullering oppdages ikke for søkere som søker én gang.** `HentVgsVitnemaalService` kalles fra ett sted i produksjonskoden: `SoknadshendelseJobb`, ved tildeling. Det finnes ingen GraphQL-mutasjon for å hente vitnemål. Tilbakekallingsmekanismen utløses bare av en ny henting, og ny henting skjer bare når søkeren får en ny søknad tildelt. Søker personen én gang, blir en senere annullering aldri oppdaget.

**Et rettet vitnemål plukkes aldri opp.** `VgsLagringService` returnerer `FANTES_FRA_FOER` for et vitnemål som allerede er lagret, og oppdaterer kun annullert-flagget. Får et forbedret resultat et nytt vitnemålsnummer, lagres det som nytt og fanges. Rettes et eksisterende vitnemål i seg selv, ignoreres endringen permanent. Hvilket av tilfellene som er vanlig i KREG er ikke avklart.

Dette siste er forutsetningen bak scenarioet «Be om ny innhenting»: kravet forutsetter at en ny innhenting faktisk oppdaterer, noe dagens lagring ikke gjør.

### Åpne beslutninger

**Beslutningsgrunnlag som versjonert objekt.** Endringsloggen (rad-audit med full `row_data`, `changed_fields`, tidsstempel, bruker, `intensjon`, `trace_id`) er påskrudd på 46 tabeller. Ingen av dem er i `kompetanse`-skjemaet. Linja går konsekvent mellom søkerens sak og beslutningene på den, som auditeres, og referanse- og innhentede data, som ikke gjør det.

Konsekvensen er at `kompetanse.vgs_dokument` er *modellert* som referansedata, men *brukes* som beslutningsgrunnlag. Insert-once-designet bygger bro ved å la raden oppføre seg som et øyeblikksbilde, men det er en implisitt kontrakt — og annullert-flagget bryter den allerede.

Å flytte `kompetanse` over linja er teknisk billig (`audit_table`-kall). Det dyre er datamengden og å bestemme hva historikken skal brukes til.

**Ettersendingsfristen som skjæringspunkt.** Ingenting kobler fristen til dataens gyldighet: ingen ny innhenting ved fristen, og ingen «grunnlaget slik det var ved fristen».

Konsekvensen av en dataendring avhenger dessuten av hvilken port som er passert — søknadsfrist, ettersendingsfrist, rangering, tilbud sendt, tilbud akseptert, studiestart. Et annullert vitnemål før rangering er en reberegning; det samme vitnemålet etter akseptert tilbud er en tilbaketrekking av studieplass, med egne krav til forhåndsvarsel og klagerett.

### To spørsmål som ikke er tekniske

Disse bør besvares av noen med myndighet, ikke designes rundt:

1. **Er ettersendingsfristen en frist for søkeren eller for systemet?** Er kilden nede gjennom hele fristvinduet, hvem bærer risikoen? Søkeren har gjort alt riktig; løsningen fikk ikke lest det. Svaret avgjør om mellomlagring er en bekvemmelighet eller en rettssikkerhetsgaranti.

2. **Kan et vedtak stå på et grunnlag som senere viste seg feil?** Forvaltningsrettslig ofte ja — vedtaket var riktig på tidspunktet. Men det forutsetter at man kan *vise* hva som var kjent, og uten versjonert grunnlag kan man ikke det.
