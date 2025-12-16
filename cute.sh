#!/bin/sh -eu

local cute_color_success="\033[32m"
local cute_color_error="\033[31m"
local cute_color_prompt="\033[90m"

local cute_debug_mode=0


_cute_usage() {
  cat <<EOF
Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-d] [TASK_NAME|SLUG ...]

Options:
  -h: Show this help message and exit
  -d: Enable debug mode (prints commands as they are executed)

Arguments:
  TASK_NAME|SLUG: Task name or slug to execute. If specified, fuzzy search will be skipped.
                  Multiple tasks can be specified to execute them in order.

Example:
  cute                   # Interactive mode with fzf
  cute -d                # Enable debug mode with fzf selection
  cute build             # Execute task with slug "build"
  cute "Build Project"   # Execute task by name
  cute build test deploy  # Execute multiple tasks in order
EOF
}

_cute_extract_tasks() {
  echo "$@" | xargs awk -v sep="\x1f" '
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
  '
}

_cute_execute_task() {
  local cute_task="$@"
  local cute_task_name=$(echo "$cute_task" | awk -F'\x1f' '{print $1}')
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

cute() {
  while getopts "hd" opt; do
    case "$opt" in
      h) _cute_usage; return 0 ;;
      d) cute_debug_mode=1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local cute_files="$(find . -type f -name "*.md" -o -name "*.markdown" | sort)"
  local cute_tasks=$(_cute_extract_tasks "$cute_files")

  local cute_duplicate_slugs=$(echo "$cute_tasks" | awk -F'\x1f' '{print $2}' | sort | uniq -d)
  if [ -n "$cute_duplicate_slugs" ]; then
    echo "Duplicate task found: $cute_duplicate_slugs"
    return 1
  fi

  local cute_requested_tasks="$@"
  if [ -z "$cute_requested_tasks" ]; then
    local cute_task_names=$(echo "$cute_tasks" | awk -F'\x1f' '{print $1 "\t" $2} ')
    local cute_task_name=$(echo "$cute_task_names" | fzf --prompt="Select a task to execute: " | awk -F'\t' '{print $2}')
    if [ -z "$cute_task_name" ]; then
      echo "No task selected."
      return 1
    fi
    cute_requested_tasks="$cute_task_name"
  fi

  for cute_task_identifier in $cute_requested_tasks; do
    local cute_task=$(echo "$cute_tasks" | awk -F'\x1f' -v identifier="$cute_task_identifier" '$1 == identifier || $2 == identifier {print $0; exit}')

    if [ -z "$cute_task" ]; then
      echo "Task not found: '$cute_task_identifier'"
      return 1
    fi

    _cute_execute_task "$cute_task"
  done
}
