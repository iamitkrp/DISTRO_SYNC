#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." &> /dev/null && pwd )"

echo -e "${BLUE}Installing DistroSync...${NC}"

# Create virtual environment if it doesn't exist
if [ ! -d "$PROJECT_ROOT/venv" ]; then
    echo -e "\n${BLUE}Creating virtual environment...${NC}"
    python -m venv "$PROJECT_ROOT/venv"
fi

# Activate virtual environment and install package
source "$PROJECT_ROOT/venv/bin/activate"
pip install -e "$PROJECT_ROOT"

# Create directories if they don't exist
sudo mkdir -p /opt/distrosync
sudo mkdir -p /usr/local/bin

# Copy files
echo -e "\n${BLUE}Copying files...${NC}"
sudo cp -r "$PROJECT_ROOT/venv" /opt/distrosync/
sudo cp -r "$PROJECT_ROOT/distrosync" /opt/distrosync/
sudo cp "$PROJECT_ROOT/desktop/distrosync.desktop" /usr/share/applications/

# Make launcher executable
echo -e "\n${BLUE}Setting up launcher...${NC}"
sudo chmod +x /opt/distrosync/distrosync/launcher.py

# Create launcher script
echo -e "\n${BLUE}Creating command line launcher...${NC}"
cat << 'EOF' | sudo tee /usr/local/bin/distrosync > /dev/null
#!/bin/bash
source /opt/distrosync/venv/bin/activate
PYTHONPATH=/opt/distrosync python -m distrosync "$@"
EOF

# Make command line launcher executable
sudo chmod +x /usr/local/bin/distrosync

# Update desktop database
echo -e "\n${BLUE}Updating desktop database...${NC}"
sudo update-desktop-database

# Set proper permissions
echo -e "\n${BLUE}Setting permissions...${NC}"
sudo chown -R root:root /opt/distrosync
sudo chmod -R 755 /opt/distrosync

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "You can now:
1. Run 'distrosync' from terminal
2. Launch from application menu
3. Double-click distrosync.desktop file

To verify installation, run:
  $PROJECT_ROOT/scripts/check_installation.sh"