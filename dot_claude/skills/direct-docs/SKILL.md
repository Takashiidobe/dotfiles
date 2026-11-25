---
name: direct-docs
description: Write or edit READMEs and maintainer docs so they are short, task-oriented, and direct. Use when creating or revising documentation for any project.
---

# Direct Docs

Say what it is, how to use it, and what to do when it breaks. Nothing else.

- **Open with one or two sentences:** what the project does and what it produces.
- **Show the smallest working use first:** an install line and a minimal example or command, before any reference.
- **One topic per section, one idea per paragraph.** Sections follow what the reader wants to do, not how the code is organized. No paragraph longer than about four sentences.
- **Plain prose in second person.** Write commands, flags, settings, and paths exactly as they appear in the project.
- **Bullets for lists, paragraphs for everything else.** Use bullets when the items are parallel and independent: features, supported or unsupported items, options, steps, requirements. Use short paragraphs for explanation, rules that depend on each other, and anything with cause and effect. Don't split connected sentences into bullets, and don't write a list as a paragraph.
- **Document behavior, not mechanism.** Leave out internals, storage locations, and implementation choices unless the reader must act on them.
- **Cover the common path.** Mention edge cases, limits, and version requirements only when hitting them breaks the reader's task.
- **Give steps only where a mistake is costly or the path is hard to guess** (credentials, permissions, platform setup): where to go, what to pick, where to put the result. Everything else is one sentence.
- **Say when a step is optional or required, and under what condition.**
- **Link instead of restating** what the code, `--help`, generated API docs, or another doc already says.
- **Keep volatile facts out of prose:** version numbers, counts, support matrices.
- **Separate audiences.** User docs in the README; build, release, and contributor steps in their own file, linked once.
- **Skip intros, recaps, history, TODOs, hedging, and justification.**
- **List options as name, one-line effect, default.**
- **Check each sentence:** would the reader act differently without it? If not, cut it.
- **After editing, wrap at 80 columns:** `prettier --prose-wrap always --print-width 80 --write <file>`.
