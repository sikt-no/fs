# Plasstildeling — Raffineringsnotat

> Utgangsdokument for planlegging av ferdigstilling av plasstildeling i opptak.
> Basert paa gap-analyse mellom krav (Confluence), datamodell (Admissio-skjema), Jira-saker (TAKE-prosjektet) og kildekoden (GitLab fs-plattform/opptak).

## Kontekstdiagram

```
                      ┌──────────────────────────────────────────────┐
   OPPTAK ───────────►│   RUNDER I OPPTAKET        (oppgave 1)       │
   navn, rundetype,   │   en eller flere per opptak                  │
   datoer             └───────────────────┬──────────────────────────┘
                                          │
   SOKNADSBEHANDLING                      │     INNSTILLINGER PER KVOTE
   kvalifisering                          │     maaltall, plassflyt,
        │                                 │     tilbud til alle kvalifiserte,
        ▼                                 │     kvote for tilbudsgaranti
   kvotetilhoerighet, poeng, rangering    │     (oppgave 2 og 3)
                                          │              │
        └───────────────┐                 │              │
                        ▼                 ▼              ▼
                     ╔═════════════════════════════════════════════╗
   forrige           ║        PLASSTILDELING     (oppgave 4 og 5)  ║
   publiserte  ─────►║  hvem faar plass — og hva ble poenggrensen? ║
   runde (arv)       ╚══════════════════════┬══════════════════════╝
                                            │
                                            ▼
              resultat per soknad: tilbud / venteliste (nr) / avslag
              poenggrense per kvote  ·  spor av plassflyt
                                            │
                     ┌──────────────────────┴──────────────────────┐
                     ▼                                             ▼
           SAKSBEHANDLER (oppgave 6)                  PUBLISERING (oppgave 7)
           kvalitetssikring foer publisering          valgfri — en proeve-
                                                      tildeling publiseres ikke
                                                                   │
                                                                   ▼
                                                     SVAR FRA SOKER (oppgave 8)
                                                     ja / nei / staar paa venteliste
                                                                   │
                                             utloeser ny runde ────┘
```

## Avklaringer fra oppdatert Confluence-side

Fire ting den oppdaterte Confluence-siden avgjorde:

1. **Opptaksforvalter** er definert: tilgangsrollen som setter innstillinger i opptaket som paavirker plasstildelingen.
2. **Poenglikhetsregler: fire, ikke tre.** Tidspunkt for levert soknad er med som egen rangeringsregel.
3. **"Eldste soker foerst" er ikke stabilt.** Siden sier at dette endres fra neste aars forskrift — det er en regelendring som maa planlegges.
4. **Melding om vedtak** er nytt og markert rodt: soker maa faa melding om at vedtaket foreligger, etter forvaltningsloven og eForvaltningsforskriften.

Rundetypene er navngitt: **hovedrunde, tilleggsrunde, supplerende**. "Supplerende" finnes som rundetype, samtidig som suppleringsoppfoerselen (frafallskompensasjon) er avgrenset bort.

## Oppgaveoversikt

Oppgavene foelger Confluence-sidens nummerering (oppdatert september 2026). Nummereringen er omstrukturert siden forrige runde:

| Ny | Oppgave | Var foer |
|----|---------|----------|
| 1 | Legge til runder for plasstildeling i ett opptak | 1 |
| 2 | Sette plasstildelingsinnstillinger (antall tilbud per utdanningskvote) | 2 (delt) |
| 3 | Sette plassflyt mellom utdanningskvoter | 2 (delt) |
| 4 | Starte en ny plasstildeling | 1b |
| 5 | Gjennomfoere plasstildeling | 3 + 4 |
| 6 | Vise resultatet til saksbehandler | 5 |
| 7 | Publisere resultatet til soekerne | 6 |
| 8 | Haandtere svar fra soker | 7 |

## Evidensgrunnlag

| Kilde | Tilgang | Kommentar |
|-------|---------|-----------|
| Datamodell (Admissio-skjema via FS-MCP) | Verifisert | Tabeller i `plasstildeling`, `opptak`, `soknad`, `regelverk` |
| Jira TAKE-prosjektet | Verifisert | 56 saker gjennomgaatt |
| GitHub sikt-no/fs | Verifisert | Issues og initiativ #216 |
| GitLab fs-plattform/opptak | **Verifisert** | Kjernetjenester og algoritme gjennomgaatt |
| Confluence raffineringsnotat | Verifisert | 8 oppgaver, oppdatert struktur |

