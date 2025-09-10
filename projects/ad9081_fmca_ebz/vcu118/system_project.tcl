###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
set ADI_POST_ROUTE_SCRIPT [file normalize $ad_hdl_dir/projects/scripts/auto_timing_fix_xilinx.tcl]

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make JESD_MODE=64B66B RX_LANE_RATE=24.75 TX_LANE_RATE=12.375 RX_JESD_L=4 TX_JESD_L=4
#      make JESD_MODE=64B66B RX_LANE_RATE=16.22016 TX_LANE_RATE=16.22016 RX_JESD_M=8 RX_JESD_L=2 TX_JESD_M=16 TX_JESD_L=4
#      make JESD_MODE=64B66B RX_LANE_RATE=16.50 TX_LANE_RATE=16.50 RX_JESD_M=4 RX_JESD_L=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_M=4 TX_JESD_L=4 TX_JESD_S=1 TX_JESD_NP=16
#      make JESD_MODE=64B66B RX_LANE_RATE=24.75 TX_LANE_RATE=24.75 RX_JESD_M=4 RX_JESD_L=4 RX_JESD_S=2 RX_JESD_NP=12 TX_JESD_M=4 TX_JESD_L=4 TX_JESD_S=2 TX_JESD_NP=12
#      make JESD_MODE=64B66B RX_LANE_RATE=16.50 TX_LANE_RATE=16.50 RX_JESD_M=4 RX_JESD_L=4 RX_JESD_S=2 RX_JESD_NP=12 TX_JESD_M=4 TX_JESD_L=4 TX_JESD_S=2 TX_JESD_NP=12
#      make JESD_MODE=8B10B  RX_JESD_L=4 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=8

#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   RX_LANE_RATE :  Lane rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to MxFE )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#   [RX/TX]_KS_PER_CHANNEL : Number of samples stored in internal buffers in kilosamples per converter (M)
#

adi_project ad9081_fmca_ebz_vcu118 0 [list \
  JESD_MODE         [get_env_param JESD_MODE      8B10B ] \
  RX_LANE_RATE      [get_env_param RX_LANE_RATE      10 ] \
  TX_LANE_RATE      [get_env_param TX_LANE_RATE      10 ] \
  RX_JESD_M         [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L         [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S         [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP        [get_env_param RX_JESD_NP        16 ] \
  RX_NUM_LINKS      [get_env_param RX_NUM_LINKS       1 ] \
  TX_JESD_M         [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L         [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S         [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP        [get_env_param TX_JESD_NP        16 ] \
  TX_NUM_LINKS      [get_env_param TX_NUM_LINKS       1 ] \
  RX_KS_PER_CHANNEL [get_env_param RX_KS_PER_CHANNEL 64 ] \
  TX_KS_PER_CHANNEL [get_env_param TX_KS_PER_CHANNEL 64 ] \
  CORUNDUM          [get_env_param CORUNDUM           0 ] \
]

adi_project_files ad9081_fmca_ebz_vcu118 [list \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" \
]

if {[get_env_param CORUNDUM 0] == 1} {
  adi_project_files ad9081_fmca_ebz_vcu118 [list \
    "system_constr_corundum.xdc" \
    "system_top_corundum.v" \
    "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/boot.xdc" \
    "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/rtl/sync_signal.v" \
  ]

  add_files -fileset constrs_1 -norecurse [list \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
    "$ad_hdl_dir/library/corundum/scripts/sync_reset.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
  ]
} else {
  adi_project_files ad9081_fmca_ebz_vcu118 [list \
    "system_top.v" \
  ]
}

# Avoid critical warning in OOC mode from the clock definitions
# since at that stage the submodules are not stiched together yet
if {$ADI_USE_OOC_SYNTHESIS == 1} {
  set_property used_in_synthesis false [get_files timing_constr.xdc]
}

set_property strategy Congestion_SpreadLogic_high [get_runs impl_1]

adi_project_run ad9081_fmca_ebz_vcu118
