---
name: docs-audit
description: Audit the documentation under docs/ against the actual codebase for correctness, stale claims, missing coverage, missing rationale, consistency, and readability. Use for a full documentation audit, when the user asks to review, audit, fact-check, or verify the docs, suspects documentation drift (after refactors, renames, or dependency updates), or wants a periodic quality check. Not for small one-off doc edits.
argument-hint: "[focus]"
disable-model-invocation: true
---

# Docs audit

Documentation is a set of claims about the codebase. Audit it like a
fact-checker. Verify every claim against ground truth, cite evidence for every
finding, and never rewrite wording that you can't source.

Ground truth has an order. The codebase and its locked dependencies outrank git
history, and git history outranks the docs. When a doc and the code disagree,
decide for each case which side is wrong. The fix is not always in the docs.

The user invokes this skill explicitly as `/docs-audit [focus]`. An optional
focus narrows the scope or adds context.

## 1. Build context first

- Audit every file under `docs/`. List the files at the start of each audit,
  because the doc set changes over time.
- Map the repository: the tree, the entry points, and the build and wiring
  files.
- Read every audited doc completely, from start to end.
- Learn the role of each doc from its intro and structure. A role is a claim
  that you audit too. When this skill was written, the roles were:
  - `docs/architecture.md`: the ADR-style decision record. It is authoritative
    for *what* and *why*.
  - `docs/implementation-guide.md`: the operational companion, with mechanics
    and examples. It defers to the ADR.

  If the doc set no longer matches this list, report the mismatch and propose
  an update to this skill.
- Read the code behind the claims in the docs. Start with the entry points,
  then read the modules that the docs name.
- Check `git log` for recent structural changes. Refactor commit messages often
  contain the rationale that the docs lack, and they explain why the docs
  drifted.

## 2. Audit one check at a time

`references/checklist.md` defines eight checks. Read it first, then run the
checks in this order:

1. **Correctness.** Is each claim true?
2. **Codebase alignment.** Are any paths, names, examples, or file lists stale?
3. **Coverage.** Does everything important have a home in the docs, and does
   the summary match the body?
4. **Rationale.** Does every decision say why?
5. **Consistency.** Does each concept have one term and one style?
6. **Grammar and typos.** Proofread and run the mechanical sweeps.
7. **Readability.** Can a reader navigate the docs and follow every diagram and
   example?
8. **Other.** Report adjacent issues, such as code bugs that verification
   exposes, and repo hygiene.

For each check, investigate, report the findings, and wait for the user's
decision. Then apply the approved changes and start the next check. A report
for one check is small enough for the user to decide on every finding.

## 3. Evidence rules

- Verify, never trust. "Sounds right" is not evidence. Run a minimal repro for
  a claim about framework behavior, and read the upstream sources for tool
  semantics. `references/verification.md` lists techniques, including
  Nix-specific ones.
- Cite `file:line` or a commit in every finding.
- Treat doc examples as code. Diff every snippet against the real files,
  including identifiers, names, and magic values. Examples marked as
  illustrative must use dummy names, so that they can't go stale.
- Separate "correct in this repo" from "correct in general". Flag claims that
  are true here by accident but wrong in general.

## 4. Report format

Give each finding these parts:

- **Location**: the `file:line` of the claim.
- **Claim**: what the doc says, quoted.
- **Reality**: what is true, with evidence.
- **Severity**: one of the levels below.
- **Proposed action**: the exact text before and after, or the code change.

Use these severity levels:

- `incorrect`: the claim is false, or it leads the reader to a wrong action.
- `stale`: the claim was true once, but the code has changed since.
- `unsupported`: the claim or rule has no evidence or no rationale.
- `inconsistent`: two docs disagree, or the docs use two terms for one concept.
- `minor`: a typo, a style issue, or a formatting issue.

After the findings, list what you verified as clean. End the report with a
summary table of the findings.

A hypothetical finding:

```markdown
### F1. Example uses a renamed option

- **Location**: `docs/implementation-guide.md:120`
- **Claim**: "Set `programs.mise.enableMutableConfig = true`."
- **Reality**: The option is now `programs.mise.mutableSettings`
  (`modules/features/mise.nix:12`, renamed in commit `d091e6e`).
- **Severity**: `stale`
- **Proposed action**: Replace `enableMutableConfig` with `mutableSettings`.
```

When a fix needs a choice of wording or policy, such as which side is the
source of truth or how to phrase a rule, ask a targeted question instead of
guessing. Iterate on a contested rule until the user approves its exact
wording.

## 5. Apply approved changes exactly

- Edit only what the user approved. Verify the code that you touch: parse it,
  evaluate it, or type-check it.
- If a `technical-writing` skill is available, apply it to every sentence that
  you add or change.
- Don't commit unless the user asks.
- When the user asks for commits, split them by topic, for example docs and
  code. If the user wants a follow-up folded into an earlier commit, run:

  ```bash
  git commit --fixup <sha>
  GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>
  ```

## 6. Mandatory final re-audit

After all checks, re-read every modified doc from start to end. Run the
mechanical sweeps again, and check the cross-references and anchors again. An
edit to one rule can make two rules that agreed before contradict each other.
This happens every time, so the final pass is not optional. Report and fix its
findings the same way.

Ask whether to commit the changes only after this pass is complete and its
findings are resolved. Never ask earlier.
