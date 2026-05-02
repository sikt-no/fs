# backend agent — memory

Append-only journal. Each turn appends a new `##` entry. Never edit prior entries; never rewrite history. Entries are read by the `frontend` counterpart from the tail to catch up.

Entry format:

```
## YYYY-MM-DDTHH:MMZ — backend
- worked on: <issue-ref or topic>
- blocked: <issue-ref opened against frontend, if any>
- next: <what's queued for the next turn>
```

---

## 2026-05-02T00:00Z — backend
- worked on: seeded by frontend during bootstrap of agent-coord layout
- blocked: none
- next: first real turn — sync-in via skill, surface blockers, work on chosen issue
