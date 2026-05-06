---
name: cute
description: Run project-defined tasks through Cute, a Markdown task runner. Use when an agent needs to list or execute repository tasks such as build, test, lint, format, check, generate, release, or deploy, and the project exposes those workflows through the `cute` command. Prefer this skill when repository policy limits command execution to Cute task invocations.
license: MIT
compatibility: Requires the `cute` command to be available in PATH or otherwise provided by the project. This skill itself does not require network access.
allowed-tools: Bash(cute:*)
metadata:
  source: "https://github.com/ras0q/cute"
  specification: "https://agentskills.io/specification"
---

# Use Cute

## Workflow

Use Cute as the execution boundary for project tasks. This skill is agent-neutral: map "run a command" to the host agent's shell-command capability, but keep the command boundary limited to Cute invocations.

1. List available tasks with `cute -l` when the requested task name or slug is not already clear.
2. Choose the matching task slug or exact heading from the list.
3. Run only `cute <task...>` or `cute -v <task...>` to execute tasks.
4. Run multiple requested tasks in one ordered invocation when order matters: `cute build test`.
5. Report the command and the relevant result.

## Command Boundary

- Allow only Cute commands such as `cute -l`, `cute test`, `cute -v test`, or `cute build test`.
- Enforce the command allowlist in the host agent or sandbox. The `allowed-tools` frontmatter is advisory because support varies between implementations.
- Do not run package-manager, build-tool, test-runner, interpreter, or deployment commands directly when a Cute task exists for the work.
- Do not recreate a Cute task body as a shell command; execute the task through Cute.
- If no matching task exists, say which task was missing and ask the user before using any non-Cute command.
- If Cute is unavailable, report that instead of substituting another command.
