
source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl

# adc interface

set adc_clk_in_p    [create_bd_port -dir I adc_clk_in_p]
set adc_clk_in_n    [create_bd_port -dir I adc_clk_in_n]
set adc_or_in_p     [create_bd_port -dir I adc_or_in_p]
set adc_or_in_n     [create_bd_port -dir I adc_or_in_n]
set adc_data_in_p   [create_bd_port -dir I -from 15 -to 0 adc_data_in_p]
set adc_data_in_n   [create_bd_port -dir I -from 15 -to 0 adc_data_in_n]

if {$sys_zynq == 1} {

  set spi_csn_2_o     [create_bd_port -dir O spi_csn_2_o]
  set spi_csn_1_o     [create_bd_port -dir O spi_csn_1_o]
  set spi_csn_0_o     [create_bd_port -dir O spi_csn_0_o]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]

} else {

  set spi_csn_o       [create_bd_port -dir O -from 2 -to 0 spi_csn_o]
  set spi_csn_i       [create_bd_port -dir I -from 2 -to 0 spi_csn_i]
}

set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

if {$sys_zynq == 0} {

  set gpio_fmcomms6_i   [create_bd_port -dir I gpio_fmcomms6_i]
  set gpio_fmcomms6_o   [create_bd_port -dir O gpio_fmcomms6_o]
  set gpio_fmcomms6_t   [create_bd_port -dir O gpio_fmcomms6_t]
}

# dma interface

set adc_clk         [create_bd_port -dir O adc_clk]
set adc_valid_0     [create_bd_port -dir O adc_valid_0]
set adc_enable_0    [create_bd_port -dir O adc_enable_0]
set adc_data_0      [create_bd_port -dir O -from 15 -to 0 adc_data_0]
set adc_valid_1     [create_bd_port -dir O adc_valid_1]
set adc_enable_1    [create_bd_port -dir O adc_enable_1]
set adc_data_1      [create_bd_port -dir O -from 15 -to 0 adc_data_1]
set adc_dma_wr      [create_bd_port -dir I adc_dma_wr]
set adc_dma_sync    [create_bd_port -dir I adc_dma_sync]
set adc_dma_wdata   [create_bd_port -dir I -from 31 -to 0 adc_dma_wdata]

# adc peripherals

set axi_ad9652 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9652:1.0 axi_ad9652]

set axi_ad9652_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9652_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9652_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9652_dma

if {$sys_zynq == 1} {
  set axi_ad9652_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9652_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9652_dma_interconnect
}

if {$sys_zynq == 0} {

  set axi_fmcomms6_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_fmcomms6_gpio]
  set_property -dict [list CONFIG.C_IS_DUAL {0}] $axi_fmcomms6_gpio
  set_property -dict [list CONFIG.C_GPIO_WIDTH {1}] $axi_fmcomms6_gpio
  set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_fmcomms6_gpio

  set axi_fmcomms6_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_fmcomms6_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_fmcomms6_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {3}] $axi_fmcomms6_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_fmcomms6_spi
}

# additions to default configuration

if {$sys_zynq == 1} {

  set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125.0}] $sys_ps7
  set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7

  set_property LEFT 16 [get_bd_ports GPIO_I]
  set_property LEFT 16 [get_bd_ports GPIO_O]
  set_property LEFT 16 [get_bd_ports GPIO_T]

} else {

  set_property -dict [list CONFIG.NUM_MI {11}] $axi_cpu_interconnect
  set_property -dict [list CONFIG.NUM_SI {9}] $axi_mem_interconnect
  delete_bd_objs [get_bd_nets sys_concat_intc_din_2] [get_bd_ports unc_int2]
  delete_bd_objs [get_bd_nets sys_concat_intc_din_3] [get_bd_ports unc_int3]
}

# connections (spi and gpio)

