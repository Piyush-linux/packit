#!/bin/bash

VERSION="1.0.0"

# ANSI color codes
COLORS=(
    '\033[0;31m'  # Red
    '\033[0;33m'  # Yellow
    '\033[0;32m'  # Green
    '\033[0;36m'  # Cyan
    '\033[0;34m'  # Blue
    '\033[0;35m'  # Purple
)
NC='\033[0m'

# Cat variants
declare -A CATS
CATS[1]=$(cat << 'EOF'
  /\___/\
 (  o o  )
 (  =^=  )
  (______)
EOF
)

CATS[2]=$(cat << 'EOF'
    /\___/\
   ( ^.^ )
    > ~ <
   (______)
EOF
)

CATS[3]=$(cat << 'EOF'
  /\  /\
 (  ◕.◕ )
  )  ~  (
 (______)
EOF
)

help() {
    cat << EOF
neko - Rainbow ASCII Cat v$VERSION

Usage: neko [message]
       neko -h|--help
       neko --version

Example: neko "Hello, World!"
EOF
}

display_message() {
    local message="$1"
    local variant=$((1 + RANDOM % 3))
    local cat_art="${CATS[$variant]}"
    local color_index=0
    
    # Print message with rainbow colors
    for ((i=0; i<${#message}; i++)); do
        echo -en "${COLORS[$((color_index % 6))]}${message:$i:1}"
        ((color_index++))
    done
    echo

    # Print cat with random color
    echo -e "${COLORS[$((RANDOM % 6))]}${cat_art}${NC}"
}

case "$1" in
    -h|--help)
        help
        exit 0
        ;;
    --version)
        echo "neko v$VERSION"
        exit 0
        ;;
    *)
        MESSAGE="$*"
        if [ -z "$MESSAGE" ]; then
            read -p "Enter your message: " MESSAGE
        fi
        display_message "$MESSAGE"
        ;;
esac