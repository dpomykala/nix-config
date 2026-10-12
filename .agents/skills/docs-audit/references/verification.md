# Evidence techniques

- Prove framework claims with minimal repros. Write the smallest possible
  example, run it, and show the output as evidence. For example, run
  `nix-instantiate --eval` on a 10-line module to prove whether the module
  system deduplicates diamond imports.
- Prefer upstream sources over memory. Read the source of the dependency to
  confirm exact semantics and names. For Nix, the flake inputs are under
  `/nix/store/*-source`. Grep them for the option or mechanism in question.
- Use git archaeology: `git log --oneline` and `git show <sha>`. Recent
  refactors explain drift, and their commit messages are rationale that you can
  quote in the docs.
- Diff examples against the code. Extract the identifiers and values from doc
  snippets, `grep` the codebase for them, and compare names, IDs, and paths
  character by character.
- Prove code edits. Parse the changed files with `nix-instantiate --parse`, and
  evaluate the affected configurations with `nix eval .#...`.
