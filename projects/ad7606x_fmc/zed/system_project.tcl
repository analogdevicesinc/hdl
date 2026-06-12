###############################################################################
## Copyright (C) 2023-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# Parameter description
# INTF - Operation interface
#  - Options : Parallel(0)/Serial(1)
# NUM_OF_SDI - Number of SDI lines used
#  - Options: 1, 2, 4, 8
# ADC_N_BITS - ADC resolution
#  - Options: 16, 18

set NUM_OF_SDI [get_env_param NUM_OF_SDI 2]
set ADC_N_BITS [get_env_param ADC_N_BITS 16]
set INTF [get_env_param INTF 0]

adi_project ad7606x_fmc_zed 0 [list \
  INTF $INTF \
  NUM_OF_SDI $NUM_OF_SDI \
  ADC_N_BITS $ADC_N_BITS \
]

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $INTF {
  0 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_pi.v" \
      "system_constr_pif.xdc"]
  }
  1 {
    switch $NUM_OF_SDI {
      1 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_1.xdc"]
      }

      2 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_2.xdc"]
      }

      4 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_4.xdc"]
      }

      8 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_8.xdc"]
      }
    }
  }
}

adi_project_run ad7606x_fmc_zed
