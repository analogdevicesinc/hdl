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

set_property company_url {https://wiki.analog.com/resources/fpga/docs/spi_slave} [ipx::current_core]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
]

set cc [ipx::current_core]

ipx::create_xgui_files $cc
ipx::save_core $cc
