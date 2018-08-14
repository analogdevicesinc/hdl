
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## The following HDL projects supports all the devices of EVAL-AD40XX-FMCZ:
##
##  AD4000/AD4001/AD4002/AD4003/AD4004/AD4005/AD4006/AD4007/AD4008/AD4010/AD4011/AD4020
##
## and also the EVAL-ADAQ400x eval board (with PMOD):
##
##  ADAQ4003
##
## NOTE: Make sure that you set up your required ADC resolution and sampling rate
##       in system_bd.tcl

## Please select which eval board do you want to use
##
##    1 - EVAL-AD40XX-FMCZ
##    0 - EVAL-ADAQ400x
##
set ad40xx_adaq400x_n 1

adi_project ad40xx_zed

if {$ad40xx_adaq400x_n == 1} {
  adi_project_files ad40xx_zed [list \
      "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
      "system_top_ad40xx.v" \
      "system_constr_ad40xx.xdc" \
      "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]
} elseif {$ad40xx_adaq400x_n == 0} {
  adi_project_files ad40xx_zed [list \
      "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
      "system_top_adaq400x.v" \
      "system_constr_adaq400x.xdc" \
      "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

} else {
  return -code error [format "ERROR: Invalid eval board type! ..."]
}

adi_project_run ad40xx_zed

