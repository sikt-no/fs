# Intern akseptansetest – Saksbehandlertildeling

- **Testplan**: [testplan.md](testplan.md)
- **Krav**: `@OPT-BEH-BEH-011` (de leverte delene), og fasen «Søknadsalternativene fordeles når søknaden sendes» i `@FLY-OPT-SAK-001`, commit `a326792`
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling
- **Laget**: 2026-10-23 av fs-testplan (testgjennomføringen står på samme side som testplanen, som «Akseptansetesting automatisering av kvoter»)

---

## Testgjennomføring

Fyll ut **Faktisk resultat** og **Bestått?** (Ja / Nei / Delvis). Funn registreres i tabellen «Funn» og lenkes i kolonnen for faktisk resultat.

Testbrukerne står i testbeskrivelsen: 1 er opptaksforvalter ved HK-dir, 2 opptaksforvalter ved Universitetet i Oslo, 3 saksbehandler ved Universitetet i Oslo, 4 saksbehandler ved HK-dir og 5 søker. Alle eksemplene gjelder det samordna opptaket i testdataene, forvaltet av HK-dir, med Universitetet i Oslo, UiT, NTNU og Høgskulen på Vestlandet som deltakere. Utdanningstilbudene og behandlertildelingsreglene i eksemplene byttes med dem i testdataene.

**Behandlertildelingsreglene** finnes i opptaket under «Behandlertildelingsregler». Fordelingene heter «Alle i opptaket», «Tilbyderen, også andre», «Tilbyderen, dette studieønsket» og «Samme sektor» i lista, og «Alle som deltar i opptaket», «Bare tilbyderen – også for studieønsker uten egen regel», «Bare tilbyderen – bare dette studieønsket» og «Tilbydere i samme sektor» under «Hvem skal saksbehandle?» i regelen.

**Fordelingen sjekkes slik** (regel 2–8): søkeren (testbruker 5) sender inn søknaden i Min kompetanse med søknadsalternativene i rekkefølgen som står. Så logger du inn som saksbehandler ved organisasjonen (eller testbruker 1, som ser alle sakene), går til «Søknadsbehandling», velger opptaket og finner saken i «Saker i opptak». Under «Søknadsalternativer» i saken står søknadsalternativene organisasjonen saksbehandler. [Sjekk begrep: hvor testbruker 1 ser hvilken organisasjon som har saken]

