# Utkast til Jira: Forberede plasstildeling

Utkast 2026-10-28, skrevet om 2026-11-02 etter gjennomgangen av prototypen v88 ([PR #907](https://github.com/sikt-no/fs/pull/907)). Ikke opprettet eller endret i Jira ennå. Kravene er `@draft`, og lenkene går til `main` (kravene kommer dit når PR #907 er merget).

Forvaltning av rundetyper (`@OPT-REG-RUN-002`, Could) er ikke med. Varsling av lærestedene og markering av gjennomgang (`@OPT-PLA-INN-004`, Could) og kontrollen av antall tilbud (`@OPT-PLA-INN-003`, Should) er heller ikke med.

## Epic (TAKE-3, skrives om): Forberede plasstildeling

Opptaksforvalter legger til plasstildelingsrundene i opptaket, med rundetypene og innstillingene fra regelverkssamlingen. Lærestedene setter antall tilbud som skal gis per utdanningskvote i runden, og ser opplysningene de trenger for å sette tallene. Første leveranse i plasstildelingen: det plasstildelingen leser.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/scope.md)

## Ny epic: Gjennomføre og publisere plasstildeling

Starte og gjennomføre plasstildelingen etter innstillingene i runden, se resultatet før det publiseres, publisere resultatet til søkerne og håndtere svarene. Oppgavene «Gjennomføre plasstildelingen» og «Publisere resultatet og svare på tilbud» i scopet. Bygger på «Forberede plasstildeling».

Flyttes hit fra TAKE-3: TAKE-328, TAKE-329, TAKE-330, TAKE-331, TAKE-265, TAKE-267, TAKE-268, TAKE-278, TAKE-288, TAKE-74, TAKE-156, TAKE-159 og TAKE-165.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/scope.md)

---

## Story: Opprette plasstildelingsrunder med rundetyper og innstillinger

Opptaksforvalter legger til runder av rundetypene i regelverkssamlingen (hovedtildeling, supplering og etterfylling i samordna opptak), og runden får innstillingene fra rundetypen. I dag kan bare hovedrunde velges i fs-admin, og rundetypene er et fast kodeverk uten innstillinger.

Akseptansekriterier:

- Regelverkssamlingene for samordna opptak har rundetypene hovedtildeling, supplering og etterfylling, med innstillingene plasstildelingen leser (`@OPT-REG-RUN-001`)
- Opptaksforvalter legger til en runde med navn, rundetype og svarfrist, og rundetypene i regelverkssamlingen avgjør hvilke runder opptaket kan ha (`@OPT-PLA-RUN-001`)
- Runden har innstillingene fra rundetypen, og de kan ikke endres på runden. Rundetypen kan ikke endres etter at runden er lagt til
- Navn og svarfrist kan alltid endres, og en runde kan slettes så lenge den ikke er publisert til søker
- Opptaksforvalter setter tak for antall tilbud per søker i runden, som vises og kan endres. I samordna opptak: 1 i hovedtildeling og supplering, opptil 10 i etterfylling
- Opptaksforvalter kan åpne runden for ledige studieplasser, og setter da tak for antall tilbud på ledige studieplasser per søker (opptil 10 i supplering og etterfylling i samordna opptak, i tillegg til de ordinære tilbudene)
- Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud (dato og klokkeslett, kan alltid endres). Svarfristen må komme etter at perioden er slutt
- Lærestedet ser alle rundene og hva det skal gjøre i hver, men kan bare åpne runden der perioden er åpen

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [bruke_rundetyper.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature)

## Story (TAKE-327, skrives om): Lærestedet setter antall tilbud som skal gis per utdanningskvote

Ny tittel og beskrivelse. Fordelingen i prosent er forkastet.

Lærestedet setter antall tilbud som skal gis per utdanningskvote, eller at utdanningstilbudet gir tilbud til alle kvalifiserte, innenfor perioden på runden. Lærestedet ser opplysningene det trenger for å sette tallene. Opptakets forvalter kan endre tallene også utenfor perioden. I dag settes ett tall for hele opptaket, og perioden håndheves ikke.

Akseptansekriterier:

- Lærestedet setter antall tilbud som skal gis per utdanningskvote, og totalt antall tilbud for utdanningstilbudet er summen (`@OPT-PLA-INN-001`)
- Tallene er fylt ut med kvoteplassene, og lærestedet bekrefter eller endrer dem. En utdanningskvote der tallet er fjernet, gir ingen tilbud
- Et utdanningstilbud kan gi tilbud til alle kvalifiserte i stedet for tall i utdanningskvotene
- Per utdanningskvote ser lærestedet kvoteplassene, antall tilbud som skal gis og overbookingen (antall tilbud minus kvoteplassene)
- Per utdanningstilbud, og summert for utdanningstilbudene lærestedet tilbyr, ser lærestedet planlagte studieplasser, ledige plasser å gi tilbud til og totalt antall tilbud som skal gis
- Ledige plasser å gi tilbud til trekker fra søkere med tilbudsgaranti som ikke har fått tilbud
- Lærestedet kan bare endre tallene innenfor perioden på runden. Opptakets forvalter kan alltid endre dem, og siste lagrede tall gjelder
- Tallene kan ikke endres når runden er publisert, og kan ikke settes før opptaket har en runde
- Utdanningstilbudene kan filtreres på om antall tilbud er satt i alle utdanningskvotene

Krav: [antall_tilbud_som_skal_gis.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature)

## Bug: Redigering av en runde nullstiller publiseringen og perioden

Når opptaksforvalter endrer navn eller svarfrist på en runde i fs-admin, blir publiseringstidspunktet og perioden for antall tilbud satt til tomt. På en publisert runde mister søkerne svaret og kan ikke svare, og runden kan publiseres på nytt.

Forventet: Navn og svarfrist kan alltid endres (`@OPT-PLA-RUN-001`), og søkeren ser den nye svarfristen (`@OPT-PLA-SVA-001`). Publiseringen og perioden endres ikke.

Kode: `fs-admin/…/RedigerRundeForm/RedigerRundeForm.tsx:118-124` sender ikke feltene, og `fs-plattform/…/opptak/OpptaksrundeMutations.java:103-115` setter dem fra input. Gjelder også utkast-branchen. Rettet på branchen `maciek/plasstildeling-feat-runder-oversikt`.

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [håndtere_svar_fra_søker.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)
