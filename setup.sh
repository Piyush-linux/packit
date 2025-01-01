#!/bin/bash

# Download the packit script
echo "Downloading packit script..."
sudo wget https://raw.githubusercontent.com/Piyush-linux/packit/master/packit.sh -O /usr/local/bin/packit

# Make it executable
echo "Making packit script executable..."
sudo chmod +x /usr/local/bin/packit

# Add the directory to PATH
echo "Adding packit-scripts directory to PATH..."
echo 'export PATH=$HOME/.local/bin/packit-scripts:$PATH' >> ~/.bashrc

# Reload .bashrc
echo "Reloading .bashrc to apply changes..."
source ~/.bashrc

# Verify installation
echo "Verifying packit installation..."
packit --version
 