###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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
