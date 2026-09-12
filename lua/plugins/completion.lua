-- Completion. blink.cmp sources suggestions from whatever's active in a
-- buffer -- LSP clients (lsp.lua), the buffer's own words, file paths, and
-- snippets -- and needs no per-buffer wiring: it attaches globally once
-- setup() runs.
--
-- v1.x is the current stable line. v2 (the default branch) is explicitly
-- marked "under active development with many breaking changes" and adds an
-- external dependency (blink.lib) outside vim.pack's reach, so this pins to
-- the latest 1.x release *tag* rather than tracking a branch -- being on an
-- actual tag is also what makes blink download its prebuilt fuzzy-matcher
-- binary instead of requiring a Rust toolchain to build one.
vim.pack.add({
  {
    src = 'https://github.com/Saghen/blink.cmp',
    version = vim.version.range('1.0'),
  },
  -- Snippet data only (JSON, no runtime logic) for blink's snippet source,
  -- which loads it automatically via Neovim's native vim.snippet engine.
  'https://github.com/rafamadriz/friendly-snippets',
})

require('blink.cmp').setup({
  -- 'default': arrows / <C-n> / <C-p> to move, <C-y> to accept, <C-space>
  -- to open/expand docs -- closest to Neovim's own built-in ins-completion
  -- keys (unlike the 'super-tab' preset), so existing muscle memory holds.
  keymap = { preset = 'default' },
  completion = {
    documentation = { auto_show = true },
  },
  -- Left off: Neovim already maps <C-s> (insert mode) to native LSP
  -- signature help by default (see `:h lsp-defaults`) -- blink's own
  -- signature module is redundant with that and still experimental.
})

-- The one place completion needs to reach into LSP: tell every server
-- (every lsp/*.lua config) that the client supports more than Neovim's
-- default capabilities, so e.g. servers know completion snippets are
-- understood. vim.lsp.config('*', ...) merges into all of them, so this
-- doesn't need touching each lsp/<name>.lua file individually.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})
