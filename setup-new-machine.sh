#!/bin/bash
# Set up config_files and scripts on a new Mac. Safe to re-run.
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/aroberts/config_files/master/setup-new-machine.sh)
#
# Installs Homebrew if missing (admin users only), then clones both repos
# into ~/Source, linked from ~/config and ~/bin (the layout
# pcrn-mgmt's admin_setup.yml uses). Fetches go over anonymous https so
# dotfile-update works before any ssh keys exist; pushes go over ssh.
# Creates a local overlays/work repo holding the git identity, then runs
# install.sh.
#
# Options:
#   --email <addr>      email for overlays/work/gitconfig (prompted otherwise)
#   --macos-defaults    also run config's bootstrap (Finder/keyboard defaults, sudo)

set -euo pipefail

source_dir=$HOME/Source
email=
macos_defaults=

while [ $# -gt 0 ]; do
  case $1 in
    --email) email=$2; shift 2 ;;
    --macos-defaults) macos_defaults=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[33mwarning: %s\033[0m\n' "$*" >&2; }

# clone_repo <github name> <dest under ~/Source> <link under ~>
clone_repo() {
  local name=$1 dest=$source_dir/$2 link=$HOME/$3

  if [ -d "$dest/.git" ]; then
    say "Updating $dest"
    git -C "$dest" pull --ff-only || warn "$dest did not fast-forward; left as is"
  else
    say "Cloning $name into $dest"
    git clone "https://github.com/aroberts/$name" "$dest"
  fi
  git -C "$dest" remote set-url --push origin "git@github.com:aroberts/$name.git"

  if [ -L "$link" ]; then
    ln -sfn "$dest" "$link"
  elif [ -e "$link" ]; then
    echo "$link exists and is not a symlink; move it aside and re-run" >&2
    exit 1
  else
    ln -s "$dest" "$link"
  fi
}

# --- prerequisites ---

[ "$(uname)" = Darwin ] || { echo "this script is for macOS" >&2; exit 1; }

if ! xcode-select -p &>/dev/null; then
  say "Installing Xcode Command Line Tools (needed for git)"
  xcode-select --install || true
  echo "Re-run this script once the Command Line Tools install finishes."
  exit 1
fi

if [ ! -x /opt/homebrew/bin/brew ] && ! command -v brew &>/dev/null; then
  if id -Gn | grep -qw admin; then
    say "Installing Homebrew"
    # NONINTERACTIVE skips the installer's prompts but also its sudo password
    # prompt, so cache sudo credentials first
    sudo -v
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    warn "not an admin user; skipping Homebrew. zshrc works without it, but tmux, ag, grc, etc. come from brew."
  fi
fi
# zprofile sets this up in new shells; this script needs it now
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

mkdir -p "$source_dir"

# --- repos ---

clone_repo config_files config config
clone_repo scripts scripts bin
config=$source_dir/config

# --- work overlay: the git identity lives here (base gitconfig sets none) ---

work=$config/overlays/work
if [ ! -f "$work/gitconfig" ]; then
  if [ -z "$email" ]; then
    read -r -p "Work email for git commits: " email </dev/tty
  fi
  [ -n "$email" ] || { echo "an email is required for overlays/work/gitconfig" >&2; exit 1; }

  say "Creating $work"
  mkdir -p "$work"
  printf '[user]\n  email = %s\n' "$email" > "$work/gitconfig"
  cat > "$work/aliases" <<'EOF'
# work aliases and functions. Same layout as the base repo: zshrc,
# zsh/functions/*.zsh and zsh/completions are picked up too.
EOF
  git -C "$work" init -q -b master
  git -C "$work" add -A
  git -C "$work" -c user.email="$email" commit -qm "initial work overlay"
fi

# --- move aside regular files that would block install.sh's symlinks ---

backup=$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)
for path in "$config"/*; do
  name=$(basename "$path")
  grep -qx "$name" "$config/do_not_install" && continue
  target=$HOME/.$name
  # install.sh merges into files carrying its cut line, and descends into
  # real directories; only plain conflicting files need to move
  if [ -f "$target" ] && [ ! -L "$target" ] \
    && ! grep -q "DO NOT EDIT BELOW THIS LINE" "$target"; then
    mkdir -p "$backup"
    mv "$target" "$backup/"
    warn "moved $target to $backup/"
  fi
done

# --- install ---

say "Running install.sh"
"$config/install.sh"

say "Installing fonts"
mkdir -p "$HOME/Library/Fonts"
find "$config/fonts" -maxdepth 1 -type f \( -name '*.ttf' -o -name '*.otf' \) \
  -exec cp -n {} "$HOME/Library/Fonts/" \;

say "Installing vim plugins"
# vim -E -s exits non-zero even when PlugInstall succeeds; check the result
vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall || true
[ -n "$(ls -A "$HOME/.vim/plugs" 2>/dev/null)" ] || warn "no vim plugins installed; run :PlugInstall"

if [ -n "$macos_defaults" ]; then
  say "Applying macOS defaults"
  "$config/bootstrap"
fi

say "Done"
cat <<EOF

Next steps:
  - open a new terminal; antidote clones zsh plugins on first start
  - gh auth login (config/gh/hosts.yml is untracked, so this stays local)
  - add an ssh key to GitHub before pushing from ~/config or ~/bin
  - machine-only settings go in ~/.zshrc.local and ~/.gitconfig.local
  - work aliases, functions and git settings go in ~/config/overlays/work
EOF
