

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name axi_ad9625_fifo
set adc_data_width 512
set adc_dma_data_width 64

# adc peripherals

ad_ip_instance util_adxcvr util_fmcadc5_0_xcvr
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.CPLL_FBDIV 1
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_CLK25_DIV 25
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_fmcadc5_0_xcvr CONFIG.RX_CDR_CFG 0x03000023ff10200020

ad_ip_instance util_adxcvr util_fmcadc5_1_xcvr
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.CPLL_FBDIV 1
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_CLK25_DIV 25
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_fmcadc5_1_xcvr CONFIG.RX_CDR_CFG 0x03000023ff10200020

ad_ip_instance axi_adxcvr axi_ad9625_0_xcvr
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.ID 0
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.SYS_CLK_SEL 0x0
ad_ip_parameter axi_ad9625_0_xcvr CONFIG.OUT_CLK_SEL 0x2

ad_ip_instance axi_adxcvr axi_ad9625_1_xcvr
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.ID 1
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.SYS_CLK_SEL 0x0
ad_ip_parameter axi_ad9625_1_xcvr CONFIG.OUT_CLK_SEL 0x2

adi_axi_jesd204_rx_create axi_ad9625_0_jesd 8
ad_ip_parameter axi_ad9625_0_jesd/rx CONFIG.SYSREF_IOB false

adi_axi_jesd204_rx_create axi_ad9625_1_jesd 8
ad_ip_parameter axi_ad9625_1_jesd/rx CONFIG.SYSREF_IOB false

ad_ip_instance axi_ad9625 axi_ad9625_0_core
ad_ip_parameter axi_ad9625_0_core CONFIG.ID 0

ad_ip_instance axi_ad9625 axi_ad9625_1_core
ad_ip_parameter axi_ad9625_1_core CONFIG.ID 1

ad_ip_instance axi_dmac axi_ad9625_dma
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.ID 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9625_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_1

ad_xcvrpll  rx_ref_clk_0 util_fmcadc5_0_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc5_0_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_0_xcvr/up_pll_rst util_fmcadc5_0_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_0_xcvr/up_pll_rst util_fmcadc5_0_xcvr/up_cpll_rst_*
ad_xcvrpll  rx_ref_clk_1 util_fmcadc5_1_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_1 util_fmcadc5_1_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_1_xcvr/up_pll_rst util_fmcadc5_1_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_1_xcvr/up_pll_rst util_fmcadc5_1_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_fmcadc5_0_xcvr/up_rstn
ad_connect  $sys_cpu_resetn util_fmcadc5_1_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_fmcadc5_0_xcvr/up_clk
ad_connect  $sys_cpu_clk util_fmcadc5_1_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_fmcadc5_0_xcvr axi_ad9625_0_xcvr axi_ad9625_0_jesd
ad_xcvrcon  util_fmcadc5_1_xcvr axi_ad9625_1_xcvr axi_ad9625_1_jesd

delete_bd_objs [get_bd_nets -of_objects [get_bd_pins util_fmcadc5_1_xcvr/rx_out_clk_0]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9625_1_jesd_rstgen/peripheral_reset]]
delete_bd_objs [get_bd_cells axi_ad9625_1_jesd_rstgen]

ad_xcvrpll  util_fmcadc5_0_xcvr/rx_out_clk_0 util_fmcadc5_1_xcvr/rx_clk_*
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_1_jesd/device_clk
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_0_core/rx_clk
ad_connect  axi_ad9625_0_jesd/rx_sof axi_ad9625_0_core/rx_sof
ad_connect  axi_ad9625_0_jesd/rx_data_tdata axi_ad9625_0_core/rx_data
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_1_core/rx_clk
ad_connect  axi_ad9625_0_jesd/rx_sof axi_ad9625_1_core/rx_sof
ad_connect  axi_ad9625_1_jesd/rx_data_tdata axi_ad9625_1_core/rx_data
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_0_core/adc_raddr_in
ad_connect  axi_ad9625_0_core/adc_raddr_out axi_ad9625_1_core/adc_raddr_in
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_ad9625_fifo/adc_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset axi_ad9625_fifo/adc_rst
ad_connect  axi_ad9625_fifo/adc_wovf axi_ad9625_0_core/adc_dovf
ad_connect  axi_ad9625_fifo/adc_wovf axi_ad9625_1_core/adc_dovf
ad_connect  $sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44a60000 axi_ad9625_0_xcvr
ad_cpu_interconnect 0x44b60000 axi_ad9625_1_xcvr
ad_cpu_interconnect 0x44a10000 axi_ad9625_0_core
ad_cpu_interconnect 0x44b10000 axi_ad9625_1_core
ad_cpu_interconnect 0x44a90000 axi_ad9625_0_jesd
ad_cpu_interconnect 0x44b90000 axi_ad9625_1_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma

# interconnect (gt/adc)

ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9625_0_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9625_1_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9625_dma/irq
ad_cpu_interrupt ps-11 mb-13 axi_ad9625_0_jesd/irq
ad_cpu_interrupt ps-10 mb-14 axi_ad9625_1_jesd/irq

