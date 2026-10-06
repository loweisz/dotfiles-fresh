# dotfiles

My zsh setup: [Oh My Zsh](https://ohmyz.sh/) + a few plugins + personal aliases. One script sets it all up.

## Install

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
exec zsh
```

The script is idempotent, so re-run it any time. It will:

1. Install Homebrew (macOS), `zsh` and `git` if missing
2. Install Oh My Zsh
3. Install the `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
4. Back up any existing `~/.zshrc` (as `~/.zshrc.backup.<timestamp>`) and symlink `zsh/.zshrc` in its place
5. Set zsh as your default shell

## Layout

```
install.sh        # bootstrap script
zsh/
  .zshrc          # Oh My Zsh config: theme, plugins, loads the files below
  exports.zsh     # environment variables and PATH
  aliases.zsh     # aliases
```

## Customize

- **Aliases:** edit `zsh/aliases.zsh`, then run `reload`.
- **Theme / plugins:** edit `ZSH_THEME` and `plugins=(...)` in `zsh/.zshrc`.
- **Machine-specific or secret settings:** put them in `~/.zshrc.local` (sourced last, never committed).

Because `~/.zshrc` is a symlink into this repo, changes show up in `git diff` immediately.
