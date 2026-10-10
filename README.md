# nvim

A general-purpose, IDE-style Neovim configuration built from scratch: no distribution,
Neovim's native plugin manager (`vim.pack`) and native LSP client, and plugin defaults wherever
possible. Targets Neovim 0.12+; developed on macOS.

## Requirements

- **Neovim 0.12+**
- `git`, `curl`, `tar`, `unzip` and `gzip`
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
  (from your package manager, **not npm**) and a C compiler, to build tree-sitter parsers
- [`fzf`](https://github.com/junegunn/fzf) and [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  (used for finding and replacing); `fd` is recommended
- The toolchains the tools in [`lua/plugins/mason.lua`](lua/plugins/mason.lua) are built or run
  with (Node.js, Go and so on)
- A [Nerd Font](https://www.nerdfonts.com/) for icons

`:checkhealth` reports anything missing, with the versions each plugin needs.

## Install

Back up any existing `~/.config/nvim`, then:

```sh
git clone git@github.com:mezterious/nvim.git ~/.config/nvim
nvim
```

The first launch installs the plugins, the Mason tools and the tree-sitter parsers in the
background. Let it finish and restart Neovim.

To try it without touching an existing config, clone to `~/.config/nvim-test` and start it with
`NVIM_APPNAME=nvim-test nvim`.

## Layout

```
init.lua              load order
lua/config/           keymaps, options and autocmds
lua/plugins/          one file per plugin (vim.pack.add + its config); init.lua sets the order
after/lsp/            per-server overrides on top of nvim-lspconfig's defaults
ftplugin/             per-filetype settings
nvim-pack-lock.json   plugin versions (vim.pack's lockfile)
```

## Where to look

- **Keymaps:** the core ones are in [`lua/config/keymaps.lua`](lua/config/keymaps.lua); each
  plugin's own keys are in its file. In Neovim, press `<leader>` (Space) and which-key lists what's
  available.
- **Languages:** added one at a time. The Mason `tools` table in
  [`lua/plugins/mason.lua`](lua/plugins/mason.lua) lists what gets installed; the rest of each
  language's setup is in the plugin files and `after/lsp/` it points to.
- **Why something behaves as it does:** comments sit next to the code they explain, including
  which formatters and linters only run when a project has its own config.

Project-specific debug configurations belong in that project's `.vscode/launch.json`, which is
read automatically. The ones in [`lua/plugins/dap.lua`](lua/plugins/dap.lua) are only defaults.

## Changing it

- **Add a tool** (language server, formatter or debug adapter): add it to the matching list in
  `lua/plugins/mason.lua`, then wire it up in the file for that concern.
- **Add a tree-sitter language:** add the parser in `lua/plugins/treesitter.lua` and a file in
  `ftplugin/` (copy an existing one).
- **Add a plugin:** create `lua/plugins/<name>.lua` with its `vim.pack.add` and setup, then
  require it in `lua/plugins/init.lua`.
- **Update plugins:** run `:lua vim.pack.update()`. The lockfile pins plugins only, not Mason
  tools or parsers.
