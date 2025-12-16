#!/bin/sh -eu

cute() {
  local cute_usage='Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-d]

Options:
  -h: Show this help message and exit
  -d: Enable debug mode (prints commands as they are executed)

Example:
  cute -d
This will enable debug mode.
'

  local cute_color_success="\033[32m"
  local cute_color_error="\033[31m"
  local cute_color_prompt="\033[90m"

  local cute_debug_mode=0

  while getopts "hd" opt; do
    case "$opt" in
      h) echo "$cute_usage"; return 0 ;;
      d) cute_debug_mode=1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local cute_files="$(find . -type f -name "*.md" -o -name "*.markdown" | sort)"
  local cute_tasks=$(echo "$cute_files" | xargs awk -v sep="\x1f" '
    function slugify(str) {
      gsub(/[^a-zA-Z0-9]+/, "-", str)
      str = tolower(str)
      gsub(/^-+|-+$/, "", str)
      return str
    }
    match($0, /^```(sh|shell|bash|zsh)/, m) {
      if (task_name == "") {
        print "no task specified.";
        exit 1;
      }
      if (shell_name != "") {
        print "the previous codeblock is not closed."
        exit 1;
      }
      shell_name = (m[1] == "shell" ? "sh" : m[1]);
      next
    }
    /^```/ {
      if (task_name != "" && shell_name != "" && command != "") {
        slug = slugify(task_name);
        print task_name sep slug sep shell_name sep command;
      }
      task_name = "";
      shell_name = "";
      command = "";
      next
    }
    /^\$/ {
      # Lines starting with "$" are considered as example command blocks,
      # representing command execution and its result, not as tasks to execute.
      if (shell_name != "") {
        task_name = "";
        shell_name = "";
        command = "";
      }
      next
    }
    shell_name != "" {
      command = command (command == "" ? "" : sep) $0;
      next
    }
    match($0, /^#{1,6} (.+)/, m) {
      task_name = m[1];
      next
    }
  ')

  local cute_task_names=$(echo "$cute_tasks" | awk -F'\x1f' '{print $1 " (" $2 ")"} ')
  local cute_duplicate_slugs=$(echo "$cute_tasks" | awk -F'\x1f' '{print $2}' | uniq -d)
  if [ -n "$cute_duplicate_slugs" ]; then
    echo "Duplicate task found: $cute_duplicate_slugs"
    return 1
  fi

  local cute_task_name=$(echo "$cute_task_names" | fzf --prompt="Select a task to execute: ")
  if [ -z "$cute_task_name" ]; then
    echo "No task selected."
    return 1
  fi

  local cute_task=$(echo "$cute_tasks" | awk -F'\x1f' -v task="$cute_task_name" '$1 " (" $2 ")" == task {print $0; exit}')
  local cute_shell=$(echo "$cute_task" | awk -F'\x1f' '{print $3}')
  local cute_command=$(echo "$cute_task" | cut -d$'\x1f' -f4- | sed "s/$(print '\x1f')/\n/g")
  if [ -z "$cute_command" ]; then
    echo "No command found for task '$cute_task_name'."
    return 1
  fi

  (
    if [ $cute_debug_mode -eq 1 ]; then
      printf "${cute_color_success}▶ Executing task: %s\033[0m\n" "$cute_task_name"
    fi

    export PS4="$(printf "${cute_color_prompt}[%s]$ \033[0m" "$cute_task_name")"
    script -eq -c "$cute_shell -c 'set -ux; $cute_command'" /dev/null
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
      return $exit_code
    fi

    if [ $cute_debug_mode -eq 1 ]; then
      printf "${cute_color_success}✔ Completed task: %s\033[0m\n" "$cute_task_name"
    fi
  )
}
