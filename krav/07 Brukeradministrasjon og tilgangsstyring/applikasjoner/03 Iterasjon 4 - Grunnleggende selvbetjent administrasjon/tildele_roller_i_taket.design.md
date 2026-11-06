# Implementasjonsdetaljer: Forvalte roller i taket til en Feide-applikasjon

**Relatert feature:** [`tildele_roller_i_taket.feature`](./tildele_roller_i_taket.feature)

## Overordnet UI-mønster

En egen fane for taket på detaljsiden for applikasjonen, ved siden av fanen for tilganger. Fanen vises bare for Feide-applikasjoner. Tildeling og fjerning følger dialogene for roller på personbrukere (`TildelRolleAction` og `FjernRolleAction` i FS Admin): organisasjon, miljø og roller i kaskade.

## Komponenter og layout

- **Listen:** rolle, organisasjon, miljø, gyldighetstidsrom, og om taket gjelder organisasjonen selv eller kommer fra en organisasjonssamling.
- **Tildel-dialogen:** valgliste for organisasjon, valgliste for miljø og flervalgsliste for roller, som «Tildel roller» for personbrukere ([`tildele_roller.design.md`](../../12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.design.md)).
- **Fjern-dialogen:** som «Fjern roller» for personbrukere (BRU-PER-GRU-012).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Delvis suksess | Som ved tildeling av roller til personbrukere (BRU-PER-GRU-003): de gyldige tildelingene gjennomføres, og dialogen viser hvilke som ikke ble gjennomført, og hvorfor |

## Tekster

Ingen tekster med variasjoner er bestemt ennå.

**Skisser:** Det finnes ingen skisser for fanen.

## Per-scenario detaljer

### Regel: Fanen for taket viser rollene i taket til applikasjonen som gjelder nå

- Et tak gjelder nå når gyldighetsperioden inneholder tidspunktet nå, og taket ikke er ugyldiggjort (jf. `tildele_roller.design.md` for personbrukere).
- Tak som er avsluttet eller starter senere, filtreres bort i spørringen (filteret `erAktivNaa` på `brukerdelegeringer`), ikke med RLS, slik som for personbrukere og applikasjoner.
- Gyldighetstidsrommet vises med dato, som i rollelisten for personbrukere (`formatGyldighetstidsrom` i `PersonbrukerRollerResultList`): «01.05.2026 –», «– 01.08.2026», «01.05.2026 – 01.08.2026», og ingen verdi uten tidsbegrensning. Gyldighetsperioden kan ikke settes i fanen.

### Regel: Tak for en organisasjonssamling vises som tak for hver organisasjon i samlingen

Samlingstak ligger i `applikasjon_brukerdelegering_organisasjonssamling` (0080 i fs-plattform), og er i dag verken synlige eller redigerbare gjennom grafen (`FeideApplikasjon.brukerdelegeringer` leser bare direkte rader). Visningen per organisasjon krever at grafen utvider samlingstaket til medlemmene, slik `raa_delegeringstilganger` gjør.

### Regel: Forvaltning av taket krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen taket gjelder, i samme miljø

Regelen er formulert ett sted i fs-plattform, `tilgangsstyring.kan_forvalte_delegering`, og håndheves av skrivepolicyen på `applikasjon_brukerdelegering`. Grafflaten er `leggTilBrukerdelegeringer` og `fjernBrukerdelegeringer`.

### Regel: Taket begrenser hvilke av personbrukerens roller brukeren får gjennom applikasjonen

Effektiv tilgang gjennom applikasjonen er ((personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller) minus nekt (`kombiner_tildelinger`, 0099 i fs-plattform). Taket brukes også i valglisten for rolle på personbrukere (BRU-PER-GRU-003).

## Åpne designspørsmål

- [ ] Hva heter fanen, og hvor står den blant fanene på detaljsiden?
- [ ] Hvordan vises det at et tak kommer fra en organisasjonssamling (egen kolonne, merkelapp som «Arvet» i tilgangslisten, eller annet)?
