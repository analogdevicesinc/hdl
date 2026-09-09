###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_width_extend
adi_ip_files util_width_extend [list \
  "util_width_extend.v" ]

adi_ip_properties_lite util_width_extend

ipx::save_core [ipx::current_core]
