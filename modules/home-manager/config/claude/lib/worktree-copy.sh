#!/usr/bin/env bash
# Shared helper: copy gitignored config files from a repo into a new worktree.
# Usage: source this file, then call: worktree_copy_files <source_repo> <dest_worktree>

worktree_copy_files() {
  local src="$1"
  local dest="$2"

  if [[ -z "$src" || -z "$dest" ]]; then
    echo "worktree_copy_files: missing arguments" >&2
    return 1
  fi

  # Default set of env/config files to copy if they exist and are gitignored
  local defaults=(
    .env
    .env.local
    .env.development
    .env.test
    .env.production
    .envrc
  )

  local copied=0

  _copy_if_ignored() {
    local file="$1"
    local src_path="$src/$file"
    local dest_path="$dest/$file"

    [[ -f "$src_path" ]] || return 0

    # Only copy if git considers it ignored (never duplicate tracked files)
    if git -C "$src" check-ignore -q "$file" 2>/dev/null; then
      mkdir -p "$(dirname "$dest_path")"
      cp "$src_path" "$dest_path"
      echo "worktree: copied $file" >&2
      (( copied++ ))
    fi
  }

  for f in "${defaults[@]}"; do
    _copy_if_ignored "$f"
  done

  # Per-repo allowlist: .claude/worktree-include (gitignore syntax, # comments ok)
  local include_file="$src/.claude/worktree-include"
  if [[ -f "$include_file" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      # Skip blank lines and comments
      [[ -z "$line" || "$line" == \#* ]] && continue
      _copy_if_ignored "$line"
    done < "$include_file"
  fi

  if (( copied == 0 )); then
    echo "worktree: no gitignored config files found to copy" >&2
  fi
}
