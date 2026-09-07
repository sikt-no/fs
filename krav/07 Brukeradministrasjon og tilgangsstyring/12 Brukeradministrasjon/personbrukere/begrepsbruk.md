# Begrepsbruk: tilgang og rolle

> Status: utkast. Begrepene bør valideres med utvikling, design og brukere før de låses.

## Formål

Dette notatet beskriver begrepsbruken som foreslås for tilgangsstyring og administrasjon av personbrukere i FS, og hvorfor det innføres et semantisk skille mellom **tilgang** og **rolle** på domenesiden — uten å endre den tekniske modellen.

Notatet er del av domenebeskrivelsen for initiativet [«Brukeradministrasjon av FS Admin-brukere» (#350)](https://github.com/sikt-no/fs/issues/350).

## Bakgrunn og hensikt

I arbeidet med tilgangsstyring trengs begreper som er presise for utviklere og samtidig forståelige for dem som faktisk administrerer tilganger i det daglige. Disse to hensynene trekker i litt ulik retning: den tekniske modellen er bevisst enkel og uniform, mens administratoren tenker i konkrete oppgaver og ansvar. Notatet skiller derfor tydelig mellom **den tekniske modellen** og **domenemodellen** (det som vises i brukerflaten), og forklarer hvorfor det legges semantikk oppå den tekniske strukturen.

## Den tekniske modellen

Teknisk er hele hierarkiet bygget av én og samme byggekloss. Det minste elementet — «atomet» — er en rolle. Roller kan settes sammen til en ny rolle, og den rollen kan i sin tur arves av en tredje rolle. Modellen er rekursiv og bærer ingen innebygd semantikk: en rolle er en rolle, uavhengig av om den representerer én enkelt rettighet eller en hel jobbfunksjon.

Dette er en styrke på teknisk side. Én uniform datatype med komposisjon og arv gir en enkel, fleksibel og forutsigbar modell som er lett å vedlikeholde og resonnere om i koden.

## Domenebegrepene

På domenesiden, og i brukerflaten, innføres semantikk oppå den tekniske modellen:

- **Tilgang** er atomet: den minste, udelelige enheten — én konkret rettighet eller mulighet i systemet.
- **Rolle** er molekylet: en meningsfull sammensetning av tilganger (og eventuelt andre roller) som svarer til en arbeidsoppgave, et ansvar eller en funksjon.

Roller kan settes sammen til større roller — akkurat som i den tekniske modellen — men nå med en betydning knyttet til seg.

## Sammenhengen mellom teknisk og domene

Domenebegrepene er et semantisk lag oppå den tekniske modellen, ikke en ny teknisk konstruksjon. Under panseret er det fortsatt bare roller som komponeres og arves. Skillet mellom tilgang og rolle handler om hvilken rolle elementet spiller for brukeren:

- Et element som fungerer som en udelelig byggekloss, presenteres som en **tilgang**.
- Et element som er satt sammen for å dekke et behov eller en funksjon, presenteres som en **rolle**.

|                          | Teknisk modell              | Domenemodell (brukerflate)              |
|--------------------------|-----------------------------|------------------------------------------|
| Atomet (minste enhet)    | rolle                       | tilgang                                  |
| Sammensatt enhet         | rolle                       | rolle                                    |
| Semantikk                | ingen — alt er roller       | ja — tilgang vs. rolle har ulik betydning |

## Hvorfor skillet ønskes

- **Speiler hverdagsspråket.** Folk spør «har du tilgang til X?» og «hvilken rolle har du?». Begrepene tilgang og rolle er allerede innarbeidet og intuitive, mens «en rolle som arver en rolle» er en teknisk abstraksjon de fleste administratorer ikke bør måtte forholde seg til.
- **Reduserer kognitiv last.** Administratoren slipper å forstå den rekursive modellen. Det holder å vite at en rolle er bygget av tilganger.
- **Skiller «hva man kan gjøre» fra «hvilken funksjon man har».** Tilgang beskriver en konkret rettighet; rolle beskriver et ansvar eller en oppgave. Det gjør det enklere å vurdere om en tildeling er riktig.
- **Gjør tildeling tryggere og mer forståelig.** Når roller er meningsbærende, blir det lettere å se hva en bruker faktisk får, og hvorfor.
- **Beholder teknisk fleksibilitet.** Fordi semantikken bare ligger i domenelaget, kan brukerne få et tydeligere språk uten å gi avkall på den enkle, uniforme tekniske modellen.

## Bruksprinsipper

- Det skal være lett å gjøre riktig, og vanskelig å gjøre feil. Særlig for komplekse valg med stor konsekvens ved feilvalg.
