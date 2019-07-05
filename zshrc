# completion
fpath=('/usr/local/share/zsh/site-functions' $fpath)
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

# docker
# : ${DOCKER_VIRTUALBOX_NAME:=dockerbox}
# if [ -d "$HOME/.docker/machine/machines/$DOCKER_VIRTUALBOX_NAME" ]; then
#   eval "$(docker-machine env $DOCKER_VIRTUALBOX_NAME)"
# fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH=./.git/safe/../../bin:$PATH
export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/local/heroku/bin:$PATH

# expand functions in the prompt
setopt prompt_subst

# include zsh files - handled by antigen, and causes double-sourcing of
# antigen-bundles if uncommented
# for config_file ($HOME/.zsh/*.zsh) source $config_file

# tab completion for custom git scripts
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

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

# antigen
ANTIGEN_SRC="/usr/local/share/antigen/antigen.zsh"
if [ -e "$ANTIGEN_SRC" ]; then
  source "$ANTIGEN_SRC"
  [[ -f ~/.antigenrc ]] && source ~/.antigenrc
else
  echo "Antigen not installed, use \`brew install antigen\`"
fi

# prompt
export PS1='[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}]$(git_super_status) '
which virtualenv_prompt_info > /dev/null
if [ $? -eq 0 ]; then
  export PS1='$(virtualenv_prompt_info)$PS1'
fi

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export NOSE_REDNOSE=1

# virtualenvwrapper setup
export WORKON_HOME=$HOME/.virtualenvs

# javaaaaaaa
export JAVA_HOME=$(/usr/libexec/java_home)

# GRC aliases
GRC_CONF="`brew --prefix`/etc/grc.bashrc"
if [ -e "$GRC_CONF" ]; then
  source "$GRC_CONF"
fi

if [ -e "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

psa() {
  # TODO: is this useful? move it to an antigen plugin
  if [ ! -z $1 ] ; then
    ps aux | ag $1
  else
    ps aux
  fi
}
