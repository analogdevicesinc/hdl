
# create board design
# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 eth1_mdio
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth1_rgmii

create_bd_port -dir I -type intr eth1_intn

# hdmi interface

create_bd_port -dir O hdmi_out_clk
create_bd_port -dir O hdmi_hsync
create_bd_port -dir O hdmi_vsync
create_bd_port -dir O hdmi_data_e
create_bd_port -dir O -from 15 -to 0 hdmi_data

# i2s

create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

# spdif audio

create_bd_port -dir O spdif

## ps7 modifications

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_DMA0  1
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_DMA1  1
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_DMA2  1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1

# ethernet-1

ad_ip_instance gmii_to_rgmii sys_rgmii
ad_ip_parameter sys_rgmii CONFIG.SupportLevel Include_Shared_Logic_in_Core

ad_ip_instance proc_sys_reset sys_rgmii_rstgen
ad_ip_parameter sys_rgmii_rstgen CONFIG.C_EXT_RST_WIDTH 1

# hdmi peripherals

ad_ip_instance axi_clkgen axi_hdmi_clkgen
ad_ip_instance axi_hdmi_tx axi_hdmi_core
ad_ip_parameter axi_hdmi_core CONFIG.OUT_CLK_POLARITY 1
ad_ip_parameter axi_hdmi_core CONFIG.INTERFACE 16_BIT

ad_ip_instance axi_dmac axi_hdmi_dma
ad_ip_parameter axi_hdmi_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_hdmi_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_hdmi_dma CONFIG.CYCLIC true
ad_ip_parameter axi_hdmi_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_hdmi_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_hdmi_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_hdmi_dma CONFIG.DMA_2D_TRANSFER true
ad_ip_parameter axi_hdmi_dma CONFIG.DMA_DATA_WIDTH_SRC 64

# audio peripherals

ad_ip_instance clk_wiz sys_audio_clkgen
ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 12.288
ad_ip_parameter sys_audio_clkgen CONFIG.USE_LOCKED false
ad_ip_parameter sys_audio_clkgen CONFIG.USE_RESET true
ad_ip_parameter sys_audio_clkgen CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter sys_audio_clkgen CONFIG.USE_PHASE_ALIGNMENT false
ad_ip_parameter sys_audio_clkgen CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance axi_spdif_tx axi_spdif_tx_core
ad_ip_parameter axi_spdif_tx_core CONFIG.DMA_TYPE 1
ad_ip_parameter axi_spdif_tx_core CONFIG.S_AXI_ADDRESS_WIDTH 16

ad_ip_instance axi_i2s_adi axi_i2s_adi
ad_ip_parameter axi_i2s_adi CONFIG.DMA_TYPE 1
ad_ip_parameter axi_i2s_adi CONFIG.S_AXI_ADDRESS_WIDTH 16

# system reset/clock definitions

ad_connect  sys_200m_clk axi_hdmi_clkgen/clk
ad_connect  sys_ps7/MDIO_ETHERNET_1 sys_rgmii/MDIO_GEM
ad_connect  sys_ps7/GMII_ETHERNET_1 sys_rgmii/GMII
ad_connect  sys_rgmii/MDIO_PHY eth1_mdio
ad_connect  sys_rgmii/RGMII eth1_rgmii
ad_connect  sys_ps7/ENET1_EXT_INTIN eth1_intn
ad_connect  sys_200m_clk sys_rgmii_rstgen/slowest_sync_clk
ad_connect  sys_200m_clk sys_rgmii/clkin
ad_connect  sys_rgmii_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N
ad_connect  sys_rgmii_rstgen/peripheral_reset sys_rgmii/tx_reset
ad_connect  sys_rgmii_rstgen/peripheral_reset sys_rgmii/rx_reset

# hdmi

ad_connect  sys_cpu_clk axi_hdmi_core/vdma_clk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_data

ad_connect  axi_hdmi_dma/m_axis axi_hdmi_core/s_axis
ad_connect  sys_cpu_resetn axi_hdmi_dma/s_axi_aresetn
ad_connect  sys_cpu_resetn axi_hdmi_dma/m_src_axi_aresetn
ad_connect  sys_cpu_clk axi_hdmi_dma/s_axi_aclk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_src_axi_aclk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_aclk

# spdif audio

