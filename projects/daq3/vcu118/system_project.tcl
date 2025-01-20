###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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
#      make RX_JESD_L=4 RX_JESD_M=2 TX_JESD_L=4 TX_JESD_M=2 

# Parameter description:
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame

adi_project daq3_vcu118 0 [list \
  RX_JESD_M    [get_env_param RX_JESD_M    2 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  TX_JESD_M    [get_env_param TX_JESD_M    2 ] \
  TX_JESD_L    [get_env_param TX_JESD_L    4 ] \
  TX_JESD_S    [get_env_param TX_JESD_S    1 ] \
]

adi_project_files daq3_vcu118 [list \
  "../common/daq3_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" \
  "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/boot.xdc" \
  "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/rtl/sync_signal.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/rb_drp.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_port.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
]

## To improve timing in DDR4 MIG
set_property strategy Performance_Retiming [get_runs impl_1]

adi_project_run daq3_vcu118

