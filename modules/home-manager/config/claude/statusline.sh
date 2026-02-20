#!/bin/bash
# Catppuccin Mocha Status Line with Enhanced Git Status

# Catppuccin Mocha Colors
MAUVE="\033[38;2;203;166;247m"
LAVENDER="\033[38;2;180;190;254m"
BLUE="\033[38;2;137;180;250m"
SAPPHIRE="\033[38;2;116;199;236m"
TEAL="\033[38;2;148;226;213m"
GREEN="\033[38;2;166;227;161m"
YELLOW="\033[38;2;249;226;175m"
PEACH="\033[38;2;250;179;135m"
RED="\033[38;2;243;139;168m"
PINK="\033[38;2;245;194;231m"
SUBTEXT0="\033[38;2;166;173;200m"
TEXT="\033[38;2;205;214;244m"
RESET="\033[0m"

# Icons
ICON_ROBOT="󱜚"
ICON_FOLDER="󰉋"
ICON_GIT_BRANCH=""
ICON_TOKENS=""
ICON_DOLLAR="💰"
ICON_PLUS="+"
ICON_MINUS="-"
ICON_SEPARATOR="|"

ICON_AHEAD="🏎️💨"
ICON_BEHIND="🐢"
ICON_CONFLICTED="⚔️"
ICON_DELETED="🗑️"
ICON_DIVERGED="🔱"
ICON_MODIFIED="📝"
ICON_RENAMED="📛"
ICON_STAGED="🗃️"
ICON_STASHED="📦"
ICON_UNTRACKED="🛤️"

# Read JSON input
input=$(cat)

# Extract values
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
MODEL_ID=$(echo "$input" | jq -r '.model.id // ""')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
DIR_NAME="${DIR##*/}"
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# ============================================================================
# CONTEXT CALCULATION (Using Claude's used_percentage)
# ============================================================================

