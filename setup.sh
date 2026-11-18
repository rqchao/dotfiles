#!/usr/bin/env bash

set -euo pipefail

readonly GITHUB_USER="rqchao"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="$HOME/.config"
readonly BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

log() {
  printf '\n\033[1;34m==>\033[0m %s\n' "$*"
}

die() {
  printf '\n\033[1;31mError:\033[0m %s\n' "$*" >&2
  exit 1
}

append_line_once() {
  local file="$1"
  local line="$2"

  touch "$file"
  grep -Fqx "$line" "$file" 2>/dev/null || printf '\n%s\n' "$line" >> "$file"
}

link_config() {
  local source="$1"
  local target="$2"
  local name
  name="$(basename "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'Already linked: %s\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$name"
    printf 'Backed up: %s -> %s\n' "$target" "$BACKUP_DIR/$name"
  fi

  ln -s "$source" "$target"
  printf 'Linked: %s -> %s\n' "$target" "$source"
}

[[ "$(uname -s)" == "Darwin" ]] || die "This setup script supports macOS only."

for required_path in \
  "$REPO_DIR/.config/nvim" \
  "$REPO_DIR/.config/starship.toml" \
  "$REPO_DIR/.config/kitty/kitty.conf"; do
  [[ -e "$required_path" ]] || die "Missing $required_path. Run this script from the cloned dotfiles repository."
done

log "Installing Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  readonly BREW_BIN="/opt/homebrew/bin/brew"
elif [[ -x /usr/local/bin/brew ]]; then
  readonly BREW_BIN="/usr/local/bin/brew"
else
  die "Homebrew was installed but its executable could not be found."
fi

eval "$("$BREW_BIN" shellenv)"
append_line_once "$HOME/.zprofile" "eval \"\$($BREW_BIN shellenv)\""

log "Installing command-line tools"
brew install gh starship neovim

log "Installing Kitty and JetBrains Mono Nerd Font"
brew install --cask kitty font-jetbrains-mono-nerd-font

log "Linking dotfiles"
mkdir -p "$CONFIG_DIR"
link_config "$REPO_DIR/.config/nvim" "$CONFIG_DIR/nvim"
link_config "$REPO_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
link_config "$REPO_DIR/.config/kitty" "$CONFIG_DIR/kitty"

log "Enabling Starship in Zsh"
append_line_once "$HOME/.zshrc" 'eval "$(starship init zsh)"'

log "Authenticating GitHub CLI"
active_user="$(gh api user --jq .login 2>/dev/null || true)"
if [[ "$active_user" != "$GITHUB_USER" ]]; then
  if ! gh auth switch -h github.com -u "$GITHUB_USER" 2>/dev/null; then
    gh auth login -h github.com -p https -w
  fi
  active_user="$(gh api user --jq .login 2>/dev/null || true)"
fi

if [[ "$active_user" == "$GITHUB_USER" ]]; then
  printf 'GitHub CLI active account: %s\n' "$active_user"
else
  printf 'Warning: GitHub CLI is not active as %s. Run:\n' "$GITHUB_USER" >&2
  printf '  gh auth switch -h github.com -u %s\n' "$GITHUB_USER" >&2
fi

log "Verifying setup"
command -v gh
command -v starship
command -v nvim
command -v kitty
starship --version
kitty --version

log "Launching Kitty"
open -na kitty

printf '\nSetup complete. Open a new Kitty window to start a fresh login shell.\n'
if [[ -d "$BACKUP_DIR" ]]; then
  printf 'Previous configuration was saved in: %s\n' "$BACKUP_DIR"
fi
