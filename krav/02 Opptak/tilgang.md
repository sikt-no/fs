# Tilgang i opptak

Siste oppdatering: 2026-11-10

Denne siden viser hvem som ser og endrer hva i opptak, og hvilket krav som beskriver regelen. Selve reglene står i kravene (`.feature`-filene) og er tagget `@tilgang`. Står det noe her som ikke står i et krav, er det kravet som mangler.

Grunnlaget er spec-en «Krav til RLS» (regel R1–R16), avklaringsmøtet 2026-11-10 og rolleforslaget 2026-10-12.

## Slik leser du siden

En persons tilgang i et opptak avhenger av to ting:

1. **Brukerrollen** personen har ved organisasjonen sin. Den tildeles ut fra arbeidsoppgavene, ikke per opptak.
2. **Organisasjonens rolle i opptaket.** En organisasjon kan forvalte noen opptak, delta i andre og ikke være med i resten.

### Organisasjonens rolle i opptaket

| Rolle | Betyr | Eksempel i samordna opptak |
|---|---|---|
| **forvalter** | Organisasjonen som forvalter (eier) opptaket | HK-dir |
| **tilbyder** | Organisasjonen som tilbyr utdanningstilbudet et søknadsalternativ gjelder | NTNU tilbyr Sykepleie |
| **behandler** | Organisasjonen som saksbehandler et søknadsalternativ | UiO behandler søknadsalternativet til Sykepleie ved NTNU |

I et lokalt opptak er én organisasjon forvalter, tilbyder og behandler. En organisasjon som ikke er forvalter, tilbyder eller behandler, har ingen tilgang til opptaket før det er publisert, og bare til det publiserte etterpå.

### Brukerroller

| Brukerrolle | Rolle i tilgangsstyring | Gjør |
|---|---|---|
| **opptaksforvalter** | OPPTAK_FORVALTER, med handlingskoden MODIFISERE_REGELVERK | Forvalter opptak og utdanningstilbud, og oppretter og administrerer regelverket for organisasjonen. Handler på søkerens vegne når organisasjonen er forvalter |
| **saksbehandler** | OPPTAK_SAKSBEHANDLER | Behandler søknader når organisasjonen er behandler. Har innsyn når organisasjonen er tilbyder |
| **dokumentforvalter** | OPPTAK_DOKUMENTASJON | Laster opp og sletter dokumentasjon på søkerens vegne når organisasjonen er forvalter |
| **bruker med OPPTAK_INNSYN** | OPPTAK_INNSYN | Svarer søkere. Ser, men endrer ingenting |

Andre aktører: **søker**, **bruker uten tilganger** (innlogget uten roller, også integrasjoner uten roller), **integrasjon** (maskinbruker med roller) og **Sikt-brukerstøtte**.

⚠️ «Forvalter» (organisasjonens rolle) og «opptaksforvalter» (brukerrollen) er ikke det samme. En opptaksforvalter ved NTNU er opptaksforvalter ved en organisasjon som er tilbyder i Samordna opptak, men forvalter i NTNUs lokale opptak.

## Grunnregler

- **Ingenting er åpent uten en regel.** Data er bare tilgjengelige når en tilgangsregel sier det.
- **Tilgangen styres i API-et, ikke bare i skjermbildene.** En integrasjon får aldri mer enn de ansatte ved samme organisasjon får i FS Admin med de samme rollene. Eksempel: Politihøgskolens opptakssystem henter søkerne til Politihøgskolen, ikke andre søkere.
- **Handlingen må gjelde ved organisasjonen.** En rolle ved UiO gir ingenting i et opptak der UiO verken er forvalter, tilbyder eller behandler.
- **Intern eller delt.** Merknader, mangler og meldinger er delt med forvalter, tilbyder og behandler på søknaden, med mindre organisasjonen har merket dem som interne. Interne ses bare av organisasjonen som registrerte dem.

## Hvem ser og endrer hva

Status: ✅ står i kravet · 🟡 står delvis · ❌ mangler · ✏️ kravet må rettes

