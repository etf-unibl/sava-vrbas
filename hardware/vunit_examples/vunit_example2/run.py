#!/usr/bin/env python3
from pathlib import Path
from vunit import VUnit

vu = VUnit.from_argv()
SRC_PATH = Path(__file__).parent / "src"
vu.add_library("right_shifter_lib").add_source_files(SRC_PATH / "*.vhd")
vu.add_library("tb_right_shifter_lib").add_source_files("*.vhd")

# Run vunit function
vu.main()