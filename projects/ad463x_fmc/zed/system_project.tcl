
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## Please select which mode you want to use
##
##    0 - single SDO
##    1 - quad SDO
##    

set ad463x_mode 1

adi_project ad463x_fmc_zed

if {$ad463x_mode == 0} {
  adi_project_files ad463x_fmc_zed [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "system_top_single_sdi.v" \
    "system_constr_single_sdi.xdc" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]
} elseif {$ad463x_mode == 1} {
  adi_project_files ad463x_fmc_zed [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "system_top_dual_sdi.v" \
    "system_constr_dual_sdi.xdc" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]
} else {
  return -code error [format "ERROR: Invalid mode! ..."]
}

adi_project_run ad463x_fmc_zed
