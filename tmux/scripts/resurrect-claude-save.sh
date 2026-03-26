#!/usr/bin/env bash
# Post-save-layout hook for tmux-resurrect
# Rewrites Claude pane entries in the save file so resurrect can restore them
# with `claude --resume <session_id>`

SAVE_FILE="$1"
[ -z "$SAVE_FILE" ] && exit 0

# Collect pane → session_id mapping from tmux pane options
tmux list-panes -a -F "#{session_name}	#{window_index}	#{pane_index}	#{@claude_session_id}	#{@claude_config_dir}" |
  while IFS=$'\t' read -r sess win pane sid cdir; do
    [ -z "$sid" ] && continue

    # Build restore command
    cmd="claude --resume $sid"
    [ -n "$cdir" ] && cmd="CLAUDE_CONFIG_DIR=$cdir $cmd"

    # Replace field 11 (full_command) for the matching pane line
    # Save file format: pane<tab>session<tab>window<tab>...<tab>pane_index(field7)<tab>...<tab>:full_command(field11)
    awk -v sess="$sess" -v win="$win" -v pane="$pane" -v cmd="$cmd" \
      'BEGIN{FS=OFS="\t"} $1=="pane" && $2==sess && $3==win && $7==pane { $11=":"cmd } 1' \
      "$SAVE_FILE" > "${SAVE_FILE}.tmp" && mv "${SAVE_FILE}.tmp" "$SAVE_FILE"
  done
