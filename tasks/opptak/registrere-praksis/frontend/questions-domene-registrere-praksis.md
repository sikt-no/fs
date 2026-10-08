# Spørsmål til domeneekspertene: Registrere og beregne praksis

Fra `bat-analyze` 2026-10-08, kodegjennomgangen av backend-forslaget på `opptak/praksiskalkulator` (fs-plattform). Spørsmålene gjelder ting kravet (`registrere_praksis.feature`, `@OPT-BEH-BEH-003`) ikke avgjør, men som koden allerede har tatt et valg om. Alle tallene er regnet med koden på branchen.

Bakgrunn: [analysis-registrere-praksis.md](analysis-registrere-praksis.md).

> **Status 08.10.2026:** Alle spørsmålene ble besluttet i gjennomgangen etter `bat-analyze` (se «Besluttet» under hvert spørsmål).
>
> Domeneekspertene må fortsatt gjøre dette:
>
> - **Rette kravet med `fs-krav`** for Q-D1 (kopien av kodeverket), Q-D2 (hva som skjer når perioden starter sent i måneden, eller deles), Q-D3 (antagelsen om jevn fordeling), Q-D5 (tilgangen følger saken) og Q-D6 (avvik på inntil ±2 dager).

---

## Q-D1. Hvilken liste skal praksistype hentes fra?

Kravet («Velge praksistype for en praksisperiode», avklart 16.09.2026) sier at valglisten skal være det **felles praksistypekodeverket**, alle typer med `status_gjelder_soker = J`.

Backend-forslaget lager i stedet en egen tabell, `kodeverk.arbeidserfaringstype`, i opptak. Den har 37 koder som er kopiert inn for hånd og merket «Foreløpig liste», og et eget aktiv-flagg. Bare aktive typer vises i valglisten. Feltet heter «arbeidserfaringstype», ikke «praksistype».

- (a) Bruk felleskodeverket direkte, slik kravet sier.
- (b) Godta en egen kopi i opptak. Hvem vedlikeholder den da, og hvordan holdes den i takt med felleskodeverket?
- (c) Noe annet.

Vi trenger også svar på dette: er de 37 kodene nøyaktig de som har `status_gjelder_soker = J` i dag?

**Besluttet 08.10.2026: (b).** Kopien i opptak godtas. Det gjenstår å avklare hvem som vedlikeholder den, og å rette kravteksten med `fs-krav`.

## Q-D2. Hvordan telles kalendertiden når perioden starter sent i måneden, eller deles i to?

Kravet sier: «hele kalendermåneder, pluss restdagene delt på 30». Det står ikke hva en «hel kalendermåned» er når startdagen ikke finnes i måneden etter (29.–31.).

Med koden blir det slik:

| Periode | Dager | Måneder |
|---|---|---|
| 01.02.–28.02.2021 | 28 | 1,00 |
| 28.01.–27.02.2021 | 31 | 1,00 |
| 29.01.–28.02.2021 | 31 | **1,03** |
| 31.01.–28.02.2021 | 29 | **1,03** |
| 31.01.–30.03.2021 | 59 | 2,00 |

To perioder på 31 dager gir altså ulik praksis. Og en periode på 29 dager gir mer enn en på 28 dager.

Tallet endrer seg også når en periode deles i to:

- **Januar 2021 som én periode** gir 1 måned (0,0833 år). **Delt i 01.–15.01. og 16.–31.01.** gir 15/30 + 16/30 = 1,033 måneder (0,0861 år), altså mer.
- **Februar 2021 som én periode** gir 1 måned. **Delt i 01.–14.02. og 15.–28.02.** gir 28/30 = 0,933 måneder, altså mindre.

Hva skal gjelde?

- (a) Godta dette som en følge av 30-dagersregelen.
- (b) Definer «hel måned» på en annen måte.
- (c) Tell dager delt på 30 for hele perioden.
- (d) Noe annet.

**Besluttet 08.10.2026 (endret samme dag): (a).** Månedsregelen i kravet beholdes: hele kalendermåneder pluss restdagene delt på 30. Alle eksemplene i kravet gjelder fortsatt. At perioder som starter sent i måneden og perioder som deles gir små forskjeller, godtas. Det skal stå i kravet, og det skal testes.

Først ble (c) valgt: dager delt på 30. Det ble endret fordi (c) regner et år som 360 dager og gir for mye praksis. For eksempel ville 01.01.2020–21.12.2021, som er 10 dager mindre enn to år, gitt 2,00 år i stedet for 1,97.

## Q-D3. Hvordan skal timer telle når en timeperiode overlapper en annen periode?

En periode i timer har ikke noe tidspunkt for når timene ble jobbet. Koden antar at timene er **jevnt fordelt** over hele perioden.

Eksempel: 825 timer i hele 2024, og 100 % fra januar til juni 2024.

- Koden regner timeperioden som 50 % hele året. Overlappet i første halvår blir da 150 %, og justert sum blir **0,75 år**.
- Hvis timene i virkeligheten ble jobbet om høsten, er det ikke noe overlapp, og riktig sum er **1,00 år**.

Er jevn fordeling riktig, eller skal timeperioder behandles på en annen måte når de overlapper?

**Besluttet 08.10.2026:** jevn fordeling godtas. Antagelsen skal skrives inn i kravet.

