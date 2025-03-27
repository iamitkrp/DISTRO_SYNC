from setuptools import setup, find_packages

# Read the version from __init__.py
with open('distrosync/__init__.py', 'r') as f:
    for line in f:
        if line.startswith('__version__'):
            version = line.strip().split('=')[1].strip(' \'"')
            break

# Read the long description from README.md
with open('README.md', 'r', encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='distrosync',
    version=version,
    author='DistroSync Contributors',
    author_email='your.email@example.com',
    description='Sync package installations across Linux distributions',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/yourusername/distrosync',
    packages=find_packages(),
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Topic :: System :: Installation/Setup',
        'Topic :: System :: Systems Administration',
        'Topic :: System :: Package Management',
    ],
    python_requires='>=3.8',
    install_requires=[
        'click>=8.0.0',
        'distro>=1.7.0',
    ],
    entry_points={
        'console_scripts': [
            'distrosync=distrosync.cli:main',
        ],
    },
    package_data={
        'distrosync': ['py.typed'],
    },
    data_files=[
        ('share/applications', ['desktop/distrosync.desktop']),
        ('share/distrosync/scripts', [
            'scripts/install.sh',
            'scripts/uninstall.sh',
            'scripts/check_installation.sh',
        ]),
    ],
    include_package_data=True,
    zip_safe=False,
    keywords='linux package manager sync distribution',
)