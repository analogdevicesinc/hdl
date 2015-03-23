
# adv7511

create_bd_port -dir I  fmc_hdmi_rx_clk
create_bd_port -dir I  -from 15 -to 0 fmc_hdmi_rx_data

# adv7611

create_bd_port -dir O  fmc_hdmi_tx_clk
create_bd_port -dir O  fmc_hdmi_tx_spdif
create_bd_port -dir O -from 15 -to 0 fmc_hdmi_tx_data

# iic interface

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_fmc

# fmc hdmi peripherals

set fmc_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 fmc_hdmi_clkgen]

set fmc_hdmi_tx_core  [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 fmc_hdmi_tx_core]
set_property -dict [list CONFIG.PCORE_EMBEDDED_SYNC {1}] $fmc_hdmi_tx_core

set fmc_hdmi_rx_core  [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_rx:1.0 fmc_hdmi_rx_core]

set fmc_hdmi_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 fmc_hdmi_tx_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $fmc_hdmi_tx_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $fmc_hdmi_tx_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $fmc_hdmi_tx_dma

set fmc_hdmi_rx_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 fmc_hdmi_rx_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {1}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {1}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {14}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $fmc_hdmi_rx_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $fmc_hdmi_rx_dma

set fmc_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 fmc_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $fmc_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $fmc_spdif_tx_core

set axi_iic_fmc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_iic_fmc
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_fmc

# additional setups

set_property -dict [list CONFIG.PCW_USE_DMA1 {1}] $sys_ps7

# fmc hdmi tx connections

ad_connect  sys_cpu_clk                             fmc_hdmi_tx_core/m_axis_mm2s_clk
ad_connect  sys_cpu_clk                             fmc_hdmi_tx_dma/m_axis_mm2s_aclk
ad_connect  sys_cpu_clk                             fmc_hdmi_clkgen/drp_clk
ad_connect  sys_200m_clk                            fmc_hdmi_clkgen/clk
ad_connect  fmc_hdmi_tx_core/hdmi_clk               fmc_hdmi_clkgen/clk_0
ad_connect  fmc_hdmi_tx_clk                         fmc_hdmi_tx_core/hdmi_out_clk

ad_connect  fmc_hdmi_tx_data                        fmc_hdmi_tx_core/hdmi_16_es_data
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_tvalid     fmc_hdmi_tx_dma/m_axis_mm2s_tvalid
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_tdata      fmc_hdmi_tx_dma/m_axis_mm2s_tdata
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_tkeep      fmc_hdmi_tx_dma/m_axis_mm2s_tkeep
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_tlast      fmc_hdmi_tx_dma/m_axis_mm2s_tlast
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_tready     fmc_hdmi_tx_dma/m_axis_mm2s_tready
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_fsync      fmc_hdmi_tx_dma/mm2s_fsync
ad_connect  fmc_hdmi_tx_core/m_axis_mm2s_fsync_ret  fmc_hdmi_tx_dma/mm2s_fsync

# fmc hdmi rx connections

ad_connect  fmc_hdmi_rx_core/dma_data   fmc_hdmi_rx_dma/fifo_wr_din
ad_connect  fmc_hdmi_rx_core/dma_valid  fmc_hdmi_rx_dma/fifo_wr_en
ad_connect  fmc_hdmi_rx_core/dma_clk    fmc_hdmi_rx_dma/fifo_wr_clk
ad_connect  fmc_hdmi_rx_core/dma_sync   fmc_hdmi_rx_dma/fifo_wr_sync
ad_connect  fmc_hdmi_rx_core/dma_ovf    fmc_hdmi_rx_dma/fifo_wr_overflow

ad_connect  fmc_hdmi_rx_clk   fmc_hdmi_rx_core/hdmi_clk
ad_connect  fmc_hdmi_rx_data  fmc_hdmi_rx_core/hdmi_data

# fmc spdif audio

ad_connect  sys_ps7/DMA1_REQ  fmc_spdif_tx_core/DMA_REQ
ad_connect  sys_ps7/DMA1_ACK  fmc_spdif_tx_core/DMA_ACK
ad_connect  sys_cpu_clk fmc_spdif_tx_core/DMA_REQ_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA1_ACLK

ad_connect  sys_cpu_resetn fmc_spdif_tx_core/DMA_REQ_RSTN

ad_connect  sys_audio_clkgen/clk_out1 fmc_spdif_tx_core/spdif_data_clk
ad_connect  fmc_hdmi_tx_spdif fmc_spdif_tx_core/spdif_tx_o

# fmc iic connections

ad_connect  iic_fmc axi_iic_fmc/iic
ad_connect  sys_cpu_clk    axi_iic_fmc/s_axi_aclk
ad_connect  sys_cpu_resetn axi_iic_fmc/s_axi_aresetn

# processor interconnect

ad_cpu_interconnect   0x43C00000  fmc_hdmi_tx_core
ad_cpu_interconnect   0x43100000  fmc_hdmi_rx_core
ad_cpu_interconnect   0x43010000  fmc_hdmi_tx_dma
ad_cpu_interconnect   0x43C20000  fmc_hdmi_rx_dma
ad_cpu_interconnect   0x43C30000  fmc_spdif_tx_core
ad_cpu_interconnect   0x43C40000  axi_iic_fmc
ad_cpu_interconnect   0x43C50000  fmc_hdmi_clkgen

# memory interconnect

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk fmc_hdmi_tx_dma/M_AXI_MM2S

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk fmc_hdmi_rx_dma/m_dest_axi

# fmc hdmi interrupts

connect_bd_net -net fmc_hdmi_tx_interrupt   [get_bd_pins fmc_hdmi_tx_dma/mm2s_introut]  [get_bd_ports fmc_hdmi_tx_dma_intr]
connect_bd_net -net fmc_hdmi_rx_interrupt   [get_bd_pins fmc_hdmi_rx_dma/irq]           [get_bd_ports fmc_hdmi_rx_dma_intr]
connect_bd_net -net fmc_hdmi_iic_interrupt  [get_bd_pins axi_iic_fmc/iic2intc_irpt]     [get_bd_ports fmc_hdmi_iic_intr]

ad_cpu_interrupt ps-11 mb-14   axi_iic_fmc/iic2intc_irpt
ad_cpu_interrupt ps-12 mb-13   fmc_hdmi_rx_dma/irq
ad_cpu_interrupt ps-13 mb-12   fmc_hdmi_tx_dma/mm2s_introut

