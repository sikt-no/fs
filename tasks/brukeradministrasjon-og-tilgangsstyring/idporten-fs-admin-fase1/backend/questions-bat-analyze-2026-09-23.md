# Spørsmål og svar — `bat-analyze` (2026-09-23)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Gjennomgang av åpne spørsmål

**Spørsmål:** Analysen har 11 funn og 9 åpne spørsmål. De viktigste er at 0073 bruker Feide-rettighetene og at duplisert fødselsnummer gir 23505. Vil du gå gjennom de åpne spørsmålene nå?

**Alternativer:**
- Gå gjennom åpne spørsmål (Anbefalt) — Ett spørsmål om gangen, med anbefaling der det er alternativer. Beslutningene føres inn i analysen.
- Stopp her — Avslutt. Spørsmålene kan tas senere eller i bat-plan.

**Svar:** Gå gjennom åpne spørsmål (Anbefalt)

---

## 2. Åpent spørsmål 1/9 — rettighetsfamilie

**Spørsmål:** Rettighetsfamilie for personer. Anbefaling (a): følger mønsteret fra 0052–0054 og gir atskillelse også på rollenivå; (c) gir alle med BRUKERADMINISTRASJON_* personrettigheten automatisk.

**Alternativer:**
- (a) Full parallell familie (Anbefalt) — BRUKERADMIN_PERSON_LES/_SKRIV/_TILDELING_SKRIV, egen forretningsrolle og eget delegeringstak.
- (b) Én samlet rettighet — BRUKERADMIN_PERSON_SKRIV dekker lesing, opprettelse og tildeling. Enklere, men avviker fra mønsteret.
- (c) Egne privilegier, eksisterende roller — Tre nye privilegier, men impliserte av BRUKERADMINISTRASJON_LES/_SKRIV/_TILDELING.

**Svar:** (a) Full parallell familie (Anbefalt)

---

## 3. Åpent spørsmål 2/9 — typetest på tildelingsflaten

**Spørsmål:** Med (a) fra forrige spørsmål er bare (a) forenlig med kravet: tredje gren i subjektrolletildeling-policyene med subjekt_type = 'person' og BRUKERADMIN_PERSON_* som nøkkel. Bekrefter du (a)?

**Alternativer:**
- (a) Tredje gren for person (Anbefalt) — Egen typetest (subjekt_er_person) og egen nøkkel i alle fire policyene. Ny migrering med DROP + CREATE, som 0057.
- (b) Felles «er menneske»-gren — Utvid subjekt_er_feide_bruker til å dekke person med felles nøkkel. I strid med kravet.

**Svar:** (a) Tredje gren for person (Anbefalt)

---

## 4. Åpent spørsmål 3/9 — registrer-og-tildel

**Spørsmål:** Anbefaling: én SECURITY DEFINER-funksjon (registrer_person(fnr, fornavn, etternavn, rolle, org, miljø)) som sjekker rett først, finner eller oppretter på fødselsnummer og tildeler i samme transaksjon. Samme utfall for ny og kjent person, ingen orakel. Hva velger du?

**Alternativer:**
- Én operasjon (Anbefalt) — Finn-eller-opprett og tildel i én definer-funksjon. Løser funn 3 og 4 samtidig.
- To steg — Opprett person først, tildel etterpå. Krever at nyopprettede personer gjøres synlige for den som opprettet dem.

**Svar:** Én operasjon (Anbefalt)

---

## 5. Åpent spørsmål 4/9 — navn ved gjenregistrering

**Spørsmål:** En annen organisasjon registrerer et kjent fødselsnummer med et annet navn. Anbefaling (a) behold eksisterende; (b) lar enhver organisasjon endre andres navn, (c) røper at personen finnes. Hva velger du?

**Alternativer:**
- (a) Behold eksisterende (Anbefalt) — Oppgitt navn ignoreres for en kjent person. Ingen lekkasje, og ingen organisasjon kan overskrive andres data.
- (b) Nytt navn erstatter — Ny temporal rad i subjektnavn. Siste registrering vinner.
- (c) Avvis ved avvik — Feil når navnet ikke stemmer. Røper at personen er registrert.

**Svar:** (a) Behold eksisterende (Anbefalt)

---

## 6. Åpent spørsmål 5/9 — fødselsnummervalidering

**Spørsmål:** Anbefaling (b): valider i @service-laget med Fodselsnummer flyttet dit det kan deles; godta fnr/D-nummer med gyldige kontrollsifre + Tenor-serien, avvis FS-genererte (kan aldri logge inn med ID-porten). Hva velger du?

**Alternativer:**
- (b) Service-laget, fnr/D/Tenor (Anbefalt) — Delt Fodselsnummer-klasse. Typet GraphQL-feil. Databasen beholder formsjekken som i 0073.
- (a) I databasen — Modulus-11 i registrer_person eller en CHECK. Én port for alle kallere, men i strid med begrunnelsen i 0073.
- (b), men godta FS-genererte — Som anbefalt, men med FS-genererte numre i tillegg, for testdata i syntetiske miljø.

