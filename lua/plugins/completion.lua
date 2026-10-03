-- Completion popup. Stays on V1: the default branch is V2, which is still
-- breaking, and a release tag is also what downloads the prebuilt fuzzy matcher.
-- The plugin registers its LSP capabilities itself (plugin/blink-cmp.lua).
vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
})

-- Defaults: <C-space> opens, <C-n>/<C-p> select, <C-y> accepts, <C-e> hides.
require('blink.cmp').setup({})
