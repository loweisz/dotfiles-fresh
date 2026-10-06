#!/usr/bin/env bash
# Sets up zsh + Oh My Zsh and links the dotfiles from this repo. Safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. Homebrew (macOS) -------------------------------------------------------
if [[ "$(uname)" == "Darwin" ]] && ! command -v brew >/dev/null; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. zsh + git --------------------------------------------------------------
if ! command -v zsh >/dev/null || ! command -v git >/dev/null; then
  info "Installing zsh and git"
  if command -v brew >/dev/null; then brew install zsh git
  elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y zsh git curl
  else echo "Install zsh and git manually, then re-run." >&2; exit 1; fi
fi

# 3. Oh My Zsh (unattended: don't overwrite .zshrc, don't switch shell yet) --
if [[ ! -d "$OMZ_DIR" ]]; then
  info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 4. Plugins ----------------------------------------------------------------
install_plugin() {
  local name="$1" url="$2" dest="$ZSH_CUSTOM_DIR/plugins/$1"
  if [[ -d "$dest" ]]; then info "Updating $name"; git -C "$dest" pull -q
  else info "Installing $name"; git clone -q --depth 1 "$url" "$dest"; fi
}
install_plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

# 5. Link .zshrc (back up anything that isn't already our symlink) -----------
TARGET="$HOME/.zshrc"
SOURCE="$REPO_DIR/zsh/.zshrc"
if [[ -e "$TARGET" || -L "$TARGET" ]] && [[ "$(readlink "$TARGET" || true)" != "$SOURCE" ]]; then
  BACKUP="$TARGET.backup.$(date +%Y%m%d%H%M%S)"
  info "Backing up existing .zshrc to $BACKUP"
  mv "$TARGET" "$BACKUP"
fi
ln -sfn "$SOURCE" "$TARGET"
info "Linked $TARGET -> $SOURCE"

# 6. Default shell ----------------------------------------------------------
ZSH_PATH="$(command -v zsh)"
if [[ "${SHELL:-}" != "$ZSH_PATH" ]]; then
  info "Setting zsh as default shell (may ask for your password)"
  grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_PATH" || echo "Could not change shell; run: chsh -s $ZSH_PATH"
fi

info "Done. Open a new terminal or run: exec zsh"
