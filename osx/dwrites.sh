#!/bin/bash

# emoji substitutions in Messages.app
defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
-dict-add "automaticEmojiSubstitutionEnablediMessage" -bool true
#

# safari find using substring rather than prefix
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool FALSE

