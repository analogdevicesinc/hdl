source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make NUM_OF_SDI=4  CAPTURE_ZONE=2
#
#
# Parameter description:
#
# CLK_MODE : Clocking mode of the device's digital interface
#
#   0 - SPI Mode
#   1 - Echo-clock or Master clock mode
#
# NUM_OF_SDI : the number of MOSI lines of the SPI interface
#
#    1 - Interleaved mode
#    2 - 1 lane per channel
#    4 - 2 lanes per channel
#    8 - 4 lanes per channel
#
# CAPTURE_ZONE : the capture zone of the next sample
# There are two capture zones for AD4624-30:
#
#   1 - from negative edge of the BUSY line until the next CNV positive edge -20ns
#   2 - from the next consecutive CNV positive edge +20ns until the second next
#   consecutive CNV positive edge -20ns
#
# DDR_EN : in echo and master clock mode the SDI lines can have Single or Double
# Data Rates
#
#   0 - MISO runs on SDR
#   1 - MISO runs on DDR
#
# Example:
#
#   make NUM_OF_SDI=2 CAPTURE_ZONE=2
#

adi_project ad4630_fmc_zed 0 [list \
  CLK_MODE     [get_env_param CLK_MODE      0] \
  NUM_OF_SDI   [get_env_param NUM_OF_SDI    4] \
  CAPTURE_ZONE [get_env_param CAPTURE_ZONE  2] \
  DDR_EN       [get_env_param DDR_EN  0] ]

adi_project_files ad4630_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

switch [get_env_param NUM_OF_SDI 4] {
  1 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_1sdi.xdc" ]
  }
  2 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_2sdi.xdc" ]
  }
  4 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_4sdi.xdc" ]
  }
  8 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_8sdi.xdc" ]
  }
  default {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_2sdi.xdc" ]
  }
}

adi_project_run ad4630_fmc_zed

