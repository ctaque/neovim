-- Branche master : compile les parsers avec le compilateur C, sans le CLI tree-sitter
-- (la branche main l'exige)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", "c", "css", "diff", "go", "html", "javascript", "json", "lua",
        "luadoc", "markdown", "markdown_inline", "python", "query", "regex",
        "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        -- Équivalent de expand-region (SPC v dans Spacemacs)
        keymaps = {
          init_selection = "<leader>v",
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "fonction" },
            ["if"] = { query = "@function.inner", desc = "intérieur de fonction" },
            ["ac"] = { query = "@class.outer", desc = "classe" },
            ["ic"] = { query = "@class.inner", desc = "intérieur de classe" },
            ["aa"] = { query = "@parameter.outer", desc = "argument" },
            ["ia"] = { query = "@parameter.inner", desc = "intérieur d'argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
      },
    })
  end,
}
