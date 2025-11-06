###############################################################################
## Copyright (C) 2021-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make LANES_PER_CHANNEL=4  CAPTURE_ZONE=2
#
#
# Parameter description:
#
# CLK_MODE : Clocking mode of the device's digital interface
#
#   0 - SPI Mode
#   1 - Echo-clock or Master clock mode
#
# NUM_OF_CHANNEL : the number of ADC channels
#
#    1 - AD403x devices
#    2 - AD463x/adaq42xx devices
#
# LANES_PER_CHANNEL : the number of MOSI lines of the SPI interface
#
#    1 - 1 lane per channel: Interleaved mode or single lane per channel
#    2 - 2 lanes per channel
#    4 - 4 lanes per channel
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
# INTERLEAVE_MODE: parameter used for NUM_OF_CHANNEL = 2 and LANES_PER_CHANNEL = 1 (ad463x).
# Enabling INTERLEAVE_MODE for any other configuration is invalid.
#
#     0 - interleave mode disabled, each channel has its own SDI line
#     1 - interleave mode enabled, the ad463x ADC share the same SDI line
#
# Example:
#
#     make CLK_MODE=0 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=0 INTERLEAVE_MODE=0
#

if {[get_env_param INTERLEAVE_MODE 0] == 1} {
  set NUM_OF_SDI      1
} else {
  set NUM_OF_SDI      [expr {[get_env_param NUM_OF_CHANNEL 2] * [get_env_param LANES_PER_CHANNEL 2]}]
}

adi_project ad4630_fmc_zed 0 [list \
  CLK_MODE           [get_env_param CLK_MODE           0] \
  LANES_PER_CHANNEL  [get_env_param LANES_PER_CHANNEL  2] \
  NUM_OF_CHANNEL     [get_env_param NUM_OF_CHANNEL     2] \
  NUM_OF_SDI         $NUM_OF_SDI                          \
  CAPTURE_ZONE       [get_env_param CAPTURE_ZONE       2] \
  DDR_EN             [get_env_param DDR_EN             0] \
  INTERLEAVE_MODE    [get_env_param INTERLEAVE_MODE    0] ]

adi_project_files ad4630_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

switch [get_env_param LANES_PER_CHANNEL 2] {
  1 {
    # For 1 lane per channel, check NUM_OF_CHANNEL
    if {[get_env_param NUM_OF_CHANNEL 2] == 1} {
      # 1 channel, 1 SDI lane
      adi_project_files ad4630_fmc_zed [list \
        "system_constr_1sdi_1ch.xdc" ]
    } else {
      # 2 channels, check INTERLEAVE_MODE
      if {[get_env_param INTERLEAVE_MODE 0] == 0} {
        # INTERLEAVE_MODE=0: 2 SDI lanes (1 per channel)
        adi_project_files ad4630_fmc_zed [list \
          "system_constr_2sdi_2ch.xdc" ]
      } else {
        # INTERLEAVE_MODE=1: valid for AD463x only, both channels share the same SDI line
        adi_project_files ad4630_fmc_zed [list \
          "system_constr_1sdi_2ch_interleave.xdc" ]
      }
    }
  }
  2 {
    # For 2 lanes per channel, check NUM_OF_CHANNEL
    if {[get_env_param NUM_OF_CHANNEL 2] == 1} {
      # 1 channel, 2 SDI lanes
      adi_project_files ad4630_fmc_zed [list \
        "system_constr_2sdi_1ch.xdc" ]
    } else {
      # 2 channels, 4 SDI lanes (2 per channel)
      adi_project_files ad4630_fmc_zed [list \
        "system_constr_4sdi_2ch.xdc" ]
    }
  }
  4 {
    # For 4 lanes per channel, check NUM_OF_CHANNEL
    if {[get_env_param NUM_OF_CHANNEL 2] == 1} {
      # 1 channel, 4 SDI lanes
      adi_project_files ad4630_fmc_zed [list \
        "system_constr_4sdi_1ch.xdc" ]
    } else {
      # 2 channels, 8 SDI lanes (4 per channel)
      adi_project_files ad4630_fmc_zed [list \
        "system_constr_8sdi_2ch.xdc" ]
    }
  }
  default {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_4sdi_2ch.xdc" ]
  }
}

adi_project_run ad4630_fmc_zed
