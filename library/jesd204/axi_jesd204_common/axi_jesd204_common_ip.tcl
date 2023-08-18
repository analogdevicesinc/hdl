###############################################################################
## Copyright (C) 2016, 2017, 2019, 2022, 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_jesd204_common

add_files -fileset [get_filesets sources_1] [list \
  "../../xilinx/common/up_clock_mon_constr.xdc" \
  "../../common/up_clock_mon.v" \
  "jesd204_up_common.v" \
  "jesd204_up_sysref.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite axi_jesd204_common

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]
set_property display_name "ADI AXI JESD204B Common Library" [ipx::current_core]
set_property description "ADI AXI JESD204B Common Library" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::save_core [ipx::current_core]
