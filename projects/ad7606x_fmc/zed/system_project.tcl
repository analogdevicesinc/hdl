
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# DEV_CONFIG - The device which will be used
#  - Options : AD7606B(0)/C-16(1)/C-18(2)
# INTF - Operation interface
#  - Options : Parallel/Serial
# NUM_OF_SDI - NUmber of SDI lines used
#  - Options: 1, 2, 4, 8
# SIMPLE_STATUS_CRC - ADC read mode options
#  - Options : SIMPLE(0), STATUS(1), CRC(2) CRC_STATUS(3)
# EXT_CLK - Use external clock as ADC clock
#  - Options : No(0), Yes(1)

set DEV_CONFIG [get_env_param DEV_CONFIG 0]
set INTF [get_env_param INTF 0]
set NUM_OF_SDI [get_env_param NUM_OF_SDI 8]
set SIMPLE_STATUS_CRC [get_env_param SIMPLE_STATUS_CRC 0]
set EXT_CLK [get_env_param EXT_CLK 0]

adi_project ad7606x_fmc_zed 0 [list \
  DEV_CONFIG $DEV_CONFIG \
  INTF $INTF \
  NUM_OF_SDI $NUM_OF_SDI \
  SIMPLE_STATUS_CRC $SIMPLE_STATUS_CRC \
  EXT_CLK $EXT_CLK \
]

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.tcl"]

switch $INTF {
  0 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_pi.v" ]
  }
  1 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_si.v" ]
  }
}

adi_project_run ad7606x_fmc_zed
