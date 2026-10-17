return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        layout_strategy = "bottom_pane",
        layout_config = { height = 0.4 },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "^.git/" },
        mappings = {
          -- Navigation façon Helm/Ivy
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
