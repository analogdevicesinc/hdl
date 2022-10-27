
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# DEV_CONFIG - The device which will be used
#  - Options : AD7606B(0)/C-16(1)/C-18(2)
# SIMPLE_STATUS_CRC - ADC read mode options
#  - Options : SIMPLE(0), STATUS(1), CRC(2) CRC_STATUS(3)

if {[info exists ::env(SIMPLE_STATUS_CRC)]} {
  set SIMPLE_STATUS_CRC [get_env_param SIMPLE_STATUS_CRC 0]
} elseif {![info exists SIMPLE_STATUS_CRC]} {
  set SIMPLE_STATUS_CRC 0
}

if {[info exists ::env(DEV_CONFIG)]} {
  set DEV_CONFIG [get_env_param DEV_CONFIG 0]
} elseif {![info exists DEV_CONFIG]} {
  set DEV_CONFIG 0
}

adi_project ad7606x_fmc_zed 0 [list \
  DEV_CONFIG $DEV_CONFIG \
  SIMPLE_STATUS_CRC $SIMPLE_STATUS_CRC \
]

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_top.v" \
  "system_constr.xdc"]

adi_project_run ad7606x_fmc_zed
