###############################################################################
## Copyright (C) 2020-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create spi_engine_execution {SPI Engine Execution}
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files spi_engine_execution [list\
  spi_engine_execution.v \
  spi_engine_execution_shiftreg.v]

# parameters

ad_ip_parameter NUM_OF_CS INTEGER 1
ad_ip_parameter DEFAULT_SPI_CFG INTEGER 0
ad_ip_parameter DEFAULT_CLK_DIV INTEGER 0
ad_ip_parameter DATA_WIDTH INTEGER 8
ad_ip_parameter NUM_OF_SDI INTEGER 1
ad_ip_parameter SDI_DELAY INTEGER 0
ad_ip_parameter SDO_DEFAULT INTEGER 0

proc p_elaboration {} {

  set data_width [get_parameter_value DATA_WIDTH]
  set num_of_sdi [get_parameter_value NUM_OF_SDI]
  set num_of_cs [get_parameter_value NUM_OF_CS]

  # clock and reset interface

  ad_interface clock   clk     input 1
  ad_interface reset-n resetn  input 1 if_clk

  # command interface

  add_interface cmd axi4stream end
  add_interface_port cmd cmd_ready tready output 1
  add_interface_port cmd cmd_valid tvalid input  1
  add_interface_port cmd cmd       tdata  input  16

  set_interface_property cmd associatedClock if_clk
  set_interface_property cmd associatedReset if_resetn

  # SDO data interface

  add_interface sdo_data axi4stream end
  add_interface_port sdo_data sdo_data_ready  tready output 1
  add_interface_port sdo_data sdo_data_valid  tvalid input  1
  add_interface_port sdo_data sdo_data        tdata  input  $data_width

  set_interface_property sdo_data associatedClock if_clk
  set_interface_property sdo_data associatedReset if_resetn

  # SDI data interface

  add_interface sdi_data axi4stream start
  add_interface_port sdi_data sdi_data_ready  tready input  1
  add_interface_port sdi_data sdi_data_valid  tvalid output 1
  add_interface_port sdi_data sdi_data        tdata  output [expr $num_of_sdi * $data_width]

  set_interface_property sdi_data associatedClock if_clk
  set_interface_property sdi_data associatedReset if_resetn

  # SYNC data interface

  add_interface sync axi4stream start
  add_interface_port sync sync_valid  tvalid output  1
  add_interface_port sync sync_ready  tready input 1
  add_interface_port sync sync        tdata  output  8

  set_interface_property sync associatedClock if_clk
  set_interface_property sync associatedReset if_resetn

  # physical SPI interface

  ad_interface clock sclk output 1

  ad_interface signal sdo   output 1
  ad_interface signal sdo_t output 1
  ad_interface signal sdi   input  $num_of_sdi

  ad_interface signal cs output 1
  ad_interface signal three_wire output 1

}

