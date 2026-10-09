###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create spi_translator
adi_ip_files spi_translator [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "spi_translator_slave.v" \
  "spi_translator_decoder.v" \
  "spi_translator_execution.v" \
  "spi_translator_regmap.v" \
  "spi_translator.v" \
]

adi_ip_properties_lite spi_translator

set_property display_name "ADI SPI Translator" [ipx::current_core]
set_property description  "Store-and-forward SPI bridge" [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
]

## Interface definitions

adi_add_bus "spi_engine_ctrl" "master" \
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
    {"sync_data" "sync_data"} \
  }
adi_add_bus_clock "clk" "spi_engine_ctrl" "spi_resetn" "master"

set cc [ipx::current_core]

## resetn is the core reset; spi_resetn above is driven out to the engine
set reset_inf [ipx::add_bus_interface resetn $cc]
set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
set_property interface_mode "slave" $reset_inf
set_property physical_name resetn [ipx::add_port_map "RST" $reset_inf]
set_property value "ACTIVE_LOW" [ipx::add_bus_parameter "POLARITY" $reset_inf]

set irq_inf [ipx::add_bus_interface irq $cc]
set_property abstraction_type_vlnv "xilinx.com:signal:interrupt_rtl:1.0" $irq_inf
set_property bus_type_vlnv "xilinx.com:signal:interrupt:1.0" $irq_inf
set_property interface_mode "master" $irq_inf
set_property physical_name irq [ipx::add_port_map "INTERRUPT" $irq_inf]
set_property value "LEVEL_HIGH" [ipx::add_bus_parameter "SENSITIVITY" $irq_inf]

## Parameter validations

foreach {param} {UP_CPOL UP_CPHA HEADER_CRC_EN} {
  set_property -dict [list \
    "value_format" "bool" \
    "value" [expr {$param == "HEADER_CRC_EN" ? "true" : "false"}] \
  ] [ipx::get_user_parameters $param -of_objects $cc]
  set_property -dict [list \
    "value_format" "bool" \
    "value" [expr {$param == "HEADER_CRC_EN" ? "true" : "false"}] \
  ] [ipx::get_hdl_parameters $param -of_objects $cc]
}

ipx::create_xgui_files $cc
ipx::save_core $cc
