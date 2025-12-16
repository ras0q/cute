#!/bin/sh -eu

local cute_color_success="\033[32m"
local cute_color_error="\033[31m"
local cute_color_prompt="\033[90m"

_cute_usage() {
  cat <<EOF
Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-d] [-h] [-l] [TASK_NAME|SLUG ...]

Options:
  -d: Enable debug mode (prints commands as they are executed)
  -h: Show this help message and exit
  -l: List tasks

Arguments:
  TASK_NAME|SLUG: Task name or slug to execute. If specified, fuzzy search will be skipped.
                  Multiple tasks can be specified to execute them in order.

Example:
  cute -l                # List tasks
  cute build             # Execute task with slug "build"
  cute "Build Project"   # Execute task by name
  cute build test deploy # Execute multiple tasks in order
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
        print "no task specified." > "/dev/stderr";
        exit 1;
      }
      if (shell_name != "") {
        print "the previous codeblock is not closed." > "/dev/stderr";
        exit 1;
      }
      shell_name = (m[1] == "shell" ? "sh" : m[1]);
      next
    }
    /^```/ {
      if (task_name != "" && shell_name != "" && command != "") {
        slug = slugify(task_name);
        if (slug_seen[slug]++) {
          print "duplicate slug detected: " slug > "/dev/stderr";
          exit 1;
        }
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
  local cute_debug_mode=0
  local cute_list_mode=0
  while getopts "dhl" opt; do
    case "$opt" in
      d) cute_debug_mode=1 ;;
      h) _cute_usage; return 0 ;;
      l) cute_list_mode=1 ;;
    esac
  done
  shift $((OPTIND - 1))

  cute_files="$(find . -type f -name "*.md" -o -name "*.markdown" | sort)"
  cute_tasks="$(_cute_extract_tasks "$cute_files")" || return 1

  if [ $cute_list_mode -eq 1 ]; then
    echo $cute_tasks | awk -F'\x1f' '{printf "%s\t%s\t%s\t%s\n", $1, $2, $3, $4}'
    return 0
  fi

  local cute_requested_tasks="$@"
  if [ -z "$cute_requested_tasks" ]; then
    _cute_usage
    return 0
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
