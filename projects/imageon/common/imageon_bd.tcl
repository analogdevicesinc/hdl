
# define additional ports

create_bd_port -dir I spdif_rx

# adv7511 (reconfigure base design)

set_property CONFIG.EMBEDDED_SYNC {1} [get_bd_cells axi_hdmi_core]

create_bd_port -dir O -from 15 -to 0 hdmi_es_data
ad_connect  hdmi_es_data axi_hdmi_core/hdmi_16_es_data

# adv7611

create_bd_port -dir I hdmi_rx_clk
create_bd_port -dir I -from 15 -to 0 hdmi_rx_data

# iic interface

set axi_iic_imageon [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_imageon]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_iic_imageon
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_imageon

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_imageon
ad_connect  iic_imageon axi_iic_imageon/iic
ad_cpu_interconnect  0x43C40000  axi_iic_imageon
ad_cpu_interrupt ps-11 mb-11 axi_iic_imageon/iic2intc_irpt

# hdmi peripherals

set axi_hdmi_rx_core  [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_rx:1.0 axi_hdmi_rx_core]

set axi_hdmi_rx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_hdmi_rx_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {1}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {1}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {14}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_hdmi_rx_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_hdmi_rx_dma

ad_connect  hdmi_rx_clk axi_hdmi_rx_core/hdmi_rx_clk
ad_connect  hdmi_rx_data axi_hdmi_rx_core/hdmi_rx_data
ad_connect  hdmi_clk axi_hdmi_rx_core/hdmi_clk
ad_connect  hdmi_clk axi_hdmi_rx_dma/fifo_wr_clk
ad_connect  axi_hdmi_rx_core/hdmi_dma_sof axi_hdmi_rx_dma/fifo_wr_sync
ad_connect  axi_hdmi_rx_core/hdmi_dma_de axi_hdmi_rx_dma/fifo_wr_en
ad_connect  axi_hdmi_rx_core/hdmi_dma_data axi_hdmi_rx_dma/fifo_wr_din
ad_connect  axi_hdmi_rx_core/hdmi_dma_ovf axi_hdmi_rx_dma/fifo_wr_overflow

set axi_spdif_rx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_rx:1.0 axi_spdif_rx_core]
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_rx_core
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_spdif_rx_core

set_property -dict [list CONFIG.PCW_USE_DMA3 {1}] $sys_ps7

ad_connect  sys_cpu_clk axi_spdif_rx_core/DMA_REQ_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA3_ACLK
ad_connect  sys_cpu_resetn axi_spdif_rx_core/DMA_REQ_RSTN
ad_connect  sys_ps7/DMA3_REQ axi_spdif_rx_core/DMA_REQ
ad_connect  sys_ps7/DMA3_ACK axi_spdif_rx_core/DMA_ACK
ad_connect  spdif_rx axi_spdif_rx_core/spdif_rx_i

ad_cpu_interconnect 0x43100000 axi_hdmi_rx_core
ad_cpu_interconnect 0x43C20000 axi_hdmi_rx_dma
ad_cpu_interconnect 0x75C20000 axi_spdif_rx_core

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_hdmi_rx_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_hdmi_rx_dma/m_dest_axi_aresetn

ad_cpu_interrupt ps-12 mb-12 axi_hdmi_rx_dma/irq

# debug

set ila_fifo_dma_rx [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_fifo_dma_rx]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_DATA_DEPTH {4096}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_PROBE2_WIDTH {64}] $ila_fifo_dma_rx
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_fifo_dma_rx

ad_connect  hdmi_rx_clk ila_fifo_dma_rx/clk

ad_connect  ila_fifo_dma_rx/probe0 axi_hdmi_rx_dma/fifo_wr_sync
ad_connect  ila_fifo_dma_rx/probe1 axi_hdmi_rx_dma/fifo_wr_en
ad_connect  ila_fifo_dma_rx/probe2 axi_hdmi_rx_dma/fifo_wr_din
ad_connect  ila_fifo_dma_rx/probe3 axi_hdmi_rx_dma/fifo_wr_overflow

