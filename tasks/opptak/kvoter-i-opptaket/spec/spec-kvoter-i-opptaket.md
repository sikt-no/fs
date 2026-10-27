# Spec: Kvoteprioritet og standard plassflyt i regelverkssamlingen

## Kilde

- **Oppgave:** `tasks/opptak/kvoter-i-opptaket/`
- **Kilde-mappe:** `krav/02 Opptak/10 Regelverk/04 Kvoter/`
- **Scope:** scope-kvoter-i-opptaket-2027
- **GitHub:** [#216](https://github.com/sikt-no/fs/issues/216), [#598](https://github.com/sikt-no/fs/issues/598)
- **Hentet:** 2026-10-26 12:30

## Omfang

Regelverksforvalteren ved organisasjonen som eier regelverkssamlingen, rangerer kvotetypene med kvoteprioritet og setter standard plassflyt med én hovedkvote. Begge deler gjøres i fanen «Kvoteprioritet og plassflyt» i regelverkssamlingen, og gjelder alle opptak som bruker regelverkssamlingen. Spesifikasjonen dekker å sette, lagre og validere innstillingene, med varsel på kvotetyper som mangler kvoteprioritet eller ikke er koblet til plassflyten. Hva plasstildelingen og utdanningstilbudene gjør med innstillingene, er ikke med (`@OPT-PLA-TIL-002`, `@OPT-PLA-INN-002`, `@OPT-OPT-UTD-004`).

## Krav

- **`sette_kvoteprioritet.feature`** (`@OPT-REG-KVO-004`) — kvotetypene rangeres fra 1 til antall kvotetyper, uten like tall, og kan lagres med kvotetyper uten kvoteprioritet. ([krav/02 Opptak/10 Regelverk/04 Kvoter/sette_kvoteprioritet.feature](../../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_kvoteprioritet.feature))
- **`sette_plassflyt.feature`** (`@OPT-REG-KVO-003`) — standard plassflyt med én hovedkvote, én mottaker per kvote, regler for SPEV-kvoter og vern mot ring. ([krav/02 Opptak/10 Regelverk/04 Kvoter/sette_plassflyt.feature](../../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_plassflyt.feature))

## Skisser

### Skisse: Utkast i fs-admin (gjeldende design)

- **Type:** `annet`
- **Referanse:** branchen `poc-pattern-skills` i fs-admin (`266400461`), `src/domains/regelverk/features/Kvoteinnstillinger/`. Review-miljøet (krever innlogging): https://studieadm-fs-admin-review-poc-patter-z2lvpk.sokrates.edupaas.no/regelverk/regelverksamlinger/cmVnZWx2ZXJrc2FtbGluZzpGU1UsMTk0/kvoteinnstillinger
- **Dekker krav:** `sette_kvoteprioritet.feature`, `sette_plassflyt.feature`
- **Valideringsstatus:** `Avvik: varselet om ny kvotetype, tallgrensen, SPEV som hovedkvote eller mottaker, taggen i redigering og feiltekstene fra serveren` (se `## Kodesjekk`)
- **Beslutning ved avvik:** Kravene er riktige, utkastet justeres. Avklart 2026-10-26, og står i implementasjonsdetaljene.

### Skisse: Kvoteprioritet

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/kvoteprioritet/screenshot.png)
- **Dekker krav:** `sette_kvoteprioritet.feature`
- **Valideringsstatus:** `Avvik: innstillingen står på opptaket, og tallene er ikke 1 til antall kvotetyper`
- **Beslutning ved avvik:** Kravene er riktige, skissen er utdatert (avklart i kravet 2026-10-15 og 2026-10-21). Utkastet i fs-admin er gjeldende design.

### Skisse: Kvoter (prototyp v1.13)

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/kvoter-gjeldende/screenshot.png)
- **Dekker krav:** `sette_plassflyt.feature`
- **Valideringsstatus:** `Avvik: innstillingen står på opptaket, og teksten «Ledige plasser i disse kvotene flyttes ikke til andre kvoter.» er feil`
- **Beslutning ved avvik:** Kravene er riktige, skissen er utdatert (avklart i kravet 2026-10-19 og 2026-10-21). Utkastet i fs-admin er gjeldende design.