### Regel 1: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 1.1 | Opprette behandlertildelingsregel | Som testbruker 1: åpne «Behandlertildelingsregler» i opptaket, og velg «Opprett». Fyll inn Kode «JOU», Navn «Journalistutdanning», velg «Tilbydere i samme sektor» under «Hvem skal saksbehandle?», og slå på «Aktiv». Lagre. Gå tilbake til lista, og åpne «JOU» igjen | «JOU» står i lista med «Samme sektor» og «Aktiv». Verdiene står i regelen når den åpnes igjen |  |  |
| 1.2 | Nytt opptak får standard behandlertildelingsregel med «Alle som deltar i opptaket» | Som testbruker 1: opprett et nytt samordna opptak. Åpne «Behandlertildelingsregler» i det nye opptaket | «Standard for opptaket» er en aktiv regel med «Alle i opptaket» |  |  |
| 1.3 | Bytte standard behandlertildelingsregel | Som testbruker 1: velg «UVH» i «Standard for opptaket». Søkeren sender inn en søknad med «Informatikk, UiO» og «Historie, UiT», som ikke har egen regel | «UVH» står som «(standard for opptaket)» i lista. Hvert søknadsalternativ saksbehandles av tilbyderen (UiO og UiT), slik «UVH» sier |  |  |
| 1.4 | Opptaket kan bare ha én aktiv behandlertildelingsregel med «Alle som deltar i opptaket» | Som testbruker 1: opprett en ny regel med «Alle som deltar i opptaket», og slå på «Aktiv». Lagre | Regelen lagres ikke, og det kommer en feilmelding [Sjekk begrep: teksten] |  |  |
| 1.5 | Se hvilke utdanningstilbud som er knyttet til behandlertildelingsregelen | Som testbruker 1: åpne «JOU», som er knyttet til 12 utdanningstilbud. Velg lenken til studiealternativene | Regelen sier at den er knyttet til 12 studiealternativer. Lenken viser «Studiealternativer knyttet til JOU» med de 12 |  |  |
| 1.6 | Slette behandlertildelingsregel som ikke er knyttet til utdanningstilbud | Som testbruker 1: åpne en regel som ikke er knyttet til utdanningstilbud. Velg «Slett», og bekreft | «Tildelingsregelen er slettet.» Regelen står ikke lenger i lista |  |  |
| 1.7 | Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes | Som testbruker 1: åpne «JOU», som er knyttet til utdanningstilbud | «Slett» vises ikke |  |  |
| 1.8a | Behandlertildelingsregel som er standard i opptaket kan ikke deaktiveres | Som testbruker 1: åpne standardregelen, og prøv å slå av «Aktiv» | Regelen kan ikke deaktiveres, og teksten sier at den er standard for opptaket |  |  |
| 1.8b | Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke deaktiveres | Som testbruker 1: åpne «SPE», som er knyttet til utdanningstilbud, og prøv å slå av «Aktiv» | Regelen kan ikke deaktiveres, og teksten sier hvor mange studiealternativer den er knyttet til |  |  |
| 1.9 | Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak | Som testbruker 1: åpne et lokalt opptak | «Behandlertildelingsregler» finnes ikke i opptaket |  |  |
| 1.10 | Deltakende lærested kan ikke endre behandlertildelingsreglene | Logg inn som testbruker 2 (opptaksforvalter ved Universitetet i Oslo). Åpne «Behandlertildelingsregler» i det samordna opptaket, og åpne en regel | «Opprett» vises ikke. Feltene i regelen kan bare leses, og «Slett» vises ikke |  |  |

### Regel 2: Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 2.1 | Lærestedet på første prioritet saksbehandler hele søknaden | Søkeren har norsk utdanningsbakgrunn, og søker «Informatikk, UiO», «Historie, UiT» og «Sykepleie, NTNU», i den rekkefølgen. Ingen av dem har egen regel | Universitetet i Oslo saksbehandler alle tre |  |  |
| 2.2 | Søknadsalternativ med egen behandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden | «Utøvende musikk, NTNU» har «UVH». Søkeren søker «Utøvende musikk, NTNU», «Historie, UiT» og «Informatikk, UiO» | NTNU saksbehandler «Utøvende musikk, NTNU». UiT saksbehandler «Historie, UiT» og «Informatikk, UiO» |  |  |

### Regel 3: Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Tilbyderen saksbehandler søknadsalternativene uten egen behandlertildelingsregel | «Utøvende musikk, NTNU» har «SPE». Søkeren søker «Informatikk, UiO» og «Utøvende musikk, NTNU» | NTNU saksbehandler begge |  |  |
| 3.2 | Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen behandlertildelingsregel | «Utøvende musikk, NTNU» og «Musikkpedagogikk, HVL» har «SPE». Søkeren søker «Informatikk, UiO», «Musikkpedagogikk, HVL» og «Utøvende musikk, NTNU» | Høgskulen på Vestlandet saksbehandler «Musikkpedagogikk, HVL» og «Informatikk, UiO». NTNU saksbehandler «Utøvende musikk, NTNU» |  |  |

