# language: no
@skip @støtteprosesser @kurs @ci
Egenskap: 08 Teknisk: Snarveismeny
  Som administrator trenger jeg å kunne finne noen kjernefunksjoner jeg bruker ofte veldig raskt fra hvor som helst i brukerflaten, gjennom å kunne bruke hurtigtaster på tastaturet. (Command palette)
  Fordi jeg vil spare meg for å klikke og navigere rundt i brukerflaten for å finne alle funksjoner jeg trenger. (minimere risiko for musarm)

  # Bakgrunn:
  #   Gitt administratoren er logget inn

  # Scenario: Administrator slår opp snarveismeny fra mac
  #   Når administrator trykker cmd+K fra mac
  #   Så får administrator opp snarveismenyen

  # Scenario: Administrator slår opp snarveismeny fra PC
  #   Når administrator trykker ctrl+K fra PC
  #   Så får administrator opp snarveismenyen

  # Scenario: Administrator tar snarvei direkte til personsøk
  #   Når administrator trykker cmd+shift+p
  #   Så kommer administrator til personsøket

  # # tilgjengelige snarveier

  #   Scenario: Administrator tar snarvei til personsøk
  #     Gitt at administrator er i snarveismenyen
  #     Når administrator trykker cmd+shift+p
  #     Så kommer administrator til personsøket

  # Scenario: Administrator tar snarvei til personsøk
  #   Gitt at administrator er i snarveismenyen
  #   Når administrator trykker cmd+shift+p
  #   Så kommer administrator til personsøket

  # Scenario: Administrator tar snarvei til gruppesøk
  #   Gitt at administrator er i snarveismenyen
  #   Når administrator trykker cmd+shift+g
  #   Så kommer administrator til gruppesøk

  # Scenariomal: Administrator tar snarvei til et område
  #   Gitt at administrator er i snarveismenyen
  #   Når administrator trykker på "<område>"
  #   Så kommer administrator til "<område>"
  #   Eksempler:
  #   |område|
  #   |gruppesøk|
  #   |personsøk|
  #   |opptak   |
  #   |opprette opptak|
  #   |regelverk      |
  #   |søknadsbehandling|

  #   # kommende mulighet
  # #Scenariomal: Snarveienes sortering tilpasser seg kontekst (områdeavhengig visning)

