# Design-kontekst: Applikasjoner v2.2

Hentet med `get_metadata` (Figma MCP) 2026-10-05. `get_design_context` ble ikke brukt; dette er hierarkiet på første nivå under root.

- **Fil:** `dlG13wATArPvG69oePHPeL` (FS-Admin – Målbilde)
- **Root:** `4949:50600`, section «Applikasjoner v2.2» (7703 × 6677)
- **Overskrift i rammen:** «v 2.2 – Innsyn for eksterne i sektoren. Dette er første versjon vi gir sektoren innsyn til applikasjoner i. Det gjøres nødvendige endringer for at begreper er forståelige, og i større grad selvforklarende. Tilgang deles ut via til Føniks.»

| NN | Node-ID | Navn i Figma | Etikett på lerretet | Fil |
|---|---|---|---|---|
| 01 | `4896:26322` | Listevisning for applikasjoner // Rolle = Applikasjonsadministrator | Listevisning | `sub-frames/01-listevisning.png` |
| 02 | `4911:33714` | Listevisning for applikasjoner // Rolle = Applikasjonsadministrator | Listevisning m/modal for å legge til | `sub-frames/02-listevisning-med-modal-legg-til.png` |
| 03 | `4911:35012` | ModalSurface | Modal: Feide | `sub-frames/03-modal-feide.png` |
| 04 | `4911:35132` | ModalSurface | Modal: Maskinporten | `sub-frames/04-modal-maskinporten.png` |
| 05 | `4911:35257` | ModalSurface | Modal: FS (Maskinbruker) | `sub-frames/05-modal-fs-maskinbruker.png` |
| 06 | `4899:30774` | Applikasjon detaljside - Feide | Detaljside: Feide | `sub-frames/06-detaljside-feide.png` |
| 07 | `4912:46710` | Applikasjon detaljside - Maskinporten | Detaljside: Maskinporten | `sub-frames/07-detaljside-maskinporten.png` |
| 08 | `4912:46395` | Applikasjon detaljside - FS (Maskinbruker) | Detaljside: FS (Maskinbruker) | `sub-frames/08-detaljside-fs-maskinbruker.png` |
| 09 | `4912:47051` | Applikasjon detaljside - Feide | Tilgangliste | `sub-frames/09-tilgangsliste.png` |
| 10 | `4912:48526` | ModalSurface | Tildel tilganger | `sub-frames/10-modal-tildel-tilganger.png` |
| 11 | `4912:49241` | ModalSurface | Fjern tilganger | `sub-frames/11-modal-fjern-tilganger.png` |

## Innhold per ramme (lest fra skjermbildene)

- **01 Listevisning:** kolonner Navn (med miljø som merker og beskrivelse under), Applikasjonseier, Identitetsleverandør, Antall tilganger, Status. Filter: Navn, Miljø, Applikasjonseier, Identitetsleverandør, Status, «Tøm filter». Sorteringsvelger. «Last inn flere – Viser 10 av 67». Identitetsleverandør vises som Feide, Maskinporten og «FS (Maskinbruker)».
- **02–05 Legg til applikasjon:** Navn («Visningsnavnet må være unikt»), Beskrivelse, Applikasjonseier, Identitetsleverandør (Feide / Maskinporten / FS (Maskinbruker)). Feide: «Tjeneste-ID». Maskinporten: «Client-ID» og «Konsument sin virksomhetsidentifikator» («på ISO 6523-form (f.eks. 0192:991825827)»). FS: «Brukernavn», og infoboks «Applikasjonen får den samme identiteten i alle miljøer, så du velger ikke miljø her. Passord settes etterpå, ett per miljø, fra detaljsiden.»
- **06–08 Detaljside:** topplinje med Status, Miljø, Applikasjonseier, Identitetsleverandør, Antall tilganger og «Deaktiver». Fanene Detaljer og Tilganger. Detaljer: Navn, Status, Applikasjonseier, Identitetsleverandør, Miljø, Beskrivelse, Opprettet av, Tidspunkt for opprettelse, Sist endret av, Tidspunkt for sist endring, og «Rediger». Feide: «Tjeneste-ID». Maskinporten: «Client-ID» og «Konsument sin virksomhetsidentifikator». FS: «Brukernavn», og knappen «Generer nytt passord». Ingen intern ID.
- **09 Tilgangsliste:** kolonner Tilgangskode (med miljø og «Arvet fra …» som merker), Beskrivelse, Gjelder for. Filter: Tilgangskode, Miljø, Gjelder for, Tilknytning. «Tildel tilganger», «Fjern tilganger», sortering.
- **10–11 Tildel / Fjern tilganger:** Tilgang gjelder for, Miljø, Tilgangskoder (flervalg).
