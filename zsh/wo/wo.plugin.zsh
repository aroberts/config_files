wo () {
  local -a targets
  targets=("$HOME/Source")
  if [[ -z $1 ]]; then
    ( for t in $targets; do
      \ls -d "$t"/*/ | xargs -n 1 basename
    done ) | sort
  else
    for t in $targets; do
      local dir="$t/$1"
      if [[ -d $dir ]]; then
        cd -P $dir
        return 0
      fi
    done
  fi
}
