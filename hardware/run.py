#!/usr/bin/env python3
from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent
vu = VUnit.from_argv()
SRC_PATH = ROOT / "design"/"*"
TB_PATH = ROOT / "tests"
vu.add_library("common_lib").add_source_files(SRC_PATH/ "*.vhd")
vu.add_library("tb_common_lib").add_source_files(TB_PATH/ "*.vhd")

vu.main()