| Data | Hvem ser | Hvem endrer | Krav | Status |
|---|---|---|---|---|
| **Opptak og innstillinger** | Forvalter: alt. Tilbyder og behandler: frister og innstillinger. Alle andre: det som er publisert | Opptaksforvalter hos forvalter. Ingen når opptaket er deaktivert | `@OPT-OVO-SAM-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-GRU-001` | 🟡 Deaktivert opptak og brukere uten tilganger mangler (R7, R14, R15) |
| **Utdanningstilbud og kvoter** | Forvalter: alle. Tilbyder: tilbudene den tilbyr. Behandler: krav, poeng og kvoter på tilbudene den behandler. Alle andre: etter publisering | Opptaksforvalter hos forvalter: alle. Opptaksforvalter hos tilbyder: tilbudene organisasjonen tilbyr, innen fristene | `@OPT-OPT-UTD-001`, `@OPT-OPT-UTD-002`, `@OPT-OPT-UTD-004` | 🟡 Behandlerens lesing mangler (R8) |
| **Regelverk** | Opptaksforvaltere, saksbehandlere og brukere med OPPTAK_INNSYN: alt regelverk. Regelverket ved brukerens organisasjon vises først. Søkere og brukere uten tilganger: ikke | Bruker med MODIFISERE_REGELVERK (opptaksforvalter) ved organisasjonen som eier regelverkssamlingen. Kopierer bare til organisasjonen brukeren er ansatt ved | `@OPT-REG-SAM-001`, `@OPT-REG-SAM-002` (PR 996) | ✏️ PR 996 må få med OPPTAK_INNSYN og sorteringen (R9) |
| **Personopplysninger** | Forvalter, tilbyder og behandler: personer med en søknad de har tilknytning til. Fortrolig adresse: bare søkeren | Kommer fra Folkeregisteret og KRR. Søkeren eller opptaksforvalter hos forvalter endrer bare for personer som ikke finnes der | – | ❌ (R2) |
| **Personsøk uten søknad** | Opptaksforvalter hos forvalter, for å opprette søknad. Viser det samme som for en søker med søknad, men ikke fortrolig adresse | – | `@OPT-SØK-SØK-002` (`@skip`) | ❌ (R2) |
| **Søknad** | Forvalter, tilbyder og behandler: hele søknaden, også de andre alternativene | Søkeren: fram til plasstildeling. Opptaksforvalter hos forvalter: på søkerens vegne | `@OPT-SØK-SØK-008`, `@OPT-SØK-SØK-009`, `@OPT-BEH-BEH-011` | 🟡 Handling på søkerens vegne mangler (R1, R12) |
| **Dokumentasjon** | Som søknaden. Innsyn logges | Søkeren: kort tid etter opplasting. Dokumentforvalter hos forvalter: på søkerens vegne | `@OPT-BEH-DOK-001`, `@OPT-BEH-BEH-001` | ✏️ `behandle_søknad` sier at saksbehandleren laster opp (R4) |
| **Politiattest** | Innholdet: behandler, og tilbyder etter at søkeren har takket ja. Andre ser bare at den er levert | Søkeren | – | ❌ (R4) |
| **Sak: vurdering, poeng, kvalifisering, praksiskalkulator** | Forvalter, tilbyder og behandler, også behandlere av andre alternativer på samme søknad | Saksbehandler hos behandler | `@OPT-BEH-BEH-011`, `@OPT-BEH-BEH-004` | ✏️ `@OPT-BEH-BEH-004` sier at poeng fra andre saker ikke vises (R3) |
| **Tilbudsgaranti** | Som saken | Saksbehandler hos behandler eller tilbyder. Forvalterens tilbudsgaranti settes bare maskinelt | `@OPT-BEH-BEH-010` | 🟡 (R3) |
| **GSK-konklusjon** | Alle som har tilknytning til en av søkerens søknader. Én per søker, på tvers av opptak | Saksbehandler hos alle behandlere av søkerens søknader. Endringen logges | `@OPT-BEH-BEH-042` (PR 1003) | ✏️ Må inn i PR 1003 |
| **Merknader** | Delte: forvalter, tilbyder og behandler. Interne: bare organisasjonen som skrev dem. Søkeren: ingen | Organisasjonen som skrev merknaden | – | ❌ (R6) |
| **Mangler** | Som merknader. Søkeren ser delte mangler når de er publisert | Saksbehandler hos behandler | `@OPT-BEH-BEH-008` | ✏️ Skillet mellom interne og delte mangler mangler |
| **Meldinger til søker** | Søkeren: alle meldinger til søkeren. Forvalter, tilbyder og behandler: delte meldinger, og interne meldinger organisasjonen har sendt. Delt er standard | Søkeren kan ikke endre. Avsenderen velger per melding om den er intern | `@OPT-SØK-SØK-010`, `@OPT-OVO-TEK-001` | ❌ (R5) |
| **Resultat av plasstildeling** | Forvalter: alt. Saksbehandler hos tilbyder og behandler: tilbudene og sakene organisasjonen har, også før publisering. Brukere med OPPTAK_INNSYN og søker: etter publisering. Søkertall følger det samme | Opptaksforvalter hos forvalter kjører og publiserer | `@OPT-PLA-RES-001`, `@OPT-PLA-RES-002`, `@OPT-PLA-RES-003` | ✏️ `@OPT-PLA-RES-003` sier at saksbehandler ikke ser resultatet før publisering (R10) |
| **Poenggrenser** | Forvalter, tilbyder og behandler: hele tiden. Søker og brukere uten tilganger: etter publisering, når tilbudet viser den. Tidlig opptak: tilbydere ser ikke hverandres | Tidlig opptak: tilbyder innen fristen. Opptaksforvalter hos forvalter: alltid | `@OPT-OPT-UTD-004`, `@OPT-OPT-UTD-029` | 🟡 (R11) |
| **Tekster til søkere** | Opptaksforvalter og saksbehandler hos forvalter, tilbyder og behandler, for søkere organisasjonen har ansvar for | Opptaksforvalter hos forvalter: alle. Tilbyder og behandler: tekster som gjelder det de tilbyr eller behandler | `@OPT-OVO-TEK-001` | ❌ (R16). Generiske tekster er ikke avklart |
| **Endringslogg** | Som det loggen gjelder. Søkeren ser hvilken organisasjon, ikke navnet på saksbehandleren | Ingen | `@OPT-OVO-LOG-001`, `@OPT-BEH-BEH-016`, `@OPT-OPT-UTD-019` | ❌ (R13) |
| **Uttrekk av sakslista** | Saksbehandler og opptaksforvalter, for sakene de ser. Ikke brukere med OPPTAK_INNSYN. Brukeren oppgir formål og bekrefter sikker lagring. Fødselsnummer bare når brukeren velger det | – | – | ❌ |

## Aktører med egne krav

| Aktør | Regel | Krav | Status |
|---|---|---|---|
| **Bruker med OPPTAK_INNSYN** | Ser søknad og behandling der organisasjonen er forvalter, tilbyder eller behandler. Endrer ingenting | `@OPT-BEH-BEH-043` (`se_søknader_med_opptak_innsyn.feature`) | ❌ Nytt |
| **Bruker uten tilganger** | Bare det som er publisert: opptak, utdanningstilbud, frister og studieplasser når opptaket er publisert, poenggrenser når plasstildelingen er publisert | – | ❌ (R15) |
| **Integrasjon** | Som en person med de samme rollene ved samme organisasjon | – | ❌ |
| **Sikt-brukerstøtte** | Innsyn på tvers av organisasjoner for feilsøking, få navngitte ansatte, innsynet logges | – | ❌ Eget spor |

## Åpent

- Hvem ser og endrer generiske tekster (som ikke gjelder bestemte søkere)
- Testbrukere
- Hvordan fortrolig adresse følger med når søkeren blir student
