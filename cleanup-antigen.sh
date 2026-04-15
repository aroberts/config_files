#!/bin/bash
# cleanup-antigen.sh — one-time cleanup for antigen → antidote migration
# Run by install.sh when antigen artifacts are detected.

CONFIG_REPO="${1:-$(cd "$(dirname "$0")" && pwd)}"

echo "Cleaning up antigen artifacts..."

# Remove dangling ~/.antigenrc symlink
if [ -L "$HOME/.antigenrc" ] && [ ! -e "$HOME/.antigenrc" ]; then
  echo "  Removing dangling ~/.antigenrc symlink"
  rm -f "$HOME/.antigenrc"
fi

# Remove stale zcompdump files (antidote/ez-compinit will recreate)
for f in "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" "$HOME/.antigen/.zcompdump" "$HOME/.antigen/.zcompdump.zwc"; do
  if [ -e "$f" ]; then
    echo "  Removing stale $f"
    rm -f "$f"
  fi
done

# Remove antigen plugin cache
if [ -d "$HOME/.antigen" ]; then
  echo "  Removing ~/.antigen/ cache"
  rm -rf "$HOME/.antigen"
fi

# Remove orphaned src/antigen directory (submodule was removed from index)
if [ -d "$CONFIG_REPO/src/antigen" ]; then
  echo "  Removing orphaned src/antigen/"
  rm -rf "$CONFIG_REPO/src/antigen"
fi

echo "Antigen cleanup complete."
