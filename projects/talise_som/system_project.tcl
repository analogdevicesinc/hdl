
source ../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xczu11eg-ffvf1517-1-e"
set sys_zynq 2

adi_project_xilinx talise_som
adi_project_files talise_som [list \
  "system_top.v" \
  "talise_som_spi.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" ]

adi_project_run talise_som
