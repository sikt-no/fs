# Scope: Utdanningstilbud i samordna opptak 2027

- **Slug**: utdanningstilbud-i-opptak-2027
- **Initiativ**: [#398](https://github.com/sikt-no/fs/issues/398)
- **Eier**: –
- **Siste oppdatering**: 2026-10-12

## Mål

- Opptak henter utdanningsinstansene som skal være med i samordna opptak 2027 fra utdanningsregisteret, og fanger opp navneendringer, deaktivering og reaktivering.
- Opptaksforvalter ser utdanningstilbudene i opptaket i en liste, og kan legge til og fjerne utdanningstilbud.

## Ikke-mål

- Å registrere utdanninger i FS-SIS og utdanningsregisteret, og veiledningen for det (#588–#590).
- Å behandle ett utdanningstilbud, og å trekke utdanningstilbud fra opptaket. Det står i [scope-utdanningstilbud-2027](scope-utdanningstilbud-2027.md).

## Kilder

- [GitHub #398](https://github.com/sikt-no/fs/issues/398) — initiativet «Lage og vedlikeholde utdanningstilbud», med under-sakene #591–#594.
- [Jira SHI-710](https://sikt.atlassian.net/browse/SHI-710) — fjerne utdanningstilbud fra opptak.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [hente-fra-utdanningsregisteret](hente-fra-utdanningsregisteret/) | `@OPT-OPT-UTD-005` [hente_utdanninger_fra_utdanningsregisteret.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/01%20Hente%20fra%20utdanningsregisteret/hente_utdanninger_fra_utdanningsregisteret.feature) | Must | – | [#593](https://github.com/sikt-no/fs/issues/593) | |
| [hente-fra-utdanningsregisteret](hente-fra-utdanningsregisteret/) | `@OPT-OPT-UTD-006` [fange_opp_endringer_fra_utdanningsregisteret.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/01%20Hente%20fra%20utdanningsregisteret/fange_opp_endringer_fra_utdanningsregisteret.feature) | Must | – | [#591](https://github.com/sikt-no/fs/issues/591), [#592](https://github.com/sikt-no/fs/issues/592) | Should i workshopen |
| [utdanningstilbud-i-opptak](utdanningstilbud-i-opptak/) | `@OPT-OPT-UTD-001` [listevisning_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) | Must | – | [#398](https://github.com/sikt-no/fs/issues/398) | |
| [utdanningstilbud-i-opptak](utdanningstilbud-i-opptak/) | `@OPT-OPT-UTD-002` [legge_til_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/legge_til_utdanningstilbud.feature) | Must | – | [#594](https://github.com/sikt-no/fs/issues/594) | |
| [utdanningstilbud-i-opptak](utdanningstilbud-i-opptak/) | `@OPT-OPT-UTD-026` [fjerne_utdanningstilbud.feature](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/fjerne_utdanningstilbud.feature) | Must | – | – | Jira SHI-710 |

## Åpne spørsmål

- [ ] Finnes det skisser for listevisningen, og for å legge til og fjerne utdanningstilbud? Brødsmulestien i skissen for detaljsiden ([node 18797:108875](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18797-108875)) viser en side «Rediger studiealternativer».
- [ ] Skal oppgavene ha hver sin GitHub-issue? hente-fra-utdanningsregisteret dekker #591, #592 og #593, og fjerne utdanningstilbud (026) har bare Jira SHI-710.
