# Agent coordination layout

Multi-agent coordination per `docs/INGEST/Agent Coordination Spec.md` (in the `admissio-soknadsbehandling` repo, to be canonicalized here later). Originally specified for two agents; generalized to N via the agent registry below.

## Write discipline (load-bearing)

- An agent writes **only** under `agents/$AGENT_ID/`.
- The one exception is `agents/README.md` (this file), which agents append their own row to during onboarding. Append-only-yourself: never edit other agents' rows.
- Files in `tasks/` are **created**, never modified, by the agent that opens them. Filenames use the issue number (atomic from GitHub) so collisions are mechanically impossible.
- `shared/` changes go through PR, not direct push.

This is enforced by convention here, but mechanical guarantees come from the per-agent subtree split + atomic issue-number filenames. Don't break the discipline.

## Layout

```
agents/
  README.md           # this file — registry index
  <agent_id>/
    AGENT.md          # the agent's manifest (registry entry)
    memory.md         # append-only journal, this agent writes only
    analyses/         # one .md per topic, immutable from other agents' POV
    outbox/           # drafts/notes intended for another agent
  ...one directory per agent...
shared/
  glossary.md
  architecture.md
tasks/
  {issue-number}.md   # richer spec when issue body isn't enough
```

## Registered agents

The canonical registry is the union of `agents/*/AGENT.md` manifests. This table is a hand-maintained index of those manifests — refresh by reading the manifests if it looks stale.

| Agent ID | Display name | What it does | Status | Joined |
| --- | --- | --- | --- | --- |
| [frontend](frontend/AGENT.md) | Frontend agent | Owns the React/Next.js UI work in admissio-soknadsbehandling. | active | 2026-05-02 |

Onboarding adds a row here. Removal/retirement updates the `Status` column to `retired` rather than deleting the row, so the registry preserves history.

## Identity

Per machine, in `~/.config/agent-coord.env`:

```
AGENT_ID=<your agent id>            # any unique string in the registry
COORD_REPO=/abs/path/to/this/repo   # local clone path
COORD_REPO_URL=https://github.com/sikt-no/fs.git
```

No `OTHER_AGENT` — other agents are discovered at runtime by globbing `agents/*/AGENT.md`. The `agent-coord` skill reads the env file at start of turn; the `UserPromptSubmit` hook handles the per-turn `git pull`.

## Onboarding a new agent

The `agent-coord-setup` skill walks through it:

1. Pick a unique `AGENT_ID` (validated against the registry).
2. Provide a display name and one-line description.
3. Choose `COORD_REPO` path and working branch.
4. The skill writes `agents/<id>/AGENT.md`, appends a row to this README, commits, and pushes.

If you're onboarding by hand (no skill available), do the same five things in the same order.
