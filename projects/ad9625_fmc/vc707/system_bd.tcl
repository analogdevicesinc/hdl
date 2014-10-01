
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl
source ../common/ad9625_fmc_bd.tcl

set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9625_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9625_dma

p_sys_dmafifo [current_bd_instance .] sys_dmafifo 256

delete_bd_objs [get_bd_nets axi_ad9625_adc_clk]
delete_bd_objs [get_bd_nets axi_ad9625_adc_enable]
delete_bd_objs [get_bd_nets axi_ad9625_adc_data]
delete_bd_objs [get_bd_nets axi_ad9625_adc_dovf]
delete_bd_objs [get_bd_nets axi_ad9625_adc_valid]

connect_bd_net -net sys_200m_clk [get_bd_pins sys_dmafifo/axi_clk] $sys_200m_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins sys_dmafifo/dma_clk] $sys_200m_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9625_dma/fifo_wr_clk] $sys_200m_clk_source

connect_bd_net -net [get_bd_nets axi_ad9625_gt_rx_rst] [get_bd_pins sys_dmafifo/adc_rst]  [get_bd_pins axi_ad9625_gt/rx_rst]
connect_bd_net -net [get_bd_nets sys_200m_resetn] [get_bd_pins sys_dmafifo/dma_rstn] $sys_200m_resetn_source
connect_bd_net -net axi_ad9625_dma_xfer_req [get_bd_pins axi_ad9625_dma/fifo_wr_xfer_req] [get_bd_pins sys_dmafifo/axi_xfer_req]

connect_bd_net -net axi_ad9625_adc_clk      [get_bd_pins axi_ad9625_core/adc_clk]     [get_bd_pins sys_dmafifo/adc_clk]
connect_bd_net -net axi_ad9625_adc_enable   [get_bd_pins axi_ad9625_core/adc_enable]  [get_bd_pins sys_dmafifo/adc_wr]
connect_bd_net -net axi_ad9625_adc_data     [get_bd_pins axi_ad9625_core/adc_data]    [get_bd_pins sys_dmafifo/adc_wdata]
connect_bd_net -net axi_ad9625_adc_dovf     [get_bd_pins axi_ad9625_core/adc_dovf]    [get_bd_pins sys_dmafifo/adc_wovf]

connect_bd_net -net axi_ad9625_dma_dwr      [get_bd_pins sys_dmafifo/dma_wr]          [get_bd_pins axi_ad9625_dma/fifo_wr_en]
connect_bd_net -net axi_ad9625_dma_ddata    [get_bd_pins sys_dmafifo/dma_wdata]       [get_bd_pins axi_ad9625_dma/fifo_wr_din]
connect_bd_net -net axi_ad9625_dma_dovf     [get_bd_pins sys_dmafifo/dma_wovf]        [get_bd_pins axi_ad9625_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9625_adc_valid    [get_bd_pins axi_ad9625_core/adc_valid]   [get_bd_pins axi_ad9625_dma/fifo_wr_sync]

connect_bd_net -net axi_ad9625_adc_data     [get_bd_pins ila_jesd_rx_mon/PROBE3]

set ila_dma_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_dma_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_dma_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH {64}] $ila_dma_mon
set_property -dict [list CONFIG.C_PROBE3_WIDTH {5}] $ila_dma_mon

connect_bd_net -net sys_200m_clk            [get_bd_pins ila_dma_mon/clk]
connect_bd_net -net axi_ad9625_dma_dwr      [get_bd_pins ila_dma_mon/probe0]
connect_bd_net -net axi_ad9625_dma_xfer_req [get_bd_pins ila_dma_mon/probe1]
connect_bd_net -net axi_ad9625_dma_ddata    [get_bd_pins ila_dma_mon/probe2]
connect_bd_net -net axi_xfer_status         [get_bd_pins ila_dma_mon/probe3]  [get_bd_pins sys_dmafifo/axi_xfer_status]

create_bd_addr_seg -range 0x00200000 -offset 0xc0000000 [get_bd_addr_spaces sys_dmafifo/axi_fifo2s/axi] [get_bd_addr_segs sys_dmafifo/axi_bram_ctl/S_AXI/Mem0] SEG_axi_bram_ctl_mem

