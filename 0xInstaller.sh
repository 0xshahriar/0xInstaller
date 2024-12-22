#!/bin/bash

# Script to install specified tools
# Author: Md. Shahriar Alam Shaon (0xShahriar)

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Log file
LOG_FILE="$HOME/0xInstaller/0xInstaller.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Pre-check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script requires root privileges. Please run as root.${RESET}"
    exit 1
fi

# Function to display banner
display_banner() {
    if ! command -v figlet &>/dev/null; then
        apt-get install figlet -y
    fi
    if ! command -v lolcat -i &>/dev/null; then
        apt-get install lolcat -y
    fi
    figlet -f smslant "0xInstaller" | lolcat
    echo -e "Author : Md. Shahriar Alam Shaon ( 0xShahriar )\nVersion : 1.0\n" | lolcat
}

# Define variables for script paths and arguments
SCRIPT="$(readlink -f "$0")"
SCRIPTFILE="$(basename "$SCRIPT")"
SCRIPTPATH="$(dirname "$SCRIPT")"
ARGS=( "$@" )
BRANCH="main"

# Define variables for repository URL and branch
REPO_URL="https://github.com/0xShahriar/0xInstaller.git"  # Repository URL
BRANCH="main"                                             # Default branch to check for updates

# Function to check and apply updates from GitHub
check_for_updates() {
    echo "Checking for updates from GitHub..."

    # Get full path of the script and related information
    SCRIPT="$(readlink -f "$0")"
    SCRIPTFILE="$(basename "$SCRIPT")"        # Name of the script file
    SCRIPTPATH="$(dirname "$SCRIPT")"         # Directory where the script is located
    ARGS=( "$@" )                             # Preserve any arguments passed to the script

    # Navigate to the script directory
    cd "$SCRIPTPATH" || { echo "Failed to access script directory: $SCRIPTPATH"; exit 1; }

    # Fetch the latest changes from the GitHub repository
    git fetch origin "$BRANCH"

    # Check if the script file has been updated
    if [ -n "$(git diff --name-only "origin/$BRANCH" "$SCRIPTFILE")" ]; then
        echo "A new version of the script is available. Updating..."
        git pull --force
        git checkout "$BRANCH"
        git pull --force
        echo "Update applied successfully. Restarting the script..."
        
        # Navigate back to the original working directory and re-run the script
        cd - || exit 1
        exec "$SCRIPT" "${ARGS[@]}"
        
        # Exit the old instance after the update
        exit 1
    fi

    echo "The script is already up to date."
}

# Call the update function at the start of the script
check_for_updates

# Function to check and install a package
check_and_install() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installing $1..."
        apt-get install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Install libpcap-dev for Go-based tools that require it
check_and_install "libpcap-dev"

# Function to install Go-based tools
install_go_tool() {
    local tool=$1
    local url=$2
    if ! command -v "$tool" &>/dev/null; then
        echo "Installing $tool..."
        go install -v "$url"
    else
        echo "$tool is already installed."
    fi
}

# Function to install Python-based tools
install_python_tool() {
    local repo=$1
    local dir=$2
    if [ ! -d "$dir" ]; then
        echo "Installing $repo..."
        git clone "$repo" "$dir"
        cd "$dir" || exit
        pip3 install -r requirements.txt
        cd ..
    else
        echo "$repo is already installed."
    fi
}

# Check for dry-run mode
DRY_RUN=false
if [[ $1 == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${GREEN}Dry-run mode enabled. No installations will occur.${RESET}"
fi

# Update and upgrade system
if ! $DRY_RUN; then
    apt-get update && apt-get upgrade -y
fi

# Display banner
display_banner

# Install essential packages
echo "Installing essential packages..."
for pkg in git python3 python3-pip golang ruby tree; do
    $DRY_RUN || check_and_install "$pkg"
done

# Install cybersecurity tools
echo "Installing cybersecurity tools..."
for tool in nmap; do
    $DRY_RUN || check_and_install "$tool"
done

# Install Go-based tools
echo "Installing Go-based tools..."
install_go_tools=(
    "httpx github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "waybackurls github.com/tomnomnom/waybackurls@latest"
    "anew github.com/tomnomnom/anew@latest"
    "nuclei github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
    "shuffledns github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
    "subfinder github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "ffuf github.com/ffuf/ffuf@latest"
    "uncover github.com/projectdiscovery/uncover/cmd/uncover@latest"
    "naabu github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
)
for tool_info in "${install_go_tools[@]}"; do
    $DRY_RUN || install_go_tool $tool_info
done

# Install Python-based tools
echo "Installing Python-based tools..."
install_python_tools=(
    "https://github.com/jordanpotti/AWSBucketDump.git AWSBucketDump"
    "https://github.com/aboul3la/Sublist3r.git Sublist3r"
)
for tool_info in "${install_python_tools[@]}"; do
    $DRY_RUN || install_python_tool $tool_info
done

echo -e "${GREEN}Installation complete!${RESET}"
