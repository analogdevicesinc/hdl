###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require -exact qsys 13.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl


set_module_property NAME util_clkdiv
set_module_property DESCRIPTION "Clock Division Utility"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_clkdiv

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_clkdiv
add_fileset_file util_clkdiv.v       VERILOG PATH util_clkdiv.v TOP_LEVEL_FILE

# defaults

ad_interface clock   clk             input   1
ad_interface reset   reset           input 1 if_clk
ad_interface clock   clk_out         output  1
ad_interface reset   reset_out       output 1 if_clk_out

