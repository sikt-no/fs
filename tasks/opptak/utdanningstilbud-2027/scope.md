# Scope: Lage og vedlikeholde utdanningstilbud i samordna opptak 2027

- **Slug**: utdanningstilbud-2027 (= navnet på mappa og taggen `@scope-utdanningstilbud-2027`)
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#398](https://github.com/sikt-no/fs/issues/398)
- **Jira**: [sikt-no/fs#597](https://github.com/sikt-no/fs/issues/597), [sikt-no/fs#398](https://github.com/sikt-no/fs/issues/398)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Opptaksforvalter kan behandle ett utdanningstilbud på detaljsiden (se skissen under *Kilder*): opplysninger fra utdanningsregisteret, regelverk og kvoter, attester, poengopplysninger, beskrivelse, alternativt visningsnavn og søkeord til Min kompetanse, endringslogg og tidligere utdanningstilbud.
- Opptaksforvalter kan sette opptaksinnstillingene per utdanningstilbud, og trekke utdanningstilbudet fra opptaket.

## Ikke-mål

- Del 1 i [utdanningstilbud](scope.md): å registrere utdanninger i FS-SIS og utdanningsregisteret, og veiledningen for det (#588–#590). Det har ingen krav i `12 Utdanningstilbud`.
- Plasstildeling: antall tilbud som skal gis per plasstildelingsrunde, hva plasstildelingen gjør med plassflyten, og vernet mot sirkulær plassflyt (#598). Det står i `14 Plasstildeling`, og hører til initiativet #216.
- Å hente utdanninger fra utdanningsregisteret, og listen, å legge til og å fjerne utdanningstilbud (001, 002, 005, 006, 026). Det står i [scope-utdanningstilbud-i-opptak-2027](../utdanningstilbud-i-opptak-2027/scope.md).
- Å sette innstillinger for flere utdanningstilbud av gangen (008). Det står i [scope-innstillinger-for-flere-utdanningstilbud](../innstillinger-for-flere-utdanningstilbud/scope.md).
- Å flytte registreringen av kvoteflyt fra utdanningstilbudet til opptaksinnstillingene (`@OPT-OPT-UTD-013`, [flytte_kvoteflyt_til_opptaksinnstillinger.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/flytte_kvoteflyt_til_opptaksinnstillinger.feature), Jira SHI-691).

## Kilder

- [GitHub #398](https://github.com/sikt-no/fs/issues/398) — initiativet «Lage og vedlikeholde utdanningstilbud», med under-sakene #591–#599.
- [Jira SHI-686](https://sikt.atlassian.net/browse/SHI-686) — sakene for å behandle et utdanningstilbud (SHI-687 til SHI-710).
- [Figma: Sidelayout i FS Admin - Pattern (node 18797:108875)](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) — detaljsiden for ett utdanningstilbud («Fysikk og astronomi»).
- [scope.md](scope.md) — oppgavedelingen fra workshopen 2026-09-14.

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-OPT-UTD-003` [trekke_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/trekke_utdanningstilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#595](https://github.com/sikt-no/fs/issues/595) | Jira SHI-709. «Trekk studiet fra opptaket» |
| `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#597](https://github.com/sikt-no/fs/issues/597) | «Regelverk og kvoter», «Tidlig opptak», «Behandlertildelingsregel» (overtatt fra 028) |
| `@OPT-OPT-UTD-007` [sette_studieplasser_og_antall_tilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#596](https://github.com/sikt-no/fs/issues/596) | Se åpent spørsmål om antall studieplasser |
| `@OPT-OPT-UTD-032` [sette_antall_studieplasser_per_kvote.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skrevet fra koden («Ant. kvoteplasser» i fs-admin) |
| `@OPT-OPT-UTD-009` [vise_beskrivelses_url.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_beskrivelses_url.feature) | Must | – | – | Jira SHI-687. Usikkert om det finnes skisse |
| `@OPT-OPT-UTD-010` [registrere_poengopplysninger.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_poengopplysninger.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-688 |
| `@OPT-OPT-UTD-011` [registrere_studietypenummer.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_studietypenummer.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-689 |
| `@OPT-OPT-UTD-012` [registrere_planlagte_studieplasser.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_planlagte_studieplasser.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-690 |
| `@OPT-OPT-UTD-014` [registrere_påkrevde_attester.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_p%C3%A5krevde_attester.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-692 |
| `@OPT-OPT-UTD-015` [overstyre_regler_for_poenglikhet.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/overstyre_regler_for_poenglikhet.feature) | Must | – | – | Jira SHI-693. Usikkert om det finnes skisse. Kanskje levert |
| `@OPT-OPT-UTD-016` [angi_beskrivelse_til_min_kompetanse.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_beskrivelse_til_min_kompetanse.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-694 |
| `@OPT-OPT-UTD-017` [angi_søkeord.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_s%C3%B8keord.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-695. «Tags» i skissen |
| `@OPT-OPT-UTD-019` [vise_endringslogg.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_endringslogg.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-698 |
| `@OPT-OPT-UTD-021` [vise_lenke_til_tidligere_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_lenke_til_tidligere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-700 |
| `@OPT-OPT-UTD-022` [angi_studieavgift.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_studieavgift.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-701 |
| `@OPT-OPT-UTD-025` [sette_tidlig_søknadsfrist.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_tidlig_s%C3%B8knadsfrist.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-708 |
| `@OPT-OPT-UTD-027` [sette_kjønnspoeng.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_kj%C3%B8nnspoeng.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| `@OPT-OPT-UTD-029` [vise_poenggrense_og_ventelistenummer_for_søker.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_poenggrense_og_ventelistenummer_for_s%C3%B8ker.feature) | Should | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| `@OPT-OPT-UTD-030` [eksportere_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/eksportere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| `@OPT-OPT-UTD-031` [sammenligne_med_tidligere_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sammenligne_med_tidligere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| `@OPT-OPT-UTD-033` [angi_alternativt_visningsnavn.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_alternativt_visningsnavn.feature) | Must | – | – | Jira SHI-780. Usikkert om det finnes skisse |

## Åpne spørsmål

- [ ] Skissen viser antall studieplasser, studienummer og studiestart som opplysninger fra utdanningsregisteret, uten mulighet for å endre dem. Kravene 007, 011 og 012 sier at opptaksforvalter registrerer eller korrigerer dem. Hva gjelder? (023, studiestart, er slettet i #791: studiestart rettes i utdanningsregisteret.)
- [ ] Er «antall studieplasser» (007) og «planlagt antall studieplasser» (012) det samme tallet?
- [ ] Skissen har beskrivelse til Min kompetanse på bokmål, nynorsk og engelsk. Skal samisk være med (016)?
- [ ] Skissen lar opptaksforvalter legge til og slette utdanningskvoter for hånd («Søk og legg til kvoter»). Kravet 004 sier at utdanningskvotene følger av regelverkssamlingen. Hva gjelder?
- [ ] Skissen har en bryter for «Tilbudsgarantier tas fra» per utdanningskvote. Det finnes ikke krav for den. Hører den til 004, eller til 14 Plasstildeling?
- [ ] Skissen bruker «studiealternativ» og «studiet» («Rediger studiealternativer», «Trekk studiet fra opptaket»). Kravene bruker «utdanningstilbud».
- [ ] Finnes det skisse for URL til beskrivelse av utdanningstilbudet (009)? Den er ikke i rammen.
- [ ] Finnes det skisse for alternativt visningsnavn (033)? Det er ikke i rammen.
- [ ] Finnes det skisse for å overstyre regler for poenglikhet (015)? Den er ikke i rammen.
- [ ] Det ryktes at overstyring av regler for poenglikhet (015) er levert. Stemmer det? I så fall kan kravet verifiseres med `fs-verify`.
- [ ] Skal oppgavene ha hver sin GitHub-issue? opptaksinnstillinger dekker #596 og #597, og behandle-utdanningstilbud har bare Jira SHI-686 og #595 (003).

## Behandle et utdanningstilbud (fra oppgaven behandle-utdanningstilbud)


Detaljsiden for ett utdanningstilbud i FS Admin: opplysninger fra utdanningsregisteret, opplysningene opptaksforvalter registrerer (attester, poengopplysninger, beskrivelse og søkeord til Min kompetanse, kjønnspoeng, behandlertildelingsregel og mer), endringslogg og tidligere utdanningstilbud, og å trekke utdanningstilbudet fra opptaket (#595). Jira: [SHI-686](https://sikt.atlassian.net/browse/SHI-686).

### Åpne punkter

- [ ] Oppgaven har ingen GitHub-issue. Kravene kommer fra Jira-sakene under SHI-686.

## Opptaksinnstillinger for utdanningstilbud (fra oppgaven opptaksinnstillinger)

Jira: [sikt-no/fs#597](https://github.com/sikt-no/fs/issues/597)


Opptaksforvalter setter opptaksinnstillinger per utdanningstilbud (regelverk, utdanningskvoter, plassflyt, tidlig tilbud), og antall studieplasser (#596).

## Utdanningstilbud i opptak (fra oppgaven utdanningstilbud)

Jira: [sikt-no/fs#398](https://github.com/sikt-no/fs/issues/398)


Sørge for at utdanninger som skal med i samordna opptak 2027 finnes i utdanningsregisteret, at endringer flyter til opptak, og at opptaksforvalter kan opprette og konfigurere utdanningstilbud med alle nødvendige innstillinger.

### Oppgaver

#### Del 1: Utdanninger inn i utdanningsregisteret

Overordnet: utdanningsregisteret får utdanninger som skal med i de samordna opptakene fra universiteter, høyskoler og fagskoler (studieprogram og studieprogramkull med campus).

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 1 | UH-ansatte kan registrere studieprogram, studieretninger og studieprogramkull i FS-SIS og få dem overført til utdanningsregisteret | Must | Løst — overføring via batchjobber fungerer (fulloverføring hvert 30. min) | | |
| 2 | Fagskoleansatte kan registrere studieprogram og studieprogramkull direkte i utdanningsregisteret | Must | Snart i produksjon | [#588](https://github.com/sikt-no/fs/issues/588) | [SHI-631](https://sikt.atlassian.net/browse/SHI-631) |
| 3 | UH-læresteder har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 (inkl. studieretninger som skal ha opptak) | Must | | [#589](https://github.com/sikt-no/fs/issues/589) | [SHI-632](https://sikt.atlassian.net/browse/SHI-632) |
| 4 | Fagskoler har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 | Must | | [#590](https://github.com/sikt-no/fs/issues/590) | [SHI-633](https://sikt.atlassian.net/browse/SHI-633) |

#### Del 2: Endringer flyter fra SIS → ureg → opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 5 | Fange opp navneendringer på utdanninger fra ureg til opptak | Should | SIS → ureg fungerer via fulloverføring. ureg → opptak under innføring | [#591](https://github.com/sikt-no/fs/issues/591) | [SHI-634](https://sikt.atlassian.net/browse/SHI-634) |
| 6 | Fange opp deaktivering og reaktivering av utdanninger fra ureg til opptak | Should | SIS → ureg fungerer via fulloverføring. ureg → opptak gjenstår | [#592](https://github.com/sikt-no/fs/issues/592) | [SHI-635](https://sikt.atlassian.net/browse/SHI-635) |

#### Del 3: Utdanningstilbud i opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 7 | Opptak får tak i relevante utdanninger og instanser fra utdanningsregisteret | Must | | [#593](https://github.com/sikt-no/fs/issues/593) | [SHI-636](https://sikt.atlassian.net/browse/SHI-636) |
| 8 | Opptaksforvalter kan legge til utdanningstilbud i opptaket (inkl. legge til flere av gangen) | Must | | [#594](https://github.com/sikt-no/fs/issues/594) | [SHI-637](https://sikt.atlassian.net/browse/SHI-637) |
| 9 | Opptaksforvalter kan trekke utdanningstilbud fra opptak (trekkfrist settes av opptakseier) | Must | | [#595](https://github.com/sikt-no/fs/issues/595) | [SHI-638](https://sikt.atlassian.net/browse/SHI-638) |
| 10 | Sette antall studieplasser og antall tilbud som skal gis per utdanningstilbud | Must | | [#596](https://github.com/sikt-no/fs/issues/596) | [SHI-639](https://sikt.atlassian.net/browse/SHI-639) |
| 11 | Koble regelverk per utdanningstilbud | Must | Løst | | |
| 12 | Konfigurere utdanningskvoter med relativ fordeling per utdanningstilbud | Must | Delvis — absolutte kvoter finnes, relativ fordeling gjenstår | [#597](https://github.com/sikt-no/fs/issues/597) | [SHI-640](https://sikt.atlassian.net/browse/SHI-640) |
| 13 | Sette plassflyt mellom utdanningskvoter | Must | Delvis — fungerer, men mangler sirkularitetsvern (ORDF→ORD→ORDF…) | [#598](https://github.com/sikt-no/fs/issues/598) | [SHI-641](https://sikt.atlassian.net/browse/SHI-641) |
| 14 | Sette default-innstillinger for flere utdanningstilbud | Should | | [#599](https://github.com/sikt-no/fs/issues/599) | [SHI-642](https://sikt.atlassian.net/browse/SHI-642) |
| 15 | Hvilke utdanningstilbud mangler regelverk | Must | Løst | | |

### Workshop 2026-09-14: oppgavedeling og status

**Team:** Shinkansen | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 15. nov)

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Oppgave og scope slått sammen til scope.md (fra behandle-utdanningstilbud, opptaksinnstillinger, utdanningstilbud) | – | – |
| 2026-10-12 | [behandle-utdanningstilbud] Opprettet i scope-utdanningstilbud-2027 | – | – |
| 2026-10-12 | [opptaksinnstillinger] Opprettet i scope-utdanningstilbud-2027 | – | – |
| 2026-10-12 | [utdanningstilbud] Del 2 og 3 delt i oppgaver i [scope-utdanningstilbud-2027](scope.md) | – | – |
| 2026-09-15 | [utdanningstilbud] Workshop: oppgavedeling avklart | @karensikt | – |
| 2026-09-11 | [utdanningstilbud] Tatt inn i veikart (design) | @karensikt | – |
