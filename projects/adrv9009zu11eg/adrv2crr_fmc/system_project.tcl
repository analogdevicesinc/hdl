###############################################################################
## Copyright (C) 2019-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
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
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make TX_JESD_L=4 RX_OS_JESD_M=8
#      make TX_JESD_M=8 TX_JESD_L=4 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2
#      make TX_JESD_M=4 TX_JESD_L=2 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2

# Parameter description:
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#

adi_project_create adrv9009zu11eg 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M     8] \
  RX_JESD_L       [get_env_param RX_JESD_L     4] \
  RX_JESD_S       [get_env_param RX_JESD_S     1] \
  TX_JESD_M       [get_env_param TX_JESD_M     8] \
  TX_JESD_L       [get_env_param TX_JESD_L     8] \
  TX_JESD_S       [get_env_param TX_JESD_S     1] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  4] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  4] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1] \
  CORUNDUM        [get_env_param CORUNDUM      0] \
] "xczu11eg-ffvf1517-2-i"

adi_project_files adrv9009zu11eg [list \
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

if {[get_env_param CORUNDUM 0] == 1} {
  adi_project_files adrv9009zu11eg [list \
    "system_constr_corundum.xdc" \
    "system_top_corundum.v" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_clock_cdc.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/tdma_ber_ch.tcl"
  ]
} else {
  adi_project_files adrv9009zu11eg [list \
    "system_top.v" \
  ]
}

adi_project_run adrv9009zu11eg
