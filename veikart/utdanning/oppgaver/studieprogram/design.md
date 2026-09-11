# Opprette og vedlikeholde studieprogram

Utdanningsregisteret er autoritativ kilde for all utdanningsdata i FS. Studieprogrammer, utdanningsmuligheter og utdanningsinstanser registreres her og konsumeres av nedstrøms systemer — først og fremst opptak, men også Finn studier (studiekatalogen), vitnemålsportalen og andre.

Dette dokumentet beskriver tre-nivå-modellen, hvordan studieprogrammer opprettes og vedlikeholdes, og hvilke grensesnitt som finnes for ulike typer læresteder.

**Status:** innledende utkast, 2026-09-11. Bygger på domenedokumentasjon fra fs.sikt.no og gjennomgang av logisk replikering mellom utdanningsregisteret og opptak.

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med «opprette og vedlikeholde studieprogram» mener vi arbeidet lærestedet gjør for å registrere sine utdanninger i utdanningsregisteret — fra grunnlagsdata om utdanningen til konkrete instanser med termin og campus. Det er noe annet enn opptak (som bruker utdanningsdataene) og noe annet enn søknadsbehandling.

| | Utdanningsregisteret | Opptak |
|---|---|---|
| **Spørsmålet** | hva tilbys, hvor og når? | hvem får plassene? |
| **Eier** | lærested | opptaksforvalter / opptaksleder |
| **Dekkes her** | ja | nei — se [opptak/design.md](../../opptak/oppgaver/opptak/design.md) |

### Mål

- Læresteder skal kunne registrere studieprogrammer med all nødvendig grunnlagsdata.
- Data registrert i utdanningsregisteret skal være autoritativ — nedstrøms systemer arver, ikke dupliserer.
- Alle typer læresteder (universiteter, høyskoler, fagskoler) skal kunne registrere utdanninger.
- Endringer i et studieprogram skal propageres til systemer som konsumerer dataene.

### Ikke-mål

- **Ikke opptak.** Opptaksspesifikke innstillinger (kapasitet, regelverk, kvoter) settes i opptaket, ikke i utdanningsregisteret.
- **Ikke emneoppretting.** Emner og etterutdanning har egne prosesser og er ikke i scope her.
- **Ikke studiekatalog / Finn studier.** Presentasjonen av utdanninger til potensielle søkere er et eget domene.

---

## Del 2: tre-nivå-modellen

Utdanningsregisteret organiserer utdanningsdata i tre hierarkiske nivåer. Hvert nivå bygger på det forrige.

### Utdanningsspesifikasjon — «Hva tilbys?»

Grunnlagsdata og beskrivelse av en utdanning. Inneholder:

| Felt | Beskrivelse |
|------|-------------|
| Kode | Unik kode for utdanningen |
| Navn | Offisielt navn (med navnehistorikk, flerspråklig) |
| Type | Studieprogram, emne eller etterutdanning |
| Omfang | Studiepoeng |
| NKR-nivå | Norsk kvalifikasjonsrammeverk (bachelor, master, ph.d. osv.) |
| Fagområde (NUS) | Norsk utdanningsklassifisering |
| Beskrivelse | Innhold, læringsutbytte, opptakskrav (fritekst) |
| Eier | Organisasjonen som har utviklet programmet |

### Utdanningsmulighet — «Hvor og hvordan?»

Utdanningen knyttet til lærestedet som tilbyr den, med informasjon om organisering:

| Felt | Beskrivelse |
|------|-------------|
| Tilbyderorganisasjon | Lærestedet som tilbyr utdanningen |
| Organisering | Heltid / deltid / nettbasert / samlingsbasert |
| Undervisningsspråk | Norsk, engelsk, samisk osv. |
| Prosent av fulltid | For deltidsutdanninger |
| Varighet | Normert studietid |
| Campus-historikk | Hvilke campus utdanningen har vært tilbudt ved |
| Status | Aktiv, planlagt, avviklet |

I høyere utdanning er det typisk én-til-én mellom spesifikasjon og mulighet. Unntak finnes der samme utdanning tilbys med ulik organisering (f.eks. heltid og deltid).

### Utdanningsinstans — «Når og ved hvilket campus?»

Det mest konkrete nivået — en gitt utdanning tilbudt ved et gitt lærested i en gitt termin:

