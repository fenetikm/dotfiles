#!/bin/bash
# from: https://www.builder.io/blog/claude-code-settings#4-add-a-live-status-line
input=$(cat)

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
context_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
rate_5hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_7day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

current_dir=$(basename "$cwd")

# Git branch + dirty status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
            git_info=" git:($branch)✗"
        else
            git_info=" git:($branch)"
        fi
    fi
fi

# Context usage progress bar
ctx_bar=""
ctx_color=""
total_input=$((input_tokens + cache_creation + cache_read))
if [ "$total_input" -gt 0 ] && [ -n "$context_window_size" ] && [ "$context_window_size" -gt 0 ]; then
    percentage=$(( (total_input * 100 + context_window_size / 2) / context_window_size ))
    if [ "$percentage" -lt 50 ]; then ctx_color="\\033[32m"
    elif [ "$percentage" -lt 80 ]; then ctx_color="\\033[33m"
    else ctx_color="\\033[31m"; fi

    bar_width=20
    filled=$(( (percentage * bar_width + 50) / 100 ))
    [ "$filled" -gt "$bar_width" ] && filled=$bar_width
    empty=$(( bar_width - filled ))
    bar=""
    i=0
    while [ "$i" -lt "$filled" ]; do bar="${bar}█"; i=$((i+1)); done
    i=0
    while [ "$i" -lt "$empty" ]; do bar="${bar}░"; i=$((i+1)); done
    # ctx_bar="[${bar}] ${percentage}%"
    ctx_bar="Ctx:${percentage}%"
fi

rate_info=""
if [ -n "$rate_5hr" ]; then
    rate_5hr_int=$(printf "%.0f" "$rate_5hr")
    if [ -n "$rate_7day" ]; then
        rate_7day_int=$(printf "%.0f" "$rate_7day")
        rate_info=" 5h:${rate_5hr_int}% 7d:${rate_7day_int}%"
    else
        rate_info=" 5h:${rate_5hr_int}%"
    fi
fi

# printf "\\033[36m%s\\033[0m" "$current_dir"
[ -n "$git_info" ] && printf "\\033[0m%s\\033[0m" "$git_info"
[ -n "$ctx_bar" ] && printf "${ctx_color}%s\\033[0m" "$ctx_bar"
[ -n "$rate_info" ] && printf "\\033[0m%s\\033[0m" "$rate_info"
[ -n "$model" ] && printf " \\033[0m[%s] " "$model"
