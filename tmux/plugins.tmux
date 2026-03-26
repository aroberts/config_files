tmux_plugin_root='~/.tmux/tmux-plugins'

set -g @resurrect-save 'S'
set -g @resurrect-restore 'R'
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-processes 'claude'
set -g @resurrect-hook-post-save-layout '~/.tmux/scripts/resurrect-claude-save.sh'
run-shell -b '#{tmux_plugin_root}/tmux-resurrect/resurrect.tmux'

set -g @logging_key 'O'
set -g @screen-capture-key 'o'
set -g @save-complete-history-key 'C-O'

run-shell -b '#{tmux_plugin_root}/tmux-logging/logging.tmux'
run-shell -b '#{tmux_plugin_root}/tmux-yank/yank.tmux'

# auto-restore session on tmux server start
set -g @continuum-restore 'on'
run-shell -b '#{tmux_plugin_root}/tmux-continuum/continuum.tmux'

