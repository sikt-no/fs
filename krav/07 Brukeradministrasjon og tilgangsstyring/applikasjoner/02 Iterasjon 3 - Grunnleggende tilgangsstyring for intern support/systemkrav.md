# Systemkrav: Iterasjon 3 — Grunnleggende tilgangsstyring for intern support

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / applikasjoner

**Aktører:**
- Sikt support (super-applikasjonsadministrator eller applikasjonsadministrator for relevante organisasjoner)
- Lokal administrator (kunde-side bruker med applikasjonsadministrator-rollen for egen organisasjon)

**Formål:** Gjøre support i stand til å forvalte applikasjonenes livssyklus og tilganger fullt ut: opprette, tildele og fjerne tilganger, og deaktivere/reaktivere. Iterasjonen bygger på leseflyten fra Iterasjon 2 og legger til alle endringsoperasjoner som påvirker tilgangen — bortsett fra selvbetjent administrasjon, som kommer i Iterasjon 4.

## Brukerreise

1. **Oppstart:** Et lærested skal koble til en ny integrasjon. Sikt support oppretter en ny applikasjon for organisasjonen og navngir den.
2. **Tilgang:** Support tildeler riktig tilgang i riktig miljø — én eller flere tilganger om gangen, eksplisitt valgt miljø, og kun blant tilgangene support selv har rettighet til å tildele.
3. **Vedlikehold over tid:** Når kunden trenger nye eller endrede tilganger, fjerner support tilganger som ikke lenger er nødvendige (med bekreftelsesdialog), og tildeler nye.
4. **Avslutning:** Når integrasjonen ikke lenger skal være i bruk, deaktiverer support applikasjonen (reversibelt, beholder tilganger). Den kan reaktiveres senere om behovet kommer tilbake.

Iterasjonen forutsetter at oversikt og detaljer fra Iterasjon 2 allerede er på plass.

## Kapabiliteter

### K8 — Opprette applikasjon

**Feature-ID:** [`BRU-APP-API-009`](opprette_applikasjon.feature) | **GitHub:** [#446](https://github.com/sikt-no/fs/issues/446)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å opprette en ny applikasjon, slik at nye integrasjoner kan konfigureres.

**Kort beskrivelse:** En applikasjon har én autentiseringstype som velges ved opprettelse — FS, Feide eller Maskinporten — og typen kan ikke endres senere. FS krever et globalt unikt visningsnavn, og systemet genererer brukernavn. Feide og Maskinporten krever en ID som verifiseres mot kilden ved opprettelse; navnet hentes fra samme oppslag, og ID-en kan ikke registreres på nytt hvis applikasjonen allerede finnes. Alle administratorer må velge en organisasjon — vanlig administrator velger blant sine, super-applikasjonsadministrator blant alle. Nyopprettet applikasjon har ingen tilganger og er ikke aktiv i noen miljøer; FS-applikasjon mangler i tillegg passord og må klargjøres via passordbytte før bruk.

### K6, K13 — Tildele tilgang til applikasjon

**Feature-ID:** [`BRU-APP-API-007`](tildele_tilgang.feature) | **GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å tildele en tilgang til en applikasjon for et gitt miljø og en gitt organisasjon, slik at applikasjonen får tilgang til riktige data i riktig miljø.

**Kort beskrivelse:** En tildeling gjelder én tilgang i ett eksplisitt valgt miljø. Flere tilganger kan tildeles samtidig i samme miljø. Allerede tildelte tilganger vises gråtonet og er ikke valgbare. Valgliste begrenset til tilganger administratoren selv har rettighet til å tildele. Organisasjon settes implisitt eller velges hvis administrator har tilgang til flere. En applikasjon kan ha tilganger i flere miljøer; tildeling i et nytt miljø gjør applikasjonen aktiv i miljøet med sin valgte autentiseringstype.

### K7, K14 — Fjerne tilgang fra applikasjon

**Feature-ID:** [`BRU-APP-API-008`](fjerne_tilgang.feature) | **GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å fjerne en tilgang fra en applikasjon, slik at applikasjonen mister tilgang den ikke lenger skal ha.

**Kort beskrivelse:** Fjerning krever eksplisitt bekreftelse. Flere tilganger i ett miljø kan fjernes samtidig (bulk). Fjerning er ikke tilgjengelig for tilganger administratoren ikke har rettighet til å fjerne.

### K9 — Deaktivere applikasjon

**Feature-ID:** [`BRU-APP-API-010`](deaktivere_applikasjon.feature) | **GitHub:** [#447](https://github.com/sikt-no/fs/issues/447)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker med applikasjonsadministrator-rollen ønsker jeg å deaktivere en applikasjon, slik at en applikasjon som ikke lenger er i bruk ikke kan benyttes.

**Kort beskrivelse:** Deaktivering krever bekreftelse, hindrer autentisering og bevarer tilgangene (gir ikke tilgang så lenge applikasjonen er deaktivert). Reversibelt — reaktivering krever også bekreftelse og gir tilbake alle tidligere tilganger. Deaktivering er sluttilstanden i livssyklusen — det finnes ingen permanent sletting.

## Notater

- Iterasjonen forutsetter at Iterasjon 2 (oversikt, detaljer, tilganger, passordbytte, ansvarlig, beskrivelse) er på plass.
- K10 er bevisst utelatt — deaktivering er sluttilstanden, ingen permanent sletting.
- Selvbetjent administrasjon av tilganger (K13/K14) er allerede dekket av disse features via rettighetsregler — Iterasjon 4 fokuserer derfor på sporbarhet, ikke duplikater av denne funksjonaliteten.