### Regel 4: Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 4.1 | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | «Utøvende musikk, NTNU» har «UVH». Søkeren søker «Utøvende musikk, NTNU» og «Informatikk, UiO» | NTNU saksbehandler «Utøvende musikk, NTNU». Universitetet i Oslo saksbehandler «Informatikk, UiO» |  |  |
| 4.2 | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | I et opptak der standardregelen er «Bare tilbyderen – bare dette studieønsket» (for eksempel et fagskoleopptak) søker søkeren to utdanningstilbud ved to læresteder | Hvert lærested saksbehandler sitt eget søknadsalternativ |  |  |

### Regel 5: Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 5.1 | Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren | «Journalistikk, HVL» og «Journalistikk, UiT» har «JOU». Søkeren søker «Informatikk, UiO», «Journalistikk, HVL» og «Journalistikk, UiT» | Høgskulen på Vestlandet saksbehandler alle tre |  |  |
| 5.2 | Organisasjonen som er valgt på behandlertildelingsregelen saksbehandler hele sektoren | Som 5.1, men UiT er valgt i «Velg organisasjon» på «JOU». Søkeren søker «Journalistikk, HVL» og «Journalistikk, UiT» | UiT saksbehandler begge |  |  |
| 5.3 | Søknadsalternativer i ulike sektorer fordeles hver for seg | «Paramedisin, NTNU» har «PAP», og «Journalistikk, HVL» har «JOU». Søkeren søker «Paramedisin, NTNU», «Journalistikk, HVL» og «Informatikk, UiO» | NTNU saksbehandler «Paramedisin, NTNU» og «Informatikk, UiO». Høgskulen på Vestlandet saksbehandler «Journalistikk, HVL» |  |  |
| 5.4 | Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel | Som opptaksforvalter ved NTNU: velg «JOU» som behandlertildelingsregel for «Journalistikk, NTNU». Søkeren søker «Journalistikk, NTNU» og «Journalistikk, HVL» | NTNU er med i sektoren: NTNU saksbehandler begge |  |  |
| 5.5 | Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen behandlertildelingsregel | «Journalistikk, HVL» har «JOU», og «Utøvende musikk, NTNU» har «SPE». Søkeren søker «Journalistikk, HVL», «Utøvende musikk, NTNU» og «Informatikk, UiO» | Høgskulen på Vestlandet saksbehandler «Journalistikk, HVL» og «Informatikk, UiO». NTNU saksbehandler «Utøvende musikk, NTNU» |  |  |
| 5.6a | Opptaksforvalteren kan velge UiT som organisasjon for sektoren | Som testbruker 1: velg UiT i «Velg organisasjon» på «JOU», og lagre. Søkeren søker et utdanningstilbud med «JOU» | UiT saksbehandler søknadsalternativet |  |  |
| 5.6b | Opptaksforvalteren kan velge HK-dir som organisasjon for sektoren | Som 5.6a, med HK-dir | HK-dir saksbehandler søknadsalternativet |  |  |
| 5.7 | Organisasjonen for sektoren må delta i opptaket | Som testbruker 1: åpne «Velg organisasjon» på «JOU» | Universitetet i Bergen, som ikke deltar i opptaket, står ikke blant valgene. Opptakets egen organisasjon og deltakerne står der |  |  |

