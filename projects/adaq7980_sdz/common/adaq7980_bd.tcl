
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi

# create a SPI Engine architecture

create_bd_cell -type hier spi
current_bd_instance /spi

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  set spi_engine [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_execution:1.0 execution]
  set axi_spi_engine [create_bd_cell -type ip -vlnv analog.com:user:axi_spi_engine:1.0 axi]
  set spi_engine_offload [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_offload:1.0 offload]
  set spi_engine_interconnect [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_interconnect:1.0 interconnect]
  set spi_engine_trigger_gen [create_bd_cell -type ip -vlnv analog.com:user:util_pulse_gen:1.0 trigger_gen]

  set_property -dict [list CONFIG.DATA_WIDTH 16] $spi_engine_offload
  set_property -dict [list CONFIG.DATA_WIDTH 16] $axi_spi_engine
  set_property -dict [list CONFIG.DATA_WIDTH 16] $spi_engine_interconnect
  set_property -dict [list CONFIG.DATA_WIDTH 16] $spi_engine

  ## to setup the sample rate of the system change the PULSE_PERIOD value
  ## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
  set_property -dict [list CONFIG.PULSE_PERIOD 100] $spi_engine_trigger_gen
  set_property -dict [list CONFIG.PULSE_WIDTH 1] $spi_engine_trigger_gen

  set_property -dict [list CONFIG.NUM_OF_CS 1] $spi_engine
  set_property -dict [list CONFIG.NUM_OFFLOAD 1] $axi_spi_engine

  ad_connect axi/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  ad_connect offload/offload_sdi M_AXIS_SAMPLE

  ad_connect execution/spi m_spi

  ad_connect clk offload/spi_clk
  ad_connect clk offload/ctrl_clk
  ad_connect clk execution/clk
  ad_connect clk axi/s_axi_aclk
  ad_connect clk axi/spi_clk
  ad_connect clk interconnect/clk
  ad_connect clk trigger_gen/clk

  ad_connect axi/spi_resetn offload/spi_resetn
  ad_connect axi/spi_resetn execution/resetn
  ad_connect axi/spi_resetn interconnect/resetn
  ad_connect axi/spi_resetn trigger_gen/rstn
  ad_connect trigger_gen/pulse_period_en GND
  ad_connect trigger_gen/pulse_period GND

  ad_connect trigger_gen/pulse offload/trigger

  ad_connect resetn axi/s_axi_aresetn
  ad_connect irq axi/irq

current_bd_instance /

set axi_adaq7980_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adaq7980_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {1}] $axi_adaq7980_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_adaq7980_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_adaq7980_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_adaq7980_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_adaq7980_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_adaq7980_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_adaq7980_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {16}] $axi_adaq7980_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_adaq7980_dma

ad_connect  sys_cpu_clk spi/clk
ad_connect  sys_cpu_resetn spi/resetn
ad_connect  sys_cpu_resetn axi_adaq7980_dma/m_dest_axi_aresetn

ad_connect  spi/m_spi spi
ad_connect  axi_adaq7980_dma/s_axis spi/M_AXIS_SAMPLE

ad_cpu_interconnect 0x44a00000 spi/axi
ad_cpu_interconnect 0x44a30000 axi_adaq7980_dma

ad_connect sys_cpu_clk axi_adaq7980_dma/s_axis_aclk

ad_cpu_interrupt "ps-13" "mb-13" axi_adaq7980_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" spi/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_adaq7980_dma/m_dest_axi

