# Scope: Kvoter i opptaket 2027

- **Slug**: kvoter-i-opptaket-2027
- **Initiativ**: [#211](https://github.com/sikt-no/fs/issues/211)
- **Eier**: –
- **Siste oppdatering**: 2026-10-28

## Mål

- Regelverksforvalter ved organisasjonen som eier regelverkssamlingen kan sette standard plassflyt i regelverkssamlingen: hvilken kvote ledige plasser går videre til, med nøyaktig én hovedkvote og uten sirkulær plassflyt.
- Regelverksforvalter ved organisasjonen som eier regelverkssamlingen kan sette kvoteprioriteten i regelverkssamlingen: en rangering av alle kvotetypene i regelverkssamlingen, fra 1 til antall kvotetyper.
- Plassflyten og kvoteprioriteten er en del av regelverket, og settes i regelverkssamlingen, ikke på opptaket (avklart 2026-10-21). Kravene ligger i `10 Regelverk/04 Kvoter`.
- Kravene beskriver at plassflyten og kvoteprioriteten settes og finnes i regelverkssamlingen (avklart 2026-10-19, samme prinsipp som de andre innstillingene i [scope-opprette-opptak-2027](scope-opprette-opptak-2027.md)). Det er det som skal lages og testes nå.
- Leveres før plasstildelingen ([scope-plasstildeling-2027](scope-plasstildeling-2027.md)), som bruker innstillingene.

## Ikke-mål

- Hva plasstildelingen gjør med plassflyten og kvoteprioriteten. **Virkningen er ikke løst, og skal løses senere.** Det står i `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) og `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature), i scope-plasstildeling-2027.
- At lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine. Regelen står i `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature), i [scope-utdanningstilbud-2027](scope-utdanningstilbud-2027.md).
- Kvotetypene i regelverket. De står i `@OPT-REG-KVO-001`, i scope-regelverk-2027.

## Kilder

- [GitHub #211](https://github.com/sikt-no/fs/issues/211) — initiativet «Opprette og vedlikeholde opptak». Oppgaven bruker samme issue.
- [GitHub #216](https://github.com/sikt-no/fs/issues/216) — initiativet for plasstildeling, der kravene sto før 2026-10-15.
- [GitHub #598](https://github.com/sikt-no/fs/issues/598) — sirkularitetsvern for plassflyt mellom utdanningskvoter.
- [Review-miljøet i fs-admin: Kvoteinnstillinger](https://studieadm-fs-admin-review-poc-patter-z2lvpk.sokrates.edupaas.no/regelverk/regelverksamlinger/cmVnZWx2ZXJrc2FtbGluZzpGU1UsMTk0/kvoteinnstillinger) — gjeldende design (avklart 2026-10-26). Utkastet på branchen `poc-pattern-skills` i fs-admin (`src/domains/regelverk/features/Kvoteinnstillinger/`), med plassflyten og kvoteprioriteten i regelverkssamlingen. Krever Feide-innlogging, og forsvinner når review-branchen slettes. Avvikene fra kravene står i [spesifikasjonen](kvoter-i-opptaket/spec/spec-kvoter-i-opptaket.md) (kravene gjelder, utkastet justeres).
- [Figma: Kvoter, eldre skisse](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637) (node 5299:11637, prototyp v1.13) — seksjonen «Kvoter» i opprett opptak, med fanene «Kvoteplassflyt» og «Kvoteprioritet». Erstattet av review-miljøet over, men gjelder foran de eldre skissene under. Unntak: teksten om at ledige plasser i kvotene som ikke er koblet, ikke flyttes, er feil (avklart 2026-10-19). Plassflyten og kvoteprioriteten kan lagres med kvotetyper som mangler dem, men kvotetypen får et varsel, og kan ikke brukes av utdanningstilbud eller i plasstildelingen før den har begge (avklart 2026-10-21). Skissen viser kvotene i opprett opptak, men de skal flyttes til regelverkssamlingen (avklart 2026-10-21), så skissen må oppdateres.
- [Figma: Kvoteplassflyt](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22410-106608) (node 22410:106608) — skissen «Kvoter», fanen «Kvoteplassflyt».
- [Figma: Kvoteprioritet](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465) (node 22399:113465) — skissen «Kvoter», fanen «Kvoteprioritet».
- [Mockup v12: Kvoteplassflyt og kvoteprioritet](https://fs.sikt.no/design-sketches/plassflyt-v1.12.html#kvoteprioritet) — grensen 0–25 og loddtrekningen der gjelder ikke (avklart 2026-10-15).

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [kvoter-i-opptaket](kvoter-i-opptaket/) | `@OPT-REG-KVO-003` [sette_plassflyt.feature](../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_plassflyt.feature) | Must | [Kvoteinnstillinger (review-miljøet)](https://studieadm-fs-admin-review-poc-patter-z2lvpk.sokrates.edupaas.no/regelverk/regelverksamlinger/cmVnZWx2ZXJrc2FtbGluZzpGU1UsMTk0/kvoteinnstillinger) | [#211](https://github.com/sikt-no/fs/issues/211) | Standard plassflyt på opptaket, med vern mot sirkulær plassflyt (#598). Flyttet fra scope-plasstildeling-2027 2026-10-15 |
| [kvoter-i-opptaket](kvoter-i-opptaket/) | `@OPT-REG-KVO-004` [sette_kvoteprioritet.feature](../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_kvoteprioritet.feature) | Must | [Kvoteinnstillinger (review-miljøet)](https://studieadm-fs-admin-review-poc-patter-z2lvpk.sokrates.edupaas.no/regelverk/regelverksamlinger/cmVnZWx2ZXJrc2FtbGluZzpGU1UsMTk0/kvoteinnstillinger) | [#211](https://github.com/sikt-no/fs/issues/211) | Kvoteprioriteten på opptaket, som en rangering av kvotetypene. Flyttet fra scope-plasstildeling-2027 2026-10-15 |

## Uløst arbeid

Virkningen av innstillingene står i kravene der de brukes, og er ikke en del av dette scopet:

| Innstilling | Krav der virkningen står | Regel eller scenario |
|---|---|---|
| Standard plassflyt og hovedkvote | `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) | Hele kravet |
| Kvoteprioritet | `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) | Regel «Søkeren prøves i utdanningskvotene etter kvoteprioritet», med «Lavest tall gir høyest prioritet» (flyttet hit 2026-10-19) |
| Plassflyt og kvoteprioritet på utdanningstilbudet | `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Regel «Utdanningskvotene følger kvoteprioriteten og plassflyten i regelverkssamlingen» (ny 2026-10-21), «Lærestedet velger utdanningskvotene blant kvotetypene i regelverkssamlingen» (endret 2026-10-21) og «Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine» |

## Åpne spørsmål

- [x] Skisse for plassflyt og kvoteprioritet i regelverkssamlingen mangler. Besvart 2026-10-28: utkastet i review-miljøet i fs-admin er gjeldende design (se *Kilder*).
- [ ] Jira-sak for oppgaven mangler.
- [ ] Skal regelen om at lærestedene ser plassflyten og kvoteprioriteten (`@OPT-OPT-UTD-004`) leveres sammen med dette scopet?
