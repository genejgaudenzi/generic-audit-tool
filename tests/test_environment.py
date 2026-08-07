"""Checks for the committed development-environment contract."""

import sys


def test_minimum_supported_python_version() -> None:
    assert sys.version_info >= (3, 12)
