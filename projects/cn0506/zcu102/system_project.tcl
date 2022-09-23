source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set CN0506 interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make INTF_CFG=MII
#
#    INTF_CFG  - Defines the interface type (MII, RGMII or RMII)
#
# LEGEND: MII
#         RGMII
#         RMII
#
##--------------------------------------------------------------

set intf RGMII

if {[info exists ::env(INTF_CFG)]} {
  set intf $::env(INTF_CFG)
} else {
  set env(INTF_CFG) $intf
}

adi_project cn0506_zcu102 0 [list \
  INTF_CFG  $intf \
]

adi_project_files cn0506_zcu102 [list \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
  "system_constr.tcl"
  ]

switch $intf {
  MII {
    adi_project_files cn0506_zcu102 [list \
      "system_top_mii.v" ]
  }
  RGMII {
    adi_project_files cn0506_zcu102 [list \
      "system_top_rgmii.v" ]
  }
  RMII {
    adi_project_files cn0506_zcu102 [list \
      "system_top_rmii.v" ]
  }
}

adi_project_run cn0506_zcu102
