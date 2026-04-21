#!/bin/zsh
# Manual interactive update: pull, submodules, zsh plugins, vim plugins.
# Records HEAD on success so dotfile-update.zsh stops nudging.

set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="$HOME/.local/state/dotfile_update"

git -C "$REPO" pull
git -C "$REPO" submodule update --init --recursive

if [[ -r "$HOME/.src/antidote/antidote.zsh" ]]; then
  source "$HOME/.src/antidote/antidote.zsh"
  antidote update
fi

vim +PlugClean +PlugUpdate +PlugInstall +qall

mkdir -p "$STATE_DIR"
git -C "$REPO" rev-parse HEAD > "$STATE_DIR/last_plugin_run"
