# language: no

Egenskap: Plasstildeling
Plasstildeling, også kjent som opptakskjøring, omtaler prosessen hvor et sett med ferdige søknader blir kjørt med en opptaksalgoritme. Algoritmen sammenligner søkerens poengscore innenfor et sett med prioriterte kvoter for å vurdere om vedkommende skal få tilbud eller ikke.

Bakgrunn:
Gitt at følgende brukere ferdigbehandlede søknader finnes:
| navn                  | kvalifisert? | kvote 1 | kvote 2 | kvote 3 | Konkurransepoeng | Skolepoeng  | 
| Thomas Edison         | Ja           | Ja      | Ja      | Nei     | 50               | 50          |
| Nikola Tesla          | Ja           | Ja      | Ja      | Nei     | 55               | 50          |  
| Benjamin Franklin     | Ja           | Ja      | Ja      | Nei     | 30               | 45          |
| Alexander Graham Bell | Ja           | Ja      | Ja      | Nei     | 50               | 40          |
| Albert Einstein       | Ja           | Nei     | Ja      | Nei     | 30               | 30          |
| Marie Curie           | Ja           | Nei     | Ja      | Nei     | 30               | 20          |
| Isaac Newton          | Ja           | Nei     | Ja      | Nei     | 30               | 10          |
| Steve Jobs            | Nei          | Ja      | Ja      | Nei     | 35               | 35          |
| Alan Turing           | Nei          | Ja      | Ja      | Nei     | 40               | 30          |
| Leonardo Da Vinci     | Nei          | Nei     | Ja      | Ja      | 30               | 30          |

Gitt at det finnes følgende kvoter og plasser på studier:
| kvoteprioritet | kvotenavn           | antall plasser | poengutregning   |
| 1              | Italiakvote         | 1              | Konkurransepoeng |
| 2              | Førstegangsvitnemål | 2              | Skolepoeng       |
| 3              | Andregangsvitnemål  | 1              | Konkurransepoeng |

Scenario: Liste prioritert per kvote

Scenario: For mange med samme score

Scenario: Sette rundekriterier

Scenario: Sette opp runder
Når en opptaksleder 

@nih
Scenario: Hovedopptak med en runde
Når opptaksleder starter en runde
Og setter inn følgende rundekriterier
| publiseres | antall runder | kun ett tilbud om plass | kun et ja-svar | bortfall settes |
| ja         | 1             | Ja                      | Ja             | Ja              |

Så skal følgende personer få plass på følgende kvoter 
| Kvote 1           | Kvote 2       | Kvote 3               |
| Leonardo Da Vinci | Thomas Edison | Alexander Graham Bell |
| .                 | Nikola Tesla  | .                     |
Og sendes et tilbud om plass



Scenario: Etterfyllingsopptak
Når opptaksleder starter en runde på et utdanningstilbud som allerede har gitt tilbud til et sett med søkere.

Scenario: Svar på tidligere runder
