#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." &> /dev/null && pwd )"

# Function to remove file/directory if it exists
remove_if_exists() {
    local path=$1
    local desc=$2
    if [ -e "$path" ]; then
        echo -e "${BLUE}Removing $desc...${NC}"
        sudo rm -rf "$path"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Removed $desc${NC}"
        else
            echo -e "${RED}✗ Failed to remove $desc${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}! $desc not found (already removed?)${NC}"
    fi
}

echo -e "${BLUE}DistroSync Uninstaller${NC}"
echo -e "${YELLOW}This will remove DistroSync from your system.${NC}\n"

# Ask for confirmation
read -p "Are you sure you want to uninstall DistroSync? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Uninstallation cancelled.${NC}"
    exit 0
fi

echo -e "\n${BLUE}Starting uninstallation...${NC}"

# List of components to remove
echo -e "\nWill remove the following components:"
echo "1. Command-line launcher (/usr/local/bin/distrosync)"
echo "2. Desktop entry (/usr/share/applications/distrosync.desktop)"
echo "3. Installation directory (/opt/distrosync)"
echo -e "4. Cache directory (~/.cache/distrosync) - optional\n"

# Ask for final confirmation with component list
read -p "Proceed with uninstallation? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Uninstallation cancelled.${NC}"
    exit 0
fi

# Remove installed files
echo -e "\n${BLUE}Removing system components...${NC}"
remove_if_exists "/usr/local/bin/distrosync" "command-line launcher"
remove_if_exists "/usr/share/applications/distrosync.desktop" "desktop entry"
remove_if_exists "/opt/distrosync" "installation directory"

# Remove cache directory (ask first)
cache_dir="$HOME/.cache/distrosync"
if [ -d "$cache_dir" ]; then
    echo -e "\n${YELLOW}Cache directory found at $cache_dir${NC}"
    read -p "Do you want to remove the cache directory? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        remove_if_exists "$cache_dir" "cache directory"
    else
        echo -e "${BLUE}Keeping cache directory${NC}"
    fi
fi

# Update desktop database
echo -e "\n${BLUE}Updating desktop database...${NC}"
if sudo update-desktop-database; then
    echo -e "${GREEN}✓ Desktop database updated${NC}"
else
    echo -e "${RED}✗ Failed to update desktop database${NC}"
fi

echo -e "\n${GREEN}DistroSync has been uninstalled successfully!${NC}"
echo -e "\nThe following user-specific files may still exist:"
echo "- Cache directory: ~/.cache/distrosync"
echo "- Configuration files in your home directory (if any)"
echo -e "\nTo remove them manually, delete the directories listed above."