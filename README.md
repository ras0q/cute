# Cute

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
  -d: Enable debug mode (prints commands as they are executed)

Example:
  cute -f CONTRIBUTING.md -H "###" -d
This will read tasks from CONTRIBUTING.md with "###" headings and enable debug mode.
```

## Test

```sh
echo hello
```

## Bye

```bash
echo bye
```
