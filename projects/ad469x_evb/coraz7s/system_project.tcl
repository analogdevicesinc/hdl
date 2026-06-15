###############################################################################
## Copyright (C) 2020-2023, 2026 Analog Devices, Inc. All rights reserved.
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
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl

# Parameter description

# SPI_4WIRE - For 0 CNV is linked to PWM. For 1 CNV is linked to SPI_CS
# PWM_OFFLOAD - 0: BUSY edge trigger, DMA+PWM+BUSY gated CNV (ad469x)
#               1: BUSY edge trigger, PWM+BUSY gated CNV (ad4692 register)
#               2: PWM+DMA gated trigger, no CNV gating (ad4692 manual)

adi_project ad469x_evb_coraz7s 0 [list \
  SPI_4WIRE   [get_env_param SPI_4WIRE   0] \
  PWM_OFFLOAD [get_env_param PWM_OFFLOAD 0]]

adi_project_files ad469x_evb_coraz7s [list \
    "../../../library/common/ad_iobuf.v" \
    "../../common/coraz7s/coraz7s_system_constr.xdc" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad469x_evb_coraz7s
