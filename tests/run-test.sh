#!/bin/bash -eu

CUTE_UPDATE_SNAPSHOTS=${CUTE_UPDATE_SNAPSHOTS:-0}

TEST_DIR=$(dirname $(realpath "$BASH_SOURCE"))
CUTE_PATH=$(dirname "$TEST_DIR")/cute
STDOUT_LOG=$TEST_DIR/stdout.log
STDERR_LOG=$TEST_DIR/stderr.log

# Usage: _test [--allow-fail|-a] "test name" command [args...]
_test() {
  local allow_fail=0
  if [[ "$1" = "--allow-fail" ]]; then
    allow_fail=1
    shift
  fi

  local test_name="$1"
  shift

  echo -e "--- Running test: '$test_name' ---\n$ $*" | tee -a "$STDOUT_LOG" "$STDERR_LOG" >/dev/null

  if (
    cd "$TEST_DIR";
    . "$CUTE_PATH";
    "$@"
  ) >> "$STDOUT_LOG" 2>> "$STDERR_LOG"; then
    echo -e "--- Test '$test_name' passed. ---\n" | tee -a "$STDOUT_LOG" "$STDERR_LOG" >/dev/null
  else
    echo -e "--- Test '$test_name' failed. ---\n" | tee -a "$STDOUT_LOG" "$STDERR_LOG" >/dev/null
    if [ $allow_fail -eq 0 ]; then
      echo "Test '$test_name' failed unexpectedly. See logs for details." 1>&2
      exit 1
    fi
  fi
}


truncate -s 0 $STDOUT_LOG
truncate -s 0 $STDERR_LOG
source $TEST_DIR/../cute

# MARK: - Test cases

_test "usage" cute -h
_test "list tasks" cute -l

_test "test" cute Test
_test "h3" cute 'Cute can execute any shell code block in Markdown headings'
_test "h4" cute h4
_test "h5" cute h5
_test "h6" cute h6
_test --allow-fail "h7 (should be ignored)" cute h7

_test "Bash Shell" cute 'Bash Shell'
_test "Zsh Shell" cute 'Zsh Shell'
_test "Shell Variant" cute 'Shell Variant'

_test --allow-fail "example block should be ignored" cute 'example block'
_test "multi-line with Variables" cute multi-line-with-variables
_test "command with exit code" cute command-with-exit-code
_test --allow-fail "Quit if Error" cute 'Quit if Error'


# MARK: - Check snapshots

if [[ "$CUTE_UPDATE_SNAPSHOTS" -eq 0 ]] && ! git diff --quiet -- $STDOUT_LOG $STDERR_LOG; then
  echo "Test snapshots have changed. If the changes are expected, run the tests again with CUTE_UPDATE_SNAPSHOTS=1 to update the snapshots. Restoring logs..."
  git --no-pager diff -- $STDOUT_LOG $STDERR_LOG
  git restore -- $STDOUT_LOG $STDERR_LOG
  exit 1
fi

