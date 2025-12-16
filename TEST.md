# Test Cases for Cute

## Simple Command

```sh
echo "test output"
```

## Multiple Commands

```sh
echo "first"
echo "second"
```

## Bash Shell

```bash
echo "bash test"
```

## Zsh Shell

```zsh
echo "zsh test"
```

## Shell Variant

```shell
echo "shell variant test"
```

## Example Block (Should Be Ignored)

```sh
$ echo "This should not execute"
This should not execute
```

## Multi-line with Variables

```sh
VAR="value"
echo "Variable: $VAR"
```

## Command with Exit Code

```sh
exit 0
```

