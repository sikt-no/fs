# Spørsmål og svar — `fs-specify` (2026-10-21)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Krav i spesifikasjonen

**Spørsmål:** Scope-raden for oppgaven tilbudsgaranti har bare @OPT-BEH-BEH-010 (gi_tilbudsgaranti.feature, @planned). Skal spesifikasjonen ha bare det kravet?

**Alternativer:**
- Bare BEH-010 (Recommended) — Som i scope-raden. Skjelettene i «(ikke tildelt)» er @draft og kan ikke være med.
- Flere krav — Skriv hvilke i «Annet».

**Svar:** Bare BEH-010 (Recommended)

---

## 2. Skisse uten Figma

**Spørsmål:** Skissen i scope-raden er Figma-rammen «Søknadsalternativ i saksbehandlingen» (node 9840-220112). Figma-MCP finnes ikke i denne økta, så jeg kan ikke hente og lagre den. Hva vil du?

**Alternativer:**
- Fortsett uten å hente (Recommended) — Skissen står med lenken. Valideringen blir «Uavklart», men avviket som er kjent (én nedtrekksmeny mot tre felt), står med.
- Stopp, legg til Figma først — Du legger til Figma-MCP med claude mcp add og logger inn, og så kjører vi skissesteget på nytt.

**Svar:** Fortsett uten å hente (Recommended)

**Fritekst:** Brukeren la deretter til Figma-MCP, og skissen ble hentet likevel.

---

## 3. Skisseavvik: Søknadsalternativ i saksbehandlingen

**Spørsmål:** Skissen «Søknadsalternativ i saksbehandlingen» viser tilbudsgaranti som én avkrysningsboks «Ja». Kravet BEH-010 (og fs-admin) har tre felt med tilbudsgaranti-typer, étt per rolle. Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, skissen er utdatert — Skissen merkes som utdatert i spesifikasjonen. Det åpne spørsmålet i scope-fila er da besvart: det holder at fs-specify noterer avviket.
- Skissen skal oppdateres — Kravet er riktig, men skissen må tegnes på nytt. Det står som åpent spørsmål i spesifikasjonen, til designeren.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravet er riktig, skissen er utdatert

---

## 4. Implementasjonsdetaljer

**Spørsmål:** BEH-010 har ingen implementasjonsdetaljer (gi_tilbudsgaranti.design.md). Skissen er utdatert, så tekstene må hentes fra kravet og fs-admin («Tilbudsgaranti fra behandler/tilbyder/forvalter», endringsloggen). Hva vil du?

**Alternativer:**
- Vent (Recommended) — Står under Åpne spørsmål i spesifikasjonen. Det meste er alt bygget i fs-admin, så det haster ikke.
- Kjør fs-implementasjonsdetaljer nå — Ut fra kravet og fs-admin, uten skisse. Jeg viser utkastet før det skrives.

**Svar:** Vent (Recommended)
