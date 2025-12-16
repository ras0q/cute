# Cute

Cute: A CLI tool to exe"CUTE"s commands from markdown files.

## Installation

### Install as a Zsh plugin (Recommended)

```sh
antidote install ras0q/cute
```

### Install manually

You can install or update cute with a single command. This will download the script to `~/.local/share/cute/` and add the necessary configuration to your `~/.bashrc` or `~/.zshrc`.

```sh
curl -sL https://raw.githubusercontent.com/ras0q/cute/main/install.sh | sh
```

## Usage

```sh
$ source ./cute.sh && cute -h
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
```