**Svar:** (b) Service-laget, fnr/D/Tenor (Anbefalt)

---

## 7. Åpent spørsmål 6/9 — delegeringstak (første runde)

**Spørsmål:** Anbefaling (a): koblingstabell fra ID-porten-client_id til fs-admins eksisterende applikasjonssubjekt, samme tak uansett innloggingsmetode; ukjent client_id gir bare åpne roller.

**Alternativer:**
- (a) Koble client_id til appen (Anbefalt) — idporten_klient(client_id → applikasjon) og tilganger_for_bruker-snittet. Samme tak som Feide-stien.
- (b) Ingen tak i fase 1 — Personens tildelinger ∪ åpne roller, uten delegeringstak. Enklest, men en annen modell enn Feide.
- (c) Egen ID-porten-applikasjon — Ny subjekttype idporten_applikasjon (som maskinporten_applikasjon) med eget tak, forvaltet separat.

**Svar (Other):** «Gir det mening å bruke samme tak som Feide-stien? En Feide-tilgang er allerede knytte til en org, men idporten er ikke det.»

Svar til brukeren: taket er appens egenskap og organisasjonene kommer fra tildelingene (Feide-stien sender NULL som org-begrensning, 0063); gulvet er det eneste stedet institusjonsbegrepet hører hjemme, og det er ikke hjemorg-avgrenset.

---

## 8. Åpent spørsmål 6/9 — delegeringstak (revidert)

**Spørsmål:** Anbefaling (a'): koble ID-porten-client_id til fs-admins eksisterende feide_applikasjon (samme tak, FK-garantien holder), men for personer uten gulv: (tak ∩ tildelinger) ∪ åpne − nekt.

**Alternativer:**
- (a') Samme tak, uten gulv (Anbefalt) — Koblingstabell client_id → fs-admins app. Personen får bare det hun er tildelt, innenfor appens tak.
- (a) Samme tak, med gulv — tilganger_for_bruker uendret. Personen får gulvet fra alle organisasjoner i taket, slik Feide-brukere får i dag.
- (b) Ingen tak i fase 1 — Tildelinger ∪ åpne roller − nekt. Enklest, men en tildeling i en organisasjon fs-admin ikke er delegert for, virker likevel.

**Svar (Other):** «Jeg vil ikke at vi skal legge ting i samme flyt som feide, isåfall bør feide_applikasjon revurderes som tabellnavn. Jeg ser ikke problemet med at det får en egen tabell. De må også kunne få tilgangsgulvet»

Tolket som: alternativ (c) fra første runde (egen idporten_applikasjon med eget tak), med gulv.

---

## 9. Åpent spørsmål 7/9 — GraphQL-form

**Spørsmål:** Anbefaling (a): egen type Person (@table personsubjekt) med egne felter og operasjoner, parallelt med FeideBruker; interface kan komme senere.

**Alternativer:**
- (a) Egen Person-type (Anbefalt) — Parallell flate til FeideBruker. Egne filtre og egne @service-klasser, ingen gjenbruk av Feide-typene.
- (b) Felles interface nå — Interface over FeideBruker og Person, med én samlet søkeliste for fs-admin. Mer arbeid, og Graphitron må støtte formen.
- Avklar med fs-admin først — La spørsmålet stå åpent til fs-admin-tasken har sett på skjermbildene.

**Svar (Other):** «Egen IdPortenBruker, gjør det eksplisitt i API-et hva det er ment for.»

---

## 10. Åpent spørsmål 8/9 — DELETE på personsubjekt

**Spørsmål:** Anbefaling: trekk tilbake DELETE også; kravet sier fjerning via tildelinger, og DELETE bryter historikken ved gjenregistrering.

**Alternativer:**
- Trekk tilbake DELETE (Anbefalt) — REVOKE INSERT, UPDATE, DELETE. Fjerning skjer bare via tildelinger, slik kravet beskriver.
- Behold DELETE — Som i 0073. Gir en opprydningssti, men avviker fra kravet.

**Svar (Other):** «Behold DELETE, det eneste som er viktig er at en administrator bare kan slette tildelinger.»

---

## 11. Åpent spørsmål 9/9 — audiens i dev/test

**Spørsmål:** Anbefaling: pinn audiensen nå med testverdi i test-profilen og avvisningstest mot JWKS-stubben; produksjonsverdi når Digdir-registreringen finnes; manglende verdi skal stoppe oppstart.

**Alternativer:**
- Pinn nå, fail-closed (Anbefalt) — Testverdi i test-profilen. Påkrevd verdi i dev/prod, så manglende konfigurasjon stopper oppstart.
- Pinn nå, valgfri i dev — Som over, men dev-profilen kan stå uten audiens til Digdir-klienten finnes.
- Vent på Digdir — Ingen endring nå. Audiensregelen står som ikke oppfylt til klientregistreringen finnes.

**Svar:** Pinn nå, fail-closed (Anbefalt)

---
