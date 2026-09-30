# Versjoner og release av FS Kravforvaltning

Desktop-appen bygges for macOS, Windows og Linux av GitHub Actions, og legges ved en GitHub-release sammen med endringsloggen. Versjonen og endringsloggen styres med [Changesets](https://changesets.dev).

## Når du endrer appen

Legg til en changeset i samme PR som endringen:

```bash
cd fs-kravforvaltning
npx changeset
```

Velg `patch` (feilretting), `minor` (ny funksjon) eller `major` (endring brukerne må forholde seg til), og skriv én setning om endringen for brukerne av appen. Det lages en fil i `.changeset/`, som sjekkes inn sammen med endringen.

En endring som ikke skal nevnes i endringsloggen (refaktorering, tester), trenger ingen changeset.

## Fra changeset til release

Workflowen er `.github/workflows/kravforvaltning-release.yml`, og kjører ved push til `main` som endrer `fs-kravforvaltning/`.

1. **Finnes det changesets**, lager eller oppdaterer workflowen PR-en *«fs-kravforvaltning: ny versjon»*. Den bumper `version` i `package.json` og `package-lock.json`, skriver endringene inn i `CHANGELOG.md` og sletter changeset-filene. PR-en oppdateres hver gang en ny changeset kommer på `main`.
2. **Når den PR-en merges**, finnes det ingen changesets, og versjonen i `package.json` har ingen release. Da:
   - lages en draft-release `fs-kravforvaltning-v<versjon>` med endringene for versjonen fra `CHANGELOG.md`
   - bygges appen på tre maskiner, og filene lastes opp til releasen:
     - macOS: `fs-kravforvaltning-<versjon>-mac-arm64.dmg` og `-mac-x64.dmg`
     - Windows: `fs-kravforvaltning-<versjon>-win-x64.exe`
     - Linux: `fs-kravforvaltning-<versjon>-linux-x86_64.AppImage`
   - publiseres releasen når alle tre er lastet opp. Feiler ett bygg, blir releasen stående som draft, og neste kjøring (eller *Re-run failed jobs*) bygger den ferdig.
3. Andre push til `main` gjør ingenting, så lenge versjonen allerede har en publisert release.

Taggen har prefikset `fs-kravforvaltning-`, fordi repoet først og fremst er kravene, og en bar `v1.2.0` ville sett ut som en versjon av hele repoet.

## Oppsett i GitHub (én gang)

Gjør dette **før** workflowen kommer på `main`. `package.json` har versjon `1.0.0`, som ikke har noen release, så første kjøring publiserer `fs-kravforvaltning-v1.0.0` med en gang.

- **Repo-variabel `KRAV_GITHUB_CLIENT_ID`** (*Settings → Secrets and variables → Actions → Variables*) med Client ID til OAuth-appen. Det er en variabel, ikke en secret, fordi ID-en ikke er hemmelig (se [github-oauth.md](github-oauth.md)). Mangler den, stopper bygget, så det ikke publiseres en app der innloggingen ikke virker.
- **«Allow GitHub Actions to create and approve pull requests»** (*Settings → Actions → General → Workflow permissions*) må være på, ellers kan ikke workflowen lage versjons-PR-en. Kan være låst på organisasjonsnivå.

## Signering

Appene er ikke signert. En `.dmg` lastet ned fra GitHub blir stoppet av Gatekeeper (høyreklikk og **Åpne**, eller `xattr -cr "/Applications/FS Kravforvaltning.app"`), og Windows SmartScreen advarer mot `.exe`-en. Dette står i release-notatene.

Signering krever sertifikater som secrets i repoet:

- macOS: Apple Developer ID-sertifikat (`CSC_LINK`, `CSC_KEY_PASSWORD`) og notarisering (`APPLE_ID`, `APPLE_APP_SPECIFIC_PASSWORD`, `APPLE_TEAM_ID`). Da fjernes `CSC_IDENTITY_AUTO_DISCOVERY: 'false'` fra workflowen
- Windows: kodesigneringssertifikat, for eksempel Azure Trusted Signing

## Bygge lokalt

```bash
cd fs-kravforvaltning
npm run app:dist   # bare for plattformen og arkitekturen du sitter på, i release/
```

Client ID leses fra `.env` (se `.env.example`).
