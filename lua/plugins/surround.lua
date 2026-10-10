-- Add, delete and change surrounding pairs: `ysiw)`, `ds"`, `cs'"`, and `S` in visual
-- mode. Needs no setup; `:help nvim-surround.usage` lists the rest.
vim.pack.add({
  { src = 'https://github.com/kylechui/nvim-surround', version = vim.version.range('4.x') },
})
