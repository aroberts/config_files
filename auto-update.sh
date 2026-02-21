#!/bin/bash
# auto-update.sh — headless periodic updater for config + scripts repos.
# Unlike update.sh (manual interactive: pull, submodules, vim plugins),
# this runs unattended via cron/launchd.

set -euo pipefail

STATE_DIR="$HOME/.local/state/dotfile_update"
CONFIG_FILE="$HOME/.config/dotfile_update/auto-update.conf"
CONFIG_REPO="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_REPO="${CONFIG_REPO}/../scripts"
THRESHOLD_SECS=$((48 * 3600))

mkdir -p "$STATE_DIR"

# Source user config overrides if present
# Supported keys: SCRIPTS_REPO, PUSHOVER_USER, PUSHOVER_TOKEN
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
fi

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*"
}

send_notification() {
  local title="$1"
  local message="$2"

  # Pushover notification if configured
  if [[ -n "${PUSHOVER_USER:-}" && -n "${PUSHOVER_TOKEN:-}" ]]; then
    curl -s \
      --form-string "token=$PUSHOVER_TOKEN" \
      --form-string "user=$PUSHOVER_USER" \
      --form-string "title=$title" \
      --form-string "message=$message" \
      https://api.pushover.net/1/messages.json >/dev/null 2>&1 || \
      log "WARNING: Pushover notification failed"
  fi

  # Local mail fallback
  if command -v mail &>/dev/null; then
    echo "$message" | mail -s "$title" "$USER" 2>/dev/null || true
  fi
}

update_repo() {
  local name="$1"
  local repo_path="$2"
  local marker="$STATE_DIR/${name}.unmerged"

  if [[ ! -d "$repo_path/.git" ]]; then
    log "SKIP $name: $repo_path is not a git repo"
    return
  fi

  log "Fetching $name ($repo_path)"
  if ! git -C "$repo_path" fetch --quiet 2>&1; then
    log "ERROR: fetch failed for $name"
    return
  fi

  local behind
  behind=$(git -C "$repo_path" rev-list HEAD..@{u} --count 2>/dev/null) || behind=0

  if [[ "$behind" -eq 0 ]]; then
    log "$name: up to date"
    rm -f "$marker"
    return
  fi

  log "$name: $behind commit(s) behind upstream"

  # Snapshot root entries before merge (config repo only)
  local snapshot_before=""
  if [[ "$name" == "config" ]]; then
    snapshot_before=$(ls -1 "$repo_path")
  fi

  # Attempt fast-forward merge
  if git -C "$repo_path" merge --ff-only 2>&1; then
    log "$name: fast-forward merge succeeded"
    rm -f "$marker"

    # Check for new root entries in config repo and re-install if needed
    if [[ "$name" == "config" ]]; then
      local snapshot_after
      snapshot_after=$(ls -1 "$repo_path")
      if [[ "$snapshot_before" != "$snapshot_after" ]]; then
        log "$name: root entries changed, running install.sh --no-updates"
        "$repo_path/install.sh" --no-updates
      fi
    fi
  else
    log "$name: fast-forward merge failed (diverged branches)"

    # Write unmerged marker with timestamp if new, check age if existing
    if [[ ! -f "$marker" ]]; then
      date +%s > "$marker"
      log "$name: created unmerged marker"
    else
      local marker_time
      marker_time=$(cat "$marker")
      local now
      now=$(date +%s)
      local age=$(( now - marker_time ))

      if [[ "$age" -ge "$THRESHOLD_SECS" ]]; then
        local hours=$(( age / 3600 ))
        log "$name: unmerged for ${hours}h, sending notification"
        send_notification "Dotfile update: $name needs attention" \
          "$name repo has had unmerged upstream changes for ${hours} hours. Manual merge required at $repo_path."
      fi
    fi
  fi
}

# --- Main ---
log "=== dotfile auto-update starting ==="

update_repo "config" "$CONFIG_REPO"

if [[ -d "$SCRIPTS_REPO" ]]; then
  update_repo "scripts" "$SCRIPTS_REPO"
fi

log "=== dotfile auto-update complete ==="
