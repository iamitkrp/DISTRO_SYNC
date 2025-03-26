from setuptools import setup, find_packages

setup(
    name="distrosync",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "click>=8.0.0",  
        "distro>=1.7.0",  
    ],
    entry_points={
        "console_scripts": [
            "distrosync=distrosync.cli:main",
        ],
    },
    author="Amit",
    description="A tool to sync package installations across Linux distributions",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/distrosync",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: POSIX :: Linux",
    ],
    python_requires=">=3.8",
)