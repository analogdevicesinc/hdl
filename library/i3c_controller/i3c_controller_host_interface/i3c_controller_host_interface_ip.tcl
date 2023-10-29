source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_host_interface
adi_ip_files i3c_controller_host_interface [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mem_dual.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
	"i3c_controller_host_interface_constr.ttcl" \
	"i3c_controller_host_interface.v" \
	"i3c_controller_regmap.v" \
	"i3c_controller_regmap_defs.v" \
	"i3c_controller_cmd_parser.v" \
	"i3c_controller_write_byte.v" \
	"i3c_controller_read_byte.v" \
	"i3c_controller_write_ibi.v" \
]

adi_ip_properties i3c_controller_host_interface
adi_ip_ttcl i3c_controller_host_interface "i3c_controller_host_interface_constr.ttcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/host_interface} [ipx::current_core]

adi_add_bus "cmdp" "master" \
	"analog.com:interface:i3c_controller_cmdp_rtl:1.0" \
	"analog.com:interface:i3c_controller_cmdp:1.0" \
	{
		{"cmdp_valid"        "CMDP_VALID"} \
		{"cmdp_ready"        "CMDP_READY"} \
		{"cmdp_ccc"          "CMDP_CCC"} \
		{"cmdp_ccc_bcast"    "CMDP_CCC_BCAST"} \
		{"cmdp_ccc_id"       "CMDP_CCC_ID"} \
		{"cmdp_bcast_header" "CMDP_BCAST_HEADER"} \
		{"cmdp_xmit"         "CMDP_XMIT"} \
		{"cmdp_sr"           "CMDP_SR"} \
		{"cmdp_buffer_len"   "CMDP_BUFFER_LEN"} \
		{"cmdp_da"           "CMDP_DA"} \
		{"cmdp_rnw"          "CMDP_RNW"} \
		{"cmdp_cancelled"    "CMDP_CANCELLED"} \
		{"cmdp_unknown_da"   "CMDP_UNKNOWN_DA"} \
		{"cmdp_nop"          "CMDP_NOP"} \
	}
adi_add_bus_clock "clk" "cmdp" "reset_n"

adi_add_bus "sdio" "master" \
	"analog.com:interface:i3c_controller_sdio_rtl:1.0" \
	"analog.com:interface:i3c_controller_sdio:1.0" \
	{
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
adi_add_bus_clock "clk" "sdio" "reset_n"

adi_add_bus "rmap" "master" \
	"analog.com:interface:i3c_controller_rmap_rtl:1.0" \
	"analog.com:interface:i3c_controller_rmap:1.0" \
	{
		{"devs_ctrl"                   "DEVS_CTRL"} \
		{"devs_ctrl_candidate"         "DEVS_CTRL_CANDIDATE"} \
		{"devs_ctrl_commit"            "DEVS_CTRL_COMMIT"} \
		{"devs_ctrl_is_i2c"            "DEVS_CTRL_IS_I2C"} \
		{"rmap_daa_status"             "RMAP_DAA_STATUS"} \
		{"rmap_dev_char_e"             "RMAP_DEV_CHAR_E"} \
		{"rmap_dev_char_we"            "RMAP_DEV_CHAR_WE"} \
		{"rmap_dev_char_addr"          "RMAP_DEV_CHAR_ADDR"} \
		{"rmap_dev_char_wdata"         "RMAP_DEV_CHAR_WDATA"} \
		{"rmap_dev_char_rdata"         "RMAP_DEV_CHAR_RDATA"} \
		{"rmap_ibi_config"             "RMAP_IBI_CONFIG"} \
		{"rmap_pp_sg"                  "RMAP_PP_SG"} \
	}
adi_add_bus_clock "clk" "rmap" "reset_n" "master"

adi_add_bus "offload" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"offload_sdi_ready"  "OFFLOAD_SDI_READY"} \
		{"offload_sdi_valid"  "OFFLOAD_SDI_VALID"} \
		{"offload_sdi"        "OFFLOAD_SDI"} \
	}
adi_add_bus_clock "clk" "offload" "reset_n" "master"

adi_set_ports_dependency "clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.ASYNC_CLK')) = 1)"

adi_set_bus_dependency "offload" "offload" \
      "(spirit:decode(id('MODELPARAM_VALUE.OFFLOAD')) = 1)"
adi_set_ports_dependency "offload_trigger" \
      "(spirit:decode(id('MODELPARAM_VALUE.OFFLOAD')) = 1)"

## Parameter validations
set cc [ipx::current_core]

## ID
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "255" \
 ] \
 [ipx::get_user_parameters ID -of_objects $cc]

## ASYNC_CLK
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ASYNC_CLK -of_objects $cc]

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

## OFFLOAD
set_property -dict [list \
  "value_format" "bool" \
  "value" "true" \
 ] \
 [ipx::get_user_parameters OFFLOAD -of_objects $cc]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Host Interface} -component [ipx::current_core] -display_name {AXI I3C Controller Host Interface}
set page0 [ipgui::get_pagespec -name "I3C Controller Host Interface" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
  "tooltip" "\[ID\] Core instance ID" \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "ASYNC_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_CLK\] Define the relationship between the core clock and the memory mapped interface clock" \
] [ipgui::get_guiparamspec -name "ASYNC_CLK" -component $cc]

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

ipgui::add_param -name "OFFLOAD" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Offload engine" \
  "tooltip" "\[OFFLOAD\] Allows to offload output data to a external receiver, like a DMA" \
] [ipgui::get_guiparamspec -name "OFFLOAD" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
