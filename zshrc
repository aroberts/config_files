# antigen
source "$HOME/.zsh/antigen/antigen.zsh"
source "$HOME/.zsh/antigen-bundles.zsh"

# completion
autoload -U compinit
compinit

# automatically enter directories without cd
setopt auto_cd

# no dups in command history
setopt histignoredups

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

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# expand functions in the prompt
setopt prompt_subst

# include zsh files - handled by antigen, and causes double-sourcing of
# antigen-bundles if uncommented (see source cmd at top of file)
# for config_file ($HOME/.zsh/*.zsh) source $config_file

# tab completion for custom git scripts
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

# apply antigen bundles
antigen-apply

# enable caching of git-prompt
# ZSH_THEME_GIT_PROMPT_CACHE=1

export PS1='$(virtualenv_prompt_info)[${SSH_CONNECTION+"%n@%m:"}%~]$(git_super_status) '

export PYTHONDONTWRITEBYTECODE=1
export NOSE_REDNOSE=1

# virtualenvwrapper setup
export WORKON_HOME=$HOME/.virtualenvs

psa() {
  # TODO: is this useful? move it to an antigen plugin
  if [ ! -z $1 ] ; then
    ps aux | ack $1 | ack -v ack
  else
    ps aux
  fi
}
