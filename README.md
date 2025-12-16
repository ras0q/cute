# cute.sh

Cute: A CLI tool to exe"CUTE"s commands from markdown files.

## Usage

```sh
$ source ./cute.sh
$ cute -h
Cute: A CLI tool to exe"CUTE"s commands from markdown files.

Usage:
  cute [-h] [-f <file>] [-H <heading>] [-t <task_color>] [-p <prompt_color>] [-d]

Options:
  -h: Show this help message and exit
  -f: Specify the markdown file to read (default: README.md)
  -H: Specify the heading to look for (default: "##")
  -t: Specify the color for task output (default: "\033[32m" - green)
  -p: Specify the color for prompt output (default: "\033[90m" - gray)
  -d: Enable debug mode (prints commands as they are executed)

Example:
  cute -f CONTRIBUTING.md -H "###" -t "\033[34m" -p "\033[90m" -d
This will read tasks from CONTRIBUTING.md with "###" headings, use blue for task output, gray for prompt output, and e
nable debug mode.
```

