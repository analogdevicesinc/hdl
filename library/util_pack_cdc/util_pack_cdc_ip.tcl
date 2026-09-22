###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_pack_cdc
adi_ip_files util_pack_cdc [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "util_pack_cdc_constr.xdc" \
  "util_pack_cdc.v" ]

adi_ip_properties_lite util_pack_cdc

ipx::save_core [ipx::current_core]
