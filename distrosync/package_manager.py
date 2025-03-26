"""
Package manager operations module
"""
import subprocess
import logging
from typing import List, Dict
from .detector import PackageManagerType

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PackageManager:
    """Handles package operations across different package managers."""
    
    def __init__(self, package_manager: PackageManagerType):
        self.package_manager = package_manager
        self._setup_commands()
        print(f"Initialized PackageManager with {package_manager}")
        logger.info(f"Initialized PackageManager with {package_manager}")
    
    def _setup_commands(self):
        """Set up commands for different package managers."""
        self.commands = {
            "apt": {
                "list": "dpkg --get-selections | grep -v deinstall | cut -f1",
                "install": "apt-get install -y",
                "update": "apt-get update",
            },
            "dnf": {
                "list": "dnf list installed | tail -n +2 | cut -d' ' -f1",
                "install": "dnf install -y",
                "update": "dnf check-update",
            },
            "pacman": {
                "list": "pacman -Qqe",
                "install": "pacman -S --noconfirm",
                "update": "pacman -Sy",
            },
            "zypper": {
                "list": "zypper search -i | tail -n +5 | cut -d'|' -f2 | tr -d ' '",
                "install": "zypper install -y",
                "update": "zypper refresh",
            },
        }
        print(f"Commands configured for {self.package_manager}")
        logger.info(f"Commands configured for {self.package_manager}")
    
    def _run_command(self, command: str) -> str:
        """
        Run a shell command and return its output.
        
        Args:
            command: The command to run
            
        Returns:
            str: Command output
            
        Raises:
            subprocess.CalledProcessError: If the command fails
        """
        print(f"Running command: {command}")
        logger.info(f"Running command: {command}")
        try:
            result = subprocess.run(
                command,
                shell=True,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            print(f"Command output: {result.stdout}")
            if result.stderr:
                print(f"Command stderr: {result.stderr}")
            logger.info(f"Command completed successfully")
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            print(f"Command failed: {e.stderr}")
            logger.error(f"Command failed: {e.stderr}")
            raise
    
    def update_packages(self):
        """
        Update package lists from repositories.
        
        Raises:
            ValueError: If package manager is not supported
            subprocess.CalledProcessError: If update fails
        """
        if self.package_manager not in self.commands:
            error_msg = f"Unsupported package manager: {self.package_manager}"
            print(error_msg)
            logger.error(error_msg)
            raise ValueError(error_msg)
            
        update_cmd = self.commands[self.package_manager]["update"]
        print(f"Updating package lists using command: {update_cmd}")
        logger.info(f"Updating package lists using command: {update_cmd}")
        self._run_command(update_cmd)
        print("Package lists updated successfully")
        logger.info("Package lists updated successfully")
    
    def list_packages(self) -> List[str]:
        """
        Get list of installed packages.
        
        Returns:
            List[str]: List of installed package names
            
        Raises:
            ValueError: If package manager is not supported
            subprocess.CalledProcessError: If command execution fails
        """
        if self.package_manager not in self.commands:
            error_msg = f"Unsupported package manager: {self.package_manager}"
            print(error_msg)
            logger.error(error_msg)
            raise ValueError(error_msg)
            
        command = self.commands[self.package_manager]["list"]
        print(f"Listing packages using command: {command}")
        logger.info(f"Listing packages using command: {command}")
        output = self._run_command(command)
        packages = [pkg for pkg in output.split('\n') if pkg]
        print(f"Found {len(packages)} packages")
        logger.info(f"Found {len(packages)} packages")
        return packages
    
    def install_packages(self, packages: List[str]):
        """
        Install specified packages.
        
        Args:
            packages: List of package names to install
            
        Raises:
            ValueError: If package manager is not supported
            subprocess.CalledProcessError: If installation fails
        """
        if not packages:
            print("No packages to install")
            logger.info("No packages to install")
            return
            
        if self.package_manager not in self.commands:
            error_msg = f"Unsupported package manager: {self.package_manager}"
            print(error_msg)
            logger.error(error_msg)
            raise ValueError(error_msg)
        
        # Then install packages
        print(f"Installing {len(packages)} packages: {', '.join(packages)}")
        logger.info(f"Installing {len(packages)} packages")
        install_cmd = f"{self.commands[self.package_manager]['install']} {' '.join(packages)}"
        self._run_command(install_cmd)
        print("Package installation completed")
        logger.info("Package installation completed")
    
    def get_package_manager_info(self) -> Dict[str, str]:
        """
        Get information about the current package manager.
        
        Returns:
            dict: Information about the package manager including name and commands
        """
        return {
            "name": self.package_manager,
            "commands": self.commands[self.package_manager]
        }