#!/bin/bash

git pull && \
git sup && \
source ~/.zshrc && \
antidote update && \
vim +PlugClean +PlugUpdate +PlugInstall +qall
