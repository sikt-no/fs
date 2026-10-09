# Begrepsliste — Opptak

Siste oppdatering: 2026-10-09

Denne listen sammenstiller begreper brukt i kravene (`krav/02 Opptak/`), design-filene og begrepskatalogen på [fs.sikt.no](https://fs.sikt.no/domenekunnskap/begreper/). Målet er konsistent begrepsbruk på tvers av krav, kode, API og brukergrensesnitt.

**Leseforklaring:**
- **Begrep i krav** = begrep slik det brukes i `.feature`-filer under `krav/02 Opptak/`
- **Definisjon** = hva begrepet betyr. En definisjon i «anførselstegn» er hentet fra begrepskatalogen. De andre er arbeidsdefinisjoner, utledet fra kravene og avklaringene, og er forslag til begrepskatalogen
- **Begrepskatalog** = lenke til begrepet på [fs.sikt.no/domenekunnskap/begreper/](https://fs.sikt.no/domenekunnskap/begreper/), med status (aktiv eller utkast)
- **Gammel FS** = begrep fra fellesstudentsystem.no (nåværende FS-klient)
- ⚠️ = inkonsistens eller avvik mellom krav, begrepskatalog eller kode. Se også *Kravene som er rettet* og *Avvik i begrepskatalogen* nederst
- ✅ = avklart

## Aktører og organisasjoner

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| opptaksforvalter | Rollen som setter opp og forvalter et opptak: innstillinger, frister, runder, antall tilbud som skal gis og plasstildeling | – | – | Ny rolle i nytt opptak. Ikke i begrepskatalogen enda |
| opptaksforvalter ved forvaltende organisasjon | Opptaksforvalter i organisasjonen som eier opptaket. I samordna opptak HK-dir, i lokale opptak lærestedet selv | – | – | Spesifisering av opptaksforvalter |
| opptaksforvalter ved deltakende organisasjon | Opptaksforvalter ved et lærested som deltar i et opptak som en annen organisasjon forvalter. Setter opp egne utdanningstilbud, for eksempel antall tilbud som skal gis | – | – | Spesifisering av opptaksforvalter |
| opptakseier | Organisasjonen som oppretter og vedlikeholder (forvalter) et opptak. Opptakseieren har ansatte som er opptaksforvaltere | – | – | ✅ Avklart 2026-10-09. Samme organisasjon som «forvaltende organisasjon» |
| saksbehandler | Person som behandler søknader: vurderer dokumentasjon, setter grunnlag og regner ut poeng. Kvalitetssikrer også resultatet av plasstildelingen | – | Saksbehandler | Brukes generelt i kravene; bør presiseres |
| saksbehandlende organisasjon | Organisasjonen som har ansvaret for å saksbehandle et søknadsalternativ, og som får tilgang til saken. Søknaden blir til én sak hos hver saksbehandlende organisasjon | – | – | Ny term (`tildele_saksbehandlende_organisasjon.feature`). Ansvaret ligger hos organisasjonen, ikke hos en enkelt saksbehandler |
| tilbyder | Lærestedet som tilbyr utdanningstilbudet søknadsalternativet gjelder | – | – | Ny term (`tildele_saksbehandlende_organisasjon.feature`) |
| søker | «Person som søker utdanning, eller har levert søknad, i ett eller flere opptak» | [søker](https://fs.sikt.no/domenekunnskap/begreper/soker/) (utkast) | Søker | OK |

## Opptak og struktur

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| opptak | «Prosess som løper fra en søker leverer en søknad til søknad er behandlet og ferdig prosessert så det foreligger et svar til søker» | [opptak](https://fs.sikt.no/domenekunnskap/begreper/opptak/) (aktiv) | Opptak | OK. Sto som manglende i forrige versjon av lista, men finnes nå i katalogen |
| samordna opptak | Opptak der søkeren søker på utdanningstilbud ved flere læresteder i én søknad, forvaltet av HK-dir | – | NOM-opptak | ✅ Avklart: «samordna opptak» er riktig form (offisielt navn). Rettet i kravene 2026-10-09 |
| lokalt opptak | Opptak som et lærested forvalter selv, der lærestedet er den eneste organisasjonen | – | Lokalt opptak | OK |
| opptakstype | «Kategorisering av opptak med utdanningstilbud som har relativt like opptaksregler» | [opptakstype](https://fs.sikt.no/domenekunnskap/begreper/opptakstype/) | Opptakstype | OK |
| tidlig opptak | Tidlig behandling av og tilbud til søkere i et opptak. Søkerne får ikke tildelt studierett tidligere enn andre søkere av den grunn: det reelle opptaket til utdanningen er ikke gjennomført. Løses med tilbudsgaranti i rundene som kjøres, ikke som en egen runde | – | Tidligopptak | ✅ Avklart: «tidlig opptak» (to ord) er riktig. ✅ Avklart 2026-10-09: definisjonen, og at det ikke er en rundetype |
| forvaltende organisasjon | Organisasjonen som forvalter og eier opptaket, altså opptakseieren | – | – | Ny term. Se «opptakseier» |
| deltakende organisasjon | Organisasjon som deltar i et opptak som en annen organisasjon forvalter, med egne utdanningstilbud | – | – | ✅ Avklart: «deltakende» er riktig. Krav som bruker «deltagende» bør rettes |
| lærested | «Organisasjon som tilbyr utdanning» | [lærested](https://fs.sikt.no/domenekunnskap/begreper/larested/) (aktiv) | Institusjon / Lærested | OK |
| organisasjon | Generelt begrep for alle typer registrerte enheter | – | Institusjon | Nytt generelt begrep som erstatter «institusjon» (se `krav/README.md` terminologi) |
| hendelseslogg | Logg over endringer på opptaket og det som hører til det, med hvem (rolle og organisasjon), hva, når, og verdien før og etter | – | – | Ny term (`hendelseslogg.feature`) |
| hendelse | Én loggført endring i hendelsesloggen, med fast minimumsinnhold | – | – | Ny term (`hendelseslogg.feature`) |
| standardinnstilling | Innstilling som settes for flere utdanningstilbud av gangen | – | – | Ny term (`sette_standardinnstillinger.feature`). Om det er en mal som arves, er uavklart |

## Utdanningstilbud og søknad

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| utdanningstilbud | «Utdanningsinstans som er gjort tilgjengelig i ett eller flere opptak, slik at den kan søkes på av personer» | [utdanningstilbud](https://fs.sikt.no/domenekunnskap/begreper/utdanningstilbud/) (aktiv) | Opptaksstudieprogram | OK. Merknad i katalogen: «Valgte/prioriterte utdanningstilbud i ett opptak, kalles søknadsalternativ» |
| søknad | «Søknaden er søkers objekt-representasjon i systemet i ett opptak» | [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | Søknad | OK. Tilstandene påbegynt, levert og plasstildelt står i katalogen |
| søknadsalternativ | «Representasjon av søkers valgte og eventuelt prioriterte utdanningstilbud i en søknad» | [søknadsalternativ](https://fs.sikt.no/domenekunnskap/begreper/soknadsalternativ/) | Søknadsalternativ | OK |
| påbegynt søknad | Søknad som er opprettet, men ikke levert. Kan endres fram til søknadsfristen | Tilstand i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | – | ✅ Avklart: «påbegynt søknad» er riktig, ikke «søknadskladd» |
| studierett | Retten en søker får til å studere på et utdanningstilbud etter opptak | – | Studierett | Mangler i begrepskatalogen |
| antall studieplasser | Hvor mange studieplasser utdanningstilbudet har. Settes på utdanningstilbudet, og vises som grunnlag når antall tilbud som skal gis settes | Se [kapasitet](https://fs.sikt.no/domenekunnskap/begreper/kapasitet/) | – | ✅ Avklart 2026-10-09: «antall studieplasser» er vår term. ⚠️ Katalogen kaller det «kapasitet» |
| tidlig tilbud | Markering på et utdanningstilbud om at det gir tilbud ved tidlig opptak | – | – | Brukes i `opptaksinnstillinger_utdanningstilbud.feature`. Se «tidlig opptak» |

## Regelverk

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| regelverkssamling | «En samlet pakke med opptaksregelverk» | [regelverkssamling](https://fs.sikt.no/domenekunnskap/begreper/regelverkssamling/) (utkast) | – | OK |
| opptaksregelverk | «Samlebegrep for reglene som avgjør kvalifisering og rangering» | [opptaksregelverk](https://fs.sikt.no/domenekunnskap/begreper/opptaksregelverk/) (utkast) | – | OK |
| kompetansekrav | Krav til søkers kompetanse for å bli regnet som kvalifisert | [kompetansekrav](https://fs.sikt.no/domenekunnskap/begreper/kompetansekrav/) | Kompetansekrav | ✅ Avklart. Sjekkes mot kompetanseregelverket |
| kompetanseregelverk | Regelverket som brukes for å sjekke om søkeren møter kompetansekravene | – | Kompetanseregelverk | ✅ Avklart: eget begrep, ikke det samme som «kompetansekrav» |
| rangeringsregelverk | «Regler som bestemmer hvordan kvalifiserte søkere rangeres» | [rangeringsregelverk](https://fs.sikt.no/domenekunnskap/begreper/rangeringsregelverk/) (utkast) | Rangeringsregelverk | OK |
| opptakskrav | «Kombinasjonen av kompetansekrav og rangeringsregelverk» | [opptakskrav](https://fs.sikt.no/domenekunnskap/begreper/opptakskrav/) (utkast) | – | OK |
| kravelement | En enkelt del av et kompetansekrav eller et rangeringsregelverk, for eksempel et fag eller en karaktergrense | – | Kravelement | Finnes i kravene og gammel FS, mangler i begrepskatalogen |
| grunnlag | Enten **kvalifikasjonsgrunnlag** (de konkrete kompetansekravelementene en søker oppfyller for å regnes som kvalifisert) eller **rangeringsgrunnlag** (de konkrete rangeringselementene brukt på en søker for å utlede rangeringspoeng). Konteksten avgjør | – | Kvalifikasjonsgrunnlag | ✅ Avklart |

## Kvoter

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| kvote | «Begrensning på tilgang til utdanningstilbud som forfordeler noen søkergrupper foran andre når det er konkurranse om plassene» | [kvote](https://fs.sikt.no/domenekunnskap/begreper/kvote/) (aktiv) | Kvote | OK |
| kvotetype | Malen for en kvote, definert i regelverket, for eksempel førstegangsvitnemål eller ordinær | – | Kvotetype | Finnes i gammel FS, mangler i begrepskatalogen |
| utdanningskvote | En kvotetype anvendt på et utdanningstilbud i et opptak. Antall tilbud som skal gis settes per utdanningskvote og runde | – | – | ✅ Avklart: «utdanningskvote» er riktig, ikke «studiekvote» |
| kvotesøknad | At en søker konkurrerer i én utdanningskvote, med en poengsum og en rangering. En søker har én kvotesøknad per utdanningskvote søkeren konkurrerer i | – | – | Ny term i kravene (plasstildeling) |
| kvoteprioritet | «Innbyrdes rangering mellom ulike kvoter. Kvoteprioriteten angir hvilken kvote en søknad vurderes i først, dersom det finnes flere muligheter» | [kvoteprioritet](https://fs.sikt.no/domenekunnskap/begreper/kvoteprioritet/) (aktiv) | – | OK. Sto som manglende i forrige versjon av lista, men finnes nå i katalogen |
| kvotespørsmål | Spørsmål i søknaden som avgjør hvilke kvoter søkeren kan konkurrere i | – | Kvotespørsmål | Finnes i gammel FS, mangler i begrepskatalogen |
| plassflyt | «Automatisk overføring av ledige plasser fra en kvote til en annen når kvoten ikke fylles opp» | [plassflyt](https://fs.sikt.no/domenekunnskap/begreper/plassflyt/) (utkast) | Plassflyt / Kvotetilh plassflyt | ✅ Avklart: erstatter «kvoteflyt». ✅ Avklart 2026-10-09: plassflyt er bare at ubrukte plasser flyter mellom kvoter i et opptak. Det må ikke blandes med informasjonsarv mellom runder. ⚠️ Katalogen sier at plassflyt også kan gå mellom plasstildelinger. Om plassflyt settes på opptaket eller per utdanningstilbud, er uavklart |
| mottakende utdanningskvote | Utdanningskvoten som får de ledige plassene fra en annen utdanningskvote ved plassflyt | – | – | Ny term (`plassflyt.feature`) |
| siste utdanningskvote | Utdanningskvote som ikke sender ledige plasser videre, typisk ordinær kvote | – | – | Ny term (`plassflyt.feature`) |
| tilbud til alle kvalifiserte | Innstilling på et utdanningstilbud der alle kvalifiserte søkere får tilbud uansett poengsum, uten poenggrense | – | – | Ny term (`antall_tilbud_som_skal_gis.feature`) |

## Poengberegning og rangering

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| poengberegning | Utregningen av søkerens poengsum etter rangeringsregelverket | – | Poengberegning | OK |
| poengsum | Summen av poengene søkeren konkurrerer med i en kvote | – | Poengsum | OK |
| poenggrense | «Poengsummen til den lavest rangerte kvalifiserte søkeren som fikk tilbud om plass» | [poenggrense](https://fs.sikt.no/domenekunnskap/begreper/poenggrense/) (aktiv) | Poenggrense | OK. Beregnes per utdanningskvote |
| poengklasse | Gruppe av poeng med samme opphav, for eksempel karakterpoeng (KAR) eller alderspoeng (ALD) | – | Atomiskpoengklasse | ✅ Avklart: dropp «atomisk»-prefikset |
| poengvariant | Variant av en poengtype i rangeringsregelverket | – | Atomiskpoengtype | ⚠️ Kravene bruker «poengvariant», gammel FS har «atomisk poengtype» |
| poenglikhetsregel | «Regel som avgjør hvem som skal prioriteres når to eller flere søkere har eksakt samme poengsum i konkurranse om samme plasser» | [poenglikhetsregel](https://fs.sikt.no/domenekunnskap/begreper/poenglikhetsregel/) (utkast) | Rangeringslikhetstype | OK |
| loddtrekning | Poenglikhetsregel der loddtrekning avgjør rekkefølgen ved lik poengsum. Regelen for UHG fra 2027 | – | – | Hvem som eier trekningen, er uavklart |
| karakterpoeng | Poeng beregnet fra søkerens karakterer | – | KAR | OK |
| skolepoeng | Karakterpoeng pluss eventuelle realfags- og språkpoeng | – | SKO | OK |
| konkurransepoeng | Samlebegrep for summen av alle poeng søkeren konkurrerer med i en kvote | – | – | OK |
| alderspoeng | Tilleggspoeng ut fra søkerens alder | – | ALD | OK |
| kjønnspoeng | Tilleggspoeng til søkere av underrepresentert kjønn på utdanningstilbud som gir det | – | – | OK |
| realfagspoeng | Tilleggspoeng for realfag | – | REA | OK |
| språkpoeng | Tilleggspoeng for fremmedspråk | – | SPR | OK |
| rangering | Rekkefølgen kvalifiserte søkere står i innenfor en kvote, etter poengsum og poenglikhetsregel | – | Rangering | OK |

## Plasstildeling og runder

| Begrep i krav | Definisjon | Begrepskatalog | Gammel FS | Merknad |
|---------------|------------|----------------|-----------|---------|
| plasstildeling | «Bestemt utfall av søknadsbehandling i opptak som får virkning for alle søknader i ett opptak, i én av tre former»: tilbud om studieplass, venteliste eller avslag | [plasstildeling](https://fs.sikt.no/domenekunnskap/begreper/plasstildeling/) (utkast) | Opptakskjøring | OK. Erstatter «opptakskjøring». I kravene: beregningen som gjøres i en runde. Én runde kan ha flere plasstildelinger |
| prøvetildeling | Plasstildeling som ikke publiseres, brukt til å kvalitetssikre resultatet før den som publiseres | – | – | Ny term i kravene |
| plasstildelingsrunde | Vinduet i et opptak der plasser fordeles og søkerne får svar, med egen svarfrist. Et opptak kan ha flere plasstildelingsrunder | [opptaksrunde](https://fs.sikt.no/domenekunnskap/begreper/opptaksrunde/) (aktiv) | Kvoterunde / Opptaksrunde | ✅ Avklart 2026-09-30, bekreftet 2026-10-09: «plasstildelingsrunde». Rettet i kravene 2026-10-09. ⚠️ Katalogen har «opptaksrunde» |
| rundetype | Hva slags runde det er: hovedtildeling, supplering eller etterfylling. Settes når runden legges til, og kan ikke endres | – | – | ✅ Avklart 2026-10-09: tre rundetyper. Ledige studieplasser og tidlig opptak er ikke rundetyper. ⚠️ Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST |
| hovedtildeling | Den første runden i et opptak. Søkeren får tilbud på høyest mulige prioritet, og lavere prioriteter faller bort | – | Hovedopptak | Et opptak har én hovedtildeling. Kodeverket kaller den «Hovedopptak» |
| supplering | Runde etter hovedtildelingen som bygger på forrige publiserte runde, med bortfall og kompensasjonstilbud ved opprykk | – | Suppleringsopptak | Kodeverket kaller den «Suppleringsopptak» |
| etterfylling | «En ny plasstildelingsrunde som fyller opp plasser som ble ledige etter at søkere svarte nei eller ikke svarte innen svarfristen». Uten bortfall: søkeren kan ha flere tilbud og må velge ett | [etterfylling](https://fs.sikt.no/domenekunnskap/begreper/etterfylling/) (utkast) | Etterfyllingsopptak | OK. Sto som manglende i forrige versjon av lista, men finnes nå i katalogen |
| ledige studieplasser | Egenskap opptaksforvalter kan sette på en runde av alle rundetyper, når opptaket tilbyr søknad på ledige studieplasser. Søkere innen ordinær frist får plass først etter poeng, deretter søkere på ledige studieplasser etter søknadstidspunkt | – | – | ✅ Avklart 2026-10-08: en egenskap ved runden, ikke en rundetype |
| informasjonsarv | At en plasstildeling bygger videre på forrige publiserte runde: tidligere tilbud, ventelister og svar, slik at en ny plasstildeling ikke begynner på blanke ark | – | – | Brukes i design.md og kravene. Er ikke plassflyt |
| antall tilbud som skal gis | Hvor mange nye tilbud som skal gis i en utdanningskvote på et utdanningstilbud i en runde. Settes som hele tall per utdanningskvote og runde. Kan være negativt i supplering | Se [antall plasser](https://fs.sikt.no/domenekunnskap/begreper/antall_plasser/) og [overbooking](https://fs.sikt.no/domenekunnskap/begreper/overbooking/) | Tilbud ønsket / Tilbud maks | ✅ Avklart 2026-10-08, bekreftet 2026-10-09: «antall tilbud som skal gis». Brukerne sier «sette opptaksparametere». ⚠️ Katalogen har «antall plasser» for det samme |
| periode for å endre antall tilbud som skal gis | Tidsrommet, satt på runden, der lærestedene kan endre antall tilbud som skal gis | – | – | Ny term (`forvalte_runder.feature`) |
| netto tilbud | Aksepterte tilbud pluss gitte tilbud der svarfristen ikke er ute | – | – | Ny term (`antall_tilbud_som_skal_gis.feature`) |
| svar på søknad | Resultatet søkeren får per søknadsalternativ: tilbud, ventelisteplass eller avslag | – | – | Resultatet av plasstildelingen |
| tilbud | Svar på søknad der søkeren får tilbud om studieplass | – | Tilbud | OK |
| ventelisteplass | Svar på søknad der søkeren får plass på venteliste, med ventelistenummer | [venteliste](https://fs.sikt.no/domenekunnskap/begreper/venteliste/) (utkast) | Venteliste | OK |
| ventelistenummer | Søkerens plass på ventelisten til en utdanningskvote | – | – | Om nummeret skal vises for søkeren, settes per utdanningstilbud |
| avslag | Svar på søknad der søkeren ikke er kvalifisert, eller ikke har nådd opp i konkurransen om tilbud om studieplass og heller ikke har fått plass på venteliste | – | Avslag | ✅ Avklart 2026-10-09. Er ikke det samme som bortfall |
| opprykk | At en søker får tilbud på en høyere prioritet, og den opprinnelige plassen frigjøres | – | – | OK |
| bortfall | At søkeren mister tilbudet på en lavere prioritet fordi søkeren har fått tilbud på en høyere prioritet | – | Bortfall | ✅ Avklart 2026-10-09 (se `gjennomføre_plasstildeling.feature`). Er ikke det samme som avslag. Gjelder ikke i etterfylling |
| kompensasjonstilbud | Nytt tilbud til neste på ventelisten når en plass frigjøres ved opprykk eller bekreftet avslag i supplering. Teller mot antall tilbud som skal gis i runden | – | – | ✅ Avklart 2026-10-08: teller mot antall tilbud som skal gis i runden |
| tilbudsgaranti | Markering på en søknad, satt av saksbehandler, som gir tilbud etter reglene for runden uten poengsum. Brukes blant annet ved tidlig opptak | – | – | ✅ Avklart 2026-10-09. Tas fra en bestemt utdanningskvote |
| svarfrist | Fristen søkeren har til å svare på et tilbud. Settes per runde | – | Svarfrist | OK |
| publisere | Gjøre resultatet av en plasstildeling synlig for søkerne. Tidspunktet settes når opptaksforvalter publiserer | – | – | En runde har én publisert plasstildeling |
| antall plasser | «Antall plasser forteller hvor mange tilbud som skal gis og setter begrensinger for hvor mange som kan motta et tilbud» | [antall plasser](https://fs.sikt.no/domenekunnskap/begreper/antall_plasser/) (aktiv) | Tilbud ønsket / Tilbud maks | ⚠️ Brukes ikke i kravene. Se «antall tilbud som skal gis» |
| kapasitet | «Kapasiteten beskriver det faktiske antall plasser som finnes på utdanningstilbudet. Det antallet studenter som utdanningstilbudet er dimensjonert for» | [kapasitet](https://fs.sikt.no/domenekunnskap/begreper/kapasitet/) (aktiv) | – | ⚠️ Brukes ikke i kravene. Se «antall studieplasser» |
| overbooking | Totalt antall tilbud som gis minus antall studieplasser | [overbooking](https://fs.sikt.no/domenekunnskap/begreper/overbooking/) (aktiv) | – | ✅ Avklart 2026-10-09: definisjonen. Er ikke noe som settes, og brukes ikke i kravene. ⚠️ I koden er det feltnavnet for antall tilbud som skal gis |

## Frister og datoer

| Begrep i krav | Definisjon | Begrepskatalog | Merknad |
|---------------|------------|----------------|---------|
| søknadsfrist | Fristen for å levere søknad i opptaket | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| dokumentasjonsfrist | Fristen for å laste opp dokumentasjon | – | OK |
| omprioriteringsfrist | Fristen for å endre rekkefølgen på søknadsalternativene | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| ettersendingsfrist | Fristen for å ettersende dokumentasjon | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| frist for poenggrenser | Frist ved tidlig opptak | – | Ny i kravene, for tidlig opptak |
| informasjonsdato | Dato på opptaket som bare er informasjon til søker, for eksempel når resultatet kan forventes publisert | – | OK |
| publiseringsdato | – | – | ⚠️ Avklart 2026-10-07: runden har ingen publiseringsdato som settes. Publiseringstidspunktet er når opptaksforvalter publiserer. Bør tas ut som eget begrep |

## Kvalifisering og vurdering

| Begrep i krav | Definisjon | Begrepskatalog | Merknad |
|---------------|------------|----------------|---------|
| kvalifisering | Prosessen der søkerens kompetanse sjekkes mot kompetansekravene | – | OK |
| kvalifisert søker | «Søker som oppfyller alle formelle krav for opptak til et utdanningstilbud» | [kvalifisert søker](https://fs.sikt.no/domenekunnskap/begreper/kvalifisert_soker/) (utkast) | OK. Om søknaden også må være ferdigbehandlet for å være med i plasstildelingen, er uavklart |
| ferdigbehandlet | Status på en søknad når saksbehandlingen er ferdig | – | Brukes i `trekke_søknad.feature` og plasstildelingen |
| generell studiekompetanse (GSK) | Det generelle kompetansekravet for opptak til høyere utdanning | – | OK. Gammel FS: GSK |
| realkompetanse | Kompetanse fra arbeid og annen erfaring som vurderes i stedet for formell utdanning | – | OK |
| fagprofil | Søkerens registrerte fag og karakterer | – | Gammel FS: Fagprofil |
| utdanningsbakgrunn | Gruppe søkere med samme type utdanning, med egne frister i opptaket | – | ⚠️ Brukes i kravene for frister. Relatert til «kvalifikasjonsgrunnlag» i gammel FS, men bredere |
| praksis / praksisperiode | Arbeidserfaring som kan telle i kvalifisering eller rangering | – | OK |

## Søknadsbehandling

| Begrep i krav | Definisjon | Begrepskatalog | Merknad |
|---------------|------------|----------------|---------|
| saksbehandling | Behandlingen av søknaden: vurdering av dokumentasjon, grunnlag og poeng | – | OK |
| sak | Søknaden slik den ligger hos én saksbehandlende organisasjon | – | Ny i `tildele_saksbehandlende_organisasjon.feature` |
| saksbehandlertildelingsregel | En eller flere regler for hvordan søknader skal fordeles til saksbehandlende organisasjoner i et samordna opptak | – | ✅ Avklart 2026-10-09: «saksbehandlertildelingsregel». Rettet i kravene |
| vedtak / vedtaksbrev | Den formelle avgjørelsen på søknaden, og brevet søkeren får med den | – | OK |
| mangelkode | Kode for hva søkeren mangler for å være kvalifisert | – | Gammel FS: Kompetansemangler (SFA, SNU, SÆR) |

---

## Avklarte begrepsvalg

| # | Riktig begrep | Feil / utdatert | Handling | Avklart |
|---|--------------|-----------------|----------|---------|
| 1 | samordna opptak | samordnet opptak | Rett i kravene der «samordnet» brukes | 2026-09-30 |
| 2 | deltakende organisasjon | deltagende organisasjon | Rett i kravene der «deltagende» brukes | 2026-09-30 |
| 3 | tidlig opptak | tidligopptak | Skrives som to ord | 2026-09-30 |
| 4 | påbegynt søknad | søknadskladd | Rett i kravene der «søknadskladd» brukes | 2026-09-30 |
| 5 | utdanningskvote | studiekvote | «Utdanningskvote» er vår term | 2026-09-30 |
| 6 | kompetansekrav / kompetanseregelverk | – | To ulike begreper: **kompetansekrav** = krav til søkers kompetanse for å bli kvalifisert. **Kompetanseregelverk** = regelverket som brukes for å sjekke om søker møter kravene | 2026-09-30 |
| 7 | plasstildelingsrunde | opptaksrunde, runde | Bekreftet 2026-10-09. «Opptaksrunde» er rettet i kravene | 2026-09-30 |
| 8 | grunnlag (kvalifikasjons- / rangerings-) | – | «Grunnlag» kan henvise til **kvalifikasjonsgrunnlag** eller **rangeringsgrunnlag** | 2026-09-30 |
| 9 | plassflyt | kvoteflyt | Avvikle «kvoteflyt» | 2026-09-30 |
| 10 | poengklasse | atomisk poengklasse | Dropp «atomisk»-prefikset | 2026-09-30 |
| 11 | antall tilbud som skal gis | overbooking, måltall, antall ønsket ja-svar, opptaksparametere | «Opptaksparametere» står bare i parentes i tittelen, fordi brukerne sier det | 2026-10-08 |
| 12 | rundetype: hovedtildeling, supplering, etterfylling | ledige studieplasser, tidlig opptak som rundetype | Ledige studieplasser er en egenskap ved runden. Tidlig opptak løses med tilbudsgaranti | 2026-10-08 og 2026-10-09 |
| 13 | antall tilbud settes som hele tall per utdanningskvote og runde | prosentfordeling, kvotefordeling | Prosentfordeling utgår | 2026-10-08 |
| 14 | antall studieplasser | kapasitet | Vår term for hvor mange studieplasser utdanningstilbudet har | 2026-10-09 |
| 15 | overbooking = totalt antall tilbud som gis − antall studieplasser | overbooking som tallet som settes | Det som settes, er antall tilbud som skal gis | 2026-10-09 |
| 16 | opptakseier | – | Organisasjonen som oppretter og forvalter opptaket. Opptaksforvalterne er ansatte der | 2026-10-09 |
| 17 | saksbehandlertildelingsregel | tildelingsregel | «Tildelingsregel» er rettet i kravene | 2026-10-09 |
| 18 | tidlig opptak | – | Tidlig behandling og tilbud, uten tidligere studierett | 2026-10-09 |
| 19 | plassflyt | plassflyt mellom runder | Plassflyt er mellom kvoter. Det som går mellom runder, er informasjonsarv | 2026-10-09 |
| 20 | avslag / bortfall | – | To ulike svar: avslag = ikke kvalifisert eller ikke nådd opp. Bortfall = mister tilbud på lavere prioritet | 2026-10-09 |

---

## Kravene som er rettet etter avklaringene (2026-10-09)

- «Opptaksrunde» → «plasstildelingsrunde»: `se_egen_søknad.feature`, `svare_på_tilbud.feature`, `frister_og_hendelser.feature`
- «Tildelingsregel» → «saksbehandlertildelingsregel», og «samordnet» → «samordna»: `tildele_saksbehandlende_organisasjon.feature`, `opptaksinnstillinger_utdanningstilbud.feature`
- Det åpne spørsmålet om plassflyt mellom plasstildelinger i `plassflyt.feature` er lukket

- «Samordnet opptak» → «samordna opptak» i alle opptakskrav. `samordnet_opptak.feature` heter nå `samordna_opptak.feature`
- «Runde» → «plasstildelingsrunde» i alle opptakskrav, også i scenariotitler og steg. `forvalte_runder.feature` har tittelen «Plasstildelingsrunder i et opptak». Navn på runder i anførselstegn («Hovedrunde», «Suppleringsrunde») og mappenavnet `01 Runder` er ikke endret

## Avvik i begrepskatalogen som bør meldes

- Katalogen har «opptaksrunde». Vår term er «plasstildelingsrunde»
- Katalogen har «kapasitet». Vår term er «antall studieplasser»
- Katalogen definerer «overbooking» som et estimat, og «antall plasser» som kapasitet pluss overbooking. Vi sier «antall tilbud som skal gis», og overbooking er totalt antall tilbud som gis minus antall studieplasser
- Katalogen sier at plassflyt også gjelder mellom plasstildelinger. Det er informasjonsarv

## Begreper som mangler i begrepskatalogen

Følgende begreper brukes i kravene, men finnes ikke (enda) i begrepskatalogen på fs.sikt.no:

- opptaksforvalter (ny rolle), opptakseier
- forvaltende organisasjon / deltakende organisasjon
- saksbehandlende organisasjon, tilbyder
- studierett
- tidlig opptak
- kravelement
- kvotetype, utdanningskvote, kvotesøknad
- kvalifikasjonsgrunnlag (som eget begrep)
- plasstildelingsrunde, rundetype, hovedtildeling, supplering (etterfylling finnes)
- ledige studieplasser (som egenskap ved runden)
- antall tilbud som skal gis, netto tilbud
- tilbudsgaranti, kompensasjonstilbud
- bortfall, opprykk, avslag
- saksbehandlertildelingsregel
- antall studieplasser
- prøvetildeling
- hendelseslogg
- utdanningsbakgrunn (i kontekst av frister)

Sto som manglende i forrige versjon av lista, men finnes nå i katalogen: opptak, etterfylling, kvoteprioritet, plassflyt, opptaksrunde, poenggrense, kapasitet, antall plasser, overbooking, kvalifisert søker.
