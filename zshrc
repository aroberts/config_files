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

export PATH=$HOME/bin:/usr/local/bin:$PATH

# expand functions in the prompt
setopt prompt_subst

source $HOME/.zsh/git-prompt/zshrc.sh
export PS1='[${SSH_CONNECTION+"%n@%m:"}%~]$(git_super_status) '

# include zsh files
for config_file ($HOME/.zsh/*.zsh) source $config_file

# tab completion for custom git scripts
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}


export PYTHONDONTWRITEBYTECODE=1

# virtualenvwrapper setup
#
# this block is a lazy-loader for workon that only runs if ~/.virtualenvs
# exists.  It defines a function (__workon_with_load) that loads the real
# workon, sets up the environment, and removes the alias we made to do the
# loading on the first invocation of workon.
export WORKON_HOME=$HOME/.virtualenvs
if [ -d $WORKON_HOME ]; then
  __workon_with_load () {
    unalias workon
    source /usr/local/bin/virtualenvwrapper.sh
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    export PIP_RESPECT_VIRTUALENV=true
    workon $1
  }
  alias workon='__workon_with_load'
  _workon_complete () {
    reply=( $( (\cd "$WORKON_HOME"; \
                for f in */bin/activate; do echo $f; done) 2>/dev/null |\
                  \sed 's|^\./||' |\
                  \sed "s|/bin/activate||" |\
                  \sort |\
                  (unset GREP_OPTIONS; \egrep -v '^\*$') ) )
  }
  compctl -K _workon_complete __workon_with_load
fi
