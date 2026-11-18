# dotfiles

Personal macOS development environment files.

## Included

- **Neovim** (`.config/nvim/`) — LazyVim-based setup with custom keymaps and plugins
- **Starship** (`.config/starship.toml`) — Powerline-style shell prompt
- **Kitty** (`.config/kitty/`) — Starship-matched terminal theme with a Totoro corner watermark

## Set up a new Mac

These instructions assume macOS with Zsh. The setup script supports both Apple
Silicon and Intel Homebrew installations.

```bash
git clone https://github.com/rqchao/dotfiles.git ~/dotfiles
bash ~/dotfiles/setup.sh
```

The script will:

1. Install Homebrew if needed.
2. Install GitHub CLI, Starship, Neovim, Kitty, and JetBrains Mono Nerd Font.
3. Back up conflicting files to a timestamped `~/.config-backup-*` directory.
4. Symlink the Neovim, Starship, and Kitty configuration into `~/.config`.
5. Add Homebrew to `.zprofile` and initialize Starship from `.zshrc`.
6. Authenticate GitHub CLI as `rqchao` if needed.
7. Verify the installed commands and launch Kitty.

The script is safe to run again: existing correct symlinks and shell setup lines
are left unchanged.

## Apply future updates

```bash
git -C ~/dotfiles pull --ff-only
```

Kitty automatically reloads most configuration changes. To reload manually on
macOS, press **Control-Command-Comma**. Starship changes appear at the next
prompt.

## Troubleshooting

If `starship` is not found after setup, start a fresh login shell:

```bash
exec zsh -l
```

Then verify the installation and symlinks:

```bash
command -v gh starship nvim kitty
readlink ~/.config/starship.toml
readlink ~/.config/kitty
```
