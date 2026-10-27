# Akseptansetest

Her står testplanene for akseptansetestene, med testcasene og testrapportene. Mappa ligger i rota av repoet, ikke under `tasks/`, fordi en test kan gå på tvers av domener. Flyten og reglene står i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) i Confluence.

Hele prosessen, fra kravene skrives til leveransen er godkjent, er forklart steg for steg i [Kom i gang med krav og akseptansetest i FS](https://sikt-no.github.io/fs/kom-i-gang.html#testplan) (`kom-i-gang.html`).

## Flyten

| Steg | Hva | Skill | Fil | Side i Confluence |
|---|---|---|---|---|
| 1 | Verifisering | `fs-verify` eller `fs-verify-agent-teams` | `verify-<dato>-<HHMM>.md` her for et scope, i `spec/` for en oppgave, eller ved siden av kravet for en mappe eller fil | «Verifisering – <leveranse> – <dato tid>» |
| 2 | Testplan | `fs-testplan` | `testplan.md` | «Testplan – <leveranse>» |
| 3 | Testrapport etter verifiseringen | `fs-testrapport` | `testrapport-verifisering-<dato>.md` | «Testrapport – verifisering – <leveranse>» |
| 4 | Intern akseptansetest | `fs-testcaser-intern` | `testcaser-intern.md` | «Intern akseptansetest – <leveranse>» |
| 4b | CDP-kjøring (valgfri) | `fs-testcaser-cdp` lager testene i [`cdp-tester/`](../cdp-tester/README.md), en agent kjører dem med `cdp`-skillen | `kjoring-<dato>-<HHMM>/resultat.md` | Når brukeren sier ja |
| 5 | Testrapport etter den interne testen | `fs-testrapport` | `testrapport-intern-<dato>.md` | «Testrapport – intern akseptansetest – <leveranse>» |
| 6 | Ekstern akseptansetest | `fs-testcaser-ekstern` | `testcaser-ekstern.md` | «Ekstern akseptansetest – <leveranse>» |
| 7 | Testrapport etter den eksterne testen | `fs-testrapport` | `testrapport-ekstern-<dato>.md` | «Testrapport – ekstern akseptansetest – <leveranse>» |

Verifiseringen kommer først. `fs-verify` (eller `fs-verify-agent-teams` når det er mange feature-filer) setter `@implemented` på kravene der koden er funnet, og rapporten er grunnlaget for testplanen: det som er `@implemented`, er det som testes, og det verifiseringen ikke fant, står i «Venter på verifisering». Verifiseringen kjøres på leveransen (et scope, en oppgave, en mappe eller feature-filer), siden testplanen ikke finnes ennå.

Testplanen er hovedsiden i Confluence, og ligger alltid under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner). De andre sidene er undersider til testplanen. Verifiseringen fra steg 1 legges som underside når testplanen opprettes i Confluence (`fs-testplan`). Seksjonen «Status i flyten» i testplanen lenker til hver av dem.

## Struktur

```
akseptansetest/
├── README.md                    # dette dokumentet
└── <testplan-slug>/             # én mappe per testplan
    ├── testplan.md
    ├── testcaser-intern.md
    ├── testcaser-ekstern.md
    ├── verify-<YYYY-MM-DD>-<HHMM>.md     # fra fs-verify, når leveransen er et scope (mappa har scope-slugen)
    ├── kjoring-<YYYY-MM-DD>-<HHMM>/      # valgfritt (steg 4b): resultat.md fra en CDP-kjøring (skjermbilder ligger lokalt, ignorert av git)
    ├── testrapport-<verifisering|intern|ekstern>-<YYYY-MM-DD>.md
    ├── oppsett.md                    # forslag: hva som gjøres i testmiljøet før og etter testen (se «Oppsett av testmiljøet»)
    └── oppsett/                      # forslag: skriptene oppsett.md viser til
```

- **Testplan-slugen** er scope-slugen for et scope, `<domene>-<oppgave-slug>` for en oppgave (en oppgave-slug er bare unik innenfor domenet), og navnet på mappa eller fila i kebab-case for en mappe eller fil.
- **Hver fil** har metadata øverst, så en strek (`---`), og under den innholdet som publiseres i Confluence. Metadataene publiseres ikke.
- **Fila er utkastet** fram til testen starter. Etter det er siden i Confluence kilden for resultatene, og fila oppdateres fra siden av `fs-testrapport`.

## Kravene

En testplan gjelder et scope, en oppgave, en mappe under `krav/` eller én eller flere feature-filer (`- **Kilde**:` i testplanen):

- **Scope:** alle kravene og delene med taggen `@scope-<slug>`.
- **Oppgave:** kravene i oppgavens rad i scope-tabellen.
- **Mappe:** alle feature-filene under mappa.
- **Feature-fil:** filene.

Det som testes, er det som er `@implemented`, også de leverte delene i et krav som er delvis levert (`@implemented` på en regel eller et scenario under en `@in-progress` egenskap). Krav som er `@in-progress`, og delene som ikke er levert, står i «Venter på verifisering», og resten i «Ikke med i denne testen».

