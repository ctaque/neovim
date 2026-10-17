-- Raccourcis globaux façon Spacemacs. Les groupes (noms affichés par which-key)
-- sont déclarés dans plugins/which-key.lua ; les raccourcis LSP dans plugins/lsp.lua.

local function map(lhs, rhs, desc, mode)
  vim.keymap.set(mode or "n", lhs, rhs, { desc = desc, silent = true })
end

-- lazy.nvim charge le plugin au premier `require`, ce qui permet de garder
-- tous les raccourcis ici sans charger Telescope au démarrage
local function tb(picker, opts)
  return function() require("telescope.builtin")[picker](opts or {}) end
end

local function project_root()
  local root = vim.fs.root(0, { ".git" })
  return root or vim.uv.cwd()
end

-- SPC SPC / SPC TAB
map("<leader><leader>", tb("commands"), "M-x (commandes)")
map("<leader><tab>", "<cmd>b#<cr>", "Dernier buffer")
map("<leader>:", tb("command_history"), "Historique des commandes")
map("<leader>/", function() tb("live_grep", { cwd = project_root() })() end, "Chercher dans le projet")
vim.keymap.set("n", "<leader>;", "gcc", { desc = "Commenter la ligne", remap = true })
vim.keymap.set("v", "<leader>;", "gc", { desc = "Commenter la sélection", remap = true })

-- SPC 1..9 : sélectionner la fenêtre n
for i = 1, 9 do
  map("<leader>" .. i, "<cmd>" .. i .. "wincmd w<cr>", "Fenêtre " .. i)
end
-- C-h / C-l : passer de l'arborescence au fichier (et entre fenêtres côte à côte)
map("<C-h>", "<cmd>wincmd h<cr>", "Fenêtre à gauche")
map("<C-l>", "<cmd>wincmd l<cr>", "Fenêtre à droite")

-- SPC 0 : aller dans l'arborescence (comme neotree/treemacs dans Spacemacs)
map("<leader>0", "<cmd>Neotree focus<cr>", "Arborescence")

-- SPC b : buffers
map("<leader>bb", tb("buffers", { sort_mru = true }), "Lister les buffers")
map("<leader>bd", function() require("mini.bufremove").delete(0) end, "Fermer le buffer")
map("<leader>bD", function() require("mini.bufremove").delete(0, true) end, "Fermer le buffer (forcer)")
map("<leader>bn", "<cmd>BufferLineCycleNext<cr>", "Buffer suivant")
map("<leader>bp", "<cmd>BufferLineCyclePrev<cr>", "Buffer précédent")
map("<S-l>", "<cmd>BufferLineCycleNext<cr>", "Onglet suivant")
map("<S-h>", "<cmd>BufferLineCyclePrev<cr>", "Onglet précédent")
map("<leader>b>", "<cmd>BufferLineMoveNext<cr>", "Déplacer l'onglet à droite")
map("<leader>b<", "<cmd>BufferLineMovePrev<cr>", "Déplacer l'onglet à gauche")
map("<leader>bP", "<cmd>BufferLineTogglePin<cr>", "Épingler l'onglet")
map("<leader>bo", "<cmd>BufferLineCloseOthers<cr>", "Fermer les autres onglets")
map("<leader>bs", function()
  vim.cmd.enew()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.api.nvim_buf_set_name(0, "*scratch*")
end, "Buffer *scratch*")
map("<leader>bY", "<cmd>%y+<cr>", "Copier tout le buffer")
map("<leader>bh", function() require("mini.starter").open() end, "Page d'accueil")

