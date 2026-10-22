# Design-kontekst: Målbilde vitnemålsbehandleren, steg 2

Kilde: Figma, fileKey `LmoNQlmAuE2FlE0fUo5GoO`, siden «Vitnemålsbehandleren» (node `20402:102594`), seksjonen «MÅLBILDE» (node `21388:111761`). Hentet 2026-09-30.

`get_metadata` på siden feilet (svaret var for stort til å overføres). Oversikten under er hentet med et lesende Plugin API-kall (`use_figma`) og viser seksjonens direkte children.

| Node | Navn | Type | Størrelse | I scope |
|---|---|---|---|---|
| `21388:113858` | Steg 2 Grunnlag - Ingen e-vitnemål | FRAME | 1920×2082 | Ja |
| `21388:114364` | Steg 2 Grunnlag - Vitnemål åpen - Auto tabellrad | FRAME | 1920×3914 | Ja |
| `21388:112060` | Steg 2 Grunnlag - Legg inn vitnemål manuelt | FRAME | 1920×4091 | Ja |
| `21388:112861` | Steg 2 Grunnlag - Behandle e-vitnemål | FRAME | 1920×5003 | Ja |
| `21388:116625` | Steg 2 - 1240px | FRAME | 1240×5241 | Ja |
| `21388:111762` | Steg 1 | FRAME | 1920×1937 | Nei |
| `21388:111913` | Steg 1 med merknader | FRAME | 1920×2022 | Nei |
| `21388:116379` | iPad portrett 768px — skuff lukket | FRAME | 768×2417 | Nei |
| `21388:116192` | iPad portrett 768px — Merknader åpen | FRAME | 768×2016 | Nei |
| `21388:115379` | Spesielle opptakskrav - vis per grunnlag åpen | FRAME | 1900×2231 | Nei |
| `21388:115796` | Spesielle opptakskrav | FRAME | 1900×2112 | Nei |
| `21388:114012` | Steg 4  Poengberegning | FRAME | 1900×2175 | Nei |
| `21388:115111` | Kvoter | FRAME | 1920×2082 | Nei |
| `21388:115251` | SDS - Oppsummering med vertikale linjer og merknader og riktig padding | FRAME | 2176×2406 | Nei |
| `21388:116484` | Søknadsbehandling 1240px | FRAME | 1240×3651 | Nei |
| `21388:117375` | Dialog | INSTANCE | 832×340 | Nei |
| `21388:117376` | Outer Frame | FRAME | 1885×1446 | Nei |
| `21388:114360`, `21388:114362`, `21388:114354`, `21388:114356`, `21388:114358` | Frame 1000002413/2417/2412/2416/2414 | FRAME | – | Nei (uten meningsbærende navn) |
| `21388:117366` | image 55 | RECTANGLE | – | Nei |
| `21388:117365` | delete | INSTANCE | – | Nei |

## Innhold i vitnemålsseksjonen (steg 2)

- Seksjonen heter «Vitnemålsbehandling», med en teller for antall vitnemål (2) og «Vis»/«Skjul».
- Tabellen «Vitnemål» har kolonnene Vitnemålsnummer (lenke med ikon for eget vindu), Utstedt dato, GSK, Første, KAR, REA og SPR, med ett valg (radioknapp) per vitnemål, og valget «Legg inn manuelt».
- Under valgt vitnemål vises fagene («Vitnemål 498463131356», Opprinnelig/Forbedret, Omfang, Fag, Fagnavn, Stp, Eks, Merknad, Fagstatus) med «Åpne i nytt vindu».
- Deretter følger «Kvalifisering og poengberegning», «Poeng fra vitnemål», «Tilleggsfag» og «Spesielle opptakskrav».
