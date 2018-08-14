
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcomms2_vc707
adi_project_files fmcomms2_vc707 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" ]

adi_project_run fmcomms2_vc707
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

