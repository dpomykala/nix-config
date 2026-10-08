---
name: docs-audit
description: Audit the documentation under docs/ against the actual codebase for correctness, stale claims, missing coverage, missing rationale, consistency, and readability. Use for a full documentation audit — when the user asks to review, audit, fact-check, or verify the docs, suspects documentation drift (after refactors, renames, or dependency updates), or wants a periodic quality check. Not for small one-off doc edits.
disable-model-invocation: true
---

# Docs audit

Documentation is a set of claims about the codebase. Audit it like fact-checking:
verify every claim against ground truth, cite evidence for every finding, and
never rewrite wording you cannot source.

Ground truth: the codebase and its locked dependencies outrank git history,
which outranks the docs. When doc and code disagree, decide per case which side
is wrong — the fix is not always in the docs.

Invoked explicitly (`/docs-audit [optional focus]`); arguments narrow scope or
add context.

## 1. Build context first

- Scope: every file under `docs/` — determine the set dynamically, never
  hard-code file names.
- Map the repository: tree, entry points, build/wiring files.
- Read the audited docs completely, end to end.
- Know the doc set and its roles — the roles are themselves auditable claims:
  - `docs/architecture.md` — ADR-style decision record; authoritative for
    *what* and *why*.
  - `docs/implementation-guide.md` — operational companion: mechanics and
    examples; defers to the ADR.

  Derive each file's role from its intro and structure rather than trusting
  this list; if the doc set has changed, update this block and flag the
  mismatch during the audit.
- Read representative code behind the docs' claims: entry points first, then
  the modules the docs cite by name.
- Check `git log` for recent structural changes. Refactor commit messages often
  contain the rationale the docs are missing, and explain why docs drifted.

## 2. Run the eight checks

Read `references/checklist.md` first and work through it in order:

1. **Correctness** — is each claim true?
2. **Codebase alignment** — stale paths, names, examples, file lists?
3. **Coverage** — does everything important have a documented home?
4. **Rationale** — does every decision have a "because"?
5. **Consistency** — one term, one style per concept.
6. **Grammar and typos** — including mechanical sweeps.
7. **Readability** — navigation, diagrams, summary↔body mapping.
8. **Other** — adjacent issues (code bugs surfaced by verification, hygiene).

## 3. Evidence rules

- Verify, never trust. "Sounds right" is not evidence; run a minimal repro for
  framework behavior claims and read upstream sources for tool semantics
  (`references/verification.md` has techniques, including Nix-specific ones).
- Cite `file:line` (or commit) in every finding.
- Doc examples are code: diff every snippet against the real files, including
  identifiers, names, and magic values. Examples marked illustrative should use
  dummy names so they cannot go stale.
- Distinguish "correct in this repo" from "correct as a general statement" —
  flag claims that are accidentally true here but wrong in general.

## 4. Report before changing anything

For each finding: **location** — **claim** — **reality** (with evidence) —
**severity** (`incorrect/misleading`, `stale`, `unsupported`, `inconsistent`,
`minor`) — **proposed action** with exact before/after text. Also list what was
verified clean, and end with a summary table.

Work one check at a time with approval gates: present, wait for the user's
decision, then edit. When a fix involves wording or policy choices (e.g. which
side is source of truth, how to phrase a rule), ask a targeted question instead
of guessing, and iterate on contested rules until the exact wording is approved.

## 5. Apply approved changes exactly

- Edit only what was approved; verify touched code (parse/eval/type-check).
- Do not commit unless the user asks.
- When committing on request, keep commits logically split (docs vs code). If
  the user wants a follow-up folded into an earlier commit, use
  `git commit --fixup <sha>` followed by
  `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>`.

## 6. Mandatory final re-audit

After all fixes: re-read every modified doc end to end, re-run the mechanical
sweeps, and re-validate cross-references and anchors. Editing rules can make two
previously consistent rules contradict each other (this happens every time) —
the final pass is not optional. Report and fix its findings the same way.

Only after this pass is complete and its findings are resolved, ask whether the
changes should be committed — never earlier.
