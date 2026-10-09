#!/usr/bin/env bash
# tmux-resurrect restore strategy for vim, selected with
# `@resurrect-strategy-vim 'dotsession'`. Same as the built-in 'session'
# strategy, but looks for the .session.vim that vim/autocmds.vim tells
# obsession to write, instead of Session.vim.
#
# resurrect only looks up strategies at strategies/<command>_<name>.sh inside
# the plugin, so plugins.tmux symlinks this file in as vim_dotsession.sh.

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

if [ -e "${DIRECTORY}/.session.vim" ]; then
  echo "vim -S .session.vim"
else
  echo "$ORIGINAL_COMMAND"
fi
