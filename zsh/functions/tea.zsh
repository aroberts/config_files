# tea wrapper - auto-discovers gitea remote from configured logins
# Requires: tea CLI (https://gitea.com/gitea/tea)

(( $+commands[tea] )) || return

tea() {
  # Pass through if --remote already specified or doing shell completion
  if [[ "$*" == *"--remote"* ]] || [[ "$*" == *"-R "* ]] || [[ "$*" == *"--generate-shell-completion"* ]]; then
    command tea "$@"
    return
  fi

  # Commands that support --remote flag
  local remote_cmds=(issues issue i pulls pull pr milestones milestone ms releases release r times time t open o notifications notification n branches branch b comment c)
  local first_arg="$1"
  local supports_remote=false
  for cmd in "${remote_cmds[@]}"; do
    [[ "$first_arg" == "$cmd" ]] && supports_remote=true && break
  done

  if $supports_remote; then
    # Get known Gitea hostnames from tea logins (strip protocol)
    local gitea_hosts
    gitea_hosts=$(command tea logins 2>/dev/null | awk 'NR>3 && /│/ {gsub(/https?:\/\//, "", $4); print $4}' | tr -d ' ')

    if [[ -n "$gitea_hosts" ]]; then
      # Try remotes in order, but only if URL matches a known Gitea host
      local remotes=(origin upstream gitea)
      for r in "${remotes[@]}"; do
        local url
        url=$(git remote get-url "$r" 2>/dev/null) || continue
        for host in ${(f)gitea_hosts}; do
          if [[ "$url" == *"$host"* ]]; then
            command tea "$@" --remote "$r"
            return
          fi
        done
      done
    fi
  fi

  # Fallback
  command tea "$@"
}

# Lazy-loaded completion
_tea() {
  unfunction _tea
  source <(tea completion zsh)
  _tea "$@"
}
compdef _tea tea
