# Scope: Opprette opptak 2027

- **Slug**: opprette-opptak-2027
- **Initiativ**: [#211](https://github.com/sikt-no/fs/issues/211)
- **Eier**: –
- **Siste oppdatering**: 2026-10-12

## Mål

- Opptaksforvalter kan opprette et opptak, samordna eller lokalt, med navn, regelverkssamling og opptakstype.
- Opptaksforvalter ved forvaltende organisasjon kan invitere læresteder til et samordna opptak, og sette opp hvordan søknadene fordeles til saksbehandlende organisasjoner.
- Opptaksforvalter kan sette innstillingene, fristene og utdanningsbakgrunnene for opptaket.

## Ikke-mål

- Å legge til utdanningstilbud i opptaket (oppgave 9, løses av Shinkansen). Kravet står i [scope-utdanningstilbud-i-opptak-2027](scope-utdanningstilbud-i-opptak-2027.md).
- Interne saksbehandlingsfrister (oppgave 15). Fjernet: saksbehandlingen styres av publiseringsdatoene per plasstildelingsrunde.
- Det som står som (ikke tildelt) i tabellen, er utsatt: hendelseslogg (Should), fellestekster, svarmeldingsmal, gjenbruk av innstillinger og deaktivering av opptak (Won't).

## Kilder

- [GitHub #211](https://github.com/sikt-no/fs/issues/211) — initiativet «Opprette og vedlikeholde opptak».
- [oppgave.md](opprette-og-vedlikeholde-opptak/oppgave.md) — workshop 2026-09-14 og tidsrammene. Oppgavelista er flyttet hit.
- [Jira TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) — epic.
- [Confluence: T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377) — bakgrunn.
- [Figma: FS-Admin – Seksjon Opptak](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20606-117530) (node 20606:117530) — designfila for opptak i fs-admin.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-GRU-001` [opprett_opptak.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Must | – | [#577](https://github.com/sikt-no/fs/issues/577) | Oppgave 1: opprette et opptak med navn, regelverkssamling og opptakstype. Jira [TAKE-379](https://sikt.atlassian.net/browse/TAKE-379) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-SAM-001` [samordna_opptak.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Must | – | – | Oppgave 2: invitere læresteder til samordna opptak. Synk og replika mot utdanningsregisteret må fikses, nytt design, begrense til fagskoler og UH. Regelen om saksbehandlertildeling hører til oppgave 8. Jira [TAKE-380](https://sikt.atlassian.net/browse/TAKE-380) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-INN-001` [innstillinger.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Must | – | [#578](https://github.com/sikt-no/fs/issues/578) | Oppgave 4: sette innstillinger i opptaket (blant annet startnummer og maks søknadsalternativer). Reglene om utdanningsbakgrunner hører til oppgave 7. Jira [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) og [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-FRI-001` [frister_og_hendelser.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Must | – | [#579](https://github.com/sikt-no/fs/issues/579) | Oppgave 6: sette frister og hendelser for opptaket. Avvikende frister per utdanningsbakgrunn hører til oppgave 7. Jira [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) og [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-BEH-BEH-011` [tildele_saksbehandlende_organisasjon.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | Must | – | [#207](https://github.com/sikt-no/fs/issues/207) | Oppgave 8: saksbehandlertildelingsregler for samordna opptak, en regeltype som legges til eksplisitt. Løses av Puff. Jira [TAKE-382](https://sikt.atlassian.net/browse/TAKE-382) |
| (ikke tildelt) | `@OPT-OVO-LOG-001` [hendelseslogg.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/06%20Hendelseslogg/hendelseslogg.feature) | Should | – | – | Oppgave 10: hendelseslogg for opptak. Venter på en generell løsning |
| (ikke tildelt) | `@OPT-OVO-TEK-001` [fellestekster.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/05%20Tekster/fellestekster.feature) | Won't | – | [#214](https://github.com/sikt-no/fs/issues/214) | Oppgave 11: fellestekster som blir synlige for søkere. Informasjonen utledes fra innstillingene, og tekstene forvaltes i repo. Jira [TAKE-322](https://sikt.atlassian.net/browse/TAKE-322) |
| (ikke tildelt) | `@OPT-OVO-TEK-002` [svarmeldingsmal.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/05%20Tekster/svarmeldingsmal.feature) | Won't | – | [#214](https://github.com/sikt-no/fs/issues/214) | Oppgave 12: svarmeldingsmal (juridisk kjerne, parametere og valgfritt tillegg). Utsatt til senere iterasjon, ses i sammenheng med tekstforvaltning. Jira [TAKE-323](https://sikt.atlassian.net/browse/TAKE-323) |
| (ikke tildelt) | `@OPT-OVO-GRU-001` — Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak | Won't | – | – | Oppgave 13: utsatt til senere iterasjon. Åpent spørsmål: hva kopieres, og hva kopieres ikke? |
| (ikke tildelt) | `@OPT-OVO-GRU-001` — Regel: Opptaksforvalter kan deaktivere et opptak | Won't | – | – | Oppgave 14: utsatt til senere iterasjon |

## Åpne spørsmål

- [x] Oppgave 7 (utdanningsbakgrunner) har ikke egen GitHub-issue. Avklart 2026-10-12: den løses med reglene i `innstillinger.feature` og `frister_og_hendelser.feature`.
- [x] Skal oppgave 8, som Puff løser, ha en egen oppgavemappe? Avklart 2026-10-12: nei, den står under opprette-og-vedlikeholde-opptak.
