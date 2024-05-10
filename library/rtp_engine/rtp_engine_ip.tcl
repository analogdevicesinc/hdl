###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create rtp_engine
adi_ip_files rtp_engine [list \
  "rtp_engine.sv" \
  "../common/up_axi.v" \
  "axis_fifo.v" \
  "rtp_engine_regmap.sv" \
  "rtp_engine_package.sv" ]

adi_ip_properties rtp_engine
#adi_ip_ttcl axi_tdd "axi_tdd_constr.ttcl"
set_property display_name "AXI-RTP engine" [ipx::current_core]
set_property description "ADI AXI-RTP engine" [ipx::current_core]
set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_rtp} [ipx::current_core]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset aresetn ACTIVE_LOW

adi_add_bus "rtp_engine_slave" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid" "TVALID"} \
		{"s_axis_tdata" "TDATA"} \
		{"s_axis_tlast" "TLAST"} \
		{"s_axis_tdest" "TDEST"} \
		{"s_axis_tuser" "TUSER"} \
		{"s_axis_tready" "TREADY"} \
	}

adi_add_bus "rtp_engine_master" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"m_axis_tvalid" "TVALID"} \
		{"m_axis_tdata" "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
		{"m_axis_tready" "TREADY"} \
		{"m_axis_tkeep" "TKEEP"} \
	}

adi_add_bus_clock "aclk" "rtp_engine_slave" "aresetn"
adi_add_bus_clock "aclk" "rtp_engine_master" "aresetn"

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "16" \
        "value_validation_range_maximum" "64" \
        ] \
        [ipx::get_user_parameters S_TDATA_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "16" \
        "value_validation_range_maximum" "64" \
        ] \
        [ipx::get_user_parameters M_TDATA_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "10" \
        ] \
        [ipx::get_user_parameters S_TDEST_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "10" \
        ] \
        [ipx::get_user_parameters M_TDEST_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "96" \
        ] \
        [ipx::get_user_parameters S_TUSER_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "96" \
        ] \
        [ipx::get_user_parameters M_TUSER_WIDTH -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

