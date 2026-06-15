###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#    Use over-writable parameters from the environment.
#
#    e.g. JESD only
#      RX-OS Non-LinkSharing:
#       - JESD204C: make JESD_MODE=64B66B ORX_ENABLE=1 TX_LANE_RATE=16.22 RX_LANE_RATE=16.22 \
#                       RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 RX_OS_JESD_NP=16 RX_JESD_M=4 RX_JESD_L=2 \
#                       RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_M=4 TX_JESD_L=2 TX_JESD_S=1 TX_JESD_NP=16
#
#    e.g. XCVR only
#      make PLL_TYPE=QPLL0 REF_CLK=491.5151515 LANE_RATE=16.22
#
#    e.g. JESD and XCVR
#      make JESD_MODE=64B66B ORX_ENABLE=1 TX_LANE_RATE=16.22 RX_LANE_RATE=16.22 \
#           RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 RX_OS_JESD_NP=16 RX_JESD_M=4 RX_JESD_L=2 \
#           RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_M=4 TX_JESD_L=2 TX_JESD_S=1 TX_JESD_NP=16 PLL_TYPE=QPLL0 REF_CLK=491.5151515 LANE_RATE=16.22

# adi_xcvr_project runs the xcvr_wizard project sub-build and returns a
# dictionary with the paths to the `cfng` file containing the modified
# parameters and to the `_common.v` file for GTXE2.
#
#   e.g. call for make with parameters
#   set xcvr_config_paths [adi_xcvr_project [list \
#     LANE_RATE 16.22\
#     REF_CLK 491.5151515\
#     PLL_TYPE QPLL0\
#   ]]

global xcvr_config_paths

# Parameter description:
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL0/QPLL1]
#   JESD_MODE: Used link layer encoder mode [64B66B - JESD 204C, 8B10B - JESD 204B]
#   XCVR_RX_LANE_RATE: Value of lane rate for the RX link [gbps] (Optional)
#   XCVR_RX_REF_CLK: Value of the reference clock for the RX link [MHz] (usually XCVR_RX_LANE_RATE/20 or XCVR_RX_LANE_RATE/40) (Optional)
#   XCVR_RX_PLL_TYPE: The PLL used for driving the RX link [CPLL/QPLL1/QPLL0] (Optional)

set JESD_MODE [get_env_param JESD_MODE 64B66B]

set xcvr_config_paths [adi_xcvr_project [list \
  LANE_RATE [get_env_param LANE_RATE 16.22] \
  REF_CLK   [get_env_param REF_CLK   491.5151515] \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL0] \
  JESD_MODE $JESD_MODE \
]]

# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#   ORX_ENABLE : Additional data path for RX-OS
#      0 - Disabled (used for profiles with RX-OS disabled)
#      1 - Enabled (used for profiles with RX-OS enabled)
#   TX_LANE_RATE : Transceiver line rate of the TX link
#   RX_LANE_RATE : Transceiver line rate of the RX link
#   [TX/RX/RX_OS]_NUM_LINKS : Number of links
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#   [TX/RX/RX_OS]_TPL_WIDTH : TPL data path width in bits

adi_project adrv903x_zcu102 0 [list \
  JESD_MODE       $JESD_MODE \
  ORX_ENABLE      [get_env_param ORX_ENABLE         1] \
  TX_LANE_RATE    [get_env_param TX_LANE_RATE   16.22] \
  RX_LANE_RATE    [get_env_param RX_LANE_RATE   16.22] \
  TX_NUM_LINKS    [get_env_param TX_NUM_LINKS       1] \
  RX_NUM_LINKS    [get_env_param RX_NUM_LINKS       1] \
  RX_OS_NUM_LINKS [get_env_param RX_OS_NUM_LINKS    1] \
  TX_JESD_M       [get_env_param TX_JESD_M          4] \
  TX_JESD_L       [get_env_param TX_JESD_L          2] \
  TX_JESD_S       [get_env_param TX_JESD_S          1] \
  TX_JESD_NP      [get_env_param TX_JESD_NP        16] \
  TX_TPL_WIDTH    [get_env_param TX_TPL_WIDTH      {}] \
  RX_JESD_M       [get_env_param RX_JESD_M          4] \
  RX_JESD_L       [get_env_param RX_JESD_L          2] \
  RX_JESD_S       [get_env_param RX_JESD_S          1] \
  RX_JESD_NP      [get_env_param RX_JESD_NP        16] \
  RX_TPL_WIDTH    [get_env_param RX_TPL_WIDTH      {}] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M       4] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L       2] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S       1] \
  RX_OS_JESD_NP   [get_env_param RX_OS_JESD_NP     16] \
  RX_OS_TPL_WIDTH [get_env_param RX_OS_TPL_WIDTH   {}] \
]

adi_project_files adrv903x_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run adrv903x_zcu102