### Regel 6: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 6.1 | Legge til unntak for utdanningsbakgrunn | Som testbruker 1: åpne «JOU». Under «Unntak for utdanningsbakgrunn», velg «Legg til unntak» to ganger: «Utenlandsk» og «Rudolf Steinerskole», begge med HK-dir i «Fordeles til». Lagre, og åpne regelen igjen | Begge unntakene står i regelen, og lista viser «2 unntak» for «JOU» |  |  |
| 6.2a | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn Utenlandsk | Reglene har unntak som fordeler «Utenlandsk» til HK-dir. Søkeren har utenlandsk utdanningsbakgrunn, og søker «Informatikk, UiO», «Historie, UiT» og «Sykepleie, NTNU» | HK-dir saksbehandler alle tre |  |  |
| 6.2b | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn Rudolf Steinerskole | Som 6.2a, med «Rudolf Steinerskole» | HK-dir saksbehandler alle tre |  |  |
| 6.3 | Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse | Søkeren har realkompetanse, og søker «Informatikk, UiO», «Historie, UiT» og «Sykepleie, NTNU» | Universitetet i Oslo, UiT og NTNU saksbehandler hvert sitt søknadsalternativ |  |  |
| 6.4 | Unntaket går foran behandlertildelingsregel der bare tilbyderen saksbehandler | «Utøvende musikk, NTNU» har «SPE». Både «SPE» og standardregelen har unntak som fordeler «Utenlandsk» til HK-dir. Søkeren har utenlandsk utdanningsbakgrunn, og søker «Informatikk, UiO» og «Utøvende musikk, NTNU» | HK-dir saksbehandler begge |  |  |
| 6.5 | Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig | «Utøvende musikk, NTNU» har «UVH», uten unntak. Standardregelen har unntaket for «Utenlandsk». Søkeren har utenlandsk utdanningsbakgrunn, og søker «Informatikk, UiO» og «Utøvende musikk, NTNU» | NTNU saksbehandler «Utøvende musikk, NTNU». HK-dir saksbehandler «Informatikk, UiO» |  |  |
| 6.6 | Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass | «Informatikk, UiO» tilbyr ledige studieplasser, og ledige studieplasser har åpnet. Søkeren søker ledig studieplass på «Informatikk, UiO» | Universitetet i Oslo saksbehandler søknadsalternativet |  |  |
| 6.7 | Ledig studieplass går foran unntak for utdanningsbakgrunn | Som 6.6, men søkeren har utenlandsk utdanningsbakgrunn | Universitetet i Oslo saksbehandler søknadsalternativet, ikke HK-dir |  |  |
| 6.8 | Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren | Ledige studieplasser har åpnet. Som testbruker 3: legg til ledig studieplass på «Informatikk, UiO» på vegne av søkeren, under «Søknadsalternativer» i saken («Nytt søknadsalternativ») | Universitetet i Oslo saksbehandler søknadsalternativet |  |  |

### Regel 7: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 7.1a | Søknadsalternativene fordeles når søkeren sender inn søknaden | Søkeren sender inn søknaden | Hvert søknadsalternativ har en saksbehandlende organisasjon |  |  |
| 7.1b | Søknadsalternativene fordeles når søkeren endrer søknaden | Søkeren legger til et søknadsalternativ, og sender inn på nytt | Det nye søknadsalternativet har fått saksbehandlende organisasjon |  |  |
| 7.1c | Søknadsalternativene fordeles når saksbehandleren legger til et søknadsalternativ på vegne av søkeren | Som testbruker 3: legg til et søknadsalternativ på vegne av søkeren («Nytt søknadsalternativ») | Det nye søknadsalternativet har fått saksbehandlende organisasjon |  |  |
| 7.2 | Søknaden får én sak per saksbehandlende organisasjon | Søkeren søker «Sykepleie, NTNU» og «Informatikk, UiO», der NTNU skal saksbehandle «Sykepleie, NTNU» og Universitetet i Oslo «Informatikk, UiO» (for eksempel med «UVH» på begge) | Søknaden har én sak hos NTNU og én sak hos Universitetet i Oslo |  |  |
| 7.3 | Tilbyder som ikke er saksbehandlende organisasjon får ingen sak | Søkeren søker «Informatikk, UiO» og «Sykepleie, NTNU», og begge er fordelt til Universitetet i Oslo. Logg inn som saksbehandler ved NTNU, og søk etter søknaden i «Saker i opptak» | NTNU har ingen sak for søknaden |  |  |
| 7.4 | Ny prioritering endrer ikke saksbehandlende organisasjon | Søkeren har søkt «Informatikk, UiO» og «Historie, UiT», begge fordelt til Universitetet i Oslo. Søkeren setter «Historie, UiT» først, og sender inn | Universitetet i Oslo saksbehandler fortsatt begge |  |  |
| 7.5 | Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før | Søkeren har søkt «Informatikk, UiO», fordelt til Universitetet i Oslo. Søkeren legger til «Sykepleie, NTNU» som første prioritet, og sender inn | Universitetet i Oslo saksbehandler «Sykepleie, NTNU» |  |  |
| 7.6 | Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt | Søkeren har søkt «Informatikk, UiO», fordelt til Universitetet i Oslo. Søkeren legger til «Utøvende musikk, NTNU», som har «SPE», og sender inn | NTNU saksbehandler «Utøvende musikk, NTNU». Universitetet i Oslo saksbehandler fortsatt «Informatikk, UiO» |  |  |
| 7.7 | Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene | Søkeren har søkt «Utøvende musikk, NTNU» («SPE») og «Informatikk, UiO», begge fordelt til NTNU. Søkeren sletter «Utøvende musikk, NTNU», og sender inn | NTNU saksbehandler fortsatt «Informatikk, UiO» |  |  |

