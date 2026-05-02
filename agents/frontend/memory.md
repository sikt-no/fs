# frontend agent — memory

Append-only journal. Each turn appends a new `##` entry. Never edit prior entries; never rewrite history. Entries are read by the `backend` counterpart from the tail to catch up.

Entry format:

```
## YYYY-MM-DDTHH:MMZ — frontend
- worked on: <issue-ref or topic>
- blocked: <issue-ref opened against backend, if any>
- next: <what's queued for the next turn>
```

---

## 2026-05-02T00:00Z — frontend
- worked on: bootstrap of agent-coord layout per docs/INGEST/Agent Coordination Spec.md
- blocked: none
- next: first real turn — sync-in via skill, surface blockers, work on chosen issue
