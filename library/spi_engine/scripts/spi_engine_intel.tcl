###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc spi_engine_create {{name "spi_engine"}
                        {data_width 32}
                        {async_spi_clk 1}
                        {num_cs 1}
                        {num_sdi 1}
                        {num_sdo 1}
                        {sdi_delay 0}
                        {echo_sclk 0}
                        {sdo_streaming 0}
                        {cmd_mem_addr_width 4}
                        {data_mem_addr_width 4}
                        {sdi_fifo_addr_width 5}
                        {sdo_fifo_addr_width 5}
                        {sync_fifo_addr_width 4}
                        {cmd_fifo_addr_width 4}} {

  # save current top system for restoring later
  save_system {system_bd.qsys}

  # create subsystem for spi engine
  create_system spi_engine_subsystem

  # create external interfaces
  if {$async_spi_clk == 1} {
    add_instance spi_clk clock_source
    set_instance_parameter_value spi_clk {clockFrequencyKnown} {0}
    add_interface spi_clk clock sink
    set_interface_property spi_clk EXPORT_OF spi_clk.clk_in
  }
  if {$echo_sclk == 1} {
    add_instance echo_clk clock_source
    set_instance_parameter_value echo_clk {clockFrequencyKnown} {0}
    add_interface echo_clk clock sink
    set_interface_property echo_clk EXPORT_OF echo_clk.clk_in
  }
  add_instance axi_clk clock_source
  set_instance_parameter_value axi_clk {clockFrequencyKnown} {0}
  add_interface axi_clk clock sink
  set_interface_property axi_clk EXPORT_OF axi_clk.clk_in
  add_interface rst           reset   sink
  set_interface_property rst EXPORT_OF axi_clk.clk_in_reset

  add_interface s_axi axi4lite end
  add_interface trigger       conduit end
  add_interface interrupt_ender           interrupt end
  add_interface m_spi_sclk    clock      source
  add_interface m_spi_cs      conduit    start
  add_interface m_spi_miso    conduit    end
  add_interface m_spi_mosi    conduit    start
  add_interface m_axis_sample axi4stream start
  if {$sdo_streaming == 1} {
    add_interface s_axis_sample axi4stream end
  }

  # spi engine IP instances
  set execution "${name}_execution"
  set axi_regmap "${name}_axi_regmap"
  set offload "${name}_offload"
  set interconnect "${name}_interconnect"

  add_instance $execution spi_engine_execution
  set_instance_parameter_value $execution {NUM_OF_CS} $num_cs
  set_instance_parameter_value $execution {DATA_WIDTH} $data_width
  set_instance_parameter_value $execution {NUM_OF_SDI} $num_sdi
  set_instance_parameter_value $execution {SDI_DELAY} $sdi_delay
  set_instance_parameter_value $execution {ECHO_SCLK} $echo_sclk
  set_instance_parameter_value $execution {SDO_DEFAULT} 1

  add_instance $axi_regmap axi_spi_engine
  set_instance_parameter_value $axi_regmap {ASYNC_SPI_CLK} $async_spi_clk
  set_instance_parameter_value $axi_regmap {DATA_WIDTH}    $data_width
  set_instance_parameter_value $axi_regmap {MM_IF_TYPE}    {0}
  set_instance_parameter_value $axi_regmap {NUM_OF_SDI}    $num_sdi
  set_instance_parameter_value $axi_regmap {NUM_OFFLOAD}   {1}
  set_instance_parameter_value $axi_regmap {OFFLOAD0_CMD_MEM_ADDRESS_WIDTH} $cmd_mem_addr_width
  set_instance_parameter_value $axi_regmap {OFFLOAD0_SDO_MEM_ADDRESS_WIDTH} $data_mem_addr_width
  set_instance_parameter_value $axi_regmap {SDI_FIFO_ADDRESS_WIDTH}         $sdi_fifo_addr_width
  set_instance_parameter_value $axi_regmap {SDO_FIFO_ADDRESS_WIDTH}         $sdo_fifo_addr_width
  set_instance_parameter_value $axi_regmap {SYNC_FIFO_ADDRESS_WIDTH}        $sync_fifo_addr_width
  set_instance_parameter_value $axi_regmap {CMD_FIFO_ADDRESS_WIDTH}         $cmd_fifo_addr_width

  add_instance $offload spi_engine_offload
  set_instance_parameter_value $offload {ASYNC_TRIG}    {0}
  set_instance_parameter_value $offload {ASYNC_SPI_CLK} 0
  set_instance_parameter_value $offload {DATA_WIDTH}    $data_width
  set_instance_parameter_value $offload {NUM_OF_SDI}    $num_sdi
  set_instance_parameter_value $offload {SDO_STREAMING} $sdo_streaming
  set_instance_parameter_value $offload {CMD_MEM_ADDRESS_WIDTH} $cmd_mem_addr_width
  set_instance_parameter_value $offload {SDO_MEM_ADDRESS_WIDTH} $data_mem_addr_width

  add_instance $interconnect spi_engine_interconnect
  set_instance_parameter_value $interconnect {DATA_WIDTH} $data_width
  set_instance_parameter_value $interconnect {NUM_OF_SDI} $num_sdi

  # clocks
  add_connection axi_clk.clk $axi_regmap.s_axi_clock

   if {$async_spi_clk == 1} {
    add_connection spi_clk.clk $axi_regmap.if_spi_clk
    add_connection spi_clk.clk $execution.if_clk
    add_connection spi_clk.clk $interconnect.if_clk
    add_connection spi_clk.clk $offload.if_ctrl_clk
    add_connection spi_clk.clk $offload.if_spi_clk
  } else {
    add_connection axi_clk.clk $axi_regmap.if_spi_clk
    add_connection axi_clk.clk $execution.if_clk
    add_connection axi_clk.clk $interconnect.if_clk
    add_connection axi_clk.clk $offload.if_ctrl_clk
    add_connection axi_clk.clk $offload.if_spi_clk
  }
  if {$echo_sclk == 1} {
    add_connection echo_sclk.clk $execution.echo_sclk
  }

  # resets
  add_connection axi_clk.clk_reset $axi_regmap.s_axi_reset
  add_connection $axi_regmap.if_spi_resetn $execution.if_resetn
  add_connection $axi_regmap.if_spi_resetn $interconnect.if_resetn
  add_connection $axi_regmap.if_spi_resetn $offload.if_spi_resetn
  if {$async_spi_clk == 1} {
    # not really needed, but quartus complains otherwise
    # we are not using spi_clk.clk_reset
    add_connection $axi_regmap.if_spi_resetn spi_clk.clk_in_reset
  }

  # spi engine internal connections
  add_connection $interconnect.m_cmd $execution.cmd
  add_connection $execution.sdi_data $interconnect.m_sdi
  add_connection $interconnect.m_sdo $execution.sdo_data
  add_connection $execution.sync $interconnect.m_sync
  add_connection $axi_regmap.cmd $interconnect.s1_cmd
  add_connection $interconnect.s1_sdi $axi_regmap.sdi_data
  add_connection $axi_regmap.sdo_data $interconnect.s1_sdo
  add_connection $interconnect.s1_sync $axi_regmap.sync
  add_connection $offload.cmd $interconnect.s0_cmd
  add_connection $interconnect.s0_sdi  $offload.sdi_data
  add_connection $offload.sdo_data $interconnect.s0_sdo
  add_connection $interconnect.s0_sync $offload.sync
  add_connection $offload.m_interconnect_ctrl $interconnect.s_interconnect_ctrl
  add_connection $offload.ctrl_cmd_wr       $axi_regmap.offload0_cmd
  add_connection $offload.ctrl_sdo_wr       $axi_regmap.offload0_sdo
  add_connection $offload.if_ctrl_enable    $axi_regmap.if_offload0_enable
  add_connection $offload.if_ctrl_enabled   $axi_regmap.if_offload0_enabled
  add_connection $offload.if_ctrl_mem_reset $axi_regmap.if_offload0_mem_reset
  add_connection $offload.status_sync       $axi_regmap.offload_sync

  # external interface connections
  set_interface_property m_spi_sclk       EXPORT_OF $execution.if_cs
  set_interface_property m_spi_cs         EXPORT_OF $execution.if_sclk
  set_interface_property m_spi_miso       EXPORT_OF $execution.if_sdi
  set_interface_property m_spi_mosi       EXPORT_OF $execution.if_sdo
  set_interface_property m_spi_mosi_t     EXPORT_OF $execution.if_sdo_t
  set_interface_property m_spi_three_wire EXPORT_OF $execution.if_three_wire
  set_interface_property m_axis_sample    EXPORT_OF $offload.offload_sdi
  if {$sdo_streaming == 1} {
    set_interface_property s_axis_sample  EXPORT_OF $offload.s_axis_sdo
  }
  set_interface_property trigger          EXPORT_OF $offload.if_trigger
  set_interface_property interrupt_sender EXPORT_OF $axi_regmap.interrupt_sender
  set_interface_property s_axi            EXPORT_OF $axi_regmap.s_axi

  # save it for debugging
  save_system "spi_engine_subsystem.qsys"
  # export hardware tcl for synthesis tools
  export_hw_tcl
  # reload previous system
  load_system {system_bd.qsys}

  add_instance $name spi_engine_subsystem
}