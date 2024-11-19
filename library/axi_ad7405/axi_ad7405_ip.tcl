###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_ad7405

adi_ip_files axi_ad7405 [list \
	"$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
    "$ad_hdl_dir/library/common/ad_datafmt.v" \
    "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
    "$ad_hdl_dir/library/common/up_xfer_status.v" \
    "$ad_hdl_dir/library/common/up_clock_mon.v" \
    "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
    "$ad_hdl_dir/library/common/up_adc_channel.v" \
    "$ad_hdl_dir/library/common/up_adc_common.v" \
    "$ad_hdl_dir/library/util_cdc/sync_data.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
	"$ad_hdl_dir/library/common/util_dec256sinc24b.v" \
	"axi_ad7405.v" ]

adi_ip_properties axi_ad7405
#ipx::remove_all_bus_interface [ipx::current_core]

set cc [ipx::current_core]

#ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 $cc
#ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 $cc

ipx::create_xgui_files $cc
ipx::save_core $cc
