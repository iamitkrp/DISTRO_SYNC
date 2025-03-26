"""
Distribution detector module
"""
import os
import logging
import distro
from typing import Literal

# Configure logging
logger = logging.getLogger(__name__)

PackageManagerType = Literal["apt", "dnf", "pacman", "zypper"]

class DistroDetector:
    """Detects the current Linux distribution and its package manager."""
    
    DISTRO_TO_PKG_MANAGER = {
        "ubuntu": "apt",
        "debian": "apt",
        "pop": "apt",
        "fedora": "dnf",
        "rhel": "dnf",
        "centos": "dnf",
        "arch": "pacman",
        "manjaro": "pacman",
        "endeavouros": "pacman",
        "opensuse": "zypper",
        "suse": "zypper"
    }

    PACKAGE_MANAGER_PATHS = {
        "apt": "/usr/bin/apt",
        "dnf": "/usr/bin/dnf",
        "pacman": "/usr/bin/pacman",
        "zypper": "/usr/bin/zypper"
    }
    
    def get_package_manager(self) -> PackageManagerType:
        """
        Determine the package manager based on the current distribution.
        
        Returns:
            str: The name of the package manager (apt, dnf, pacman, or zypper)
            
        Raises:
            ValueError: If the distribution's package manager is not supported
        """
        # Get the distribution ID (e.g., 'ubuntu', 'fedora')
        distro_id = distro.id()
        logger.info(f"Detected distribution ID: {distro_id}")
        
        # First try to detect by distribution ID
        pkg_manager = self.DISTRO_TO_PKG_MANAGER.get(distro_id)
        if pkg_manager:
            logger.info(f"Found package manager {pkg_manager} for distribution {distro_id}")
            # Verify the package manager is installed
            if os.path.exists(self.PACKAGE_MANAGER_PATHS.get(pkg_manager, "")):
                return pkg_manager
            else:
                logger.warning(f"Package manager {pkg_manager} not found at expected path")
        
        # If not found by ID, try to detect by checking which package managers are installed
        logger.info("Attempting to detect package manager by checking installed binaries")
        for pm, path in self.PACKAGE_MANAGER_PATHS.items():
            if os.path.exists(path):
                logger.info(f"Found installed package manager: {pm}")
                return pm
        
        # If we get here, we couldn't detect a supported package manager
        error_msg = (
            f"Could not detect supported package manager for distribution {distro_id}. "
            f"Supported distributions: {', '.join(sorted(self.DISTRO_TO_PKG_MANAGER.keys()))}"
        )
        logger.error(error_msg)
        raise ValueError(error_msg)
    
    def get_distro_info(self) -> dict:
        """
        Get detailed information about the current distribution.
        
        Returns:
            dict: Information about the distribution including id, version, etc.
        """
        info = {
            "id": distro.id(),
            "distro_name": distro.name(),  # Changed from 'name' to 'distro_name'
            "distro_version": distro.version(),  # Changed from 'version' to 'distro_version'
            "codename": distro.codename(),
            "package_manager": self.get_package_manager()
        }
        logger.info(f"Distribution info: {info}")
        return info