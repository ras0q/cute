# shellcheck shell=bash

_cute_bash_file="${BASH_SOURCE[0]}"
_cute_bash_dir="$(cd -- "$(dirname -- "$_cute_bash_file")" && pwd -P)" || return 1

source "$_cute_bash_dir/cute"

_cute_bash_completion() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local tasks
  tasks=$(cute -l 2>/dev/null || true)

  case "$prev" in
    cute)
      COMPREPLY=($(compgen -W "-h -l -v $tasks" -- "$cur"))
      ;;
    *)
      COMPREPLY=($(compgen -W "$tasks" -- "$cur"))
      ;;
  esac
}

complete -o bashdefault -o default -o nospace -F _cute_bash_completion cute

unset _cute_bash_file _cute_bash_dir
