# Contributing to DistroSync

Thank you for your interest in contributing to DistroSync! This document provides information about the project structure and how to get started.

## Project Structure

```
distrosync/
├── distrosync/               # Main package directory
│   ├── __init__.py          # Package initialization
│   ├── __main__.py          # Entry point for python -m distrosync
│   ├── cli.py               # Command-line interface
│   ├── config.py            # Configuration management
│   ├── detector.py          # Distribution detection
│   ├── launcher.py          # Desktop integration launcher
│   └── package_manager.py   # Package management operations
│
├── media/                    # Screenshots and images
│   ├── ds_desktop_1.png     # Desktop integration screenshot
│   ├── exporting_2.png      # Package export process
│   ├── Installing.png       # Installation process
│   └── installing-final.png # Installation complete
│
├── scripts/                  # Installation and maintenance scripts
│   ├── install.sh           # Installation script
│   ├── uninstall.sh         # Uninstallation script
│   ├── cleanup.sh           # Repository cleanup
│   └── check_installation.sh # Installation verification
│
├── desktop/                  # Desktop integration files
│   └── distrosync.desktop   # Application launcher
│
├── docs/                     # Documentation
│   ├── CHANGELOG.md         # Version history
│   └── CONTRIBUTING.md      # This file
│
├── setup.py                 # Package setup script
├── MANIFEST.in              # Package manifest
├── README.md               # Project documentation
└── LICENSE                 # MIT License
```

## Development Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate
```

2. Install development dependencies:
```bash
pip install -r requirements-dev.txt
```

3. Install package in editable mode:
```bash
pip install -e .
```

## Code Style

- Follow PEP 8 guidelines
- Use type hints where possible
- Include docstrings for all modules, classes, and functions
- Keep functions focused and small
- Write tests for new functionality

## Screenshots and Media

When adding screenshots or media files:

1. Place files in the `media/` directory
2. Use descriptive filenames with context (e.g., `feature_name_1.png`)
3. Optimize images for web viewing
4. Update README.md with new screenshots
5. Include alt text for accessibility

## Testing

Run tests using pytest:
```bash
python -m pytest tests/
```

## Making Changes

1. Fork the repository
2. Create a new branch for your feature
3. Make your changes
4. Write tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Documentation

Documentation is written in Markdown. Key files:
- README.md: Main project documentation
- CHANGELOG.md: Version history and changes
- CONTRIBUTING.md: Development guide (this file)

Update documentation when:
- Adding new features
- Changing existing functionality
- Adding new screenshots
- Updating installation instructions

## Release Process

1. Update version in:
   - distrosync/__init__.py
   - setup.py
   - CHANGELOG.md
2. Run tests
3. Create release tag
4. Build and publish package

## Getting Help

If you need help:
- Check existing issues
- Read the documentation
- Ask questions in discussions
- Contact maintainers

Thank you for contributing to DistroSync!