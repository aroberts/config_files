# from jimeh/tmux-themepack

# Status update interval
set -g status-interval 1

# Basic status bar colors
set -g status-style fg=colour238,bg=colour233

# Left side of status bar
# set -g status-left-style bg=colour233,fg=colour243
# set -g status-left-length 40
# set -g status-left "#[fg=colour232,bg=colour24,bold] #S #[fg=colour24,bg=colour240,nobold]#[fg=colour233,bg=colour240] #(whoami) #[fg=colour240,bg=colour235]#[fg=colour240,bg=colour235] #I:#P #[fg=colour235,bg=colour233,nobold]"

# Right side of status bar
# set -g status-right-style bg=colour233,fg=colour243
# set -g status-right-length 150
# set -g status-right "#[fg=colour235,bg=colour233]#[fg=colour240,bg=colour235]#[fg=colour240,bg=colour235]#[fg=colour233,bg=colour240]#[fg=colour245,bg=colour240]#[fg=colour232,bg=colour245,bold] #H "

# Window status
set -g window-status-format " #I:#W#F "
set -g window-status-current-format "#[fg=colour233,bg=black]#[fg=colour33,nobold] #I:#W #[fg=black,bg=colour233,nobold]"

# Current window status
set -g window-status-current-style bg=colour100,fg=colour235

# Window with activity status
set -g window-status-activity-style bg=colour233,fg=colour245

# Window separator
set -g window-status-separator ""

# Window status alignment
set -g status-justify left

# Pane border
set -g pane-border-style bg=default,fg=colour238

# Active pane border
set -g pane-active-border-style bg=default,fg=colour24

# Pane number indicator
set -g display-panes-colour colour233
set -g display-panes-active-colour colour245

# Clock mode
set -g clock-mode-colour colour24
set -g clock-mode-style 24

# Message
set -g message-style bg=colour24,fg=black

# Command message
set -g message-command-style bg=colour233,fg=black

# Mode
set -g mode-style bg=colour24,fg=colour231
