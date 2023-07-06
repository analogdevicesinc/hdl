###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create util_rfifo {Utils Read FIFO} util_rfifo_elab
ad_ip_files util_rfifo [list\
  $ad_hdl_dir/library/common/ad_mem.v \
  util_rfifo.v \
  util_rfifo_constr.sdc]

# parameters

ad_ip_parameter NUM_OF_CHANNELS INTEGER 4
ad_ip_parameter DIN_DATA_WIDTH INTEGER 32
ad_ip_parameter DOUT_DATA_WIDTH INTEGER 64
ad_ip_parameter DIN_ADDRESS_WIDTH INTEGER 8

# defaults

ad_interface clock din_clk input 1
ad_interface reset-n din_rstn input 1 if_din_clk
ad_interface clock dout_clk input 1
ad_interface reset dout_rst input 1 if_dout_clk

add_interface din_0 conduit end
add_interface_port din_0 din_enable_0 enable Output 1
add_interface_port din_0 din_valid_0 valid Output 1
add_interface_port din_0 din_valid_in_0 data_valid Input 1
add_interface_port din_0 din_data_0 data Input DIN_DATA_WIDTH
set_interface_property din_0 associatedClock if_din_clk
set_interface_property din_0 associatedReset none

add_interface dout_0 conduit end
add_interface_port dout_0 dout_enable_0 enable Input 1
add_interface_port dout_0 dout_valid_0 valid Input 1
add_interface_port dout_0 dout_valid_out_0 data_valid Output 1
add_interface_port dout_0 dout_data_0 data Output DOUT_DATA_WIDTH
set_interface_property dout_0 associatedClock if_dout_clk
set_interface_property dout_0 associatedReset none

ad_interface signal din_unf input 1 unf
ad_interface signal dout_unf output 1 unf

proc util_rfifo_elab {} {

  for {set n 1} {$n < 8} {incr n} {
    if {[get_parameter_value NUM_OF_CHANNELS] > $n} {
      add_interface din_${n} conduit end
      add_interface_port din_${n} din_enable_${n} enable Output 1
      add_interface_port din_${n} din_valid_${n} valid Output 1
      add_interface_port din_${n} din_valid_in_${n} data_valid Input 1
      add_interface_port din_${n} din_data_${n} data Input DIN_DATA_WIDTH
      set_interface_property din_${n} associatedClock if_din_clk
      set_interface_property din_${n} associatedReset none

      add_interface dout_${n} conduit end
      add_interface_port dout_${n} dout_enable_${n} enable Input 1
      add_interface_port dout_${n} dout_valid_${n} valid Input 1
      add_interface_port dout_${n} dout_valid_out_${n} data_valid Output 1
      add_interface_port dout_${n} dout_data_${n} data Output DOUT_DATA_WIDTH
      set_interface_property dout_${n} associatedClock if_dout_clk
      set_interface_property dout_${n} associatedReset none
    }
  }
}

