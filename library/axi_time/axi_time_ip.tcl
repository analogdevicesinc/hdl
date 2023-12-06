###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_time
adi_ip_files axi_time [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_time_pkg.sv" \
  "axi_time_counter.sv" \
  "axi_time_regmap.sv" \
  "axi_time_rx.sv" \
  "axi_time.sv" ]

adi_ip_properties axi_time
adi_ip_ttcl axi_time "axi_time_constr.ttcl"
set_property display_name "ADI AXI Timestamp Controller" [ipx::current_core]
set_property description "ADI AXI Timestamp Controller" [ipx::current_core]
set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_time} [ipx::current_core]

adi_ip_add_core_dependencies [list \
        analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
        analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_add_bus "fifo_wr_in" "slave" \
  "analog.com:interface:fifo_wr_rtl:1.0" \
  "analog.com:interface:fifo_wr:1.0" \
  { \
    {"fifo_wr_in_en" "EN"} \
    {"fifo_wr_in_data" "DATA"} \
    {"fifo_wr_in_overflow" "OVERFLOW"} \
    {"fifo_wr_in_sync" "SYNC"} \
    {"fifo_wr_in_xfer_req" "XFER_REQ"} \
  }
adi_add_bus_clock "clk" "fifo_wr_in"

adi_add_bus "fifo_wr_out" "master" \
  "analog.com:interface:fifo_wr_rtl:1.0" \
  "analog.com:interface:fifo_wr:1.0" \
  { \
    {"fifo_wr_out_en" "EN"} \
    {"fifo_wr_out_data" "DATA"} \
    {"fifo_wr_out_overflow" "OVERFLOW"} \
    {"fifo_wr_out_sync" "SYNC"} \
    {"fifo_wr_out_xfer_req" "XFER_REQ"} \
  }
adi_add_bus_clock "clk" "fifo_wr_out"

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset resetn ACTIVE_LOW
add_reset s_axi_aresetn ACTIVE_LOW

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "32" \
        "value_validation_range_maximum" "64" \
        ] \
        [ipx::get_user_parameters COUNT_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "list" \
        "value_validation_list" "16 32 64 128 256 512 1024 2048" \
        ] \
        [ipx::get_user_parameters DATA_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "1" \
        ] \
        [ipx::get_user_parameters SYNC_EXTERNAL -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "1" \
        ] \
        [ipx::get_user_parameters SYNC_EXTERNAL_CDC -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

