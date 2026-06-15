###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
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

##--------------------------------------------------------------
# IMPORTANT: Set AD7616 operation and interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make INTF=0
#
# INTF  - Defines the interface type (serial OR parallel)
#       - 0 - parallel (default)
#       - 1 - serial
# NUM_OF_SDIO - Number of SDI lines used when **serial interface** is set
#       - 1 - one SDI line
#       - 2 - two SDI lines (default)
#
# NOTE : This switch is a 'hardware' switch. Please rebuild the design if the
# variable has been changed.
#     SL5 - mounted - Serial
#     SL5 - unmounted - Parallel
#
##--------------------------------------------------------------

set INTF [get_env_param INTF 0]
set NUM_OF_SDIO [get_env_param NUM_OF_SDIO 2]

adi_project ad7616_sdz_zed 0 [list \
   INTF $INTF \
   NUM_OF_SDIO $NUM_OF_SDIO \
]

adi_project_files ad7616_sdz_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

switch $INTF {
  1 {
    switch $NUM_OF_SDIO {
      1 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "system_constr_serial_sdi1.xdc"]
      }
      2 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "system_constr_serial_sdi2.xdc"]
      }
    }
  }
  0 {
    adi_project_files ad7616_sdz_zed [list \
      "system_top_pi.v" \
      "system_constr_parallel.xdc"
    ]
  }
}

adi_project_run ad7616_sdz_zed
