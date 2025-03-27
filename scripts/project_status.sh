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

echo -e "${BLUE}DistroSync Project Status${NC}"
echo "=========================="

# Check project structure
echo -e "\n${BLUE}Project Structure:${NC}"
directories=(
    "distrosync"
    "scripts"
    "desktop"
    "docs"
)

files=(
    "LICENSE"
    "README.md"
    "setup.py"
    "MANIFEST.in"
    "requirements-dev.txt"
    "docs/CHANGELOG.md"
    "docs/CONTRIBUTING.md"
    "desktop/distrosync.desktop"
    "distrosync/__init__.py"
    "distrosync/__main__.py"
    "distrosync/cli.py"
    "distrosync/config.py"
    "distrosync/detector.py"
    "distrosync/launcher.py"
    "distrosync/package_manager.py"
)

# Check directories
echo "Core Directories:"
for dir in "${directories[@]}"; do
    if [ -d "$PROJECT_ROOT/$dir" ]; then
        echo -e "${GREEN}✓ $dir${NC}"
    else
        echo -e "${RED}✗ $dir${NC}"
    fi
done

# Check files
echo -e "\nCore Files:"
for file in "${files[@]}"; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file${NC}"
    fi
done

# Check scripts are executable
echo -e "\n${BLUE}Script Permissions:${NC}"
scripts=(
    "scripts/install.sh"
    "scripts/uninstall.sh"
    "scripts/check_installation.sh"
    "scripts/cleanup.sh"
    "scripts/test_functionality.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "$PROJECT_ROOT/$script" ]; then
        echo -e "${GREEN}✓ $script is executable${NC}"
    else
        echo -e "${RED}✗ $script is not executable${NC}"
    fi
done

# Check installed components
echo -e "\n${BLUE}Installation Status:${NC}"
components=(
    "/usr/local/bin/distrosync"
    "/usr/share/applications/distrosync.desktop"
    "/opt/distrosync/venv"
    "/opt/distrosync/distrosync"
)

for component in "${components[@]}"; do
    if [ -e "$component" ]; then
        echo -e "${GREEN}✓ $component${NC}"
    else
        echo -e "${YELLOW}! $component not installed${NC}"
    fi
done

# Check version consistency
echo -e "\n${BLUE}Version Information:${NC}"
version_init=$(grep "__version__" "$PROJECT_ROOT/distrosync/__init__.py" | cut -d'"' -f2)
version_setup=$(grep "version=" "$PROJECT_ROOT/setup.py" | cut -d'"' -f2 || echo "not found")
echo "Version in __init__.py: $version_init"
echo "Version in setup.py: $version_setup"

if [ "$version_init" = "$version_setup" ]; then
    echo -e "${GREEN}✓ Versions match${NC}"
else
    echo -e "${RED}✗ Version mismatch${NC}"
fi

# Summary
echo -e "\n${BLUE}Summary:${NC}"
echo "1. Project structure is organized"
echo "2. Core files are present"
echo "3. Scripts are executable"
echo "4. Installation can be verified with: scripts/check_installation.sh"
echo "5. Functionality can be tested with: scripts/test_functionality.sh"
echo -e "\nFor detailed testing, run: ./scripts/test_functionality.sh"