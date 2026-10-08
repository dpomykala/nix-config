# Docs audit checklist

## 1. Correctness

Verify every factual claim against ground truth: mechanism semantics, tool
behavior, option names, priority/merging rules, file formats. For framework
claims, build a minimal repro and run it. For upstream behavior, read the
upstream source (locked dependency sources are authoritative). Watch for
over-broad claims: "always/never" statements that hold only for one variant of
a mechanism (e.g. path-keyed vs anonymous modules deduplicate differently).

## 2. Codebase alignment

Cross-check the docs against reality: paths and file lists (complete?), option
and attribute names (renamed?), example code (matches real code verbatim?),
config layouts (do the directories/files exist?), naming used in prose (matches
the identifiers in code?). Distinguish current state from intended state — docs
may prescribe a target layout, but then they must say so.

## 3. Coverage

Scan the code → doc direction: significant decisions, constraints, and
conventions visible in the codebase (special wiring, invariants enforced in
code, non-obvious gotchas documented only in comments) deserve a documented
home with rationale. Check summary↔body mapping in both directions: every
summary (TL;DR) rule has a body section and points to it; every body rule worth
summarizing appears in the summary.

## 4. Rationale

Every decision needs a "because"; every prohibition needs the concrete failure
mode it prevents. Flag bare assertions ("X should not be Y.") and one-sided
rules ("prefer A over B" without why). Strong rationale names the observable
breakage (error messages, duplicated values), not just "it's cleaner".

## 5. Consistency

One name per concept (watch abbreviations, e.g. "ADR" vs "ARD" vs file names),
one symbol style (→ vs ->), one heading-case convention, one term for core
concepts ("the canonical package set", not 4 variants). Check that all docs
state shared rules in identical terms. Adopt explicit micro-conventions where
the doc set has drifted (e.g. "e.g." for inline parentheticals, "such as:"
before example blocks).

## 6. Grammar and typos

Proofread, then run mechanical sweeps: grep for leftovers of renamed things
(old terms, old option names, old identifiers), "e.g.:"/"i.e.:" misuse, mixed
arrow styles, spelling. Validate markdown integrity: tables uniform, TOC
anchors match heading slugs, numbered cross-references point at the right
sections.

## 7. Readability

TOC and cross-links between documents; every summary rule (TL;DR) has a body
home and points to it; diagrams and terse notation carry a plain-language
caption; examples don't need decoding.

## 8. Other

Adjacent issues discovered during verification (latent code bugs the docs
contradict, deprecation warnings surfaced by eval), repo hygiene, and
consistency with neighboring docs (README, code comments quoted by the docs).
No credentials, key material, or private values in docs or examples (use
placeholders).

## Anti-patterns to hunt for

- **Location-vs-invariant confusion**: a rule mandating *where* something lives
  when the real constraint is *how often* (e.g. "import once in a profile" vs
  "each module enters the tree exactly once"). Ask: what is actually
  constrained?
- **Stale examples**: snippets using pre-refactor APIs (they read like real
  code but aren't).
- **Rules outgrown by the system**: wording that worked until a new case
  appeared ("single import" breaks when a wrapper takes two inputs). Check each
  rule against edge cases.
- **Fix-induced contradictions**: reworded rules that now contradict another
  rule. Always re-check rule pairs after edits (see the final re-audit).
- **Unsupported decisions**: architecture rules with no stated trade-off.
