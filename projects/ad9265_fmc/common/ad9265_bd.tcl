
source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl

# ad9265

set adc_clk_in_p    [create_bd_port -dir I adc_clk_in_p]
set adc_clk_in_n    [create_bd_port -dir I adc_clk_in_n]
set adc_data_or_p   [create_bd_port -dir I adc_data_or_p]
set adc_data_or_n   [create_bd_port -dir I adc_data_or_n]
set adc_data_in_n   [create_bd_port -dir I -from 7 -to 0 adc_data_in_n]
set adc_data_in_p   [create_bd_port -dir I -from 7 -to 0 adc_data_in_p]

set spi_csn_i       [create_bd_port -dir I spi_csn_i]
set spi_csn0        [create_bd_port -dir O spi_csn0]
set spi_csn1        [create_bd_port -dir O spi_csn1]
set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

# interrupts

set ad9265_spi       [create_bd_port -dir O ad9265_spi]
set ad9265_dma_irq   [create_bd_port -dir O ad9265_dma_irq]

# adc peripheral

set axi_ad9265  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9265:1.0 axi_ad9265]

set axi_ad9265_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9265_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $axi_ad9265_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9265_dma

if {$sys_zynq == 1} {
  set axi_ad9265_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9265_dma_interconnect]
  set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9265_dma_interconnect
}

# spi

if {$sys_zynq == 0} {
  set axi_ad9265_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_ad9265_spi]
  set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_ad9265_spi
  set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] $axi_ad9265_spi
  set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_ad9265_spi
} else {
  set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
}

# additions to default configuration

if {$sys_zynq == 0} {
  set_property -dict [list CONFIG.NUM_MI {10}] $axi_cpu_interconnect
} else {
  set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect
}

if {$sys_zynq == 0} {
  set_property -dict [list CONFIG.NUM_SI {9}] $axi_mem_interconnect
}

# clock for ila

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
  set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125.0}] $sys_ps7

  set_property LEFT 31 [get_bd_ports GPIO_I]
  set_property LEFT 31 [get_bd_ports GPIO_O]
  set_property LEFT 31 [get_bd_ports GPIO_T]

  set sys_ila_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]

  connect_bd_net -net sys_ila_clk $sys_ila_clk_source
} else {
  set ila_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 ila_clkgen]
  set_property -dict [list CONFIG.PRIM_IN_FREQ {200}] $ila_clkgen
  set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125}] $ila_clkgen
  set_property -dict [list CONFIG.USE_LOCKED {false}] $ila_clkgen
  set_property -dict [list CONFIG.USE_RESET {false}] $ila_clkgen

  connect_bd_net -net sys_200m_clk [get_bd_pins ila_clkgen/clk_in1]

  set sys_ila_clk_source [get_bd_pins ila_clkgen/clk_out1]
  connect_bd_net -net sys_ila_clk $sys_ila_clk_source
}

# connections (spi)

