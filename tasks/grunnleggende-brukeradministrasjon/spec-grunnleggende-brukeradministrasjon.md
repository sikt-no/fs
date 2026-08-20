# Spec: Grunnleggende brukeradministrasjon (personbrukere)

> Skrevet 2026-08-20 fra kravinventar innsamlet i samme økt. Full `bat-specify`-kjøring ble
> hoppet over med brukerens samtykke; kravkilden under er autoritativ.

## Kravkilde

- Repo: `sikt-no/fs`, branch **`grunnleggende-brukeradministrasjon-og-tilgangsstyring`** (lokal klone: `~/sources/fs`).
- Mappe: `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/`.
- Branchen sletter de gamle `@skip`-kravene under `12 Brukeradministrasjon/01 Brukere/` og erstatter dem med et nytt kravsett. Kravene finnes **ikke** på `main`/`fruitbat` — de gamle filene der er utdaterte.
- Initiativ: [#350 Brukeradministrasjon av FS Admin-brukere](https://github.com/sikt-no/fs/issues/350).
- Skisser: ingen Figma-artefakter er koblet til denne kjøringen (frontend-prototypen på `fs-admin`-branchen `BAT-185-grunnleggende-brukeradministrasjon-v-1-frontend` fungerer som de facto design-referanse).

## Kravinventar — «1 - Grunnleggende brukeradministrasjon»

Alle `@must @planned`.

| ID | Fil | GitHub | Sammendrag |
|---|---|---|---|
| BRU-PER-GRU-001 | `søke_opp_bruker.feature` | #479 | Listevisning og søk i personbrukere: kolonner Navn, Feide-ID, Organisasjon, Status, Sist innlogget; sortering på navn; 50-og-50-paginering med totalt antall treff; fritekst på navn/Feide-ID; filter på status (Alle/Aktiv/Deaktivert), organisasjon (kun org. jeg administrerer), rolle (roller tildelt minst én synlig bruker); AND-kombinasjon. Synlighet: personadministrator ser brukere med minst én tilgang i egne organisasjoner (og ser hvilke org. tilgangene gjelder); super-personadministrator ser alle. |
| BRU-PER-GRU-002 | `se_brukers_tilganger.feature` | #480 | Detaljside med separate seksjoner for tildelte **roller** og **tilganger**; hver tildeling viser Navn, Status, Organisasjon, Tildelt av, Tildelt dato; vis gyldighetstidsrom og stedkoder når satt; tydelig skille aktiv/inaktiv. |
| BRU-PER-GRU-003 | `tildele_og_fjerne_tilganger.feature` | #481 | Tildele og fjerne roller og tilganger, enkeltvis og i bulk (én operasjon). **Delvis suksess påkrevd**: gyldige tildelinger gjennomføres, avviste vises med årsak. Hver endring sporbar i historikk. |
| BRU-PER-GRU-004 | `aktivere_og_deaktivere_bruker.feature` | #482 | Deaktivering **fryser** brukerens samlede tildelinger (status «Deaktivert», tildelinger blir inaktive men beholdes; brukeren når ikke FS-data). Reaktivering gjenoppretter (unntatt tildelinger som var tidsutløpt før deaktiveringen). Sporbart i historikk. |
| BRU-PER-GRU-005 | `sette_stedkoder_for_tilgang.feature` | #483 | Begrense en tildeling til stedkoder ved tildelingens organisasjon; legge til/fjerne/fjerne alle; lovlige verdier fra organisasjonen. |
| BRU-PER-GRU-006 | `sette_tidsbegrensning_for_tilgang.feature` | #484 | Valgfritt start-/sluttidspunkt per tildeling (minuttoppløsning, Europe/Oslo); felles sluttidspunkt for hele tildelingssettet; validering (slutt i fortid avvises, slutt før start avvises). |

Videre iterasjoner i samme kravtre (ikke i scope): «2 - Historikk», «3 - Rollevisning», «4 - Opprette og administrere roller», «5 - Etterspørre tilgang / Rolledeling / brukerprofil», «1 - Bruksvilkår».

### Begrepsbruk (`personbrukere/begrepsbruk.md`, status utkast)

- Teknisk modell: alt er **roller** (rekursiv komposisjon via `rolle_implikasjon`), ingen innebygd semantikk.
- Domenemodell (brukerflaten): **tilgang** = atomet (én konkret rettighet), **rolle** = molekylet (meningsfull sammensetning). Semantisk lag oppå den tekniske modellen — ingen ny teknisk konstruksjon.
- Prinsipp: lett å gjøre riktig, vanskelig å gjøre feil.

## Scope-avgrensning (besluttet av bruker 2026-08-20)

**I scope: BRU-PER-GRU-001–004** — det frontend-prototypen implementerer.

**Utenfor scope (utsatt):**
- GRU-005 stedkoder (mangler i prototype og i backend-datamodellen — helt ny dimensjon).
- GRU-006 tidsbegrensnings-UI (datamodellen har allerede `tstzrange`-perioder, men ingen API/UI).
- «Sist innlogget»-kolonnen fra GRU-001 (krever ny datakilde — innloggingstidspunkt lagres ikke i dag).
- Opprette personbruker (eksplisitt utenfor prototypens scope).
- `Query.mineTilganger` og frontend-gating-mekanismen (eies av andre utviklere).
- Historikk-**visning** (iterasjon «2 - Historikk»); sporbar **lagring** er dekket av eksisterende append-only-modell med aktørkolonner.

## Åpne spørsmål fra kravfilene (må følges opp)

Fra GRU-001:
- Rollenavnene «personadministrator» / «super-personadministrator» er arbeidstitler — bekreft/juster mot rolledefinisjonsarbeidet i «4 - Opprette og administrere roller».
- Kant-tilfeller: brukere uten Feide-ID / med flere identiteter — eget krav?

Fra GRU-002:
- Skal direkte tildelinger skilles fra rolle-arvede, eller presenteres samlet med kilde-merking? (Designfase.)
- «Inaktiv pga. tidsbegrensning» vs. «deaktivert av administrator» — én eller to statuser? (Designfase.)

Fra GRU-003:
- **Autorisasjon: hvilken regel styrer hva en brukeradministrator kan tildele?** Forslag i kravet: kun tilganger som (a) gjelder ved organisasjon administratoren administrerer og (b) administratoren selv har eller kan administrere.
- Bekreftelsesdialog vs. angre ved fjerning. (Designfase.)
- Krever tildeling godkjente bruksvilkår/taushetserklæring først? (Henger på «1 - Bruksvilkår».)

Fra GRU-004:
- Skal aktive sesjoner termineres umiddelbart ved deaktivering? (Sikkerhetsbeslutning. Merk: utstedte JWT-er lever i inntil 1 time; deaktivering håndheves ved neste tokenutstedelse.)
- Tidsbegrenset deaktivering (suspender til dato)?
- Forhold til automatisk deaktivering ved stillingsslutt (BRU-PER-ETT-005).

## Avvik/konflikter identifisert i kravene

- GRU-003 «Delvis suksess» står i spenning til plattformens etablerte alt-eller-ingenting-mutasjonsmønster — **blokkerende avklaring med kravansvarlig** før skrivesidens semantikk låses (se plan, beslutning B5: skjemaet designes så begge utfall støttes).
- GRU-001 forventer kolonnen «Navn», men persondata (navn) eies av SIS-subgrafen — tilgangsstyring-subgrafen kan ikke levere navn selv. Se plan, beslutning B1.
