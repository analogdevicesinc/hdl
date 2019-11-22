
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xczu11eg-ffvf1517-2-i"
set sys_zynq 2

adi_project adrv9009zu11eg
adi_project_files adrv9009zu11eg [list \
  "system_top.v" \
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" ]

adi_project_run adrv9009zu11eg
