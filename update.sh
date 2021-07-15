#!/bin/bash

git pull
git sup
vim +PlugClean +PlugUpdate +PlugInstall +qall
