-- Claude Code dans Neovim (protocole WebSocket/MCP de l'extension VS Code)
return {
  "coder/claudecode.nvim",
  cmd = {
    "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSelectModel", "ClaudeCodeAdd", "ClaudeCodeSend",
    "ClaudeCodeTreeAdd", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeStatus",
  },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "native", -- pas de dépendance à snacks.nvim
    },
    diff_opts = {
      layout = "vertical",
      open_in_new_tab = false,
    },
  },
  config = function(_, opts)
    require("claudecode").setup(opts)
    -- C-h / C-l depuis le terminal Claude, comme dans les autres fenêtres
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("minionvim_claudecode", { clear = true }),
      callback = function(ev)
        vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { buffer = ev.buf, desc = "Fenêtre à gauche" })
        vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { buffer = ev.buf, desc = "Fenêtre à droite" })
      end,
    })
  end,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Afficher/masquer Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Aller dans Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Reprendre une session" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continuer la dernière session" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Choisir le modèle" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Ajouter le buffer courant" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Envoyer la sélection" },
    {
      "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Ajouter le fichier",
      ft = { "neo-tree", "NvimTree", "oil", "minifiles", "netrw" },
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accepter le diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Refuser le diff" },
  },
}
