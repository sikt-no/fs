# Scope: Opprette opptak 2027

- **Slug**: opprette-opptak-2027
- **Initiativ**: [#211](https://github.com/sikt-no/fs/issues/211)
- **Eier**: –
- **Siste oppdatering**: 2026-10-19

## Mål

- Opptaksforvalter kan opprette et opptak, samordna eller lokalt, med navn, regelverkssamling og opptakstype.
- Opptaksforvalter ved forvaltende organisasjon kan invitere læresteder til et samordna opptak, og knytte regler for saksbehandlertildeling til opptaket.
- Opptaksforvalter kan sette innstillingene, fristene og utdanningsbakgrunnene for opptaket.

## Ikke-mål

- Å legge til utdanningstilbud i opptaket (oppgave 9, løses av Shinkansen). Kravet står i [scope-utdanningstilbud-i-opptak-2027](scope-utdanningstilbud-i-opptak-2027.md).
- Selve fordelingen av søknader til saksbehandlende organisasjoner. Den står i `@OPT-BEH-BEH-011` [tildele_saksbehandlende_organisasjon.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature), og løses av Puff. Det som er med her (oppgave 8), er at opptaksforvalter kan knytte reglene til opptaket, i `@OPT-OVO-SAM-001`.
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
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-SAM-001` [samordna_opptak.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Must | – | – | Oppgave 2: invitere læresteder til samordna opptak. Synk og replika mot utdanningsregisteret må fikses, nytt design, begrense til fagskoler og UH. Regelen om å knytte regler for saksbehandlertildeling til opptaket er oppgave 8. Jira [TAKE-380](https://sikt.atlassian.net/browse/TAKE-380) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-INN-001` [innstillinger.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Must | – | [#578](https://github.com/sikt-no/fs/issues/578) | Oppgave 4: sette innstillinger i opptaket (blant annet startnummer og maks søknadsalternativer). Reglene om utdanningsbakgrunner hører til oppgave 7. Jira [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) og [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) |
| [opprette-og-vedlikeholde-opptak](opprette-og-vedlikeholde-opptak/) | `@OPT-OVO-FRI-001` [frister_og_hendelser.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Must | – | [#579](https://github.com/sikt-no/fs/issues/579) | Oppgave 6: sette frister og hendelser for opptaket. Avvikende frister per utdanningsbakgrunn hører til oppgave 7. Jira [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) og [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) |
| (ikke tildelt) | `@OPT-OVO-LOG-001` [hendelseslogg.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/06%20Hendelseslogg/hendelseslogg.feature) | Should | – | – | Oppgave 10: hendelseslogg for opptak. Venter på en generell løsning |
| (ikke tildelt) | `@OPT-OVO-TEK-001` [fellestekster.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/05%20Tekster/fellestekster.feature) | Won't | – | [#214](https://github.com/sikt-no/fs/issues/214) | Oppgave 11: fellestekster som blir synlige for søkere. Informasjonen utledes fra innstillingene, og tekstene forvaltes i repo. Jira [TAKE-322](https://sikt.atlassian.net/browse/TAKE-322) |
| (ikke tildelt) | `@OPT-OVO-TEK-002` [svarmeldingsmal.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/05%20Tekster/svarmeldingsmal.feature) | Won't | – | [#214](https://github.com/sikt-no/fs/issues/214) | Oppgave 12: svarmeldingsmal (juridisk kjerne, parametere og valgfritt tillegg). Utsatt til senere iterasjon, ses i sammenheng med tekstforvaltning. Jira [TAKE-323](https://sikt.atlassian.net/browse/TAKE-323) |
| (ikke tildelt) | `@OPT-OVO-GRU-001` — Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak | Won't | – | – | Oppgave 13: utsatt til senere iterasjon. Åpent spørsmål: hva kopieres, og hva kopieres ikke? |
| (ikke tildelt) | `@OPT-OVO-GRU-001` — Regel: Opptaksforvalter kan deaktivere et opptak | Won't | – | – | Oppgave 14: utsatt til senere iterasjon |

## Uløst arbeid

Akseptansetesten 2026-10-19 testet at opptaket blir opprettet med riktige innstillinger og frister. Virkningen av innstillingene og fristene hos søkeren, i saksbehandlingen og for utdanningstilbudene er ikke med i dette scopet. Kravene i `@OPT-OVO-INN-001` og `@OPT-OVO-FRI-001` beskriver derfor bare at verdiene settes og finnes på opptaket, og virkningen står i kravet der verdien brukes.

Virkningene under hadde ikke noe krav. De er lagt inn som regler der de brukes (`@draft`, eller uten status når hele kravet er `@draft`), og har ingen oppgave ennå. De må få et scope med `fs-scope` før de kan bygges.

| Innstilling eller frist | Krav der virkningen står | Regel |
|---|---|---|
| Søknadsdato og ordinær søknadsfrist | `@OPT-SØK-SØK-001` [søke_på_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_p%C3%A5_opptak.feature) | Søkeren kan begynne på og sende inn en søknad bare når søknaden i opptaket har åpnet |
| Utdanningsbakgrunner med avvikende frister | `@OPT-SØK-SØK-001` [søke_på_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_p%C3%A5_opptak.feature) | Søknadsfristen og dokumentasjonsfristen følger søkerens utdanningsbakgrunn |
| Utdanningsbakgrunner i opptaket | `@OPT-SØK-SØK-001` [søke_på_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_p%C3%A5_opptak.feature) | Søkeren velger utdanningsbakgrunn blant utdanningsbakgrunnene i opptaket |
| Startnummer for søknadene | `@OPT-SØK-SØK-001` [søke_på_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_p%C3%A5_opptak.feature) | Søknadsnummeret følger startnummeret i opptaket |
| Omprioriteringsfrist | `@OPT-SØK-SØK-006` [prioritere_søknadsalternativer.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/prioritere_s%C3%B8knadsalternativer.feature) | Rekkefølgen på søknadsalternativene er låst etter omprioriteringsfristen |
| Frist for sletting av søknadsalternativer | `@OPT-SØK-SØK-006` [prioritere_søknadsalternativer.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/prioritere_s%C3%B8knadsalternativer.feature) | Søkeren kan slette søknadsalternativer fram til fristen for sletting |
| Dokumentasjonsopplasting | `@OPT-SØK-SØK-003` [veilede_om_dokumentasjon.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/veilede_om_dokumentasjon.feature) | Søkeren kan laste opp dokumentasjon bare når opptaket åpner for det |
| Ordinær dokumentasjonsfrist | `@OPT-SØK-SØK-003` [veilede_om_dokumentasjon.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/veilede_om_dokumentasjon.feature) | Søkeren ser den ordinære dokumentasjonsfristen i opptaket |
| Dokumentasjonsfrist for tidlig opptak | `@OPT-SØK-SØK-011` [søke_om_tidlig_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) | Søkeren ser dokumentasjonsfristen for tidlig opptak |
| Søknadsfrist for tidlig opptak | `@OPT-SØK-SØK-011` [søke_om_tidlig_opptak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) | Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak |
| Ledige studieplasser og datoene | `@OPT-SØK-SØK-014` [søke_på_ledige_studieplasser.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_p%C3%A5_ledige_studieplasser.feature) (nytt krav) | Hele kravet |
| Når hovedopptaket publiseres | `@OPT-SØK-SØK-009` [se_egen_søknad.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_egen_s%C3%B8knad.feature) | Søkeren ser når hovedopptaket publiseres |
| Redigering av utdanningstilbud åpner og stenger | `@OPT-OPT-UTD-002` [legge_til_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/legge_til_utdanningstilbud.feature) | Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering |
| Redigering stenger (antall studieplasser) | `@OPT-OPT-UTD-007` [sette_studieplasser_og_antall_tilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature) | Deltakende organisasjoner kan endre antall studieplasser til første plasstildelingsrunde er publisert |
| Frist for poenggrenser for tidlig opptak | `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Deltakende organisasjon kan ikke endre poenggrensen for tidlig opptak etter fristen |
| Poenglikhetsregel uten unntak | `@OPT-OPT-UTD-015` [overstyre_regler_for_poenglikhet.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/overstyre_regler_for_poenglikhet.feature) | Utdanningstilbudet kan ikke overstyre poenglikhetsregelen når opptaket ikke åpner for unntak |

Virkninger som allerede hadde et krav, står som henvisning under hver regel i `innstillinger.feature` og `frister_og_hendelser.feature`.

## Åpne spørsmål

- [x] Oppgave 7 (utdanningsbakgrunner) har ikke egen GitHub-issue. Avklart 2026-10-12: den løses med reglene i `innstillinger.feature` og `frister_og_hendelser.feature`.
- [x] Skal oppgave 8 ha en egen oppgavemappe? Avklart 2026-10-12: nei. Det som er med i scopet, er å knytte regler til opptaket (`@OPT-OVO-SAM-001`). Fordelingen (`@OPT-BEH-BEH-011`) er tatt ut av scopet og løses av Puff.