Evidensnivaa: **M** = verifisert i datamodellen, **S** = dokumentert i en sak, **V** = verifisert i koden

## Gap-analyse per oppgave

### Oppgave 1 — Legge til runder

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Navn paa runde | `opptak.opptaksrunde.navn` NOT NULL | Ingen | M |
| Svarfrist for soker | `opptaksrunde.svarfrist` NOT NULL | Ingen | M |
| Dato for naar plasstildelingen skal skje | **Ingen kolonne** | Feltet finnes ikke i modellen | M |
| Rundetype (hoved/tillegg/supplerende) | `opptaksrundetype_kode` | Se strukturfunn under | M |
| Publiseringstidspunkt | `opptaksrunde.publiseringstidspunkt` (nullable) | Automatisk publisering avgrenset bort | M |
| Periode for aa endre parametere | `opptaksrunde.periode_endre_opptaksparametere` (tstzrange) | Finnes i modellen, ikke i krav | M |

**Strukturfunn:** `opptaksrundetype_kode` er del av **primaernoekkelen** til `opptak.opptaksrunde` og foelger med i hver fremmednoekkel ut derfra. En runde kan ikke bytte type etter oppretting, og loepenummer er unikt per rundetype, ikke per opptak — noe som er noyaktig det TAKE-284 handler om.

