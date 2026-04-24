# dotfile-update.zsh — background auto-update + plugin nudge on shell start
#
# On interactive shell start:
#   1. Throttled background `git fetch && merge --ff-only` on the config repo.
#      Throttle: DOTFILE_UPDATE_THRESHOLD seconds (default 3600).
#   2. Red banner if the repo is behind upstream (merge stuck / diverged).
#   3. Yellow banner if plugin config (vimrc / zsh_plugins.txt) has changed
#      since last update.sh run.
#
# State under ~/.local/state/dotfile_update:
#   last_fetch        — mtime gates the background fetch
#   lock              — mkdir-based mutex so concurrent shells don't race
#   update.log        — stdout/stderr from background jobs
#   last_plugin_run   — HEAD SHA written by update.sh on success

[[ -o interactive ]] || return
[[ -t 1 ]] || return

typeset -g _dotfile_update_repo=${DOTFILE_UPDATE_REPO:-$HOME/config}
typeset -g _dotfile_update_state=$HOME/.local/state/dotfile_update
typeset -gi _dotfile_update_threshold=${DOTFILE_UPDATE_THRESHOLD:-3600}

[[ -d $_dotfile_update_repo/.git ]] || return
mkdir -p $_dotfile_update_state

_dotfile_update_mtime() {
  # GNU stat first: BSD stat rejects -c and falls through. The reverse order
  # breaks on Linux because GNU stat treats -f as "filesystem info" (not an
  # error) and %m prints the mount point, which then crashes (( )) arithmetic.
  stat -c %Y $1 2>/dev/null || stat -f %m $1 2>/dev/null
}

_dotfile_update_tick() {
  local stamp=$_dotfile_update_state/last_fetch
  local lockdir=$_dotfile_update_state/lock
  local now=$(date +%s)

  if [[ -f $stamp ]]; then
    local mtime=$(_dotfile_update_mtime $stamp)
    (( mtime && now - mtime < _dotfile_update_threshold )) && return
  fi

  # bump the gate before forking so racing shells bail on the time check
  touch $stamp

  (
    # clean stale lock from a crashed run, then claim
    if [[ -d $lockdir ]]; then
      local lmtime=$(_dotfile_update_mtime $lockdir)
      (( lmtime && $(date +%s) - lmtime > _dotfile_update_threshold )) \
        && rmdir $lockdir 2>/dev/null
    fi
    mkdir $lockdir 2>/dev/null || exit 0
    trap "rmdir $lockdir 2>/dev/null" EXIT

    echo "$(date '+%Y-%m-%d %H:%M:%S') fetching $_dotfile_update_repo"
    git -C $_dotfile_update_repo fetch --quiet \
      && git -C $_dotfile_update_repo merge --ff-only --quiet
  ) >>$_dotfile_update_state/update.log 2>&1 &!
}

_dotfile_update_nudge() {
  local repo=$_dotfile_update_repo

  local behind
  behind=$(git -C $repo rev-list HEAD..@{u} --count 2>/dev/null) || behind=0
  if (( behind > 0 )); then
    print -P "%F{red}dotfiles: ${behind} commit(s) behind upstream — run update.sh to merge%f"
  fi

  local baseline_file=$_dotfile_update_state/last_plugin_run
  [[ -f $baseline_file ]] || return
  local baseline=$(<$baseline_file)
  [[ -n $baseline ]] || return

  local changed
  changed=$(git -C $repo diff --name-only $baseline HEAD 2>/dev/null)
  if grep -qE '^(zsh_plugins\.txt|vimrc)$' <<<$changed; then
    print -P "%F{yellow}dotfiles: plugin config changed — run update.sh%f"
  fi
}

_dotfile_update_tick
_dotfile_update_nudge