if {$sys_zynq == 0} {
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i]    [get_bd_pins axi_ad9265_spi/ss_i]
  connect_bd_net -net spi_csn_o   [get_bd_ports spi_csn_o]    [get_bd_pins axi_ad9265_spi/ss_o]
  connect_bd_net -net spi_sclk_i  [get_bd_ports spi_clk_i]    [get_bd_pins axi_ad9265_spi/sck_i]
  connect_bd_net -net spi_sclk_o  [get_bd_ports spi_clk_o]    [get_bd_pins axi_ad9265_spi/sck_o]
  connect_bd_net -net spi_mosi_i  [get_bd_ports spi_sdo_i]    [get_bd_pins axi_ad9265_spi/io0_i]
  connect_bd_net -net spi_mosi_o  [get_bd_ports spi_sdo_o]    [get_bd_pins axi_ad9265_spi/io0_o]
  connect_bd_net -net spi_miso_i  [get_bd_ports spi_sdi_i]    [get_bd_pins axi_ad9265_spi/io1_i]

} else {
  connect_bd_net -net spi_csn0    [get_bd_ports spi_csn0]  [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_csn1    [get_bd_ports spi_csn1]  [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net spi_csn_i   [get_bd_ports spi_csn_i] [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_sclk_i  [get_bd_ports spi_clk_i] [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_sclk_o  [get_bd_ports spi_clk_o] [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net spi_mosi_i  [get_bd_ports spi_sdo_i] [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_mosi_o  [get_bd_ports spi_sdo_o] [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_miso_i  [get_bd_ports spi_sdi_i] [get_bd_pins sys_ps7/SPI0_MISO_I]
}

# connections (ad9265)

connect_bd_net -net axi_ad9265_adc_clk_in_n     [get_bd_ports adc_clk_in_p]     [get_bd_pins axi_ad9265/adc_clk_in_p]
connect_bd_net -net axi_ad9265_adc_clk_in_p     [get_bd_ports adc_clk_in_n]     [get_bd_pins axi_ad9265/adc_clk_in_n]
connect_bd_net -net axi_ad9265_adc_data_in_n    [get_bd_ports adc_data_in_n]    [get_bd_pins axi_ad9265/adc_data_in_n]
connect_bd_net -net axi_ad9265_adc_data_in_p    [get_bd_ports adc_data_in_p]    [get_bd_pins axi_ad9265/adc_data_in_p]
connect_bd_net -net axi_ad9265_adc_data_or_p    [get_bd_ports adc_data_or_p]    [get_bd_pins axi_ad9265/adc_or_in_p]
connect_bd_net -net axi_ad9265_adc_data_or_n    [get_bd_ports adc_data_or_n]    [get_bd_pins axi_ad9265/adc_or_in_n]

set adc_125m_clk_source [get_bd_pins axi_ad9265/adc_clk]

connect_bd_net -net adc_125m_clk    [get_bd_pins axi_ad9265_dma/fifo_wr_clk] $adc_125m_clk_source
connect_bd_net -net sys_200m_clk    [get_bd_pins axi_ad9265/delay_clk]

connect_bd_net -net axi_ad9265_dma_valid       [get_bd_pins axi_ad9265/adc_valid] [get_bd_pins axi_ad9265_dma/fifo_wr_en]
connect_bd_net -net axi_ad9265_dma_data        [get_bd_pins axi_ad9265/adc_data]  [get_bd_pins axi_ad9265_dma/fifo_wr_din]
connect_bd_net -net axi_ad9265_dma_dovf        [get_bd_pins axi_ad9265/adc_dovf]  [get_bd_pins axi_ad9265_dma/fifo_wr_overflow]

connect_bd_net -net axi_ad9265_dma_irq          [get_bd_pins axi_ad9265_dma/irq]  [get_bd_ports ad9265_dma_irq]

# interconnect (cpu)

connect_bd_net -net sys_100m_clk    [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk    [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source

connect_bd_net -net sys_100m_clk    [get_bd_pins axi_ad9265/s_axi_aclk]
connect_bd_net -net sys_100m_clk    [get_bd_pins axi_ad9265_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9265/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9265_dma/s_axi_aresetn]

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07 [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9265_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08 [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9265/s_axi]

if {$sys_zynq == 0} {
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9265_spi/axi_lite]

  connect_bd_net -net sys_100m_clk      [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
  connect_bd_net -net sys_100m_clk      [get_bd_pins axi_ad9265_spi/s_axi_aclk]
  connect_bd_net -net sys_100m_clk      [get_bd_pins axi_ad9265_spi/ext_spi_clk]
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad9265_spi/s_axi_aresetn]

  connect_bd_net -net axi_ad9265_spi_irq [get_bd_pins axi_ad9265_spi/ip2intc_irpt] [get_bd_ports ad9265_spi]
}

# interconnect (mem/adc)

if {$sys_zynq == 0} {
  connect_bd_intf_net -intf_net axi_mem_interconnect_s08_axi [get_bd_intf_pins axi_mem_interconnect/S08_AXI] [get_bd_intf_pins axi_ad9265_dma/m_dest_axi]
  connect_bd_net -net sys_200m_clk    [get_bd_pins axi_mem_interconnect/S08_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk    [get_bd_pins axi_ad9265_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/S08_ARESETN] $sys_200m_resetn_source
  connect_bd_net -net sys_200m_resetn [get_bd_pins axi_ad9265_dma/m_dest_axi_aresetn]
} else {
  connect_bd_intf_net -intf_net axi_ad9265_dma_interconnect_s0 [get_bd_intf_pins axi_ad9265_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9265_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_ad9265_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9265_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]

  connect_bd_net -net sys_200m_clk  [get_bd_pins axi_ad9265_dma_interconnect/S00_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk  [get_bd_pins axi_ad9265_dma/m_dest_axi_aclk]
  connect_bd_net -net sys_200m_clk  [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
  connect_bd_net -net sys_200m_clk  [get_bd_pins axi_ad9265_dma_interconnect/ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_200m_clk  [get_bd_pins axi_ad9265_dma_interconnect/M00_ACLK] $sys_200m_clk_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad9265_dma_interconnect/ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad9265_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad9265_dma/m_dest_axi_aresetn]
  connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad9265_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
}

# ila (with fifo to prevent timing failure)

p_sys_wfifo [current_bd_instance .] ila_wfifo 16 32

connect_bd_net -net adc_125m_clk    [get_bd_pins ila_wfifo/m_clk] $adc_125m_clk_source
connect_bd_net -net sys_ila_clk     [get_bd_pins ila_wfifo/s_clk] $sys_ila_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins ila_wfifo/rstn] $sys_100m_resetn_source

set ila_ad9265_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_ad9265_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {32}] $ila_ad9265_mon
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_ad9265_mon

connect_bd_net -net axi_ad9265_dma_valid  [get_bd_pins ila_wfifo/m_wr] [get_bd_pins axi_ad9265/adc_valid]
connect_bd_net -net axi_ad9265_dma_data   [get_bd_pins ila_wfifo/m_wdata] [get_bd_pins axi_ad9265/adc_data]
connect_bd_net -net axi_ad9265_adc_dovf   [get_bd_pins ila_wfifo/m_wovf] [get_bd_pins axi_ad9265/adc_dunf]
connect_bd_net -net ila_fifo_wr [get_bd_pins ila_wfifo/s_wr] [get_bd_pins ila_ad9265_mon/PROBE0]
connect_bd_net -net ila_fifo_wdata [get_bd_pins ila_wfifo/s_wdata] [get_bd_pins ila_ad9265_mon/PROBE1]
connect_bd_net -net sys_ila_clk  [get_bd_pins ila_ad9265_mon/clk] $sys_ila_clk_source

# address mapping

create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9265/s_axi/axi_lite]      SEG_data_ad9265_core
create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9265_dma/s_axi/axi_lite]  SEG_data_ad9265_dma

if {$sys_zynq == 0} {
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9265_spi/axi_lite/Reg]    SEG_data_ad9265_spi
}

if {$sys_zynq == 0} {
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9265_dma/m_dest_axi]    [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl
} else {
  create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9265_dma/m_dest_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
}
