# Utdanningsregister - Offentlig visning

## Oversikt
Dette er krav for offentlig visning av utdanningsregisteret - en markedsføringsside som gir innsyn i alle utdanninger registrert i FS uten behov for innlogging.

## Formål
- Gi offentlig innsyn i utdanningstilbudet i Norge
- Tilby søke- og filtreringsmuligheter for å finne relevante utdanninger
- Vise hvilke organisasjoner som tilbyr utdanninger
- Tilgjengeliggjøre data via åpne API-er

## Målgruppe
- Potensielle søkere
- Ledere og beslutningstakere
- Forskere og analytikere
- Partnere og samarbeidsinstitusjoner
- Allmennheten

## Kravfiler

### Må ha (prioritert)
1. **UTREG-001-forside-og-orientering.feature** - Introduksjon og navigasjon til videre ressurser
2. **UTREG-002-visning-av-utdanninger.feature** - Oversikt og detaljvisning av utdanninger
3. **UTREG-003-søk-og-filtrering.feature** - Søk og filtrering i utdanninger og organisasjoner
4. **IFK-001-ikke-funksjonelle-krav.feature** - WCAG, mobilstøtte, ytelse og sikkerhet

### Bør ha (kan vente)
5. **UTREG-004-visning-av-organisasjoner.feature** - Oversikt over læresteder med deres utdanninger

## Integrasjoner
- **Utdanningsregisteret**: Primær datakilde for all utdanningsinformasjon
- **FS Admin**: Lenke til administrasjonsgrensesnittet for innloggede brukere
- **Åpne data API**: Lenke til fs.sikt.no for teknisk dokumentasjon

## Ikke-funksjonelle krav
- **Tilgjengelighet**: WCAG 2.1 nivå AA
- **Responsivt design**: Støtte for mobile enheter (375px+)
- **Ytelse**: Direkte henting fra kildedata uten caching
- **Språk**: Norsk bokmål med klarspråk-prinsipper
- **Sikkerhet**: All informasjon tilgjengelig uten innlogging

## Kontekst
Dette er en markedsføringsside som ligger på siden av våre vanlige brukergrensesnitt (FS Admin og Min kompetanse). Visningen kan oppdateres over tid basert på hva interessenter leter etter, men primær visning av utdanninger skjer fortsatt i de ordinære grensesnittene.

## Status
- **Opprettet**: 2024-03-25
- **Prioritet**: Må ha for grunnfunksjonalitet, Bør ha for organisasjonsvisning
- **Fase**: Kravspesifikasjon