###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_selmap
adi_ip_files axi_selmap [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "async_cdc_fifo.v" \
  "axi_selmap_regmap.v" \
  "axi_selmap.v"]

adi_ip_properties axi_selmap

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_selmap} [ipx::current_core]

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

set_property display_name "ADI AXI SelMap Interface" $cc
set_property description  "ADI AXI SelMap Interface" $cc

## Save the modifications

ipx::create_xgui_files $cc
ipx::save_core $cc
