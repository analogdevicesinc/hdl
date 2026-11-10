###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create spi_translator_interconnect
adi_ip_files spi_translator_interconnect [list \
  "spi_translator_interconnect.v" \
]

adi_ip_properties_lite spi_translator_interconnect

set_property display_name "ADI SPI Translator Interconnect" [ipx::current_core]
set_property description  "Routes the SPI translator to one of several SPI Engine execution modules" [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

proc spi_translator_ctrl_bus {name mode prefix} {
  adi_add_bus $name $mode \
    "analog.com:interface:spi_engine_ctrl_rtl:1.0" \
    "analog.com:interface:spi_engine_ctrl:1.0" \
    [list \
      [list "${prefix}_cmd_ready" "cmd_ready"] \
      [list "${prefix}_cmd_valid" "cmd_valid"] \
      [list "${prefix}_cmd_data" "cmd_data"] \
      [list "${prefix}_sdo_ready" "sdo_ready"] \
      [list "${prefix}_sdo_valid" "sdo_valid"] \
      [list "${prefix}_sdo_data" "sdo_data"] \
      [list "${prefix}_sdi_ready" "sdi_ready"] \
      [list "${prefix}_sdi_valid" "sdi_valid"] \
      [list "${prefix}_sdi_data" "sdi_data"] \
      [list "${prefix}_sync_ready" "sync_ready"] \
      [list "${prefix}_sync_valid" "sync_valid"] \
      [list "${prefix}_sync_data" "sync_data"] \
    ]
  adi_add_bus_clock "clk" $name "resetn"
}

spi_translator_ctrl_bus "s_ctrl" "slave" "s"

for {set k 0} {$k < 16} {incr k} {
  spi_translator_ctrl_bus "m${k}_ctrl" "master" "m${k}"
  adi_set_bus_dependency "m${k}_ctrl" "m${k}_" \
    "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_ENGINES')) > $k)"
}

set cc [ipx::current_core]

set reset_inf [ipx::add_bus_interface resetn $cc]
set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
set_property interface_mode "slave" $reset_inf
set_property physical_name resetn [ipx::add_port_map "RST" $reset_inf]
set_property value "ACTIVE_LOW" [ipx::add_bus_parameter "POLARITY" $reset_inf]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters NUM_OF_ENGINES -of_objects $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc
