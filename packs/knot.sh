# =================================================================
# Knot - Dotfile Manager
# =================================================================
#
# Author:          Piyush-linux
# Version:         1.0.0
# License:         MIT
# GitHub:          https://github.com/Piyush-linux/packit/blob/master/packs/knot.sh
# 
# Description:	**Knot** is a lightweight, Bash-based dotfile manager that helps you back up,
#				organize, and manage your dotfiles seamlessly. It simplifies syncing your 
#				configurations across multiple systems.
# =================================================================

#!/bin/bash

VERSION="1.0.0"
BACKUP_DIR="$HOME/.knot"
CONFIG_FILE="$BACKUP_DIR/config"

# Create necessary directories
mkdir -p "$BACKUP_DIR/files"

# Error handling
set -e
trap 'echo "Error: Command failed at line $LINENO. Exit code: $?" >&2' ERR

help() {
    cat << EOF
knot - Dotfile Manager v$VERSION

Usage:
    knot                    Sync files and push to GitHub
    knot add <file>        Create hard link of file in backup directory
    knot list              List all tracked files
    knot repo <url>        Set GitHub repository URL
    knot --version         Display version
    knot --help            Display this help message
EOF
}

set_repo() {
    local url="$1"
    if [[ ! "$url" =~ ^https://github.com/.+/.+\.git$ ]]; then
        echo "Error: Invalid GitHub repository URL"
        echo "Format: https://github.com/username/repository.git"
        exit 1
    fi
    echo "REPO_URL=$url" > "$CONFIG_FILE"
    echo "Repository URL set successfully"
}

get_repo_url() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "$REPO_URL"
    fi
}

check_git_config() {
    local repo_url=$(get_repo_url)
    if [ -z "$repo_url" ]; then
        echo "Error: GitHub repository not configured"
        echo "Use: knot repo <url>"
        exit 1
    fi

    if [ ! -d "$BACKUP_DIR/.git" ]; then
        git -C "$BACKUP_DIR" init
        git -C "$BACKUP_DIR" remote add origin "$repo_url"
    fi
}

add_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist"
        exit 1
    fi

    # Get absolute path
    local abs_path=$(realpath "$file")
    local filename=$(basename "$abs_path")
    local backup_path="$BACKUP_DIR/files/$filename"

    # Create hard link
    if ln "$abs_path" "$backup_path" 2>/dev/null; then
        echo "Added: $abs_path"
    else
        echo "Error: Failed to create hard link for '$abs_path'"
        exit 1
    fi
}

list_files() {
    echo "Tracked files:"
    find "$BACKUP_DIR/files" -type f -exec readlink -f {} \;
}

sync_repository() {
    check_git_config
    git -C "$BACKUP_DIR" add .
    git -C "$BACKUP_DIR" commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')" || true
    git -C "$BACKUP_DIR" push origin master
    echo "Successfully synced with remote repository"
}

case "$1" in
    "add")
        if [ -z "$2" ]; then
            echo "Error: Please specify a file"
            exit 1
        fi
        add_file "$2"
        ;;
    "list")
        list_files
        ;;
    "repo")
        if [ -z "$2" ]; then
            echo "Current repository: $(get_repo_url)"
        else
            set_repo "$2"
        fi
        ;;
    "--version")
        echo "knot v$VERSION"
        ;;
    "--help")
        help
        ;;
    "")
        sync_repository
        ;;
    *)
        echo "Error: Unknown command '$1'"
        help
        exit 1
        ;;
esac