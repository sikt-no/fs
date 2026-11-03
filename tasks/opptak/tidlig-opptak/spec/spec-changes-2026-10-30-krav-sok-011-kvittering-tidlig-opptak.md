# Delta-spec: kvitteringen og kontrollen for tidlig opptak — 2026-10-30-krav-sok-011-kvittering-tidlig-opptak

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Oppgave:** `tasks/opptak/tidlig-opptak/`
- **Type:** `branch`
- **Branch:** `krav/sok-011-kvittering-tidlig-opptak` (PR #890), branch-SHA `a91ce8edd2700e7eaad18d243c618cf68cf24a41`, main-SHA `7e601676747c9ed37da171db03daea1aafa0083a` ([sammenligning](https://github.com/sikt-no/fs/compare/7e601676747c9ed37da171db03daea1aafa0083a...a91ce8edd2700e7eaad18d243c618cf68cf24a41))
- **Lokalt:** `git diff 7e601676747c9ed37da171db03daea1aafa0083a...a91ce8edd2700e7eaad18d243c618cf68cf24a41 -- krav/`
- **Hentet:** 2026-10-30

## Omfang

Endringen kommer fra funn 1 i den interne akseptansetesten av «Søke om tidlig opptak» 30.10.2026 (testcase 2.4b). Kvitteringen for søknaden om tidlig opptak skal bare vise søknadsalternativene der utdanningstilbudet tilbyr tidlig opptak, og søkeren skal ikke kunne søke når opptaket har tidlig opptak, men ingen av søknadsalternativene tilbyr det. Begge deler følger av at tidlig opptak krever både at opptaket har tidlig opptak, og at utdanningstilbudet tilbyr det (avklart i `@OPT-OVO-INN-001`, TAKE-408). Endringen dekker fs-plattform, ikke Min kompetanse, som allerede viser det fs-plattform gir. Kvitteringer som allerede er laget, endres ikke.

## Krav

### Lagt til

- **`søke_om_tidlig_opptak.feature` — scenario «Kvitteringen viser søknadsalternativene som tilbyr tidlig opptak»** (`@OPT-SØK-SØK-011`, regel «Søkeren kan søke om tidlig opptak når opptaket tilbyr det») — kvitteringen viser søknadsalternativene som tilbyr tidlig opptak, og ikke dem som ikke gjør det. Tillegg, erstatter ingen del. ([etter](https://github.com/sikt-no/fs/blob/a91ce8edd2700e7eaad18d243c618cf68cf24a41/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature)) ([krav/…/søke_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature))
- **`søke_om_tidlig_opptak.feature` — scenario «Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det»** (`@OPT-SØK-SØK-011`, samme regel) — opptaket har tidlig opptak, men ingen av søknadsalternativene tilbyr det, og søkeren kan ikke søke. Erstatter «Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det (avvikles)». ([før](https://github.com/sikt-no/fs/blob/7e601676747c9ed37da171db03daea1aafa0083a/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature)) · ([etter](https://github.com/sikt-no/fs/blob/a91ce8edd2700e7eaad18d243c618cf68cf24a41/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature)) ([krav/…/søke_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature))

### Skal fjernes (`@deprecated`)

- **`søke_om_tidlig_opptak.feature` — scenario «Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det (avvikles)»** (`@OPT-SØK-SØK-011`) — erstattes av «Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det». Det gamle scenarioet hadde et opptak uten tidlig opptak, et tilfelle der ingen utdanningstilbud kan tilby det. ([før](https://github.com/sikt-no/fs/blob/7e601676747c9ed37da171db03daea1aafa0083a/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature)) ([krav/…/søke_om_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature))

Resten av `@OPT-SØK-SØK-011` er levert (`@implemented`), og er ikke med i denne delta-en.

## Avhengigheter

- **`@OPT-OVO-INN-001`** `innstillinger.feature` — `@implemented`. Brukes av regelen «Søkeren kan søke om tidlig opptak når opptaket tilbyr det» (tidlig opptak på opptaket). ([krav/…/innstillinger.feature](../../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature))
- **`@OPT-OPT-UTD-004`** `opptaksinnstillinger_utdanningstilbud.feature` — `@draft`. Brukes av samme regel (utdanningstilbudet tilbyr tidlig opptak). Kravet er ikke validert, men innstillingen finnes i koden, og rettingen bruker den. Brukeren valgte å hente scenarioene inn likevel (2026-10-30). ([krav/…/opptaksinnstillinger_utdanningstilbud.feature](../../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature))

## Skisser

Ingen skisse: kvitteringen og meldingen «Du har søkt om tidlig opptak» finnes i Min kompetanse, og endringen gjelder bare hvilke studier fs-plattform tar med, og en kontroll på serveren.

## Kodesjekk

Sjekket mot fs-plattform `6c8976d066` (2026-10-30). Koden gjør ikke det de to scenarioene sier, og det er grunnen til endringen. Kravene skal ikke endres:

- `opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/SoknadKvitteringService.java:126–135` (`settInnAlternativerTidligOpptak`): tar med alle søknadsalternativene når opptaket har tidlig opptak, og bare dem som tilbyr det ellers.
- `opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/tidligopptak/SokTidligOpptakService.java:98–120` (`assertTidligOpptakTilbys`): godtar søknaden når opptaket har tidlig opptak **eller** et søknadsalternativ tilbyr det. Min kompetanse skjuler knappen når ingen søknadsalternativer tilbyr det, så søkeren ser ikke avviket i dag.

Min kompetanse viser alle søknadsalternativene den får i kvitteringen (`kvittering-melding-content.tsx`), og trenger ingen endring.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/søke_om_tidlig_opptak.feature` — Scenario: Kvitteringen viser søknadsalternativene som tilbyr tidlig opptak | `@planned` | `@in-progress` |
| `krav/02 …/søke_om_tidlig_opptak.feature` — Scenario: Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det | `@planned` | `@in-progress` |

Det avviklede scenarioet beholder `@deprecated`.

## Åpne spørsmål

Ingen.

## Rute

fs-plattform
