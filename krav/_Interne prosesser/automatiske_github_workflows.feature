# language: no
@automatisering @workflows @github
Egenskap: Automatiske GitHub workflows for saksadministrasjon
  Som produktteam trenger vi automatiserte workflows slik at saker håndteres konsekvent gjennom hele livssyklusen fra opprettelse til ferdigstillelse.

  Bakgrunn:
    Gitt at GitHub-repoet for FS har konfigurerte workflows
    Og at både githug-prosjektene for både offentlig og intern saksoversikt er tilgjengelige
    Og at issue-templates krever obligatoriske felt

  Scenario: Automatisk tilknytte nye saker til prosjekter
    Gitt at en ny sak opprettes i GitHub-repoet
    Når saken lagres
    Så legges saken automatisk til "FS Offentlig saksoversikt"
    Og saken legges automatisk til "FS Saksoversikt (intern)"
    Og det kommenteres på saken om prosjekt-tilknytning

  Scenario: Unntak - saker som markeres med label "intern" synes kun i FS Saksoversikt (intern)
      Gitt at en ny sak opprettes i GitHub-repoet
      Når saken lagres
      Og saken er markert med label "Intern"
      Så legges saken kun automatisk til "FS Saksoversikt (intern)"
      Og det kommenteres på saken om prosjekt-tilknytning

  Scenario: Tildele standard status ved saksopprettelse
    Gitt at en ny sak opprettes
    Når saken ikke har spesielle kriterier for unntak
    Så tildeles saken automatisk status "til vurdering"
    Og saken plasseres i riktig kolonne i saksoversiktene

  Scenario: Tildele arbeidskø-status for kritiske bugs
    Gitt at en sak opprettes med type "bug"
    Og saken har prioritet "critical"
    Og saken er tilordnet en seksjon
    Når saken lagres
    Så tildeles saken automatisk status "arbeidskø"
    Og saken hopper over "til vurdering"-stadiet
    Og seksjonen varsles om den kritiske saken

  Scenario: Automatisk registrere startdato når arbeid begynner
    Gitt at en sak ligger med status "arbeidskø"
    Når saken flyttes til kolonne som inneholder "under arbeid"
    Så legges dagens dato automatisk til som startdato i beskrivelsen
    Og saken får label "under arbeid"
    Og endringen synkroniseres til begge saksoversikter

  Scenario: Automatisk registrere ferdigdato når arbeid fullføres
    Gitt at en sak har status "under arbeid"
    Når saken flyttes til status "ferdig" eller lukkes
    Så legges dagens dato automatisk til som ferdigdato i beskrivelsen
    Og endringen synkroniseres til begge saksoversikter

  Scenario: Håndtere konflikter mellom workflows
    Gitt at flere workflows kan trigges samtidig
    Når en sak endres på en måte som påvirker flere workflows
    Så skal workflows kjøre uten å overskrive hverandres endringer
    Og alle relevante metadata skal legges til korrekt

  Scenario: Sikre konsistent synkronisering mellom saksoversikter
    Gitt at en workflow endrer en saks metadata
    Når endringen prosesseres
    Så oppdateres både offentlig og intern saksoversikt samtidig
    Og begge viser samme informasjon om status og startdato og ferdigdato

  Scenario: Logge workflow-aktivitet for feilsøking
    Gitt at en workflow kjører på en sak
    Når workflow-handlinger utføres
    Så logges alle steg og eventuelle feil
    Og logger er tilgjengelige for feilsøking
    Og suksessfulle kjøringer bekreftes