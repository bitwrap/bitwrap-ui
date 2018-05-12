from setuptools import setup, find_packages

DESC = """
# Bitwrap-ui

Web application written using Brython
"""

setup(
    name="bitwrap-io",
    version="0.1.0",
    author="Matthew York",
    author_email="myork@stackdump.com",
    description="A Webapp written for bitwrap.io",
    license='MIT',
    keywords='PNML petri-net state-machine brython',
    packages=find_packages(),
    include_package_data=True,
    install_requires=[],
    long_description=DESC,
    url="http://getbitwrap.com",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "License :: OSI Approved :: MIT License"
    ],
)
