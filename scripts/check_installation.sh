#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." &> /dev/null && pwd )"

echo -e "${BLUE}Checking DistroSync Installation...${NC}\n"

# Function to check file existence and permissions
check_file() {
    local file=$1
    local desc=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ Found $desc${NC}"
        ls -l "$file"
    else
        echo -e "${RED}✗ Missing $desc${NC}"
        return 1
    fi
}

# Function to check directory existence and permissions
check_dir() {
    local dir=$1
    local desc=$2
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓ Found $desc${NC}"
        ls -ld "$dir"
    else
        echo -e "${RED}✗ Missing $desc${NC}"
        return 1
    fi
}

# Check command line installation
echo -e "${BLUE}Checking command line installation:${NC}"
check_file "/usr/local/bin/distrosync" "command line launcher"

# Check desktop integration
echo -e "\n${BLUE}Checking desktop integration:${NC}"
check_file "/usr/share/applications/distrosync.desktop" "desktop entry"

# Check package files
echo -e "\n${BLUE}Checking package installation:${NC}"
check_dir "/opt/distrosync" "installation directory"
check_dir "/opt/distrosync/venv" "virtual environment"
check_file "/opt/distrosync/distrosync/launcher.py" "launcher script"

# Check terminal emulators
echo -e "\n${BLUE}Checking available terminal emulators:${NC}"
terminals=("konsole" "gnome-terminal" "xfce4-terminal" "xterm")
found_terminal=false

for term in "${terminals[@]}"; do
    if command -v "$term" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Found $term${NC}"
        found_terminal=true
    else
        echo -e "${RED}✗ $term not found${NC}"
    fi
done

if [ "$found_terminal" = false ]; then
    echo -e "${RED}Warning: No supported terminal emulator found${NC}"
    echo "Please install one of: konsole, gnome-terminal, xfce4-terminal, or xterm"
fi

# Try running distrosync --version
echo -e "\n${BLUE}Testing DistroSync:${NC}"
if output=$(distrosync --version 2>&1); then
    echo -e "${GREEN}✓ DistroSync version check successful${NC}"
    echo "$output"
else
    echo -e "${RED}✗ DistroSync version check failed${NC}"
    echo "$output"
fi

# Check cache directory
echo -e "\n${BLUE}Checking cache directory:${NC}"
cache_dir="$HOME/.cache/distrosync"
if [ -d "$cache_dir" ]; then
    echo -e "${GREEN}✓ Cache directory exists${NC}"
    ls -l "$cache_dir"
else
    echo -e "${YELLOW}! Cache directory will be created on first run${NC}"
fi

# Check project structure
echo -e "\n${BLUE}Checking project structure:${NC}"
required_files=(
    "$PROJECT_ROOT/desktop/distrosync.desktop"
    "$PROJECT_ROOT/scripts/install.sh"
    "$PROJECT_ROOT/scripts/uninstall.sh"
    "$PROJECT_ROOT/distrosync/launcher.py"
    "$PROJECT_ROOT/distrosync/cli.py"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ Found $(basename $file)${NC}"
    else
        echo -e "${RED}✗ Missing $(basename $file)${NC}"
    fi
done

echo -e "\n${BLUE}Verification complete!${NC}"
echo -e "\nTo launch DistroSync, you can:"
echo "1. Run 'distrosync' in terminal"
echo "2. Launch from application menu"
echo "3. Double-click the desktop entry"

# Print any error messages
if [ $? -ne 0 ]; then
    echo -e "\n${RED}Some checks failed. Please review the output above.${NC}"
    exit 1
fi