
package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create spi_engine_offload {SPI Engine Offload} p_elaboration
ad_ip_files spi_engine_offload [list\
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  spi_engine_offload.v]

# parameters

ad_ip_parameter ASYNC_SPI_CLK INTEGER 0
ad_ip_parameter ASYNC_TRIG INTEGER 0
ad_ip_parameter CMD_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter SDO_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter DATA_WIDTH INTEGER 8
ad_ip_parameter NUM_OF_SDI INTEGER 1

proc p_elaboration {} {

  set data_width [get_parameter_value DATA_WIDTH]
  set num_of_sdi [get_parameter_value NUM_OF_SDI]

  # control interface

  ad_interface clock ctrl_clk input 1

  add_interface ctrl_cmd_if conduit end
  add_interface_port ctrl_cmd_if ctrl_cmd_wr_en    wre   output  1
  add_interface_port ctrl_cmd_if ctrl_cmd_wr_data  data  output 16

  set_interface_property ctrl_cmd_if associatedClock if_ctrl_clk
  set_interface_property ctrl_cmd_if associatedReset none

  add_interface ctrl_sdo_if conduit end
  add_interface_port ctrl_sdo_if ctrl_sdo_wr_en    wre   output  1
  add_interface_port ctrl_sdo_if ctrl_sdo_wr_data  data  output $data_width

  set_interface_property ctrl_sdo_if associatedClock if_ctrl_clk
  set_interface_property ctrl_sdo_if associatedReset none

  ad_interface signal  ctrl_enable     input  1   enable
  ad_interface signal  ctrl_enabled    output 1   enabled
  ad_interface signal  ctrl_mem_reset  input  1   reset

  # SPI Engine interfaces

  ad_interface clock   spi_clk     input 1
  ad_interface reset-n spi_resetn  input 1 if_spi_clk

  ad_interface signal  trigger     input 1

  ## command interface

  add_interface cmd_if conduit end
  add_interface_port cmd_if cmd_valid valid   output    1
  add_interface_port cmd_if cmd_ready ready   input     1
  add_interface_port cmd_if cmd       data    output   16

  set_interface_property cmd_if associatedClock if_spi_clk
  set_interface_property cmd_if associatedReset if_spi_resetn

  ## SDO data interface

  add_interface sdo_if conduit end
  add_interface_port sdo_if sdo_data_valid  valid   output 1
  add_interface_port sdo_if sdo_data_ready  ready   input  1
  add_interface_port sdo_if sdo_data        data    output $data_width

  set_interface_property sdo_if associatedClock if_spi_clk
  set_interface_property sdo_if associatedReset if_spi_resetn

  ## SDI data interface

  add_interface sdi_if conduit end
  add_interface_port sdi_if sdi_data_valid  valid input   1
  add_interface_port sdi_if sdi_data_ready  ready output  1
  add_interface_port sdi_if sdi_data        data  input   [expr $num_of_sdi * $data_width]

  set_interface_property sdi_if associatedClock if_spi_clk
  set_interface_property sdi_if associatedReset if_spi_resetn

  ## SYNC data interface

  add_interface sync_if conduit end
  add_interface_port sync_if sync_data_valid  valid input   1
  add_interface_port sync_if sync_data_ready  ready output  1
  add_interface_port sync_if sync_data        data  input   8

  set_interface_property sync_if associatedClock if_spi_clk
  set_interface_property sync_if associatedReset if_spi_resetn

  ## Offload SDI data interface

  add_interface offload_sdi_if conduit end
  add_interface_port offload_sdi_if offload_sdi_valid  valid input   1
  add_interface_port offload_sdi_if offload_sdi_ready  ready output  1
  add_interface_port offload_sdi_if offload_sdi_data   data  input   [expr $num_of_sdi * $data_width]

  set_interface_property offload_sdi_if associatedClock if_spi_clk
  set_interface_property offload_sdi_if associatedReset if_spi_resetn

}
