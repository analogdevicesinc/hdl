source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_i3c_controller
adi_ip_files axi_i3c_controller [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mem_dual.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_i3c_controller_constr.ttcl" \
  "axi_i3c_controller.v" \
  "i3c_controller_regmap.v" \
]

adi_ip_properties axi_i3c_controller
adi_ip_ttcl axi_i3c_controller "axi_i3c_controller_constr.ttcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/axi} [ipx::current_core]


## Interface definitions

adi_add_bus "ctrl" "master" \
	"analog.com:interface:i3c_controller_ctrl_rtl:1.0" \
	"analog.com:interface:i3c_controller_ctrl:1.0" \
	{
		{"cmd_ready"  "CMD_READY"} \
		{"cmd_valid"  "CMD_VALID"} \
		{"cmd"        "CMD_DATA"} \
		{"cmdr_ready" "CMDR_READY"} \
		{"cmdr_valid" "CMDR_VALID"} \
		{"cmdr"       "CMDR_DATA"} \
		{"sdo_ready"  "SDO_READY"} \
		{"sdo_valid"  "SDO_VALID"} \
		{"sdo"        "SDO_DATA"} \
		{"sdi_ready"  "SDI_READY"} \
		{"sdi_valid"  "SDI_VALID"} \
		{"sdi"        "SDI_DATA"} \
		{"ibi_ready"  "IBI_READY"} \
		{"ibi_valid"  "IBI_VALID"} \
		{"ibi"        "IBI_DATA"} \
	}
adi_add_bus_clock "i3c_clk" "ctrl" "i3c_reset_n" "master"

adi_add_bus "rmap" "master" \
	"analog.com:interface:i3c_controller_rmap_rtl:1.0" \
	"analog.com:interface:i3c_controller_rmap:1.0" \
	{
		{"rmap_daa_status"             "RMAP_DAA_STATUS"} \
		{"rmap_devs_ctrl_mr"           "RMAP_DEVS_CTRL_MR"} \
		{"rmap_devs_ctrl"              "RMAP_DEVS_CTRL"} \
		{"rmap_dev_char_e"             "RMAP_DEV_CHAR_E"} \
		{"rmap_dev_char_we"            "RMAP_DEV_CHAR_WE"} \
		{"rmap_dev_char_addr"          "RMAP_DEV_CHAR_ADDR"} \
		{"rmap_dev_char_wdata"         "RMAP_DEV_CHAR_WDATA"} \
		{"rmap_dev_char_rdata"         "RMAP_DEV_CHAR_RDATA"} \
		{"rmap_ibi_config"             "RMAP_IBI_CONFIG"} \
	}
adi_add_bus_clock "i3c_clk" "rmap" "i3c_reset_n" "master"

foreach port {"up_clk" "up_rstn" "up_wreq" "up_waddr" "up_wdata" "up_rreq" "up_raddr"} {
  set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}

adi_set_bus_dependency "s_axi" "s_axi" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 0)"

adi_set_ports_dependency "up_clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rstn" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_waddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_raddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"

adi_set_ports_dependency "i3c_clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.ASYNC_I3C_CLK')) = 1)"

## Parameter validations

set cc [ipx::current_core]

## ID
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "255" \
 ] \
 [ipx::get_user_parameters ID -of_objects $cc]

## MM_IF_TYPE
set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "AXI4 Memory Mapped" "0" \
      "ADI uP FIFO" "1" \
    } \
 ] \
 [ipx::get_user_parameters MM_IF_TYPE -of_objects $cc]

## ASYNC_I3C_CLK
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ASYNC_I3C_CLK -of_objects $cc]

## MAX_DEVS
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "15" \
 ] \
 [ipx::get_user_parameters MAX_DEVS -of_objects $cc]

## No validation...
### PID
#set_property -dict [list \
# ] \
# [ipx::get_user_parameters PID -of_objects $cc]
#
### DCR
#set_property -dict [list \
# ] \
# [ipx::get_user_parameters DCR -of_objects $cc]
#
### BCR
#set_property -dict [list \
# ] \
# [ipx::get_user_parameters BCR -of_objects $cc]

## Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {AXI I3C Controller soft-controller} -component [ipx::current_core] -display_name {AXI I3C Controller soft-controller}
set page0 [ipgui::get_pagespec -name "AXI I3C Controller soft-controller" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
  "tooltip" "\[ID\] Core instance ID" \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "MM_IF_TYPE" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Memory Mapped Interface Type" \
  "tooltip" "\[MM_IF_TYPE\] Define the memory mapped interface type" \
] [ipgui::get_guiparamspec -name "MM_IF_TYPE" -component $cc]

ipgui::add_param -name "ASYNC_I3C_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_I3C_CLK\] Define the relationship between the core clock and the memory mapped interface clock" \
] [ipgui::get_guiparamspec -name "ASYNC_I3C_CLK" -component $cc]

ipgui::add_param -name "MAX_DEVS" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Maximum number of peripherals" \
  "tooltip" "\[MAX_DEVS\] Maximum number of peripherals in the bus, not counting the controller" \
] [ipgui::get_guiparamspec -name "MAX_DEVS" -component $cc]

ipgui::add_param -name "PID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Controller's PID" \
  "tooltip" "\[PID\] Controller's provisioned identifier" \
] [ipgui::get_guiparamspec -name "PID" -component $cc]

ipgui::add_param -name "DCR" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Controller's DCR" \
  "tooltip" "\[DCR\] Controller's device characteristics" \
] [ipgui::get_guiparamspec -name "DCR" -component $cc]

ipgui::add_param -name "BCR" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Controller's BCR" \
  "tooltip" "\[BCR\] Controller's bus characteristics" \
] [ipgui::get_guiparamspec -name "BCR" -component $cc]
## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
