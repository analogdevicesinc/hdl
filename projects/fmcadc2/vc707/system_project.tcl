


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcadc2_vc707
adi_project_files fmcadc2_vc707 [list \
  "../common/fmcadc2_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" ]

set_property is_enabled false [get_files  *system_axi*_spi*.xdc]

adi_project_run fmcadc2_vc707


