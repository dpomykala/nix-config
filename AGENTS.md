# AGENTS.md

This repository holds the nix-darwin and Home Manager configurations for several
macOS and Linux machines. It uses flake-parts and the dendritic pattern. Every
`.nix` file under `modules/` is a flake-parts module, and `import-tree` loads it
with no explicit import.

## Docs

The docs under `docs/` are the source of truth for the architecture and the code
patterns. Before you change code, read the doc sections that cover it.

- `docs/architecture.md` is the architecture decision record (ADR). It records
  what the repository does and why. Its summary links each rule to its section.
- `docs/implementation-guide.md` shows the mechanics and examples behind the
  ADR. If the two docs disagree, the ADR wins.

`README.md` is stale. Its setup paths, such as `home/hosts`, predate the
dendritic layout. Don't use it as a source for the structure.

## Rules that are easy to break

The ADR defines these rules. Check every change against them, because a
violation can merge a module twice or fail evaluation far from the change.

- A feature never imports another feature. Profiles, hosts, and homes compose
  shared dependencies once. See ADR §3.
- A home imports exactly one platform profile. Feature bundles such as
  `development` don't import `base`. See ADR §3.
- Only the provider feature imports an external input module, such as
  `inputs.sops-nix.homeManagerModules.sops`. See ADR §3.
- A feature that needs a tool sets `enable = lib.mkDefault true` for it. A
  feature with an optional dependency uses `lib.mkIf` with a fallback. See ADR
  §3.
- Every host module sets `_module.args.system`. See ADR §3.
- Prefer a separate module for each platform over `isDarwin` or `isLinux`
  conditionals. See ADR §4.
- Put each file in the directory for its layer, and name it after the module it
  defines. See ADR §1 and §9.

## Nix practices

- Copy the patterns of the nearest similar module. For example, `darwin`
  features install macOS GUI apps as Homebrew casks, as in
  `modules/features/slack.nix`.
- Check option names against the pinned inputs, not against memory. nixpkgs,
  Home Manager, and nix-darwin rename options often. To read the current
  definition of an option, evaluate it through a configuration:

  ```bash
  nix eval '.#homeConfigurations."dp@vm-ubuntu".options.programs.mise.globalConfig.description'
  nix eval --json .#darwinConfigurations.mbp-private.options.homebrew.casks.declarationPositions
  ```

- Treat a deprecation warning during evaluation as a bug to fix. It usually
  marks a renamed option.
- Use `lib.mkIf` and `lib.mkMerge` for conditional configuration. An `if`
  expression on a `config` value around a whole module body causes infinite
  recursion.
- Add a comment that says why next to every `lib.mkForce`.
- Use `with pkgs;` only around a package list, as the existing modules do. Never
  put `with` at module scope.
- Remove unused module arguments. Write `_:` for a module function that takes no
  arguments.
- For a new flake input, set `inputs.nixpkgs.follows = "nixpkgs"` when the input
  takes nixpkgs, and `flake = false` when the input is not a flake.
- Never read a decrypted secret at evaluation time, because the value then lands
  in the world-readable Nix store. Reference secrets through the paths in
  `config.sops.secrets` and `config.sops.templates`.

## Verify changes

Run `just --list` to see the recipes in the `justfile`. If a tool such as
`just` or `nh` is missing, run the command inside `nix develop`.

1. Stage new files with `git add`. A flake sees only files that git tracks, so
   evaluation skips an untracked module with no error.
2. Run `just fmt`. It formats the `justfile` and runs `nix fmt`.
3. Evaluate every configuration that the change can reach.
   `modules/flake/configurations.nix` lists them. A Linux home also evaluates on
   macOS.

   ```bash
   nix eval --raw .#darwinConfigurations.<host>.system.drvPath
   nix eval --raw '.#homeConfigurations."<user>@<host>".activationPackage.drvPath'
   ```

Ask the user before you run a command with `sudo`, `just darwin`, `just home`,
`just update`, or `just iupdate`. These commands change the running system or
commit to the repository.

## Secrets

- Never decrypt, print, or log a secret, and never write one in plaintext to a
  file.
- Ask the user to create or edit encrypted files with `sops`.
- Put each secret file where ADR §8 and the path rules in `.sops.yaml` say.

## Keep the code and the docs in sync

1. If a change contradicts the docs, stop before you make it. Tell the user
   which rule the change breaks, with the doc section, and why the change needs
   it. Make the change only after the user approves it.
2. After the user approves a change that contradicts the docs, ask whether to
   update the docs to match it.
3. If a change makes a doc claim stale, such as a path, a file list, a module
   name, or an example, propose the doc edit. Edit the docs only after the user
   agrees.
4. To edit a rule, change the ADR first and the guide after it. Keep the ADR
   summary in line with the ADR body.
5. To check all the docs against the code, use the `docs-audit` skill in
   `.agents/skills/docs-audit/`.

## Maintain this file

If a change makes a statement in this file wrong or incomplete, propose an
update and ask before you edit the file. Keep the file short. Point to the docs
instead of copying them.

Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists. If
Claude-specific rules become necessary, create a `CLAUDE.md` that imports this
file with `@AGENTS.md`.

Shared skills live in `.agents/skills/`. Each skill has a symlink in
`.claude/skills/` that points to its directory. Add a new skill the same way.

## Writing style

- Write a code comment only to explain a non-obvious why or to warn about a
  trap. Match the comment style of the file.
- Wrap comments and Markdown prose at 80 characters, and fill each line up to
  the limit.
- If the `technical-writing` and `unslop` skills are available, apply them to
  the docs. Otherwise, match the existing docs: plain words, active voice,
  present tense, sentence-case headings, and one term for each concept.
- In `AGENTS.md`, `CLAUDE.md`, and skill files, skip these `technical-writing`
  rules: the Diátaxis mode choice, headings that carry the point, a sentence
  before each list, the rhythm rules, and the rewording of examples. Keep the
  `description:` frontmatter of a skill in the style that triggers the skill.
- Don't use em dashes or en dashes in docs, comments, or commit messages.

## Commits

- Commit only when the user asks.
- Write the subject in the imperative mood and sentence case, with no trailing
  period. Put code names in backticks, for example "Rename
  `programs.mise.enableMutableConfig` to `mutableSettings`".
- Keep one topic in each commit.
- Don't add AI attribution trailers such as `Co-Authored-By`.