if {$sys_zynq == 1 } {

  connect_bd_net -net spi_csn_2_o [get_bd_ports spi_csn_2_o]  [get_bd_pins sys_ps7/SPI0_SS2_O]
  connect_bd_net -net spi_csn_1_o [get_bd_ports spi_csn_1_o]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_0_o [get_bd_ports spi_csn_0_o]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]    [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]    [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]    [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]    [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]    [get_bd_pins sys_ps7/SPI0_MISO_I]

} else {

  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]                [get_bd_pins axi_fmcomms6_spi/ss_i]
  connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]                [get_bd_pins axi_fmcomms6_spi/ss_o]
  connect_bd_net -net spi_clk_i   [get_bd_ports spi_clk_i]                [get_bd_pins axi_fmcomms6_spi/sck_i]
  connect_bd_net -net spi_clk_o   [get_bd_ports spi_clk_o]                [get_bd_pins axi_fmcomms6_spi/sck_o]
  connect_bd_net -net spi_sdo_i   [get_bd_ports spi_sdo_i]                [get_bd_pins axi_fmcomms6_spi/io0_i]
  connect_bd_net -net spi_sdo_o   [get_bd_ports spi_sdo_o]                [get_bd_pins axi_fmcomms6_spi/io0_o]
  connect_bd_net -net spi_sdi_i   [get_bd_ports spi_sdi_i]                [get_bd_pins axi_fmcomms6_spi/io1_i]

  connect_bd_net -net gpio_fmcomms6_i [get_bd_ports gpio_fmcomms6_i]    [get_bd_pins axi_fmcomms6_gpio/gpio_io_i]
  connect_bd_net -net gpio_fmcomms6_o [get_bd_ports gpio_fmcomms6_o]    [get_bd_pins axi_fmcomms6_gpio/gpio_io_o]
  connect_bd_net -net gpio_fmcomms6_t [get_bd_ports gpio_fmcomms6_t]    [get_bd_pins axi_fmcomms6_gpio/gpio_io_t]

  connect_bd_net -net axi_fmcomms6_spi_irq  [get_bd_pins axi_fmcomms6_spi/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In5]
  connect_bd_net -net axi_fmcomms6_gpio_irq [get_bd_pins axi_fmcomms6_gpio/ip2intc_irpt]  [get_bd_pins sys_concat_intc/In6]
}

# connections (adc)

p_sys_wfifo [current_bd_instance .] sys_wfifo 32 64

connect_bd_net -net adc_clk [get_bd_ports adc_clk] [get_bd_pins axi_ad9652/adc_clk] [get_bd_pins sys_wfifo/m_clk]
connect_bd_net -net sys_200m_clk [get_bd_pins sys_wfifo/s_clk] [get_bd_pins axi_ad9652_dma/fifo_wr_clk] [get_bd_pins axi_ad9652/delay_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins sys_wfifo/rstn] $sys_100m_resetn_source

connect_bd_net -net axi_ad9652_adc_clk_in_p     [get_bd_ports adc_clk_in_p]                       [get_bd_pins axi_ad9652/adc_clk_in_p]
connect_bd_net -net axi_ad9652_adc_clk_in_n     [get_bd_ports adc_clk_in_n]                       [get_bd_pins axi_ad9652/adc_clk_in_n]
connect_bd_net -net axi_ad9652_adc_or_in_p      [get_bd_ports adc_or_in_p]                        [get_bd_pins axi_ad9652/adc_or_in_p]
connect_bd_net -net axi_ad9652_adc_or_in_n      [get_bd_ports adc_or_in_n]                        [get_bd_pins axi_ad9652/adc_or_in_n]
connect_bd_net -net axi_ad9652_adc_data_in_p    [get_bd_ports adc_data_in_p]                      [get_bd_pins axi_ad9652/adc_data_in_p]
connect_bd_net -net axi_ad9652_adc_data_in_n    [get_bd_ports adc_data_in_n]                      [get_bd_pins axi_ad9652/adc_data_in_n]

