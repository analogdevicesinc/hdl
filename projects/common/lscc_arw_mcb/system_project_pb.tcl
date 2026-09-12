###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_pb.tcl

adi_project_pb template_lscc_arw_mcb -parameter_list [list \
  SYSMEM_INIT_FILE [get_env_param SYSMEM_INIT_FILE ""]]
