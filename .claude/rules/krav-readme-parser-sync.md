---
paths:
  - "krav/README.md"
  - "viewer/server/parse.ts"
  - "viewer/server/parse.test.ts"
---

# Hold krav/README.md og viewer-parseren i synk

Konvensjonene i `krav/README.md` sjekkes av kravvieweren i `viewer/server/parse.ts`, og testes i `viewer/server/parse.test.ts`. Parseren leser ikke README-en når den kjører, så reglene står i koden. De må oppdateres for hånd hver gang README-en endres.

## Når du endrer `krav/README.md`

Gjør dette i samme endring, uten at brukeren må be om det:

1. **Finn reglene som er endret.** Sammenlign med forrige versjon (`git diff krav/README.md`). Se etter regler som er lagt til, endret eller fjernet, og etter merket *(sjekkes i vieweren)*.
2. **Vurder om en regel kan sjekkes.** Kan regelen avgjøres ut fra én `.feature`-fil og stien til den (tags, nøkkelord, stegrekkefølge, kommentarer, filnavn, mappenivå)? Da skal den sjekkes. Regler som krever skjønn (godt språk, «én funksjonalitet per scenario», terminologi) sjekkes ikke.
3. **Oppdater `parse.ts`.** Legg til, endre eller fjern sjekken i konvensjonsblokken (`// Konvensjonsavvik: …`). Meldingen skrives på norsk, i samme stil som de andre, og peker på linja bruddet står på.
4. **Oppdater `parse.test.ts`.** Hver sjekk skal ha ett brudd og ett gyldig eksempel, og testnavnet skal gjøre det lett å kjenne igjen regelen.
5. **Oppdater merkingen i README-en.** Regelen får *(sjekkes i vieweren)* bare når den faktisk sjekkes og testes. Fjernes en sjekk, fjernes merket også.
6. **Kjør testene:** `cd viewer && npm test`. Alle skal gå gjennom.
7. **Se etter nye avvik i eksisterende krav.** En strengere regel kan gi avvik i filer som var gyldige før. Si fra til brukeren hvilke filer det gjelder. Ikke rett kravfilene uten å spørre.

Endres bare formuleringen, og ikke innholdet i regelen, trenger ikke koden å endres. Si likevel fra at du har sjekket det.

## Når du endrer `parse.ts` eller `parse.test.ts`

Det samme gjelder motsatt vei: endrer du en konvensjonssjekk, skal regelen og merket i `krav/README.md` oppdateres i samme endring, slik at README-en fortsatt beskriver det vieweren sjekker.
