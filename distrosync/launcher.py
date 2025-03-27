#!/usr/bin/env python3
"""
Terminal launcher for DistroSync
"""
import os
import sys
import time
import subprocess
from pathlib import Path

def detect_terminal():
    """Detect the available terminal emulator."""
    terminals = [
        ('konsole', ['konsole', '-e']),
        ('gnome-terminal', ['gnome-terminal', '--']),
        ('xfce4-terminal', ['xfce4-terminal', '-e']),
        ('xterm', ['xterm', '-e']),
    ]
    
    for term, cmd in terminals:
        try:
            if subprocess.run(['which', term], stdout=subprocess.PIPE, stderr=subprocess.PIPE).returncode == 0:
                print(f"Found terminal: {term}")
                return cmd
        except Exception as e:
            continue
    
    return None

def show_startup_message():
    """Show a startup message in case of delay."""
    print("Starting DistroSync...")
    print("If terminal doesn't open automatically, please run 'distrosync' from command line.")
    sys.stdout.flush()

def main():
    """Launch DistroSync in a terminal."""
    show_startup_message()
    
    # Small delay to ensure message is visible
    time.sleep(1)
    
    terminal = detect_terminal()
    
    if not terminal:
        print("Error: No supported terminal emulator found")
        print("Please install one of: konsole, gnome-terminal, xfce4-terminal, or xterm")
        sys.exit(1)
    
    # Construct the command
    distrosync_path = '/usr/local/bin/distrosync'
    
    if not os.path.exists(distrosync_path):
        print(f"Error: {distrosync_path} not found")
        print("Please make sure DistroSync is properly installed")
        sys.exit(1)
    
    cmd = terminal + [distrosync_path]
    
    try:
        print(f"Launching with command: {' '.join(cmd)}")
        sys.stdout.flush()
        subprocess.run(cmd)
    except Exception as e:
        print(f"Error launching DistroSync: {str(e)}")
        print("Please run 'distrosync' from command line instead")
        sys.exit(1)

if __name__ == "__main__":
    main()