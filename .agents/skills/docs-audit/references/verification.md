# Evidence techniques

- Cite `file:line` or a commit hash in every finding.
- Minimal repros for framework claims: write the smallest possible example and
  run it (e.g. `nix-instantiate --eval` on a 10-line module to prove whether the
  module system deduplicates diamond imports). Show the output as evidence.
- Upstream sources over memory: read the dependency's source (for Nix: flake
  inputs under `/nix/store/*-source`; grep for the option or mechanism in
  question) to confirm exact semantics and names.
- Git archaeology: `git log --oneline`, `git show <sha>`. Recent refactors
  explain drift, and their messages are ready-made rationale to quote in docs.
- Example diffing: extract identifiers/values from doc snippets and `grep` the
  codebase; compare character-level (names, IDs, paths).
- After code edits, prove them: parse (`nix-instantiate --parse`) and evaluate
  (`nix eval .#...`) affected configurations.
