
# adv7511 (reconfigure base design)

delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports hdmi_out_clk]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports hdmi_vsync]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports hdmi_hsync]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports hdmi_data_e]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports hdmi_data]]]

delete_bd_objs [get_bd_ports hdmi_out_clk]
delete_bd_objs [get_bd_ports hdmi_vsync]
delete_bd_objs [get_bd_ports hdmi_hsync]
delete_bd_objs [get_bd_ports hdmi_data_e]
delete_bd_objs [get_bd_ports hdmi_data]

ad_ip_parameter axi_hdmi_core CONFIG.INTERFACE 16_BIT_EMBEDDED_SYNC
ad_ip_parameter axi_hdmi_core CONFIG.OUT_CLK_POLARITY 1

create_bd_port -dir O hdmi_tx_clk
create_bd_port -dir O -from 15 -to 0 hdmi_tx_data

ad_connect  hdmi_tx_clk axi_hdmi_core/hdmi_out_clk
ad_connect  hdmi_tx_data axi_hdmi_core/hdmi_16_es_data

# adv7611

ad_ip_instance axi_hdmi_rx axi_hdmi_rx_core

ad_ip_instance axi_dmac axi_hdmi_rx_dma
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_hdmi_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_hdmi_rx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_hdmi_rx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_2D_TRANSFER 1
ad_ip_parameter axi_hdmi_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_LENGTH_WIDTH 14
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_hdmi_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_hdmi_rx_dma CONFIG.FIFO_SIZE 16

create_bd_port -dir I hdmi_rx_clk
create_bd_port -dir I -from 15 -to 0 hdmi_rx_data

ad_connect  hdmi_rx_clk axi_hdmi_rx_core/hdmi_rx_clk
ad_connect  hdmi_rx_data axi_hdmi_rx_core/hdmi_rx_data

ad_connect  axi_hdmi_rx_core/hdmi_clk axi_hdmi_rx_dma/fifo_wr_clk
ad_connect  axi_hdmi_rx_core/hdmi_dma_sof axi_hdmi_rx_dma/fifo_wr_sync
ad_connect  axi_hdmi_rx_core/hdmi_dma_de axi_hdmi_rx_dma/fifo_wr_en
ad_connect  axi_hdmi_rx_core/hdmi_dma_data axi_hdmi_rx_dma/fifo_wr_din
ad_connect  axi_hdmi_rx_core/hdmi_dma_ovf axi_hdmi_rx_dma/fifo_wr_overflow
ad_connect  axi_hdmi_rx_core/hdmi_dma_unf GND
ad_connect  $sys_cpu_resetn axi_hdmi_rx_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x43100000 axi_hdmi_rx_core
ad_cpu_interconnect 0x43C20000 axi_hdmi_rx_dma

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_hdmi_rx_dma/m_dest_axi

ad_cpu_interrupt ps-12 mb-12 axi_hdmi_rx_dma/irq

# spdif tx

delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_ports spdif]]]
delete_bd_objs [get_bd_ports spdif]

create_bd_port -dir O spdif_tx
ad_connect  spdif_tx axi_spdif_tx_core/spdif_tx_o

# spdif rx

create_bd_port -dir I spdif_rx

ad_ip_instance axi_spdif_rx axi_spdif_rx_core
ad_ip_parameter axi_spdif_rx_core CONFIG.C_S_AXI_ADDR_WIDTH 16
ad_ip_parameter axi_spdif_rx_core CONFIG.C_DMA_TYPE 1

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_DMA3 1

ad_connect  $sys_cpu_clk axi_spdif_rx_core/DMA_REQ_ACLK
ad_connect  $sys_cpu_clk sys_ps7/DMA3_ACLK
ad_connect  $sys_cpu_resetn axi_spdif_rx_core/DMA_REQ_RSTN
ad_connect  sys_ps7/DMA3_REQ axi_spdif_rx_core/DMA_REQ
ad_connect  sys_ps7/DMA3_ACK axi_spdif_rx_core/DMA_ACK
ad_connect  spdif_rx axi_spdif_rx_core/spdif_rx_i

ad_cpu_interconnect 0x75C20000 axi_spdif_rx_core

# iic interface

ad_ip_instance axi_iic axi_iic_imageon
ad_ip_parameter axi_iic_imageon CONFIG.USE_BOARD_FLOW true
ad_ip_parameter axi_iic_imageon CONFIG.IIC_BOARD_INTERFACE Custom

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_imageon
ad_connect  iic_imageon axi_iic_imageon/iic
ad_cpu_interconnect  0x43C40000  axi_iic_imageon
ad_cpu_interrupt ps-11 mb-11 axi_iic_imageon/iic2intc_irpt

