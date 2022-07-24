#!/usr/bin/env python
"""Package setup script"""

from __future__ import absolute_import
import json
from setuptools import setup, find_packages

if __name__ == '__main__':
    # Provide static information in setup.json
    # such that it can be discovered automatically
    with open('setup.json', 'r', encoding='utf8') as info:
        kwargs = json.load(info)
        with open('README.md', 'r', encoding='utf8') as readme:
            setup(packages=find_packages(),
                  long_description=readme.read(),
                  long_description_content_type='text/markdown',
                  **kwargs)
