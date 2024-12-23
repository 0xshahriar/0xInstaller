#!/bin/bash
# testing update 1
# Script to install specified tools
# Author: Md. Shahriar Alam Shaon (0xShahriar)

# Current script version
CURRENT_VERSION="1.0.1"

# GitHub repository details
REPO_URL="https://raw.githubusercontent.com/0xShahriar/0xInstaller/main"
SCRIPT_NAME="0xInstaller.sh"
VERSION_FILE="VERSION.txt"

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
    echo -e "Author : Md. Shahriar Alam Shaon ( 0xShahriar )\nVersion : $CURRENT_VERSION\n" | lolcat
}

# Function to compare semantic versions
version_gt() {
    [ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ]
}

# Function to check for updates
check_for_updates() {
    echo "Checking for updates..."
    LATEST_VERSION=$(curl -s "$REPO_URL/$VERSION_FILE")
    
    if [[ -z "$LATEST_VERSION" ]]; then
        echo "Unable to fetch the latest version. Skipping update check."
        return
    fi
    
    if version_gt "$LATEST_VERSION" "$CURRENT_VERSION"; then
        echo -e "${GREEN}A new version ($LATEST_VERSION) is available. You are using version $CURRENT_VERSION.${RESET}"
        read -p "Do you want to update? (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Updating the script..."
            curl -s -o "$SCRIPT_NAME" "$REPO_URL/$SCRIPT_NAME"
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}Failed to download the updated script. Please try again later.${RESET}"
                exit 1
            fi
            chmod +x "$SCRIPT_NAME"
            echo "Update applied successfully. Restarting the script..."
            exec ./"$SCRIPT_NAME" "${@}"
        else
            echo "Continuing with the current version."
        fi
    else
        echo "You are using the latest version ($CURRENT_VERSION)."
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

# Run update check
check_for_updates "$@"

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
