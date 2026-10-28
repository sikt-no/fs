# Scope: Lage og vedlikeholde utdanningstilbud i samordna opptak 2027

- **Slug**: utdanningstilbud-2027
- **Initiativ**: [#398](https://github.com/sikt-no/fs/issues/398)
- **Eier**: –
- **Siste oppdatering**: 2026-10-28

## Mål

- Opptaksforvalter kan behandle ett utdanningstilbud på detaljsiden (se skissen under *Kilder*): opplysninger fra utdanningsregisteret, regelverk og kvoter, attester, poengopplysninger, beskrivelse, alternativt visningsnavn og søkeord til Min kompetanse, endringslogg og tidligere utdanningstilbud.
- Opptaksforvalter kan sette opptaksinnstillingene per utdanningstilbud, og trekke utdanningstilbudet fra opptaket.

## Ikke-mål

- Del 1 i [utdanningstilbud](utdanningstilbud/oppgave.md): å registrere utdanninger i FS-SIS og utdanningsregisteret, og veiledningen for det (#588–#590). Det har ingen krav i `12 Utdanningstilbud`.
- Plasstildeling: antall tilbud som skal gis per plasstildelingsrunde, hva plasstildelingen gjør med plassflyten, og vernet mot sirkulær plassflyt (#598). Det står i `14 Plasstildeling`, og hører til initiativet #216.
- Å hente utdanninger fra utdanningsregisteret, og listen, å legge til og å fjerne utdanningstilbud (001, 002, 005, 006, 026). Det står i [scope-utdanningstilbud-i-opptak-2027](scope-utdanningstilbud-i-opptak-2027.md).
- Å sette innstillinger for flere utdanningstilbud av gangen (008). Det står i [scope-innstillinger-for-flere-utdanningstilbud](scope-innstillinger-for-flere-utdanningstilbud.md).
- Å flytte registreringen av kvoteflyt fra utdanningstilbudet til opptaksinnstillingene (`@OPT-OPT-UTD-013`, [flytte_kvoteflyt_til_opptaksinnstillinger.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/flytte_kvoteflyt_til_opptaksinnstillinger.feature), Jira SHI-691).

## Kilder

- [GitHub #398](https://github.com/sikt-no/fs/issues/398) — initiativet «Lage og vedlikeholde utdanningstilbud», med under-sakene #591–#599.
- [Jira SHI-686](https://sikt.atlassian.net/browse/SHI-686) — sakene for å behandle et utdanningstilbud (SHI-687 til SHI-710).
- [Figma: Sidelayout i FS Admin - Pattern (node 18797:108875)](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) — detaljsiden for ett utdanningstilbud («Fysikk og astronomi»).
- [utdanningstilbud/oppgave.md](utdanningstilbud/oppgave.md) — oppgavedelingen fra workshopen 2026-09-14.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-003` [trekke_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/trekke_utdanningstilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#595](https://github.com/sikt-no/fs/issues/595) | Jira SHI-709. «Trekk studiet fra opptaket» |
| [opptaksinnstillinger](opptaksinnstillinger/) | `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#597](https://github.com/sikt-no/fs/issues/597) | «Regelverk og kvoter», «Tidlig opptak», «Saksbehandlertildelingsregel» (overtatt fra 028) |
| [opptaksinnstillinger](opptaksinnstillinger/) | `@OPT-OPT-UTD-007` [sette_studieplasser_og_antall_tilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | [#596](https://github.com/sikt-no/fs/issues/596) | Se åpent spørsmål om antall studieplasser |
| [opptaksinnstillinger](opptaksinnstillinger/) | `@OPT-OPT-UTD-032` [sette_antall_studieplasser_per_kvote.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skrevet fra koden («Ant. kvoteplasser» i fs-admin) |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-009` [vise_beskrivelses_url.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_beskrivelses_url.feature) | Must | – | – | Jira SHI-687. Usikkert om det finnes skisse |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-010` [registrere_poengopplysninger.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_poengopplysninger.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-688 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-011` [registrere_studietypenummer.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_studietypenummer.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-689 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-012` [registrere_planlagte_studieplasser.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_planlagte_studieplasser.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-690 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-014` [registrere_påkrevde_attester.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_p%C3%A5krevde_attester.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-692 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-015` [overstyre_regler_for_poenglikhet.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/overstyre_regler_for_poenglikhet.feature) | Must | – | – | Jira SHI-693. Usikkert om det finnes skisse. Kanskje levert |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-016` [angi_beskrivelse_til_min_kompetanse.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_beskrivelse_til_min_kompetanse.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-694 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-017` [angi_søkeord.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_s%C3%B8keord.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-695. «Tags» i skissen |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-019` [vise_endringslogg.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_endringslogg.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-698 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-021` [vise_lenke_til_tidligere_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_lenke_til_tidligere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-700 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-022` [angi_studieavgift.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_studieavgift.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-701 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-025` [sette_tidlig_søknadsfrist.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_tidlig_s%C3%B8knadsfrist.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Jira SHI-708 |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-027` [sette_kjønnspoeng.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_kj%C3%B8nnspoeng.feature) | Must | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-029` [vise_poenggrense_og_ventelistenummer_for_søker.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_poenggrense_og_ventelistenummer_for_s%C3%B8ker.feature) | Should | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-030` [eksportere_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/eksportere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-031` [sammenligne_med_tidligere_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sammenligne_med_tidligere_utdanningstilbud.feature) | Could | [Detaljside](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875) | – | Skjelett fra skissen |
| [behandle-utdanningstilbud](behandle-utdanningstilbud/) | `@OPT-OPT-UTD-033` [angi_alternativt_visningsnavn.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_alternativt_visningsnavn.feature) | Must | – | – | Usikkert om det finnes skisse |

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
