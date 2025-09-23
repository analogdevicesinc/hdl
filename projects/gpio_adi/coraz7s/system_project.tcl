###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl

# Parameter description
adi_project gpio_adi_coraz7s 

adi_project_files gpio_adi_coraz7s [list \
    "../../../library/common/ad_iobuf.v" \
    "../../common/coraz7s/coraz7s_system_constr.xdc" \
    "../../../library/axi_gpio_adi/axi_gpio_adi.v" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run gpio_adi_coraz7s

# --- Fix pentru eroarea de la opt_design ---
set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]