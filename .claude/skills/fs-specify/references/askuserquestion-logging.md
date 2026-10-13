# `AskUserQuestion`-logging — `questions-<skill>-<date>.md`

Definition of the questions-file convention used by `fs-specify` and `fs-specify-delta` to log their `AskUserQuestion` calls.

Every `AskUserQuestion` call the skill makes during a run is appended to a per-run questions file in `<spec>/` (`tasks/<domene>/<slug>/spec/`), so the next contributor on the task has a complete decision trail without digging through transcripts. The deliverable (`spec-*.md`, `spec-changes-*.md`) carries the agreed outcome; the questions file is the session log behind it.

**File naming.** One file per skill run:

```
<spec>/questions-<skill>-<YYYY-MM-DD>.md
```

`<skill>` is the bare skill name (`fs-specify` or `fs-specify-delta`); `<YYYY-MM-DD>` is today's date from the conversation's `# currentDate`. If a file with that exact name already exists when the skill starts (a second run the same day), append `-2`, `-3`, … to the filename so the new run never overwrites an earlier one.

The filename is **resolved once per run** — right after the skill's `started`-entry is written to `spec.log.md` — and reused for every `AskUserQuestion` block in that run. The file itself is created **lazily** by the first call; if the skill never asks a question, no file is written.

**File format.** A short header followed by one numbered block per `AskUserQuestion` call, in the order they were asked:

```markdown
# Spørsmål og svar — `fs-specify` (2026-06-16)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. <kort tittel, gjerne et utdrag av spørsmålet>

**Spørsmål:** <hele `question`-teksten>

**Alternativer:**
- <label 1> — <description>
- <label 2> — <description>
- <label 3> — <description>

**Svar:** <det valgte alternativet, ordrett som vist til brukeren>

**Fritekst:** <`Other`-svaret hvis brukeren skrev sin egen — utelat hele linjen hvis ikke>

---

## 2. <neste spørsmål>
...
```

For `multiSelect: true`-spørsmål: list alle valgte labels i `**Svar:**`, én per linje med bindestrek-prefiks.

**How to write entries.** Same Read → append → Write pattern as `spec.log.md` (see `fs-specify/SKILL.md` → _Logg kjøringen_): use only Claude's Read + Write tools — no `bash`, `printf`, `date`, `>>`, `[ -f ]`, or any other POSIX-shell construct. The procedure must work on macOS, Linux, and Windows hosts equally.

**What to log.** Every `AskUserQuestion` call the skill makes during the run — clarifications, source-pickers, "walk through open questions?" prompts, the lot. The goal is full traceability; do not pre-filter "trivial" questions. If the skill calls `AskUserQuestion` only conditionally (the common case), the file may end up empty-of-blocks for runs that took the no-question path — and that's fine, just don't create the file.
