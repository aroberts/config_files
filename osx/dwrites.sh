#!/bin/bash


# no emoji substitutions in Messages.app
defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
-dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false


