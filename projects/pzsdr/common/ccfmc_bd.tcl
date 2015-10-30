
# create board design
# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 eth1_mdio
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 eth1_rgmii

create_bd_port -dir O eth1_link_status
create_bd_port -dir O eth1_duplex_status
create_bd_port -dir O -type clk eth1_refclk
create_bd_port -dir O -type clk eth1_125mclk
create_bd_port -dir O -type clk eth1_25mclk
create_bd_port -dir O -type clk eth1_2m5clk
create_bd_port -dir I -type intr eth1_intn
create_bd_port -dir O -from 1 -to 0 eth1_clock_speed
create_bd_port -dir O -from 1 -to 0 eth1_speed_mode

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

set_property -dict [list CONFIG.PCW_USE_DMA0 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA2 {1}] $sys_ps7

# ethernet-1

set sys_rgmii [create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.0 sys_rgmii]
set_property -dict [list CONFIG.SupportLevel {Include_Shared_Logic_in_Core}] $sys_rgmii

set sys_rgmii_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rgmii_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rgmii_rstgen

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

# audio peripherals

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_LOCKED {false}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.DMA_TYPE {1}] $axi_spdif_tx_core
set_property -dict [list CONFIG.S_AXI_ADDRESS_WIDTH {16}] $axi_spdif_tx_core

set axi_i2s_adi [create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi]
set_property -dict [list CONFIG.DMA_TYPE {1}] $axi_i2s_adi
set_property -dict [list CONFIG.S_AXI_ADDRESS_WIDTH {16}] $axi_i2s_adi

# system reset/clock definitions

ad_connect  sys_200m_clk axi_hdmi_clkgen/clk
ad_connect  sys_ps7/MDIO_ETHERNET_1 sys_rgmii/MDIO_GEM
ad_connect  sys_ps7/GMII_ETHERNET_1 sys_rgmii/GMII
ad_connect  sys_rgmii/MDIO_PHY eth1_mdio
ad_connect  sys_rgmii/RGMII eth1_rgmii
ad_connect  sys_rgmii/ref_clk_out eth1_refclk
ad_connect  sys_rgmii/gmii_clk_125m_out eth1_125mclk
ad_connect  sys_rgmii/gmii_clk_25m_out eth1_25mclk
ad_connect  sys_rgmii/gmii_clk_2_5m_out eth1_2m5clk
ad_connect  sys_rgmii/link_status eth1_link_status
ad_connect  sys_rgmii/duplex_status eth1_duplex_status
ad_connect  sys_rgmii/clock_speed eth1_clock_speed
ad_connect  sys_rgmii/speed_mode eth1_speed_mode
ad_connect  sys_ps7/ENET1_EXT_INTIN eth1_intn
ad_connect  sys_200m_clk sys_rgmii_rstgen/slowest_sync_clk
ad_connect  sys_200m_clk sys_rgmii/clkin
ad_connect  sys_rgmii_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N
ad_connect  sys_rgmii_rstgen/peripheral_reset sys_rgmii/tx_reset
ad_connect  sys_rgmii_rstgen/peripheral_reset sys_rgmii/rx_reset

# hdmi

ad_connect  sys_cpu_clk axi_hdmi_core/vdma_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_data
ad_connect  axi_hdmi_core/vdma_valid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/vdma_data axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/vdma_ready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_core/vdma_fs_ret

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

ad_cpu_interrupt ps-15 mb-15 axi_hdmi_dma/mm2s_introut

# interconnects

ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_cpu_interconnect 0x77600000 axi_i2s_adi
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S

# usued io (gpio & gt)

set axi_gpio_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_0

create_bd_port -dir I -from 31 -to 0 gpio_0_0_i
create_bd_port -dir O -from 31 -to 0 gpio_0_0_o
create_bd_port -dir O -from 31 -to 0 gpio_0_0_t
create_bd_port -dir I -from 31 -to 0 gpio_0_1_i
create_bd_port -dir O -from 31 -to 0 gpio_0_1_o
create_bd_port -dir O -from 31 -to 0 gpio_0_1_t

ad_connect  gpio_0_0_i axi_gpio_0/gpio_io_i
ad_connect  gpio_0_0_o axi_gpio_0/gpio_io_o
ad_connect  gpio_0_0_t axi_gpio_0/gpio_io_t
ad_connect  gpio_0_1_i axi_gpio_0/gpio2_io_i
ad_connect  gpio_0_1_o axi_gpio_0/gpio2_io_o
ad_connect  gpio_0_1_t axi_gpio_0/gpio2_io_t

set axi_gpio_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_1

create_bd_port -dir I -from 31 -to 0 gpio_1_0_i
create_bd_port -dir O -from 31 -to 0 gpio_1_0_o
create_bd_port -dir O -from 31 -to 0 gpio_1_0_t
create_bd_port -dir I -from 31 -to 0 gpio_1_1_i
create_bd_port -dir O -from 31 -to 0 gpio_1_1_o
create_bd_port -dir O -from 31 -to 0 gpio_1_1_t

ad_connect  gpio_1_0_i axi_gpio_1/gpio_io_i
ad_connect  gpio_1_0_o axi_gpio_1/gpio_io_o
ad_connect  gpio_1_0_t axi_gpio_1/gpio_io_t
ad_connect  gpio_1_1_i axi_gpio_1/gpio2_io_i
ad_connect  gpio_1_1_o axi_gpio_1/gpio2_io_o
ad_connect  gpio_1_1_t axi_gpio_1/gpio2_io_t

