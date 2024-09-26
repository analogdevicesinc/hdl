###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# ONPEPORT - 0 (default), both DACs receive data from dedicated ports, 1 DACs 
# receive data from the same port 

adi_project ad9747_ebz_zed 0 [list \
  ONPEPORT [get_env_param ONPEPORT 0]]

adi_project_files ad9747_ebz_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_top.v" ]

adi_project_run ad9747_ebz_zed
