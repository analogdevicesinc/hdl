###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc spi_engine_create {{name "spi_engine"} {axi_clk} {axi_reset} {spi_clk} {data_width 32} {async_spi_clk 1} {num_cs 1} {num_sdi 1} {num_sdo 1} {sdi_delay 0} {echo_sclk 0} {sdo_streaming 0} {cmd_mem_addr_width 4} {data_mem_addr_width 4} {sdi_fifo_addr_width 5} {sdo_fifo_addr_width 5} {sync_fifo_addr_width 4} {cmd_fifo_addr_width 4}} {

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
  add_connection $axi_clk $axi_regmap.s_axi_clock
  add_connection $spi_clk $axi_regmap.if_spi_clk
  add_connection $spi_clk $execution.if_clk
  add_connection $spi_clk $interconnect.if_clk
  add_connection $spi_clk $offload.if_ctrl_clk
  add_connection $spi_clk $offload.if_spi_clk

  # resets
  add_connection $axi_reset $axi_regmap.s_axi_reset
  add_connection $axi_regmap.if_spi_resetn $execution.if_resetn
  add_connection $axi_regmap.if_spi_resetn $interconnect.if_resetn
  add_connection $axi_regmap.if_spi_resetn $offload.if_spi_resetn

  # interfaces
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

}