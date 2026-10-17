-- minionvim : configuration Neovim inspirée de Spacemacs
-- Leader = <Space>, leader "major mode" = ","

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("minionvim.options")
require("minionvim.lazy")
require("minionvim.keymaps")
require("minionvim.autocmds")
