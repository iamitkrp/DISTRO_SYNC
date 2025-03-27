#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}Cleaning up temporary and generated files...${NC}"

# List of files to remove
files=(
    "distrosync.json"
    "distrosync.log"
    "verification.log"
    "verify_export.json"
    "verify_installation.sh"
    "minimal_test.json"
    "my_packages.json"
    "test_output.log"
)

# Remove individual files
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "Removed: $file"
    fi
done

# Remove directories
if [ -d "tests" ]; then
    rm -rf tests/
    echo "Removed: tests/"
fi

if [ -d "distrosync.egg-info" ]; then
    rm -rf distrosync.egg-info/
    echo "Removed: distrosync.egg-info/"
fi

echo -e "${GREEN}Cleanup complete!${NC}"