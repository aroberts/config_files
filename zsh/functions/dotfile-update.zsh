# dotfile-update.zsh — background auto-update + plugin nudge on shell start
#
# At the first prompt of an interactive shell (deferred so ~/.zshrc.local and
# overlay zshrcs can set the knobs below):
#   1. Throttled background `git fetch && merge --ff-only` on the config repo,
#      its overlays, and the extra dirs.
#      Throttle: DOTFILE_UPDATE_THRESHOLD seconds (default 3600).
#   2. Red banner for each of those repos that is behind upstream (merge
#      stuck / diverged).
#   3. Yellow banner if plugin config (vimrc / vim/vim-plug.vim /
#      zsh_plugins.txt) has changed since last update.sh run.
#
# Extra dirs are colon-separated, like PATH. Entries that aren't git repos
# with an upstream are skipped.
#   DOTFILE_UPDATE_DIRS        — replaces the default list ($HOME/bin and
#                                $HOME/.claude); set it empty to drop it
#   DOTFILE_UPDATE_EXTRA_DIRS  — appended to whichever list is in effect
#
# State under ~/.local/state/dotfile_update:
#   last_fetch        — mtime gates the background fetch
#   lock              — mkdir-based mutex so concurrent shells don't race
#   update.log        — stdout/stderr from background jobs
#   last_plugin_run   — HEAD SHA written by update.sh on success

[[ -o interactive ]] || return
[[ -t 1 ]] || return

typeset -g _dotfile_update_state=$HOME/.local/state/dotfile_update

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
    # BatchMode prevents ssh prompts that would leak to the user's tty even
    # though fd 1/2 are redirected; ConnectTimeout caps the wait on unreachable
    # remotes. Fetch only origin — merge --ff-only uses its upstream anyway,
    # and the other remotes are LAN hosts that are slow or flaky.
    export GIT_SSH_COMMAND='ssh -o BatchMode=yes -o ConnectTimeout=5'
    # git's https credential prompt opens /dev/tty directly, same leak
    export GIT_TERMINAL_PROMPT=0
    local before=$(git -C $_dotfile_update_repo rev-parse HEAD)
    git -C $_dotfile_update_repo fetch --quiet origin \
      && git -C $_dotfile_update_repo merge --ff-only --quiet

    # check out the submodule commits the merge recorded, so they don't show
    # as modified and block later updates (e.g. admin_setup's git task). Only
    # when HEAD moved, to leave an in-progress submodule bump alone.
    if [[ $(git -C $_dotfile_update_repo rev-parse HEAD) != $before ]]; then
      git -C $_dotfile_update_repo submodule update --init --recursive --quiet
    fi

    # overlays (see zshrc) and extra dirs get the same treatment when they
    # track a remote. Plain fetch pulls only the remote the upstream is on.
    local dir
    for dir ($_dotfile_update_dirs); do
      git -C $dir rev-parse --abbrev-ref @{u} &>/dev/null || continue
      echo "$(date '+%Y-%m-%d %H:%M:%S') fetching $dir"
      git -C $dir fetch --quiet && git -C $dir merge --ff-only --quiet
    done
  ) </dev/null >>$_dotfile_update_state/update.log 2>&1 &!
}

_dotfile_update_nudge() {
  local repo=$_dotfile_update_repo

  local behind
  behind=$(git -C $repo rev-list HEAD..@{u} --count 2>/dev/null) || behind=0
  if (( behind > 0 )); then
    print -P "%F{red}dotfiles: ${behind} commit(s) behind upstream — run update.sh to merge%f"
  fi

  # reads the remote-tracking refs the last background fetch left, no network
  local dir
  for dir ($_dotfile_update_dirs); do
    behind=$(git -C $dir rev-list HEAD..@{u} --count 2>/dev/null) || continue
    if (( behind > 0 )); then
      print -P "%F{red}dotfiles: ${(D)dir} ${behind} commit(s) behind upstream — fast-forward blocked, merge manually%f"
    fi
  done

  local baseline_file=$_dotfile_update_state/last_plugin_run
  [[ -f $baseline_file ]] || return
  local baseline=$(<$baseline_file)
  [[ -n $baseline ]] || return

  local changed
  changed=$(git -C $repo diff --name-only $baseline HEAD 2>/dev/null)
  if grep -qE '^(zsh_plugins\.txt|vimrc|vim/vim-plug\.vim)$' <<<$changed; then
    print -P "%F{yellow}dotfiles: plugin config changed — run update.sh%f"
  fi
}

_dotfile_update_init() {
  add-zsh-hook -d precmd _dotfile_update_init

  typeset -g _dotfile_update_repo=${DOTFILE_UPDATE_REPO:-$HOME/config}
  typeset -gi _dotfile_update_threshold=${DOTFILE_UPDATE_THRESHOLD:-3600}

  [[ -d $_dotfile_update_repo/.git ]] || return
  mkdir -p $_dotfile_update_state

  # overlays + extra dirs, resolved and deduped. The .git check keeps a
  # non-repo dir from resolving to an enclosing repo (e.g. the config repo).
  typeset -gaU _dotfile_update_dirs=()
  local dir
  for dir in $_dotfile_update_repo/overlays/*(N/) \
      ${(s.:.)${DOTFILE_UPDATE_DIRS-$HOME/bin:$HOME/.claude}} \
      ${(s.:.)DOTFILE_UPDATE_EXTRA_DIRS}; do
    dir=${dir:A}
    [[ -e $dir/.git && $dir != ${_dotfile_update_repo:A} ]] \
      && _dotfile_update_dirs+=($dir)
  done

  _dotfile_update_tick
  _dotfile_update_nudge
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfile_update_init
