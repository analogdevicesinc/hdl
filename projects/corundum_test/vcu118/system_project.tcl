###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=2 TX_JESD_L=4 TX_JESD_M=2 

# Parameter description:
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame

adi_project corundum_test_vcu118 0

adi_project_files corundum_test_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" \
  "$ad_hdl_dir/library/corundum/constraints.tcl" \
  "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/boot.xdc" \
  "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/rtl/sync_signal.v" \
]

## To improve timing in DDR4 MIG
set_property strategy Performance_Retiming [get_runs impl_1]

adi_project_run corundum_test_vcu118
