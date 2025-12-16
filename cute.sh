#!/bin/sh -eu

cute() {
  local cute_usage='Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-f <file>] [-H <heading>] [-t <task_color>] [-p <prompt_color>] [-d]

Options:
  -h: Show this help message and exit
  -f: Specify the markdown file to read (default: README.md)
  -H: Specify the heading to look for (default: "##")
  -t: Specify the color for task output (default: "\\033[32m" - green)
  -p: Specify the color for prompt output (default: "\\033[90m" - gray)
  -d: Enable debug mode (prints commands as they are executed)

Example:
  cute -f CONTRIBUTING.md -H "###" -t "\\033[34m" -p "\\033[90m" -d
This will read tasks from CONTRIBUTING.md with "###" headings, use blue for task output, gray for prompt output, and enable debug mode.
'

  local cute_target="README.md"
  local cute_heading="##"
  local cute_color_task="\033[32m"
  local cute_color_error="\033[31m"
  local cute_color_prompt="\033[90m"
  local cute_debug_mode=0

  while getopts "hf:H:t:p:d" opt; do
    case "$opt" in
      h) echo "$cute_usage"; return 0 ;;
      f) cute_target="$OPTARG" ;;
      H) cute_heading="$OPTARG" ;;
      t) cute_color_task="$OPTARG" ;;
      p) cute_color_prompt="$OPTARG" ;;
      d) cute_debug_mode=1 ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ ! -f "$cute_target" ]; then
    echo "File '$cute_target' does not exist."
    return 1
  fi

  local cute_tasks=$(awk -v heading="$cute_heading" '
    $0 ~ "^" heading " " {
      if (has_code && task_name != "") print task_name;
      task_name = $0; sub("^" heading " ", "", task_name);
      has_code = 0;
      next
    }
    /```(sh|shell|bash|zsh)/ {
      has_code = 1
    }
    END {
      if (has_code && task_name != "") print task_name
    }
  ' "$cute_target")

  local cute_task=$(echo "$cute_tasks" | fzf --prompt="Select a task to execute: ")
  if [ -z "$cute_task" ]; then
    echo "No task selected."
    return 1
  fi

  local cute_shell=$(awk -v task="$cute_task" -v heading="$cute_heading" '
    BEGIN { in_task = 0; in_code = 0 }
    $0 ~ "^" heading " " {
      if ($0 ~ "^" heading " " task "$") {
        in_task = 1
      } else {
        in_task = 0
      }
      next
    }
    in_task && match($0, /```(sh|shell|bash|zsh)/, m) {
      print m[1]
      exit
    }
  ' "$cute_target")
  if [ -z "$cute_shell" ]; then
    cute_shell="sh"
  fi

  local cute_command=$(awk -v task="$cute_task" -v heading="$cute_heading" '
    BEGIN { in_task = 0; in_code = 0 }
    $0 ~ "^" heading " " {
      if ($0 ~ "^" heading " " task "$") {
        in_task = 1
      } else {
        in_task = 0
      }
      next
    }
    in_task && /```(sh|shell|bash|zsh)/ {
      in_code = 1
      next
    }
    in_task && /```/ {
      in_code = 0
      next
    }
    in_task && in_code {
      print $0
    }
  ' "$cute_target")
  if [ -z "$cute_command" ]; then
    echo "No command found for task '$cute_task'."
    return 1
  fi

  (
    if [ $cute_debug_mode -eq 1 ]; then
      printf "${cute_color_task}▶ Executing task: %s\033[0m\n" "$cute_task"
    fi

    export PS4="$(printf "${cute_color_prompt}[%s]$ \033[0m" "$cute_task")"
    script -eq -c "$cute_shell -c 'set -ux; $cute_command'" /dev/null
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
      return $exit_code
    fi

    if [ $cute_debug_mode -eq 1 ]; then
      printf "${cute_color_task}✔ Completed task: %s\033[0m\n" "$cute_task"
    fi
  )
}
