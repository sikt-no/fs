# Utdanningstilbud i opptak

Placeholder — designdokument under utarbeidelse. Skilt ut som egen oppgave fra [opptak/design.md](../opptak/design.md).

**Status:** ikke påbegynt, 2026-09-11.

## Scope

Dette dokumentet skal dekke:

- Hvordan utdanningstilbud knyttes til et opptak (eierskap og retning)
- Konfigurasjon per utdanningstilbud: kapasitet, antall tilbud, antall ja-svar, regelverk, kvoter
- Overstyring av opptakets innstillinger per utdanningstilbud
- Visning av utdanningstilbud fra opptakssiden

## Hypotese om eierskap

Det er utdanningstilbudet som forteller at det skal være med i et opptak, ikke opptaket som «henter inn» utdanningstilbud. Lærestedet knytter sine utdanningstilbud til et opptak fra utdanningstilbudsiden. Fra opptakssiden skal det være mulig å se hvilke utdanningstilbud som er med, og det bør også være mulig å legge til utdanningstilbud derfra som en snarvei.

## Egenskaper per utdanningstilbud

| Egenskap | Beskrivelse |
|----------|-------------|
| **Antall studieplasser** (kapasitet) | Faktisk antall plasser |
| **Antall tilbud som skal gis** | Det absolutte antallet tilbud som skal gis for dette utdanningstilbudet |
| **Antall ja-svar** | Nødvendig for utdanningstilbud som skal være med i plasstildelingsrunder etter hovedrunden |
| **Regelverkssamling** (valgfritt) | Overstyrer opptakets regelverkssamling for dette tilbudet |
| **Kompetanseregelverk** | Arves fra regelverkssamling eller settes eksplisitt |
| **Rangeringsregelverk** | Arves fra regelverkssamling eller settes eksplisitt |
| **Utdanningskvoter** | Standard (default) kvotetyper arves fra regelverkssamling, og vises. Lærestedet kan legge til eventuelle andre tilgjengelige kvoter som ikke er standard. Standard- og tilgjengelige kvotetyper med fordeling og plassflyt settes i regelverkssamling, se også [plasstildeling/design.md](../plasstildeling/design.md) |
| **Tidlig behandling og tilbud** | Om dette tilbudet støtter tidlig behandling og tilbud (arves fra opptak) |

**Merk:** det foreligger et forslag om å endre kvotefordelingen fra absolutt per utdanningskvote til relativ fordeling på kvotetypenivå i regelverkssamlingen. Med denne endringen setter lærestedet bare totaltall og eventuelle absolutte spesialkvoter per utdanningstilbud — den relative fordelingen mellom ordinære kvoter beregnes automatisk. Se [regelverk/design.md, «Forslag: relativ fordeling på kvotetypenivå»](../regelverk/design.md#forslag-relativ-fordeling-på-kvotetypenivå).

Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).