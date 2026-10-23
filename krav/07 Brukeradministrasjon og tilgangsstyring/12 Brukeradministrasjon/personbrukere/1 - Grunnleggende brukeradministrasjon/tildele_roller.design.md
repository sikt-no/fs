# Implementasjonsdetaljer: Tildele roller til en personbruker

**Relatert feature:** [`tildele_roller.feature`](./tildele_roller.feature)

## Overordnet UI-mønster

Modal («Tildel roller») som åpnes fra fanen Roller på detaljsiden for personbrukeren. Den samme modalen brukes for tilganger på fanen Tilganger, med tekstvariantene «tilganger» i stedet for «roller».

## Komponenter og layout

Tre felt i kaskade, øverst og ned:

1. **Organisasjon**: nedtrekksliste med organisasjonene administratoren har rett til å tildele til personbrukere i. Navnet vises, med akronymet under. Har organisasjonen ikke navn, vises organisasjonskoden.
2. **Miljø**: nedtrekksliste med miljøene administratoren har rett til å tildele i for den valgte organisasjonen. Aktivt først når organisasjonen er valgt.
3. **Roller**: nedtrekksliste med flervalg, med rollekoden og beskrivelsen under. Aktivt først når organisasjon og miljø er valgt.

Bunnen av modalen har «Avbryt» og primærknappen «Tildel roller».

### Én organisasjon

Administrerer administratoren bare én organisasjon, er feltet så normalt som mulig: en vanlig, aktiv nedtrekksliste der organisasjonen er forhåndsvalgt. Administratoren kan åpne listen og se at det ikke finnes andre valg, slik det ville vært med flere organisasjoner. Feltet er **ikke** deaktivert, for det ser ut som en feil eller som om noe mangler.

## Interaksjonsmønstre

### Primærhandling
Knappen «Tildel roller» i modalen kan trykkes når organisasjon, miljø og minst én rolle er valgt. Når administratoren trykker på den, lagres tildelingene. Mens det lagres, står det «Tildeler …» på knappen, og administratoren kan ikke trykke på «Tildel roller» eller «Avbryt».

- Blir alle rollene tildelt, lukkes modalen, og administratoren er tilbake på fanen Roller. Listen over roller oppdateres automatisk med de nye rollene, og kvitteringen vises.
- Blir noen av rollene ikke tildelt, blir modalen stående, og utfallet vises per rolle (se *Delvis suksess* under *Tilstander*).

### Sekundære handlinger
- Når administratoren trykker på «Avbryt», lukkes modalen uten at noe lagres, og valgene nullstilles.
- Når administratoren velger en annen organisasjon, nullstilles miljøet og rollene som er valgt. Når administratoren velger et annet miljø, nullstilles rollene som er valgt.

### Navigasjon
Administratoren åpner modalen ved å trykke på «Tildel roller» over listen på fanen Roller, på detaljsiden for personbrukeren. Etter at rollene er lagret, eller administratoren har trykket på «Avbryt», er administratoren tilbake på fanen Roller.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Én organisasjon | Organisasjonen er forhåndsvalgt i en vanlig, aktiv nedtrekksliste med ett valg (se *Én organisasjon*) |
| Flere organisasjoner, hjemorganisasjonen er blant dem | Hjemorganisasjonen er valgt i nedtrekkslisten, og kan endres |
| Flere organisasjoner, ellers | Ingen organisasjon er valgt. Feltet viser «Ikke valgt» |
| Organisasjon eller miljø mangler | Feltet Roller er deaktivert, med hjelpeteksten «Velg organisasjon og miljø.» |
| Henter roller | Feltet Roller er deaktivert, med hjelpeteksten «Henter …» |
| Ingen roller å tildele | Feltet Roller er deaktivert, med hjelpeteksten «Ingen roller å tildele i denne kombinasjonen.» |
| Rolle allerede tildelt | Rollen står i listen, men kan ikke velges, og har «allerede tildelt» under. Gjelder bare roller som er tildelt direkte. En arvet rolle kan tildeles direkte |
| Suksess (alle tildelt) | Modalen lukkes, listen over roller på fanen Roller oppdateres automatisk, og kvitteringen vises |
| Delvis suksess | Modalen blir stående. Utfallet vises per rolle i tre grupper: tildelt, ikke bekreftet og ikke tildelt (med årsak). Valgene nullstilles |
| Feil for alle | Feilmeldingen vises én gang i modalen |

