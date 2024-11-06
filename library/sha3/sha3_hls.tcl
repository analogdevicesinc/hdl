# Copyright (C) 2019-2022, Xilinx, Inc.
# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# vitis hls makefile-generator v2.0.0
source ../../scripts/adi_env.tcl
# ------------------------------------------------------------------------------
# Vitis Security
# ------------------------------------------------------------------------------
set XF_PROJ_ROOT "$ad_hdl_dir/library/sha3"
# ------------------------------------------------------------------------------
# Vitis HLS Project Information
# ------------------------------------------------------------------------------
set CSIM 1
set CSYNTH 1
set COSIM 1
set VIVADO_SYN 0
set VIVADO_IMPL 1
set PROJ_DIR "$XF_PROJ_ROOT"
set SOURCE_DIR "$PROJ_DIR"
set PROJ_NAME "sha3.hls"
set PROJ_TOP "sha3_ip_512"
set SOLUTION_NAME "sol1"
set SOLUTION_PART "xczu9eg-ffvb1156-2-e"
set SOLUTION_CLKP 3.333
#xczu9eg-ffvb1156-2-e #zcu102
#xc7z020clg484-1 #zed
#xcu200-fsgd2104-2-e

# ------------------------------------------------------------------------------
# C Simulation / CoSimulation Library References
#------------------------------------------------------------------------------
set VITIS_LIBRARIES_NAME "Vitis_Libraries"
set SECURITY_INC_FLAGS "-I$ad_hdl_dir/../$VITIS_LIBRARIES_NAME/security/L1/include"

# ------------------------------------------------------------------------------
# Create Project
# ------------------------------------------------------------------------------
open_project -reset $PROJ_NAME

# ------------------------------------------------------------------------------
# Add C++ source and Testbench files with Security includes
# ------------------------------------------------------------------------------
add_files "${PROJ_DIR}/sha3_ip_512.cpp" -cflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build"
add_files "${PROJ_DIR}/sha3_ip_512.hpp" -cflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build"
add_files -tb "${PROJ_DIR}/main.cpp" -cflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${SECURITY_INC_FLAGS} -I${PROJ_DIR}/build"

# ------------------------------------------------------------------------------
# Create Project and Solution
# ------------------------------------------------------------------------------
set_top $PROJ_TOP
open_solution -reset $SOLUTION_NAME
set_part $SOLUTION_PART
config_schedule -effort high
config_compile -name_max_length 64
create_clock -period $SOLUTION_CLKP -name usr_clk_300
set_clock_uncertainty 1.05


# ------------------------------------------------------------------------------
# Run Vitis HLS Stages
# ------------------------------------------------------------------------------
if {$CSIM == 1} {
  csim_design
}

if {$CSYNTH == 1} {
  csynth_design
}

if {$COSIM == 1} {
  cosim_design
}

if {$VIVADO_SYN == 1} {
  export_design -flow syn -rtl verilog
}

if {$VIVADO_IMPL == 1} {
  export_design -flow impl -rtl verilog
}

exit
