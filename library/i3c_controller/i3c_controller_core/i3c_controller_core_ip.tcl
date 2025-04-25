###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create i3c_controller_core
adi_ip_files i3c_controller_core [list \
  "i3c_controller_core.v" \
  "i3c_controller_framing.v" \
  "i3c_controller_word.v" \
  "i3c_controller_word.vh" \
  "i3c_controller_bit_mod.v" \
  "i3c_controller_bit_mod.vh" \
]

adi_ip_properties_lite i3c_controller_core

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/core} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions

adi_add_bus "i3c" "master" \
  "analog.com:interface:i3c_controller_rtl:1.0" \
  "analog.com:interface:i3c_controller:1.0" \
  {
    {"i3c_scl" "scl"} \
    {"i3c_sdo" "sdo"} \
    {"i3c_sdi" "sdi"} \
    {"i3c_t"   "t"} \
  }
adi_add_bus_clock "clk" "i3c" "reset_n"

adi_add_bus "sdio" "slave" \
  "analog.com:interface:i3c_controller_sdio_rtl:1.0" \
  "analog.com:interface:i3c_controller_sdio:1.0" \
  {
    {"sdo_ready" "sdo_ready"} \
    {"sdo_valid" "sdo_valid"} \
    {"sdo"       "sdo"} \
    {"sdi_ready" "sdi_ready"} \
    {"sdi_valid" "sdi_valid"} \
    {"sdi_last"  "sdi_last"} \
    {"sdi"       "sdi"} \
    {"ibi_ready" "ibi_ready"} \
    {"ibi_valid" "ibi_valid"} \
    {"ibi"       "ibi"} \
  }
adi_add_bus_clock "clk" "sdio" "reset_n"

adi_add_bus "cmdp" "slave" \
  "analog.com:interface:i3c_controller_cmdp_rtl:1.0" \
  "analog.com:interface:i3c_controller_cmdp:1.0" \
  {
    {"cmdp_valid"       "cmdp_valid"} \
    {"cmdp_ready"       "cmdp_ready"} \
    {"cmdp"             "cmdp"} \
    {"cmdp_error"       "cmdp_error"} \
    {"cmdp_nop"         "cmdp_nop"} \
    {"cmdp_daa_trigger" "cmdp_daa_trigger"} \
  }
adi_add_bus_clock "clk" "cmdp" "reset_n"

adi_add_bus "rmap" "slave" \
  "analog.com:interface:i3c_controller_rmap_rtl:1.0" \
  "analog.com:interface:i3c_controller_rmap:1.0" \
  {
    {"rmap_ibi_config"    "rmap_ibi_config"} \
    {"rmap_pp_sg"         "rmap_pp_sg"} \
    {"rmap_dev_char_addr" "rmap_dev_char_addr"} \
    {"rmap_dev_char_data" "rmap_dev_char_data"} \
  }
adi_add_bus_clock "clk" "rmap" "reset_n" "master"

set cc [ipx::current_core]

## MAX_DEVS
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters MAX_DEVS -of_objects $cc]

## I2C_MOD
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "0 1 2 3 4" \
] \
[ipx::get_user_parameters I2C_MOD -of_objects $cc]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Core} -component [ipx::current_core] -display_name {AXI I3C Controller Core}
set page0 [ipgui::get_pagespec -name "I3C Controller Core" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "MAX_DEVS" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Maximum number of peripherals" \
  "tooltip" "\[MAX_DEVS\] Maximum number of peripherals in the bus, counting the controller" \
] [ipgui::get_guiparamspec -name "MAX_DEVS" -component $cc]

ipgui::add_param -name "I2C_MOD" -component $cc -parent $general_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "I2C divider" \
  "tooltip" "\[I2C_MOD\] Further divide (two power) open drain speed to achieve a lower I2C. Set 0 to achieve 1.56MHz at (clk=100MHz, Clock cycles per bit=8), 1 for 781kHz." \
] [ipgui::get_guiparamspec -name "I2C_MOD" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
