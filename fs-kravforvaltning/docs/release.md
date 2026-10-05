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

### macOS

macOS-appen signeres med et Developer ID-sertifikat og notariseres hos Apple når secrets-ene under finnes i repoet (*Settings → Secrets and variables → Actions → Secrets*). Mangler `MAC_CSC_LINK`, bygges den usignert, og release-notatene forklarer hvordan karantenen fjernes med `xattr`. Er `MAC_CSC_LINK` satt, men en av de andre mangler, stopper bygget.

| Secret | Verdi |
|---|---|
| `MAC_CSC_LINK` | Developer ID Application-sertifikatet med privat nøkkel, som `.p12` i base64 på én linje: `base64 -i sikt-developer-id.p12 \| tr -d '\n' \| pbcopy` |
| `MAC_CSC_KEY_PASSWORD` | Passordet til `.p12`-fila |
| `APPLE_API_KEY_P8` | Innholdet i `AuthKey_<id>.p8` fra App Store Connect (hele fila, med `BEGIN`/`END`-linjene) |
| `APPLE_API_KEY_ID` | Key ID til API-nøkkelen |
| `APPLE_API_ISSUER` | Issuer ID (står over lista med nøkler i App Store Connect) |

Slik lages de:

1. **Sertifikatet** (bare kontoinnehaveren, *Account Holder*, kan lage Developer ID-sertifikater): I Nøkkelringtilgang, *Sertifikatassistent → Be om et sertifikat fra en sertifiseringsinstans…*, lagret på disk. Last opp CSR-fila under *developer.apple.com → Certificates → + → Developer ID Application* (G2 Sub-CA), last ned `.cer` og dobbeltklikk den. Eksporter så sertifikatet med den private nøkkelen fra *Mine sertifikater* som `.p12` med passord.
2. **API-nøkkelen for notarisering**: *App Store Connect → Users and Access → Integrations → App Store Connect API → Team Keys → +*, med rollen **Developer**. `.p8`-fila kan bare lastes ned én gang.

Workflowen gir secrets-ene til electron-builder bare i macOS-jobben (som `CSC_LINK`, `CSC_KEY_PASSWORD` og `APPLE_API_*`), og skriver `.p8`-fila til disk, fordi notariseringen vil ha en sti. Hardened runtime er på som standard, og electron-builders standard-entitlements (JIT og library validation) er det Electron trenger. Etter bygget sjekker workflowen signaturen, Gatekeeper og notariseringen (`codesign`, `spctl`, `stapler`).

Sertifikatet varer i fem år. Ta vare på `.p12`-fila og passordet utenfor GitHub (for eksempel i Vault), og trekk ikke tilbake et sertifikat som er brukt uten grunn: apper som er signert med det, kan slutte å starte.

### Windows

Windows-appen er ikke signert, og SmartScreen advarer mot `.exe`-en (**Mer informasjon → Kjør likevel**). Det står i release-notatene. Signering krever et kodesigneringssertifikat, for eksempel Azure Trusted Signing (`win.azureSignOptions` i `electron-builder.yml`).

## Bygge lokalt

```bash
cd fs-kravforvaltning
npm run app:dist   # bare for plattformen og arkitekturen du sitter på, i release/
```

Client ID leses fra `.env` (se `.env.example`).
