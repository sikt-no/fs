# Scope: Meldinger, varslinger og oppgaver

- **Slug**: meldinger-varslinger-og-oppgaver (= navnet på mappa og taggen `@scope-meldinger-varslinger-og-oppgaver`)
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: –
- **Jira**: –
- **Eier**: Tina Ravndal
- **Siste oppdatering**: 2026-11-09

## Mål

- Saksbehandleren, opptaksforvalteren og de ansatte ved tilbyderen kan sende en melding til én søker, i Min kompetanse og eventuelt på e-post og SMS, og opptaksforvalteren forvalter tekstene.
- Søkerne får påminnelse før fristene: om en påbegynt søknad som ikke er levert, og om dokumentasjonsfristen når søknaden har mangler. Opptaksforvalteren bestemmer hvor ofte påminnelsene går.
- Søkeren ser hva som må gjøres i søknadene (oppgaver) når søkeren logger inn i Min kompetanse. En oppgave forsvinner når den er gjort.
- Søkeren får melding når en mangel er sjekket ut (K5-2).
- Saksbehandleren ser all kommunikasjon med søkeren, og opptaksforvalteren ser mottakerne og utsendingene som feilet (blokkert av sporingsloggen).

## Ikke-mål

- Meldinger til et utvalg av søkerne eller til alle søkerne (K6, K7, K9, K10). De er utsatt til scopet [`meldinger-til-flere-sokere`](../meldinger-til-flere-sokere/scope.md).
- Vedtaksformidling, varselet om at vedtaket foreligger. Det er scopet [`vedtaksformidling`](../vedtaksformidling/scope.md), og er scopet ut i første omgang.
- Kvittering for registrert søknad og for endringer i søknaden (K2, K3, K4). Det er levert i `@OPT-SØK-SØK-010` (`mine_meldinger.feature`).
- Oppgaver for de ansatte. Oppgavene i scopet er søkerens.

## Kilder

- Miro-tavla fra workshopen om meldinger 2026-11-09: <https://miro.com/app/board/uXjVERCNuvk=/> — behovene, brukerhistoriene K1–K12 og beslutning 1–9
- Presentasjonen om løsningsarkitekturen fra workshopen: <https://claude.ai/artifact/WF5t81THoeXE3VEwkh5Xzk>

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-SØK-MEL-001` [sende_melding_til_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/sende_melding_til_s%C3%B8ker.feature) | Must | – | – | K11, beslutning 2, 4 og 8 |
| `@OPT-SØK-MEL-002` [påminne_søkere_om_frister.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/p%C3%A5minne_s%C3%B8kere_om_frister.feature) | Must | – | – | K1 og K8, beslutning 3 og 5 |
| `@OPT-SØK-MEL-003` [se_oppgaver.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/se_oppgaver.feature) | Should | – | – | K1-1 |
| `@OPT-SØK-MEL-004` [se_kommunikasjon_med_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/se_kommunikasjon_med_s%C3%B8ker.feature) | Should | – | – | K12 og beslutning 9. Blokkert av sporingsloggen (BAT-324) |
| `@OPT-BEH-BEH-008` [søknadsmangler.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/s%C3%B8knadsmangler.feature) | Must | – | – | Den nye regelen «Søkeren får melding når en mangel er sjekket ut» (K5-2, `@draft`). Kravet er delvis levert (`@in-progress` fra `fs-verify`), og er ikke i noen spesifikasjon. Se åpne spørsmål om scope-taggen |

## Åpne spørsmål

- [ ] Scopet har ingen Jira-sak. Det trengs ikke nå (Tina Ravndal, 2026-11-09).
- [ ] `@OPT-SØK-SØK-010` (`mine_meldinger.feature`) er levert, men bør gjennomgås mot behovene fra workshopen (K2–K4) på et tidspunkt.
- [ ] Påminnelsen om svarfristen står i `@OPT-PLA-SVA-002` (scopet `plasstildeling-2027`). Skal den flyttes hit?
- [ ] `@scope-meldinger-varslinger-og-oppgaver` står på `Egenskap:` i `@OPT-BEH-BEH-008`, og da hører hele søknadsmangler til scopet, ikke bare regelen om melding ved utsjekk (K5-2). På en del er taggen bare lov når egenskapen er `@implemented`, og kravet er `@in-progress`. Skal hele kravet være i scopet, eller skal regelen flyttes til `@OPT-SØK-MEL-001` med `@depends-on-OPT-BEH-BEH-008`, og taggen fjernes fra søknadsmangler? Scopet `automatisk-ferdigbehandling` har «resten av søknadsmangler» som ikke-mål.
- [ ] K5-2: hva skal meldingen si når en mangel er sjekket ut, og sendes den ved utsjekk eller når manglene publiseres på nytt? Spørsmålene står i regelen i søknadsmangler.
- [ ] Tilbyderen er lærestedet (`begreper.md`), ikke en rolle. Hvilken rolle har de ansatte ved tilbyderen som sender meldinger?
- [ ] Beslutning 8 (forvalteren forvalter tekstene) strider mot `@OPT-OVO-TEK-001` (`@wont`), der kvitteringen er en standardtekst.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-09 | Etter review av PR #999: `@draft`-regel for K5-2 i søknadsmangler, og åpne spørsmål om scope-taggen på `@OPT-BEH-BEH-008` og om rollen ved tilbyderen | @JøranIndseth | [#999](https://github.com/sikt-no/fs/pull/999) |
| 2026-11-09 | Opprettet med fs-scope, fra workshopen om meldinger. Fire skjelett-krav i `04 Meldinger og oppgaver`, og `@OPT-BEH-BEH-008` tatt inn for K5-2 | @JøranIndseth | – |
