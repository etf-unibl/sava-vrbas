#!/usr/bin/env python3
from pathlib import Path
from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()
SRC_PATH = Path(__file__).parent / "src"

vu.add_library("multiplier_lib").add_source_files(SRC_PATH / "*.vhd")
vu.add_library("tb_multipier_lib").add_source_files(SRC_PATH / "test" / "*.vhd")

# Run vunit function
vu.main()