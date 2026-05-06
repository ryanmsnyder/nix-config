#!/usr/bin/env bash
# WorktreeCreate hook for Claude Code.
# Reads JSON from stdin, creates the worktree, copies gitignored config files,
# and prints the worktree path to stdout (required by Claude Code's hook contract).

set -euo pipefail

INPUT=$(cat)

WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path')
SOURCE_BRANCH=$(echo "$INPUT"  | jq -r '.source_branch')
TARGET_BRANCH=$(echo "$INPUT"  | jq -r '.target_branch')
CWD=$(echo "$INPUT"            | jq -r '.cwd')

if [[ -z "$WORKTREE_PATH" || -z "$SOURCE_BRANCH" || -z "$TARGET_BRANCH" || -z "$CWD" ]]; then
  echo "worktree-create: missing required fields in hook input" >&2
  exit 1
fi

# Create the worktree using Claude's pre-computed path and branch names
git -C "$CWD" worktree add -b "$TARGET_BRANCH" "$WORKTREE_PATH" "$SOURCE_BRANCH" >&2

# Copy gitignored config files into the new tree
source "$(dirname "$0")/../lib/worktree-copy.sh"
worktree_copy_files "$CWD" "$WORKTREE_PATH"

# Required output: print the worktree path so Claude Code knows where to cd
echo "$WORKTREE_PATH"
