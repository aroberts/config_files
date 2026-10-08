#!/usr/bin/env bash
# Single-instance wrapper around tmux-resurrect's save.sh, installed as
# @resurrect-save-script-path so tmux-continuum calls it for auto-saves.
# continuum_save.sh runs from status-right on every refresh; when tmux is slow
# to record the last-save timestamp, several refreshes start overlapping saves.
# Each save forks `ps` once per pane, so overlapping saves can drive load into
# the hundreds.

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux-resurrect"
LOCK="$STATE_DIR/save.lock"
SAVE_SCRIPT="$HOME/.tmux/tmux-plugins/tmux-resurrect/scripts/save.sh"

mkdir -p "$STATE_DIR"

# The lock is a symlink whose target is the holder's pid; `ln -s` is atomic.
if ! ln -s "$$" "$LOCK" 2>/dev/null; then
  holder=$(readlink "$LOCK")
  if [ -n "$holder" ] && kill -0 "$holder" 2>/dev/null; then
    exit 0
  fi
  # Holder died without cleaning up (e.g. SIGKILL); take the lock over once.
  rm -f "$LOCK"
  ln -s "$$" "$LOCK" 2>/dev/null || exit 0
fi
trap 'rm -f "$LOCK"' EXIT

"$SAVE_SCRIPT" "$@"