| Felt | Beskrivelse |
|------|-------------|
| Oppstartstermin | Når utdanningen starter (f.eks. høst 2027) |
| Campus | Hvilket studiested |
| Status | Aktiv, kansellert |

Ny instans opprettes for hvert semester en utdanning tilbys. **Dette er nivået opptak kobler seg til** — en søker søker seg opp til en utdanningsinstans.

---

## Del 3: registrering av utdanninger

### To veier inn til utdanningsregisteret

Utdanningsregisteret har to grensesnitt for registrering:

**1. SIS-integrasjon (universiteter og høyskoler)**

Alle universiteter og høyskoler som er med i samordna opptak bruker FS-SIS, som har integrasjon mot utdanningsregisteret. Utdanninger registreres i FS-SIS og overføres automatisk:

```
Lærested → FS-SIS → [integrasjon] → Utdanningsregisteret → [replikering] → Opptak
```

Dette er den etablerte veien og fungerer i dag for UH-sektoren.

**2. Eget grensesnitt (fagskoler)**

Fagskolenes SIS-er integrerer ikke mot utdanningsregisteret. For 2027-opptaket (første samordna opptak med fagskoler) vil fagskolene registrere sine utdanninger i et **eget grensesnitt direkte mot utdanningsregisteret**:

```
Fagskole → [eget grensesnitt] → Utdanningsregisteret → [replikering] → Opptak
```

Dette grensesnittet må dekke oppretting av utdanningsspesifikasjon, utdanningsmulighet og utdanningsinstans — alt som UH-sektoren gjør via FS-SIS.

### Hva grensesnittet for fagskoler må støtte

| Funksjon | Beskrivelse |
|----------|-------------|
| Opprette studieprogram | Registrere utdanningsspesifikasjon med navn, omfang, nivå, fagområde |
| Koble til organisasjon | Angi hvilken fagskole som tilbyr utdanningen |
| Sette organisering | Heltid/deltid, undervisningsspråk, varighet |
| Opprette instanser | Angi oppstartstermin og campus for hvert semester |
| Vedlikeholde | Endre status, oppdatere metadata, avvikle utdanninger |

---

## Del 4: konsumering av utdanningsdata

Utdanningsregisteret publiserer data via to mekanismer:

**GraphQL API:** Nedstrøms systemer kan spørre etter utdanninger, filtrere på nivå/fagområde/status, og hente detaljer. Brukes av Finn studier, opptaksfrontenden og andre.

**Logisk replikering (PostgreSQL):** Opptak abonnerer på tabeller fra utdanningsregisteret for referanseintegritet. Foreløpig replikeres kun primærnøkler og navn — se [utdanningstilbud/design.md](../../opptak/oppgaver/utdanningstilbud/design.md) for detaljer om gap.

### Prinsipp: én autoritativ kilde

Utdanningsregisteret er eneste kilde for grunnlagsdata om utdanninger. Nedstrøms systemer:

- **Arver** — henter data fra utdanningsregisteret ved behov
- **Dupliserer ikke** — lagrer ikke egne kopier av grunnlagsdata (med unntak av replikering for referanseintegritet)
- **Beriker** — legger til egne data (opptaksinnstillinger, søknadsdata) uten å overskrive grunnlagsdata

---

## Del 5: åpne spørsmål

1. **Scope for grensesnittet i 2027:** Skal grensesnittet for fagskoler kun dekke studieprogrammer, eller også emner og etterutdanning? For samordna opptak er det trolig bare studieprogrammer som er aktuelt.

2. **Validering og kvalitetssikring:** Hvem godkjenner at en utdanning er korrekt registrert? Trengs det en godkjenningsprosess, eller er lærestedet selv ansvarlig?

3. **Navnehistorikk og versjonering:** Når et studieprogram endrer navn, hvordan håndteres dette? Skal gamle navn bevares for historikk?

4. **Avhengighet til NOKUT-godkjenning:** Fagskoleutdanninger må være NOKUT-godkjent. Skal utdanningsregisteret validere dette, eller er det lærestedets ansvar å kun registrere godkjente utdanninger?

5. **Migreringsplan for fagskoler:** Har fagskolene eksisterende utdanningsdata som må migreres inn, eller registreres alt fra scratch?

6. **Langsiktig integrasjon:** Skal fagskolenes SIS-er på sikt integrere mot utdanningsregisteret (slik UH-sektoren gjør), eller er det egne grensesnittet en permanent løsning?