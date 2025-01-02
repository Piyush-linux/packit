#!/bin/bash

# =================================================================
# zone - A Simple Command-line Pomodoro Timer
# =================================================================
#
# Author:          Piyush-linux
# Version:         1.0.0
# License:         MIT
# GitHub:          https://github.com/Piyush-linux/packit/blob/master/packs/zone.sh
# 
# Description:     A minimalist Pomodoro timer for the command line
#                 with pause/resume functionality and visual progress
#                 bar. Designed for developers who prefer to stay in
#                 the terminal.
# =================================================================

VERSION="1.0.0"

# Function to display help message
show_help() {
    cat << EOF

zone - A simple Pomodoro timer

Usage: zone [ --help | start <number of minutes> | usage | --version ]

Controls:
    P or SPACE - Pause/Resume
    Q         - Quit

Examples:
    zone start 25     # Start a 25-minute timer
    zone --version    # Show version information
    zone --help        # Show this help message

EOF
}

# Function to show usage
show_usage() {
    echo "Usage: zone [ -help | start <number of minutes> | usage | --version ]"
}

# Function to show version
show_version() {
    echo "zone version $VERSION"
}

# Function to format time
format_time() {
    local total_seconds=$1
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d" $minutes $seconds
}

# Function to generate progress bar
generate_progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local progress=$((current * width / total))
    local remaining=$((width - progress))
    
    # Characters for animation
    local filled="|"
    local empty="-"
    
    printf "%s%s" "$(printf "%${progress}s" | tr ' ' "$filled")" "$(printf "%${remaining}s" | tr ' ' "$empty")"
}

# Function to run the timer
# Function to run the timer
# Function to center-align text in the terminal
center_text() {
    local text="$1"
    local term_width=$(tput cols)  # Get terminal width
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))  # Calculate padding for centering

    # Print padding spaces followed by the text
    printf "%${padding}s%s\n" "" "$text"
}



# Function to run the timer
run_timer() {
    local duration_minutes=$1
    local total_seconds=$((duration_minutes * 60))
    local remaining_seconds=$total_seconds
    local is_paused=false
    local start_time

    # Switch to raw input mode
    stty -echo raw

    # Clear screen and hide cursor
    echo -e "\e[2J\e[?25l"

    while [ $remaining_seconds -ge 0 ]; do
        if ! $is_paused; then
            start_time=$(date +%s)
        fi

        # Calculate the progress bar based on the remaining time
        local progress_bar
        progress_bar=$(generate_progress_bar $((total_seconds - remaining_seconds)) $total_seconds)

        # Display timer with progress bar centered
        echo -e "\e[H\e[K"  # Move to top and clear line
        echo -e "\e[33mZone Timer: \e[36m$(format_time $remaining_seconds) \e[32m$progress_bar\e[0m"
        echo -e "\n\n"
        echo -e "\e[35m['p' - pause/resume], ['q' - quit]\e[0m"

        # Read key input with timeout
        read -t 1 -n 1 key 2>/dev/null

        # Convert input to uppercase for case-insensitive comparison
        key=$(echo "$key" | tr '[:lower:]' '[:upper:]')

        case "$key" in
            P|" ")  # Space or P to pause/resume
                if $is_paused; then
                    is_paused=false
                    echo -e "\e[K\e[32mResumed\e[0m"
                else
                    is_paused=true
                    echo -e "\e[K\e[33mPaused\e[0m"
                fi
                ;;
            Q)  # Q to quit
                echo -e "\e[?25h"  # Show cursor
                stty echo -raw
                echo -e "\n\e[31mTimer stopped\e[0m"
                exit 0
                ;;
        esac

        if ! $is_paused; then
            # Calculate elapsed time and update remaining seconds
            end_time=$(date +%s)
            elapsed=$((end_time - start_time))
            if [ $elapsed -ge 1 ]; then
                remaining_seconds=$((remaining_seconds - elapsed))
            fi
        fi
    done

    # Timer finished
    echo -e "\e[?25h"  # Show cursor
    stty echo -raw
    echo -e "\n\e[31mTime's up!\e[0m"
    
    # Play alert sound (if available)
    if command -v tput > /dev/null && tput bel > /dev/null 2>&1; then
        tput bel
    fi
}

# Main script logic
case "${1:-}" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    usage)
        show_usage
        ;;
    start)
        if [[ -z "${2:-}" ]]; then
            echo "Error: Duration required"
            show_usage
            exit 1
        fi
        if ! [[ "${2}" =~ ^[0-9]+$ ]]; then
            echo "Error: Duration must be a positive number"
            exit 1
        fi
        run_timer "${2}"
        ;;
    *)
        show_usage
        exit 1
        ;;
esac