ad_connect  sys_cpu_clk axi_spdif_tx_core/DMA_REQ_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA0_ACLK
ad_connect  sys_cpu_resetn axi_spdif_tx_core/DMA_REQ_RSTN
ad_connect  sys_ps7/DMA0_REQ axi_spdif_tx_core/DMA_REQ
ad_connect  sys_ps7/DMA0_ACK axi_spdif_tx_core/DMA_ACK
ad_connect  sys_200m_clk sys_audio_clkgen/clk_in1
ad_connect  sys_cpu_resetn sys_audio_clkgen/resetn
ad_connect  sys_audio_clkgen/clk_out1 axi_spdif_tx_core/spdif_data_clk
ad_connect  spdif axi_spdif_tx_core/spdif_tx_o

# i2s audio

ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_RX_ACLK
ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_TX_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA1_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA2_ACLK
ad_connect  sys_cpu_resetn axi_i2s_adi/DMA_REQ_RX_RSTN
ad_connect  sys_cpu_resetn axi_i2s_adi/DMA_REQ_TX_RSTN
ad_connect  sys_ps7/DMA1_REQ axi_i2s_adi/DMA_REQ_TX
ad_connect  sys_ps7/DMA1_ACK axi_i2s_adi/DMA_ACK_TX
ad_connect  sys_ps7/DMA2_REQ axi_i2s_adi/DMA_REQ_RX
ad_connect  sys_ps7/DMA2_ACK axi_i2s_adi/DMA_ACK_RX
ad_connect  sys_audio_clkgen/clk_out1 i2s_mclk
ad_connect  sys_audio_clkgen/clk_out1 axi_i2s_adi/DATA_CLK_I
ad_connect  i2s axi_i2s_adi/I2S

# interrupts

ad_cpu_interrupt ps-15 mb-15 axi_hdmi_dma/irq

# interconnects

ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_cpu_interconnect 0x77600000 axi_i2s_adi
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/m_src_axi

# un-used io (gt)

ad_ip_instance axi_xcvrlb axi_pz_xcvrlb
ad_ip_parameter axi_pz_xcvrlb CONFIG.NUM_OF_LANES 2

create_bd_port -dir I gt_ref_clk_0
create_bd_port -dir I -from 1 -to 0 gt_rx_p
create_bd_port -dir I -from 1 -to 0 gt_rx_n
create_bd_port -dir O -from 1 -to 0 gt_tx_p
create_bd_port -dir O -from 1 -to 0 gt_tx_n

ad_cpu_interconnect 0x44A60000 axi_pz_xcvrlb
ad_connect  axi_pz_xcvrlb/ref_clk gt_ref_clk_0
ad_connect  axi_pz_xcvrlb/rx_p gt_rx_p
ad_connect  axi_pz_xcvrlb/rx_n gt_rx_n
ad_connect  axi_pz_xcvrlb/tx_p gt_tx_p
ad_connect  axi_pz_xcvrlb/tx_n gt_tx_n

# un-used io (regular)

ad_ip_instance axi_gpreg axi_gpreg
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_CLK_MONS 3
ad_ip_parameter axi_gpreg CONFIG.NUM_OF_IO 2
ad_ip_parameter axi_gpreg CONFIG.BUF_ENABLE_0 1
ad_ip_parameter axi_gpreg CONFIG.BUF_ENABLE_1 1
ad_ip_parameter axi_gpreg CONFIG.BUF_ENABLE_2 1

create_bd_port -dir I -from 31 -to 0 gp_in_0
create_bd_port -dir I -from 31 -to 0 gp_in_1
create_bd_port -dir O -from 31 -to 0 gp_out_0
create_bd_port -dir O -from 31 -to 0 gp_out_1
create_bd_port -dir I clk_0
create_bd_port -dir I clk_1
create_bd_port -dir I gt_ref_clk_1

ad_connect  clk_0 axi_gpreg/d_clk_0
ad_connect  clk_1 axi_gpreg/d_clk_1
ad_connect  gt_ref_clk_1 axi_gpreg/d_clk_2
ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
ad_connect  gp_in_1 axi_gpreg/up_gp_in_1
ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
ad_connect  gp_out_1 axi_gpreg/up_gp_out_1
ad_cpu_interconnect 0x41200000 axi_gpreg

## temporary (remove ila indirectly)

delete_bd_objs [get_bd_cells ila_adc]