## Q-D4. Skal saksbehandleren varsles når en periode på 0 % overlapper en annen?

0 % er en gyldig stillingsprosent, og gir 0,00 år. Koden tar perioder på 0 % helt ut av overlappsberegningen, så de gir aldri varsel om overlapp.

Skal saksbehandleren likevel få varsel når en periode på 0 % overlapper en annen periode?

**Besluttet 08.10.2026:** nei. En periode på 0 % gir ikke varsel om overlapp.

## Q-D5. Hvem skal kunne se og registrere praksis?

Kravet sier at **bare** brukere med rollen søknadsbehandler kan se og registrere praksis. Hele praksisdelen skal være skjult for andre (situasjon E).

Backend styrer i stedet tilgangen etter **handlinger** per organisasjon:

- **Se** praksis: alle som kan se søknadsbehandlingen. Det er administrator, superbruker, søknadsbehandler og **brukerstøtte**.
- **Endre** praksis: administrator, superbruker og søknadsbehandler.

Holder det at de som kan se saken, også ser praksisen? Eller skal praksis være begrenset til søknadsbehandlerrollen, slik kravet sier?

**Besluttet 08.10.2026 (endret samme dag):** praksis har samme tilgang som saken. Den som kan se søknadsbehandlingen i organisasjonen, kan se praksis. Den som kan endre den, kan endre praksis. Backend gjør dette allerede i dag, og kravet skal rettes slik at det stemmer.

Først ble det besluttet at bare søknadsbehandler skulle ha tilgang. Det ble endret av tre grunner:

- Opptak ser bare handlinger fra tokenet, ikke roller.
- Å begrense tilgangen til én rolle hadde krevd nye handlinger i tilgangsstyring.
- Administrator, superbruker og brukerstøtte hadde mistet tilgangen.

## Q-D6. Må justert sum være nøyaktig begrenset til kalendertiden?

Kravet «Justert sum kan ikke overstige kalendertiden i perioden» holder nesten, men ikke helt.

Koden regner perioder og overlapp med 30-dagersregelen hver for seg, og det gir et avvik på inntil ±2 dager. Eksempel med tre perioder på 100 %: 05.01.–12.03., 21.01.–12.03. og 26.01.–27.03.2021.

- Kalendertiden fra 05.01. til 27.03. er **0,2306 år**.
- Justert sum blir **0,2361 år**. Det er omtrent 2 dager mer enn kalendertiden.

Det kan også bli 2 dager for lite. Testene på branchen beskriver dette som en «kjent begrensning».

Holder det at justert sum er omtrent riktig, eller må grensen være nøyaktig?

**Besluttet 08.10.2026 (endret samme dag):** et avvik på inntil ±2 dager godtas. Det er en følge av månedsregelen (Q-D2), og det skjer bare når et overlapp går gjennom en måned. Dette skal stå i kravet.

## Q-D7. Skal samlet praksis låses når den er regnet ut?

Kravet sier: «Samlet praksis er den samme som da jeg forlot saken.» Koden lagrer periodene og hvilke som er inkludert, men regner summen på nytt hver gang den vises.

Det betyr at hvis regnereglene endres senere, for eksempel etter svaret på Q-D2, endres summene også på saker som allerede er behandlet.

Er det greit, eller skal summen lagres når den regnes ut, med de reglene som gjaldt da?

**Besluttet 08.10.2026:** det er greit å regne summen på nytt hver gang. Det som ligger fast, er periodene, omfanget og hvilke perioder som er inkludert. Summene følger alltid regnereglene som gjelder.

## Q-D8. Hvordan skal overlappsvarselet se ut i grensetilfellene?

Varselteksten er «Du har {antall} perioder som overlapper ({fra}–{til})». Det gjenstår tre spørsmål:

1. **Varierende samlet omfang.** A (50 %) og B (60 %) gjelder hele 2020, og C (10 %) kommer til fra 01.07. Koden gir da to deler: 01.01.–30.06. med 110 % og 01.07.–31.12. med 120 %. Skal det vises ett varsel («tre perioder, 01.01.–31.12.2020») eller ett per del?
2. **Overlapp på én dag.** A slutter 01.07., og B starter 01.07. Skal et slikt overlapp varsles? Etter kravet er det et overlapp, fordi sluttdatoen regnes med.
3. **Summer som ikke stemmer med radene.** Hver rad viser sin egen praksis, avkortet nedover til to desimaler, og radene viser praksis uten justering for overlapp. Summen av radene blir derfor ofte lavere enn summen som vises. Eksempel: tolv månedsperioder vises som 0,08 år hver, til sammen 0,96, mens samlet praksis vises som 0,99 eller 1,00. Trengs det en forklaring i brukerflaten?

**Besluttet 08.10.2026:**

1. Varselet deles der samlet omfang går over eller under 100 % (endret samme dag). Deler som ligger ved siden av hverandre slås sammen bare når de er på samme side av 100 %. A og B (50 % + 40 %) i 2020, og C (20 %) fra 01.07., gir derfor to varsler: ett for 01.01.–30.06. og ett med «>100%» for 01.07.–31.12.
2. Ja, overlapp på én dag skal varsles.
3. Ingen forklaring i brukerflaten.
