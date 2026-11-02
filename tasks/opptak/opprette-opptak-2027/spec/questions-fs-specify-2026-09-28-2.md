# Spørsmål og svar — `fs-specify` (2026-09-28)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Andre kjøring samme dag: Figma-skissen hentet via Figma Dev Mode MCP og validert mot kravene.

---

## 1. Avvik 1/4 — Opptaksresultat

**Spørsmål:** Skissen «Opprett opptak — frister og hendelser» ser ut til å avvike fra kravene: Under «Opptaksresultat» viser skissen bare «Hovedopptaket kjøres». Kravene har i tillegg «dato for når søker kan forvente svar» og «første svarfrist som informasjon til søkere». Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — Kravene mangler/har for mye — registreres som åpent spørsmål for fs-krav
- Kravene er riktige — Skissen er utdatert og må få de to datoene
- Ulikt scope — Begge er riktige — skissen dekker ikke hele kravet
- Vet ikke — Åpent spørsmål uten beslutning

**Svar:** Other

**Fritekst:** Kravene er riktige, design må legge disse inn. Men det blir et krav om at disse to parametere/datoer blir brukt til å opprette første plasstilgelingsrunde som publiseres

---

## 2. Avvik 2/4 — Tidlig dokumentasjonsfrist

**Spørsmål:** Skissen «Opprett opptak — frister og hendelser» ser ut til å avvike fra kravene: Under «Dokumentasjon» viser skissen bare «Ordinær frist» og «Ettersendingsfrist». Kravene har også «tidlig dokumentasjonsfrist for søkere med tidlig søknadsfrist» under dokumentasjonsfrister. Skissen har en «Dokumentasjonsfrist» bare under «Tidlig opptak», så kravene kan beskrive samme frist to ganger. Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — Én frist (under Tidlig opptak) — kravene har et dobbelt scenario, åpent spørsmål for fs-krav
- Kravene er riktige — To ulike frister — skissen må få tidlig dokumentasjonsfrist under Dokumentasjon
- Ulikt scope — Begge er riktige — skissen dekker ikke hele kravet
- Vet ikke — Åpent spørsmål uten beslutning

**Svar:** Other

**Fritekst:** Disse fristene som er i krav skal ikke ligge her, men skal flyttes til utdanningstilbud. Altså tildlig dokumentasjonsfrist for søkere og tidlig søknadsfrist skal settes på utdanningstilbud OG på utdanningsbakgrunn

---

## 3. Avvik 3/4 — Trekkfrist og interne saksbehandlingsfrister

**Spørsmål:** Skissen «Opprett opptak — frister og hendelser» ser ut til å avvike fra kravene: Kravene har to regler som ikke finnes i skissen: «trekkfrist for utdanningstilbud» og «interne saksbehandlingsfrister» (generell saksbehandlingsfrist). Begge er @openquestion. «Redigering stenger» i skissen nevner ikke trekking. Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — Fristene skal ikke settes her — kravene må endres i fs-krav
- Kravene er riktige — Skissen er utdatert og må få trekkfrist og saksbehandlingsfrist
- Ulikt scope — Begge er riktige — fristene settes et annet sted
- Vet ikke — Åpent spørsmål uten beslutning (venter på @openquestion-avklaringen)

**Svar:** Other

**Fritekst:** Trekfrist for utdanningstilbud svarer til "redigering stenger" fristen. Interne saksbehandlingsfrister er ikke et krav og kan tas bort

---

## 4. Avvik 4/4 — Endre utdanningsbakgrunn (første svar)

**Spørsmål:** Skissen «Opprett opptak — frister og hendelser» ser ut til å avvike fra kravene: «Endre utdanningsbakgrunn» («Selvbetjent endring av utdanningsbakgrunn») står under overskriften «Saksbehandlertildeling». Kravet beskriver en frist for at søkere endrer utdanningsbakgrunn selv, og har et @openquestion om det gjelder søker, saksbehandler eller begge. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Fristen gjelder søkers selvbetjening — overskriften i skissen er feil
- Skissen er riktig — Fristen handler om saksbehandlertildeling — kravet må endres i fs-krav
- Ulikt scope — Begge er riktige — fristen gjelder begge
- Vet ikke — Åpent spørsmål uten beslutning

**Svar:** Other

**Fritekst:** SKissen var litt feil, det som stod selvbetjent utdanningsbakgrunn skal hete "endre utdanningsbakgrunn", denne endringen har blitt lagt til i figma nå. Kravet så riktig ut

---

## 5. Avvik 4/4 — Hvem fristen gjelder for (etter oppdatert skisse)

**Spørsmål:** Den oppdaterte skissen sier nå «Saksbehandler kan endre søkers utdanningsbakgrunn frem til denne datoen» (under «Saksbehandlertildeling»). Kravet sier «søkere kan endre sin utdanningsbakgrunn selv fram til denne fristen». Hvem gjelder fristen for?

**Alternativer:**
- Saksbehandler — Skissen er riktig — kravet må endres i fs-krav (og @openquestion kan lukkes der)
- Søker (selvbetjent) — Kravet er riktig — skissen må rettes igjen
- Begge — Fristen gjelder både søker og saksbehandler — kravet må utvides i fs-krav
- Vet ikke — Åpent spørsmål uten beslutning

**Svar:** Saksbehandler

---
