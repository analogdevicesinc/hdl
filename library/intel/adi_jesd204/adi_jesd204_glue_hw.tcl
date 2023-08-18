###############################################################################
## Copyright (C) 2016, 2018, 2019, 2020, 2021, 2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl


ad_ip_create adi_jesd204_glue {Glue} jesd204_phy_glue_elab
set_module_property INTERNAL true

# files

ad_ip_files adi_jesd204_glue [list \
  adi_jesd204_glue.v \
]

# parameters

ad_ip_parameter IN_PLL_POWERDOWN_EN BOOLEAN 1 false

proc jesd204_phy_glue_elab {} {
  add_interface in_pll_powerdown conduit end
  add_interface_port in_pll_powerdown in_pll_powerdown pll_powerdown Input 1
  set_interface_property in_pll_powerdown ENABLED [get_parameter IN_PLL_POWERDOWN_EN]

  add_interface out_pll_powerdown conduit end
  add_interface_port out_pll_powerdown out_pll_powerdown pll_powerdown Output 1
  add_interface out_mcgb_rst conduit end
  add_interface_port out_mcgb_rst out_mcgb_rst mcgb_rst Output 1

  add_interface out_pll_select_gnd conduit end
  add_interface_port out_pll_select_gnd out_pll_select_gnd pll_select Output 1
}
