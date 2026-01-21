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
- `09 Kommunikasjon` - Meldinger og varsler
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
