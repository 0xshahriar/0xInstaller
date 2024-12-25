#!/bin/bash

# Script to install specified tools
# Author: Md. Shahriar Alam Shaon (0xShahriar)

# Current script version
CURRENT_VERSION="1.0.2"

# GitHub repository for raw file access
REPO_URL="https://raw.githubusercontent.com/0xShahriar/0xInstaller/main"
SCRIPT_NAME="0xInstaller.sh"
VERSION_FILE="VERSION.txt"

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Set up Go environment
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Log file
LOG_FILE="$HOME/0xInstaller/0xInstaller.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Function to check internet connectivity
check_internet() {
    echo "Checking internet connectivity..."
    if ! ping -c 1 google.com &>/dev/null; then
        echo -e "${RED}Error: No internet connection. Please check your network.${RESET}"
        exit 1
    fi
}

# Function to rotate logs
rotate_logs() {
    if [ -f "$LOG_FILE" ] && [ "$(wc -c <"$LOG_FILE")" -ge 10485760 ]; then
        mv "$LOG_FILE" "${LOG_FILE}_$(date +%Y%m%d%H%M%S)"
        echo "Log file rotated due to size limit."
    fi
}

# Pre-check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script requires root privileges. Please run as root.${RESET}"
    exit 1
fi

# Function to display banner
display_banner() {
    for pkg in figlet lolcat; do
        if ! command -v "$pkg" &>/dev/null; then
            echo "Installing $pkg..."
            apt-get install -y -qq "$pkg"
        fi
    done
    figlet -f smslant "0xInstaller" | lolcat
    echo "Author: Md. Shahriar Alam Shaon (0xShahriar)" | lolcat
    echo "Version: $CURRENT_VERSION" | lolcat
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
        echo -e "${GREEN}New version available ($LATEST_VERSION). You are using ($CURRENT_VERSION).${RESET}"
        read -p "Update script? (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Updating script..."
            curl -s -o "$SCRIPT_NAME" "$REPO_URL/$SCRIPT_NAME" && chmod +x "$SCRIPT_NAME"
            echo "Update successful. Restarting script..."
            exec ./"$SCRIPT_NAME" "$@"
        fi
    else
        echo "You are using the latest version."
    fi
}

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: $1 failed. Check the logs for details.${RESET}"
        exit 1
    fi
}

# Function to check and install a package
check_and_install() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installing $1..."
        apt-get install -y -qq "$1"
        check_command "$1 installation"
    else
        echo "$1 is already installed."
    fi
}

# Function to install Go-based tools in parallel
install_go_tool_parallel() {
    local tool=$1
    local url=$2
    if ! command -v "$tool" &>/dev/null; then
        echo "Installing $tool..."
        go install "$url" &
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
        git clone "$repo" "$dir" && cd "$dir" && pip3 install -r requirements.txt && cd ..
        check_command "Installation of $repo"
    else
        echo "$repo is already installed."
    fi
}

# Parse configuration
[ -f "tools.conf" ] && source tools.conf

# Command-line argument parsing
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        --install-go-tools) INSTALL_GO_TOOLS=true ;;
        --install-python-tools) INSTALL_PYTHON_TOOLS=true ;;
        *) echo -e "${RED}Unknown option: $arg${RESET}" && exit 1 ;;
    esac
done

# Defaults
DRY_RUN=${DRY_RUN:-false}
INSTALL_GO_TOOLS=${INSTALL_GO_TOOLS:-true}
INSTALL_PYTHON_TOOLS=${INSTALL_PYTHON_TOOLS:-true}

# Clear screen and check prerequisites
clear
rotate_logs
check_internet
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
if $INSTALL_GO_TOOLS; then
    echo "Installing Go-based tools..."
    go_tools=(
        "httpx github.com/projectdiscovery/httpx/cmd/httpx@latest"
        "waybackurls github.com/tomnomnom/waybackurls@latest"
    )
    for tool_info in "${go_tools[@]}"; do
        IFS=' ' read -r tool url <<< "$tool_info"
        $DRY_RUN && echo "Dry-run: $tool installation skipped." || install_go_tool_parallel "$tool" "$url"
    done
    wait
fi

# Install Python-based tools
if $INSTALL_PYTHON_TOOLS; then
    echo "Installing Python-based tools..."
    python_tools=(
        "https://github.com/jordanpotti/AWSBucketDump.git AWSBucketDump"
        "https://github.com/aboul3la/Sublist3r.git Sublist3r"
    )
    for tool_info in "${python_tools[@]}"; do
        IFS=' ' read -r repo dir <<< "$tool_info"
        $DRY_RUN && echo "Dry-run: $repo installation skipped." || install_python_tool "$repo" "$dir"
    done
fi

echo -e "${GREEN}Installation complete!${RESET}"