Er et krav med i en flyt i `krav/_Flyter/`, står flyten i «Flyter» i testplanen, og overleveringene i den testes også: at det ett krav lager, blir brukt av det neste. Hele flyten testes når den er `@implemented`, ellers fasene i leveransen som er levert. Se *Flyter* i [`krav-fra-testplan.md`](../.claude/references/akseptansetest/krav-fra-testplan.md).

Kravene står med Feature-ID i «Omfang» i testplanen, og alle skillene i flyten leser dem derfra, så alle trinnene tester de samme kravene. Scope-id-ene kravene har, står i `- **Scope**:`. De automatiske testene av de samme kravene kjøres med `npx playwright test --grep @scope-<slug>`, eller med Feature-ID-ene når kravene ikke har scope. Reglene står i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../.claude/references/akseptansetest/krav-fra-testplan.md).

## CDP-kjøring (valgfritt, steg 4b)

En agent kan kjøre testene i Chrome med `cdp`-skillen, mot testmiljøet. Testene er ikke en del av testplanen: de er varige, ligger i [`cdp-tester/`](../cdp-tester/README.md), og lages og oppdateres med `fs-testcaser-cdp`, fra kravene. Det som hører til leveransen, er kjøringene.

- **Samme grunnlag.** Roller, testbrukere og testdata avklares i testplanen, med de samme spørsmålene for alle trinnene (se [`.claude/references/akseptansetest/roller-og-testdata.md`](../.claude/references/akseptansetest/roller-og-testdata.md)). Svarer teamet ja på «Skal en CDP-agent kjøre testene?», fyller `fs-testplan` i kolonnene `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand` og `Brukes av`, og leser koden for å vise hva løsningen krever.
- **Nøkler, ikke navn.** Testene bruker nøkler (`brukeradministrator-alle-miljoer`), som slås opp i testplanen ved kjøring, så de overlever en ny testplan med andre testbrukere.
- **Frivillig.** Steget er «Ikke aktuell» i «Status i flyten» til teamet har svart ja. Skillen kan også kjøres uten testplan, for å lage eller oppdatere testene fra kravene.
- **Resultatet** skrives til `kjoring-<YYYY-MM-DD>-<HHMM>/resultat.md`, og er et forslag: en tester bekrefter statusen, og `fs-testrapport` teller først etter det. Skjermbilder legges i samme mappe, men `.gitignore` holder dem utenfor git: bare `resultat.md` committes.
- **Bare i testmiljø.** Agenten avbryter hvis URL-en er produksjon.

## Testcasene

Kolonnene er `Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status`:

- **Faktisk resultat** er det testeren så, som fritekst.
- **Status** er `Bestått`, `Ikke bestått` eller `Ikke testet` (med en kort begrunnelse). Det er den testrapporten teller.

Reglene for testcasene står i [`.claude/references/akseptansetest/testcase-regler.md`](../.claude/references/akseptansetest/testcase-regler.md).

## Oppsett av testmiljøet (forslag)

> Dette er et forslag fra opptaksteamet, prøvd ut i [`soke-om-tidlig-opptak/`](soke-om-tidlig-opptak/oppsett.md). Det er ikke avtalt på tvers av teamene ennå. Si fra hvis dere gjør det annerledes, eller har et bedre sted.

Mange tester trenger at noe gjøres i testmiljøet først, for eksempel at en innstilling endres, eller at en søknad gjøres klar, og at det settes tilbake etterpå. Uten et felles sted ligger slike skript lokalt hos den som skrev dem, og de andre i teamet finner dem ikke.

- **`oppsett.md`** ligger ved siden av testplanen, og har tre deler: *Før testen* (hva, hvordan og hvem), *Sjekk* (hvordan man ser at alt er klart), og *Etter testen* (hva som settes tilbake, og hva som ikke kan settes tilbake).
- **Løsningen først.** Det som kan gjøres i løsningen, beskrives som steg der, gjerne de samme som «Gjør klar»-stegene i testcasene. SQL brukes bare der løsningen ikke kan gjøre det.
- **`oppsett/`** har skriptene. Vi tar vare på tre slags: de som setter opp før testen, de som sjekker at oppsettet er riktig, og de som setter tilbake etterpå. Engangsspørringer for å finne testdata tas ikke med.
- **Sjekkskriptet** bare leser, og gir én tabell med én rad per sjekk og en kolonne `ok`, så alt kan ses i ett resultat. Det kjøres dagen før testen, siden data i testmiljøet ikke alltid blir liggende.
- **Hvert skript** sier i en kommentar øverst hva det gjør, hvilket skript som setter det tilbake, og at det kjøres som superbruker når tabellene har RLS. `oppsett.md` sier hvilken versjon av fs-plattform skriptene er skrevet mot, siden skjemaet kan endres av migreringene der.
- **Testplanen** viser til `oppsett.md` i tabellen «Testdata», i kolonnen «Kan settes tilbake» eller der det passer.
- **Ingen hemmeligheter.** Ingen passord, tokens eller ekte personopplysninger i skriptene. Testpersonene i testmiljøet er syntetiske.
