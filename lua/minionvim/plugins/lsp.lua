-- Serveurs installés automatiquement par Mason. Ajouter un nom ici (cf. :Mason)
-- suffit : mason-lspconfig l'active avec la config fournie par nvim-lspconfig.
local servers = { "lua_ls", "pyright", "ts_ls", "rust_analyzer", "jsonls", "bashls" }
-- Formateurs utilisés par conform.nvim, installés par Mason (rustfmt vient de rustup)
local formatters = { "stylua", "ruff", "prettierd", "shfmt" }

-- Raccourcis du "major mode" : accessibles via "," et via "SPC m", comme dans Spacemacs
local function on_attach(buf)
  local tb = require("telescope.builtin")
  local maps = {
    { "gg", vim.lsp.buf.definition, "Aller à la définition" },
    { "gd", vim.lsp.buf.declaration, "Aller à la déclaration" },
    { "gr", tb.lsp_references, "Références" },
    { "gi", tb.lsp_implementations, "Implémentations" },
    { "gt", tb.lsp_type_definitions, "Définition du type" },
    { "gs", tb.lsp_document_symbols, "Symboles du fichier" },
    { "gS", tb.lsp_dynamic_workspace_symbols, "Symboles du projet" },
    { "rr", vim.lsp.buf.rename, "Renommer" },
    { "a", vim.lsp.buf.code_action, "Actions de code" },
    { "=", function() require("conform").format({ lsp_format = "fallback" }) end, "Formater" },
    { "hh", vim.lsp.buf.hover, "Documentation" },
    { "hs", vim.lsp.buf.signature_help, "Signature" },
  }
  for _, m in ipairs(maps) do
    for _, prefix in ipairs({ "<localleader>", "<leader>m" }) do
      vim.keymap.set("n", prefix .. m[1], m[2], { buffer = buf, desc = m[3] })
    end
  end
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Aller à la définition" })
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("lua_ls", {
        settings = { Lua = { completion = { callSnippet = "Replace" } } },
      })
      -- Diagnostics de clippy (au lieu de cargo check) à chaque sauvegarde
      vim.lsp.config("rust_analyzer", {
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("minionvim-lsp", { clear = true }),
        callback = function(args) on_attach(args.buf) end,
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(formatters) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then pkg:install() end
        end
      end)
    end,
  },

  -- Complétion de l'API Neovim dans les fichiers de config Lua
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    event = "BufWritePre",
    opts = {
      -- Formatage à la sauvegarde (formateur dédié, sinon le LSP) ; SPC t f pour basculer
      format_on_save = function()
        if vim.g.minionvim_autoformat == false then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
      formatters_by_ft = (function()
        local by_ft = {
          rust = { "rustfmt" },
          lua = { "stylua" },
          python = { "ruff_format" },
          sh = { "shfmt" },
          bash = { "shfmt" },
        }
        local web = { "javascript", "javascriptreact", "typescript", "typescriptreact",
          "json", "jsonc", "yaml", "markdown", "css", "scss", "html" }
        for _, ft in ipairs(web) do
          by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
        end
        return by_ft
      end)(),
    },
  },
}
