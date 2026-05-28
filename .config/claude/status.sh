#!/bin/bash
input=$(cat)

COLOUR_OK="\\033[32m"
COLOUR_WARNING="\\033[33m"
COLOUR_CRITICAL="\\033[31m"
COLOUR_SEPARATOR="\\033[38;2;87;87;94m"
COLOUR_DIR="\\033[38;2;153;164;188m"
COLOUR_GIT="\\033[38;2;112;112;130m"
COLOUR_RESET="\\033[0m"

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
                printf " ${COLOUR_SEPARATOR}|${COLOUR_RESET} ${COLOUR_GIT} %s✗${COLOUR_RESET}" "$branch"
            else
                printf " ${COLOUR_SEPARATOR}|${COLOUR_RESET} ${COLOUR_GIT} %s${COLOUR_RESET}" "$branch"
            fi
        fi
    fi
}

get_ctx() {
    local total_input=$(( input_tokens + cache_creation + cache_read ))
    [ "$total_input" -le 0 ] && return

    local tenths=$(( (total_input + 50) / 100 ))
    local tokens_k="$(( tenths / 10 )).$(( tenths % 10 ))"
    local ctx_color="$COLOUR_OK"
    if [ -n "$context_window_size" ] && [ "$context_window_size" -gt 0 ]; then
        local percentage=$(( (total_input * 100 + context_window_size / 2) / context_window_size ))
        if [ "$percentage" -lt 20 ]; then
          ctx_color="$COLOUR_OK"
        elif [ "$percentage" -lt 40 ]; then
          ctx_color="$COLOUR_WARNING"
        else
          ctx_color="$COLOUR_CRITICAL"
        fi
    fi

    printf "${ctx_color}${tokens_k}k${COLOUR_RESET}"
}

rate_color() {
    local pct=$1
    if [ "$pct" -lt 50 ]; then printf "$COLOUR_RESET"
    elif [ "$pct" -lt 80 ]; then printf "$COLOUR_WARNING"
    else printf "$COLOUR_CRITICAL"; fi
}

get_rate_5hr() {
    [ -z "$rate_5hr" ] && return
    local rate_int color
    rate_int=$(printf "%.0f" "$rate_5hr")
    color=$(rate_color "$rate_int")
    printf " ${color}5h:${rate_int}%%${COLOUR_RESET}"
}

get_rate_7day() {
    [ -z "$rate_7day" ] && return
    local rate_int color
    rate_int=$(printf "%.0f" "$rate_7day")
    color=$(rate_color "$rate_int")
    printf " ${color}7d:${rate_int}%%${COLOUR_RESET}"
}

get_model() {
    [ -z "$model" ] && return
    local short="$model"
    short="${short//Opus /Op}"
    short="${short//Sonnet /So}"
    short="${short//Haiku /Ha}"
    short="${short// (1M context)/(1M)}"
    printf " ${COLOUR_SEPARATOR}|${COLOUR_RESET} %s " "$short"
}

render_status() {
    local display_dir git_info ctx_bar rate_5hr_info rate_7day_info model_info
    display_dir=$(get_display_dir)
    git_info=$(get_git_info)
    ctx_bar=$(get_ctx)
    rate_5hr_info=$(get_rate_5hr)
    rate_7day_info=$(get_rate_7day)
    model_info=$(get_model)
    printf "${COLOUR_RESET}"

    [ -n "$ctx_bar" ] && printf "%b" "$ctx_bar"
    [ -n "$rate_5hr_info" ] && printf "%b" "$rate_5hr_info"
    [ -n "$rate_7day_info" ] && printf "%b" "$rate_7day_info"
    [ -n "$git_info" ] && printf "%b" "$git_info"
    printf " ${COLOUR_SEPARATOR}|${COLOUR_RESET} ${COLOUR_DIR}%s${COLOUR_RESET}" "$display_dir"
    [ -n "$model_info" ] && printf "%b" "$model_info"
}

extract_data
render_status
