###############################################################################
## Copyright (C) 2022-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

# load scripts
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# TWOLANES: parameter describing the number of lanes
# - 1: in two-lane mode (default)
# - 0: in one-lane mode
#
# ADC_RES: parameter describing the ADC input resolution, thus selecting
#          between ADAQ23878 (18-bit, default) and ADAQ23875/ADAQ23876 (16-bit)
# - 18: 18 bits, ADAQ23878 (default)
# - 16: 16 bits, ADAQ23875 & ADAQ23876
#
# USE_MMCM: parameter used to select between the 100MHz ref_clk or passing it
#           through a clk_wizard and increase it to 120MHz
# - 1: use the default clocking scheme
# - 0: use the clk_wizard to increase the clk frequency
#
# The valid configurations for each supported evaluation board, depending on
# the above parameters, are:
#
# Eval board | ADC_RES | TWOLANES | USE_MMCM |
# ============================================
# ADAQ23875  | 16      | 0 or 1   | 0 or 1   |
# ADAQ23876  | 16      | 0 or 1   | 0 or 1   |
# ADAQ23878  | 18      | 0 or 1   | 0 or 1   |

adi_project adaq23875_zed 0 [list \
  TWOLANES  [get_env_param TWOLANES  1 ] \
  ADC_RES   [get_env_param ADC_RES  18 ] \
  USE_MMCM  [get_env_param USE_MMCM  0 ]]

# Base files
adi_project_files adaq23875_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

# Add contraint for MMCM 0 - 100MHz or 1 - 120MHz
if { [get_env_param USE_MMCM 0] == 1 } {
  adi_project_files adaq23875_zed [list "timing_mmcm.xdc" ]
} else {
  adi_project_files adaq23875_zed [list "timing_default.xdc" ]
}

adi_project_run adaq23875_zed
