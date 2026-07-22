---
name: cute
description: Discover and run repository tasks defined in Markdown with Cute. Use when asked to build, test, lint, format, type-check, validate, or run another documented project task with Cute.
compatibility: Requires a POSIX shell and either `cute` on PATH or `npx` with network access. The agent must be permitted to execute shell commands and download the npm package when Cute is not installed.
---

# Cute

Use Cute as the execution boundary for repository tasks. Do not interpret or reproduce a Markdown task body in the shell.

## Run tasks

1. Run [`scripts/run-cute.sh`](scripts/run-cute.sh) from the repository root. It uses `cute` on `PATH`, or downloads and runs `@ras0q/cute` with `npx --yes` when Cute is not installed.
2. Discover task slugs with `scripts/run-cute.sh -l`.
3. Execute one task with `scripts/run-cute.sh <slug-or-heading>`. Add `-v` when command tracing is needed.
4. Pass multiple task slugs in the required order, for example `scripts/run-cute.sh build test`.

## Boundaries

- Never recreate a Cute task body or invoke its underlying commands directly.
- If Cute cannot be run because `npx` is unavailable or the package download fails, report the launcher's error and ask the user how to proceed.
- If a requested task is absent, report the available task slugs and ask before using a non-Cute command.
