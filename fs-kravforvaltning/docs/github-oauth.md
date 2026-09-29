# GitHub-innlogging i FS Kravforvaltning

FS Kravforvaltning bruker en OAuth-app i GitHub for å logge inn brukerne. Dette dokumentet forklarer hvorfor appen trengs, hvordan den settes opp, og hva brukeren ser når hen logger inn.

## Hvorfor trengs en OAuth-app?

Med «Lag PR» lager appen en branch, pusher den til `sikt-no/fs` og oppretter en pull request. For å gjøre det trenger den et GitHub-token som tilhører brukeren.

- **Utviklere** som kjører dev-serveren, har som regel `gh` installert. Da brukes `gh auth token`, og OAuth-appen trengs ikke.
- **Desktop-appen** er laget for brukere som ikke har git eller `gh`. De må kunne logge inn fra appen, og det krever en OAuth-app.

Appen bruker *device flow*. Den trenger bare en **Client ID**, ikke en hemmelighet, og derfor kan ID-en bygges inn i appen uten risiko. PR-en lages i brukerens navn, med brukerens egne rettigheter. Den som logger inn, må altså ha skrivetilgang til `sikt-no/fs`.

## Sette opp OAuth-appen (én gang)

Det må gjøres av en som er eier av organisasjonen `sikt-no`.

1. Gå til **github.com/organizations/sikt-no/settings/applications** (*Settings → Developer settings → OAuth Apps*) og velg **New OAuth App**.
2. Fyll ut:

   | Felt | Verdi |
   |------|-------|
   | Application name | `FS Kravforvaltning` (brukerne ser dette navnet når de godkjenner) |
   | Homepage URL | `https://sikt-no.github.io/fs/` |
   | Authorization callback URL | `https://sikt-no.github.io/fs/` (må fylles ut, men brukes ikke ved device flow) |

3. Velg **Register application**.
4. Kryss av for **Enable Device Flow** og lagre. Uten dette avviser GitHub innloggingen.
5. Kopier **Client ID** (f.eks. `Ov23li…`). Du trenger **ikke** lage en client secret.

Appen bør eies av organisasjonen og ikke av en person, så den ikke forsvinner når noen slutter. Har `sikt-no` begrenset tilgangen for tredjepartsapper (*OAuth app access restrictions*), kan en org-eier måtte godkjenne appen under *Third-party access*.

## Gi Client ID til appen

Client ID er ikke hemmelig, men den må være med når appen bygges eller startes.

**Bygges inn i desktop-appen** (anbefalt for utdeling):

```bash
cd fs-kravforvaltning
MAIN_VITE_KRAV_GITHUB_CLIENT_ID=Ov23li... npm run app:dist
```

**Settes når appen startes** (overstyrer den innebygde):

```bash
KRAV_GITHUB_CLIENT_ID=Ov23li... npm run app:dev
```

**Dev-serveren** bruker `gh` hvis den er innlogget. Uten `gh` kan device flow brukes på samme måte:

```bash
KRAV_GITHUB_CLIENT_ID=Ov23li... npm run dev
```

Mangler Client ID, viser «Lag PR» meldingen *«Innlogging mot GitHub er ikke satt opp i denne versjonen av appen»*.

## Slik opplever brukeren innloggingen

1. Brukeren velger **Lag PR** i «Endringer»-modus, og deretter **Logg inn med GitHub**.
2. Appen viser en kode på åtte tegn (f.eks. `ABCD-1234`) og en lenke til **github.com/login/device**.
3. Brukeren åpner lenken i nettleseren, logger inn på GitHub om nødvendig, og skriver inn koden.
4. GitHub spør: *«FS Kravforvaltning ønsker tilgang til repositoriene dine»*. Brukeren godkjenner. Krever `sikt-no` SSO, blir brukeren også bedt om å godkjenne tilgangen for organisasjonen.
5. Appen merker godkjenningen i løpet av noen sekunder, og viser **«Innlogget på GitHub som &lt;brukernavn&gt;»**. Nå kan PR-en lages.

Koden varer i omtrent 15 minutter. Går den ut, velger brukeren «Logg inn med GitHub» på nytt.

### Etter innlogging

- Tokenet lagres **kryptert** med operativsystemets nøkkelring (Keychain på macOS, DPAPI på Windows). Brukeren er fortsatt innlogget neste gang appen startes.
- På enkelte Linux-maskiner uten nøkkelring holdes tokenet bare i minnet, og brukeren må logge inn på nytt ved hver oppstart.
- **Logg ut** i «Lag PR»-dialogen sletter tokenet fra maskinen.
- Tilgangen kan trekkes tilbake på GitHub: *Settings → Applications → Authorized OAuth Apps → FS Kravforvaltning → Revoke*.

## Hva appen får tilgang til

Appen ber om scopet `repo`. Det gir lese- og skrivetilgang til alle repoer brukeren selv har tilgang til, også private. GitHub har ikke et smalere scope for OAuth-apper som gir rett til å pushe og lage PR-er. Appen bruker tokenet bare til dette:

- hente `main` fra `sikt-no/fs`
- pushe en ny branch `krav/<navn>`
- opprette pull requesten
- lese brukernavnet, som vises i appen og brukes som forfatter av committen
