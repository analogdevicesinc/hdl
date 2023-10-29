source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_core
adi_ip_files i3c_controller_core [list \
	"i3c_controller_core_constr.ttcl" \
	"i3c_controller_core.v" \
	"i3c_controller_framing.v" \
	"i3c_controller_word.v" \
 	"i3c_controller_word_cmd.v" \
	"i3c_controller_bit_mod.v" \
 	"i3c_controller_bit_mod_cmd.v" \
]

adi_ip_properties_lite i3c_controller_core
adi_ip_ttcl i3c_controller_core "i3c_controller_core_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/core} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions
adi_add_bus "i3c" "master" \
	"analog.com:interface:i3c_controller_rtl:1.0" \
	"analog.com:interface:i3c_controller:1.0" \
	{
		{"i3c_scl" "SCL"} \
		{"i3c_sdo" "SDO"} \
		{"i3c_sdi" "SDI"} \
		{"i3c_t"   "T"} \
	}
adi_add_bus_clock "clk" "i3c" "reset_n"

adi_add_bus "cmdp" "slave" \
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

adi_add_bus "sdio" "slave" \
	"analog.com:interface:i3c_controller_sdio_rtl:1.0" \
	"analog.com:interface:i3c_controller_sdio:1.0" \
	{
		{"sdo_ready" "SDO_READY"} \
		{"sdo_valid" "SDO_VALID"} \
		{"sdo"       "SDO_DATA"} \
		{"sdi_ready" "SDI_READY"} \
		{"sdi_valid" "SDI_VALID"} \
		{"sdi"       "SDI_DATA"} \
		{"ibi_ready" "IBI_READY"} \
		{"ibi_valid" "IBI_VALID"} \
		{"ibi"       "IBI_DATA"} \
	}
adi_add_bus_clock "clk" "sdio" "reset_n"

adi_add_bus "rmap" "slave" \
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

## Parameter validations

set cc [ipx::current_core]

## SIM_DEVICE
set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "Ultrascale" "ULTRASCALE" \
      "7 Series" "7SERIES" \
    } \
 ] \
 [ipx::get_user_parameters SIM_DEVICE -of_objects $cc]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Core} -component [ipx::current_core] -display_name {AXI I3C Controller Core}
set page0 [ipgui::get_pagespec -name "I3C Controller Core" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "SIM_DEVICE" -component $cc -parent $general_group

set_property -dict [list \
  "display_name" "Target simulation device" \
  "tooltip" "\[SIM_DEVICE\] Specify the target device for simulation" \
] [ipgui::get_guiparamspec -name "SIM_DEVICE" -component $cc]

ipgui::add_param -name "CLK_DIV" -component $cc -parent $general_group

set_property -dict [list \
  "display_name" "Core clock divider" \
  "tooltip" "\[CLK_DIV\] Divide the core clock to obtain the derivated clock used in the Open-Drain mode modulation" \
] [ipgui::get_guiparamspec -name "CLK_DIV" -component $cc]

ipgui::add_param -name "MAX_DEVS" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Maximum number of peripherals" \
  "tooltip" "\[MAX_DEVS\] Maximum number of peripherals in the bus, not counting the controller" \
] [ipgui::get_guiparamspec -name "MAX_DEVS" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
