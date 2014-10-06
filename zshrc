# antigen
source "$HOME/.zsh/antigen/antigen.zsh"
source "$HOME/.zsh/antigen-bundles.zsh"

# completion
autoload -U compinit
compinit

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# expand functions in the prompt
setopt prompt_subst

# automatically enter directories without cd
setopt auto_cd

# configure history
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# use vim as an editor
export EDITOR=vim

# aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# rvm
if [ -e "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
fi

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/local/heroku/bin:$PATH

# expand functions in the prompt
setopt prompt_subst

# include zsh files - handled by antigen, and causes double-sourcing of
# antigen-bundles if uncommented (see source cmd at top of file)
# for config_file ($HOME/.zsh/*.zsh) source $config_file

# tab completion for custom git scripts
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

# apply antigen bundles
antigen-apply

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
# bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# Allow [ or ] whereever you want
unsetopt nomatch

# enable caching of git-prompt
# ZSH_THEME_GIT_PROMPT_CACHE=1


# prompt
export PS1='$(virtualenv_prompt_info)[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}]$(git_super_status) '

export PYTHONDONTWRITEBYTECODE=1
export NOSE_REDNOSE=1

# virtualenvwrapper setup
export WORKON_HOME=$HOME/.virtualenvs

psa() {
  # TODO: is this useful? move it to an antigen plugin
  if [ ! -z $1 ] ; then
    ps aux | ag $1
  else
    ps aux
  fi
}
