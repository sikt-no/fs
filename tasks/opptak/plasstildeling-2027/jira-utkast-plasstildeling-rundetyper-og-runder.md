# Utkast til Jira: Forberede plasstildeling

Utkast 2026-10-28, skrevet om 2026-11-02 etter gjennomgangen av prototypen v88 ([PR #907](https://github.com/sikt-no/fs/pull/907)), og oppdatert 2026-11-03: rundetypene forvaltes ikke i første leveranse. Ikke opprettet eller endret i Jira ennå. Kravene er `@draft`, og lenkene går til `main` (kravene kommer dit når PR #907 er merget).

Forvaltning av rundetyper (`@OPT-REG-RUN-002`, Could) er ikke med: ingen kan legge til, endre eller slette rundetyper i regelverkssamlingen. Plasstildelingen bruker de tre rundetypene som finnes. Varsling av lærestedene og markering av gjennomgang (`@OPT-PLA-INN-004`, Could) og kontrollen av antall tilbud (`@OPT-PLA-INN-003`, Should) er heller ikke med.

## Epic (TAKE-3, skrives om): Forberede plasstildeling

Opptaksforvalter legger til plasstildelingsrundene i opptaket, av rundetypene hovedtildeling, supplering og etterfylling, og runden får innstillingene fra rundetypen. Lærestedene setter antall tilbud som skal gis per utdanningskvote i runden, og ser opplysningene de trenger for å sette tallene. Første leveranse i plasstildelingen: det plasstildelingen leser.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/scope.md)

## Ny epic: Gjennomføre og publisere plasstildeling

Starte og gjennomføre plasstildelingen etter innstillingene i runden, se resultatet før det publiseres, publisere resultatet til søkerne og håndtere svarene. Oppgavene «Gjennomføre plasstildelingen» og «Publisere resultatet og svare på tilbud» i scopet. Bygger på «Forberede plasstildeling».

Flyttes hit fra TAKE-3: TAKE-328, TAKE-329, TAKE-330, TAKE-331, TAKE-265, TAKE-267, TAKE-268, TAKE-278, TAKE-288, TAKE-74, TAKE-156, TAKE-159 og TAKE-165.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/scope.md)

---

## Story: Opprette plasstildelingsrunder

Opptaksforvalter legger til plasstildelingsrunder i opptaket av rundetypene hovedtildeling, supplering og etterfylling, og setter innstillingene som hører til runden: svarfrist, tak for antall tilbud per søker, ledige studieplasser og perioden for lærestedene. Runden får de faste innstillingene fra rundetypen. I dag kan bare hovedrunde velges i fs-admin, og rundetypene er et fast kodeverk uten innstillinger.

Ikke med: å legge til, endre eller slette rundetyper (`@OPT-REG-RUN-002`, Could).

Akseptansekriterier:

- Rundetypene hovedtildeling, supplering og etterfylling finnes for samordna opptak (UHG og HYU), hver med faste innstillinger plasstildelingen leser: bortfall på lavere prioriteter, kompensasjonstilbud ved opprykk, bygger på forrige publiserte runde, bare én i opptaket og kan åpnes for ledige studieplasser (`@OPT-REG-RUN-001`)
- Opptaksforvalter legger til en runde med navn, rundetype og svarfrist (`@OPT-PLA-RUN-001`). Opptaket kan bare ha én hovedtildeling, og supplering og etterfylling kan ikke være den første runden
- Runden har innstillingene fra rundetypen, og opptaksforvalter ser dem, men kan ikke endre dem på runden. Rundetypen kan ikke endres etter at runden er lagt til
- Navn og svarfrist kan alltid endres, og en runde kan slettes så lenge den ikke er publisert til søker
- Taket for antall tilbud per søker har en standardverdi per rundetype når runden legges til, og opptaksforvalter kan endre det. I samordna opptak: 1 i hovedtildeling og supplering, 10 i etterfylling
- Opptaksforvalter kan åpne runden for ledige studieplasser når opptaket tilbyr søknad på ledige studieplasser. Runden får da tak for antall tilbud på ledige studieplasser per søker, med standardverdien 10, og opptaksforvalter kan endre det. Tilbudene på ledige studieplasser kommer i tillegg til de ordinære tilbudene
- Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud (dato og klokkeslett, kan alltid endres). Svarfristen må komme etter at perioden er slutt
- Lærestedet ser alle rundene og hva det skal gjøre i hver, men kan bare åpne runden der perioden er åpen
- Oversikten over rundene viser navn, rundetype, perioden for lærestedene, svarfristen for søkerne, om runden er publisert og om lærestedet har en oppgave. Rundene kan søkes etter på navn, filtreres på rundetype, status og periode, og sorteres på svarfrist (tidligste først som standard), status og periode, 50 om gangen (`@OPT-PLA-RUN-002`)

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [listevisning_og_søk_i_plasstildelingsrunder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/listevisning_og_s%C3%B8k_i_plasstildelingsrunder.feature) · [bruke_rundetyper.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature)

