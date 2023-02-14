source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# if the interface is not build defined, set CMOS as default inferface
set LVDS_CMOS_N [get_env_param LVDS_CMOS_N     0]

adi_project ad4858_fmcz_zcu102 0 [list \
  LVDS_CMOS_N     $LVDS_CMOS_N \
]

if {$LVDS_CMOS_N == "0"} {
  set top_file [list "system_top_cmos.v" "system_constr_cmos.xdc"]
} else {
  set top_file [list "system_top_lvds.v" "system_constr_lvds.xdc"]
}

adi_project_files ad4858_fmcz_zcu102 [linsert $top_file 0 \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run ad4858_fmcz_zcu102

