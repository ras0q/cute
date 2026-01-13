# Cute

A CLI tool that exeCUTEs commands from Markdown files.

![Demo](https://raw.githubusercontent.com/ras0q/cute-demo/refs/heads/main/demo.gif)

```sh
$ source <(curl -fsSL https://raw.githubusercontent.com/ras0q/cute/main/cute)
$ cute -h
Cute: A CLI tool that exeCUTEs commands from Markdown files.

Usage:
  cute [-h] [-l] [-v] [TASK_NAME|SLUG ...]

Options:
  -h: Show this help message and exit
  -l: List tasks
  -L: Limit search depth for Markdown files (default: 1)
  -v: Enable verbose mode

Arguments:
  TASK_NAME|SLUG: Task name or slug to execute. If specified, fuzzy search will be skipped.
                  Multiple tasks can be specified to execute them in order.

Example:
  cute -l                # List tasks
  cute build             # Execute task with slug "build"
  cute "Build Project"   # Execute task by name
  cute build test deploy # Execute multiple tasks in order
  cute $(cute -l | fzf)  # Fuzzy search and execute a task using fzf
```

## Features

- Pure shell script with no dependencies
- Tasks defined in Markdown files with standard code blocks
- Discovers tasks from all Markdown files in current directory
- Execute tasks written in sh, bash, zsh, or shell
- Built-in completion for bash and zsh
- No configuration required
- Opt-in adoption for teams

### Comparison with Other Task Runners

#### vs [Make](https://www.gnu.org/software/make/)

Make is a build system for managing file dependencies, not a task runner.

#### vs [npm scripts](https://docs.npmjs.com/cli/using-npm/scripts)

Cute requires no Node.js installation and uses standard Markdown instead of JSON configuration.

#### vs [Task](https://taskfile.dev)

Cute is pure shell requiring no binary installation, uses natural Markdown formatting instead of YAML, and works on any POSIX shell environment. Developers can opt-in to using the cute command without forcing adoption across the team.

#### vs [xc](https://xcfile.dev)

Cute scans all Markdown files in the project instead of a single dedicated file (e.g. README.md), and any Markdown heading becomes a task without needing a `## Tasks` section.

## Installation

### Basic Usage

Download the script to a directory in your `PATH`, e.g. `~/.local/bin`:

```sh
CUTE_PATH=~/.local/bin/cute
curl -fsSL https://raw.githubusercontent.com/ras0q/cute/main/cute -o $CUTE_PATH
chmod +x $CUTE_PATH
cute -h
```

### Execute Without Installation

Cute is a pure shell script. You can try it out **without installation**:

```sh
source <(curl -fsSL https://raw.githubusercontent.com/ras0q/cute/main/cute)
cute -h
```

### Zsh

Using a plugin manager like [antidote](https://github.com/mattmc3/antidote):

```zsh
antidote install ras0q/cute
```

Or follow the [Basic Usage](#basic-usage).

### Bash

Follow the [Basic Usage](#basic-usage).

### Fish

Using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install ras0q/cute
```

Or follow the [Basic Usage](#basic-usage).

## Acknowledgements

- [joerdav/xc: Markdown defined task runner.](https://github.com/joerdav/xc): Cute is inspired by xc, but focuses on simplicity and ease of use.
