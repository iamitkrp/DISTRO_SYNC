"""
Configuration management module
"""
import json
import os
import logging
from datetime import datetime
from typing import List, Dict
import distro

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class ConfigManager:
    """Manages saving and loading of package configurations."""
    
    def save_packages(self, packages: List[str], output_file: str):
        """
        Save package list to a JSON file.
        
        Args:
            packages: List of package names
            output_file: Path to save the configuration
            
        Raises:
            IOError: If file cannot be written
        """
        logger.info(f"Preparing to save package list to {output_file}")
        config = {
            "metadata": {
                "source_distro": distro.id(),
                "distro_name": distro.name(),
                "distro_version": distro.version(),
                "export_date": datetime.now().isoformat(),
            },
            "packages": packages
        }
        
        logger.info(f"Created configuration with {len(packages)} packages")
        
        # Create directory if it doesn't exist
        output_dir = os.path.dirname(os.path.abspath(output_file))
        if output_dir:
            logger.info(f"Creating directory if needed: {output_dir}")
            os.makedirs(output_dir, exist_ok=True)
        
        try:
            logger.info(f"Writing configuration to {output_file}")
            with open(output_file, 'w') as f:
                json.dump(config, f, indent=2)
            logger.info("Configuration saved successfully")
        except IOError as e:
            logger.error(f"Failed to save configuration: {str(e)}")
            raise IOError(f"Failed to save configuration to {output_file}: {str(e)}")
    
    def load_packages(self, input_file: str) -> List[str]:
        """
        Load package list from a JSON file.
        
        Args:
            input_file: Path to the configuration file
            
        Returns:
            List[str]: List of package names
            
        Raises:
            IOError: If file cannot be read
            ValueError: If file format is invalid
        """
        logger.info(f"Loading package list from {input_file}")
        try:
            with open(input_file, 'r') as f:
                config = json.load(f)
            logger.info("Successfully read configuration file")
        except IOError as e:
            logger.error(f"Failed to read configuration: {str(e)}")
            raise IOError(f"Failed to read configuration from {input_file}: {str(e)}")
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON format: {str(e)}")
            raise ValueError(f"Invalid JSON format in {input_file}: {str(e)}")
        
        if not isinstance(config, dict) or 'packages' not in config:
            logger.error("Invalid configuration format: missing 'packages' field")
            raise ValueError(f"Invalid configuration format in {input_file}")
        
        packages = config['packages']
        if not isinstance(packages, list):
            logger.error("Invalid packages format: not a list")
            raise ValueError(f"Invalid packages format in {input_file}")
        
        logger.info(f"Successfully loaded {len(packages)} packages")
        return packages
    
    def get_config_info(self, config_file: str) -> Dict:
        """
        Get information about a configuration file.
        
        Args:
            config_file: Path to the configuration file
            
        Returns:
            dict: Configuration metadata
            
        Raises:
            IOError: If file cannot be read
            ValueError: If file format is invalid
        """
        logger.info(f"Reading configuration info from {config_file}")
        try:
            with open(config_file, 'r') as f:
                config = json.load(f)
            logger.info("Successfully read configuration file")
        except IOError as e:
            logger.error(f"Failed to read configuration: {str(e)}")
            raise IOError(f"Failed to read configuration from {config_file}: {str(e)}")
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON format: {str(e)}")
            raise ValueError(f"Invalid JSON format in {config_file}: {str(e)}")
        
        if not isinstance(config, dict) or 'metadata' not in config:
            logger.error("Invalid configuration format: missing 'metadata' field")
            raise ValueError(f"Invalid configuration format in {config_file}")
        
        logger.info("Successfully retrieved configuration metadata")
        return config['metadata']