#!/bin/bash

# Packit Information
VERSION="1.0.0"
AUTHOR="https://github.com/Piyush-Linux"

# Global directory for Packit scripts
GLOBAL_SCRIPT_DIR="$HOME/.local/bin/packit-scripts"

# Function to display help
show_help() {
    echo -e "\nPackit - A Simple Bash Package Manager"
    echo "Version: $VERSION"
    echo "Author: $AUTHOR"
    echo
    echo "Usage:"
    echo "  packit add <package_name>      Install a script globally"
    echo "  packit update <package_name>   Update an installed script"
    echo "  packit remove <package_name>   Remove an installed script"
    echo "  packit list                    List all installed scripts"
    echo "  packit version                 Display Packit version"
    echo "  packit help                    Show this help message"
    echo " "
}

# Function to display version
show_version() {
    echo "   "
    echo "Packit Version: $VERSION"
    echo "Author: $AUTHOR"
    echo "   " 
}

# Function to install a script globally using wget
install_script() {
    local package_name=$1
    local repo_url="https://raw.githubusercontent.com/Piyush-linux/packit/refs/heads/master/packs/$package_name.sh"

    echo "Installing $package_name..."

    sudo mkdir -p "$GLOBAL_SCRIPT_DIR"
    if sudo wget -O "$GLOBAL_SCRIPT_DIR/$package_name" "$repo_url"; then
        sudo chmod +x "$GLOBAL_SCRIPT_DIR/$package_name"
        sudo chown $USER:$USER "$GLOBAL_SCRIPT_DIR/$package_name"  # Ensure ownership
        echo "Installed $package_name successfully in $GLOBAL_SCRIPT_DIR!"
    else
        echo "Failed to install $package_name."
    fi
}

# Function to update a script globally using wget
update_script() {
    local package_name=$1
    local repo_url="https://raw.githubusercontent.com/Piyush-linux/packit/refs/heads/master/packs/$package_name.sh"

    if [[ -f "$GLOBAL_SCRIPT_DIR/$package_name" ]]; then
        if sudo wget -O "$GLOBAL_SCRIPT_DIR/$package_name" "$repo_url"; then
            echo "Updated $package_name successfully!"
        else
            echo "Failed to update $package_name."
        fi
    else
        echo "$package_name is not installed."
    fi
}

# Function to remove a script globally
remove_script() {
    local package_name=$1

    if [[ -f "$GLOBAL_SCRIPT_DIR/$package_name" ]]; then
        sudo rm "$GLOBAL_SCRIPT_DIR/$package_name"
        echo "Removed $package_name successfully!"
    else
        echo "$package_name is not installed."
    fi
}

# Function to list installed scripts globally
list_scripts() {
    if [[ -d "$GLOBAL_SCRIPT_DIR" ]]; then
        echo "Installed scripts in $GLOBAL_SCRIPT_DIR:"
        ls "$GLOBAL_SCRIPT_DIR"
    else
        echo "No scripts are installed."
    fi
}

# Exit if Ctrl+D (EOF) is pressed
trap "echo 'Goodbye!'; exit 0" SIGINT SIGTERM

# Main logic
case $1 in
    add)
        install_script "$2"
        ;;
    update)
        update_script "$2"
        ;;
    remove)
        remove_script "$2"
        ;;
    list)
        list_scripts
        ;;
    --version)
        show_version
        ;;
    help|*)
        show_help
        ;;
esac
