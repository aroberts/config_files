#!/bin/bash

git pull && \
git sup && \
source ~/.zshrc && \
vim +PlugClean +PlugUpdate +PlugInstall +qall
