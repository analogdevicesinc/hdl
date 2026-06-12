###############################################################################
## Copyright (C) 2019-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make TX_JESD_L=8 RX_OS_JESD_M=16
#      make TX_JESD_M=16 TX_JESD_L=8 RX_JESD_M=16 RX_JESD_L=4 RX_OS_JESD_M=8 RX_OS_JESD_L=4
#      make TX_JESD_M=8 TX_JESD_L=4 RX_JESD_M=16 RX_JESD_L=4 RX_OS_JESD_M=8 RX_OS_JESD_L=4

# Parameter description:
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#

adi_project_create fmcomms8_adrv9009zu11eg 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M    16 ] \
  RX_JESD_L       [get_env_param RX_JESD_L     8 ] \
  RX_JESD_S       [get_env_param RX_JESD_S     1 ] \
  TX_JESD_M       [get_env_param TX_JESD_M    16 ] \
  TX_JESD_L       [get_env_param TX_JESD_L    16 ] \
  TX_JESD_S       [get_env_param TX_JESD_S     1 ] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  8 ] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  8 ] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1 ] \
] "xczu11eg-ffvf1517-2-i"

adi_project_files fmcomms8_adrv9009zu11eg [list \
  "system_top.v" \
  "fmcomms8_constr.xdc"\
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
 ]

adi_project_run fmcomms8_adrv9009zu11eg
