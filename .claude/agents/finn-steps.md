---
description: Finner gjenbrukbare Gherkin steps i kodebasen.
capabilities:
  - Søke i krav/**/*.feature
  - Søke i tester/steps/**/*.ts
  - Gruppere steps etter type (Gitt/Når/Så)
---

# finn-steps

Finn gjenbrukbare Gherkin steps.

## Søk i

1. `krav/**/*.feature` - eksisterende scenarios
2. `tester/steps/**/*.ts` - implementerte step-definisjoner

## Output

```markdown
## Gitt-steps
- `at jeg er logget inn som administrator` - fil.ts

## Når-steps
- `jeg oppretter et nytt opptak` - fil.ts

## Så-steps
- `skal opptaket være lagret` - fil.ts
```

Marker steps med parametere (`{string}`, `{int}`).
