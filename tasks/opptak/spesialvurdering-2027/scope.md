# Scope: Spesialvurdering i opptak

- **Slug**: spesialvurdering-2027
- **Domene**: opptak
- **Initiativ**: –
- **Jira**: [TAKE-493](https://sikt.atlassian.net/browse/TAKE-493), [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492)
- **Eier**: –
- **Siste oppdatering**: 2026-11-13

## Mål

- Kvalifiserte søkere som ikke kan få vanlige rangeringspoeng, kan skjønnsvurderes i en egen kvote, og få eller ikke få tilbudsgaranti (TAKE-493).
- Opptaksforvalter (avklart 2026-11-06) kan opprette en ventekvote for søkere uten poeng (tidligere kalt SPEV-kvote). Kvotetypen kan settes til å ikke ha plasser, til å være standardkvote, som legges på utdanningstilbudet når det legges til i opptaket (avklart 2026-11-06), og til å være stengt for fjerning fra utdanningstilbudene (TAKE-492). Innstillingen gjelder alle, også organisasjonen som eier opptaket (avklart 2026-11-06).
- Saksbehandler kan sette interne poeng (stipulering) på søkere i ventekvoten, og søkeren ser ikke poengene.
- Opptaksforvalter ser, før plasstildelingen, søkere i ventekvoten uten tilbudsgaranti og kvalifiserte søkere uten kvote.
- Ventekvoten er en kvotetype uten plasser, og et venterom for søkere som søker på grunnlag av realkompetanse og søkere helt uten poeng. Kravene gir ikke kvotetypen eller grunnlagene konkrete navn eller koder, men legger til rette for at funksjonen SPEV-kvoten har hatt, også finnes i det nye opptaket (avklart 2026-11-06).
- Ventekvoten har ingen egen rangeringsmetode. Poengene skjules per grunnlag, og de interne poengene (intern stipulering) settes opp i rangeringsregelverket med egne poengklasser og poengtyper. De brukes bare internt i saksbehandlingen, for å avgjøre om søkeren når opp i konkurransen (avklart 2026-11-06).
- Scopet gjelder fram til tilbudsgarantien er gitt. Tilbudsgarantien gis av saksbehandler før plasstildelingen.

## Ikke-mål

- Virkningen av tilbudsgarantien i plasstildelingen (at søkere i ventekvoten får tilbud, og at tilbudene tas fra hovedkvoten). Det står i `gjennomføre_plasstildeling.feature` i scopet plasstildeling-2027.
- Søkerens ønske om spesiell vurdering per søknadsalternativ. Søkeren havner i ventekvoten ut fra grunnlaget.
- Interne poeng over 999,99.
- Avslag på spesielt grunnlag med begrunnelse til søkeren.

## Kilder

- [Hvordan er spesialvurdering løst i dag?](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5167611916/Hvordan+er+spesialvurdering+l+st+i+dag) — analyse av spesialvurdering i gamle FS, samordna-opptak og nytt opptak, med hva som mangler.
- [Brukerveiledning: Sette opp kvotetypen SPEV (Spesialvurdering) i regelverket](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5176393729/Brukerveiledning+Sette+opp+kvotetypen+SPEV+Spesialvurdering+i+regelverket) — utkast til oppsett med intern stipulering, med kjente begrensninger. Brukerveiledningen skal lages i fs-admin ut fra `opprette_ventekvote.feature`.
- [TAKE-493](https://sikt.atlassian.net/browse/TAKE-493) — epicen «Spesialvurdering i opptak».
- [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492) — «sette innstillinger på kvotetype»: standard kvote, har ikke plasser, kan ikke slettes.

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-REG-KVO-001` — Regel: En kvotetype kan være uten plasser | Must | – | [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492) | Ny regel i [kvoterregelverk.feature](../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/kvoterregelverk.feature) (levert, regelverk-2027). Finnes i koden på fs-plattform-branchen `feature/take-492-kvotetype-innstillinger` |
| `@OPT-REG-KVO-001` — Regel: En kvotetype kan være standardkvote for utdanningstilbudene | Must | – | [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492) | Standardkvoten legges på utdanningstilbudet når det legges til i opptaket, ikke på utdanningstilbud som allerede er i opptaket, og blir stående når innstillingen slås av (avklart 2026-11-06). Stemmer med koden på TAKE-492-branchen |
| `@OPT-REG-KVO-001` — Regel: En standardkvote kan stenges for fjerning fra utdanningstilbudet | Must | – | [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492) | Avvik fra koden på TAKE-492-branchen: koden lar organisasjonen som eier opptaket, alltid fjerne kvoten (`kan_fjernes_av_deltaker` gjelder bare deltakende organisasjoner). Kravet sier at innstillingen gjelder alle, og ikke kan overstyres (avklart 2026-11-06) |
| `@OPT-REG-KVO-005` [opprette_ventekvote.feature](../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/opprette_ventekvote.feature) | Must | – | [TAKE-492](https://sikt.atlassian.net/browse/TAKE-492) | Hele oppsettet av ventekvoten, som grunnlag for brukerveiledningen i fs-admin |
| `@OPT-BEH-BEH-040` [sette_interne_poeng.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/sette_interne_poeng.feature) | Must | – | [TAKE-493](https://sikt.atlassian.net/browse/TAKE-493) | Intern stipulering, høyst 999,99 |
| `@OPT-BEH-BEH-041` [kontrollere_ventekvoten.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/kontrollere_ventekvoten.feature) | Must | – | [TAKE-493](https://sikt.atlassian.net/browse/TAKE-493) | Tilsvarer «Diagnose NOM» i gamle FS |

### Avhengigheter i andre scopes

Disse kravene må endres for at scopet kan leveres, men blir i scopet de hører til:

- `@OPT-OPT-UTD-004` [opptaksinnstillinger_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) (utdanningstilbud-2027): standardkvoten legges på utdanningstilbudet når det legges til i opptaket, og en kvote som er stengt for fjerning, kan ikke fjernes, heller ikke av organisasjonen som eier opptaket. Endrer avklaringen 2026-10-21 om at utdanningstilbudet ikke får kvotetypene automatisk.
- `@OPT-OPT-UTD-032` [sette_antall_studieplasser_per_kvote.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature) (utdanningstilbud-2027): en kvote uten plasser får ingen studieplasser, og telles ikke med i summen.
- `@OPT-REG-KVO-003` [sette_plassflyt.feature](../../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/sette_plassflyt.feature) (kvoter-i-opptaket-2027, `@in-progress`) og [gjennomføre_plasstildeling.feature](../../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) (plasstildeling-2027): «SPEV-kvote» skrives om til ventekvote (kvotetype uten plasser).

Referanser, uten endring: `@OPT-BEH-BEH-012` automatisk_kvoteplassering.feature (søkeren havner i ventekvoten ut fra grunnlaget), `@OPT-BEH-BEH-010` gi_tilbudsgaranti.feature (saksbehandler gir garantien), `@OPT-REG-GRU-001` grunnlag.feature (flagget for skjulte poeng), `@OPT-REG-RAN-001` rangeringsregelverk.feature (grunnlag kobles til poengtyper) og `@OPT-REG-RAN-002` poengberegning.feature (poengklasser, poengtyper og poengformler for intern stipulering).

Rangeringsmetodene på kvotetypen (åpent spørsmål i `kvoterregelverk.feature`) er ikke en del av scopet: ventekvoten har ingen egen rangeringsmetode.

## Åpne spørsmål

- Skal TAKE-493 få egne stories for interne poeng og kontrollen av ventekvoten?

## Statuslogg

| Dato | Hendelse | Av | Lenke til review |
|------|----------|----|------------------|
| 2026-11-13 | Bare en standardkvote kan stenges for fjerning. Slutter kvotetypen å være standardkvote, er den åpen for fjerning igjen (etter fs-admin) | – | – |
| 2026-11-06 | Standardkvoten gjelder bare utdanningstilbud som legges til i opptaket, og blir stående når den slås av | – | – |
| 2026-11-06 | Stengt for fjerning gjelder alle, og kan ikke overstyres av organisasjonen som eier opptaket | – | – |
| 2026-11-06 | Opprettet med fs-scope | – | – |
