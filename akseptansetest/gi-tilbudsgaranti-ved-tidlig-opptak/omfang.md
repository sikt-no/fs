# Omfang – Gi tilbudsgaranti ved tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180882969
- **Laget**: 2026-11-09 av fs-testplan

---

Omfanget for «Gi tilbudsgaranti ved tidlig opptak»: kravene og flytene som testes, og det som ikke er med. Kravene i «Omfang» er kriteriene for godkjent, og alle skillene i testflyten leser dem herfra. Testplanen: Testplan – Gi tilbudsgaranti ved tidlig opptak.

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/072f40ee/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | `@in-progress` (delvis levert) | 25 |

De leverte delene:

- Regel: Opptaksforvalter gjennomfører tidligopptaket (20 scenarioer)
- Regel: Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt: «Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak» og «Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak»
- Regel: Opptaksforvalter ser utfallet av tidligopptaket: «Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon» og «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak»
- Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket (1 scenario)

Ingen av scenarioene i testen har et åpent spørsmål. Spørsmålet om «Reservert studieplass gir tilbudsgaranti uten kvalifisering» ble lukket 09.11.2026, etter verifiseringen: tilbudsgaranti er tilbudsgaranti, uansett kvalifisering.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-BEH-BEH-007"`.

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen er klar til implementasjon, og testes som den står. Oversikten viser hvor mye som står åpent. Tallene regnes fra kravfilene og verify-rapporten.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen |
|---|---|---|---|---|
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/072f40ee/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | 0 av 4 | 0 av 27 | 25 |

I tillegg har 6 utsatte scenarioer (`@draft @openquestion`) spørsmålet «Utsatt fra første leveranse (09.11.2026). Om og hvordan dette skal bygges, avgjøres etter testen av første leveranse: trenger sjekken av innstillingene og prøvekjøringen en grundig gjennomgang?». De er ikke med i testen. Testen av denne leveransen er derfor også grunnlaget for det spørsmålet.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

