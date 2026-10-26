# Akseptansetest

Her står testplanene for testfasene, med testcasene, kjøringene og testrapportene. Mappa ligger i rota av repoet, ikke under `tasks/`, fordi en test kan gå på tvers av domener. Flyten og reglene står i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) i Confluence.

Hele prosessen, fra kravene skrives til leveransen er godkjent, er forklart steg for steg i [Kom i gang med krav og akseptansetest i FS](https://sikt-no.github.io/fs/kom-i-gang.html#testplan) (`kom-i-gang.html`).

## Fasene

Hver leveranse går gjennom fase 1–3. Leveranser som er godkjent internt, kan gå videre til fase 4. Hver fase bygger på den forrige og gjentar den ikke.

| Fase | Svarer på | Metode | Hvem | Tester ikke |
|---|---|---|---|---|
| 1. Verifisering | Er hvert scenario laget i koden, og stemmer tilgangsstyringen med kravet? | White-box: kravene sjekkes mot koden, uten å kjøre den | Teamet | Om løsningen virker for brukeren |
| 2. Agentisk funksjonstest | Virker hver funksjon riktig, også når noe går galt? | Black-box: en agent kjører testene i testmiljøet | Teamet og testansvarlig, med agent | Flyter på tvers og avhengigheter |
| 3. Intern akseptansetest | Henger leveransen sammen med arbeidsprosessen og resten av FS? | Flyttester og testing av avhengigheter | Testansvarlig (domeneekspert) | Enkeltfunksjoner og feltvalidering |
| 4. Ekstern akseptansetest | Dekker løsningen de eksterne partenes behov? | Testing mot partenes egne krav | Eksterne parter, Sikt legger til rette | Sikts detaljerte funksjonstester |

## Flyten

| Fase | Hva | Skill | Fil | Side i Confluence |
|---|---|---|---|---|
| 1 | Verifisering | `fs-verify` eller `fs-verify-agent-teams` | `verify-<dato>-<HHMM>.md` her for et scope, i `spec/` for en oppgave, eller ved siden av kravet for en mappe eller fil | «Verifisering – <leveranse> – <dato tid>» |
| 1 | Testrapport etter verifiseringen | `fs-testrapport` | `testrapport-verifisering-<dato>.md` | «Testrapport – verifisering – <leveranse>» |
| – | Testplan | `fs-testplan` | `testplan.md` | «Testplan – <leveranse>» |
| 2 | Agentisk funksjonstest: testcasene | `fs-testcaser-cdp` lager testene i [`cdp-tester/`](../cdp-tester/README.md) | `cdp-tester/<kravstien>/<fil>.feature` | Ingen: testene ligger i repoet |
| 2 | Agentisk funksjonstest: kjøringen | En agent kjører testene med `cdp`-skillen, mot testmiljøet | `kjoring-<dato>-<HHMM>/resultat.md` | Står i testrapporten |
| 2 | Testrapport etter den agentiske testen | `fs-testrapport` | `testrapport-agentisk-<dato>.md` | «Testrapport – agentisk funksjonstest – <leveranse>» |
| 3 | Intern akseptansetest | `fs-testcaser-intern` | `testcaser-intern.md` | «Intern akseptansetest – <leveranse>» |
| 3 | Testrapport etter den interne testen | `fs-testrapport` | `testrapport-intern-<dato>.md` | «Testrapport – intern akseptansetest – <leveranse>» |
| 4 | Ekstern akseptansetest: flytforslag | `fs-testcaser-ekstern` | `testcaser-ekstern.md` | «Ekstern akseptansetest – <leveranse>» |
| 4 | Ekstern akseptansetest: flytbeskrivelser til partene | `fs-testcaser-ekstern` | `flytbeskrivelser-ekstern.md` | «Flytbeskrivelser til partene – <leveranse>» (når brukeren sier ja) |
| 4 | Testrapport etter den eksterne testen | `fs-testrapport` | `testrapport-ekstern-<dato>.md` | «Testrapport – ekstern akseptansetest – <leveranse>» |

Verifiseringen kommer først. `fs-verify` (eller `fs-verify-agent-teams` når det er mange feature-filer) setter `@implemented` på kravene der koden er funnet, og rapporten er grunnlaget for testplanen: det som er `@implemented`, er det som testes, og det verifiseringen ikke fant, står i «Venter på verifisering». `@implemented` betyr bare at koden er funnet. Om løsningen virker, sier testene i fase 2–4. Verifiseringen kjøres på leveransen (et scope, en oppgave, en mappe eller feature-filer), siden testplanen ikke finnes ennå. Rapporten har også reglene i koden som ikke har et scenario i kravet, og antall åpne spørsmål per krav.

Testplanen planlegger: hvilke krav og flyter som testes, hvordan testdataene lages, testbrukerne, forutsetningene og kriteriene for godkjent. Den lager ikke testcasene. `fs-testcaser-cdp` lager testcasene for fase 2, og `fs-testcaser-intern` flyttestene for fase 3.

Testplanen er hovedsiden i Confluence, og ligger alltid under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner). De andre sidene er undersider til testplanen. Verifiseringen fra fase 1 legges som underside når testplanen opprettes i Confluence (`fs-testplan`). Seksjonen «Status i flyten» i testplanen lenker til hver av dem.

**Inngangskriteriene.** Fase 2 er ferdig når alle testcasene er kjørt, ingen funn med alvorlighetsgraden «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til fase 3. Agenten kan aldri godkjenne en leveranse eller ta beslutningen.

## Struktur

