###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip

source ../../scripts/adi_env.tcl

source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9910
adi_ip_files axi_ad9910 [list \
    "$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/common/ad_mem.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
    "$ad_hdl_dir/library/common/up_xfer_status.v" \
    "$ad_hdl_dir/library/common/up_clock_mon.v" \
    "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
    "$ad_hdl_dir/library/common/util_ext_sync.v" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_out.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "axi_ad9910_constr.ttcl" \
    "axi_ad9910_reg.v" \
    "axi_ad9910_if.v" \
    "axi_ad9910.v" ]

adi_ip_properties axi_ad9910

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_axis_tready" "TREADY"} \
    {"s_axis_tvalid" "TVALID"} \
    {"s_axis_tdata" "TDATA"} \
  ]
adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_aresetn"

set cc [ipx::current_core]

## Customize XGUI layout

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

adi_init_bd_tcl
adi_ip_bd axi_ad9910 "bd/bd.tcl"

# Register the ttcl constraint template to be generated as XDC
adi_ip_ttcl axi_ad9910 "axi_ad9910_constr.ttcl"
set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad9910} $cc

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

adi_add_auto_fpga_spec_params

## Save the modifications

ipx::create_xgui_files $cc

ipx::save_core $cc
