###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_pad
adi_ip_files util_pad [list \
  "util_pad.v" ]

adi_ip_properties_lite util_pad

ipx::save_core [ipx::current_core]