```
akseptansetest/
├── README.md                    # dette dokumentet
└── <testplan-slug>/             # én mappe per testplan
    ├── testplan.md
    ├── testcaser-intern.md
    ├── testcaser-ekstern.md
    ├── flytbeskrivelser-ekstern.md       # fase 4: flytene og rapportene til partene
    ├── verify-<YYYY-MM-DD>-<HHMM>.md     # fra fs-verify, når leveransen er et scope (mappa har scope-slugen)
    ├── kjoring-<YYYY-MM-DD>-<HHMM>/      # fase 2: resultat.md fra en kjøring (skjermbilder og annet ligger lokalt, ignorert av git)
    └── testrapport-<verifisering|agentisk|intern|ekstern>-<YYYY-MM-DD>.md
```

- **Testplan-slugen** er scope-slugen for et scope, `<domene>-<oppgave-slug>` for en oppgave (en oppgave-slug er bare unik innenfor domenet), og navnet på mappa eller fila i kebab-case for en mappe eller fil.
- **Hver fil** har metadata øverst, så en strek (`---`), og under den innholdet som publiseres i Confluence. Metadataene publiseres ikke.
- **Fila er utkastet** fram til testen starter. Etter det er siden i Confluence kilden for resultatene, og fila oppdateres fra siden av `fs-testrapport`.
- **Bevis.** Hver testcase i fase 2 lagrer steg, input, faktisk resultat og skjermbilde eller logg, slik at et menneske kan etterprøve resultatet. `resultat.md` i kjøringsmappa committes. Skjermbilder og andre filer i `kjoring-*/` holdes utenfor git av `.gitignore`, og `resultat.md` viser til dem som «lokalt, ikke i git».

## Kravene

En testplan gjelder et scope, en oppgave, en mappe under `krav/` eller én eller flere feature-filer (`- **Kilde**:` i testplanen):

- **Scope:** alle kravene og delene med taggen `@scope-<slug>`.
- **Oppgave:** kravene i oppgavens rad i scope-tabellen.
- **Mappe:** alle feature-filene under mappa.
- **Feature-fil:** filene.

Det som testes, er det som er `@implemented`, også de leverte delene i et krav som er delvis levert (`@implemented` på en regel eller et scenario under en `@in-progress` egenskap). Krav som er `@in-progress`, og delene som ikke er levert, står i «Venter på verifisering», og resten i «Ikke med i denne testen».

Er et krav med i en flyt i `krav/_Flyter/`, står flyten i «Flyter» i testplanen, og overleveringene i den testes også, i den interne akseptansetesten (fase 3): at det ett krav lager, blir brukt av det neste. Hele flyten testes når den er `@implemented`, ellers fasene i leveransen som er levert. Se *Flyter* i [`krav-fra-testplan.md`](../.claude/references/akseptansetest/krav-fra-testplan.md).

Kravene står med Feature-ID i «Omfang» i testplanen, og alle skillene i flyten leser dem derfra, så alle fasene tester de samme kravene. Scope-id-ene kravene har, står i `- **Scope**:`. De automatiske testene av de samme kravene kjøres med `npx playwright test --grep @scope-<slug>`, eller med Feature-ID-ene når kravene ikke har scope. Reglene står i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../.claude/references/akseptansetest/krav-fra-testplan.md).

## Fase 2: agentisk funksjonstest

Mesteparten av den funksjonelle testingen skjer her. En agent kjører testene i Chrome med `cdp`-skillen, mot testmiljøet. Testene er ikke en del av testplanen: de er varige, ligger i [`cdp-tester/`](../cdp-tester/README.md), og lages og oppdateres med `fs-testcaser-cdp`, fra kravene, reglene i koden uten scenario (fra verify-rapporten) og reglene agenten utleder. Det som hører til leveransen, er kjøringene. Gherkin-testene er ikke bundet til verktøyet: andre kan bruke dem også.

- **Samme grunnlag.** Roller, testbrukere og testdata planlegges i testplanen, med de samme spørsmålene for alle fasene (se [`.claude/references/akseptansetest/roller-og-testdata.md`](../.claude/references/akseptansetest/roller-og-testdata.md)). `fs-testplan` fyller ut kolonnene `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand`, `Opprettes av`, `Brukes av` og `Rydding`, og leser koden for å vise hva løsningen krever.
- **Egne testdata.** Testautomatiseringen lager sine egne testdata, manuelt gjennom løsningen eller seedet via API, og setter dem tilbake etterpå, så testene kan kjøres på nytt. Testplanen vurderer det per krav.
- **Nøkler, ikke navn.** Testene bruker nøkler (`brukeradministrator-alle-miljoer`), som slås opp i testplanen ved kjøring, så de overlever en ny testplan med andre testbrukere.
- **Resultatet** skrives til `akseptansetest/<slug>/kjoring-<YYYY-MM-DD>-<HHMM>/resultat.md`, og er et forslag: en tester bekrefter statusen, og `fs-testrapport` teller først etter det. Skjermbilder og annet legges i samme mappe, men `.gitignore` holder dem utenfor git: bare `resultat.md` committes.
- **Bare i testmiljø.** Agenten avbryter hvis URL-en er produksjon.

## Testcasene

Kolonnene er `Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status`:

- **Faktisk resultat** er det testeren så, som fritekst.
- **Status** er `Bestått`, `Ikke bestått` eller `Ikke testet` (med en kort begrunnelse). Det er den testrapporten teller.

Testcasene i fase 2 er Gherkin i `cdp-tester/`, og i fase 3 og 4 tabeller på testsiden. Fase 3 har én testcase per flyt, med eget resultat per scenario.

Reglene for testcasene står i [`.claude/references/akseptansetest/testcase-regler.md`](../.claude/references/akseptansetest/testcase-regler.md).