## Implementasjonsdetaljer

- **`sette_kvoteprioritet.feature`** — [sette_kvoteprioritet.design.md](../../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_kvoteprioritet.design.md)
- **`sette_plassflyt.feature`** — [sette_plassflyt.design.md](../../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_plassflyt.design.md)

## Kodesjekk

- **Sjekket:** fs-admin (utkastet på `poc-pattern-skills`, `266400461`), fs-plattform (main, `97fbafa9b3`)
- **fs-plattform mangler det meste:**
  - Det finnes kolonner for kvoteprioritet og plassflyt per kvotetype (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/regelverk/kvote.graphqls:211-212`), og de oppdateres én kvotetype om gangen (`kvote.graphqls:169-187`).
  - Hovedkvote på regelverkssamlingen, lagring av hele rangeringen og hele plassflyten, og valideringen (unike tall 1 til antall kvotetyper, SPEV, ring) finnes ikke. I utkastet er det mock (`fs-admin@poc-pattern-skills/src/domains/regelverk/features/Kvoteinnstillinger/mockedOperations.ts`, `src/mocks/kvoteinnstillinger/`). Koden skal endres.
- `@OPT-REG-KVO-004` «Sette kvoteprioritet»: kravet beskriver tall, mens utkastet rangerer med dra og «Flytt opp/ned». Det er greit. API-et skal avvise tall som ikke er hele tall fra 1 til antall kvotetyper i regelverkssamlingen. Mocken tillater i dag 1 til antall rangerte (`src/mocks/kvoteinnstillinger/validering.ts:86-90`). Koden skal endres.
- `@OPT-REG-KVO-004` «Ny kvotetype kommer inn uten kvoteprioritet»: `opprettKvotetypeV2` tar imot `kvoteprioritetDefault` (`kvote.graphqls:155-156`, `KvotetypeMutations.java:50`). En ny kvotetype skal aldri få kvoteprioritet når den opprettes. Migreringen V189 kopierte `kvoteprioritet_default`, så regelverkssamlinger som finnes, kan ha tall fra før. Hva som skjer med dem, avgjør utviklerne. Koden skal endres.
- `@OPT-REG-KVO-004` og `@OPT-REG-KVO-003` «varsel på kvotetypen»: varselet i fanen (samlet varsel og tagg på raden) er nok. Taggen «Ikke koblet til plassflyten» skal også vises i redigering (`PlassflytSection.tsx:386-388`). Koden skal endres.
- `@OPT-REG-KVO-003` SPEV: en SPEV-kvote kan i utkastet velges som hovedkvote (`PlassflytSection.tsx:243-247`) og som mottaker for andre kvoter (`utils/plassflyt.ts:38`). Ingen av delene skal være lov. Kravet har fått regelen «En SPEV-kvote kan ikke være hovedkvote eller mottaker for andre kvoter» (2026-10-26). Koden skal endres.
- `@OPT-REG-KVO-003` «Sirkulær plassflyt»: eksempelet satte en mottaker på hovedkvoten, som ikke er mulig. Det er byttet til en ring mellom SAM og NN (2026-10-26).
- `@OPT-REG-KVO-003` feiltekster: utkastet viser meldingen fra serveren før teksten i fs-admin (`PlassflytSection.tsx:173-181`). Tekstene i implementasjonsdetaljene skal brukes. Koden skal endres.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/10 Regelverk/04 Kvoter/sette_kvoteprioritet.feature` | `@OPT-REG-KVO-004 @must @planned` | `@OPT-REG-KVO-004 @must @in-progress` |
| `krav/02 Opptak/10 Regelverk/04 Kvoter/sette_plassflyt.feature` | `@OPT-REG-KVO-003 @must @planned` | `@OPT-REG-KVO-003 @must @in-progress` |

`sette_plassflyt.feature` ble endret før retaggingen: ny regel om SPEV-kvoter, og et nytt eksempel i «Sirkulær plassflyt». Endringene er validert av produkteier 2026-10-26.

## Åpne spørsmål

Ingen.

## Rute

fs-plattform → fs-admin
