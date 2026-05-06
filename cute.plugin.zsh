# shellcheck shell=zsh

_cute_plugin_file="${(%):-%N}"
_cute_plugin_dir="${_cute_plugin_file:A:h}"

source "$_cute_plugin_dir/cute"

_cute_zsh_completion() {
  local -a tasks
  tasks=("${(@f)$(cute -l 2>/dev/null || true)}")

  _arguments -C \
    '-h[Show help message]' \
    '-l[List tasks]' \
    '-L=[Limit search depth for Markdown files]:depth:' \
    '-v[Enable verbose mode]' \
    "*::task:($tasks)"
}

if command -v compdef >/dev/null 2>&1; then
  compdef _cute_zsh_completion cute
fi

unset _cute_plugin_file _cute_plugin_dir
