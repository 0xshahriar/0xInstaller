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

# Variables
REPO_URL="https://github.com/0xShahriar/0xInstaller.git"
SCRIPT_DIR="$HOME/0xInstaller"
SCRIPT_NAME="0xInstaller.sh"

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

# Function to check for updates
check_for_updates() {
    if [ -d "$SCRIPT_DIR" ]; then
        echo "Checking for updates in $SCRIPT_DIR..."
        cd "$SCRIPT_DIR" || exit
        git fetch origin
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)
        if [ "$LOCAL" != "$REMOTE" ]; then
            echo "Updates found. Pulling latest changes..."
            git reset --hard origin/main
            chmod +x "$SCRIPT_NAME"
            echo "Updates applied. Re-running the script..."
            exec "$SCRIPT_DIR/$SCRIPT_NAME"
        else
            echo "Already up to date."
        fi
    else
        echo "Cloning repository..."
        git clone "$REPO_URL" "$SCRIPT_DIR"
        chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"
        echo "Repository cloned. Re-running the script..."
        exec "$SCRIPT_DIR/$SCRIPT_NAME"
    fi
}

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
