# Utkast til Jira: Forberede plasstildeling

Utkast 2026-10-28, skrevet om 2026-11-02 etter gjennomgangen av prototypen v88 ([PR #907](https://github.com/sikt-no/fs/pull/907)), oppdatert 2026-11-03: rundetypene forvaltes ikke i første leveranse, og 2026-11-04 mot sakene i TAKE og beslutningene i teamet. Ikke opprettet eller endret i Jira ennå. Kravene for runder og rundetyper er `@in-progress`, og antall tilbud er `@draft`. Lenkene går til `main` (kravene kommer dit når PR #907 er merget).

Forvaltning av rundetyper (`@OPT-REG-RUN-002`, Could) er ikke med: ingen kan legge til, endre eller slette rundetyper i regelverkssamlingen. Plasstildelingen bruker de tre rundetypene som finnes. Varsling av lærestedene og markering av gjennomgang (`@OPT-PLA-INN-004`, Could) og kontrollen av antall tilbud (`@OPT-PLA-INN-003`, Should) er heller ikke med.

## Sakene i Jira nå (TAKE, hentet 2026-11-04)

| Sak | I Jira nå | I utkastet |
|---|---|---|
| [TAKE-3](https://sikt.atlassian.net/browse/TAKE-3) | Epic «Ferdigstilling av plasstildeling i opptak», In progress, med alle plasstildelingssakene | Beholdes. Leveransedelene legges under den som stories (besluttet i teamet 2026-11-04) |
| [TAKE-484](https://sikt.atlassian.net/browse/TAKE-484) | Story «Attributter på rundetype», To Do, uten epic og bare med et bilde. Sub-task [TAKE-485](https://sikt.atlassian.net/browse/TAKE-485) «BE: flyway og støtte i grafen for nye felter» | Brukes for innstillingene på rundetypene (`@OPT-REG-RUN-001`). Flyttes til TAKE-3 og får beskrivelse og akseptansekriterier |
| [TAKE-327](https://sikt.atlassian.net/browse/TAKE-327) | Story «Beregne antall tilbud per utdanningskvote fra relativ fordeling», Backlog | Skrives om til «Lærestedet setter antall tilbud som skal gis per utdanningskvote» |
| [TAKE-450](https://sikt.atlassian.net/browse/TAKE-450) | Task «Fjerne sette antall tilbud som skal gis» (opptaksinnstillingen), Won't do, under [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) | Ingen endring. Feltet er fjernet fra opptaksinnstillingene, og hører ikke med i TAKE-327 |
| TAKE-74, 156, 159, 165, 265, 267, 268, 278, 288, 328, 329, 330 og 331 | Under TAKE-3, Backlog | Blir under TAKE-3 |
| – | Ingen story for runder eller oversikten over runder | Ny story «Opprette plasstildelingsrunder» under TAKE-3 |
| – | Ingen sak for feilen der redigering nullstiller publiseringen og perioden | Ny bug under TAKE-3 |

### Avklart med teamet (2026-11-04)

- TAKE-3 beholdes som epic for hele plasstildelingen, og leveransedelene legges under den som stories. Det lages ingen ny epic.
- Feltet for antall tilbud som skal gis er fjernet fra opptaksinnstillingene, og trenger ikke stå i TAKE-327.
- Taket for antall tilbud per søker er antall tilbud søkeren kan få i runden, og hører til plasstildelingsrunden. Det er ikke det samme som maks antall søknadsalternativer, som hører til opptaket (`innstillinger.feature`). I koden ligger taket på opptaket (`maks_antall_tilbud`, «maksimalt antall tilbud som kan gis i dette opptaket»), og regelen i `innstillinger.feature` er `@deprecated`. Å flytte taket til runden hører til storyen «Opprette plasstildelingsrunder».
- Bildet i TAKE-484 viser de samme innstillingene som `@OPT-REG-RUN-001`. TAKE-484 gjelder bare innstillingene på rundetypen. Svarfrist, periode, tak og ledige studieplasser på runden hører til storyen «Opprette plasstildelingsrunder», og antall tilbud som skal gis til TAKE-327.

## Epic (TAKE-3, beholdes): Ferdigstilling av plasstildeling i opptak

Tittelen beholdes. Beskrivelsen byttes med teksten under. Epicen er den eneste for plasstildelingen, og leveransedelene legges under den som stories (besluttet i teamet 2026-11-04). Utkastene for de to andre leveransedelene står i [jira-utkast-gjennomfore-plasstildeling.md](jira-utkast-gjennomfore-plasstildeling.md) og [jira-utkast-publisere-og-svare-pa-tilbud.md](jira-utkast-publisere-og-svare-pa-tilbud.md).

> **Beskrivelse til TAKE-3:**
>
> Plasstildelingen i FS Opptak gjøres ferdig til første samordna opptak 2027 (produksjonsfrist 8. desember 2026). Opptaksforvalter legger til plasstildelingsrundene, lærestedene setter antall tilbud som skal gis, plasstildelingen gjennomføres etter innstillingene i runden, og resultatet publiseres til søkerne, som svarer på tilbud og ventelisteplass.
>
> **Hvor kravene bor**
>
> - Scopet: [plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/scope.md) — mål, avgrensning og alle kravene, med hvilken sak hvert krav hører til.
> - Kravene: [krav/02 Opptak/14 Plasstildeling](https://github.com/sikt-no/fs/tree/main/krav/02%20Opptak/14%20Plasstildeling) og rundetypene i [10 Regelverk/06 Rundetyper](https://github.com/sikt-no/fs/tree/main/krav/02%20Opptak/10%20Regelverk/06%20Rundetyper). Lesbare i [FS Kravforvaltning](https://sikt-no.github.io/fs/).
> - Spesifikasjonene: [tasks/opptak/plasstildeling-2027/spec](https://github.com/sikt-no/fs/tree/main/tasks/opptak/plasstildeling-2027/spec).
>
> **Leveransedeler i scopet** (i denne rekkefølgen, som stories under epicen)
>
> 1. **Forberede plasstildelingen:** rundetypene med innstillinger (TAKE-484), plasstildelingsrundene med oversikt (ny story), og antall tilbud som skal gis per utdanningskvote (TAKE-327). Spesifisert: [spec-rundetyper-og-plasstildelingsrunder.md](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/spec/spec-rundetyper-og-plasstildelingsrunder.md).
> 2. **Gjennomføre plasstildelingen:** kjøringen etter innstillingene i runden, plassflyt, kompensasjonstilbud (TAKE-328), tilbudsgaranti og resultatet før publisering, med de tekniske sakene om kjøringen (TAKE-74, TAKE-159, TAKE-165, TAKE-265, TAKE-267, TAKE-278).
> 3. **Publisere resultatet og svare på tilbud:** publisering (TAKE-330), ventelistenummeret (TAKE-288), det publiserte resultatet (TAKE-329) og svar fra søker (TAKE-331), med TAKE-156 og TAKE-268.
>
> **Ikke med:** forvaltning av rundetyper, vedtaksformidling (eget scope senere), og standard plassflyt og kvoteprioritet, som settes i regelverkssamlingen (scope [kvoter-i-opptaket-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/kvoter-i-opptaket-2027/scope.md)).

---

## Story (TAKE-484, utvides): Innstillinger på rundetypene

Ny beskrivelse og akseptansekriterier. Flyttes til TAKE-3. Sub-tasken TAKE-485 (backend) beholdes.

Rundetypene hovedtildeling, supplering og etterfylling får de faste innstillingene plasstildelingen leser. Rundetypene er felles for alle opptak, og er ikke en del av regelverkssamlingen. I dag er rundetypene et kodeverk uten innstillinger.

Akseptansekriterier:

- Hovedtildeling, supplering og etterfylling har innstillingene bortfall på lavere prioriteter, kompensasjonstilbud ved opprykk, bygger på forrige publiserte runde, bare én i opptaket og kan åpnes for ledige studieplasser, med verdiene i kravet (`@OPT-REG-RUN-001`)
- Rundetypene er felles for alle opptak. TIDLIG, LEDIGE_STUDIEPLASSER og TEST i kodeverket er ikke rundetyper i kravet
- Innstillingene kan ikke endres i løsningen. Forvaltning av rundetyper (`@OPT-REG-RUN-002`) er ikke med

Krav: [bruke_rundetyper.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature)

## Story: Opprette plasstildelingsrunder

Opptaksforvalter legger til plasstildelingsrunder i opptaket av rundetypene hovedtildeling, supplering og etterfylling, og setter innstillingene som hører til runden: svarfrist, tak for antall tilbud per søker, ledige studieplasser og perioden for lærestedene. Runden får de faste innstillingene fra rundetypen. I dag kan bare hovedrunde velges i fs-admin, og taket for antall tilbud per søker ligger på opptaket (`maks_antall_tilbud`). Bygger på TAKE-484 (innstillingene på rundetypene).

Ikke med: å legge til, endre eller slette rundetyper (`@OPT-REG-RUN-002`, Could).

Akseptansekriterier:

- Opptaksforvalter legger til en runde med navn, rundetype og svarfrist (`@OPT-PLA-RUN-001`). Opptaket kan bare ha én hovedtildeling, og supplering og etterfylling kan ikke være den første runden
- Navnet på runden er unikt i opptaket, uten hensyn til store og små bokstaver, og er høyst 100 tegn
- Runden har innstillingene fra rundetypen, og opptaksforvalter ser dem, men kan ikke endre dem på runden. Rundetypen kan ikke endres etter at runden er lagt til
- Navn og svarfrist kan alltid endres, og en runde kan slettes så lenge den ikke er publisert til søker
- Taket for antall tilbud per søker flyttes fra opptaket til runden. Maks antall søknadsalternativer blir på opptaket
- Taket for antall tilbud per søker har en standardverdi per rundetype når runden legges til, og opptaksforvalter kan endre det. I samordna opptak: 1 i hovedtildeling og supplering, 10 i etterfylling
- Opptaksforvalter kan åpne runden for ledige studieplasser når opptaket tilbyr søknad på ledige studieplasser. Runden får da tak for antall tilbud på ledige studieplasser per søker, med standardverdien 10, og opptaksforvalter kan endre det. Tilbudene på ledige studieplasser kommer i tillegg til de ordinære tilbudene
- Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud (dato og klokkeslett, kan alltid endres). Svarfristen må komme etter at perioden er slutt
- Lærestedet ser alle rundene og hva det skal gjøre i hver, men kan bare åpne runden der perioden er åpen
- Oversikten over rundene viser navn, rundetype, perioden for lærestedene, svarfristen for søkerne, om runden er publisert og om lærestedet har en oppgave. Rundene kan søkes etter på navn, filtreres på rundetype, status og periode, og sorteres på svarfrist (tidligste først som standard), status og periode, 50 om gangen (`@OPT-PLA-RUN-002`)
- Opptakets forvalter kan velge flere runder i oversikten og slette dem samtidig. Publiserte runder slettes ikke, og lærestedet kan ikke slette runder

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [listevisning_og_søk_i_plasstildelingsrunder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/listevisning_og_s%C3%B8k_i_plasstildelingsrunder.feature)

Spesifikasjon: [spec-rundetyper-og-plasstildelingsrunder.md](https://github.com/sikt-no/fs/blob/main/tasks/opptak/plasstildeling-2027/spec/spec-rundetyper-og-plasstildelingsrunder.md), med implementasjonsdetaljene og tekstene i `forvalte_runder.design.md` og `listevisning_og_søk_i_plasstildelingsrunder.design.md`.

## Story (TAKE-327, skrives om): Lærestedet setter antall tilbud som skal gis per utdanningskvote

Ny tittel og beskrivelse. Fordelingen i prosent er forkastet. Feltet i opptaksinnstillingene er allerede fjernet (TAKE-450).

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
