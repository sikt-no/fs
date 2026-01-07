# Implementasjonsplan: Tekniske avhengigheter

## 1. Mise

Opprett `.mise.toml` i `tester/`:

```toml
[tools]
node = "lts"
```

Verifiser med:
```bash
cd tester
mise install
mise current
```

## 2. Node og package.json

Initialiser Node-prosjekt:

```bash
cd tester
npm init -y
```

Oppdater `package.json` med:
- `"type": "module"` for ES modules
- Scripts for testkjøring

## 3. Playwright

Installer Playwright:

```bash
npm install -D @playwright/test
npx playwright install
```

Opprett `playwright.config.ts` med:
- Base URL konfigurasjon for ulike miljøer
- Prosjekter for ulike browsere
- Reporter-konfigurasjon

## 4. playwright-bdd

Installer playwright-bdd:

```bash
npm install -D playwright-bdd
```

Oppdater `playwright.config.ts`:
- Importer `defineBddConfig` fra playwright-bdd
- Pek til feature-filer i `../krav/`
- Pek til step definitions i `./steps/`

## 5. TypeScript

Installer TypeScript-støtte:

```bash
npm install -D typescript @types/node
```

Opprett `tsconfig.json` med passende konfigurasjon.

---

## Mappestruktur etter implementasjon

```
tester/
├── .mise.toml
├── package.json
├── package-lock.json
├── tsconfig.json
├── playwright.config.ts
├── steps/
│   └── (step definitions her)
└── fixtures/
    └── (test fixtures her)
```

## Første testkjøring

```bash
cd tester
npx bddgen                    # Genererer tester fra feature-filer
npx playwright test           # Kjører testene
```
