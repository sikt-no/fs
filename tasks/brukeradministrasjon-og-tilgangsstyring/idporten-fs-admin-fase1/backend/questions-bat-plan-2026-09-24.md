# Spørsmål og svar — `bat-plan` (2026-09-24)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Fire gjenstående valg (taktabell, prod-audiens, DB-navn, takinnhold)

**Spørsmål:**
1. Hvor skal delegeringstaket til ID-porten-appen lagres? `applikasjon_brukerdelegering` har i dag FK rett mot `feide_applikasjon`.
2. Påkrevd audiens stopper oppstart når verdien mangler, og Digdir-verdien finnes ikke ennå. Hvordan skal produksjonsprofilen håndteres?
3. API-et heter IdPortenBruker. Skal navnene i databasen følge med?
4. Hva skal delegeringstaket til ID-porten-appen inneholde?

**Alternativer:**
1. Løsne FK-en (Anbefalt) — subjekt_type + kompositt-FK + CHECK / Egen taktabell — idporten_applikasjon_brukerdelegering
2. Slå av ID-porten i prod (Anbefalt) / Blokker prod-utrulling
3. Behold person/PERSON (Anbefalt) / Følg API-et — idporten_bruker / BRUKERADMIN_IDPORTENBRUKER_*
4. Speil FS Admin utenom forvaltning (Anbefalt) / Tomt i prod, seed i dev/test

**Svar:** Ingen svar. Brukeren ville avklare først:

> «Det er jo fortsatt fs admin som er appen det er snakk om, selv om det kommer fra feide eller idporten. Det er naturlig at selve subjekt_id flyten må vere litt forskjellig, men må vi skille på det i applikasjon og?»

Tolket som at beslutning (c) fra analysen (egen `idporten_applikasjon` med eget tak) tas opp igjen.
Spørsmål 1 og 4 bortfaller hvis appen er felles.

---

## 2. Felles app, prod-audiens og DB-navn (omformulert)

**Spørsmål:**
1. Skal ID-porten-stien bruke FS Admins eksisterende applikasjonssubjekt (felles tak, gulv og deaktivering), med en koblingstabell fra ID-porten-client_id?
2. Hvordan skal produksjonsprofilen håndteres når påkrevd audiens mangler?
3. Skal navnene i databasen følge API-navnet IdPortenBruker?

**Alternativer:**
1. Felles app, koblingstabell (Anbefalt) / Felles app, kolonne på feide_applikasjon / Egen app likevel
2. Slå av ID-porten i prod (Anbefalt) / Blokker prod-utrulling
3. Behold person/PERSON (Anbefalt) / Følg API-et

**Svar:** Ingen svar. Kallet ble avbrutt: brukeren ville først hente inn de siste endringene fra main i tilgangsstyring.

---

## 3. Innhenting fra main

**Spørsmål:**
1. Skal main flettes inn med merge eller rebase? Branchen er allerede pushet.
2. Den committede 0072-apne-roller-uten-tildelinger.sql har samme nummer som 0072-hele-rollekjeden.sql på main. Skal den få nytt nummer?

**Alternativer:**
1. Merge main inn (Anbefalt) — ingen omskriving, ingen force-push / Rebase på main — lineær historikk, krever force-push
2. Nytt nummer, 0077 (Anbefalt) — personsubjekt får 0078 / La 0072 stå

**Svar:**
1. Rebase på main
2. Nytt nummer, 0077 (Anbefalt)

---

## 4. Revisjon etter rebase på main (0075/0076)

**Spørsmål:**
1. 0075 sender alle mennesker til Feide-nøklene. Hvordan skal personer uten Feide få sine egne nøkler i tildelingspolicyene?
2. Skal ID-porten-stien bruke FS Admins eksisterende applikasjonssubjekt, med felles tak, gulv og deaktivering? Det erstatter beslutning (c) i analysen, som var en egen idporten_applikasjon.
3. Påkrevd audiens stopper oppstarten når verdien mangler, og Digdir-verdien finnes ikke ennå. Hva gjør vi med produksjonsprofilen?
4. API-et heter IdPortenBruker. Skal navnene i databasen følge samme navn?

**Alternativer:**
1. Nøkkel per type, lukket (Anbefalt): feide_bruker → FEIDEBRUKER_*, person → PERSON_*, en ukjent menneskelig type treffer ingen gren. Datadrevet familie: kolonne på subjekttype.
2. Felles app, koblingstabell (Anbefalt): idporten_klient(client_id → feide_applikasjon.subjekt_id). Felles app, kolonne. Egen app likevel.
3. Slå av ID-porten i prod (Anbefalt). Blokker prod-utrulling.
4. Behold person/PERSON (Anbefalt): typetesten får et annet navn enn 0075s subjekt_er_person. Følg API-et.

