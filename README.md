# minionvim

Configuration Neovim (≥ 0.11) inspirée de Spacemacs : `SPC` comme leader, `,` comme leader « major mode ».

## Lancer

```sh
ln -s ~/projets/minionvim ~/.config/minionvim
    NVIM_APPNAME=minionvim nvim
```

Alias pratique : `alias mvim='NVIM_APPNAME=minionvim nvim'`.
Au premier lancement, lazy.nvim installe les plugins, Mason les serveurs LSP et nvim-treesitter les parsers.

## Raccourcis principaux

| Touche | Action |
|---|---|
| `SPC SPC` | M-x (commandes) |
| `SPC TAB` | dernier buffer |
| `S-h` / `S-l` | onglet précédent / suivant (bufferline) |
| `SPC /` | chercher dans le projet |
| `SPC ;` | commenter |
| `SPC 1..9` | aller à la fenêtre n |
| `SPC 0` | aller dans l'arborescence (neo-tree) |
| `C-h` / `C-l` | fenêtre à gauche / à droite (arborescence ↔ fichier) |
| `SPC f t` / `SPC f T` / `SPC p t` | afficher/masquer l'arborescence / révéler le fichier courant / arborescence du projet |
| `SPC f` / `b` / `p` / `w` / `s` / `g` / `e` / `t` / `h` / `q` | fichiers / buffers / projet / fenêtres / recherche / git / erreurs / bascules / aide / quitter |
| `SPC b h` | page d'accueil (`j`/`k` ou `Tab`/`S-Tab` pour naviguer, `Entrée` pour ouvrir) |
| `SPC f e d` | éditer la config |
| `SPC g s` | Neogit (façon Magit) |
| `SPC j j` | sauter (avy → flash.nvim) |
| `SPC v` puis `v` / `V` | étendre / réduire la sélection (expand-region) |
| `,` ou `SPC m` | LSP : `gg` définition, `gr` références, `rr` renommer, `a` actions, `=` formater |
| `fd` | quitter le mode insertion |
| `SPC t f` | activer / désactiver le formatage à la sauvegarde |
