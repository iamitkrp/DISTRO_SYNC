"""
Command-line interface for DistroSync
"""
import os
import sys
import logging
import click
from pathlib import Path
from . import __version__
from .detector import DistroDetector
from .package_manager import PackageManager
from .config import ConfigManager

def setup_logging(debug=False):
    """Setup logging configuration."""
    # Get user's cache directory (follows XDG Base Directory specification)
    log_dir = os.path.join(os.path.expanduser('~'), '.cache', 'distrosync')
    os.makedirs(log_dir, exist_ok=True)
    
    log_file = os.path.join(log_dir, 'distrosync.log')
    
    logging.basicConfig(
        level=logging.DEBUG if debug else logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler(log_file)
        ]
    )
    return logging.getLogger(__name__)

def print_banner():
    """Print welcome banner."""
    click.clear()
    click.secho(f"""
╔═══════════════════════════════════════════╗
║             DistroSync v{__version__:<16}║
║    Sync packages across Linux distros     ║
╚═══════════════════════════════════════════╝
    """, fg='blue', bold=True)

def confirm_action(packages, action):
    """Show packages and confirm action."""
    click.echo(f"\nPackages to {action}:")
    for i, pkg in enumerate(packages, 1):
        click.echo(f"  {i:3d}. {pkg}")
    click.echo(f"\nTotal: {len(packages)} packages")
    
    return click.confirm(f"\nDo you want to proceed with {action}?")

@click.group(invoke_without_command=True)
@click.version_option(version=__version__, prog_name="DistroSync")
@click.option('--debug/--no-debug', default=False, help='Enable debug logging')
@click.pass_context
def main(ctx, debug):
    """DistroSync - Sync your packages across Linux distributions."""
    ctx.ensure_object(dict)
    ctx.obj['logger'] = setup_logging(debug)

    if ctx.invoked_subcommand is None:
        print_banner()
        
        # Show menu
        click.echo("\nWhat would you like to do?")
        choice = click.prompt(
            "\n1. Export packages from this system"
            "\n2. Install packages on this system"
            "\n3. Exit"
            "\n\nEnter your choice",
            type=click.Choice(['1', '2', '3']),
            show_choices=False
        )
        
        if choice == '1':
            ctx.invoke(export)
        elif choice == '2':
            ctx.invoke(install)
        else:
            sys.exit(0)

@main.command()
@click.option('--output', '-o', default="distrosync.json", help="Output file for package list")
@click.pass_context
def export(ctx, output):
    """Export the list of installed packages."""
    logger = ctx.obj['logger']
    print_banner()
    click.secho("\n📦 Exporting Packages", fg='green', bold=True)
    
    try:
        # Initialize components
        click.echo("\n🔍 Detecting system...")
        detector = DistroDetector()
        pkg_manager_type = detector.get_package_manager()
        info = detector.get_distro_info()
        click.echo(f"   • Distribution: {info['distro_name']} ({info['distro_version']})")
        click.echo(f"   • Package Manager: {pkg_manager_type}")
        
        pkg_manager = PackageManager(pkg_manager_type)
        config = ConfigManager()
        
        # Get package list
        click.echo("\n📋 Getting list of installed packages...")
        packages = pkg_manager.list_packages()
        
        # Show packages and confirm
        if confirm_action(packages, "export"):
            # Save to file
            click.echo(f"\n💾 Saving package list to {output}...")
            config.save_packages(packages, output)
            click.secho(f"\n✅ Successfully exported {len(packages)} packages to {output}", fg='green')
        else:
            click.echo("\nExport cancelled.")
        
    except Exception as e:
        click.secho(f"\n❌ Error: {str(e)}", fg='red', err=True)
        logger.error(f"Export failed: {str(e)}", exc_info=True)
        sys.exit(1)

@main.command()
@click.option('--file', '-f', type=click.Path(exists=True), help="Input file with package list")
@click.option('--dry-run/--no-dry-run', default=False, help='Show what would be installed without installing')
@click.pass_context
def install(ctx, file, dry_run):
    """Install packages from a saved list."""
    logger = ctx.obj['logger']
    print_banner()
    click.secho("\n📥 Installing Packages", fg='green', bold=True)
    
    try:
        # Initialize components
        click.echo("\n🔍 Detecting system...")
        detector = DistroDetector()
        pkg_manager_type = detector.get_package_manager()
        info = detector.get_distro_info()
        click.echo(f"   • Distribution: {info['distro_name']} ({info['distro_version']})")
        click.echo(f"   • Package Manager: {pkg_manager_type}")
        
        pkg_manager = PackageManager(pkg_manager_type)
        config = ConfigManager()
        
        # Get input file
        if not file:
            file = click.prompt(
                "\nEnter the path to your package list",
                default="distrosync.json",
                type=str
            )
        
        # Load package list
        click.echo(f"\n📋 Loading package list from {file}...")
        packages = config.load_packages(file)
        
        if dry_run:
            click.secho("\n🔍 DRY RUN - No packages will be installed", fg='yellow')
            click.echo("\nWould run the following commands:")
            update_cmd = pkg_manager.commands[pkg_manager_type]["update"]
            install_cmd = f"{pkg_manager.commands[pkg_manager_type]['install']} {' '.join(packages)}"
            click.echo(f"  1. {update_cmd}")
            click.echo(f"  2. {install_cmd}")
            return
        
        # Show packages and confirm
        if confirm_action(packages, "install"):
            click.echo("\n🔄 Updating package lists...")
            pkg_manager.update_packages()
            
            click.echo("\n📦 Installing packages...")
            pkg_manager.install_packages(packages)
            click.secho("\n✅ Successfully installed all packages", fg='green')
        else:
            click.echo("\nInstallation cancelled.")
            
    except Exception as e:
        click.secho(f"\n❌ Error: {str(e)}", fg='red', err=True)
        logger.error(f"Installation failed: {str(e)}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    main()