# DistroSync

A tool to sync package installations across Linux distributions. DistroSync helps you maintain consistency when switching between different Linux distributions by automatically exporting and importing your installed packages.

## Features

- Export list of installed packages from your current system
- Import and install packages on your new system
- Support for major package managers:
  - apt (Debian/Ubuntu)
  - dnf (Fedora/RHEL)
  - pacman (Arch/Manjaro/EndeavourOS)
  - zypper (openSUSE)

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/distrosync.git
cd distrosync
```

2. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate
```

3. Install using pip:
```bash
pip install -e .
```

## Usage

### Export Packages

To export your currently installed packages:

```bash
sudo venv/bin/distrosync export -o my_packages.json
```

This will create a JSON file containing your package list. Example output:

```json
{
  "metadata": {
    "source_distro": "endeavouros",
    "distro_name": "EndeavourOS",
    "distro_version": "rolling",
    "export_date": "2025-03-25T11:44:14"
  },
  "packages": [
    "base",
    "base-devel",
    "brave-bin",
    "firefox",
    "git",
    ...
  ]
}
```

### Import Packages

To install packages from a saved configuration:

```bash
sudo venv/bin/distrosync install -f my_packages.json
```

This will detect your current distribution and install the packages using the appropriate package manager.

### Debug Mode

To see detailed logging information, use the --debug flag:

```bash
sudo venv/bin/distrosync --debug export -o my_packages.json
```

## Requirements

- Python 3.8 or higher
- Linux operating system
- Root privileges for package installation (sudo)
- One of the supported package managers installed

## Supported Distributions

- Ubuntu/Debian/Pop!_OS (apt)
- Fedora/RHEL/CentOS (dnf)
- Arch Linux/Manjaro/EndeavourOS (pacman)
- openSUSE (zypper)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.