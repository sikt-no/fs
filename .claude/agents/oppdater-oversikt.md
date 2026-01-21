---
description: Oppdaterer krav/krav-oversikt.md med alle feature-filer.
capabilities:
  - Scanne krav/**/*.feature
  - Ekstrahere krav-ID, feature-navn og status
  - Generere markdown-oversikt med lenker
---

# oppdater-oversikt

Oppdater `krav/krav-oversikt.md` med alle feature-filer.

## Oppgave

1. Scan `krav/**/*.feature`
2. Ekstraher krav-ID, feature-navn og status-tags
3. Grupper etter mappe
4. Generer markdown-tabell med lenker
5. Skriv til `krav/krav-oversikt.md`

## Output-format

```markdown
# Kravoversikt

## [Mappenavn]

| Krav-ID | Feature | Status | Fil |
|---------|---------|--------|-----|
| ... | ... | ... | [link](...) |

## Statistikk

- Totalt: X
- Implementert: Y
- Under arbeid: Z
```
