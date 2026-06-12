---
description: Designmønstre for krav — gjelder ved lesing og skriving av .feature-filer
paths: ["**/*.feature"]
---

# Design patterns for krav

Designmønstre som gjelder ved skriving og tolkning av krav (`.feature`-filer, spesifikasjoner).

## Manglende tilgang skjuler elementet

Når et krav sier at brukeren ikke har tilgang til en funksjon — f.eks. fordi brukeren mangler en rolle eller rettighet — skal elementet som utløser funksjonen være **skjult**, ikke synlig-men-deaktivert og ikke synlig-med-feilmelding ved klikk.

- Gjelder knapper, lenker, menyvalg, faner og hele seksjoner.
- Skriv scenarioer som verifiserer fravær (f.eks. «Så ser ikke brukeren knappen 'Rediger detaljer'»), ikke at elementet er deaktivert.
- Hvis et krav beskriver deaktivert tilstand for en bruker uten tilgang, avviker det fra dette mønsteret — flagg avviket og avklar med bruker i stedet for å anta.
