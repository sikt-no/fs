# Spørsmål og svar — `fs-specify` (2026-10-28)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Brukeren oppga kravfilene, oppgavemappa og skissen i invokasjonen, så spørsmålene om kildemappe, oppgave og om det finnes skisser ble ikke stilt. Spørsmålene ble stilt på tysk.

---

## 1. Branch

**Spørsmål:** Dein lokaler main liegt 44 Commits hinter GitHub. Soll ich ihn vorher aktualisieren (git pull --ff-only)? Die design.md und die Änderung an der Spezifikation bleiben dabei erhalten.

**Alternativer:**
- Ja, aktualisieren (Recommended) — Holt den neuesten Stand von main, damit ich mit den aktuellen Kravene vergleiche.
- Nein, so weiter — Vergleicht mit dem lokalen Stand. Änderungen anderer an L1 oder L2 fehlen dann vielleicht.

**Svar:** Ja, aktualisieren (Recommended)

---

## 2. Skisseavvik L2: leserettighet

**Spørsmål:** Der Rahmen «annullert vitnemål lagt til grunn fra før, saksbehandler har kun leserettighet» zeigt die Radiobuttons weiterhin (leer bzw. ausgegraut). L2 sagt für Leserecht: «Men jeg ser ikke muligheten til å endre dem», und das Muster in FS Admin ist: fehlendes Recht blendet die Bedienelemente aus, statt sie zu deaktivieren. Was gilt?

**Alternativer:**
- Anforderung gilt — Die Skizze ist veraltet: Bei Leserecht werden keine Radiobuttons angezeigt.
- Skizze gilt — Radiobuttons bleiben deaktiviert sichtbar. Das wäre eine Abweichung vom Muster und muss in L2 geändert werden (fs-krav).
- Weiß nicht — Als offene Frage festhalten.

**Svar:** Skizze gilt

---

## 3. Implementasjonsdetaljer L1

**Spørsmål:** Für L1 gibt es noch keine vise_elektroniske_vitnemål.design.md. Die beiden Fehlermeldungen aus L1 (Vitnemål können nicht geholt werden, Punkteberechnung antwortet nicht) sind in der Skizze nicht gezeichnet, und «Åpne i nytt vindu» weicht von «ny fane» ab. Soll ich die design.md für L1 jetzt mit fs-implementasjonsdetaljer anlegen?

**Alternativer:**
- Ja, jetzt anlegen — Auf Bokmål, mit den Tekster-Varianten. Fehlende Texte kommen als offene Designfragen hinein.
- Später — Bleibt als offene Frage in der Spezifikation für L1.

**Svar:** Ja, jetzt anlegen

---

## 4. Tekst: ny fane (fra `fs-implementasjonsdetaljer`)

**Spørsmål:** Über den Fächern steht in der Skizze der Knopf «Åpne i nytt vindu». L1 sagt seit dem 21.10., dass das Vitnemål in einer neuen Fane (Tab) geöffnet wird. Welcher Text gilt?

**Alternativer:**
- «Åpne i ny fane» — Passt zur Anforderung. Die Skizze ist an dieser Stelle veraltet.
- «Åpne i nytt vindu» — Text aus der Skizze bleibt, obwohl ein Tab geöffnet wird.
- Nur Icon — Kein Text, nur das Icon wie beim Vitnemålsnummer, mit verstecktem Text für Screenreader.

**Svar:** «Åpne i ny fane»

---

## 5. Tekst: vitnemålene kan ikke hentes (fra `fs-implementasjonsdetaljer`)

**Spørsmål:** Welcher Text soll erscheinen, wenn die Vitnemål nicht aus NVB geholt werden können (Szenario «Vitnemålene kan ikke hentes»)? Er darf nicht so aussehen, als hätte der Bewerber keine Vitnemål.

**Alternativer:**
- Vorschlag übernehmen — «Vitnemålene kunne ikke hentes. Vi får ikke kontakt med Nasjonal vitnemålsdatabase (NVB). Prøv igjen senere.»
- Kurz — «Vitnemålene kunne ikke hentes. Prøv igjen senere.»
- Offen lassen — Als offene Designfrage in die design.md.

**Svar:** Kurz

---

## 6. Tekst: poengberegningen svarer ikke (fra `fs-implementasjonsdetaljer`)

**Spørsmål:** Welcher Text soll erscheinen, wenn die Punkteberechnung nicht antwortet und KAR, REA und SPR leer stehen (Szenario «Feilmelding når poengberegningen ikke svarer»)?

**Alternativer:**
- Kurz, passend zu NVB — «Poengene kunne ikke beregnes. Prøv igjen senere.»
- Mit Erklärung — «Poengene kunne ikke beregnes, og vises derfor ikke. Vitnemålene vises som vanlig. Prøv igjen senere.»
- Offen lassen — Als offene Designfrage in die design.md.

**Svar:** Kurz, passend zu NVB
