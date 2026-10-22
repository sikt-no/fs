# Kjøring 2026-10-22 07:38: Grunnleggende brukeradministrasjon (pilot, personbrukerlisten)

- **Testplan**: [testplan.md](../testplan.md)
- **Miljø**: https://test-fsadmin.sikt.no/tilgangsstyring/personbrukere. Banneret «Testmiljøet» vises øverst på siden, og verten er `test-fsadmin.sikt.no`. Versjon og feature-flagg er ikke lest (flaggene står som av i debug-feltet øverst)
- **Tester**: [søke_opp_bruker.feature](../../../cdp-tester/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/søke_opp_bruker.feature) (`@TST-BRU-PER-GRU-001`)
- **Krav**: commit `c9fd3ed`, blob `f538492`
- **Kjørt av**: Claude (Sonnet 5.5) for Mats, med `cdp`-skillen mot brukerens egen Chrome, i fanen som var åpnet på siden. Ingen andre faner er rørt
- **Innlogget som**: «ANSVARSFULL FOTKREM (BRUKERADMINISTRATOR) Sikt testhøyskole», valgt i feltet «Overstyrt bruker» i debug-linja. Det er ikke bekreftet at dette er `brukeradministrator-alle-miljoer` (rolle i alle miljøer)
- **Hoppet over**: 3 med `[Fylles ut]` (nøkkelen `over-50-personbrukere` er ikke oppfylt), 0 `@endrer-data`
- **Gjort på siden**: lest tekst og DOM, tatt skjermbilder (ligger lokalt i denne mappa, ikke i git), åpnet og lukket nedtrekket «Status» (ingen verdi valgt, URL og antall rader uendret). Ingenting er lagret eller endret

---

| Test (`@TST-…`) | Regel | Scenario | Foreslått status | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|
| `@TST-BRU-PER-GRU-001` | Liste over alle personbrukere | Se liste over personbrukere | Bestått | Listen «Resultater» har kolonnene «Navn», «Feide-ID», «Hjemorganisasjon» og «Status». Alle 25 rader har alle fire felt. 11 rader har ikke navn og viser «-». Alle har hjemorganisasjon «Sikt Testhøyskole» og status «Aktiv». Radene er sortert stigende på navn, og på Feide-ID der navnet mangler (kontrollert på alle 25 med norsk sortering) | Siden var allerede åpen (menyveien «Tilgangsstyring» → «Personbrukere» er ikke gått). Leste kolonneoverskrifter og radtekst, og sammenlignet rekkefølgen | Skjermbilde `4-1-listen.png` (lokalt, ikke i git). Tekst fra siden: «25 rader i listen», første rader Alf Alfsen, Andreas Foss, Anne LærerVGS Haugen |
| `@TST-BRU-PER-GRU-001` | Liste over alle personbrukere | Liste viser de 50 første personbrukerne | Ikke testet | `over-50-personbrukere` er ikke oppfylt: listen viser «25 rader i listen», ikke «Viser 50 av N rader», og det finnes ingen «Last inn flere». Testbrukeren ser bare 25 personbrukere | Leste antall rader og tellingen | Skjermbilde `4-1-listen.png` (lokalt, ikke i git) |
| `@TST-BRU-PER-GRU-001` | Liste over alle personbrukere | Laste inn 50 flere personbrukere | Ikke testet | Som over: det finnes ingen «Last inn flere» å velge | – | – |
| `@TST-BRU-PER-GRU-001` | Liste over alle personbrukere | Alle personbrukere er lastet inn | Ikke testet | Som over. «Last inn flere» vises ikke, og tellingen er «25 rader i listen», men scenarioet krever at det først finnes over 50, så dette er ikke et bevis for scenarioet | – | – |
| `@TST-BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Tilgjengelige statuser i filter | Bestått | Filteret «Status» har valgene «Alle statuser» (valgt som standard), «Aktiv» og «Deaktivert», i den rekkefølgen | Klikket på filteret «Status», leste valgene (`role=option`), trykket Escape. Filteret lukket seg uten at noe ble valgt | Skjermbilde `4-8-statusfilter.png` (lokalt, ikke i git) |

## Funn

1. **Testdataene stemmer ikke med verifiseringen 7.10.** Verifiseringen fant 71 aktive personbrukere, alle med hjemorganisasjon Sikt. Denne testbrukeren ser 25, alle med hjemorganisasjon «Sikt Testhøyskole». `over-50-personbrukere` er derfor ikke oppfylt for denne brukeren. Enten er dataene endret, eller en annen «Overstyrt bruker» ser flere. Avklares med teamet før 4.2–4.4 kan kjøres.
2. **11 av 25 rader har ikke navn og sorteres på Feide-ID.** Kravet sier «sortert etter navn i stigende rekkefølge». Frontend-koden sier at serveren bruker Feide-ID som reserve, så dette er kjent atferd, men kravet nevner det ikke. Foreslått status på 4.1 er likevel «Bestått», siden raden uten navn viser «-» og står i rekkefølgen etter reserveregelen. En tester avgjør. Alvorlighetsgrad: Kan fikses senere (krav og løsning er ikke helt enige).
3. **Ingen deaktiverte personbrukere** blant de 25 (alle har «Aktiv»). «Filtrere på status» kan bare sjekkes for «Aktiv».
4. **Filteret «Rolle» er deaktivert** (skravert, «Alle roller»), mens siden har lastet ferdig. Frontend-koden deaktiverer filteret når det ikke finnes valg. Er ikke fulgt opp, siden scenarioene for rollefilteret ikke er med i piloten.

## Hva piloten lærte om formatet

- **`[role=status]` er feil hook for tellingen.** Første treff er en annen region med teksten «Jobber, et øyeblikk...». Tellingen står som vanlig tekst under «Resultater» («25 rader i listen»). Testene sier «ser jeg teksten …», så ordlyden holder, men agenten må lese siden som tekst, ikke etter rolle.
- **Radtekst har skjulte etiketter** («Navn:», «Feide-ID:» …), så en rad gir 8 tekstlinjer, ikke 4. Den første sorteringssjekken min ble feil av dette, og er gjort om (resultatet over er fra den andre).
- **Filtrene er `button` med `role=combobox`**, med navnet «Status», og valgene er `role=option`. Ikke `input`.
- **Innloggingen går via «Overstyrt bruker»** i debug-linja i testmiljøet, ikke bare Feide-innlogging. `Innlogging` i testplanen bør si hvilken verdi som velges, og testen bør sjekke hvem som er valgt. Navnet står øverst på siden.
- **Nøkkelen `over-50-personbrukere` gjorde jobben:** scenarioene ble stående som «Ikke testet» i stedet for å gi en falsk grønn status. Utgangstilstanden bør sjekkes først (antall rader), og scenarioet hoppes over med begrunnelse hvis den ikke stemmer.
- **Ikke gjort i piloten:** menyveien fra forsiden («Tilgangsstyring» → «Personbrukere») er ikke prøvd, siden siden var åpnet på forhånd, og bytte av testbruker er ikke prøvd.

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den før `fs-testrapport` teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten.
