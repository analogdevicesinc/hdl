###############################################################################
## Copyright (C) 2015-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_ad7616

adi_ip_files axi_ad7616 [list \
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
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
    "axi_ad7616_pif.v" \
    "axi_ad7616.v" ]

adi_ip_properties axi_ad7616

set_property company_url {https://analogdevicesinc.github.io/hdl/library/axi_ad7616/index.html} [ipx::current_core]

set cc [ipx::current_core]

set_property DRIVER_VALUE "0" [ipx::get_ports rx_db_i]

set_property display_name "AXI AD7616" $cc
set_property description "AXI AD7616 HDL interface" $cc

ipx::create_xgui_files  $cc
ipx::save_core $cc