### Regel 8: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 8.1 | Søkeren bytter til utenlandsk utdanningsbakgrunn | Søknadsalternativene er fordelt til Universitetet i Oslo. Søkeren endrer utdanningsbakgrunnen til utenlandsk i Min kompetanse | HK-dir saksbehandler alle søknadsalternativene |  |  |
| 8.2 | Søkeren bytter til realkompetanse | Søkeren har søkt «Informatikk, UiO» og «Historie, UiT», begge fordelt til Universitetet i Oslo. Søkeren endrer utdanningsbakgrunnen til realkompetanse | Universitetet i Oslo saksbehandler «Informatikk, UiO», og UiT «Historie, UiT» |  |  |
| 8.3a | Bytte fra realkompetanse til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | Søkeren har realkompetanse, og søknadsalternativene er fordelt. Søkeren endrer til norsk utdanningsbakgrunn | Ingen søknadsalternativer har byttet saksbehandlende organisasjon |  |  |
| 8.3b | Bytte fra utenlandsk til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | Som 8.3a, men søkeren har utenlandsk utdanningsbakgrunn (fordelt til HK-dir) | HK-dir saksbehandler fortsatt alle søknadsalternativene |  |  |
| 8.4a | Saksbehandleren endrer utdanningsbakgrunnen til realkompetanse | Søkeren har søkt «Informatikk, UiO» og «Historie, UiT», begge fordelt til Universitetet i Oslo. Som testbruker 3: endre utdanningsbakgrunnen til realkompetanse i saken | Universitetet i Oslo saksbehandler «Informatikk, UiO», og UiT «Historie, UiT» |  |  |
| 8.4b | Saksbehandleren endrer utdanningsbakgrunnen til dispensasjon | Som 8.4a, med dispensasjon | Universitetet i Oslo saksbehandler «Informatikk, UiO», og UiT «Historie, UiT» |  |  |
| 8.5a | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen ikke har gått ut | Fristen for endring av utdanningsbakgrunn har ikke gått ut, og søknadsalternativene er fordelt til Universitetet i Oslo. Som testbruker 3: endre utdanningsbakgrunnen til utenlandsk | HK-dir saksbehandler alle søknadsalternativene |  |  |
| 8.5b | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen har gått ut | Som 8.5a, men fristen har gått ut | Universitetet i Oslo saksbehandler fortsatt alle søknadsalternativene. Saken sier at den overstyrte utdanningsbakgrunnen er registrert etter fristen, og at bare opptaksforvalteren kan flytte saken |  |  |
| 8.6 | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | Fristen har gått ut, og søknadsalternativene er fordelt til Universitetet i Oslo. Som testbruker 1: endre utdanningsbakgrunnen til utenlandsk | HK-dir saksbehandler alle søknadsalternativene |  |  |
| 8.7a | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (tilbudsgaranti fra saksbehandler) | «Informatikk, UiO» har tilbudsgaranti fra saksbehandleren ved Universitetet i Oslo. Søknadsalternativet flyttes til HK-dir (endre utdanningsbakgrunnen til utenlandsk, som i 8.1). Som testbruker 4: åpne saken | Saksbehandlingen av «Informatikk, UiO» starter på nytt hos HK-dir, og tilbudsgarantien fra saksbehandleren står der fortsatt |  |  |
| 8.7b | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (tilbudsgaranti fra tilbyder) | Som 8.7a, med tilbudsgaranti fra tilbyderen | Tilbudsgarantien fra tilbyderen står der fortsatt |  |  |
| 8.7c | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (tilbudsgaranti fra opptaksforvalter) | Som 8.7a, med tilbudsgaranti fra opptaksforvalteren | Tilbudsgarantien fra opptaksforvalteren står der fortsatt |  |  |

