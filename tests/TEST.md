# Test Cases for Cute

## Test

```sh
echo "first"
echo "second"
```

### Cute can execute any shell code block in Markdown headings

```sh
echo "h3 test"
```

#### h4

```sh
echo "h4 test"
```

##### h5

```sh
echo "h5 test"
```

###### h6

```sh
echo "h6 test"
```

####### h7

This command should be ignored.

```sh
echo "h7 test"
```

## Bash Shell

```bash
echo "bash test"
echo "$BASH_VERSION"
```

## Zsh Shell

```zsh
echo "zsh test"
echo "$ZSH_VERSION"
```

## Shell Variant

```shell
echo "shell variant test"
```

## Example Block

This command should Be Ignored

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

## Quit if Error

```sh
false
echo "This should not be executed"
```