Valglisten for roller viser bare forretningsroller som ikke er utgått. Filtreringen gjøres på serveren.

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Organisasjon, Miljø | Ingenting er valgt | «Ikke valgt» | – | Ingen organisasjon er forhåndsvalgt uten en hjemorganisasjon jeg administrerer |
| Roller, hjelpetekst | Organisasjon eller miljø mangler | «Velg organisasjon og miljø.» | – | Valglisten for rolle avhenger av valgt organisasjon og miljø |
| Roller, hjelpetekst | Rollene hentes | «Henter …» | – | Valglisten for rolle avhenger av valgt organisasjon og miljø |
| Roller, hjelpetekst | Ingen roller å tildele | «Ingen roller å tildele i denne kombinasjonen.» | «tilganger» på fanen Tilganger | Valglisten for rolle avhenger av valgt organisasjon og miljø |
| Roller, under rollen | Rollen er allerede tildelt direkte | «allerede tildelt» | – | Allerede tildelt rolle vises som ikke-valgbar |
| Primærknapp | Tildelingen pågår | «Tildeler …» | – | Tildele en rolle til en personbruker |
| Kvittering | Alle valgte roller er tildelt | «{antall} roller tildelt» | Entall: «1 rolle tildelt». «tilganger» på fanen Tilganger | Tildele flere roller samtidig |
| Kvittering | Alle tildelt, og noen var tildelt fra før | «{antall} roller tildelt — {n} av dem var tildelt fra før» | Entall i begge ledd | Tildele flere roller samtidig |
| Modal, delvis suksess | Noen ble tildelt | «{antall} roller ble tildelt» | Entall og flertall | Delvis suksess ved samtidig tildeling av roller |
| Modal, delvis suksess | Noen ble ikke tildelt | «{antall} roller ble ikke tildelt», og årsaken bak hver rolle | Entall og flertall | Delvis suksess ved samtidig tildeling av roller |
| Modal, delvis suksess | Noen kunne ikke bekreftes | «{antall} roller kunne ikke bekreftes» og «Tildelingen kan ha gått gjennom selv om den ikke vises her — du har ikke innsyn i tildelingene for denne organisasjonen og dette miljøet. Last siden på nytt for å se hva som står der nå.» | Entall og flertall | Delvis suksess ved samtidig tildeling av roller |
| Feil | Mangler rett til å tildele | «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og miljø.» | Meldingen fra serveren brukes når den finnes | Valglisten for rolle avhenger av valgt organisasjon og miljø |
| Feil | Rollen finnes ikke | «Tilgangskoden finnes ikke.» | Som over | Delvis suksess ved samtidig tildeling av roller |
| Feil | Personbrukeren finnes ikke | «Personbrukeren finnes ikke, eller du har ikke tilgang til den.» | Som over | Delvis suksess ved samtidig tildeling av roller |
| Feil | Ingen tildeling ble bekreftet | «Ingen roller ble bekreftet tildelt. Kan skyldes at du ikke har innsyn i tildelingene for denne organisasjonen og dette miljøet — last siden på nytt for å se hva som står der nå.» | «tilganger» på fanen Tilganger | Delvis suksess ved samtidig tildeling av roller |
| Feil | Annen feil | «Kunne ikke tildele roller. Prøv igjen senere.» | «tilganger» på fanen Tilganger | Tildele en rolle til en personbruker |
## Per-scenario detaljer

### Scenario: Organisasjonen er forhåndsvalgt når administratoren administrerer én organisasjon
Organisasjonen er forhåndsvalgt i et vanlig felt som kan åpnes, ikke i et deaktivert felt (se *Én organisasjon*). Miljø er det første feltet administratoren må velge i.

### Scenario: Personbrukerens hjemorganisasjon er forhåndsvalgt
Hjemorganisasjonen er valgt når modalen åpnes. Velger administratoren en annen organisasjon, trykker på «Avbryt» og åpner modalen igjen, er hjemorganisasjonen valgt på nytt.

### Scenario: Allerede tildelt rolle vises som ikke-valgbar
Gjelder roller som er tildelt direkte for kombinasjonen av organisasjon og miljø. Arvede roller kan velges.

### Scenario: Delvis suksess ved samtidig tildeling av roller
Hver rolle tildeles for seg. Rollene som ble tildelt, står etterpå som «allerede tildelt» i listen.

## Åpne designspørsmål

Ingen.
