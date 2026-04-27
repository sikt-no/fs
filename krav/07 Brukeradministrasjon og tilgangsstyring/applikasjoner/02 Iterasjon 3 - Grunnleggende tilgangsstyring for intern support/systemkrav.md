# Systemkrav: Iterasjon 3 — Grunnleggende tilgangsstyring for intern support

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / API-brukere

**Aktører:**
- Sikt support (api-superbrukeradministrator eller api-brukeradministrator for relevante organisasjoner)
- Lokal administrator (kunde-side bruker med api-brukeradministrator-rollen for egen organisasjon)

**Formål:** Gjøre support i stand til å forvalte API-brukernes livssyklus og tilganger fullt ut: opprette, tildele og fjerne roller, og deaktivere/reaktivere. Iterasjonen bygger på leseflyten fra Iterasjon 2 og legger til alle endringsoperasjoner som påvirker tilgangen — bortsett fra selvbetjent administrasjon, som kommer i Iterasjon 4.

## Brukerreise

1. **Oppstart:** Et lærested skal koble til en ny integrasjon. Sikt support oppretter en ny API-bruker for organisasjonen og navngir den.
2. **Tilgang:** Support tilordner riktig rolle i riktig miljø — én eller flere roller om gangen, eksplisitt valgt miljø, og kun blant rollene support selv har rettighet til å tildele.
3. **Vedlikehold over tid:** Når kunden trenger nye eller endrede tilganger, fjerner support roller som ikke lenger er nødvendige (med bekreftelsesdialog), og tilordner nye.
4. **Avslutning:** Når integrasjonen ikke lenger skal være i bruk, deaktiverer support API-brukeren (reversibelt, beholder roller). Den kan reaktiveres senere om behovet kommer tilbake.

Iterasjonen forutsetter at oversikt og detaljer fra Iterasjon 2 allerede er på plass.

## Kapabiliteter

### K8 — Opprette API-bruker

**Feature-ID:** [`BRU-APP-API-009`](opprette_api_bruker.feature) | **GitHub:** [#446](https://github.com/sikt-no/fs/issues/446)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med api-brukeradministrator-rollen ønsker jeg å opprette en ny API-bruker, slik at nye integrasjoner kan konfigureres.

**Kort beskrivelse:** Krever navn og organisasjon. Hvis administrator har tilgang til kun én organisasjon, settes den implisitt; ellers velges en blant administratorens organisasjoner. Superadministrator kan opprette uten organisasjon. Nyopprettet API-bruker har ikke passord og ingen roller — den blir først aktiv i et miljø når første rolle tildeles der.

### K6, K13 — Tilordne rolle til API-bruker

**Feature-ID:** [`BRU-APP-API-007`](tilordne_rolle.feature) | **GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med api-brukeradministrator-rollen ønsker jeg å tilordne en rolle til en API-bruker for et gitt miljø og en gitt organisasjon, slik at API-brukeren får tilgang til riktige data i riktig miljø.

**Kort beskrivelse:** En tilordning gjelder én rolle i ett eksplisitt valgt miljø. Flere roller kan tilordnes samtidig i samme miljø. Allerede tildelte roller vises gråtonet og er ikke valgbare. Valgliste begrenset til roller administratoren selv har rettighet til å tildele. Organisasjon settes implisitt eller velges hvis administrator har tilgang til flere. Inneholder åpne spørsmål om miljø-avgrensning (kan API-bruker ha roller i flere miljøer samtidig?).

### K7, K14 — Fjerne rolle fra API-bruker

**Feature-ID:** [`BRU-APP-API-008`](fjerne_rolle.feature) | **GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med api-brukeradministrator-rollen ønsker jeg å fjerne en rolle fra en API-bruker, slik at API-brukeren mister tilgang den ikke lenger skal ha.

**Kort beskrivelse:** Fjerning krever eksplisitt bekreftelse. Flere roller i ett miljø kan fjernes samtidig (bulk). Fjerning er ikke tilgjengelig for roller administratoren ikke har rettighet til å fjerne.

### K9 — Deaktivere API-bruker

**Feature-ID:** [`BRU-APP-API-010`](deaktivere_api_bruker.feature) | **GitHub:** [#447](https://github.com/sikt-no/fs/issues/447)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med api-brukeradministrator-rollen ønsker jeg å deaktivere en API-bruker, slik at en API-bruker som ikke lenger er i bruk ikke kan benyttes.

**Kort beskrivelse:** Deaktivering krever bekreftelse, hindrer autentisering og bevarer rollene (gir ikke tilgang så lenge brukeren er deaktivert). Reversibelt — reaktivering krever også bekreftelse og gir tilbake alle tidligere roller. Deaktivering er sluttilstanden i livssyklusen — det finnes ingen permanent sletting.

## Åpne spørsmål

- **Miljø-avgrensning ved rolletildeling (K6/K13):** Kan en API-bruker autentisere seg til flere miljøer samtidig, eller er den knyttet til kun ett miljø? Svaret styrer om miljøvalget begrenses til miljøer brukeren allerede er aktiv i, eller om administrator kan tildele i nye miljøer. Se `tilordne_rolle.feature`.
- **Nyopprettet API-bruker uten passord/roller (K8):** Skal denne vises som «ikke aktiv» i lista og på detaljsiden inntil passord/rolle er på plass, og er det samme tilstand som «deaktivert» eller en distinkt tilstand? Se `opprette_api_bruker.feature`.

## Notater

- Iterasjonen forutsetter at Iterasjon 2 (oversikt, detaljer, roller, passordbytte, ansvarlig, beskrivelse) er på plass.
- K10 er bevisst utelatt — deaktivering er sluttilstanden, ingen permanent sletting.
- Selvbetjent rolle-administrasjon (K13/K14) er allerede dekket av disse features via rettighetsregler — Iterasjon 4 fokuserer derfor på sporbarhet, ikke duplikater av denne funksjonaliteten.
