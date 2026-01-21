---
paths:
  - "krav/**/*.feature"
  - "**/*.feature"
---

# FS Gherkin Konvensjoner

Prosjektspesifikke regler for .feature filer i FS-prosjektet.

## Språk

- Bruk `# language: no` i alle filer
- Norske nøkkelord: Egenskap, Scenario, Gitt, Når, Så, Og, Men, Regel, Bakgrunn, Scenariomal, Eksempler

## Mappestruktur

Tre nivåer: **Domene → Sub-domene → Kapabilitet**

Feature-filer skal **kun** plasseres på kapabilitetsnivå (nivå 3).

```
krav/
└── [NN] [Domene]/
    └── [NN] [Sub-domene]/
        └── [NN] [Kapabilitet]/
            └── feature-navn.feature
```

### Domener

- `00 Personas` - Brukertyper og roller
- `01 Forberede studier` - Planlegging av utdanning
- `02 Opptak` - Opptaksprosessen
- `03 Gjennomføre studier` - Studiegjennomføring
- `04 Kompetanse` - Resultater og kvalifikasjoner
- `05 Opplysninger om person` - Persondata
- `07 Tilgangstyring` - Autentisering og autorisasjon
- `08 Teknisk` - Tekniske funksjoner
- `10 Felleskrav` - Tverrgående funksjonalitet
- `99 Demo` - Demo og testing

### Eksempel

```
krav/
└── 02 Opptak/
    └── 01 Forberede opptak/
        └── 01 Regelverk og grunnlag/
            └── kompetanseregelverk.feature
```

## Tags

### Feature-ID

Hver feature **må tagges** med en unik ID. ID-en legges inn manuelt som tag i feature-filen.

**Format:**
```
@DOM-SUB-KAP-NNN
```

- `DOM` = 3-bokstavs forkortelse for domene
- `SUB` = 3-bokstavs forkortelse for sub-domene
- `KAP` = 3-bokstavs forkortelse for kapabilitet
- `NNN` = Unikt løpenummer per feature (001, 002, 003...)

**Forkortelser:** Utledes logisk fra mappenavnet (vanligvis 3 første bokstaver, men unntak for lesbarhet). Spør hvis usikker.

**Eksempler:**
- `@OPT-REG-GRU-001` = Opptak → Registrere → Grunnlag → feature 001
- `@DEM-STU-SØK-001` = Demo → Studiekatalog → Søk → feature 001

**Ved ny feature:** Sjekk eksisterende features i samme mappe for å finne neste ledige løpenummer.

### Prioritet (MoSCoW)
- `@must` / `@should` / `@could` / `@wont`

### Status
- `@implemented` - Ferdig implementert
- `@in-progress` - Under implementering
- `@planned` - Planlagt

### Type
- `@e2e` / `@integration` / `@demo`

## Åpne spørsmål

Dokumenter uklarheter med kommentarer:

```gherkin
# ÅPNE SPØRSMÅL:
# - Spørsmål her

Scenario: ...
  # TODO: Avklar med produkteier
```

## Aktører

- administrator, søker, student, saksbehandler
