
source ../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# make ADI_PLUTO_FPGA=xczu2cg-sfva625-1-e
# make ADI_PLUTO_FPGA=xczu3eg-sfva625-1-e
#
# How to use over-writable parameters from the environment:
#
# e.g.
#   make CMOS_LVDS_N=0
#  or
#   make CMOS_LVDS_N=1
#
#
# Parameter description:
#   CMOS_LVDS_N - type of interface
#         0 - LVDS
#         1 - CMOS

if [info exists ::env(ADI_PLUTO_FPGA)] {
  set p_device $::env(ADI_PLUTO_FPGA)
} else {
  # default
  set p_device xczu3eg-sfva625-2-e
}

set sys_zynq 2

set CMOS_LVDS_N [get_env_param CMOS_LVDS_N 1]

adi_project pluto_ng 0 [list \
  CMOS_LVDS_N $CMOS_LVDS_N \
]

adi_project_files pluto_ng [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

if {$CMOS_LVDS_N == 0} {
  adi_project_files {} [list \
    "lvds_constr.xdc" \
  ]
} else {
  adi_project_files {} [list \
    "cmos_constr.xdc" \
  ]
}

adi_project_run pluto_ng
