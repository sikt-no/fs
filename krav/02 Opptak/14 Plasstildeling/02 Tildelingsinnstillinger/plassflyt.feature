# language: no
# GitHub: #216, #598
@OPT-PLA-INN-002 @must @draft
Egenskap: Plassflyt mellom utdanningskvoter
  Som opptaksforvalter
  ønsker jeg at ledige plasser i en utdanningskvote flyter til en utdanningskvote jeg har pekt på
  slik at studieplasser ikke går tapt når det er for få kvalifiserte søkere i en utdanningskvote.

  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 3, oppgave 3) og oppgave.md (gap-analyse oppgave 3).
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.
  # Selve innstillingen (hvilken utdanningskvote plassene flyter til) settes på utdanningstilbudet, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature. Denne fila beskriver hva
  # plasstildelingen gjør med plassflyten.
  # Status i kode: løst (oppgave.md). Kandidat for @implemented etter verifisering.
  # Begrep: «kvoteflyt» heter nå «plassflyt».

  Bakgrunn:
    Gitt at opptaksforvalter ved lærestedet er innlogget
    Og at utdanningstilbudet "Sykepleie, høst 2027" er med i runden "Hovedrunde" i opptaket "Samordna opptak 2027"

  Regel: Overskytende plasser flyter til den utdanningskvoten det er pekt på

    Scenario: Ledige plasser flyter til mottakende utdanningskvote
      Gitt at det skal gis 20 tilbud i utdanningskvoten "Førstegangsvitnemål"
      Og at det skal gis 100 tilbud i utdanningskvoten "Ordinær"
      Og at utdanningskvoten "Førstegangsvitnemål" har 12 kvalifiserte søkere
      Og at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær"
      Når plasstildelingen gjennomføres
      Så får 12 søkere tilbud i utdanningskvoten "Førstegangsvitnemål"
      Og det gis inntil 108 tilbud i utdanningskvoten "Ordinær"

    Scenario: Plassflyt i flere ledd
      Gitt at ledige plasser i "Samisk" flyter til "Førstegangsvitnemål"
      Og at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær"
      Og at både "Samisk" og "Førstegangsvitnemål" har færre kvalifiserte søkere enn tilbud som skal gis
      Når plasstildelingen gjennomføres
      Så ender de ledige plassene fra begge utdanningskvotene i "Ordinær"

    Scenario: Siste utdanningskvote sender ikke plasser videre
      Gitt at "Ordinær" er siste utdanningskvote
      Og at "Ordinær" har færre kvalifiserte søkere enn tilbud som skal gis
      Når plasstildelingen gjennomføres
      Så blir de ledige plassene i "Ordinær" stående ubrukt

  Regel: Plassflyt er eksplisitt og avgrenset

    Scenario: Én mottakende utdanningskvote
      Når opptaksforvalter setter plassflyt for utdanningskvoten "Førstegangsvitnemål"
      Så kan opptaksforvalter velge én utdanningskvote som skal motta ledige plasser

    Scenario: Plassflyt mellom utdanningstilbud
      Når opptaksforvalter setter plassflyt for utdanningskvoten "Førstegangsvitnemål"
      Så kan opptaksforvalter bare velge utdanningskvoter på utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær"
      Når opptaksforvalter setter at ledige plasser i "Ordinær" skal flyte til "Førstegangsvitnemål"
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten ikke kan gå i ring

    Scenario: Utdanningstilbud uten siste utdanningskvote
      Når opptaksforvalter setter plassflyt slik at alle utdanningskvotene sender plasser videre
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at minst én utdanningskvote må være siste utdanningskvote

  Regel: Det kan spores at en plass kom via plassflyt

    # Visningen er beskrevet i 04 Resultat/vise_resultat.feature.
    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Så er det lagret at plassen kom fra utdanningskvoten "Førstegangsvitnemål"

# ÅPNE SPØRSMÅL:
# - Confluence (raffinering 2026-09-08) har krav om at plasser skal kunne flyte fra en tidligere
#   plasstildeling til en senere. design.md beskriver dette som en blindsone. Er det utenfor scope for 2027?
# - Sirkulær plassflyt håndteres i koden, men ikke i databasen. Skal den avvises når den settes
#   (slik scenarioet over sier), eller bare håndteres i plasstildelingen?
# - Plassflyt finnes på tre nivåer (kvotetype i regelverket, utdanningskvote i opptaket, og per plasstildeling).
#   Skal opptaksforvalter kunne endre plassflyten per runde?
# - Forgrening (sende ledige plasser til flere utdanningskvoter) er ikke støttet. Bekrefte at det ikke trengs?
# - #598 sier at «kun én utdanningskvote kan være siste mottaker». Scenarioet «Utdanningstilbud uten siste
#   utdanningskvote» krever minst én. Skal det være nøyaktig én siste utdanningskvote per utdanningstilbud?
