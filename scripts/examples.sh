#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}DistroSync Usage Examples${NC}"
echo "========================"

show_command() {
    local desc=$1
    local cmd=$2
    echo -e "\n${YELLOW}$desc${NC}"
    echo "$ $cmd"
    eval "$cmd"
    echo -e "${GREEN}✓ Command completed${NC}"
}

echo -e "\n${BLUE}Basic Commands:${NC}"
show_command "Show version" "distrosync --version"
show_command "Show help" "distrosync --help"
show_command "Show export help" "distrosync export --help"
show_command "Show install help" "distrosync install --help"

echo -e "\n${BLUE}Export Examples:${NC}"
show_command "Export packages to default file" "distrosync export"
show_command "Export packages to custom file" "distrosync export -o my_packages.json"
show_command "Export with debug output" "distrosync --debug export"

echo -e "\n${BLUE}Install Examples:${NC}"
echo -e "${YELLOW}Dry run installation (no changes made):${NC}"
show_command "Test installation" "distrosync install --dry-run -f my_packages.json"

echo -e "\n${BLUE}Available Features:${NC}"
echo "1. Interactive Menu"
echo "   $ distrosync"
echo ""
echo "2. Package Export"
echo "   $ distrosync export"
echo "   $ distrosync export -o filename.json"
echo ""
echo "3. Package Installation"
echo "   $ distrosync install"
echo "   $ distrosync install -f filename.json"
echo "   $ distrosync install --dry-run"
echo ""
echo "4. Debug Mode"
echo "   $ distrosync --debug export"
echo "   $ distrosync --debug install"
echo ""
echo "5. Desktop Integration"
echo "   - Launch from application menu"
echo "   - Double-click desktop entry"

echo -e "\n${BLUE}Installation Management:${NC}"
echo "1. Install DistroSync:"
echo "   $ sudo ./scripts/install.sh"
echo ""
echo "2. Verify Installation:"
echo "   $ ./scripts/check_installation.sh"
echo ""
echo "3. Test Functionality:"
echo "   $ ./scripts/test_functionality.sh"
echo ""
echo "4. Uninstall DistroSync:"
echo "   $ sudo ./scripts/uninstall.sh"

echo -e "\n${GREEN}For more information, see:${NC}"
echo "- README.md for general documentation"
echo "- docs/CHANGELOG.md for version history"
echo "- docs/CONTRIBUTING.md for development guide"