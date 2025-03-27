# Changelog

All notable changes to DistroSync will be documented in this file.

## [0.1.0] - 2025-03-26

### Added
- Initial release with core functionality
- Package management features:
  - Export installed packages to JSON
  - Import and install packages from JSON
  - Support for major package managers (apt, dnf, pacman, zypper)
- User interface:
  - Interactive CLI with progress indicators
  - Desktop integration with terminal auto-detection
  - Application menu entry
- System integration:
  - Automated installation script
  - Installation verification tool
  - Desktop entry for GUI launching
  - Proper log management

### Supported Features
- Distribution detection
- Package manager auto-detection
- Package list export/import
- Dry-run installation mode
- Terminal auto-detection
- System-wide installation
- User-friendly progress indicators

### Supported Package Managers
- apt (Debian/Ubuntu)
- dnf (Fedora/RHEL)
- pacman (Arch/Manjaro/EndeavourOS)
- zypper (openSUSE)

## [Upcoming Features]
- Flatpak/Snap support
- Package name translation between distributions
- Dependency resolution
- Configuration file backup/restore
- GUI interface option
- Package categories and groups
- Repository management
- System settings synchronization