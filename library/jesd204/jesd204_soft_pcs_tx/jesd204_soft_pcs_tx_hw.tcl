###############################################################################
## Copyright (C) 2017-2019, 2021, 2022, 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_soft_pcs_tx "ADI JESD204 Transmit Soft PCS"

set_module_property INTERNAL true

ad_ip_parameter INVERT_OUTPUTS INTEGER 0

add_parameter          IFC_TYPE INTEGER 0
set_parameter_property IFC_TYPE DISPLAY_NAME "Interface type"
set_parameter_property IFC_TYPE HDL_PARAMETER true
set_parameter_property IFC_TYPE ALLOWED_RANGES { "0:Legacy" "1:F-Type" }

# files

ad_ip_files jesd204_soft_pcs_tx [list \
  jesd204_soft_pcs_tx.v \
  jesd204_8b10b_encoder.v \
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

add_interface tx_phy conduit start
#set_interface_property tx_phy associatedClock clock
#set_interface_property tx_phy associatedReset reset
add_interface_port tx_phy char char Input 32
add_interface_port tx_phy charisk charisk Input 4

add_interface tx_raw_data conduit end
#set_interface_property data associatedClock clock
#set_interface_property data associatedReset reset
add_interface_port tx_raw_data data raw_data Output "(IFC_TYPE+1)*40"
