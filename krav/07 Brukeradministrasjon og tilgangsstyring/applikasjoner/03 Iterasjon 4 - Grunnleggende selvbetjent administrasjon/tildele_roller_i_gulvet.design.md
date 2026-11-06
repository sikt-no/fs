# Implementasjonsdetaljer: Forvalte roller i gulvet til en Feide-applikasjon

**Relatert feature:** [`tildele_roller_i_gulvet.feature`](./tildele_roller_i_gulvet.feature)

## Overordnet UI-mønster

En egen fane for gulvet på detaljsiden for applikasjonen, ved siden av fanen for taket. Fanen vises bare for Feide-applikasjoner. Tildeling og fjerning følger dialogene for roller på personbrukere (`TildelRolleAction` og `FjernRolleAction` i FS Admin): organisasjon, miljø og roller i kaskade.

## Komponenter og layout

- **Listen:** rolle, organisasjon, miljø og gyldighetstidsrom.
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

### Regel: Fanen for gulvet viser rollene i gulvet til applikasjonen som gjelder nå

- Et gulv gjelder nå når gyldighetsperioden inneholder tidspunktet nå, og gulvet ikke er ugyldiggjort (jf. `tildele_roller.design.md` for personbrukere).
- Gulv som er avsluttet eller starter senere, filtreres bort i spørringen, ikke med RLS, slik som for personbrukere og applikasjoner.
- Gyldighetstidsrommet vises med dato, som i rollelisten for personbrukere (`formatGyldighetstidsrom` i `PersonbrukerRollerResultList`). Gyldighetsperioden kan ikke settes i fanen.

### Regel: Forvaltning av gulvet krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen gulvet gjelder, i samme miljø

- Gulvet ligger i `applikasjon_brukergrunntilgang` (0099 i fs-plattform): applikasjon, rolle, organisasjon, miljø og gyldighetsperiode.
- Det finnes ingen skriveflate for gulvet i dag. Tabellen har bare lesepolicyen `applikasjon_brukergrunntilgang_les`, og app-rollen kan ikke skrive. Kommentaren i 0099 sier at gulvet skal få et eget privilegium. Produkteier har bestemt (04.11.2026) at applikasjonsadministrator-rollen for begge organisasjonene er nok, så skrivepolicyen kan bygges som for taket (`kan_forvalte_delegering`), og kommentaren i 0099 må oppdateres.
- Grafen har ingen typer eller mutasjoner for gulvet ennå.

### Regel: Alle brukere av applikasjonen får rollene i gulvet for organisasjonen og miljøet i gulvet

- `raa_grunntilganger(miljø, applikasjon)` gir (organisasjon, rolle) for radene som gjelder nå. Brukerne får rollen for organisasjonen på raden.
- Effektiv tilgang er ((personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller) minus nekt (`kombiner_tildelinger`, 0099). Gulvet ligger utenfor taket.
- For en bruker med FS-fiktivt fødselsnummer begrenses gulvet til hjemorganisasjonen (`tilganger_for_bruker`).

## Åpne designspørsmål

- [ ] Hva heter fanen, og hvor står den blant fanene på detaljsiden?
- [ ] Bør dialogen advare om at en rolle i gulvet gis til alle brukere av applikasjonen, også ukjente?
