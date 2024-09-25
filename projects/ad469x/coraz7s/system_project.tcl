###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl

# Parameter description

# SPI_4WIRE - For 0 CNV is linked to PWM. For 1 CNV is linked to SPI_CS

adi_project ad469x_coraz7s 0 [list \
  SPI_4WIRE [get_env_param SPI_4WIRE 0]]

adi_project_files ad469x_coraz7s [list \
    "../../../library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad469x_coraz7s
