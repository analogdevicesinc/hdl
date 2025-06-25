###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_rst

adi_ip_files util_rst [list \
  "util_rst.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite util_rst

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property name "util_rst" [ipx::current_core]
set_property display_name "ADI Reset Utils" [ipx::current_core]
set_property description "ADI Reset Utils" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::save_core [ipx::current_core]
