#!/bin/bash
input=$(cat)

COLOR_OK="\\033[32m"
COLOR_WARNING="\\033[33m"
COLOR_CRITICAL="\\033[31m"
COLOR_RESET="\\033[0m"

extract_data() {
    cwd=$(echo "$input" | jq -r '.workspace.current_dir')
    model=$(echo "$input" | jq -r '.model.display_name // empty')
    input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
    cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
    cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
    context_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
    rate_5hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
    rate_7day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
}

get_display_dir() {
    local dir="$cwd"
    [ "${#dir}" -gt 25 ] && dir="…${dir: -24}"
    echo "$dir"
}

get_git_info() {
    if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
        local branch
        branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
            if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
                echo " git:($branch)✗ "
            else
                echo " git:($branch)"
            fi
        fi
    fi
}

get_ctx() {
    local total_input=$(( input_tokens + cache_creation + cache_read ))
    [ "$total_input" -le 0 ] && return

    local tenths=$(( (total_input + 50) / 100 ))
    local tokens_k="$(( tenths / 10 )).$(( tenths % 10 ))"
    local ctx_color="$COLOR_OK"
    if [ -n "$context_window_size" ] && [ "$context_window_size" -gt 0 ]; then
        local percentage=$(( (total_input * 100 + context_window_size / 2) / context_window_size ))
        if [ "$percentage" -lt 20 ]; then
          ctx_color="$COLOR_OK"
        elif [ "$percentage" -lt 40 ]; then
          ctx_color="$COLOR_WARNING"
        else
          ctx_color="$COLOR_CRITICAL"
        fi
    fi

    printf "${ctx_color}${tokens_k}k${COLOR_RESET}"
}

rate_color() {
    local pct=$1
    if [ "$pct" -lt 50 ]; then printf "$COLOR_RESET"
    elif [ "$pct" -lt 80 ]; then printf "$COLOR_WARNING"
    else printf "$COLOR_CRITICAL"; fi
}

get_rate_info() {
    [ -z "$rate_5hr" ] && return
    local rate_5hr_int
    rate_5hr_int=$(printf "%.0f" "$rate_5hr")
    local color_5hr
    color_5hr=$(rate_color "$rate_5hr_int")
    if [ -n "$rate_7day" ]; then
        local rate_7day_int color_7day
        rate_7day_int=$(printf "%.0f" "$rate_7day")
        color_7day=$(rate_color "$rate_7day_int")
        printf " ${color_5hr}5h:${rate_5hr_int}%%${COLOR_RESET} ${color_7day}7d:${rate_7day_int}%%${COLOR_RESET}"
    else
        printf " ${color_5hr}5h:${rate_5hr_int}%%${COLOR_RESET}"
    fi
}

render_status() {
    local display_dir git_info ctx_bar rate_info
    display_dir=$(get_display_dir)
    git_info=$(get_git_info)
    ctx_bar=$(get_ctx)
    rate_info=$(get_rate_info)

    [ -n "$ctx_bar" ] && printf "%b" "$ctx_bar"
    [ -n "$git_info" ] && printf "${COLOR_RESET}%s${COLOR_RESET}" "$git_info"
    [ -n "$rate_info" ] && printf "%b" "$rate_info"
    printf " ${COLOR_RESET}%s${COLOR_RESET}" "$display_dir"
    [ -n "$model" ] && printf " ${COLOR_RESET}[%s] " "$model"
}

extract_data
render_status
