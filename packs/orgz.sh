#!/bin/bash

# Tidyup - File Organization Script
# Author: Bossadi Zenith
# Version: 1.0.0

set -e  # Exit on error
set -u  # Exit on undefined variable

# Default values
VERSION="1.0.0"
TARGET_DIR="."
ORGANIZE_BY=""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
    cat << EOF
Usage: tidyup [directory] [options]

Options:
    --ext           Organize files by extension
    --name          Organize files by starting name
    --date          Organize files by creation date
    --version       Display version information
    --help          Display this help message

Example:
    tidyup ~/Downloads --ext
    tidyup /path/to/directory --name
    tidyup . --date
EOF
    exit 1
}

# Function to display version information
version() {
    echo "tidyup version $VERSION"
    exit 0
}

# Function to log messages
log() {
    local level=$1
    local message=$2
    case $level in
        "error")
            echo -e "${RED}Error: ${message}${NC}" >&2
            ;;
        "success")
            echo -e "${GREEN}${message}${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}Warning: ${message}${NC}"
            ;;
    esac
}

# Function to validate directory
validate_directory() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        log "error" "Directory '$dir' does not exist"
        exit 1
    fi
    if [ ! -w "$dir" ]; then
        log "error" "Directory '$dir' is not writable"
        exit 1
    fi
}

# Function to handle file conflicts
handle_file_conflict() {
    local source=$1
    local target=$2
    local counter=1
    local base_name=$(basename "$target")
    local dir_name=$(dirname "$target")
    local name="${base_name%.*}"
    local ext="${base_name##*.}"
    
    while [ -e "$target" ]; do
        if [ "$ext" = "$base_name" ]; then
            target="${dir_name}/${name}_${counter}"
        else
            target="${dir_name}/${name}_${counter}.${ext}"
        fi
        ((counter++))
    done
    echo "$target"
}

# Function to organize files by extension
organize_by_extension() {
    local dir=$1
    local summary=""
    
    find "$dir" -maxdepth 1 -type f | while read -r file; do
        if [ "$(basename "$file")" = "$(basename "$0")" ]; then
            continue
        fi
        
        local ext="${file##*.}"
        if [ "$ext" = "$(basename "$file")" ]; then
            ext="no_extension"
        fi
        
        local target_dir="$dir/$ext"
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
            summary+="\n- Folder: $ext\n  - Created"
        else
            summary+="\n- Folder: $ext\n  - Already existed"
        fi
        
        local target="$target_dir/$(basename "$file")"
        if [ -e "$target" ]; then
            target=$(handle_file_conflict "$file" "$target")
        fi
        
        mv "$file" "$target"
        summary+="\n  - Files moved: $(basename "$file")"
    done
    
    echo -e "\nOrganization Summary for '$dir':$summary"
}

# Function to organize files by starting name
organize_by_name() {
    local dir=$1
    local summary=""
    
    find "$dir" -maxdepth 1 -type f | while read -r file; do
        if [ "$(basename "$file")" = "$(basename "$0")" ]; then
            continue
        fi
        
        local name=$(basename "$file")
        local prefix="${name%%-*}"
        
        local target_dir="$dir/$prefix"
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
            summary+="\n- Folder: $prefix\n  - Created"
        else
            summary+="\n- Folder: $prefix\n  - Already existed"
        fi
        
        local target="$target_dir/$name"
        if [ -e "$target" ]; then
            target=$(handle_file_conflict "$file" "$target")
        fi
        
        mv "$file" "$target"
        summary+="\n  - Files moved: $name"
    done
    
    echo -e "\nOrganization Summary for '$dir':$summary"
}

# Function to organize files by creation date
organize_by_date() {
    local dir=$1
    local summary=""
    
    find "$dir" -maxdepth 1 -type f | while read -r file; do
        if [ "$(basename "$file")" = "$(basename "$0")" ]; then
            continue
        fi
        
        local date=$(date -r "$file" +%Y-%m-%d)
        local target_dir="$dir/$date"
        
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
            summary+="\n- Folder: $date\n  - Created"
        else
            summary+="\n- Folder: $date\n  - Already existed"
        fi
        
        local target="$target_dir/$(basename "$file")"
        if [ -e "$target" ]; then
            target=$(handle_file_conflict "$file" "$target")
        fi
        
        mv "$file" "$target"
        summary+="\n  - Files moved: $(basename "$file")"
    done
    
    echo -e "\nOrganization Summary for '$dir':$summary"
}

# Parse command line arguments
while [ $# -gt 0 ]; do
    case $1 in
        --help)
            usage
            ;;
        --version)
            version
            ;;
        --ext|--name|--date)
            if [ -n "$ORGANIZE_BY" ]; then
                log "error" "The --ext, --name, and --date options cannot be used together"
                exit 1
            fi
            ORGANIZE_BY="${1#--}"
            ;;
        -*)
            log "error" "Unknown option: $1"
            usage
            ;;
        *)
            if [ "$TARGET_DIR" = "." ]; then
                TARGET_DIR="$1"
            else
                log "error" "Multiple directories specified"
                usage
            fi
            ;;
    esac
    shift
done

# Validate inputs
if [ -z "$ORGANIZE_BY" ]; then
    log "error" "No organization method specified (--ext, --name, or --date)"
    usage
fi

validate_directory "$TARGET_DIR"

# Execute organization based on selected method
case $ORGANIZE_BY in
    ext)
        organize_by_extension "$TARGET_DIR"
        ;;
    name)
        organize_by_name "$TARGET_DIR"
        ;;
    date)
        organize_by_date "$TARGET_DIR"
        ;;
esac

log "success" "Organization complete! 🎉"

