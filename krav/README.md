## Hva gjør dette repoet?

Dette repositoriet inneholder akseptansekrav for løsninger laget av studieadministrasjon i SIKT

## Retningslinjer

### Språk

Vi skriver Gherkin på Norsk.

Legg til følgende på starten av hver featurefil for norsk

```
# language: NO
```

Oversettelse Engelsk Norsk

| English Keyword | Norwegian equivalent(s) |
| --------------- | ----------------------- |
| Feature         | Egenskap                |
| Background      | Bakgrunn                |
| Scenario        | Scenario                |
| ScenarioOutline | Scenariomal             |
| Examples        | Eksempler               |
| Given           | Gitt                    |
| When            | Når                     |
| Then            | Så                      |
| And             | Og                      |
| But             | Men                     |
| Rule            | Regel                   |

### Best practice Gherkin

Gherkin er er språk som alle andre og krever at man skriver det på en god måte for at det skal være nyttig og forståelig.

Anbefaler alle som ønsker å bli gode på Gherkin går inn på https://automationpanda.com/bdd/ og leser. Dette er en fantastisk guide til hvordan skrive gode scenarioer og features. https://cucumber.io/docs/gherkin/reference/ er også en god intro.

Hvis vi har noen spesielle regler vi skal følge i studieadministrasjon kommer de i denne listen:

- Navn på Feature files skrives med snake*case *
- - Feature files skal prøve å beskrive funksjonaliteten / prosessen med et verb og et substantiv:
    - se_søknad
    - lage_opptak
- Features skal separeres etter prosessene og ikke etter komponenter.
- Hver feature file skal tydelig beskrive hva Featuren gjør og hvilken verdi den gir. Lag en god beskrivelse under Featurenavnet i første linje.
- Unngå for store scenarier. Test helst bare en funksjonalitet i hvert scenarie. Noen scenarier blir naturlig lengre enn andre på grunn av arbeidsflyten som kreves.
- Alle tester skal følge Gitt - Når - Så rekkefølgen.
  - Gitt: Hva som er kriteriene som må være på plass før handlingen skjer
  - Når: Hovedhandlingen som skal testes
  - Så: Forventet resultat.
- Det er rom for å ha flere av hvert kodeord etterhverandre, men aldri i en annen rekkefølge.
- Bruk datatabell og scenario outline for datadrevne tester:
  - https://cucumber.io/docs/gherkin/reference/
- Bruk for det meste bestemt form på roller når handlinger utføres. Personen eller administratoren.

### Tags
@levert betyr at scenariet er fullført og levert til produksjon
