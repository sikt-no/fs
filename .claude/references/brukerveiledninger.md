# Husk brukerveiledningene i fs-admin

Brukerveiledningene for FS Admin ligger i fs-admin, ikke her: markdown-filer i `src/features/Brukerveiledninger/innhold/`, vist på `/om/brukerveiledninger`. De skal beskrive det som er bygget. Når det som er levert, endres, må de oppdateres. Det gjøres i fs-admin, med skillen `fs-admin-brukerveiledninger` (`.claude/skills/fs-admin-brukerveiledninger/` i fs-admin-repoet), ikke herfra.

Skillene her skriver aldri i veiledningene. De minner brukeren på dem.

## Når

Påminnelsen gis når det brukerne ser i fs-admin, er endret:

- **`fs-verify` / `fs-verify-agent-teams`:** et krav har fått `@implemented`, `@in-progress` er fjernet fra en del i et levert krav, eller et `@deprecated`-krav eller en `@deprecated`-del er slettet fordi koden er borte.
- **`fs-krav`:** et levert krav er satt til `@deprecated` (helt eller delvis), eller en ny del i et levert krav er blitt `@planned` (modus C og D). Da er ingenting endret i appen ennå, men veiledningen må oppdateres når endringen er levert.

Bare krav med kode i fs-admin, det vil si det saksbehandlere, forvaltere og administratorer ser og gjør. Et krav som bare gjelder fs-plattform (API) eller min-kompetanse (søkerne), gir ingen påminnelse. Er du usikker, gi den.

## Hva du sier

Én kort blokk til slutt i svaret i chat, etter oppsummeringen. Den står ikke i rapporten eller i kravfilene.

> **Husk å oppdatere brukerveiledningene i fs-admin.** `<Feature-ID> <tittel>` er nå levert / endret / fjernet. Bruk skillen `fs-admin-brukerveiledninger` i fs-admin.

Står fs-admin-klonen i systemprompten, eller er stien kjent fra kjøringen, list veiledningene som kan være berørt: `grep -ril` i `src/features/Brukerveiledninger/innhold/` etter ord fra tittelen på egenskapen og fra knappene og overskriftene du fant i koden. Si «kan være berørt», ikke «er berørt». Finnes ingen veiledning for funksjonaliteten, si at det ikke finnes en ennå, og at den kan lages med samme skill. Uten klone eller uten Bash: gi påminnelsen uten lista.

Flere krav i samme kjøring gir én påminnelse med alle kravene, ikke én per krav.
