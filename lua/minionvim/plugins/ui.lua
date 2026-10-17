return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = false,
        component_separators = "|",
        section_separators = { left = "", right = "" },
      },
      sections = {
        -- Numéro de fenêtre à gauche, comme la modeline Spacemacs (cf. SPC 1..9)
        lualine_a = { function() return vim.api.nvim_win_get_number(0) end, "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "lsp_status", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = { function() return vim.api.nvim_win_get_number(0) end },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      },
    },
  },

  -- Onglets des buffers ouverts (S-h / S-l pour naviguer, cf. keymaps.lua)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        -- Fermer sans casser la disposition des fenêtres
        close_command = function(buf) require("mini.bufremove").delete(buf) end,
        right_mouse_command = function(buf) require("mini.bufremove").delete(buf) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        -- Décaler les onglets quand l'arborescence est ouverte
        offsets = {
          { filetype = "neo-tree", text = "Arborescence", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    -- Chargé sur :Neotree, ou dès le démarrage si nvim est lancé sur un dossier (`nvim .`)
    -- pour remplacer netrw
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("minionvim_neotree_start", { clear = true }),
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then return end
          local stat = vim.uv.fs_stat(vim.fn.argv(0))
          if stat and stat.type == "directory" then require("neo-tree") end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_dotfiles = false },
        hijack_netrw_behavior = "open_current",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = {},
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.nvim",
    -- Chargé au démarrage : mini.starter doit être configuré avant VimEnter
    lazy = false,
    config = function()
      require("mini.bufremove").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()

      -- Page d'accueil façon buffer *spacemacs* (rouvrir avec SPC b h)
      local starter = require("mini.starter")
      local function action(name, cmd)
        return { name = name, action = cmd, section = "Actions" }
      end
      local function in_section(name, items_fn)
        return function()
          local items = items_fn()
          for _, item in ipairs(items) do item.section = name end
          return items
        end
      end

      starter.setup({
        header = table.concat({
          [[           _       _                   _          ]],
          [[ _ __ ___ (_)_ __ (_) ___  _ __ __   _(_)_ __ ___  ]],
          [[| '_ ` _ \| | '_ \| |/ _ \| '_ \\ \ / / | '_ ` _ \ ]],
          [[| | | | | | | | | | | (_) | | | |\ V /| | | | | | |]],
          [[|_| |_| |_|_|_| |_|_|\___/|_| |_| \_/ |_|_| |_| |_|]],
        }, "\n"),
        items = {
          action("Trouver un fichier", "Telescope find_files hidden=true"),
          action("Chercher dans le projet", "Telescope live_grep"),
          action("Arborescence", "Neotree toggle"),
          action("Nouveau buffer", "enew"),
          action("Éditer la config", "edit " .. vim.fn.stdpath("config") .. "/init.lua"),
          action("Plugins (Lazy)", "Lazy"),
          action("Quitter", "qall"),
          in_section("Projet courant", starter.sections.recent_files(5, true, false)),
          in_section("Fichiers récents", starter.sections.recent_files(9, false, true)),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet("  "),
          starter.gen_hook.indexing("all", { "Actions" }),
          starter.gen_hook.aligning("center", "center"),
        },
        footer = function()
          local stats = require("lazy").stats()
          return ("%d plugins chargés en %.0f ms · j/k pour naviguer · SPC pour le menu"):format(stats.loaded, stats.startuptime)
        end,
        -- j et k sont réservés à la navigation (cf. MiniStarterOpened ci-dessous)
        query_updaters = "abcdefghilmnopqrstuvwxyz0123456789_-.",
      })

      -- Navigation façon Spacemacs : j/k (et Tab/S-Tab) déplacent la sélection, Entrée ouvre
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniStarterOpened",
        callback = function(args)
          local function nav(lhs, direction)
            vim.keymap.set("n", lhs, function() starter.update_current_item(direction) end,
              { buffer = args.buf, nowait = true, silent = true })
          end
          nav("j", "next")
          nav("k", "prev")
          nav("<Tab>", "next")
          nav("<S-Tab>", "prev")
        end,
      })

      -- startuptime n'est connu qu'après UIEnter
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function() pcall(starter.refresh) end,
      })
    end,
  },

  -- "fd" pour sortir du mode insertion (evil-escape)
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 300,
      default_mappings = false,
      mappings = {
        i = { f = { d = "<Esc>" } },
        v = { f = { d = "<Esc>" } },
        t = { f = { d = "<C-\\><C-n>" } },
      },
    },
  },
}
