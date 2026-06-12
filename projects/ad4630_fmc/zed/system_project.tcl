###############################################################################
## Copyright (C) 2021-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
# NO_REORDER : Parameter used for CAPTURE_ZONE = 1 and NUM_OF_SDI = 1 (ad4030)
# or NUM_OF_SDI = 2 (ad4630) to connect the SPI Engine directly to DMA bypassing
# the spi_axis_reorder IP
#
#   0 - spi_axis_reorder present in the system
#   1 - spi_axis_reorder removed from the system
#
# Example:
#
#   make NUM_OF_SDI=2 CAPTURE_ZONE=2
#

adi_project ad4630_fmc_zed 0 [list \
  CLK_MODE     [get_env_param CLK_MODE      0] \
  NUM_OF_SDI   [get_env_param NUM_OF_SDI    4] \
  CAPTURE_ZONE [get_env_param CAPTURE_ZONE  2] \
  DDR_EN       [get_env_param DDR_EN        0] \
  NO_REORDER   [get_env_param NO_REORDER    0] ]

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
