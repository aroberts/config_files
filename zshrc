# antigen
source "$HOME/.zsh/antigen/antigen.zsh"

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

# vi mode
bindkey -v

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# expand functions in the prompt
setopt prompt_subst

source $HOME/.zsh/git-prompt/zshrc.sh

# include zsh files
for config_file ($HOME/.zsh/*.zsh) source $config_file

# tab completion for custom git scripts
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

# apply antigen bundles
antigen-apply

export PS1='$(virtualenv_prompt_info)[${SSH_CONNECTION+"%n@%m:"}%~]$(git_super_status) '

export PYTHONDONTWRITEBYTECODE=1
export NOSE_REDNOSE=1

# virtualenvwrapper setup
export WORKON_HOME=$HOME/.virtualenvs