Ingen av kravene er med i en flyt. Oversiktsflyten Opptaksløpet (`@FLY-OPT-OPT-001`) har fasen «Søkeren får tilbudsgaranti i tidlig opptak», men flyten for den er ikke skrevet (forslaget: `tidlig_opptak.feature`).

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-BEH-BEH-007` | Ingen | Ny flyt bør lages (`fs-krav`, modus E): `tidlig_opptak.feature` i Opptaksløpet, fra søknaden om tidlig opptak til tilbudet i hovedopptaket. Til den finnes, testes gjennomføringen som en oppgave uten flyt |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon (finn dem med `grep -rn "@depends-on-<Feature-ID>" krav/_Flyter/`).

### Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Teamet lister da det leveransen bygger på eller påvirker utenfor brukerens flyt, og det sjekkes underveis i flytene der det er mulig, ellers for seg. [Fylles ut: testleder avgjør om kartet trengs. Forslaget under er fra kravene og koden.]

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| Konklusjonen for tidlig opptak i saksbehandlingen (`@OPT-BEH-BEH-013`) | Annen modul i FS | I oppgaven «Gjennomføre tidligopptaket»: at konklusjonen per organisasjon gir riktig utfall, og at konklusjonen kan endres etter gjennomføringen (utsatt fra testplanen for saksbehandling av tidlig opptak) |
| Opptaksinnstillingene på utdanningstilbudet (`@OPT-OPT-UTD-004`, `@draft`) | Annen modul i FS | Utgangstilstanden: utdanningstilbudene tilbyr tidlig opptak, og har poenggrense |
| Median poengsum fra forrige opptak (`@OPT-OPT-UTD-010`, Shinkansen) | Annet teams leveranse | Utgangstilstanden: utdanningstilbud med og uten median |
| Svaret til søkeren (`@OPT-SØK-SØK-012`) og publiseringen (`@OPT-BEH-BEH-014`) | Annen modul i FS | Gjennomføringen gjør svaret synlig for søkerne. Sjekkes i Min kompetanse etter gjennomføringen |
| Plasstildelingen i hovedopptaket (`@OPT-PLA-TIL-002`) | Annen modul i FS | Ikke i denne testen. Søknadsalternativer uten tilbudsgaranti går videre til det ordinære opptaket |

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/072f40ee/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | `@in-progress` | Scenarioene «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» og «Se antall utdanningstilbud med mangelfulle innstillinger»: prøvekjøringen i fs-admin viser ikke avvikene (`TidligOpptakResultModal.tsx:28-38`). Kommentert på STEK-489 |

## Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har et scenario i kravet, for eksempel valideringer og tilgangssjekker. De er input til de agentiske testcasene (fase 2).

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten poengsum i garantikvoten gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:765-775` | ja | nei |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kvoter eller kompetanseregelverk gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:699-708, 745-763` | nei: utgangstilstanden kan ikke lages i opptak 34 uten å endre utdanningstilbudene andre tester bruker | nei: visningen er utsatt i kravet |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med i tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:362-363` | nei: utdanningstilbudene i opptak 34 brukes av andre tester | nei |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i og som tilbudet har, og fra grunnlag rangeringsregelverket åpner for | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:922-927, 937-960` | ja | nei |
| `@OPT-BEH-BEH-007` | Kvalifiseringen: ett kvalifisert grunnlag holder. Søkeren er ikke kvalifisert bare når alle grunnlagene er vurdert til nei, ellers er kvalifiseringen ikke vurdert | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:790-813` | ja | nei |
| `@OPT-BEH-BEH-007` | Trukne søknadsalternativer og saker som ikke er aktive, er ikke med | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:534, 544, 868-869` | ja | nei |
| `@OPT-BEH-BEH-007` | En søker som ikke har søkt om tidlig opptak, men har et tidligopptakstilbud på et søknadsalternativ, er med og får tilbudsgaranti fra tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:520-545` | ja | uklart om ønsket: avklares med `fs-krav` |
| `@OPT-BEH-BEH-007` | Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:692-694, 1022-1024` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Treffer en skriving ingen rad, stoppes hele gjennomføringen og rulles tilbake | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:1005-1012` | nei: krever samtidige endringer | nei |
| `@OPT-BEH-BEH-007` | Gjennomføringen er sperret i fs-admin til prøvekjøringen har gitt en oppsummering, når poenggrenser ikke er lagret, og når prøvekjøringen gir feil | `fs-admin/…/TidligOpptakResultModal.tsx:150-154, 162-165` | ja | nei |
| `@OPT-BEH-BEH-007` | Antallet i meldingen etter gjennomføringen teller avvik (ett utdanningstilbud kan ha flere), tar med overskredet kvote, og vises bare når det er over 0 | `fs-admin/…/KjorTidligopptakButton.tsx:129-134` | nei: venter på at avvikene vises i prøvekjøringen | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kvotevarselet er 30 prosent når grensen ikke er angitt | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:96-97` | nei: kvotevarselet er utsatt | nei: dekkes av det utsatte scenarioet |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@OPT-BEH-BEH-007` «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» og «Se antall utdanningstilbud med mangelfulle innstillinger» | Venter på verifisering: mangler i fs-admin |
| `@OPT-BEH-BEH-007` «Se utfallet for hver søker» | Kommer senere: utsatt fra første leveranse |
| `@OPT-BEH-BEH-007` «Se hva som mangler for hvert utdanningstilbud med mangelfulle innstillinger» | Kommer senere: utsatt fra første leveranse |
| `@OPT-BEH-BEH-007` «Varsel når tilbudsgarantiene overskrider kvoten», «Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring», «Kvotevarsel ved 30 prosent når grensen ikke er angitt» og «Angi grensen for kvotevarsel» | Kommer senere: utsatt fra første leveranse |
| Melding til søkerne om svaret (`@OPT-BEH-BEH-014`) | Utenfor leveransen. Meldingene er utsatt |
| Tilbud i hovedopptaket til søkere med tilbudsgaranti (`@OPT-PLA-TIL-002`) | Utenfor leveransen |
