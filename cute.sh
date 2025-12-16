#!/bin/sh -eu

cute() {
  local cute_usage='Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-f <file>] [-H <heading>] [-t <task_color>] [-p <prompt_color>] [-d]

Options:
  -h: Show this help message and exit
  -f: Specify the markdown file to read (default: README.md)
  -H: Specify the heading to look for (default: "##")
  -d: Enable debug mode (prints commands as they are executed)

Example:
  cute -f CONTRIBUTING.md -H "###" -d
This will read tasks from CONTRIBUTING.md with "###" headings and enable debug mode.
'

  local cute_color_success="\033[32m"
  local cute_color_error="\033[31m"
  local cute_color_prompt="\033[90m"

  local cute_target="README.md"
  local cute_heading="##"
  local cute_debug_mode=0

  while getopts "hf:H:d" opt; do
    case "$opt" in
      h) echo "$cute_usage"; return 0 ;;
      f) cute_target="$OPTARG" ;;
      H) cute_heading="$OPTARG" ;;
      d) cute_debug_mode=1 ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ ! -f "$cute_target" ]; then
    echo "File '$cute_target' does not exist."
    return 1
  fi

  local cute_tasks=$(awk -v heading="$cute_heading" -v sep="\x1f" '
    match($0, /```(sh|shell|bash|zsh)/, m) {
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
    /```/ {
      print task_name sep shell_name sep command;
      task_name = "";
      shell_name = "";
      command = "";
      next
    }
    shell_name != "" {
      command = command (command == "" ? "" : sep) $0;
      next
    }
    $0 ~ "^" heading " " {
      task_name = $0;
      sub("^" heading " ", "", task_name);
      next
    }
  ' "$cute_target")

  local cute_task_names=$(echo "$cute_tasks" | awk -F'\x1f' '{print $1}')
  local cute_task_name=$(echo "$cute_task_names" | fzf --prompt="Select a task to execute: ")
  if [ -z "$cute_task_name" ]; then
    echo "No task selected."
    return 1
  fi

  local cute_task=$(echo "$cute_tasks" | awk -F'\x1f' -v task="$cute_task_name" '$1 == task {print $0; exit}')
  local cute_shell=$(echo "$cute_task" | awk -F'\x1f' '{print $2}')
  local cute_command=$(echo "$cute_task" | cut -d$'\x1f' -f3- | sed "s/$(print '\x1f')/\n/g")
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
