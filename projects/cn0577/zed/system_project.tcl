# load script
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# specify the resolution - 16/18 bits
# the design supports only 16/18-bits with two lanes
#
# default configuration is the 18-bit two lanes
# usage:
#   make RES=16
#   make RES=18

set resolution 18

if {[info exists ::env(RES)]} {
  set resolution $::env(RES)
} else {
  set env(RES) $resolution
}

adi_project cn0577_zed 0 [list \
  RES $resolution \
]

adi_project_files cn0577_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run cn0577_zed
