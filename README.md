# dotfiles

my personal dev env files

## Contents

- **Neovim** (`.config/nvim/`) — LazyVim-based setup with custom keymaps and plugins
- **Starship** (`.config/starship.toml`) — Terminal prompt configuration
- **Kitty** (`.config/kitty/`) — Starship-matched terminal theme with a Totoro corner watermark

## Setup

```bash
# Clone
git clone https://github.com/rqchao/dotfiles.git ~/dotfiles

# Symlink configs
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sfn ~/dotfiles/.config/kitty ~/.config/kitty
```