# interleave-sync

ad_disconnect  rx_sysref_0 axi_ad9625_0_jesd/sysref
ad_disconnect  rx_sync_0 axi_ad9625_0_jesd/sync
ad_disconnect  rx_sysref_1_0 axi_ad9625_1_jesd/sysref
ad_disconnect  rx_sync_1_0 axi_ad9625_1_jesd/sync
ad_disconnect  spi_csn_o axi_spi/ss_o
ad_disconnect  spi_csn_i axi_spi/ss_i
ad_disconnect  spi_clk_i axi_spi/sck_i
ad_disconnect  spi_clk_o axi_spi/sck_o
ad_disconnect  spi_sdo_i axi_spi/io0_i
ad_disconnect  spi_sdo_o axi_spi/io0_o
ad_disconnect  spi_sdi_i axi_spi/io1_i

ad_ip_instance axi_fmcadc5_sync axi_fmcadc5_sync
ad_cpu_interconnect 0x44a20000 axi_fmcadc5_sync
ad_connect  $sys_cpu_reset axi_fmcadc5_sync/delay_rst
ad_connect  $sys_iodelay_clk axi_fmcadc5_sync/delay_clk
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 axi_fmcadc5_sync/rx_clk
ad_connect  axi_ad9625_0_core/adc_enable axi_fmcadc5_sync/rx_enable_0
ad_connect  axi_ad9625_0_core/adc_data axi_fmcadc5_sync/rx_data_0
ad_connect  axi_ad9625_1_core/adc_enable axi_fmcadc5_sync/rx_enable_1
ad_connect  axi_ad9625_1_core/adc_data axi_fmcadc5_sync/rx_data_1
ad_connect  axi_fmcadc5_sync/rx_enable axi_ad9625_fifo/adc_wr
ad_connect  axi_fmcadc5_sync/rx_data axi_ad9625_fifo/adc_wdata
ad_connect  axi_fmcadc5_sync/rx_sysref axi_ad9625_0_jesd/sysref
ad_connect  axi_ad9625_0_jesd/sync axi_fmcadc5_sync/rx_sync_0
ad_connect  axi_fmcadc5_sync/rx_sysref axi_ad9625_1_jesd/sysref
ad_connect  axi_ad9625_1_jesd/sync axi_fmcadc5_sync/rx_sync_1
ad_connect  axi_spi/ss_o axi_fmcadc5_sync/spi_csn_o
ad_connect  axi_spi/sck_o axi_fmcadc5_sync/spi_clk_o
ad_connect  axi_spi/io0_o axi_fmcadc5_sync/spi_sdo_o
ad_connect  axi_spi/ss_i GND
ad_connect  axi_spi/sck_i GND
ad_connect  axi_spi/io0_i GND

create_bd_port -dir O rx_sysref_p
create_bd_port -dir O rx_sysref_n
create_bd_port -dir O rx_sync_0_p
create_bd_port -dir O rx_sync_0_n
create_bd_port -dir O rx_sync_1_p
create_bd_port -dir O rx_sync_1_n
create_bd_port -dir O -from 7 -to 0 spi_csn
create_bd_port -dir O spi_clk
create_bd_port -dir O spi_mosi
create_bd_port -dir I spi_miso
create_bd_port -dir O psync
create_bd_port -dir O vcal

ad_connect  axi_fmcadc5_sync/rx_sysref_p rx_sysref_p
ad_connect  axi_fmcadc5_sync/rx_sysref_n rx_sysref_n
ad_connect  axi_fmcadc5_sync/rx_sync_0_p rx_sync_0_p
ad_connect  axi_fmcadc5_sync/rx_sync_0_n rx_sync_0_n
ad_connect  axi_fmcadc5_sync/rx_sync_1_p rx_sync_1_p
ad_connect  axi_fmcadc5_sync/rx_sync_1_n rx_sync_1_n
ad_connect  axi_fmcadc5_sync/psync psync
ad_connect  axi_fmcadc5_sync/vcal vcal
ad_connect  axi_fmcadc5_sync/spi_csn spi_csn
ad_connect  axi_fmcadc5_sync/spi_clk spi_clk
ad_connect  axi_fmcadc5_sync/spi_mosi spi_mosi
ad_connect  spi_miso axi_fmcadc5_sync/spi_miso
ad_connect  spi_miso axi_spi/io1_i

# Connect core_reset_ext to be used for synchronization
create_bd_pin -dir I axi_ad9625_0_jesd/core_reset_ext
create_bd_pin -dir I axi_ad9625_1_jesd/core_reset_ext

ad_connect axi_ad9625_0_jesd/core_reset_ext axi_ad9625_0_jesd/rx_axi/core_reset_ext
ad_connect axi_ad9625_1_jesd/core_reset_ext axi_ad9625_1_jesd/rx_axi/core_reset_ext
ad_connect axi_ad9625_0_core/adc_rst axi_ad9625_0_jesd/core_reset_ext
ad_connect axi_ad9625_0_core/adc_rst axi_ad9625_1_jesd/core_reset_ext
