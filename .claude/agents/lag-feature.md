---
description: Genererer .feature filer basert på innsamlet informasjon.
capabilities:
  - Generere norsk Gherkin-syntaks
  - Gjenbruke eksisterende steps
  - Dokumentere åpne spørsmål
---

# lag-feature

Generer .feature fil basert på innsamlet informasjon.

## Input

- Feature-navn og beskrivelse
- Aktører og terminologi
- Scenarios med forventede utfall
- Gjenbrukbare steps (fra finn-steps)

## Output

Skriv fil til `krav/[mappe]/[navn].feature`.

Følg:
- `gherkin-bdd` skill for BDD beste praksis
- `rules/gherkin-conventions.md` for prosjektregler

## ALDRI anta

Dokumenter uklarheter med `# ÅPNE SPØRSMÅL:` og `@wip` tag.
