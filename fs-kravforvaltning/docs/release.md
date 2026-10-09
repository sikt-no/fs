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

1. **Finnes det changesets**, lager workflowen versjons-commiten på branchen `changeset-release/main`. Den bumper `version` i `package.json` og `package-lock.json`, skriver endringene inn i `CHANGELOG.md` og sletter changeset-filene. Finnes PR-en *«fs-kravforvaltning: ny versjon»* fra branchen, oppdateres den hver gang en ny changeset kommer på `main`. Finnes den ikke, må den lages for hånd (se *Versjons-PR-en*).
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
- **«Allow GitHub Actions to create and approve pull requests»** (*Settings → Actions → General → Workflow permissions*) er låst av organisasjonen sikt-no, så workflowen kan ikke lage versjons-PR-en selv. Den lages for hånd (se *Versjons-PR-en*).
- **Regelsettet «Pull Requests for External»** (*Settings → Rules → Rulesets*) gjelder alle brancher, og forbyr sletting og force-push. changesets/action må force-pushe `changeset-release/main`, og lager, force-pusher og sletter den midlertidige branchen `changesets-ghcommit-temp/changeset-release/main`. Begge er derfor unntatt med *Exclude by pattern*: `changeset-release/**/*` og `changesets-ghcommit-temp/**/*`. En avsluttende `**` matcher bare ett nivå, så `changesets-ghcommit-temp/**` er ikke nok. Uten unntakene feiler jobben `version` med «Repository rule violations found – Cannot delete this branch».

## Versjons-PR-en

Workflowen kan ikke lage PR-en *«fs-kravforvaltning: ny versjon»* selv (se *Oppsett i GitHub*). Når det kommer changesets på `main` og det ikke finnes en åpen versjons-PR, feiler jobben `version` med «GitHub Actions is not permitted to create or approve pull requests». Versjons-commiten ligger likevel på `changeset-release/main`. Rutinen er:

1. Sjekk at `changeset-release/main` er foran `main`, og at det ikke finnes en åpen PR fra branchen:

   ```bash
   git fetch origin
   git log --oneline origin/main..origin/changeset-release/main
   gh pr list --head changeset-release/main
   ```

2. Lag PR-en med tittelen **«fs-kravforvaltning: ny versjon»** (workflowen finner den på branchen, men tittelen bør være den samme), og endringene for versjonen fra `CHANGELOG.md` som beskrivelse:

   ```bash
   gh pr create --base main --head changeset-release/main --title 'fs-kravforvaltning: ny versjon' --body-file <beskrivelse.md>
   ```

3. Kjør den feilede kjøringen på nytt (*Re-run failed jobs*, eller `gh run rerun <id>`). Den finner PR-en, oppdaterer den («Updating found pull request #…»), og blir grønn. Etter dette holder workflowen PR-en oppdatert selv.
4. Merge PR-en når det skal lages en release. Da bygges og publiseres appen (se *Fra changeset til release*).

Claude kan gjøre steg 1–3 når du ber om det («lag release-PR for FS Kravforvaltning»).

## Signering

### macOS

macOS-appen signeres med et **Developer ID Application**-sertifikat og notariseres av Apple i release-workflowen. Da åpnes den uten advarsel fra Gatekeeper. electron-builder gjør begge deler: den signerer alt i appen (også `pty.node` og `spawn-helper` fra node-pty) med hardened runtime, sender appen til Apple med `notarytool`, og stifter billetten til appen. Steget «Sjekk signaturen og notariseringen» stopper bygget hvis noe mangler.

Workflowen trenger fem secrets (*Settings → Secrets and variables → Actions → Secrets*). Mangler én av dem, stopper macOS-bygget, så det ikke publiseres en usignert app.

| Secret | Innhold |
|--------|---------|
| `MAC_CSC_LINK` | Sertifikatet med privatnøkkel (`.p12`), base64-kodet |
| `MAC_CSC_KEY_PASSWORD` | Passordet til `.p12`-fila |
| `APPLE_API_KEY` | Innholdet i App Store Connect-nøkkelen (`AuthKey_<id>.p8`, hele fila med `-----BEGIN PRIVATE KEY-----`) |
| `APPLE_API_KEY_ID` | Key ID til nøkkelen (10 tegn) |
| `APPLE_API_ISSUER` | Issuer ID (UUID, øverst på siden med nøklene) |

Notariseringen bruker en API-nøkkel for teamet, ikke en Apple-ID med app-spesifikt passord, så den ikke er knyttet til en person og ikke stopper på tofaktorinnlogging.

**1. Lag sertifikatet** (på en Mac, én gang):

1. Åpne *Nøkkelringtilgang → Sertifikatassistent → Be om et sertifikat fra en sertifiseringsinstans*. Fyll inn e-post og navn, velg **Lagret på disk**, og lagre `.certSigningRequest`-fila.
2. Gå til <https://developer.apple.com/account/resources/certificates> og velg **+** → **Developer ID Application**. Bare kontoinnehaveren (Account Holder) kan lage Developer ID-sertifikater.
3. Last opp forespørselen og last ned `developerID_application.cer`. Dobbeltklikk den, så havner den i nøkkelringen sammen med privatnøkkelen.
4. I Nøkkelringtilgang, under *Mine sertifikater*: høyreklikk **Developer ID Application: <navn> (<team-ID>)** og velg **Eksporter**. Lagre som `.p12` med et sterkt passord.
5. Base64-kod fila og legg den i `MAC_CSC_LINK`, og passordet i `MAC_CSC_KEY_PASSWORD`:

   ```bash
   base64 -i sertifikat.p12 | pbcopy
   ```

Slett `.p12`-fila etterpå, eller legg den i en passordhvelv. Sertifikatet gjelder i fem år, og må fornyes og byttes i secreten før det går ut. Apper som er signert og notarisert før det gikk ut, virker fortsatt.

**2. Lag nøkkelen til notariseringen:**

1. Gå til <https://appstoreconnect.apple.com/access/integrations/api> (*Users and Access → Integrations → App Store Connect API → Team Keys*). Krever rollen Admin eller Account Holder.
2. Velg **+**, gi nøkkelen navnet `FS Kravforvaltning release` og tilgangen **Developer**.
3. Last ned `AuthKey_<id>.p8`. Den kan bare lastes ned én gang.
4. Legg innholdet i fila i `APPLE_API_KEY`, Key ID i `APPLE_API_KEY_ID` og Issuer ID i `APPLE_API_ISSUER`.

**Lokalt** signerer `npm run app:dist` med et Developer ID-sertifikat i nøkkelringen, hvis du har et. Notariseringen skjer bare når `APPLE_API_KEY` (stien til `.p8`-fila), `APPLE_API_KEY_ID` og `APPLE_API_ISSUER` er satt.

### Windows

Windows-appen er ikke signert, og SmartScreen advarer mot `.exe`-en (**Mer informasjon → Kjør likevel**). Dette står i release-notatene. Signering krever et kodesigneringssertifikat, for eksempel Azure Trusted Signing.

## Bygge lokalt

```bash
cd fs-kravforvaltning
npm run app:dist   # bare for plattformen og arkitekturen du sitter på, i release/
```

Client ID leses fra `.env` (se `.env.example`).
