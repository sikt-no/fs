# Fordeling av søkerne – Gi tilbudsgaranti ved tidlig opptak

Forslag (2026-11-09) til hvilke søkere som går i hver liste i miljøfila (`sak-tidlig-opptak-…` i [`cdp-tester/_Miljøer/test.md`](../../../cdp-tester/_Milj%C3%B8er/test.md)), og hva som må gjøres med hver søker før kjøringen.

Søkerne er fra spørring 5 i [`finn-testdata.sql`](finn-testdata.sql), kjørt mot eksempeldataene lokalt (versjon `20261109_035001_UTC`): 139 personer i «Velg testsøker» uten søknad i opptak 34. Tatt ut: 37 personaer i FS Admin (står i «Personaer» i miljøfila), navn som ligner ekte personer, og navn som finnes to ganger. Igjen: 91 syntetiske søkere. **Kjør spørring 5 mot TEST før kjøringen**: noen kan ha brukt søkerne der etter resettet.

## Hvor mange per kjøring

Én kjøring bruker 42 søkere (hvert scenario og hvert eksempel i en scenariomal tar sin egen). Forslaget har 62, så det er reserve til omkjøringer, og 28 til overs til en ny kjøring.

| Liste | Per kjøring | I lista | Søkere |
|---|---|---|---|
| `sak-tidlig-opptak-kvalifisert` | 24 | 30 | Økologisk Badering, Gretten Pedal, Trist Rygg, Formbar Juice, Tru Kjetting, Uromantisk Plasma, Ufornuftig Graf, Misfornøyd Skrivemaskin, Skapende Hund, Akustisk Elg, Vokal Adressat, Overeksponert Stokk, Fiktiv Motvind, Uvitende Bjørnunge, Ukontroversiell Oridé, Munter Jordbær, Rød Nattergal, Innesluttet Turistby, Lattermild Altmuligmann, Kvadratisk Opplag, Spretten Laks, Straffet Trapp, Uklar Artikkel, Uttrykksfull Port, Viktig Ringdue, Konkret Fobi, Mye Behandling, Klok Netthinne, Robust Skatoll, Idiotsikker Matte |
| `sak-tidlig-opptak-ikke-kvalifisert` | 2 | 3 | Kranglete Artisjokk, Solid Sverm, Fyldig Revebjelle |
| `sak-tidlig-opptak-kvalifisering-ikke-vurdert` | 1 | 2 | Eksemplarisk Bevegelse, Tørst Halvkule |
| `sak-tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert` | 1 | 2 | Famøs Tunge, Smart Glose |
| `sak-tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert` | 1 | 2 | Ravgul Katedral, Topp Savanne |
| `sak-tidlig-opptak-to-kvoter` | 1 | 2 | Oppklarende Fobi, Talefør Torsk |
| `sak-tidlig-opptak-poeng-i-kvote-uten-kvoteplassering` | 1 | 2 | Opprett Fjellkjede, Familiær Bane |
| `sak-tidlig-opptak-uten-poengsum` | 2 | 3 | Lang Bukt, Oppjaget Bas, Justerbar Prøve |
| `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` | 1 | 2 | Aktuell Kjepphest, Vis Servise |
| `sak-uten-soknad-om-tidlig-opptak` | 1 | 2 | Betydelig Opsjon, Sliten Munn |
| `sak-tidlig-opptak-median-over` | 2 | 3 | Kunst Klisjé, Kranglete Vevstol, Normal Konjunksjon |
| `sak-tidlig-opptak-median-lik` | 1 | 2 | Uemosjonell Betaling, Distingvert Drage |
| `sak-tidlig-opptak-median-under` | 2 | 3 | Nervøs Rosin, Anstendig Lege, Fysisk Delmengde |
| `sak-tidlig-opptak-uten-median` | 1 | 2 | Motvillig Brøkdel, Filosofisk Liste |
| `sak-tidlig-opptak-to-saker` | 1 | 2 | Gild Galleri, Vertikal Branngate |

Til overs (28, Øvrige Edelstein er brukt i prøven under): Misfornøyd Ambassade, Trist Muffins, Diskret Breiflabb, Opprett Kone, Raffinert Føll, Nøytral Busstopp, Freidig Bris, Akademisk Gallium, Konsentrisk Øy, Kry Omelett, Kompleks Corner, Observant Vevstol, Eksplosiv Hei, Toårig Påkjenning, Parodisk Hale, Fin Såpe, Underfundig Sild, Normal Diva, Plutselig Mandag, Overbevisende Abbor, Unyttig Fiskebolle, Lys Kamera, Refleksiv Sommerferie, Velkommen Desimal, Sta Jukeboks, Beskjeden Rosin, Fiolett Bokhylle, Nonfigurativ Tja.

## Slik gjøres søkerne klare

Alle i to steg: søknaden i Min kompetanse (søkeren), og kvalifiseringen og poengsummen i FS Admin (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT), i saken under «Kravliste studier» og «Poengberegning»). Saken skal stå som ikke ferdig behandlet og uten konklusjon for tidlig opptak: det gjør scenarioet selv.

**Søknaden** (Min kompetanse, «Velg testsøker»): søknad i «Samordna UHG-simulering høsten 2026» med studieønskene under, og søknad om tidlig opptak (grunnlaget «Jeg er i jobb og har oppsigelsestid, eller må søke permisjon»), unntatt `sak-uten-soknad-om-tidlig-opptak`.