**Saker:** [#107](https://github.com/sikt-no/fs/issues/107) (lukket). TAKE-184 (teknisk). **Ny sak trengs** for "dato for plasstildeling".

### Oppgave 2 — Antall tilbud som skal gis

Kravet sier at "antall tilbud som skal gis" erstatter maaltall og overbookingstall. I modellen er erstatningen ikke gjennomfoert. Fire tall i fire tabeller:

| Tabell | Kolonne | Nivaa | Brukes av algoritmen | Ev. |
|--------|---------|-------|---------------------|-----|
| `opptak.utdanningstilbud` | `antall_studieplasser` | Per utdanningstilbud (kapasitet) | Nei — kun visning | M+V |
| `opptak.kvote` | `onsket_antall_deltakere` | Per kvote, per opptak | **Fallback** naar overbook mangler | M+V |
| `opptak.opptaksparametere` | `overbook_antall_plasser` | Per kvote **per runde** | **Ja — dette er maaltallet** | M+V |
| `plasstildeling.studiekvote` | `onsket_antall_tilbud` NOT NULL | Per kvote **per plasstildeling** | Nei — kun visning/snapshot | M+V |

**Verifisert i koden:** `KvoterService:98-104` er eksplisitt: `overbook_antall_plasser` er maaltallet, med fallback til `onsket_antall_deltakere`. De andre tallene er for visning, ikke algoritmen. Begrepet "overbook" er misvisende — kolonnen er det faktiske antall tilbud som skal gis, ikke et tillegg.

Kravet om at opptaksforvalter skal se **tilbud gitt og akseptert per kvote** har ingen lagrede kolonner — maa aggregeres fra `plasstildelingsresultat`.

**Saker:** TAKE-140 (lesesiden, Done). **Hull:** Ingen sak dekker aa sette antall tilbud, og begrepsrengjoeringen er ugjort.

### Oppgave 3 — Plassflyt

**Viktigste enkeltfunn i gap-analysen.**

| Krav | Funn | Ev. |
|------|------|-----|
| Flyt til en mottakerkvote | `studiekvote` har **ett** sett flyt-kolonner — bekreftet, en mottaker | M |
| Kan ikke krysse utdanningstilbud | Flyt-FK-en gjenbruker kildens org/utdanning/periode — strukturelt umulig | M |
| Flyt fra en tidligere plasstildeling | Modellen kan peke paa en annen runde/tildeling, men **koden bruker det ikke** | M+V |
| Plassflyt opererer innenfor en tildeling | `Opptakskjoringsalgoritme` bygger flytkart (`buildFlyterFraKvote`/`buildFlyterTilKvote`) og omfordeler innenfor en kjoering | V |
| Mellom runder: `basert_pa`-kjeden | Resultater viderefores via `basert_pa`, ikke plassflyt | V |
| Plassflyt kan endres per tildeling | Tre nivaaer: `regelverk.kvotetype` -> `opptak.kvote` -> `studiekvote` | M |
| Sistekvote (stopper flyten) | NULL i flyt-kolonnene | M |
| Sirkulaeritetsvern i koden | `findPaafyllingsStudiekvoter` og `finnKvoterSomFlyterTil` bruker visited-sett, logger `warnf("Cycle detected...")` | V |
| Sirkulaeritetsvern i skjemaet | **Ingen CHECK-constraint eller trigger** — feilkonfigurert oppsett kan skape en syklus uten aa bli stoppet | V |
| Test for sirkularitet | `testCircularPlassflytDoesNotHang` bekrefter at algoritmen haandterer sykler | V |

**Konklusjon (revidert):** Plassflyt opererer kun innenfor en plasstildeling. Kryss-tildeling-kolonnene i modellen brukes ikke av koden. Omfanget for plassflyt er dermed **mindre enn antatt**: det handler om aa konfigurere flyt mellom kvoter i en enkelt kjoering, ikke om aa bygge ny funksjonalitet for kryss-tildeling-flyt. Sirkularitetsvernet finnes i koden men ikke i databasen — en operatoerfeil kan skape en syklus som algoritmen tolererer men som gir feil resultat.

**Saker:** **Hull.** Ingen sak paa sirkulaeritetsvern i databasen, ingen paa validering av plassflyt-konfigurasjon.

### Oppgave 4 — Starte en ny plasstildeling

| Krav | Funn | Ev. |
|------|------|-----|
| Bygge paa forrige publiserte tildeling | `plasstildeling.*_basert_pa` — arven er modellert. `OpprettPlasstildelingService` finner grunnlaget automatisk | M+V |
| Kjoerer automatisk i bakgrunnen | `plasstildelingsstatus` med default `'KLAR'`, egen kodetabell | M |
| Beregning skilt fra publisering | `plasstildeling.publiseres` (boolean) | M |
| Kjoere om / avbryte en feilet tildeling | **TAKE-166 "Reaper for plasstildelinger som blir staaende STARTET etter krasj" er Won't do** | S |
| Se at en tildeling feilet | TAKE-151 "Eksponer plasstildelingsstatus og feilmelding i GraphQL" er To Do | S |

De to siste radene haenger sammen: en krasjet kjoering blir staaende, og statusen er ikke synlig utenfra. TAKE-166 er aktivt avvist — det er en **beslutning**, ikke et hull.

**Saker:** [#108](https://github.com/sikt-no/fs/issues/108) (lukket). TAKE-150 (In Review), TAKE-151 (To Do), TAKE-166 (Won't do), TAKE-137 (Won't do).

### Oppgave 5 — Gjennomfoere plasstildeling

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Poenggrense per kvote lagres | `plasstildeling.poenggrense` tabell finnes | **Tabellen populeres ikke av koden.** `PlasstildelingSkriveService` har tre skriveoperasjoner (studiekvoter, kvotesoknader, resultater) — ingen for poenggrense. `slettForPlasstildeling` sletter poenggrense-rader (FK-rekkefoelge), men ingenting skriver nye | M+V |
| Poenggrense vist til soker er riktig | TAKE-265 "Poenggrenser tar med upubliserte/feilede kjoeringer" | Kjent feil, men tabellen er tom uansett | S+V |
| Rangering hentes fra soknadsbehandlingen | `kvotesoknad` med `rangering`, `poengsum`, `prioritet`, `har_tilbudsgaranti`, `svartype_kode` | Ingen | M |
| Endret soknad fanges opp mellom runder | TAKE-165 "Avklar om snapshot skal lagre alle resultater" | Aapen avklaring | S |
| Soker som mister kvalifisering faar avslag | TAKE-282 + TAKE-159 (les/skriv-asymmetri) | Se under | S |
| Tilbudsgaranti fra markert kvote | `opptak.tilbudsgaranti_kvote` | Ingen | M |
| Kvoteprioritet | Tre nivaaer: `kvotetype` -> `kvote` -> `studiekvote` | Ingen | M |
| **Poenglikhetsregel koblet til opptaket** | `regelverk.kvotetype.kvoterangering` -> `regelverk.kvoterangering` | Regelen haenger paa **kvotetype**, ikke opptak. TAKE-274 avklarer nettopp dette | M |
| Fire poenglikhetsregler | TAKE-135 (Done) | To av fire ser ut til aa vaere dekket | S |

**Verifisert i koden:** Poenggrense-beregning er designet i skjemaet men **ikke implementert**. Hele tabellen er tom. TAKE-265 (poenggrenser tar med feilede kjoeringer) er et reelt problem, men foerst naar noen skriver til tabellen. Dette er en **ny feature**, ikke en feilretting.

**Hypotese (uendret):** "Soker forsvinner stille" og "kansellert vises i stedet for tilbudet" peker begge mot TAKE-282/TAKE-159 (resultattype-kollaps). Koden maa gjennomgaas mer detaljert for aa bekrefte endelig.

**Saker:** [#71](https://github.com/sikt-no/fs/issues/71), [#92](https://github.com/sikt-no/fs/issues/92) (lukket). TAKE-125, TAKE-135, TAKE-159, TAKE-165, TAKE-265, TAKE-274, TAKE-278–284.

### Oppgave 6 — Vise resultatet til saksbehandler

| Krav | Funn | Ev. |
|------|------|-----|
| Tilbud / venteliste med nummer / avslag | `plasstildelingsresultat` med `svartype_kode`, `ventelistenummer`, `plasstildelingsresultat_type_kode` | M |
| Spore plass via plassflyt | `plasstildelingsresultat.plass_fra_kvotetype_kode` med FK | M |
| Ventelistenummer er entydig | **Ingen unikhetsskranke** — TAKE-280 | M+S |
| Vis ventelistenummer til soker | `utdanningstilbud.vis_ventelistenummer_for_soker` (default false) | M |
| Vis poenggrense til soker | `utdanningstilbud.vis_poenggrense_for_soker` (default false) | M |

Resultatet finnes **to steder**: per tildeling i `plasstildeling.plasstildelingsresultat` og denormalisert paa `soknad.soknadsalternativ`. Mulig kilde til inkonsistens.

**Saker:** [#109](https://github.com/sikt-no/fs/issues/109) (lukket). TAKE-63, TAKE-64 (Blokkert), TAKE-65. **Hull:** Ventelistenummer til soker har ingen sak.

### Oppgave 7 — Publisere resultatet

| Krav | Funn | Ev. |
|------|------|-----|
| Kontroll over publiseringstidspunkt | `plasstildeling.publiseres` + `opptaksrunde.publiseringstidspunkt` | M |
| Vedtak med begrunnelse | Haenger paa poenggrense-gapet i oppgave 5 — tabellen er tom | M+V |
| **Melding om vedtak til soker** | `soknad.sokermelding` med FK til `kommunikasjon.melding` og `opptaksrunde` — roeret finnes | M |
| Arv av svartype ved publisering | TAKE-156 "Avklar arving av svartype", To Do | S |

Meldingskravet haenger sammen med #221 Vedtaksbrev og #72 Fatte vedtak.

**Saker:** [#111](https://github.com/sikt-no/fs/issues/111), [#72](https://github.com/sikt-no/fs/issues/72), [#221](https://github.com/sikt-no/fs/issues/221). TAKE-156, TAKE-217 (Done).

### Oppgave 8 — Haandtere svar fra soker

| Krav | Funn | Ev. |
|------|------|-----|
| Soker svarer ja/nei innen frist | `soknad.opptakssvar` per soker, alternativ og runde | M |
| Svar knyttes til riktig runde | PK **uten** `opptaksrundetype_kode` — TAKE-148 (Done) vs. TAKE-284 (To Do) | M+S |
| Fristsjekk | TAKE-281 "Fristsjekk bruker applikasjonsklokke" | S |
| Trukket ja frigjoer plassen | **Ingen kolonne** for trekk/frigjoering i `opptakssvar` | M |
| Manuell overstyring | `soknadsalternativ` har skrivbare resultattype-kolonner + `skal_spesialbehandles` | M |

**Saker:** [#170](https://github.com/sikt-no/fs/issues/170) + [#175](https://github.com/sikt-no/fs/issues/175) (duplikat), [#264](https://github.com/sikt-no/fs/issues/264), [#512](https://github.com/sikt-no/fs/issues/512). TAKE-141, TAKE-148 (Done), TAKE-284.

## Kjernetjenester i koden

Verifisert i `fs-plattform/opptak`:

| Tjeneste | Ansvar |
|----------|--------|
| `KvoterService` | Leser kvotekonfigurasjon (kapasitet, prioritet, plassflytmaal) for en opptaksrunde. Loeser opp overstyringer. Maaltall: `overbook_antall_plasser` med fallback til `onsket_antall_deltakere` |
| `KvotesumService` | Beregner beste poengscore per soker per kvotetype — input-forberedelse, ikke selve tildelingen |
| `OpprettPlasstildelingService` | Oppretter ny plasstildeling-rad med status KLAR, finner `basert_pa`-grunnlaget automatisk |
| `Opptakskjoringsalgoritme` | Selve tildelingsalgoritmen. Bygger flytkart, omfordeler plasser innenfor en kjoering |
| `PlasstildelingSkriveService` | Tre skriveoperasjoner: studiekvoter, kvotesoknader, resultater. **Ikke** poenggrense |

## Mistenkte feil (TAKE-278 undersaker)

| Sak | Feil | Treffer oppgave |
|-----|------|-----------------|
| [TAKE-279](https://sikt.atlassian.net/browse/TAKE-279) | Bortfallsgrensen regnes mot feil tilbud naar soker har flere tilbud | 5 |
| [TAKE-280](https://sikt.atlassian.net/browse/TAKE-280) | Ventelistenummer-kollisjon mellom viderefoerte og nye ventelisterader | 6 |
| [TAKE-281](https://sikt.atlassian.net/browse/TAKE-281) | Fristsjekk bruker applikasjonsklokke i stedet for databaseklokke | 8 |
| [TAKE-282](https://sikt.atlassian.net/browse/TAKE-282) | Historiske resultater leses tilbake med feil resultattype (kollaps til IKKE_GYLDIG) | 5 |
| [TAKE-283](https://sikt.atlassian.net/browse/TAKE-283) | Harde tallgrenser (9999/99) feller hele kjoeringen | 4 |
| [TAKE-284](https://sikt.atlassian.net/browse/TAKE-284) | Sokers svar knyttes til runde paa loepenummer alene, uten rundetype | 8 |

Alle staar **To Do**, ingen har prioritet over Trivial.

## Saksoversikt — hull og uoverensstemmelser

| Omraade | GitHub | Jira | Vurdering |
|---------|--------|------|-----------|
| Oppgave 2: Sette antall tilbud | Ingen sak | TAKE-140 (kun lesesiden) | **Hull** |
| Oppgave 3: Plassflyt-validering | Ingen sak | Ingen egen | **Hull** — sirkularitetsvern kun i kode, ikke i DB |
| Oppgave 5: Poenggrense-beregning | Ingen sak | Ingen | **Hull** — tabell finnes, koden skriver ikke til den |
| Oppgave 6: Ventelistenr. til soker | Ingen sak | Ingen | **Hull** |
| Tvers: Tilgang per organisasjon | Ingen | TAKE-266, -293, -294, -237 | Kun Jira |
| Avgrensning: Frafallskompensasjon | Ingen | Ingen | **Hull** — boer registreres |
| GitHub vs Jira status | #71, #92, #107-109 lukket | TAKE-3 To Do, TAKE-125 In progress | **Uoverensstemmelse** |
| Duplikater | #170 / #175 | — | Boer ryddes |

## Tre funn i saksbildet som er verdt en beslutning

1. **GitHub og Jira er uenige om status.** Paa GitHub er #71, #92, #107, #108 og #109 alle **lukket**. I Jira er TAKE-3 (Epic) **To Do**, TAKE-125 **In progress**, og TAKE-74 **In progress**. GitHub-siden sier at plasstildeling er levert, Jira-siden at den ikke er det.

2. **Initiativet paa GitHub har ingen undersaker.** [#216 "Ferdigstilling av plasstildeling i opptak"](https://github.com/sikt-no/fs/issues/216) er merket `initiativ`, ligger i milestone "2026 Fremtidens opptak" — og har **null sub-issues**. De aatte oppgavene i raffineringen er den naturlige undersaksstrukturen.

3. **To duplikatpar boer ryddes:** #170 og #175 ("Soker svarer paa tilbud"), og #511 og #265 ("Koble spesielle opptakskrav til kvoter").

## Neste steg

- [x] Verifisere gap-analysen mot GitLab-koden (de 5 aapne spoersmaalene)
- [ ] Bryte ned i leveranser med avhengigheter
- [ ] Opprette Jira Stories under TAKE-3
- [ ] Koble GitHub #216 til undersakene