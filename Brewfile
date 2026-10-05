# Base packages for any Mac running config_files + scripts. Linked to
# ~/.Brewfile, so `brew bundle --global` applies it. Overlays add their own
# (overlays/*/Brewfile); setup-new-machine.sh runs all of them.

# mirrors pcrn-mgmt vars/default_packages.yml
brew "git"
brew "tmux"
brew "vim"
brew "jq"
brew "the_silver_searcher"

# config depends on these
brew "grc"     # warhol zsh plugin and GRC_CONF in zshrc do nothing without it
brew "gh"      # config/gh

# general CLI
brew "wget"
brew "watch"
brew "shellcheck"

cask "ghostty" # config/ghostty
