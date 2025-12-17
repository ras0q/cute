# Cute

A CLI tool to exe"CUTE"s commands from markdown files.

![Demo](./demo/demo.gif)

```sh
$ source ./cute.sh && cute -h
Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-l] [-v] [TASK_NAME|SLUG ...]

Options:
  -h: Show this help message and exit
  -l: List tasks
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

### Zsh

Using a plugin manager like [antidote](https://github.com/mattmc3/antidote):

```zsh
antidote install ras0q/cute
```

Or add to your `~/.zshrc`:

```zsh
# In ~/.zshrc

# Cute
CUTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cute"
if [ ! -d "$CUTE_DIR" ]; then
  git clone https://github.com/ras0q/cute "$CUTE_DIR"
fi
source "$CUTE_DIR/cute"
```

### Bash

Add to your `~/.bashrc`:

```bash
# In ~/.bashrc

# Cute
CUTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cute"
if [ ! -d "$CUTE_DIR" ]; then
  git clone https://github.com/ras0q/cute "$CUTE_DIR"
fi
source "$CUTE_DIR/cute"
```

### Fish

Using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install ras0q/cute
```

Or install the function manually:

```fish
set -l cute_functions_dir ~/.config/fish/functions
mkdir -p $cute_functions_dir
curl -fsSL https://raw.githubusercontent.com/ras0q/cute/main/functions/cute.fish -o $cute_functions_dir/cute.fish
```

The `cute` command will automatically download the script on first use.

## Acknowledgements

- [joerdav/xc: Markdown defined task runner.](https://github.com/joerdav/xc): Cute is inspired by xc, but focuses on simplicity and ease of use.
