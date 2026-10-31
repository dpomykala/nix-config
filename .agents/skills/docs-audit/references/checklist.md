# Docs audit checklist

## 1. Correctness

Verify every factual claim against ground truth: mechanism semantics, tool
behavior, option names, priority and merging rules, and file formats. For a
framework claim, build a minimal repro and run it. For upstream behavior, read
the upstream source. The locked dependency sources are authoritative. Watch for
claims that are too broad, such as an "always" or "never" statement that holds
for only one variant of a mechanism. For example, modules keyed by path and
anonymous modules deduplicate differently.

## 2. Codebase alignment

Check the docs against the code:

- Paths and file lists: are they complete?
- Option and attribute names: were any renamed?
- Example code: does it match the real code exactly?
- Config layouts: do the directories and files exist?
- Names in prose: do they match the identifiers in code?

Separate the current state from an intended state. Docs can prescribe a target
layout, but then they must say that it is a target.

## 3. Coverage

Scan from the code to the docs. Significant decisions, constraints, and
conventions in the codebase need a home in the docs, with rationale. Examples
are special wiring, invariants that the code enforces, and gotchas that only
code comments mention. Check the mapping between the summary and the body in
both directions. Every summary rule has a body section and points to it. Every
body rule worth summarizing appears in the summary.

## 4. Rationale

Every decision needs a "because", and every prohibition needs the concrete
failure that it prevents. Flag bare assertions ("X should not be Y.") and
one-sided rules ("prefer A over B" with no reason). Strong rationale names a
breakage that the reader can observe, such as an error message or duplicated
values, not just "it's cleaner".

## 5. Consistency

Check that the docs use:

- One name for each concept. Watch abbreviations, for example "ADR", "ARD", and
  file names.
- One arrow style, either → or ->.
- One heading-case convention.
- One term for each core concept, for example "the canonical package set", not
  four variants.

Check that all docs state shared rules in the same terms. Where the doc set has
drifted, adopt an explicit small convention and apply it everywhere. For
example, write "for example", not "e.g.", and end the sentence before an
example block with "for example:".

## 6. Grammar and typos

Proofread, then run mechanical sweeps. Grep for leftovers of renamed things,
such as old terms, old option names, and old identifiers. Also grep for Latin
abbreviations such as "e.g." and "i.e.", for mixed arrow styles, and for
misspellings. Check Markdown integrity: tables are uniform, TOC anchors match
heading slugs, and numbered cross-references point at the right sections.

## 7. Readability

Check that:

- A TOC and cross-links connect the documents.
- Every diagram and every piece of terse notation has a plain-language caption.
- Examples don't need decoding.

## 8. Other

Report adjacent issues that verification exposes, such as latent code bugs that
the docs contradict, or deprecation warnings from evaluation. Also check repo
hygiene and consistency with neighboring docs, such as the README and code
comments that the docs quote. Docs and examples must contain no credentials,
key material, or private values. Use placeholders instead.

## Anti-patterns to hunt for

- **Location-vs-invariant confusion.** A rule mandates _where_ something lives
  when the real constraint is _how often_. For example, "import once in a
  profile" states a location, and "each module enters the tree exactly once"
  states the invariant. Ask what the rule actually constrains.
- **Stale examples.** Snippets use pre-refactor APIs. They read like real code
  but aren't.
- **Rules outgrown by the system.** Wording worked until a new case appeared.
  For example, "single import" breaks when a wrapper takes two inputs. Check
  each rule against edge cases.
- **Fix-induced contradictions.** A reworded rule now contradicts another rule.
  Always check pairs of rules again after edits, as the final re-audit in
  `SKILL.md` requires.
- **Unsupported decisions.** An architecture rule has no stated trade-off.
