#!/bin/bash

# =================================================================
# namaskar - A Simple System Info Display
# =================================================================
#
# Author:          Piyush-linux
# Version:         1.0.0
# License:         MIT
# GitHub:          https://github.com/Piyush-linux/packit/blob/master/packs/namaskar.sh
# 
# Description:    Displays system information including OS, host, user, shell, 
#                 kernel version, and system uptime with a color-coded output.
# =================================================================

# Script version
version="1.0.0"

# Check for --version flag
if [[ "$1" == "--version" ]]; then
  echo "namaskar: ${version}"
  exit 0
fi

# Collecting system information
host=$(uname -n)
user=$(whoami)
shell=$(echo $SHELL)
kernel="$(uname -r)"
shell="$(basename "${SHELL}")"
os="$(uname -s)"
uptime="$(uptime -p)"

# Color codes
c1=$(echo -e "\e[42m  \e[0m")
c2=$(echo -e "\e[41m  \e[0m")
c3=$(echo -e "\e[43m  \e[0m")
c4=$(echo -e "\e[44m  \e[0m")
c5=$(echo -e "\e[45m  \e[0m")

# Displaying system information
cat <<EOF

${c1} ┌───┐   os     : ${os}
${c2} │ ┌─┼─┐ host   : ${host} 
${c3} │ │ │ │ user   : ${user}
${c4} └─┼─┘ │ kernel : ${kernel}
${c5}   └───┘ shell  : ${shell}

  ${uptime}

EOF