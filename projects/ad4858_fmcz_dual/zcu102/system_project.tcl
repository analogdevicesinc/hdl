source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set LVDS_CMOS_N [expr {[info exists ::env(LVDS_CMOS_N)] ? $::env(LVDS_CMOS_N) : 1}]

adi_project ad4858_fmcz_dual_zcu102 0 [list \
  LVDS_CMOS_N     $LVDS_CMOS_N \
]

if {$LVDS_CMOS_N == 1} {
  set top_file [list "system_top_lvds.v" "system_constr_lvds.xdc"]
} else {
  set top_file [list "system_top_cmos.v" "system_constr_cmos.xdc"]
}

adi_project_files ad4858_fmcz_dual_zcu102 [linsert $top_file 0 \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run ad4858_fmcz_dual_zcu102

