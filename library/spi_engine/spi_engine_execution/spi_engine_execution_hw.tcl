
package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create spi_engine_execution {SPI Engine Execution} p_elaboration
ad_ip_files spi_engine_execution [list\
  spi_engine_execution.v]

# parameters

ad_ip_parameter NUM_OF_CS INTEGER 1
ad_ip_parameter DEFAULT_SPI_CFG INTEGER 0
ad_ip_parameter DEFAULT_SPI_DIV INTEGER 0
ad_ip_parameter DATA_WIDTH INTEGER 8
ad_ip_parameter NUM_OF_SDI INTEGER 1

proc p_elaboration {} {

  set data_width [get_parameter_value DATA_WIDTH]
  set num_of_sdi [get_parameter_value NUM_OF_SDI]
  set num_of_cs [get_parameter_value NUM_OF_CS]

  # clock and reset interface

  ad_interface clock   clk     input 1
  ad_interface reset-n resetn  input 1 if_clk

  ad_interface signal active output 1

  # command interface

  add_interface cmd_if conduit end
  add_interface_port cmd_if cmd_ready ready output 1
  add_interface_port cmd_if cmd_valid valid input 1
  add_interface_port cmd_if cmd       data  input 16

  set_interface_property cmd_if associatedClock if_clk
  set_interface_property cmd_if associatedReset if_resetn

  # SDO data interface

  add_interface sdo_if conduit end
  add_interface_port sdo_if sdo_data_ready ready output 1
  add_interface_port sdo_if sdo_data_valid valid input  1
  add_interface_port sdo_if sdo_data        data input  $data_width

  set_interface_property sdo_if associatedClock if_clk
  set_interface_property sdo_if associatedReset if_resetn

  # SDI data interface

  add_interface sdi_if conduit end
  add_interface_port sdi_if sdi_data_ready  ready input  1
  add_interface_port sdi_if sdi_data_valid  valid output 1
  add_interface_port sdi_if sdi_data        data  output [expr $num_of_sdi * $data_width]

  set_interface_property sdi_if associatedClock if_clk
  set_interface_property sdi_if associatedReset if_resetn

  # SYNC data interface

  add_interface sync_if conduit end
  add_interface_port sync_if sync_data_valid  valid input  1
  add_interface_port sync_if sync_data_ready  ready output 1
  add_interface_port sync_if sync_data        data  input  8

  set_interface_property sync_if associatedClock if_clk
  set_interface_property sync_if associatedReset if_resetn

  ## physical SPI interface

  ad_interface clock sclk output 1

  ad_interface signal sdo output 1
  ad_interface signal sdo_t output 1

  ad_interface signal sdi   input 1
  ad_interface signal sdi_1 input 1
  ad_interface signal sdi_2 input 1
  ad_interface signal sdi_3 input 1
  ad_interface signal sdi_4 input 1
  ad_interface signal sdi_5 input 1
  ad_interface signal sdi_6 input 1
  ad_interface signal sdi_7 input 1

  ad_interface signal cs output 1
  ad_interface signal three_wire output 1

}