### Regel 9: Saksbehandlende organisasjon ser bare saker hos organisasjonen

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 9.1 | Saksbehandleren ser bare saken hos organisasjonen sin | Søknaden har saker hos Universitetet i Oslo og UiT. Som testbruker 3: finn søknaden i «Saker i opptak» | Saksbehandleren ser bare saken hos Universitetet i Oslo |  |  |
| 9.2 | Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon | Søknaden har saker hos HK-dir og Universitetet i Oslo. Som testbruker 4: finn søknaden i «Saker i opptak» | Saksbehandleren ser bare saken hos HK-dir |  |  |

### Regel 10: Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| 10.1 | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | Søknaden har saker hos Universitetet i Oslo og UiT. Som testbruker 1: finn søknaden i «Saker i opptak» | Opptaksforvalteren ser begge sakene |  |  |

### Flyten «Saksbehandlertildeling»: Søknadsalternativene fordeles når søknaden sendes

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
| --- | --- | --- | --- | --- | --- |
| F.1 | Søknaden blir én sak hos hver saksbehandlende organisasjon | «Utøvende musikk, NTNU» har behandlertildelingsregelen «SPE» med «Bare tilbyderen – bare dette studieønsket», valgt på utdanningstilbudet av opptaksforvalteren ved NTNU. «Informatikk, UiO» og «Historie, UiT» har ikke egen regel. Søkeren sender inn søknaden med «Informatikk, UiO», «Utøvende musikk, NTNU» og «Historie, UiT», i den rekkefølgen | Universitetet i Oslo saksbehandler «Informatikk, UiO» og «Historie, UiT», og NTNU «Utøvende musikk, NTNU». Søknaden har én sak hos Universitetet i Oslo og én hos NTNU |  |  |

Åpent spørsmål til F.1: Stegene om hvem som saksbehandler hvert søknadsalternativ gjentar fordelingsreglene. Holder det å sjekke at søknaden har én sak hos hver organisasjon?

### Ikke med i denne testen

| Scenario | Begrunnelse |
| --- | --- |
| Saksbehandling på vegne av et lærested (4 scenarioer) | Valget kan ikke gjøres i FS Admin ennå (STEK-579). Det kan bli laget som en behandlertildelingsregel i stedet |
| Tilbyderens innsyn i saksbehandlingen (3 scenarioer) | Ikke laget ennå (STEK-576). Tas sammen med visning av saksbehandlingen for tilbyderen |
| Søkeren ser saksbehandlende organisasjon | Ikke laget ennå |
| En flyttet sak får status «Overført» | Ikke avklart |
| Valg av behandlertildelingsregel per utdanningstilbud | Eget krav (`@OPT-OPT-UTD-004`), brukes som forutsetning |
| Frist for endring av utdanningsbakgrunn | Eget krav (`@OPT-OVO-FRI-001`), brukes som forutsetning |
| Tilbudsgaranti | Eget krav (`@OPT-BEH-BEH-010`), brukes som forutsetning |
