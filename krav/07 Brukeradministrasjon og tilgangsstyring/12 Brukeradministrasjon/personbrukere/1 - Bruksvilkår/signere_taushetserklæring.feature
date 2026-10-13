# language: no
# GitHub: #478
# Kilde: Bullet fra #350-body — "Bruker skal signere taushetserklæring dersom bruker får tilgang til å se og oppdatere personopplysninger"
@BRU-PER-BRV-002 @draft
Egenskap: Signere taushetserklæring ved tilgang til personopplysninger
  Som bruker som skal få tilgang til personopplysninger
  ønsker jeg å bli forelagt og kunne signere en taushetserklæring
  slik at det er dokumentert at jeg er kjent med taushetsplikten før jeg får tilgangen.

  Scenario: Bruker får tildelt en tilgang som krever taushetserklæring
    Gitt at brukeradministrator tildeler en tilgang som krever taushetserklæring
    Og brukeren ikke har en gyldig signert taushetserklæring fra før
    Når brukeren neste gang logger inn i FS Admin
    Så skal taushetserklæringen vises
    Og brukeren må signere før den tildelte tilgangen aktiveres

  Scenario: Bruker har allerede signert gyldig taushetserklæring
    Gitt at brukeren har signert gjeldende taushetserklæring
    Når brukeren får tildelt en ny tilgang som krever taushetserklæring
    Så skal tilgangen aktiveres uten ny signering

# ÅPNE SPØRSMÅL:
# - Hvilke tilganger trigger kravet om taushetserklæring? Er det per tilgang, per rolle, eller per datasett?
# - Hvor lenge er en signert taushetserklæring gyldig? (én gang, årlig, ved versjonsskift)
# - Skal taushetserklæringen være den samme på tvers av organisasjoner, eller organisasjonsspesifikk?
# - Hvordan håndteres en bruker som nekter å signere — blir tildelingen automatisk tilbakekalt?
# - Hvordan dokumenteres signaturen for revisjonsformål (tidsstempel, IP, versjon)?
# - Forholdet til bruksvilkår (BRU-PER-BRV-001) — kombinert flyt eller separat?
