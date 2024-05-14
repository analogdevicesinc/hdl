###############################################################################
## Copyright (C) 2017-2019, 2021, 2022, 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_soft_pcs_rx "ADI JESD204 Receive Soft PCS"

ad_ip_parameter REGISTER_INPUTS INTEGER 0
ad_ip_parameter INVERT_INPUTS INTEGER 0

set_module_property INTERNAL true

add_parameter          IFC_TYPE INTEGER 0
set_parameter_property IFC_TYPE DISPLAY_NAME "Interface type"
set_parameter_property IFC_TYPE HDL_PARAMETER true
set_parameter_property IFC_TYPE ALLOWED_RANGES { "0:Legacy" "1:F-Type" }

# files

ad_ip_files jesd204_soft_pcs_rx [list \
  jesd204_soft_pcs_rx.v \
  jesd204_pattern_align.v \
  jesd204_8b10b_decoder.v \
]

# clock

add_interface clock clock end
add_interface_port clock clk clk Input 1

# reset

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT

add_interface_port reset reset reset Input 1

# interfaces

add_interface rx_phy conduit start
#set_interface_property rx_phy associatedClock clock
#set_interface_property rx_phy associatedReset reset
add_interface_port rx_phy char char Output 32
add_interface_port rx_phy charisk charisk Output 4
add_interface_port rx_phy disperr disperr Output 4
add_interface_port rx_phy notintable notintable Output 4
add_interface_port rx_phy patternalign_en patternalign_en Input 1

add_interface rx_raw_data conduit end
#set_interface_property rx_raw_data associatedClock clock
#set_interface_property rx_raw_data associatedReset reset
add_interface_port rx_raw_data data raw_data Input "(IFC_TYPE+1)*40"
