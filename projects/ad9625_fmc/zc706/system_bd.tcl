
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_plddr3.tcl
source ../common/ad9625_fmc_bd.tcl

set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9625_dma

p_plddr3_fifo [current_bd_instance .] plddr3_fifo 256

set DDR3    [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3]
set sys_clk [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk]

connect_bd_intf_net -intf_net DDR3    [get_bd_intf_ports DDR3]    [get_bd_intf_pins plddr3_fifo/DDR3]
connect_bd_intf_net -intf_net sys_clk [get_bd_intf_ports sys_clk] [get_bd_intf_pins plddr3_fifo/sys_clk]

delete_bd_objs [get_bd_nets axi_ad9625_adc_clk]
delete_bd_objs [get_bd_nets axi_ad9625_adc_dwr]
delete_bd_objs [get_bd_nets axi_ad9625_adc_ddata]
delete_bd_objs [get_bd_nets axi_ad9625_adc_dovf]
delete_bd_objs [get_bd_nets axi_ad9625_adc_dsync]

connect_bd_net -net [get_bd_nets axi_ad9625_gt_rx_rst] [get_bd_pins plddr3_fifo/adc_rst]  [get_bd_pins axi_ad9625_gt/rx_rst]
connect_bd_net -net [get_bd_nets sys_fmc_dma_resetn]   [get_bd_pins plddr3_fifo/dma_rstn] [get_bd_pins sys_ps7/FCLK_RESET2_N]

connect_bd_net -net axi_ad9625_adc_clk      [get_bd_pins axi_ad9625_core/adc_clk]     [get_bd_pins plddr3_fifo/adc_clk]
connect_bd_net -net axi_ad9625_adc_dwr      [get_bd_pins axi_ad9625_core/adc_dwr]     [get_bd_pins plddr3_fifo/adc_wr]
connect_bd_net -net axi_ad9625_adc_ddata    [get_bd_pins axi_ad9625_core/adc_ddata]   [get_bd_pins plddr3_fifo/adc_wdata]
connect_bd_net -net axi_ad9625_adc_dovf     [get_bd_pins axi_ad9625_core/adc_dovf]    [get_bd_pins plddr3_fifo/adc_wovf]
connect_bd_net -net axi_ad9625_adc_enable   [get_bd_pins axi_ad9625_core/adc_enable]  [get_bd_pins plddr3_fifo/axi_xfer_req]
connect_bd_net -net axi_ad9625_dma_clk      [get_bd_pins plddr3_fifo/dma_clk]         [get_bd_pins axi_ad9625_dma/fifo_wr_clk]
connect_bd_net -net axi_ad9625_dma_dwr      [get_bd_pins plddr3_fifo/dma_wr]          [get_bd_pins axi_ad9625_dma/fifo_wr_en]       
connect_bd_net -net axi_ad9625_dma_ddata    [get_bd_pins plddr3_fifo/dma_wdata]       [get_bd_pins axi_ad9625_dma/fifo_wr_din]      
connect_bd_net -net axi_ad9625_dma_dovf     [get_bd_pins plddr3_fifo/dma_wovf]        [get_bd_pins axi_ad9625_dma/fifo_wr_overflow] 
connect_bd_net -net axi_ad9625_adc_dsync    [get_bd_pins axi_ad9625_core/adc_dsync]   [get_bd_pins axi_ad9625_dma/fifo_wr_sync]

connect_bd_net -net axi_ad9625_adc_ddata    [get_bd_pins ila_jesd_rx_mon/PROBE3]

set ila_dma_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_dma_mon]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {3}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH {64}] $ila_dma_mon

connect_bd_net -net axi_ad9625_dma_clk      [get_bd_pins ila_dma_mon/clk] 
connect_bd_net -net axi_ad9625_dma_dwr      [get_bd_pins ila_dma_mon/probe0] 
connect_bd_net -net axi_ad9625_adc_enable   [get_bd_pins ila_dma_mon/probe1] 
connect_bd_net -net axi_ad9625_dma_ddata    [get_bd_pins ila_dma_mon/probe2] 

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces plddr3_fifo/axi_fifo2s/axi] [get_bd_addr_segs plddr3_fifo/axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl_memaddr