connect_bd_net -net axi_ad9652_adc_valid_0      [get_bd_ports adc_valid_0]                        [get_bd_pins axi_ad9652/adc_valid_0]
connect_bd_net -net axi_ad9652_adc_enable_0     [get_bd_ports adc_enable_0]                       [get_bd_pins axi_ad9652/adc_enable_0]
connect_bd_net -net axi_ad9652_adc_data_0       [get_bd_ports adc_data_0]                         [get_bd_pins axi_ad9652/adc_data_0]
connect_bd_net -net axi_ad9652_adc_valid_1      [get_bd_ports adc_valid_1]                        [get_bd_pins axi_ad9652/adc_valid_1]
connect_bd_net -net axi_ad9652_adc_enable_1     [get_bd_ports adc_enable_1]                       [get_bd_pins axi_ad9652/adc_enable_1]
connect_bd_net -net axi_ad9652_adc_data_1       [get_bd_ports adc_data_1]                         [get_bd_pins axi_ad9652/adc_data_1]
connect_bd_net -net axi_ad9652_adc_dovf         [get_bd_pins axi_ad9652/adc_dovf]                 [get_bd_pins sys_wfifo/m_wovf]

connect_bd_net -net axi_ad9652_fifo_wr          [get_bd_ports adc_dma_wr]                         [get_bd_pins sys_wfifo/m_wr]
connect_bd_net -net axi_ad9652_fifo_wdata       [get_bd_ports adc_dma_wdata]                      [get_bd_pins sys_wfifo/m_wdata]

connect_bd_net -net axi_ad9652_dma_dwr          [get_bd_pins sys_wfifo/s_wr]                      [get_bd_pins axi_ad9652_dma/fifo_wr_en]
connect_bd_net -net axi_ad9652_dma_dsync        [get_bd_ports adc_dma_sync]                       [get_bd_pins axi_ad9652_dma/fifo_wr_sync]
connect_bd_net -net axi_ad9652_dma_ddata        [get_bd_pins sys_wfifo/s_wdata]                   [get_bd_pins axi_ad9652_dma/fifo_wr_din]
connect_bd_net -net axi_ad9652_dma_dovf         [get_bd_pins sys_wfifo/s_wovf]                    [get_bd_pins axi_ad9652_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9652_dma_irq          [get_bd_pins axi_ad9652_dma/irq]                  [get_bd_pins sys_concat_intc/In13]

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9652/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9652_dma/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9652/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9652_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma/s_axi_aresetn]

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_fmcomms6_spi/axi_lite]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_fmcomms6_gpio/s_axi]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms6_spi/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms6_gpio/s_axi_aclk]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_fmcomms6_spi/ext_spi_clk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcomms6_spi/s_axi_aresetn]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_fmcomms6_gpio/s_axi_aresetn]
}

# memory interconnects share the same clock (fclk2)

if {$sys_zynq == 1} {
  set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
  connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
}

# interconnect (mem/adc)

if {$sys_zynq == 0} {

  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9652_dma/m_dest_axi]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9652_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma/m_dest_axi_aresetn]

} else {

  connect_bd_intf_net -intf_net axi_ad9652_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9652_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9652_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_ad9652_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9652_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9652_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9652_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9652_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9652_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9652_dma/m_dest_axi_aresetn]
}

# ila (adc)

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

connect_bd_net -net sys_200m_clk [get_bd_pins ila_adc/clk]
connect_bd_net -net axi_ad9652_dma_dwr [get_bd_pins ila_adc/probe0]
connect_bd_net -net axi_ad9652_dma_ddata [get_bd_pins ila_adc/probe1]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x79020000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9652/s_axi/axi_lite]      SEG_data_ad9652
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9652_dma/s_axi/axi_lite]  SEG_data_ad9652_dma

if {$sys_zynq == 0} {
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms6_spi/axi_lite/Reg]  SEG_data_fmcomms6_spi
  create_bd_addr_seg -range 0x00010000 -offset 0x40030000 $sys_addr_cntrl_space [get_bd_addr_segs axi_fmcomms6_gpio/s_axi/Reg]    SEG_data_gpio_3
}

if {$sys_zynq == 0} {
  create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ad9652_dma/m_dest_axi]  [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl
} else {
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9652_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
}
