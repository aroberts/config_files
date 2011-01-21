# makes color constants available
autoload -U colors
colors

# SCM info for prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable NONE
zstyle ':vcs_info:*' stagedstr '{%'${fg_bold[green]}'%}•%{'${reset_color}'%}'
zstyle ':vcs_info:*' unstagedstr '{%'${fg_bold[yellow]}'%}•%{'${reset_color}'%}'
zstyle ':vcs_info:*' formats ' (%{'${fg[green]}'%}%b%c%u%{'${reset_color}'%})'


# enable colored output from ls, etc
export CLICOLOR=1

# expand functions in the prompt
setopt prompt_subst


precmd () { vcs_info }

# prompt
export PS1='[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}${vcs_info_msg_0_}] '

