# prompt-glyphs.zsh — colored status glyphs you call from the prompt,
# in the same spirit as git_super_status.
#
# Each function prints a single glyph whose COLOR conveys state
# (green = good, dim grey = off/down); the glyph itself is fixed-width.
# Self-gating: if the underlying tool isn't installed, it prints nothing.
#
#   lpass_prompt_glyph   ɫ   green when logged into LastPass, dim when not
#   vpn_prompt_glyph     ⊚   green when openconnect (vpn) is up, dim when down
#
# Call them from ~/.zshrc.local via PROMPT_LOCAL / RPROMPT_LOCAL, which zshrc
# re-expands each render (the (e) flag), so embedded $(...) runs every prompt:
#
#   PROMPT_LOCAL='$(lpass_prompt_glyph)$(vpn_prompt_glyph) '
#   RPROMPT_LOCAL='$(vpn_prompt_glyph) '
#
# Use single quotes so the $(...) is stored literally and re-run each prompt,
# not evaluated once at assignment. They run on every render (~30ms for both).

[[ -o interactive ]] || return

typeset -g _prompt_glyph_good='%F{green}'   # logged in / vpn up
typeset -g _prompt_glyph_off='%F{242}'      # logged out / vpn down (dim grey)

# Print $1 (a glyph) colored good/off by the exit status of the remaining args.
_prompt_glyph() {
  local glyph=$1; shift
  local color=$_prompt_glyph_off
  "$@" &>/dev/null && color=$_prompt_glyph_good
  print -n -- "${color}${glyph}%f"
}

lpass_prompt_glyph() {
  (( $+commands[lpass] )) || return
  _prompt_glyph 'ɫ' lpass status
}

# Exit-code only (openconnect pidfile check), never the optional GP_PROBE_HOST
# ping — safe to call every prompt.
vpn_prompt_glyph() {
  (( $+commands[vpn-status] )) || return
  _prompt_glyph '⊚' vpn-status
}
