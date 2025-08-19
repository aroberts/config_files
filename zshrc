local local_install_prefix=/usr/local

# brew detection and setup
which brew &>/dev/null
if [ $? -eq 0 ]; then
  local local_install_prefix=`brew --prefix`
fi

# completion
autoload -Uz compinit
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

__SUDOCMD="sudo"

if [ -e "$HOME/.zshrc.vars" ]; then
  source "$HOME/.zshrc.vars"
fi

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
export PATH=$HOME/bin:"$local_install_prefix/sbin":"$local_install_prefix"/bin:$HOME/.local/bin:$PATH

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
bindkey -s "^T" "^[I$__SUDOCMD ^[A" # "t" for "toughguy"

# Allow [ or ] whereever you want
unsetopt nomatch

# prompt
export PS1='[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}]$(git_super_status) '
which virtualenv_prompt_info > /dev/null
if [ $? -eq 0 ]; then
  export PS1='$(virtualenv_prompt_info)$PS1'
fi
export RPROMPT='%{$fg[white]%}%T%{$reset_color%}'

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export NOSE_REDNOSE=1

# virtualenvwrapper setup
export WORKON_HOME=$HOME/.virtualenvs

# color stuff
if [ $TERM == "xterm" ]; then
  export TERM=xterm-256color
fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# because now apparently we have to fight slack :(
export SLACK_DEVELOPER_MENU=true

# antigen
ANTIGEN_SRC="$HOME/.src/antigen/antigen.zsh"

# mac stuff
uname | grep Darwin >/dev/null
if [ $? -eq 0 ]; then
  # javaaaaaaa
  export JAVA_HOME=$(/usr/libexec/java_home)
  # no dock icon for java procs
  export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"

  # GRC aliases
  GRC_CONF="`brew --prefix`/etc/grc.bashrc"
fi

random_string () {
  len=${1:=20}
  openssl rand -base64 $(( $len * 2 )) | tr '\n' '=' | sed 's/[\/+=]*//g' | head -c $len
}

keepdir () {
  for var in "$@"
  do
    mkdir -p $var && touch $var/.gitkeep
  done
}

####### Config should go above this line so .zshrc.local can override it ######


if [ -e "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

if [ -e "$ANTIGEN_SRC" ]; then
  source "$ANTIGEN_SRC"
  [[ -f ~/.antigenrc ]] && source ~/.antigenrc
fi

if [ -e "$GRC_CONF" ]; then
  source "$GRC_CONF"
fi
