source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_core
adi_ip_files i3c_controller_core [list \
	"i3c_controller_core_constr.ttcl" \
	"i3c_controller_core.v" \
	"i3c_controller_framing.v" \
	"i3c_controller_daa.v" \
	"i3c_controller_phy_sda.v" \
	"i3c_controller_word.v" \
 	"i3c_controller_word_cmd.v" \
	"i3c_controller_bit_mod.v" \
 	"i3c_controller_bit_mod_cmd.v" \
	"i3c_controller_clk_div.v" \
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
		{"scl" "SCL"} \
		{"sda" "SDA"} \
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
		{"cmdp_do_daa"       "CMDP_DO_DAA"} \
		{"cmdp_do_daa_ready" "CMDP_DO_DAA_READY"} \
		{"cmdp_cancelled"    "CMDP_CANCELLED"} \
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
		{"rmap_daa_status"             "RMAP_DAA_STATUS"} \
		{"rmap_dev_clr"                "RMAP_DEV_CLR"} \
		{"rmap_devs_ctrl"              "RMAP_DEVS_CTRL"} \
		{"rmap_dev_char_0"             "RMAP_DEV_CHAR_0"} \
		{"rmap_dev_char_1"             "RMAP_DEV_CHAR_1"} \
		{"rmap_dev_char_2"             "RMAP_DEV_CHAR_2"} \
		{"rmap_ibi_config"             "RMAP_IBI_CONFIG"} \
	}
adi_add_bus_clock "i3c_clk" "rmap" "i3c_reset_n" "master"

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

## CLK_DIV
set_property -dict [list \
  "value_validation_list" { \
  "2" "3" "4" "5" "6" "7" "8" \
  } \
 ] \
 [ipx::get_user_parameters CLK_DIV -of_objects $cc]

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

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
