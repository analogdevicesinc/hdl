###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create spi_slave
adi_ip_files spi_slave [list \
  "spi_slave.v" \
]

adi_ip_properties_lite spi_slave

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
]

set_property display_name "ADI SPI Slave" [ipx::current_core]
set_property description  "ADI SPI Slave" [ipx::current_core]

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
