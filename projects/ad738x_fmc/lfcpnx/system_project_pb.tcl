###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_pb.tcl

adi_project_pb ad738x_fmc_lfcpnx -parameter_list [list \
  ALERT_SPI_N [get_env_param ALERT_SPI_N 0] \
  NUM_OF_SDI [get_env_param NUM_OF_SDI 1] \
  DATA_WIDTH [get_env_param DATA_WIDTH 16] \
  SYSMEM_INIT_FILE [get_env_param SYSMEM_INIT_FILE ""]]
