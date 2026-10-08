# wt.zsh — cd wrapper for ~/bin/wt, which prints a git worktree path
# (a child process can't change this shell's directory).
#
#   wt <name>   jump to the worktree whose branch/dir matches <name>
#   wt          pick from a menu
#   wt -l       list worktrees (prints nothing to stdout, so no cd)
#
# Self-gating: defines nothing on hosts without the wt script.

[[ -o interactive ]] || return
(( $+commands[wt] )) || return

wt() {
  local d
  d=$(command wt "$@") || return
  [[ -z $d ]] || cd "$d"
}