set axi_gpio_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_2

create_bd_port -dir I -from 31 -to 0 gpio_2_0_i
create_bd_port -dir O -from 31 -to 0 gpio_2_0_o
create_bd_port -dir O -from 31 -to 0 gpio_2_0_t
create_bd_port -dir I -from 31 -to 0 gpio_2_1_i
create_bd_port -dir O -from 31 -to 0 gpio_2_1_o
create_bd_port -dir O -from 31 -to 0 gpio_2_1_t

ad_connect  gpio_2_0_i axi_gpio_2/gpio_io_i
ad_connect  gpio_2_0_o axi_gpio_2/gpio_io_o
ad_connect  gpio_2_0_t axi_gpio_2/gpio_io_t
ad_connect  gpio_2_1_i axi_gpio_2/gpio2_io_i
ad_connect  gpio_2_1_o axi_gpio_2/gpio2_io_o
ad_connect  gpio_2_1_t axi_gpio_2/gpio2_io_t

set axi_gpio_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_3

create_bd_port -dir I -from 31 -to 0 gpio_3_0_i
create_bd_port -dir O -from 31 -to 0 gpio_3_0_o
create_bd_port -dir O -from 31 -to 0 gpio_3_0_t
create_bd_port -dir I -from 31 -to 0 gpio_3_1_i
create_bd_port -dir O -from 31 -to 0 gpio_3_1_o
create_bd_port -dir O -from 31 -to 0 gpio_3_1_t

ad_connect  gpio_3_0_i axi_gpio_3/gpio_io_i
ad_connect  gpio_3_0_o axi_gpio_3/gpio_io_o
ad_connect  gpio_3_0_t axi_gpio_3/gpio_io_t
ad_connect  gpio_3_1_i axi_gpio_3/gpio2_io_i
ad_connect  gpio_3_1_o axi_gpio_3/gpio2_io_o
ad_connect  gpio_3_1_t axi_gpio_3/gpio2_io_t

set axi_pzslb_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_pzslb_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_0 {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_pzslb_gt

set util_pzslb_gtlb [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb]

create_bd_port -dir I fmc_gt_ref_clk0
create_bd_port -dir I fmc_gt_ref_clk1
create_bd_port -dir I fmc_gt_rx_p
create_bd_port -dir I fmc_gt_rx_n
create_bd_port -dir O fmc_gt_tx_p
create_bd_port -dir O fmc_gt_tx_n

ad_connect  sys_cpu_clk util_pzslb_gtlb/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb/up_rstn
ad_connect  util_pzslb_gtlb/qpll_ref_clk fmc_gt_ref_clk0
ad_connect  util_pzslb_gtlb/cpll_ref_clk fmc_gt_ref_clk1
ad_connect  axi_pzslb_gt/gt_qpll_0 util_pzslb_gtlb/gt_qpll_0
ad_connect  axi_pzslb_gt/gt_pll_0 util_pzslb_gtlb/gt_pll_0
ad_connect  util_pzslb_gtlb/rx_p fmc_gt_rx_p
ad_connect  util_pzslb_gtlb/rx_n fmc_gt_rx_n
ad_connect  axi_pzslb_gt/gt_rx_0 util_pzslb_gtlb/gt_rx_0
ad_connect  util_pzslb_gtlb/tx_p fmc_gt_tx_p
ad_connect  util_pzslb_gtlb/tx_n fmc_gt_tx_n
ad_connect  axi_pzslb_gt/gt_tx_0 util_pzslb_gtlb/gt_tx_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_0 util_pzslb_gtlb/rx_gt_comma_align_enb_0 
ad_connect  axi_pzslb_gt/gt_rx_ip_0 util_pzslb_gtlb/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_0 util_pzslb_gtlb/gt_tx_ip_0

ad_cpu_interconnect 0x44A60000 axi_pzslb_gt
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_pzslb_gt/m_axi

ad_cpu_interconnect 0x41200000 axi_gpio_0
ad_cpu_interconnect 0x41210000 axi_gpio_1
ad_cpu_interconnect 0x41220000 axi_gpio_2
ad_cpu_interconnect 0x41230000 axi_gpio_3

create_bd_port -dir O up_clk
create_bd_port -dir O up_rst
create_bd_port -dir O up_rstn
create_bd_port -dir I up_pn_err_clr
create_bd_port -dir I up_pn_oos_clr
create_bd_port -dir O up_pn_err
create_bd_port -dir O up_pn_oos

ad_connect  sys_cpu_clk up_clk
ad_connect  sys_cpu_reset up_rst
ad_connect  sys_cpu_resetn up_rstn
ad_connect  up_pn_err_clr util_pzslb_gtlb/up_pn_err_clr
ad_connect  up_pn_oos_clr util_pzslb_gtlb/up_pn_oos_clr
ad_connect  up_pn_err util_pzslb_gtlb/up_pn_err
ad_connect  up_pn_oos util_pzslb_gtlb/up_pn_oos

delete_bd_objs [get_bd_cells ila_adc]
delete_bd_objs [get_bd_nets axi_ad9361_tdd_dbg] [get_bd_cells ila_tdd]

