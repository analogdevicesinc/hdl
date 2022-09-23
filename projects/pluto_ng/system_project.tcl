source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# make ADI_PLUTO_FPGA=xczu2cg-sfva625-1-e
# make ADI_PLUTO_FPGA=xczu3eg-sfva625-1-e

if [info exists ::env(ADI_PLUTO_FPGA)] {
  set p_device $::env(ADI_PLUTO_FPGA)
} else {
  # default
  set p_device xczu3eg-sfva625-2-e
}

set sys_zynq 2

adi_project pluto_ng

adi_project_files pluto_ng [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run pluto_ng
