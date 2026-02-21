#!/bin/bash
# manage_updates.sh — install/uninstall the dotfile auto-update schedule.
# Usage: manage_updates.sh install | uninstall

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AUTO_UPDATE="$SCRIPT_DIR/auto-update.sh"
STATE_DIR="$HOME/.local/state/dotfile_update"
PLIST_LABEL="us.pcrn.dotfile_update"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"
CRON_TAG="# dotfile-auto-update"

usage() {
  echo "Usage: $(basename "$0") install | uninstall"
  exit 1
}

install_macos() {
  mkdir -p "$STATE_DIR"
  mkdir -p "$(dirname "$PLIST_PATH")"

  # Unload existing if present
  local already_installed=false
  if launchctl list "$PLIST_LABEL" &>/dev/null; then
    already_installed=true
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
  fi

  cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${PLIST_LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>${AUTO_UPDATE}</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>${STATE_DIR}/update.log</string>
  <key>StandardErrorPath</key>
  <string>${STATE_DIR}/update.log</string>
</dict>
</plist>
EOF

  launchctl load "$PLIST_PATH"
  if [[ "$already_installed" == true ]]; then
    echo "Reinstalled launchd agent: $PLIST_LABEL"
  else
    echo "Installed launchd agent: $PLIST_LABEL"
  fi
}

uninstall_macos() {
  if launchctl list "$PLIST_LABEL" &>/dev/null; then
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
  fi
  rm -f "$PLIST_PATH"
  echo "Uninstalled launchd agent: $PLIST_LABEL"
}

install_linux() {
  mkdir -p "$STATE_DIR"

  # Deterministic minute from hostname
  local minute
  minute=$(( $(echo "$HOSTNAME" | cksum | cut -d' ' -f1) % 60 ))

  local cron_line="$minute * * * * $AUTO_UPDATE >> $STATE_DIR/update.log 2>&1 $CRON_TAG"

  # Check if already installed
  local already_installed=false
  if crontab -l 2>/dev/null | grep -q "$CRON_TAG"; then
    already_installed=true
  fi

  # Filter out old entry and append new one
  local tmp
  tmp=$(mktemp)
  (crontab -l 2>/dev/null || true) | { grep -v "$CRON_TAG" || true; } > "$tmp"
  echo "$cron_line" >> "$tmp"
  crontab "$tmp"
  rm -f "$tmp"
  if [[ "$already_installed" == true ]]; then
    echo "Reinstalled cron entry (minute $minute)"
  else
    echo "Installed cron entry (minute $minute)"
  fi
}

uninstall_linux() {
  local tmp
  tmp=$(mktemp)
  (crontab -l 2>/dev/null || true) | { grep -v "$CRON_TAG" || true; } > "$tmp"
  crontab "$tmp"
  rm -f "$tmp"
  echo "Uninstalled cron entry"
}

if [[ $# -lt 1 ]]; then
  usage
fi

case "$(uname -s)" in
  Darwin)
    case "$1" in
      install)   install_macos ;;
      uninstall) uninstall_macos ;;
      *)         usage ;;
    esac
    ;;
  Linux)
    case "$1" in
      install)   install_linux ;;
      uninstall) uninstall_linux ;;
      *)         usage ;;
    esac
    ;;
  *)
    echo "Unsupported platform: $(uname -s)"
    exit 1
    ;;
esac