| Liste | Studieønsker (prioritet 1, 2) | Kvalifisering (prioritet 1) | Poengsum (prioritet 1) |
|---|---|---|---|
| `kvalifisert` | Datateknikk ingeniør (UiT), Elektronisk systemingeniør (NTNU) | kvalifisert, på begge | over 5, på begge |
| `ikke-kvalifisert` | som `kvalifisert` | alle grunnlagene vurdert til nei | over 5 |
| `kvalifisering-ikke-vurdert` | som `kvalifisert` | ikke vurdert | over 5 |
| `grunnlag-kvalifisert-og-ikke-kvalifisert` | som `kvalifisert` | to grunnlag: ett ja, ett nei | over 5 |
| `grunnlag-ikke-vurdert-og-ikke-kvalifisert` | som `kvalifisert` | to grunnlag: ett ikke vurdert, ett nei | over 5 |
| `to-kvoter` | som `kvalifisert` | kvalifisert | ulik poengsum i to kvoter søkeren skal kvoteplasseres i |
| `poeng-i-kvote-uten-kvoteplassering` | som `kvalifisert` | kvalifisert | høyere poengsum i en kvote søkeren ikke skal kvoteplasseres i |
| `uten-poengsum` | som `kvalifisert` | kvalifisert | ingen poengsum i garantikvoten |
| `prioritet-1-uten-tidlig-opptak` | Bachelorstudium i arbeids- og velferdsfag (HIØ), Datateknikk ingeniør (UiT) | kvalifisert til Datateknikk | over 5 til Datateknikk |
| `uten-soknad-om-tidlig-opptak` | som `kvalifisert`, uten søknad om tidlig opptak | kvalifisert | over 5 |
| `median-over` | Paramedisin (UiT) | kvalifisert | minst 2 over medianen 47,8, for eksempel 50,0 |
| `median-lik` | Paramedisin (UiT) | kvalifisert | 47,8 |
| `median-under` | Paramedisin (UiT) | kvalifisert | minst 2 under medianen 47,8, for eksempel 45,0 |
| `uten-median` | Medisin (UiT, Bodø) | kvalifisert | over 5 |
| `to-saker` | Datateknikk ingeniør (UiT), Elektronisk systemingeniør (NTNU) | – | – |

## Det som må avklares

- **`to-saker`:** en søker har høyst én sak per organisasjon i et opptak (`saksbehandling.sak`, primærnøkkel søker, opptak og organisasjon). Utgangstilstanden i miljøfila er rettet 2026-11-09: én sak hos UiT og én hos NTNU. Testen gjør begge sakene klare som i Klargjøring K, men saken hos NTNU kan ikke gjøres klar av saksbehandleren ved UiT. Testen må få en testbruker for saksbehandleren ved NTNU, eller bare gjøre saken hos UiT klar.
- **`prioritet-1-uten-tidlig-opptak`:** «Bachelorstudium i arbeids- og velferdsfag» finnes ikke i eksempeldataene, og forsvinner ved neste resett av TEST.
- **Hvem gjør det:** 62 søknader i Min kompetanse og like mange saker i FS Admin er mye arbeid for hånd. Agenten kan gjøre søknadene i Chrome. Poengsummen kan ikke settes for hånd (se under).

## Poengsummen kan ikke settes for hånd (prøvd i TEST 2026-11-09)

Prøvd med Øvrige Edelstein (fra «Til overs»): søknad 34-1004196 i opptak 34, med Paramedisin (UiT) som eneste studieønske og uten søknad om tidlig opptak. Søknaden står i TEST, og Øvrige Edelstein er brukt.

- Saken er synlig for KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT).
- Steget «4. Poeng» viser «Ingen poengberegning». Poengene kan endres og låses («La stå») i FS Admin, men bare i rader som finnes, og radene lages av poengberegningen fra vitnemålene.
- Automatisk behandling (mutationen `behandleSakAutomatisk`, knappen er bak feature-flagget `automatisk-soknadsbehandling-trigger`) gikk uten feil, men ga ingen poeng og ingen kvoteplassering: søkeren har ingen vitnemål.
- `settPoengV4` kan sette poeng på en ny poengrad, men krever id-en til raden, og FS Admin har ingen måte å lage en ny rad på. Vitnemålskalkulatoren (`lagreVitnemalUtregning`) krever også en rad.
- Eksempeldataene har nesten ingen poeng i opptak 34: av 543 saker (73 hos UiT) har én søker poengrader, og ingen har poengsum. Det finnes ingen ferdige søkere med poengsum.

Veiene videre:

1. **SQL-skript (anbefalt for poengsum og kvalifisering):** teamet legger inn kvalifiseringen og poengsummene i databasen, som tilbudsgarantitypene ble lagt inn for testen av tilbudsgaranti. Søknadene og søknadene om tidlig opptak lages i Min kompetanse, så det søkeren gjør, går gjennom løsningen.
2. **Søkere med elektroniske vitnemål:** automatisk behandling lager poengradene, og poengene justeres og låses for hånd. Krever at vi finner søkere med vitnemål som gir poeng, og at de ikke er brukt.
