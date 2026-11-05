# Testrapport – intern akseptansetest – Opprette opptak 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165
- **Scope**: @scope-opprette-opptak-2027
- **Grunnlag**: testsidene, lest 2026-10-23:
  - https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126422620 (økt 1)
  - https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5129306145 (økt 2)
  - https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5129306169 (økt 3)
- **Confluence**: –
- **Laget**: 2026-10-23 av fs-testrapport

---

Testrapport for «Opprette opptak 2027». Rapporten bygger på den interne akseptansetesten 22.10.2026.

## Oppsummering

| Felt | Innhold |
|---|---|
| Testcaser | 54 bestått, 9 ikke bestått, 0 ikke testet, 37 ikke fylt ut, av 100 |
| Funn | Ingen ført i «Funn». Alle de 9 testcasene med «Ikke bestått» mangler funn |
| Testet av | [Fylles ut av testansvarlig] (står ikke på testsidene) |
| Testperiode | 22.10.2026 (sist endret på testsidene) |
| Forslag til utfall | Ingen forslag: testen ser ikke ferdig ut. 37 av 100 testcaser er ikke fylt ut (hele Del 4, frister), og ingen funn er ført |

## Resultat per krav

| Oppgave | Krav | Del | Bestått | Ikke bestått | Ikke testet | Ikke fylt ut |
|---|---|---|---|---|---|---|
| opprette-og-vedlikeholde-opptak | Opprette et opptak (`@OPT-OVO-GRU-001`) | 1 | 11 | 1 | 0 | 1 |
| opprette-og-vedlikeholde-opptak | Samordna opptak (`@OPT-OVO-SAM-001`) | 2 | 10 | 3 | 0 | 0 |
| opprette-og-vedlikeholde-opptak | Innstillinger for opptak (`@OPT-OVO-INN-001`) | 3 | 22 | 2 | 0 | 0 |
| opprette-og-vedlikeholde-opptak | Frister og hendelser for opptak (`@OPT-OVO-FRI-001`) | 4 | 0 | 0 | 0 | 36 |
| opprette-og-vedlikeholde-opptak | Listevisning og søk i opptak (`@OPT-OVO-OVE-001`) | 5 | 11 | 3 | 0 | 0 |
| | **Totalt** | | **54** | **9** | **0** | **37** |

Produkteier 23.10.2026: Del 4 er testet og godkjent, men testeren fylte ikke ut resultatene fordi stegene gjentok seg mye. Del 5 (oversikten) er godkjent. Tallene over teller bare det som står på testsidene.

Ikke fylt ut:
- **1.5a** Lagre opptak uten utdanningsbakgrunner: «Status» er «BeståttBe». Det er uklart, og telles ikke som bestått.
- **Del 4** (4.1–4.23): «Faktisk resultat» og «Status» er tomme i alle 36 testcasene.

## Ikke bestått

| Nr | Scenario | Faktisk resultat | Funn |
|---|---|---|---|
| 1.1 | Opprette et samordna opptak | HK-dir står ikke som organisasjon. | Mangler |
| 2.4 | Organisasjon som ikke deltar, kan ikke åpne opptaket. Kjent mangel (TAKE-434) | (tomt) | Mangler |
| 2.5 | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket. Kjent mangel (TAKE-433) | (tomt) | Mangler |
| 2.8 | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger. Kjent mangel (TAKE-432) | Fristen er ikke oppdatert. Ikke alle innstillingene vises. Det står «administreres av» (HK-dir mangler). | Mangler |
| 3.8 | Startnummeret er 1 når opptaksforvalter ikke har satt det. Kjent mangel (TAKE-431) | Feltet er blankt | Mangler |
| 3.13 | Aktivere tidlig opptak | Må også fylle ut informasjonsside om tidlig opptak | Mangler |
| 5.1 | Se liste over opptak | Viser også status. Organisasjon er tom. | Mangler |
| 5.3e | Velge sorteringsretning for organisasjon (stigende) | Organisasjon vises ikke i lista. | Mangler |
| 5.3f | Velge sorteringsretning for organisasjon (synkende) | Organisasjon vises ikke i lista. | Mangler |

## Ikke testet

Ingen.

## Funn

Ingen funn er ført i tabellen «Funn» på testsiden. Under står forslaget til funn ut fra testcasene med «Ikke bestått». Alvorlighetsgraden settes av testansvarlig.

| # | Testcase | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|
| 1 | 1.1, 2.8, 5.1, 5.3e, 5.3f | Organisasjonen til opptaket (HK-dir) vises ikke: tom i «Organisasjon» i lista over opptak, og «Administreres av» uten navn. Sorteringen på organisasjon kan derfor ikke sjekkes | Mangler alvorlighetsgrad | – | Feil i løsningen |
| 2 | 2.8 | Opptaksforvalter ved deltakende organisasjon ser ikke alle innstillingene, og ikke den endrede søknadsfristen | Mangler alvorlighetsgrad | TAKE-432 | Feil i løsningen (kjent mangel) |
| 3 | 2.4 | Organisasjon som ikke deltar, kan åpne opptaket med adressen | Mangler alvorlighetsgrad | TAKE-434 | Feil i løsningen (kjent mangel) |
| 4 | 2.5 | Deltakende organisasjon med utdanningstilbud kan fjernes fra opptaket | Mangler alvorlighetsgrad | TAKE-433 | Feil i løsningen (kjent mangel) |
| 5 | 3.8 | Startnummeret er blankt når det ikke er satt, ikke 1 | Mangler alvorlighetsgrad | TAKE-431 | Feil i løsningen (kjent mangel) |
| 6 | 3.13 | Tidlig opptak kan ikke lagres uten lenke til informasjonssiden | Mangler alvorlighetsgrad | – | Testcasen var feil: kravet sier at lenken må være satt når tidlig opptak er aktivert (3.15), så steget mangler i 3.13 |
| 7 | 5.1 | Lista over opptak viser kolonnen «Status» | Mangler alvorlighetsgrad | – | Uklart krav: `fs-krav`. Kravet tok ut status med vilje. Skal kolonnen bort, eller inn i kravet? |

## Andre funn

Ingen ført på testsiden.

Notert fra «Faktisk resultat»: i 1.2 står det at «Fyll ut obligatoriske felt:» viser mange flere felt enn navnefeltene. Testcasen ble satt til «Bestått». Kontaktpersonen vurderer om det følges opp.

## Kjente mangler

Fylles ut ved «Godkjent med forbehold».

| Mangel | Ansvarlig | Frist |
|---|---|---|
| | [Fylles ut av teamet] | [Fylles ut av teamet] |

## Beslutning

| Felt | Innhold |
|---|---|
| Utfall | [Fylles ut av testansvarlig] |
| Begrunnelse | |
| Besluttet av og dato | |

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

## Neste steg

1. Test Del 4 (frister, 36 testcaser), og fyll ut «Status» i 1.5a.
2. Før funnene i «Funn» på testsiden, med alvorlighetsgrad og sak.
3. Kjør `fs-testrapport` (intern) på nytt. Den foreslår da et utfall, og testansvarlig skriver beslutningen.
4. Godkjent eller godkjent med forbehold: `fs-testcaser-ekstern`.

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: 3.13 (steget med lenken til informasjonssiden mangler).
