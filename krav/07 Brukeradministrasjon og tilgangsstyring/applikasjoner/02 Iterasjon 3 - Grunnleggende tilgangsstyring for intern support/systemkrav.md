# Systemkrav: Iterasjon 3 — Grunnleggende tilgangsstyring for intern support

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / applikasjoner

**Aktører:**
- Sikt support (super-applikasjonsadministrator eller applikasjonsadministrator for relevante organisasjoner)
- Lokal administrator (kunde-side bruker med applikasjonsadministrator-rollen for egen organisasjon)

**Formål:** Gjøre support i stand til å forvalte applikasjonenes livssyklus og tilganger fullt ut: opprette, tildele og fjerne roller, og deaktivere/reaktivere. Iterasjonen bygger på leseflyten fra Iterasjon 2 og legger til alle endringsoperasjoner som påvirker tilgangen — bortsett fra selvbetjent administrasjon, som kommer i Iterasjon 4.

## Brukerreise

1. **Oppstart:** Et lærested skal koble til en ny integrasjon. Sikt support oppretter en ny applikasjon for organisasjonen og navngir den.
2. **Tilgang:** Support tilordner riktig rolle i riktig miljø — én eller flere roller om gangen, eksplisitt valgt miljø, og kun blant rollene support selv har rettighet til å tildele.
3. **Vedlikehold over tid:** Når kunden trenger nye eller endrede tilganger, fjerner support roller som ikke lenger er nødvendige (med bekreftelsesdialog), og tilordner nye.
4. **Avslutning:** Når integrasjonen ikke lenger skal være i bruk, deaktiverer support applikasjonen (reversibelt, beholder roller). Den kan reaktiveres senere om behovet kommer tilbake.

Iterasjonen forutsetter at oversikt og detaljer fra Iterasjon 2 allerede er på plass.

## Kapabiliteter

### K8 — Opprette applikasjon

**Feature-ID:** [`BRU-APP-API-009`](opprette_applikasjon.feature) | **GitHub:** [#446](https://github.com/sikt-no/fs/issues/446)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å opprette en ny applikasjon, slik at nye integrasjoner kan konfigureres.

**Kort beskrivelse:** En applikasjon har én autentiseringstype som velges ved opprettelse — FS, Feide eller Maskinporten — og typen kan ikke endres senere. FS krever et globalt unikt visningsnavn, og systemet genererer brukernavn. Feide og Maskinporten krever en ID som verifiseres mot kilden ved opprettelse; navnet hentes fra samme oppslag, og ID-en kan ikke registreres på nytt hvis applikasjonen allerede finnes. Alle administratorer må velge en organisasjon — vanlig administrator velger blant sine, super-applikasjonsadministrator blant alle. Nyopprettet applikasjon har ingen roller og er ikke aktiv i noen miljøer; FS-applikasjon mangler i tillegg passord og må klargjøres via passordbytte før bruk.

### K6, K13 — Tilordne rolle til applikasjon

**Feature-ID:** [`BRU-APP-API-007`](tilordne_rolle.feature) | **GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å tilordne en rolle til en applikasjon for et gitt miljø og en gitt organisasjon, slik at applikasjonen får tilgang til riktige data i riktig miljø.

**Kort beskrivelse:** En tilordning gjelder én rolle i ett eksplisitt valgt miljø. Flere roller kan tilordnes samtidig i samme miljø. Allerede tildelte roller vises gråtonet og er ikke valgbare. Valgliste begrenset til roller administratoren selv har rettighet til å tildele. Organisasjon settes implisitt eller velges hvis administrator har tilgang til flere. En applikasjon kan ha roller i flere miljøer; tildeling i et nytt miljø gjør applikasjonen aktiv i miljøet med sin valgte autentiseringstype.

### K7, K14 — Fjerne rolle fra applikasjon

**Feature-ID:** [`BRU-APP-API-008`](fjerne_rolle.feature) | **GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å fjerne en rolle fra en applikasjon, slik at applikasjonen mister tilgang den ikke lenger skal ha.

**Kort beskrivelse:** Fjerning krever eksplisitt bekreftelse. Flere roller i ett miljø kan fjernes samtidig (bulk). Fjerning er ikke tilgjengelig for roller administratoren ikke har rettighet til å fjerne.

### K9 — Deaktivere applikasjon

**Feature-ID:** [`BRU-APP-API-010`](deaktivere_applikasjon.feature) | **GitHub:** [#447](https://github.com/sikt-no/fs/issues/447)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å deaktivere en applikasjon, slik at en applikasjon som ikke lenger er i bruk ikke kan benyttes.

**Kort beskrivelse:** Deaktivering krever bekreftelse, hindrer autentisering og bevarer rollene (gir ikke tilgang så lenge brukeren er deaktivert). Reversibelt — reaktivering krever også bekreftelse og gir tilbake alle tidligere roller. Deaktivering er sluttilstanden i livssyklusen — det finnes ingen permanent sletting.

## Notater

- Iterasjonen forutsetter at Iterasjon 2 (oversikt, detaljer, roller, passordbytte, ansvarlig, beskrivelse) er på plass.
- K10 er bevisst utelatt — deaktivering er sluttilstanden, ingen permanent sletting.
- Selvbetjent rolle-administrasjon (K13/K14) er allerede dekket av disse features via rettighetsregler — Iterasjon 4 fokuserer derfor på sporbarhet, ikke duplikater av denne funksjonaliteten.