## Story (TAKE-327, skrives om): Lærestedet setter antall tilbud som skal gis per utdanningskvote

Ny tittel og beskrivelse. Fordelingen i prosent er forkastet.

Lærestedet setter antall tilbud som skal gis per utdanningskvote, eller at utdanningstilbudet gir tilbud til alle kvalifiserte, innenfor perioden på runden. Lærestedet ser opplysningene det trenger for å sette tallene. Opptakets forvalter kan endre tallene også utenfor perioden. I dag håndheves ikke perioden.

Ikke med: kontrollen av antall tilbud og varsel når tallet er høyere enn kvoteplassene (`@OPT-PLA-INN-003`, Should), varsling av lærestedene og markering av gjennomgang (`@OPT-PLA-INN-004`, Could), tilbudene som er gitt i tidligere runder (kommer med «Gjennomføre plasstildelingen»), og negative tall.

Akseptansekriterier:

- Lærestedet setter antall tilbud som skal gis per utdanningskvote, og totalt antall tilbud for utdanningstilbudet er summen (`@OPT-PLA-INN-001`)
- Antall tilbud som skal gis er et samlet tall for opptaket, og følger med til neste runde. En runde gir det som gjenstår etter tilbudene som er gitt i tidligere runder
- Tallene er fylt ut med kvoteplassene, og lærestedet bekrefter eller endrer dem. En utdanningskvote der tallet er fjernet, gir ingen tilbud
- Et utdanningstilbud kan gi tilbud til alle kvalifiserte i stedet for tall i utdanningskvotene
- Per utdanningskvote ser lærestedet kvoteplassene, antall tilbud som skal gis og overbookingen (antall tilbud minus kvoteplassene)
- Per utdanningstilbud, og summert for utdanningstilbudene lærestedet tilbyr, ser lærestedet planlagte studieplasser, ledige plasser å gi tilbud til og totalt antall tilbud som skal gis
- Ledige plasser å gi tilbud til trekker fra søkere med tilbudsgaranti som ikke har fått tilbud
- Lærestedet kan bare endre tallene innenfor perioden på runden, og ikke når perioden ikke er satt. Opptakets forvalter kan alltid endre dem, og siste lagrede tall gjelder
- Tallene kan ikke endres når runden er publisert, og kan ikke settes før opptaket har en runde
- Utdanningstilbudene kan filtreres på om antall tilbud er satt i alle utdanningskvotene

Krav: [antall_tilbud_som_skal_gis.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature)

## Bug: Redigering av en runde nullstiller publiseringen og perioden

Når opptaksforvalter endrer navn eller svarfrist på en runde i fs-admin, blir publiseringstidspunktet og perioden for antall tilbud satt til tomt. På en publisert runde mister søkerne svaret og kan ikke svare, og runden kan publiseres på nytt.

Forventet: Navn og svarfrist kan alltid endres (`@OPT-PLA-RUN-001`), og søkeren ser den nye svarfristen (`@OPT-PLA-SVA-001`). Publiseringen og perioden endres ikke.

Kode: `fs-admin/…/RedigerRundeForm/RedigerRundeForm.tsx:118-124` sender ikke feltene, og `fs-plattform/…/opptak/OpptaksrundeMutations.java:103-115` setter dem fra input. Gjelder også utkast-branchen. Rettet på branchen `maciek/plasstildeling-feat-runder-oversikt`.

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [håndtere_svar_fra_søker.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)
