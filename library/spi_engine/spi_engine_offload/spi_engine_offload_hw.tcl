###############################################################################
## Copyright (C) 2020-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create spi_engine_offload {SPI Engine Offload} p_elaboration
ad_ip_files spi_engine_offload [list\
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  spi_engine_offload.v]

# parameters

ad_ip_parameter ASYNC_SPI_CLK INTEGER 0
ad_ip_parameter ASYNC_TRIG INTEGER 0
ad_ip_parameter CMD_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter SDO_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter DATA_WIDTH INTEGER 8
ad_ip_parameter NUM_OF_SDIO INTEGER 1
ad_ip_parameter SDO_STREAMING INTEGER 0

proc p_elaboration {} {

  set data_width [get_parameter_value DATA_WIDTH]
  set num_of_sdi [get_parameter_value NUM_OF_SDIO]
  set disabled_intfs {}

  # control interface

  ad_interface clock ctrl_clk input 1

  add_interface ctrl_cmd_wr conduit end
  add_interface_port ctrl_cmd_wr ctrl_cmd_wr_en    wre   input  1
  add_interface_port ctrl_cmd_wr ctrl_cmd_wr_data  data  input 16

  set_interface_property ctrl_cmd_wr associatedClock if_ctrl_clk
  set_interface_property ctrl_cmd_wr associatedReset none

  add_interface ctrl_sdo_wr conduit end
  add_interface_port ctrl_sdo_wr ctrl_sdo_wr_en    wre   input  1
  add_interface_port ctrl_sdo_wr ctrl_sdo_wr_data  data  input $data_width

  set_interface_property ctrl_sdo_wr associatedClock if_ctrl_clk
  set_interface_property ctrl_sdo_wr associatedReset none

  ad_interface signal  ctrl_enable     input  1   enable
  ad_interface signal  ctrl_enabled    output 1   enabled
  ad_interface signal  ctrl_mem_reset  input  1   reset

  add_interface status_sync axi4stream start
  add_interface_port status_sync status_sync_valid tvalid   output   1
  add_interface_port status_sync status_sync_ready tready   input    1
  add_interface_port status_sync status_sync_data  tdata    output   8

  set_interface_property status_sync associatedClock if_spi_clk
  set_interface_property status_sync associatedReset if_spi_resetn

  # interconnect direction interface

  add_interface m_interconnect_ctrl conduit end
  add_interface_port m_interconnect_ctrl interconnect_dir interconnect_dir output 1
  set_interface_property m_interconnect_ctrl associatedClock if_spi_clk
  set_interface_property m_interconnect_ctrl associatedReset if_spi_resetn

  # SPI Engine interfaces

  ad_interface clock    spi_clk     input 1
  ad_interface reset-n  spi_resetn  input 1 if_spi_clk

  ad_interface signal  trigger     input 1 if_pwm

  ## command interface

  add_interface cmd axi4stream start
  add_interface_port cmd cmd_valid tvalid   output   1
  add_interface_port cmd cmd_ready tready   input    1
  add_interface_port cmd cmd       tdata    output   16

  set_interface_property cmd associatedClock if_spi_clk
  set_interface_property cmd associatedReset if_spi_resetn

  ## SDO data interface

  add_interface sdo_data axi4stream start
  add_interface_port sdo_data sdo_data_valid  tvalid   output  1
  add_interface_port sdo_data sdo_data_ready  tready   input   1
  add_interface_port sdo_data sdo_data        tdata    output  $data_width

  set_interface_property sdo_data associatedClock if_spi_clk
  set_interface_property sdo_data associatedReset if_spi_resetn

  ## SDO streaming data interface

  add_interface s_axis_sdo axi4stream end
  add_interface_port s_axis_sdo s_axis_sdo_valid  tvalid   input  1
  add_interface_port s_axis_sdo s_axis_sdo_ready  tready   output 1
  add_interface_port s_axis_sdo s_axis_sdo_data   tdata    input  $data_width

  set_interface_property s_axis_sdo associatedClock if_spi_clk
  set_interface_property s_axis_sdo associatedReset if_spi_resetn

  ## SDI data interface

  add_interface sdi_data axi4stream end
  add_interface_port sdi_data sdi_data_valid  tvalid  input   1
  add_interface_port sdi_data sdi_data_ready  tready  output  1
  add_interface_port sdi_data sdi_data        tdata   input   [expr $num_of_sdi * $data_width]

  set_interface_property sdi_data associatedClock if_spi_clk
  set_interface_property sdi_data associatedReset if_spi_resetn

  ## SYNC data interface

  add_interface sync axi4stream end
  add_interface_port sync sync_valid  tvalid input   1
  add_interface_port sync sync_ready  tready output  1
  add_interface_port sync sync_data   tdata  input   8

  set_interface_property sync associatedClock if_spi_clk
  set_interface_property sync associatedReset if_spi_resetn

  ## Offload SDI data interface

  add_interface offload_sdi axi4stream start
  add_interface_port offload_sdi offload_sdi_valid tvalid  output  1
  add_interface_port offload_sdi offload_sdi_ready tready  input   1
  add_interface_port offload_sdi offload_sdi_data  tdata   output  [expr $num_of_sdi * $data_width]

  set_interface_property offload_sdi associatedClock if_spi_clk
  set_interface_property offload_sdi associatedReset if_spi_resetn

  if {[get_parameter_value SDO_STREAMING] != 1} {
    lappend disabled_intfs s_axis_sdo
  }

  foreach intf $disabled_intfs {
    set_interface_property $intf ENABLED false
  }
}
