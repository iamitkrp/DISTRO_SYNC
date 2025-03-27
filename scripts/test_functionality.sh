#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
run_test() {
    local test_name=$1
    local command=$2
    echo -e "\n${BLUE}Testing: $test_name${NC}"
    echo "Command: $command"
    if eval "$command" > test_output.log 2>&1; then
        echo -e "${GREEN}✓ Test passed${NC}"
        cat test_output.log
        return 0
    else
        echo -e "${RED}✗ Test failed${NC}"
        cat test_output.log
        return 1
    fi
}

# Create test directory
TEST_DIR="test_run_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "${BLUE}Starting DistroSync Functionality Tests${NC}"
echo "================================================"

# Test 1: Version check
run_test "Version Check" "distrosync --version"

# Test 2: Help display
run_test "Help Command" "distrosync --help"

# Test 3: Export command help
run_test "Export Help" "distrosync export --help"

# Test 4: Install command help
run_test "Install Help" "distrosync install --help"

# Test 5: Distribution detection
run_test "Distribution Detection" "distrosync export --dry-run -o test_export.json"

# Test 6: Export packages
run_test "Export Packages" "distrosync export -o export_test.json"

# Test 7: Check exported file
if [ -f "export_test.json" ]; then
    echo -e "\n${BLUE}Checking exported file:${NC}"
    if jq . export_test.json > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Export file is valid JSON${NC}"
        jq . export_test.json
    else
        echo -e "${RED}✗ Export file is not valid JSON${NC}"
        cat export_test.json
    fi
else
    echo -e "${RED}✗ Export file not created${NC}"
fi

# Test 8: Install dry run
run_test "Install Dry Run" "distrosync install -f export_test.json --dry-run"

# Test 9: Desktop integration
echo -e "\n${BLUE}Testing Desktop Integration:${NC}"
if [ -f "/usr/share/applications/distrosync.desktop" ]; then
    echo -e "${GREEN}✓ Desktop entry installed${NC}"
    cat "/usr/share/applications/distrosync.desktop"
else
    echo -e "${RED}✗ Desktop entry not found${NC}"
fi

# Test 10: Terminal detection
run_test "Terminal Detection" "python -c \"
from distrosync.launcher import detect_terminal
print(f'Detected terminal: {detect_terminal()}')
\""

# Test 11: Cache directory
echo -e "\n${BLUE}Checking Cache Directory:${NC}"
CACHE_DIR="$HOME/.cache/distrosync"
if [ -d "$CACHE_DIR" ]; then
    echo -e "${GREEN}✓ Cache directory exists${NC}"
    ls -la "$CACHE_DIR"
else
    echo -e "${YELLOW}! Cache directory will be created on first run${NC}"
fi

# Cleanup
echo -e "\n${BLUE}Cleaning up test files...${NC}"
cd ..
rm -rf "$TEST_DIR"

echo -e "\n${BLUE}Test Summary${NC}"
echo "================================================"
echo -e "${GREEN}✓ Tests completed${NC}"
echo "You can now try running DistroSync through:"
echo "1. Command line: distrosync"
echo "2. Application menu"
echo "3. Desktop shortcut"
