#!/usr/bin/env bash
# WorktreeRemove hook for Claude Code.
# Reads JSON from stdin, removes the worktree directory, conditionally deletes
# the branch (only if zero commits ahead of origin/HEAD), and logs the action.
# Exit code is ignored by Claude Code — this hook cannot block removal.

INPUT=$(cat)

WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path')
CWD=$(echo "$INPUT"           | jq -r '.cwd')

LOG="$HOME/.claude/worktree.log"

_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

if [[ -z "$WORKTREE_PATH" || -z "$CWD" ]]; then
  _log "ERROR worktree-remove: missing worktree_path or cwd in hook input"
  exit 0
fi

# Capture branch name before the directory is gone
BRANCH=$(git -C "$WORKTREE_PATH" branch --show-current 2>/dev/null || true)

# Remove the worktree directory
if ! git -C "$CWD" worktree remove --force "$WORKTREE_PATH" 2>/dev/null; then
  _log "WARN  worktree-remove: git worktree remove failed for $WORKTREE_PATH (may already be gone)"
fi

# Conditionally delete the branch
if [[ -n "$BRANCH" ]]; then
  # Resolve the repo's default remote branch (fall back to origin/main)
  DEFAULT=$(git -C "$CWD" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo "origin/main")

  AHEAD=$(git -C "$CWD" rev-list --count "${DEFAULT}..${BRANCH}" 2>/dev/null || echo "unknown")

  if [[ "$AHEAD" == "0" ]]; then
    git -C "$CWD" branch -D "$BRANCH" 2>/dev/null || true
    _log "REMOVED path=$WORKTREE_PATH branch=$BRANCH (0 commits ahead of $DEFAULT)"
  else
    _log "REMOVED path=$WORKTREE_PATH branch=$BRANCH preserved — $AHEAD commit(s) ahead of $DEFAULT"
  fi
else
  _log "REMOVED path=$WORKTREE_PATH (branch unknown — detached HEAD or already removed)"
fi

exit 0
