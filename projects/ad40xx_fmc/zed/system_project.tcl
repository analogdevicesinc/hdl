
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## The following HDL projects supports all the devices of EVAL-AD40XX-FMCZ:
##
##  AD4000/AD4001/AD4002/AD4003/AD4004/AD4005/AD4006/AD4007/AD4008/AD4010/AD4011/AD4020
##
## and also the EVAL-ADAQ400x eval board (with PMOD):
##
##  ADAQ4003
##
## NOTE: Make sure that you set up your required ADC resolution and sampling rate
##       in system_bd.tcl

## Please select which eval board do you want to use
##    2 - EVAL-AD40XX-FMCZ
##    1 - EVAL-ADAQ40xx-FMC
##    0 - EVAL-ADAQ400x
##

# system level parameters

if {[info exists ::env(AD40XX_ADAQ400X_N)]} {
  set S_AD40XX_ADAQ400X_N [get_env_param AD40XX_ADAQ400X_N 0]
} elseif {![info exists AD40XX_ADAQ400X_N]} {
  set S_AD40XX_ADAQ400X_N 2
}

adi_project ad40xx_fmc_zed 0 [list \
  AD40XX_ADAQ400X_N  $S_AD40XX_ADAQ400X_N \
]

adi_project_files ad40xx_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $S_AD40XX_ADAQ400X_N {
  2 {
    adi_project_files ad40xx_fmc_zed [list \
      "system_top_ad40xx.v" \
      "system_constr_ad40xx.xdc" \
    ]
  }
  1 {
    adi_project_files ad40xx_fmc_zed [list \
      "system_top_adaq40xx_fmc.v" \
      "system_constr_adaq40xx_fmc.xdc" \
    ]
  }
  0 {
    adi_project_files ad40xx_fmc_zed [list \
      "system_top_adaq400x.v" \
      "system_constr_adaq400x.xdc" \
    ]
  }
}  

adi_project_run ad40xx_fmc_zed

