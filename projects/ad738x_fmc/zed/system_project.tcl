###############################################################################
## Copyright (C) 2019-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# FMC_N_PMOD - Selects the connector used for the ADC interface
#  - Options : PMOD JA(0)/FMC(1)
#  - PMOD supports only the 1 SDI/SDO variant (ALERT_SPI_N=0, NUM_OF_SDIO=1)
# ALERT_SPI_N - SDOB-SDOD/ALERT pin can operate as a serial data output pin or alert indication output
#  - Options : SDOB-SDOD(0)/ALERT(1)
# NUM_OF_SDIO - Number of SDI lines used
#  - Options : 1,2,4

set FMC_N_PMOD  [get_env_param FMC_N_PMOD  1]
set ALERT_SPI_N [get_env_param ALERT_SPI_N 0]
set NUM_OF_SDIO [get_env_param NUM_OF_SDIO 1]

if {$FMC_N_PMOD == 0 && ($ALERT_SPI_N != 0 || $NUM_OF_SDIO != 1)} {
  return -code error "ERROR: FMC_N_PMOD=0 (PMOD) supports only ALERT_SPI_N=0 and NUM_OF_SDIO=1"
}

adi_project ad738x_fmc_zed 0 [list \
  FMC_N_PMOD  $FMC_N_PMOD \
  ALERT_SPI_N $ALERT_SPI_N \
  NUM_OF_SDIO $NUM_OF_SDIO ]

adi_project_files ad738x_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
    "system_constr.xdc" ]

if {$FMC_N_PMOD == 0} {
  adi_project_files ad738x_fmc_zed [list \
    "system_top_pmod.v" \
    "system_constr_pmod.xdc" ]
} elseif {$FMC_N_PMOD == 1} {
  adi_project_files ad738x_fmc_zed [list \
    "system_top.v" \
    "system_constr_fmc.xdc" ]

  switch $NUM_OF_SDIO {
    2 {
      adi_project_files ad738x_fmc_zed [list \
        "system_constr_2sdi.xdc" ]
    }
    4 {
      adi_project_files ad738x_fmc_zed [list \
        "system_constr_4sdi.xdc" ]
    }
    default {
      adi_project_files ad738x_fmc_zed [list \
        "system_constr_1sdi.xdc" ]
    }
  }
} else {
  return -code error "ERROR: Invalid FMC_N_PMOD value! Options: 0 (PMOD), 1 (FMC)"
}

adi_project_run ad738x_fmc_zed