**Svar:**
1. Nøkkel per type, lukket (Anbefalt)
2. Felles app, koblingstabell (Anbefalt)
3. Slå av ID-porten i prod (Anbefalt)
4. Behold person/PERSON (Anbefalt)

---

## 5. App-identitet for ID-porten (gjennomgang med Min Kompetanse i scope), punkt 1

Kontekst: Min Kompetanse skal også støtte ID-porten (studenter og sluttbrukere, ingen tildelinger, bare gulvet). ID-porten-tokens har ikke `act`, og RFC 8693 token exchange er ikke beskrevet i docs.digdir.no. `client_id` er den eneste appidentiteten, og `aud`/`consumer` er like for begge appene.

**Spørsmål:** Skal ID-porten-stien skille mellom apper, slik at tilgangen regnes med appens tak og gulv, med samme formel som Feide: (tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt?

**Alternativer:**
- Ja, samme formel som Feide (Anbefalt): appen er et argument i beregningen. FS Admin gir uregistrerte bare åpne roller, Min Kompetanse gir gulvet.
- Nei, ingen app: tildelinger ∪ åpne − nekt.
- Nei, men alltid gulv: bryter TIL-PÅL-PÅL-003 for FS Admin.

**Svar:** Ja, samme formel som Feide (Anbefalt)

---

## 6. Punkt 2: hvor oversettelsen client_id → app skal bo

**Spørsmål:** Hvor skal oversettelsen fra ID-porten-client_id til app (FS Admin / Min Kompetanse) bo?

**Alternativer:**
- Konfigurasjon (Anbefalt): tilgangsstyring.idporten.klienter."<client_id>"=<service_id>
- Kolonne på appen: idporten_client_id på feide_applikasjon
- Koblingstabell: idporten_klient(client_id → feide_applikasjon)

**Svar (Other):** «idporten_applikasjon med samme tak og gulv som gjelder for Feide. Her vil jeg legge inn en todo om å bestemme hvordan tilgangstak og gulv skal administreres nå som FS Admin og Min Kompetanse får to tak og to gulv (Feide + idporten). Tak og gulv skal sannsynligvis være helt lik for begge, men vi skiller det opp for ordens skyld.»

Tolket som: egen `idporten_applikasjon` (eget applikasjonssubjekt per app og miljø, nøklet på ID-porten-client_id) med eget tak, i starten speilet fra Feide-appens tak. Forvaltningen av to tak per app er en TODO.

---

## 7. Punkt 2b: hvor taket til idporten_applikasjon lagres

Presisert til brukeren: gulvet (bruker_grunntilgang) er miljøvidt og har ikke noe subjekt, så det blir to tak per app, ikke to gulv.

**Spørsmål:** Hvor skal delegeringstaket til idporten_applikasjon lagres?

**Alternativer:**
- Samme tabell, løsnet FK (Anbefalt): applikasjon_brukerdelegering får subjekt_type + kompositt-FK + CHECK. Forvaltnings-API-et (0048) forblir Feide-only.
- Egen taktabell: idporten_applikasjon_brukerdelegering, med en UNION i raa_delegeringstilganger.

**Svar:** Samme tabell, løsnet FK (Anbefalt)

---

## 8. Punkt 3: ukjent client_id

**Spørsmål:** Hva skal skje med et gyldig ID-porten-token fra en client_id som ikke finnes i idporten_applikasjon?

**Alternativer:**
- Bare åpne roller, som Feide (Anbefalt): tomt tak, logg en advarsel og tell det i metrikken.
- Avvis med 401.

**Svar:** Bare åpne roller, som Feide (Anbefalt)

---

## 9. Punkt 4: takinnhold og vakt

**Spørsmål:** Hvordan skal taket til idporten_applikasjon fylles, og hvordan sikres FS Admin mot gulvroller?

**Alternativer:**
- Kopi ved opprettelse + pgTAP-vakt (Anbefalt)
- Kopi + DB-sperre
- Kopi, uten vakt

**Svar:** Kopi, uten vakt

---

## 10. Punkt 6: Min Kompetanse-scope

Punkt 5 (audiens) ble ikke stilt som eget spørsmål. Konklusjonen ble presentert: én audiens (ressursserveren FS GraphQL API), fail-closed. Brukeren innvendte ikke.

**Spørsmål:** Hva skal denne tasken levere for Min Kompetanse?

**Alternativer:**
- Modell + testdata (Anbefalt)
- Modell + testdata + krav: et krav for Min Kompetanse via ID-porten skrives først (bat-krav / bat-specify-delta)
- Bare modellen

**Svar:** Modell + testdata + krav

---
