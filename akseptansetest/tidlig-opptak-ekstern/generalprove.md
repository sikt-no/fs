# Generalprøve – Tidlig opptak og tilbudsgaranti, ekstern akseptansetest

Oppdraget til en agent som kjører testsiden for den eksterne akseptansetesten i en nettleser den kan styre, som en generalprøve før de eksterne testerne får den. Den er ikke den agentiske funksjonstesten (fase 2): agenten følger testsiden slik en tester gjør, og ser om stegene, ordene og testdataene stemmer.

Start en Claude Code-økt i `sikt-no/fs` med tilgang til nettleseren, og skriv: «Kjør generalprøven i `akseptansetest/tidlig-opptak-ekstern/generalprove.md`». Kjør den på nytt på samme måte, med en ny søker.

## Før agenten starter (den som starter kjøringen)

1. Kjør `oppsett/sjekk-testdata.sql` mot testmiljøet. Alle radene skal være `ok`, og søkeren under skal være «ikke brukt».
2. Logg inn selv i nettleseren agenten skal bruke, i både Min kompetanse (https://test.minkompetanse.no/) og FS Admin (https://test-fsadmin.sikt.no/), så «Velg testsøker» og «Overstyrt bruker» er tilgjengelige. Agenten logger aldri inn med passord.
3. Si hvilken søker agenten skal bruke, hvis det ikke er den neste i lista under.

## Søkeren

Bruk den første søkeren i «Søkere til testerne» i [testcaser-ekstern.md](testcaser-ekstern.md) som ikke har noe i «Tester». Første kjøring: **ØKOLOGISK BADERING** (22820998719). Skriv «Generalprøve (agent) <dato>» i «Tester» for søkeren i fila, så den ikke deles ut til en tester. Søkeren kan ikke brukes igjen: søknaden om tidlig opptak kan ikke trekkes.

## Testbrukerne i FS Admin

Velges i søkefeltet i den gule linja øverst i FS Admin, nøyaktig slik raden står i lista (sett i generalprøven 2026-11-03):

| Testbruker på testsiden | Rad i «Overstyrt bruker» |
|---|---|
| 2: KORT DOMPAP, saksbehandler ved UiT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) |
| 3: Ordentlig Rundskriv, opptaksforvalter ved HK-dir | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) |

Last inn siden på nytt etter hvert bytte, som testsiden sier.

## Slik kjører agenten

1. Les testsiden i [testcaser-ekstern.md](testcaser-ekstern.md), delen under streken. Den er fasiten. Les også [oppsett.md](oppsett.md).
2. Følg testcase 0–4 i rekkefølge, steg for steg, slik de står. Ta skjermbilde ved forventet resultat i hvert steg (`<steg>.png`, for eksempel `2c.png`).
3. Svar for hvert steg som en tester: **Ja**, **Nei** eller **Delvis**, og skriv hva du gjorde og så. Kom du ikke fram til steget, la svaret stå tomt, og skriv hvorfor.
4. Er ordene i et steg ikke de samme som i skjermen, men det finnes bare ett valg som passer, ta det valget, og skriv både ordet i steget og ordet i skjermen. Det er det generalprøven skal finne.
5. Prøv deg fram bare hvis det er nødvendig for å komme videre (som informasjonsskrivet sier), og skriv hva du gjorde.
6. Løs `[Sjekk begrep]` og `[Sjekk testdata]` i testsiden der skjermen viser svaret, særlig:
   - valget under «Velg utdanningsbakgrunn» i 0a
   - hvordan saksbehandleren finner søkeren i sakslisten i 2a (navn eller søknadsnummer, og hvor søknadsnummeret står)
   - om saken havner hos UiT (2a: saken vises for KORT DOMPAP ved UiT)
   - rekkefølgen på studieønskene etter 0b
7. Endre ingenting utenom det testsiden ber om. Ikke rett noe i FS Admin eller Min kompetanse for å få et steg til å virke.
8. Stopp og spør den som startet kjøringen, hvis du må velge noe testsiden ikke sier, eller hvis en innlogging trengs.

## Resultatet

Skriv `kjoring-<YYYY-MM-DD>-<HHMM>/resultat.md` i denne mappa. Skjermbildene ligger i den samme mappa, og er ignorert av git. Bare `resultat.md` committes.

```markdown
# Generalprøve <YYYY-MM-DD HH:MM>: Tidlig opptak og tilbudsgaranti

- **Startet av**: <navn>
- **Kjørt av**: Claude (<modell>), i <nettleser>
- **Testsiden**: testcaser-ekstern.md @ <commit>
- **Søker**: <navn> (<fødselsnummer>), søknad <nummer hvis det vises>
- **Miljø**: TEST. Versjonen i FS Admin og Min kompetanse, hvis skjermen viser den

## Steg

| Steg | Fungerte det? | Hva agenten gjorde og så | Avvik fra testsiden | Bevis |
|---|---|---|---|---|

## Rettinger i testsiden (forslag)

| Steg | Står nå | Foreslått | Hvorfor |
|---|---|---|---|

## Funn i løsningen

Det som ser ut som feil i løsningen, ikke i testsiden. Samme kolonner som «Funn» på testsiden, med «Fase funnet»: generalprøve.

## Tid

Hvor lang tid hver testcase tok, og om testsiden holder ca. 60 minutter.
```

Agenten endrer ikke testsiden, Confluence eller kravene. Rettingene står som forslag i resultatet, og den som startet kjøringen avgjør dem.

## Etter kjøringen

1. Kjør `oppsett/sjekk-testdata.sql` igjen: raden for søkeren skal vise søknaden med tre studieønsker, «søkt tidlig opptak=true», og «behandles av 186».
2. Gå gjennom resultatet, og rett testsiden. Kjør generalprøven på nytt med neste søker, eller kjør den selv.
