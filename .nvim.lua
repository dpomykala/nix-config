-- nixd completes packages from this flake's locked nixpkgs. Neovim starts nixd
-- in the project root, so `./.` is this repository.
vim.lsp.config("nixd", {
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }",
			},
		},
	},
})
