###############################################################################
## Copyright (C) 2015-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create spi_engine_execution
adi_ip_files spi_engine_execution [list \
  "spi_engine_execution_constr.ttcl" \
  "spi_engine_execution.v" \
  "spi_engine_execution_shiftreg.v" \
]

adi_ip_properties_lite spi_engine_execution
adi_ip_ttcl spi_engine_execution "spi_engine_execution_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/spi_engine/engine} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions

adi_add_bus "ctrl" "slave" \
  "analog.com:interface:spi_engine_ctrl_rtl:1.0" \
  "analog.com:interface:spi_engine_ctrl:1.0" \
  {
    {"cmd_ready" "cmd_ready"} \
    {"cmd_valid" "cmd_valid"} \
    {"cmd" "cmd_data"} \
    {"sdo_data_ready" "sdo_ready"} \
    {"sdo_data_valid" "sdo_valid"} \
    {"sdo_data" "sdo_data"} \
    {"sdi_data_ready" "sdi_ready"} \
    {"sdi_data_valid" "sdi_valid"} \
    {"sdi_data" "sdi_data"} \
    {"sync_ready" "sync_ready"} \
    {"sync_valid" "sync_valid"} \
    {"sync" "sync_data"} \
  }
adi_add_bus_clock "clk" "ctrl" "resetn"

adi_add_bus "spi" "master" \
  "analog.com:interface:spi_engine_rtl:1.0" \
  "analog.com:interface:spi_engine:1.0" \
  {
    {"sclk" "sclk"} \
    {"sdi" "sdi"} \
    {"sdo" "sdo"} \
    {"sdo_t" "sdo_t"} \
    {"three_wire" "three_wire"} \
    {"cs" "cs"} \
  }
adi_add_bus_clock "clk" "spi" "resetn"

## Parameter validations

set cc [ipx::current_core]

## DATA_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "32" \
 ] \
 [ipx::get_user_parameters DATA_WIDTH -of_objects $cc]

## NUM_OF_CS
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OF_CS -of_objects $cc]

## NUM_OF_SDI
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OF_SDI -of_objects $cc]

## DEFAULT_SPI_CFG
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "0 1 2 3" \
 ] \
 [ipx::get_user_parameters DEFAULT_SPI_CFG -of_objects $cc]

## DEFAULT_CLK_DIV
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "255" \
 ] \
 [ipx::get_user_parameters DEFAULT_CLK_DIV -of_objects $cc]

## SDO_DEFAULT
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "0 1" \
 ] \
 [ipx::get_user_parameters SDO_DEFAULT -of_objects $cc]

## SDI_DELAY
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters SDI_DELAY -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters SDI_DELAY -of_objects $cc]

## ECHO SCLK
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ECHO_SCLK -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters ECHO_SCLK -of_objects $cc]

## echo_sclk should be active only when ECHO_SCLK is set
adi_set_ports_dependency echo_sclk ECHO_SCLK 0

## Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {SPI Engine execution} -component [ipx::current_core] -display_name {AXI SPI Engine execution}
set page0 [ipgui::get_pagespec -name "SPI Engine execution" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Parallel data width" \
  "tooltip" "\[DATA_WIDTH\] Define the data interface width"
] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component $cc]

ipgui::add_param -name "NUM_OF_CS" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Number of CSN lines" \
  "tooltip" "\[NUM_OF_CS\] Define the number of chip select lines" \
] [ipgui::get_guiparamspec -name "NUM_OF_CS" -component $cc]

ipgui::add_param -name "NUM_OF_SDI" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Number of MISO lines" \
  "tooltip" "\[NUM_OF_SDI\] Define the number of MISO lines" \
] [ipgui::get_guiparamspec -name "NUM_OF_SDI" -component $cc]

set spi_config_group [ipgui::add_group -name "SPI Configuration" -component $cc \
    -parent $page0 -display_name "SPI Configuration" ]

ipgui::add_param -name "DEFAULT_SPI_CFG" -component $cc -parent $spi_config_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Default SPI mode" \
  "tooltip" "\[DEFAULT_SPI_CFG\] Define the default SPI configuration, bit 1 defines CPOL, bit 0 defines CPHA"
] [ipgui::get_guiparamspec -name "DEFAULT_SPI_CFG" -component $cc]

ipgui::add_param -name "DEFAULT_CLK_DIV" -component $cc -parent $spi_config_group
set_property -dict [list \
  "display_name" "Default SCLK divider" \
  "tooltip" "\[DEFAULT_CLK_DIV\] Define the default SCLK divider, fSCLK = fCoreClk / DEFAULT_CLK_DIV + 1"
] [ipgui::get_guiparamspec -name "DEFAULT_CLK_DIV" -component $cc]

set mosi_miso_config_group [ipgui::add_group -name "MOSI/MISO Configuration" -component $cc \
    -parent $page0 -display_name "MOSI/MISO Configuration" ]

ipgui::add_param -name "NUM_OF_SDI" -component $cc -parent $mosi_miso_config_group
set_property -dict [list \
  "display_name" "Number of MISO" \
  "tooltip" "\[NUM_OF_SDI\] Define the number of MISO lines"
] [ipgui::get_guiparamspec -name "NUM_OF_SDI" -component $cc]

ipgui::add_param -name "SDI_DELAY" -component $cc -parent $mosi_miso_config_group
set_property -dict [list \
  "display_name" "Delay MISO latching" \
  "tooltip" "\[SDI_DELAY\] Delay the MISO latching to the next consecutive SCLK edge"
] [ipgui::get_guiparamspec -name "SDI_DELAY" -component $cc]

ipgui::add_param -name "SDO_DEFAULT" -component $cc -parent $mosi_miso_config_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "MOSI default level" \
  "tooltip" "\[SDO_DEFAULT\] Define the default voltage level on MOSI"
] [ipgui::get_guiparamspec -name "SDO_DEFAULT" -component $cc]

set custom_clocking_group [ipgui::add_group -name "Custom clocking options" -component $cc \
    -parent $page0 -display_name "Custom clocking options" ]

ipgui::add_param -name "ECHO_SCLK" -component $cc -parent $custom_clocking_group
set_property -dict [list \
  "display_name" "Echoed SCLK" \
  "tooltip" "\[ECHO_SCLK\] Activate echo SCLK option (hardware support required)"
] [ipgui::get_guiparamspec -name "ECHO_SCLK" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