-- SPC f : fichiers
map("<leader>ff", tb("find_files", { hidden = true }), "Trouver un fichier")
map("<leader>fr", tb("oldfiles"), "Fichiers récents")
map("<leader>fs", "<cmd>write<cr>", "Sauvegarder")
map("<leader>fS", "<cmd>wall<cr>", "Tout sauvegarder")
map("<leader>ft", "<cmd>Neotree toggle<cr>", "Arborescence")
map("<leader>fT", "<cmd>Neotree reveal<cr>", "Révéler dans l'arborescence")
map("<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copié : " .. path)
end, "Copier le chemin du fichier")
map("<leader>fed", function() vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua") end, "Éditer la config")
map("<leader>fec", tb("find_files", { cwd = vim.fn.stdpath("config") }), "Fichiers de la config")
map("<leader>fel", "<cmd>Lazy<cr>", "Plugins (Lazy)")
map("<leader>fem", "<cmd>Mason<cr>", "Serveurs LSP (Mason)")

-- SPC p : projet
map("<leader>pf", function() tb("find_files", { cwd = project_root(), hidden = true })() end, "Fichier du projet")
map("<leader>ps", function() tb("live_grep", { cwd = project_root() })() end, "Chercher dans le projet")
map("<leader>pt", function() vim.cmd("Neotree toggle dir=" .. vim.fn.fnameescape(project_root())) end, "Arborescence du projet")

-- SPC s : recherche
map("<leader>ss", tb("current_buffer_fuzzy_find"), "Chercher dans le buffer")
map("<leader>sp", function() tb("live_grep", { cwd = project_root() })() end, "Chercher dans le projet")
map("<leader>s*", function() tb("grep_string", { cwd = project_root() })() end, "Chercher le mot sous le curseur")
map("<leader>sc", "<cmd>nohlsearch<cr>", "Effacer la surbrillance")
map("<leader>sr", tb("resume"), "Reprendre la dernière recherche")

-- SPC w : fenêtres
map("<leader>w/", "<cmd>vsplit<cr>", "Split vertical")
map("<leader>wv", "<cmd>vsplit<cr>", "Split vertical")
map("<leader>w-", "<cmd>split<cr>", "Split horizontal")
map("<leader>ws", "<cmd>split<cr>", "Split horizontal")
map("<leader>wd", "<cmd>close<cr>", "Fermer la fenêtre")
map("<leader>wm", "<cmd>only<cr>", "Maximiser (only)")
map("<leader>ww", "<cmd>wincmd w<cr>", "Fenêtre suivante")
map("<leader>w=", "<cmd>wincmd =<cr>", "Équilibrer")
map("<leader>wh", "<cmd>wincmd h<cr>", "Fenêtre à gauche")
map("<leader>wj", "<cmd>wincmd j<cr>", "Fenêtre en bas")
map("<leader>wk", "<cmd>wincmd k<cr>", "Fenêtre en haut")
map("<leader>wl", "<cmd>wincmd l<cr>", "Fenêtre à droite")
map("<leader>wH", "<cmd>wincmd H<cr>", "Déplacer à gauche")
map("<leader>wJ", "<cmd>wincmd J<cr>", "Déplacer en bas")
map("<leader>wK", "<cmd>wincmd K<cr>", "Déplacer en haut")
map("<leader>wL", "<cmd>wincmd L<cr>", "Déplacer à droite")

-- SPC e : erreurs (diagnostics)
map("<leader>en", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Erreur suivante")
map("<leader>ep", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Erreur précédente")
map("<leader>el", tb("diagnostics", { bufnr = 0 }), "Erreurs du buffer")
map("<leader>eL", tb("diagnostics"), "Erreurs du projet")
map("<leader>ee", vim.diagnostic.open_float, "Afficher l'erreur")

-- SPC g : git
map("<leader>gs", "<cmd>Neogit<cr>", "Statut (Magit)")
map("<leader>gb", "<cmd>Gitsigns blame<cr>", "Blame")
map("<leader>gl", "<cmd>Gitsigns blame_line<cr>", "Blame de la ligne")
map("<leader>gf", tb("git_files"), "Fichiers suivis")
map("<leader>gc", tb("git_commits"), "Commits")
map("<leader>gn", "<cmd>Gitsigns nav_hunk next<cr>", "Hunk suivant")
map("<leader>gN", "<cmd>Gitsigns nav_hunk prev<cr>", "Hunk précédent")
map("<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", "Prévisualiser le hunk")
map("<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", "Annuler le hunk")
map("<leader>gS", "<cmd>Gitsigns stage_hunk<cr>", "Stager le hunk")

-- SPC j : sauts (avy → flash.nvim)
map("<leader>jj", function() require("flash").jump() end, "Sauter vers…", { "n", "x", "o" })
map("<leader>jl", function()
  require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" })
end, "Sauter à une ligne")
map("<leader>ji", tb("lsp_document_symbols"), "Symboles (imenu)")

-- SPC t : bascules
map("<leader>tn", "<cmd>set number! relativenumber!<cr>", "Numéros de ligne")
map("<leader>tr", "<cmd>set relativenumber!<cr>", "Numéros relatifs")
map("<leader>tl", "<cmd>set wrap!<cr>", "Retour à la ligne")
map("<leader>tw", "<cmd>set list!<cr>", "Espaces visibles")
map("<leader>ts", "<cmd>set spell!<cr>", "Correcteur orthographique")
map("<leader>tf", function()
  vim.g.minionvim_autoformat = vim.g.minionvim_autoformat == false
  vim.notify("Formatage à la sauvegarde : " .. (vim.g.minionvim_autoformat and "activé" or "désactivé"))
end, "Formatage à la sauvegarde")
map("<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, "Inlay hints")

-- SPC T : thèmes / interface
map("<leader>Ts", tb("colorscheme", { enable_preview = true }), "Choisir un thème")

-- SPC h : aide
map("<leader>hdf", tb("help_tags"), "Aide (describe-function)")
map("<leader>hdk", tb("keymaps"), "Raccourcis (describe-key)")
map("<leader>hdv", tb("vim_options"), "Options (describe-variable)")
map("<leader>hm", tb("man_pages"), "Pages man")

-- SPC q : quitter
map("<leader>qq", "<cmd>confirm qall<cr>", "Quitter")
map("<leader>qQ", "<cmd>qall!<cr>", "Quitter sans sauvegarder")
map("<leader>qs", "<cmd>wqall<cr>", "Sauvegarder et quitter")

-- SPC x : texte
map("<leader>xd", [[<cmd>%s/\s\+$//e<cr>]], "Supprimer les espaces en fin de ligne")

-- Divers
map("<Esc>", "<cmd>nohlsearch<cr>", "Effacer la surbrillance")
map("<", "<gv", "Désindenter", "v")
map(">", ">gv", "Indenter", "v")
