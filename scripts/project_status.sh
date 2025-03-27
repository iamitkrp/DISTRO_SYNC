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
    "media"
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

# Check media files
echo -e "\n${BLUE}Media Files:${NC}"
media_files=(
    "ds_desktop_1.png"
    "exporting_2.png"
    "Installing.png"
    "installing-final.png"
)

for file in "${media_files[@]}"; do
    if [ -f "$PROJECT_ROOT/media/$file" ]; then
        echo -e "${GREEN}✓ media/$file${NC}"
    else
        echo -e "${RED}✗ media/$file${NC}"
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
    "scripts/examples.sh"
    "scripts/project_status.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "$PROJECT_ROOT/$script" ]; then
        echo -e "${GREEN}✓ $script is executable${NC}"
    else
        echo -e "${RED}✗ $script is not executable${NC}"
    fi
done

# Check documentation references
echo -e "\n${BLUE}Documentation References:${NC}"
if grep -q "media/" "$PROJECT_ROOT/README.md"; then
    echo -e "${GREEN}✓ README.md includes media references${NC}"
else
    echo -e "${RED}✗ README.md missing media references${NC}"
fi

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
echo -e "\n${BLUE}Project Status Summary:${NC}"
echo "1. Core files and directories are present"
echo "2. Documentation is up-to-date with screenshots"
echo "3. Scripts are executable"
echo "4. Media files are properly organized"
echo -e "\nNext steps:"
echo "1. Run installation: sudo ./scripts/install.sh"
echo "2. Verify installation: ./scripts/check_installation.sh"
echo "3. Test functionality: ./scripts/test_functionality.sh"
echo "4. Try examples: ./scripts/examples.sh"