# Managed by ~/projects-1/dotfiles — edit the repo, not this symlink target.

# Resolve the repo's zsh/ directory even when this file is symlinked to ~/.zshrc
export DOTFILES_ZSH="${${(%):-%N}:A:h}"

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting  # keep last
)

source "$ZSH/oh-my-zsh.sh"

# --- Personal config ---
for file in "$DOTFILES_ZSH"/exports.zsh "$DOTFILES_ZSH"/aliases.zsh; do
  [[ -r "$file" ]] && source "$file"
done

# Machine-specific overrides (not tracked in git)
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
