# Velkommen til FS-repoet
I dette GitHub-repoet finner du: 
- FS Saksoversikt
- FS Allmenningen 
- Funksjonelle krav

## FS Offentlig saksoversikt 
FS offentlig saksoversikt inneholder saker som er under arbeid og som står i kø for utvikling (ofte kalt produktbacklog), saker som er til vurdering for om de skal tas inn i arbeidskø og saker som er ferdige. Du kan se sakene og status her:
https://github.com/orgs/sikt-no/projects/4/views/3 

## FS Allmenningen - felles diskusjonsforum
FS Allmenningen er en felles diskusjonsforum som gjelder FS og studieadministrasjon. Vi ønsker å diskutere saker offentlig med engasjerte brukere og interessenter. Vi oppretter temaer og diskusjoner, og oppfordrer brukere og interessenter til å ta aktiv del i diskusjonene. 
https://github.com/sikt-no/fs/discussions

## Funksjonelle krav
Funksjonelle krav er en metode for å beskrive FS som produkt på en systematisk måte, som åpner for samarbeid og medvirkning med brukere som kjenner studieadministrativt arbeid godt.
https://github.com/sikt-no/fs/tree/main/krav

Er du ny i kravarbeidet? Start med [Kom i gang med krav og akseptansetest i FS](https://sikt-no.github.io/fs/kom-i-gang.html). Den viser hvor kravene ligger, hvordan en kravfil ser ut, og hele prosessen steg for steg, fra kravene skrives til leveransen er godkjent i akseptansetesten. Konvensjonene står i [`krav/README.md`](krav/README.md).

### Live-visning av krav
`fs-kravforvaltning/` er en lokal nettside som viser alle `.feature`-filene i `krav/` og oppdateres med én gang en fil lagres:

```bash
cd fs-kravforvaltning   # krever Node 20.19+
npm install
npm run dev   # åpner http://localhost:5173
```

En statisk versjon publiseres til GitHub Pages på <https://sikt-no.github.io/fs/> hver gang `krav/` eller `fs-kravforvaltning/` endres på `main` (`.github/workflows/deploy-viewer.yml`). Den viser kravene slik de ligger på `main`, uten live-oppdatering og uten «Endringer». Bygg og se den lokalt med `npm run build && npx vite preview`.

Tavla «Oppgaver» viser hver oppgave i `tasks/` fra den opprettes til kravene er verifisert: I scope → Kravarbeid → Spesifiseres → Klart til utvikling → repoene → Til verifisering → Verifisert. Kolonnen utledes av kravene og spesifikasjonene. Den er alltid med i FS Kravforvaltning, ved siden av Krav og Avvik. Oppgavene opprettes med skillen `fs-scope`, som deler et initiativ i oppgaver og bestemmer kravene hver oppgave har (se [`tasks/README.md`](tasks/README.md)).

Bryteren «Endringer» over treet viser bare filene i `krav/` som er endret, både det som ikke er committet og det som er committet på branchen siden den gikk ut fra `main`.

Vil du at vieweren skal følge filen og scenarioet du står i i VS Code? Installer den lille utvidelsen i `fs-kravforvaltning/vscode/` én gang, og start VS Code på nytt:

```bash
cd fs-kravforvaltning
npm run vscode:install
```

Kjører vieweren på en annen port enn 5173, setter du `kravViewer.url` i VS Code-innstillingene.

## Andre nettsteder
- Produkt- og domeneinformasjon for utviklere og brukere av FS: https://fs.sikt.no/
- Mer informasjon om FS og samstyringsmodellen ligger på Sikts nettsider: https://sikt.no/omrade/studieadministrasjon
