# Scope: Kvoter i opptaket 2027

- **Slug**: kvoter-i-opptaket-2027
- **Initiativ**: [#211](https://github.com/sikt-no/fs/issues/211)
- **Eier**: –
- **Siste oppdatering**: 2026-10-19

## Mål

- Opptaksforvalter ved forvaltende organisasjon kan sette standard plassflyt for opptaket: hvilken kvote ledige plasser går videre til, med nøyaktig én hovedkvote og uten sirkulær plassflyt.
- Opptaksforvalter ved forvaltende organisasjon kan sette kvoteprioriteten for opptaket: en rangering av alle kvotetypene i regelverkssamlingen som er knyttet til opptaket, fra 1 til antall kvotetyper.
- Kravene beskriver at plassflyten og kvoteprioriteten settes og finnes på opptaket (avklart 2026-10-19, samme prinsipp som de andre innstillingene i [scope-opprette-opptak-2027](scope-opprette-opptak-2027.md)). Det er det som skal lages og testes nå.
- Leveres før plasstildelingen ([scope-plasstildeling-2027](scope-plasstildeling-2027.md)), som bruker innstillingene.

## Ikke-mål

- Hva plasstildelingen gjør med plassflyten og kvoteprioriteten. **Virkningen er ikke løst, og skal løses senere.** Det står i `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) og `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature), i scope-plasstildeling-2027.
- At lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine. Regelen står i `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature), i [scope-utdanningstilbud-2027](scope-utdanningstilbud-2027.md).
- Kvotetypene i regelverket. De står i `@OPT-REG-KVO-001`, i scope-regelverk-2027.

## Kilder

- [GitHub #211](https://github.com/sikt-no/fs/issues/211) — initiativet «Opprette og vedlikeholde opptak». Oppgaven bruker samme issue.
- [GitHub #216](https://github.com/sikt-no/fs/issues/216) — initiativet for plasstildeling, der kravene sto før 2026-10-15.
- [GitHub #598](https://github.com/sikt-no/fs/issues/598) — sirkularitetsvern for plassflyt mellom utdanningskvoter.
- [Figma: Kvoter, gjeldende skisse](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637) (node 5299:11637, prototyp v1.13) — seksjonen «Kvoter» i opprett opptak, med fanene «Kvoteplassflyt» og «Kvoteprioritet». Gjelder foran de eldre skissene under. Unntak: «Ikke koblet» er ikke et gyldig valg, og teksten om at ledige plasser i disse kvotene ikke flyttes, er feil (avklart 2026-10-19). Alle kvotene i opptaket må være koblet inn i flyten.
- [Figma: Kvoteplassflyt](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22410-106608) (node 22410:106608) — skissen «Kvoter», fanen «Kvoteplassflyt».
- [Figma: Kvoteprioritet](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465) (node 22399:113465) — skissen «Kvoter», fanen «Kvoteprioritet».
- [Mockup v12: Kvoteplassflyt og kvoteprioritet](https://fs.sikt.no/design-sketches/plassflyt-v1.12.html#kvoteprioritet) — grensen 0–25 og loddtrekningen der gjelder ikke (avklart 2026-10-15).

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [kvoter-i-opptaket](kvoter-i-opptaket/) | `@OPT-OVO-INN-002` [sette_plassflyt.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/sette_plassflyt.feature) | Must | [Kvoter](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637) | [#211](https://github.com/sikt-no/fs/issues/211) | Standard plassflyt på opptaket, med vern mot sirkulær plassflyt (#598). Flyttet fra scope-plasstildeling-2027 2026-10-15 |
| [kvoter-i-opptaket](kvoter-i-opptaket/) | `@OPT-OVO-INN-003` [sette_kvoteprioritet.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/sette_kvoteprioritet.feature) | Must | [Kvoteprioritet](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465) | [#211](https://github.com/sikt-no/fs/issues/211) | Kvoteprioriteten på opptaket, som en rangering av kvotetypene. Flyttet fra scope-plasstildeling-2027 2026-10-15 |

## Uløst arbeid

Virkningen av innstillingene står i kravene der de brukes, og er ikke en del av dette scopet:

| Innstilling | Krav der virkningen står | Regel eller scenario |
|---|---|---|
| Standard plassflyt og hovedkvote | `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) | Hele kravet |
| Kvoteprioritet | `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) | Regel «Søkeren prøves i utdanningskvotene etter kvoteprioritet», med «Lavest tall gir høyest prioritet» (flyttet hit 2026-10-19) |
| Plassflyt og kvoteprioritet på utdanningstilbudet | `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Regel «Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine» |

## Åpne spørsmål

- [ ] Jira-sak for oppgaven mangler.
- [ ] Skal regelen om at lærestedene ser plassflyten og kvoteprioriteten (`@OPT-OPT-UTD-004`) leveres sammen med dette scopet?
