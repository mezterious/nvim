# Working in this repo

A generic, IDE-style Neovim config (Neovim 0.12+, `vim.pack`, native LSP). These rules come
from how the owner wants it built. Follow them over defaults.

## Scope and decisions

- **Generic, not aimed at any language or project.** Languages are added one at a time.
  Nothing specific to one project goes in, including its debug or lint setup. Why: this is an
  editor config; project specifics belong in the project.
- **Analyse and report before adding a plugin or behaviour; the owner decides.** Compare the
  options, recommend one, ask. Don't assume. Why: most decisions here are taste, and reversing
  them costs the owner's review time.
- **Follow the documentation and say which source.** Use Neovim's `:help` and the plugin's own
  README or docs (the installed copy under `site/pack/core/opt`). Don't copy older configs or
  invent patterns, and prefer defaults. Why: the config is meant to be explainable from docs.

## Process

- **Verify before reporting.** Test with real key input (`nvim_input`), real servers and
  throwaway directories, not just by reading code. State plainly what failed or wasn't tested.
- **Never stage or commit.** Do one feature at a time, then stop for review. The owner commits.

## Structure

- `lua/config/` holds only keymaps, options and autocmds.
- One file per plugin in `lua/plugins/` (`vim.pack.add` plus its config); the load order is in
  `lua/plugins/init.lua`.
- Per-server overrides go in `after/lsp/<name>.lua`; per-filetype settings in `ftplugin/`.
- Tools (servers, formatters, debug adapters) are listed in the `tools` table in
  `lua/plugins/mason.lua`.
- Pin a plugin's version only where its docs show a pin. Never edit `nvim-pack-lock.json` by hand.
- Formatters and linters that have a project config run only when a project has it.

## Writing

- **Comments are short and say why, not what.** Verbose comments that add no value get removed.
- **Keep the README generic and stable:** no version numbers, per-tool behaviour or lists.
  Details live in code comments next to the code. Why: it should rarely need editing.
- **Lua follows `.stylua.toml`; `stylua --check lua init.lua ftplugin after` must pass.**
  Mason installs stylua; its binary is in `~/.local/share/nvim/mason/bin`, not on PATH.
