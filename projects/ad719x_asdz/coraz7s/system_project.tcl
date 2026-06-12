###############################################################################
## Copyright (C) 2022-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# In the case of:
# EVAL-AD7190 and EVAL-AD9175:
#   it works both connecting its PMOD to PMOD JA of Cora, and
#   placing it on top of Cora, connecting it to the Arduino header
# EVAL-AD7193: only ARDZ_PMOD_N=1;
#   works only by placing it on top of Cora, connecting it to the Arduino header

# make  or  make ARDZ_PMOD_N=0 - connect the eval board PMOD to PMOD JA of Cora
# make ARDZ_PMOD_N=1 - connect the eval board to the Arduino header (placing it on top of Cora)

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad719x_asdz_coraz7s 0 [list \
  ARDZ_PMOD_N [get_env_param ARDZ_PMOD_N 0] \
]

adi_project_files ad719x_asdz_coraz7s [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc" \
]

switch [get_env_param ARDZ_PMOD_N 0] {
  0 {
    # PMOD
    adi_project_files {} [list \
      "system_constr_pmod.xdc" \
      "system_top_pmod.v" \
    ]
  }
  1 {
    # through Arduino header
    adi_project_files {} [list \
      "system_constr_ardz.xdc" \
      "system_top_ardz.v" \
    ]
  }
  default {
    # PMOD - default mode
    adi_project_files {} [list \
      "system_constr_pmod.xdc" \
      "system_top_pmod.v" \
    ]
  }
}

adi_project_run ad719x_asdz_coraz7s
