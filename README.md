# nvim

A general-purpose, IDE-style Neovim configuration built from scratch: no distribution,
Neovim's native plugin manager (`vim.pack`) and native LSP client, and plugin defaults wherever
possible. Built and tested on Neovim 0.12.5 (macOS).

## Requirements

- **Neovim 0.12+** (`vim.pack`, and nvim-treesitter's `main` branch require it)
- `git`, `curl`, `tar`, `unzip`, `gzip` (Mason, nvim-treesitter, and the downloads blink.cmp and
  codediff make on first use)
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
  0.26.1+ (from your package manager, **not npm**) and a C compiler, to build tree-sitter parsers
- **Node.js**: the language servers, formatters and debug adapter set up in
  [`lua/plugins/mason.lua`](lua/plugins/mason.lua) run on it. Debugging `.ts` files directly needs
  Node 22.18+ or 23.6+
- [`fzf`](https://github.com/junegunn/fzf) (newer than 0.36) for the fuzzy finder; `ripgrep` and
  `fd` are recommended by fzf-lua
- A [Nerd Font](https://www.nerdfonts.com/) for icons

## Install

Back up any existing `~/.config/nvim`, then:

```sh
git clone git@github.com:mezterious/nvim.git ~/.config/nvim
nvim
```

The first launch installs the plugins, the Mason tools and the tree-sitter parsers in the
background. Let it finish and restart Neovim. `:checkhealth` shows anything missing.

To try it without touching an existing config, clone to `~/.config/nvim-test` and start it with
`NVIM_APPNAME=nvim-test nvim`.

## Layout

```
init.lua              load order: keymaps, options, autocmds, plugins
lua/config/           core settings: the leader key, keymaps, options and similar
lua/plugins/          one file per plugin (vim.pack.add + its config); init.lua sets the order
after/lsp/            per-server overrides on top of nvim-lspconfig's defaults
ftplugin/             one file per filetype, starts tree-sitter highlighting
nvim-pack-lock.json   exact plugin versions (vim.pack's lockfile)
```

## Where to look

- **Plugins:** one file each in [`lua/plugins/`](lua/plugins/); the load order is in
  [`lua/plugins/init.lua`](lua/plugins/init.lua).
- **Keymaps:** the core ones are in [`lua/config/keymaps.lua`](lua/config/keymaps.lua); each
  plugin's own keys are in its file. In Neovim, press `<leader>` (Space) and which-key lists what's
  available; `<leader>?` shows the keys for the current buffer.
- **Languages:** added one at a time. Servers, formatters and debug adapters installed by Mason
  are the `tools` table in [`lua/plugins/mason.lua`](lua/plugins/mason.lua); what gets formatted
  is in [`lua/plugins/formatting.lua`](lua/plugins/formatting.lua), debug configurations in
  [`lua/plugins/dap.lua`](lua/plugins/dap.lua), tree-sitter parsers in
  [`lua/plugins/treesitter.lua`](lua/plugins/treesitter.lua), and per-server overrides in
  [`after/lsp/`](after/lsp/).

## Behaviours worth knowing

- **Formatting runs on save, but only in projects with a prettier config** (`.prettierrc*`,
  `prettier.config.*` or a `prettier` key in `package.json`). A lone `.editorconfig` doesn't
  count, though prettier honours it once it does run.
- **oxlint runs only in projects with an oxlint config**, for the same reason.
- Renaming or moving a file in the explorer updates imports through the language server and saves
  the files that changed.
- `.vscode/launch.json` is read automatically when you start a debug session.

## Changing it

- **Add a language server:** add its nvim-lspconfig name to `tools.servers` in
  `lua/plugins/mason.lua`. It is installed and enabled. Overrides go in `after/lsp/<name>.lua`.
- **Add a formatter:** add it to `tools.formatters` in `mason.lua` and to `formatters_by_ft` in
  `lua/plugins/formatting.lua`.
- **Add a tree-sitter language:** add the parser to `lua/plugins/treesitter.lua` and create
  `ftplugin/<filetype>.lua` containing `pcall(vim.treesitter.start)`.
- **Add a plugin:** create `lua/plugins/<name>.lua` with its `vim.pack.add` and setup, then
  require it in `lua/plugins/init.lua`.
- **Update plugins:** run `:lua vim.pack.update()`. The lockfile records what is installed.

Lua is formatted with [stylua](https://github.com/JohnnyMorganz/StyLua) (`.stylua.toml`).
