---
name: beads
description: Use when working with the `bd` (beads) issue tracker — listing open/ready work, creating issues and epics, managing dependencies, or updating issue state. Beads is a lightweight, dependency-aware issue tracker stored in a `.beads/` directory. Triggers include "what beads are left", "create a bead", "what's ready to work on", "close that issue", or any `bd` CLI usage.
---

# Beads (`bd`) Issue Tracker

`bd` is a lightweight issue tracker where issues ("beads") chain together with
first-class dependency support. State lives in a `.beads/` directory at the repo
root (JSONL export + an embedded Dolt DB). The CLI is `bd`, installed at
`~/.local/bin/bd`.

## Detecting a beads project

A repo uses beads if it has a `.beads/` directory. Key files:
- `.beads/issues.jsonl` — exported issues (human-readable, git-tracked)
- `.beads/interactions.jsonl` — interaction log
- `.beads/config.yaml` — config

`bd` auto-discovers the DB; you rarely need `--db`.

## Core read commands

```bash
bd ready                 # open issues with NO active blockers — the real "what can I work on"
bd list --status open    # all open issues (includes blocked ones)
bd list                  # all issues
bd show <id>             # full detail for one issue (e.g. bd show uarch-432)
bd status                # database overview / statistics
bd count <filters>       # count matching issues
bd search <text>         # text search
bd query '<expr>'        # query language
bd graph                 # dependency graph
```

`bd ready` is the right answer to "what's left to work on" / "what should I do
next" — it filters out blocked, in-progress, and deferred issues. `bd list
--status open` is broader and includes blocked work.

Add `--json` to any command for machine-readable output.

## Issue IDs

IDs are `<prefix>-<slug>`, e.g. `uarch-432`. The prefix is per-project. Epics are
issues with type `epic` and have children shown as a tree in `bd list`.

## Creating & editing

```bash
bd create -t "Title" -p 1                 # create (priority P1)
bd q "Quick title"                        # quick capture, prints only the new ID
bd update <id> --status in_progress       # update fields
bd close <id>                             # close
bd reopen <id>                            # reopen
bd priority <id> 2                        # set priority
bd note <id> "text"                       # append a note
bd comment <id> "text"                    # add a comment
bd assign <id> <who>
```

## Dependencies & structure

```bash
bd link <a> <b>          # link two issues with a dependency
bd dep ...               # manage dependencies
bd children <id>         # list child beads of a parent (epic)
bd epic ...              # epic management
bd graph                 # render dependency graph
```

Dependency-awareness is the point of beads: `bd ready` only surfaces work whose
blockers are resolved.

## Workflow conventions

- When the user asks "what's left", lead with `bd ready`, then optionally show the
  fuller `bd list --status open` if they want blocked items too.
- When starting work on an issue, set it in progress: `bd update <id> --status in_progress`.
- When done, `bd close <id>`.
- Issue changes are written to the Dolt DB; the `.beads/*.jsonl` files are the
  git-tracked export. After mutating, `bd export` may be needed to refresh JSONL
  (check the project's existing pattern before committing).

## Status legend

`○ open  ◐ in_progress  ● blocked  ✓ closed  ❄ deferred`

## Notes / TODO for this skill

This skill was scaffolded quickly — extend it as we learn the project's actual
conventions:
- [ ] Confirm the export/commit flow (does mutating auto-update `issues.jsonl`?)
- [ ] Document the priority scheme used in practice (P1/P2/P3 meaning)
- [ ] Capture any project-specific issue templates / required fields (`bd lint`)
- [ ] Note swarm/molecule (`bd swarm`, `bd mol`) usage if/when adopted
