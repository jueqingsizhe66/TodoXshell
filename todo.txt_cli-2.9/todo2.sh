# todo-txt completion
_todotxtcli() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local pre="${COMP_WORDS[COMP_CWORD-1]}"
  local cst="${COMP_WORDS[COMP_CWORD-2]}_${COMP_WORDS[COMP_CWORD-1]}"
#  echo "start--->"
#  echo $cur
#  echo $pre
#  echo $cst
#  echo "end-->"
  case $pre in
    mit )
      COMPREPLY=( $(compgen -W "today tomorrow monday tuesday wednesday thursday friday saturday sunday january february march april may june july august september october november december" -- $cur) )
      ;;
    * )
      if [[ $cst =~ ^mv_[0-9]+$ ]]; then
        COMPREPLY=( $(compgen -W "today tomorrow monday tuesday wednesday thursday friday saturday sunday january february march april may june july august september october november december" -- $cur) )
      else
        COMPREPLY=( $(compgen -W "mit `eval todo.sh lsprj` `eval todo.sh lsc`" -- $cur) )
      fi
      ;;
  esac
#  echo $COMPREPLY
}
complete -F _todotxtcli t
