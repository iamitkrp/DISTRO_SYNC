#!/bin/bash

LOG_FILE="verification.log"

echo "DistroSync Verification Test" > $LOG_FILE
echo "=========================" >> $LOG_FILE
date >> $LOG_FILE
echo "" >> $LOG_FILE

# Test export
echo "1. Testing Export..." >> $LOG_FILE
sudo PYTHONPATH=$PYTHONPATH venv/bin/distrosync export -o verify_export.json 2>&1 >> $LOG_FILE
if [ -f verify_export.json ]; then
    echo "✓ Export successful" >> $LOG_FILE
    echo "Export file contents:" >> $LOG_FILE
    cat verify_export.json >> $LOG_FILE
else
    echo "✗ Export failed" >> $LOG_FILE
fi
echo "" >> $LOG_FILE

# Test package manager detection
echo "2. Testing Package Manager Detection..." >> $LOG_FILE
cat /etc/os-release >> $LOG_FILE
echo "" >> $LOG_FILE

# Test package installation
echo "3. Testing Package Installation..." >> $LOG_FILE
echo "Checking if neofetch is installed:" >> $LOG_FILE
which neofetch >> $LOG_FILE 2>&1
if command -v neofetch >/dev/null 2>&1; then
    echo "✓ neofetch is installed" >> $LOG_FILE
    neofetch --version >> $LOG_FILE 2>&1
else
    echo "✗ neofetch is not installed" >> $LOG_FILE
fi

echo "" >> $LOG_FILE
echo "Verification complete. Check verification.log for results."

# Display results
cat verification.log