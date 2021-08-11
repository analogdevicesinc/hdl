
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## Please select which eval board mode do you want to use
##
##    1 - TX
##    0 - RX
##

set ka_band_mode 0

adi_project ka_band_zcu102

if {$ka_band_mode == 1} {
  adi_project_files ka_band_zcu102 [list \
    "system_top.v" \
    "system_constr_tx.xdc"\
    "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc"\
    "$ad_hdl_dir/library/common/ad_iobuf.v" ]
} elseif {$ka_band_mode == 0} {
  adi_project_files ka_band_zcu102 [list \
    "system_top.v" \
    "system_constr_rx.xdc"\
    "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc"\
    "$ad_hdl_dir/library/common/ad_iobuf.v" ]

} else {
  return -code error [format "ERROR: Invalid eval board type! ..."]
}

adi_project_run ka_band_zcu102
