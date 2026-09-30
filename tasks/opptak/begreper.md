# Begrepsliste — Opptak

Siste oppdatering: 2026-09-30

Denne listen sammenstiller begreper brukt i kravene (`krav/02 Opptak/`), design-filene og begrepskatalogen på [fs.sikt.no](https://fs.sikt.no/domenekunnskap/begreper/). Målet er konsistent begrepsbruk på tvers av krav, kode, API og brukergrensesnitt.

**Leseforklaring:**
- **Krav** = begrep slik det brukes i `.feature`-filer under `krav/02 Opptak/`
- **Begrepskatalog** = definisjon fra [fs.sikt.no/domenekunnskap/begreper/](https://fs.sikt.no/domenekunnskap/begreper/)
- **Gammel FS** = begrep fra fellesstudentsystem.no (nåværende FS-klient)
- ⚠️ = inkonsistens eller avvik mellom krav og begrepskatalog

## Aktører

| Begrep i krav | Begrepskatalog | Merknad |
|---------------|---------------|---------|
| opptaksforvalter | – | Ny rolle i nytt opptak. Ikke i begrepskatalogen enda |
| opptaksforvalter ved forvaltende organisasjon | – | Spesifisering av opptaksforvalter |
| opptaksforvalter ved deltagende organisasjon | – | Spesifisering av opptaksforvalter |
| saksbehandler | – | Brukes generelt i kravene; bør presiseres |
| søker | [søker](https://fs.sikt.no/domenekunnskap/begreper/soker/) | OK |

## Opptak og struktur

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| opptak | – | Opptak | Mangler i begrepskatalogen |
| samordna opptak | – | NOM-opptak | ✅ Avklart: «samordna opptak» er riktig form (offisielt navn). Krav som bruker «samordnet» bør rettes |
| lokalt opptak | – | Lokalt opptak | OK |
| opptakstype | [opptakstype](https://fs.sikt.no/domenekunnskap/begreper/opptakstype/) | Opptakstype | OK. Definisjon: «Kategorisering av opptak med utdanningstilbud som har relativt like opptaksregler» |
| tidlig opptak | – | Tidligopptak | ✅ Avklart: «tidlig opptak» (to ord) er riktig |
| forvaltende organisasjon | – | – | Ny term. Organisasjonen som forvalter/eier opptaket |
| deltakende organisasjon | – | – | ✅ Avklart: «deltakende» er riktig. Krav som bruker «deltagende» bør rettes |
| lærested | [lærested](https://fs.sikt.no/domenekunnskap/begreper/larested/) | Institusjon / Lærested | OK |
| organisasjon | – | Institusjon | Nytt generelt begrep som erstatter «institusjon» (se `krav/README.md` terminologi) |

## Utdanningstilbud og søknad

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| utdanningstilbud | [utdanningstilbud](https://fs.sikt.no/domenekunnskap/begreper/utdanningstilbud/) | Opptaksstudieprogram | OK. Merknad i katalogen: «Valgte/prioriterte utdanningstilbud i ett opptak, kalles søknadsalternativ» |
| søknad | [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | Søknad | OK. Tilstandsdiagram i katalogen |
| søknadsalternativ | [søknadsalternativ](https://fs.sikt.no/domenekunnskap/begreper/soknadsalternativ/) | Søknadsalternativ | OK. Definisjon: «Representasjon av søkers valgte og eventuelt prioriterte utdanningstilbud i en søknad» |
| påbegynt søknad | – | – | ✅ Avklart: «påbegynt søknad» er riktig, ikke «søknadskladd». Krav som bruker «søknadskladd» bør rettes |
| studierett | – | Studierett | Mangler i begrepskatalogen |

## Regelverk

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| regelverkssamling | [regelverkssamling](https://fs.sikt.no/domenekunnskap/begreper/regelverkssamling/) | – | OK (utkast). «En samlet pakke med opptaksregelverk» |
| opptaksregelverk | [opptaksregelverk](https://fs.sikt.no/domenekunnskap/begreper/opptaksregelverk/) | – | OK (utkast). «Samlebegrep for reglene som avgjør kvalifisering og rangering» |
| kompetansekrav | [kompetansekrav](https://fs.sikt.no/domenekunnskap/begreper/kompetansekrav/) | Kompetansekrav | ✅ Avklart: Krav til søkers kompetanse for å bli regnet som kvalifisert. Sjekkes mot kompetanseregelverket |
| kompetanseregelverk | – | Kompetanseregelverk | ✅ Avklart: Eget begrep — regelverket som brukes for å sjekke om søker møter kompetansekravene. Ikke det samme som «kompetansekrav» |
| rangeringsregelverk | [rangeringsregelverk](https://fs.sikt.no/domenekunnskap/begreper/rangeringsregelverk/) | Rangeringsregelverk | OK (utkast). «Regler som bestemmer hvordan kvalifiserte søkere rangeres» |
| opptakskrav | [opptakskrav](https://fs.sikt.no/domenekunnskap/begreper/opptakskrav/) | – | OK (utkast). «Kombinasjonen av kompetansekrav og rangeringsregelverk» |
| kravelement | – | Kravelement | Finnes i kravene og gammel FS, mangler i begrepskatalogen |
| grunnlag | – | Kvalifikasjonsgrunnlag | ✅ Avklart: «Grunnlag» kan henvise til to ting: **kvalifikasjonsgrunnlag** (de konkrete kompetansekravelementene en søker oppfyller for å regnes som kvalifisert) eller **rangeringsgrunnlag** (de konkrete rangeringselementene brukt på en søker for å utlede rangeringspoeng). Konteksten avgjør |

## Kvoter

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| kvote | [kvote](https://fs.sikt.no/domenekunnskap/begreper/kvote/) | Kvote | OK (aktiv). «Begrensning på tilgang til utdanningstilbud som forfordeler noen søkergrupper» |
| utdanningskvote | – | – | ✅ Avklart: «utdanningskvote» er riktig. En kvote knyttet til et utdanningstilbud i et opptak |
| kvotetype | – | Kvotetype | Finnes i gammel FS, mangler i begrepskatalogen |
| kvotespørsmål | – | Kvotespørsmål | Finnes i gammel FS, mangler i begrepskatalogen |
| plassflyt | – | Plassflyt / Kvotetilh plassflyt | ✅ Avklart: «plassflyt» er riktig. Avvikle «kvoteflyt» |

## Poengberegning og rangering

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| poengberegning | – | Poengberegning | OK |
| poengsum | – | Poengsum | OK |
| poenggrense | – | Poenggrense | OK |
| poengklasse | – | Atomiskpoengklasse | ✅ Avklart: «poengklasse» er riktig. Dropp «atomisk»-prefikset |
| poengvariant | – | Atomiskpoengtype | ⚠️ Kravene bruker «poengvariant», gammel FS har «atomisk poengtype» |
| poenglikhetsregel | [poenglikhetsregel](https://fs.sikt.no/domenekunnskap/begreper/poenglikhetsregel/) | Rangeringslikhetstype | OK. I begrepskatalogen, referert fra rangeringsregelverk |
| karakterpoeng | – | KAR | OK. Poengklasse KAR i gammel FS |
| skolepoeng | – | SKO | OK |
| konkurransepoeng | – | – | Samlebegrep for sum av alle poeng i en kvote |
| alderspoeng | – | ALD | OK |
| kjønnspoeng | – | – | OK |
| realfagspoeng | – | REA | OK |
| språkpoeng | – | SPR | OK |
| rangering | – | Rangering | OK |

## Plasstildeling

| Begrep i krav | Begrepskatalog | Gammel FS | Merknad |
|---------------|---------------|-----------|---------|
| plasstildeling | [plasstildeling](https://fs.sikt.no/domenekunnskap/begreper/plasstildeling/) | Opptakskjøring | OK (utkast). Erstatter «opptakskjøring» |
| plasstildelingsrunde | – | Kvoterunde / Opptaksrunde | ✅ Avklart: «plasstildelingsrunde» er riktig term |
| rundetype | – | – | Kravene nevner: Hovedtildeling, Supplering, Etterfylling, Ledige studieplasser |
| svar på søknad | – | – | Resultat av plasstildeling. Én av tre former: tilbud (om plass), ventelisteplass eller avslag |
| tilbud | – | Tilbud | Svar på søknad: søker får tilbud om studieplass |
| ventelisteplass | [venteliste](https://fs.sikt.no/domenekunnskap/begreper/venteliste/) | Venteliste | Svar på søknad: søker får plass på venteliste |
| avslag | – | Avslag | Svar på søknad: søker får ikke tilbud |
| opprykk | – | – | Søker rykker opp fra venteliste til tilbud |
| bortfall | – | Bortfall | Tilbud på lavere prioritet faller bort |
| svarfrist | – | Svarfrist | OK |
| antall plasser | [antall plasser](https://fs.sikt.no/domenekunnskap/begreper/antall_plasser/) | Tilbud ønsket / Tilbud maks | OK |

## Frister og datoer

| Begrep i krav | Begrepskatalog | Merknad |
|---------------|---------------|---------|
| søknadsfrist | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| dokumentasjonsfrist | – | OK |
| omprioriteringsfrist | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| ettersendingsfrist | Referert i [søknad](https://fs.sikt.no/domenekunnskap/begreper/soknad/) | OK |
| frist for poenggrenser | – | Ny i kravene, for tidlig opptak |
| publiseringsdato | – | OK |
| informasjonsdato | – | OK |

## Kvalifisering og vurdering

| Begrep i krav | Begrepskatalog | Merknad |
|---------------|---------------|---------|
| kvalifisering / kvalifisert | – | Prosessen der kompetansekrav sjekkes |
| generell studiekompetanse (GSK) | – | OK. Gammel FS: GSK |
| realkompetanse | – | OK |
| fagprofil | – | Gammel FS: Fagprofil. Søkerens registrerte fag og karakterer |
| utdanningsbakgrunn | – | ⚠️ Brukes i kravene for frister. Relatert til «kvalifikasjonsgrunnlag» i gammel FS, men bredere |
| praksis / praksisperiode | – | OK |

## Søknadsbehandling

| Begrep i krav | Begrepskatalog | Merknad |
|---------------|---------------|---------|
| saksbehandling | – | OK |
| vedtak / vedtaksbrev | – | OK |
| mangelkode | – | Gammel FS: Kompetansemangler (SFA, SNU, SÆR) |

---

## Avklarte begrepsvalg

Følgende begreper er avklart og standardisert (2026-09-30):

| # | Riktig begrep | Feil / utdatert | Handling |
|---|--------------|-----------------|----------|
| 1 | samordna opptak | samordnet opptak | Rett i kravene der «samordnet» brukes |
| 2 | deltakende organisasjon | deltagende organisasjon | Rett i kravene der «deltagende» brukes |
| 3 | tidlig opptak | tidligopptak | Skrives som to ord |
| 4 | påbegynt søknad | søknadskladd | Rett i kravene der «søknadskladd» brukes |
| 5 | utdanningskvote | studiekvote | «Utdanningskvote» er vår term |
| 6 | kompetansekrav / kompetanseregelverk | – | To ulike begreper: **kompetansekrav** = krav til søkers kompetanse for å bli kvalifisert. **Kompetanseregelverk** = regelverket som brukes for å sjekke om søker møter kravene |
| 7 | plasstildelingsrunde | opptaksrunde, runde | Kravene bruker allerede riktig term |
| 8 | grunnlag (kvalifikasjons- / rangerings-) | – | «Grunnlag» kan henvise til: **kvalifikasjonsgrunnlag** (de konkrete kompetansekravelementene en søker oppfyller for å regnes som kvalifisert) eller **rangeringsgrunnlag** (de konkrete rangeringselementene brukt på en søker for å utlede rangeringspoeng) |
| 9 | plassflyt | kvoteflyt | Avvikle «kvoteflyt» |
| 10 | poengklasse | atomisk poengklasse | Dropp «atomisk»-prefikset |

---

## Begreper som mangler i begrepskatalogen

Følgende begreper brukes i kravene, men finnes ikke (enda) i begrepskatalogen på fs.sikt.no:

- opptak (selve begrepet)
- opptaksforvalter (ny rolle)
- forvaltende organisasjon / deltakende organisasjon
- studierett
- tidlig opptak
- kravelement
- kvotetype
- kvalifikasjonsgrunnlag (som eget begrep)
- plasstildelingsrunde
- rundetype (Hovedtildeling, Supplering, Etterfylling, Ledige studieplasser)
- bortfall, opprykk
- utdanningsbakgrunn (i kontekst av frister)