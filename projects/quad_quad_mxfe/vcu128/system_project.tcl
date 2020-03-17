
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl


adi_project quad_quad_mxfe_vcu128 

adi_project_files quad_quad_mxfe_vcu128 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu128/vcu128_system_constr.xdc" ]


adi_project_run quad_quad_mxfe_vcu128 

