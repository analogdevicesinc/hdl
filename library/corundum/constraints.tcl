###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl

global VIVADO_IP_LIBRARY

source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/rb_drp.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/common/syn/vivado/mqnic_port.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl"
