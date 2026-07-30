###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_zed
adi_project_files template_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
   "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_impl.xdc" \
  "qspi_slave.v" \
  "system_top.v" ]

# Mark the async-clock-groups constraint as implementation-only.
set_property USED_IN_SYNTHESIS false [get_files zed_system_impl.xdc]

adi_project_run template_zed