# Extract context window size (defaults to 200K if not available)
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Get Claude's official used percentage
USED_PERCENT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Get current tokens for display (input + cache tokens, matching Claude's formula)
CURRENT_TOKENS=$(echo "$input" | jq -r '
    if .context_window.current_usage then
        ((.context_window.current_usage.input_tokens // 0) +
         (.context_window.current_usage.cache_creation_input_tokens // 0) +
         (.context_window.current_usage.cache_read_input_tokens // 0))
    else
        0
    end
')

# Ensure CURRENT_TOKENS is a valid number
if ! [[ "$CURRENT_TOKENS" =~ ^[0-9]+$ ]]; then
    CURRENT_TOKENS=0
fi

# Check if we have context data
HAS_CONTEXT_DATA=false
if [ "$USED_PERCENT" -gt 0 ] || [ "$CURRENT_TOKENS" -gt 0 ]; then
    HAS_CONTEXT_DATA=true
fi

# Color coding based on used percentage
CONTEXT_COLOR="${GREEN}"
if [ "$USED_PERCENT" -ge 90 ]; then
    CONTEXT_COLOR="${RED}"
elif [ "$USED_PERCENT" -ge 70 ]; then
    CONTEXT_COLOR="${YELLOW}"
elif [ "$USED_PERCENT" -ge 50 ]; then
    CONTEXT_COLOR="${PEACH}"
fi

# ============================================================================
# COST TRACKING (Today + This Week via ccusage)
# ============================================================================

# Check if ccusage is available
CCUSAGE_AVAILABLE=false
if command -v ccusage >/dev/null 2>&1; then
    CCUSAGE_AVAILABLE=true
fi

TODAY_COST="0"
WEEK_COST="0"

if [ "$CCUSAGE_AVAILABLE" = true ]; then
    # Calculate date ranges (ccusage needs YYYYMMDD format, not YYYY-MM-DD)
    TODAY=$(date +%Y%m%d)
    TODAY_DISPLAY=$(date +%Y-%m-%d)

    # Get the start of this week (Monday) in YYYYMMDD format
    # If today is Monday, use today; otherwise get last Monday
    DAY_OF_WEEK=$(date +%u)
    if [ "$DAY_OF_WEEK" -eq 1 ]; then
        # Today is Monday
        WEEK_START=$(date +%Y%m%d)
    else
        # Try GNU date first (works on most Linux), then fall back to BSD date syntax (macOS)
        if date -d "2026-01-01" +%Y >/dev/null 2>&1; then
            # GNU date
            WEEK_START=$(date -d "last monday" +%Y%m%d)
        else
            # BSD date (macOS)
            WEEK_START=$(date -v-Mon +%Y%m%d)
        fi
    fi

    # Use ccusage to get daily costs for the last 7 days
    # Get daily cost data (last 7 days) in JSON format
    DAILY_DATA=$(ccusage daily --since "$WEEK_START" --json 2>/dev/null)

    if [ -n "$DAILY_DATA" ]; then
        # Extract today's cost (ccusage returns dates in YYYY-MM-DD format in JSON)
        TODAY_COST=$(echo "$DAILY_DATA" | jq -r --arg today "$TODAY_DISPLAY" '
            [.daily[] | select(.date == $today) | .totalCost // 0] | add // 0
        ' 2>/dev/null)

        # Calculate week's total cost (sum all days from week start)
        WEEK_COST=$(echo "$DAILY_DATA" | jq -r '
            [.daily[] | .totalCost // 0] | add // 0
        ' 2>/dev/null)

        # Format costs
        TODAY_COST=$(printf "%.2f" "$TODAY_COST" 2>/dev/null || echo "0")
        WEEK_COST=$(printf "%.2f" "$WEEK_COST" 2>/dev/null || echo "0")
    fi
else
    # Fallback: Try to get costs from Claude project transcripts
    CLAUDE_PROJECTS_DIR="$HOME/.claude/projects"
    TODAY=$(date +%Y-%m-%d)

    # Get the start of this week (Monday)
    # If today is Monday, use today; otherwise get last Monday
    DAY_OF_WEEK=$(date +%u)
    if [ "$DAY_OF_WEEK" -eq 1 ]; then
        # Today is Monday
        WEEK_START=$(date +%Y-%m-%d)
    else
        # Try GNU date first (works on most Linux), then fall back to BSD date syntax (macOS)
        if date -d "2026-01-01" +%Y >/dev/null 2>&1; then
            # GNU date
            WEEK_START=$(date -d "last monday" +%Y-%m-%d)
        else
            # BSD date (macOS)
            WEEK_START=$(date -v-Mon +%Y-%m-%d)
        fi
    fi

    # Try to get costs from all project transcripts
    if [ -d "$CLAUDE_PROJECTS_DIR" ]; then
        # Get today's cost
        DAILY_COST=$(find "$CLAUDE_PROJECTS_DIR" -name "transcript.json" -type f -print0 2>/dev/null | \
            xargs -0 jq -r --arg today "$TODAY" '
                [.usage[]? | select(.timestamp // "" | startswith($today)) | .cost_usd // 0] | add // 0
            ' 2>/dev/null | \
            awk '{s+=$1} END {printf "%.4f", s+0}')

        # Get this week's cost
        WEEKLY_COST=$(find "$CLAUDE_PROJECTS_DIR" -name "transcript.json" -type f -print0 2>/dev/null | \
            xargs -0 jq -r --arg week_start "$WEEK_START" '
                [.usage[]? | select((.timestamp // "") >= $week_start) | .cost_usd // 0] | add // 0
            ' 2>/dev/null | \
            awk '{s+=$1} END {printf "%.4f", s+0}')

        TODAY_COST=${DAILY_COST:-0}
        WEEK_COST=${WEEKLY_COST:-0}
    else
        # Last resort: Use session cost from JSON input
        SESSION_COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
        TODAY_COST=$SESSION_COST
        WEEK_COST=$SESSION_COST
    fi
fi

# ============================================================================
# GIT STATUS
# ============================================================================

GIT=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_STATUS=$(git status --porcelain 2>/dev/null)
        
        STAGED_COUNT=$(echo "$GIT_STATUS" | grep -c "^[MADRC]" 2>/dev/null || echo "0")
        MODIFIED_COUNT=$(echo "$GIT_STATUS" | grep -c "^ M" 2>/dev/null || echo "0")
        DELETED_COUNT=$(echo "$GIT_STATUS" | grep -c "^ D" 2>/dev/null || echo "0")
        UNTRACKED_COUNT=$(echo "$GIT_STATUS" | grep -c "^??" 2>/dev/null || echo "0")
        RENAMED_COUNT=$(echo "$GIT_STATUS" | grep -c "^R" 2>/dev/null || echo "0")
        CONFLICTED_COUNT=$(echo "$GIT_STATUS" | grep -c "^UU\|^AA\|^DD" 2>/dev/null || echo "0")
        
        STASHED_COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
        
        UPSTREAM=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if [ -n "$UPSTREAM" ]; then
            AHEAD_COUNT=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
            BEHIND_COUNT=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
        else
            AHEAD_COUNT="0"
            BEHIND_COUNT="0"
        fi
        
        IS_DIVERGED=false
        [ "$AHEAD_COUNT" -gt 0 ] && [ "$BEHIND_COUNT" -gt 0 ] && IS_DIVERGED=true
        
        # Build status string with spaces between elements
        GIT_STATUS_STR=""
        [ "$CONFLICTED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_CONFLICTED} "
        [ "$STAGED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_STAGED}×${STAGED_COUNT} "
        [ "$MODIFIED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_MODIFIED}×${MODIFIED_COUNT} "
        [ "$DELETED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_DELETED}×${DELETED_COUNT} "
        [ "$RENAMED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_RENAMED}×${RENAMED_COUNT} "
        [ "$UNTRACKED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_UNTRACKED}×${UNTRACKED_COUNT} "
        [ "$STASHED_COUNT" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${ICON_STASHED} "

        # Trim trailing space
        GIT_STATUS_STR="${GIT_STATUS_STR% }"
        
        # Build ahead/behind string without trailing spaces
        AHEAD_BEHIND_STR=""
        if [ "$IS_DIVERGED" = true ]; then
            AHEAD_BEHIND_STR="${ICON_DIVERGED}${ICON_AHEAD}×${AHEAD_COUNT}${ICON_BEHIND}×${BEHIND_COUNT}"
        elif [ "$AHEAD_COUNT" -gt 0 ]; then
            AHEAD_BEHIND_STR="${ICON_AHEAD}×${AHEAD_COUNT}"
        elif [ "$BEHIND_COUNT" -gt 0 ]; then
            AHEAD_BEHIND_STR="${ICON_BEHIND}×${BEHIND_COUNT}"
        fi
        
        # Build git string with proper spacing (spaces only between elements)
        GIT="${PINK}${ICON_GIT_BRANCH} ${BRANCH}${RESET}"
        [ -n "$GIT_STATUS_STR" ] && GIT="${GIT} ${TEXT}${GIT_STATUS_STR}${RESET}"
        [ -n "$AHEAD_BEHIND_STR" ] && GIT="${GIT} ${TEXT}${AHEAD_BEHIND_STR}${RESET}"
    fi
fi

# ============================================================================
# BUILD STATUS LINE
# ============================================================================

STATUS="${MAUVE}${ICON_ROBOT}${RESET} ${LAVENDER}${MODEL}${RESET}"
STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${PEACH}${ICON_FOLDER}${RESET} ${SAPPHIRE}${DIR_NAME}${RESET}"

# Add git branch on same line
if [ -n "$GIT" ]; then
    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${GIT}"
fi

# Display context - show waiting message if no data yet
if [ "$HAS_CONTEXT_DATA" = true ]; then
    # Format current tokens
    if [ "$CURRENT_TOKENS" -ge 1000000 ]; then
        TOKENS_DISPLAY=$(awk "BEGIN {printf \"%.1fM\", $CURRENT_TOKENS/1000000}")
    elif [ "$CURRENT_TOKENS" -ge 1000 ]; then
        TOKENS_DISPLAY=$(awk "BEGIN {printf \"%.0fK\", $CURRENT_TOKENS/1000}")
    else
        TOKENS_DISPLAY="${CURRENT_TOKENS}"
    fi

    # Format context window size
    if [ "$CONTEXT_SIZE" -ge 1000000 ]; then
        CONTEXT_DISPLAY=$(awk "BEGIN {printf \"%.0fM\", $CONTEXT_SIZE/1000000}")
    else
        CONTEXT_DISPLAY=$(awk "BEGIN {printf \"%.0fK\", $CONTEXT_SIZE/1000}")
    fi

    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${TEAL}${ICON_TOKENS}${RESET} ${CONTEXT_COLOR}${TOKENS_DISPLAY}/${CONTEXT_DISPLAY} (${USED_PERCENT}%)${RESET}"
else
    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${TEAL}${ICON_TOKENS}${RESET} ${SUBTEXT0}(no msgs yet)${RESET}"
fi

# ============================================================================
# DISPLAY COSTS (Today + This Week)
# ============================================================================

# Display both today and weekly costs
if [ "$TODAY_COST" != "null" ] && [ "$TODAY_COST" != "0" ] && [ -n "$TODAY_COST" ]; then
    FORMATTED_TODAY=$(printf "%.2f" "$TODAY_COST")
    FORMATTED_WEEK=$(printf "%.2f" "$WEEK_COST")
    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${PINK}${ICON_DOLLAR}${FORMATTED_TODAY}/${FORMATTED_WEEK} (today/week)${RESET}"
elif [ "$WEEK_COST" != "null" ] && [ "$WEEK_COST" != "0" ] && [ -n "$WEEK_COST" ]; then
    # Fallback: if today is 0 but week has cost, show just week
    FORMATTED_WEEK=$(printf "%.2f" "$WEEK_COST")
    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${PINK}${ICON_DOLLAR}${FORMATTED_WEEK} (week)${RESET}"
fi

if [ "$LINES_ADDED" != "null" ] && [ "$LINES_ADDED" != "0" ] && [ -n "$LINES_ADDED" ]; then
    STATUS="${STATUS} ${SUBTEXT0}${ICON_SEPARATOR}${RESET} ${GREEN}${ICON_PLUS}${LINES_ADDED}${RESET}"
fi
if [ "$LINES_REMOVED" != "null" ] && [ "$LINES_REMOVED" != "0" ] && [ -n "$LINES_REMOVED" ]; then
    STATUS="${STATUS} ${RED}${ICON_MINUS}${LINES_REMOVED}${RESET}"
fi

echo -e "$STATUS"