
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## In function of the required interface mode, select the number of SDI lines.
#  (e.g. "NUM_OF_SDI 4 \")
#  The valid values are:
#
#    1 - Interleaved mode
#    2 - 1 lane per channel
#    4 - 2 lanes per channel
#    8 - 4 lanes per channel
#

adi_project ad463x_fmc_zed 0 [list \
  NUM_OF_SDI 2 \
]

adi_project_files ad463x_fmc_zed [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_top.v" \
  "system_constr.xdc" \
]

adi_project_run ad463x_fmc_zed

