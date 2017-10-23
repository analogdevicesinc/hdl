
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# usdrx1

ad_ip_instance axi_quad_spi axi_usdrx1_spi
ad_ip_parameter axi_usdrx1_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_usdrx1_spi CONFIG.C_NUM_SS_BITS 5
ad_ip_parameter axi_usdrx1_spi CONFIG.C_SCK_RATIO 8
ad_connect sys_cpu_clk axi_usdrx1_spi/ext_spi_clk
create_bd_port -dir O -from 4 -to 0 spi_csn
ad_connect spi_csn axi_usdrx1_spi/ss_o
create_bd_port -dir O spi_clk
ad_connect spi_clk axi_usdrx1_spi/sck_o
create_bd_port -dir O spi_mosi
ad_connect spi_mosi axi_usdrx1_spi/io0_o
create_bd_port -dir I spi_miso
ad_connect spi_miso axi_usdrx1_spi/io1_i
ad_connect axi_usdrx1_spi/ss_i VCC
ad_connect axi_usdrx1_spi/sck_i GND
ad_connect axi_usdrx1_spi/io0_i GND

# shared transceiver core

ad_xcvr_parameter number_of_lanes 8
ad_xcvr_parameter rx_lane_rate {3.2 Gbps}
ad_xcvr_parameter rx_ref_clk_frequency {80.000 MHz}
ad_xcvr_instance axi_usdrx1_xcvr
create_bd_port -dir O rx_core_clk
ad_connect axi_usdrx1_xcvr_rx_core_clk rx_core_clk

# adc peripherals (jesd)

adi_axi_jesd204_rx_create axi_usdrx1_jesd 8
create_bd_port -dir I rx_sysref
create_bd_port -dir O rx_sync
ad_connect rx_sysref axi_usdrx1_jesd/sysref
ad_connect axi_usdrx1_jesd/sync rx_sync
ad_connect axi_usdrx1_xcvr_rx_core_clk axi_usdrx1_jesd/device_clk
ad_connect axi_usdrx1_jesd/phy_en_char_align axi_usdrx1_xcvr/rxencommaalign

# adc peripherals (lane split)

ad_ip_instance util_bsplit util_bsplit_rx_data
ad_ip_parameter util_bsplit_rx_data CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter util_bsplit_rx_data CONFIG.NUM_OF_CHANNELS 4
ad_connect axi_usdrx1_jesd/rx_data_tdata util_bsplit_rx_data/data

# adc peripherals (ad9671- 0)

ad_ip_instance axi_ad9671 axi_ad9671_core_0
ad_ip_parameter axi_ad9671_core_0 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_0 CONFIG.ID 0
ad_connect axi_usdrx1_xcvr_rx_core_clk axi_ad9671_core_0/rx_clk
ad_connect axi_usdrx1_jesd/rx_sof axi_ad9671_core_0/rx_sof
ad_connect util_bsplit_rx_data/split_data_0 axi_ad9671_core_0/rx_data
ad_connect axi_ad9671_core_0/adc_raddr_out axi_ad9671_core_0/adc_raddr_in
ad_connect axi_ad9671_core_0/adc_sync_out axi_ad9671_core_0/adc_sync_in

# adc peripherals (ad9671- 1)

ad_ip_instance axi_ad9671 axi_ad9671_core_1
ad_ip_parameter axi_ad9671_core_1 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_1 CONFIG.ID 1
ad_connect axi_usdrx1_xcvr_rx_core_clk axi_ad9671_core_1/rx_clk
ad_connect axi_usdrx1_jesd/rx_sof axi_ad9671_core_1/rx_sof
ad_connect util_bsplit_rx_data/split_data_1 axi_ad9671_core_1/rx_data
ad_connect axi_ad9671_core_0/adc_raddr_out axi_ad9671_core_1/adc_raddr_in
ad_connect axi_ad9671_core_0/adc_sync_out axi_ad9671_core_1/adc_sync_in

# adc peripherals (ad9671- 2)

ad_ip_instance axi_ad9671 axi_ad9671_core_2
ad_ip_parameter axi_ad9671_core_2 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_2 CONFIG.ID 2
ad_connect axi_usdrx1_xcvr_rx_core_clk axi_ad9671_core_2/rx_clk
ad_connect axi_usdrx1_jesd/rx_sof axi_ad9671_core_2/rx_sof
ad_connect util_bsplit_rx_data/split_data_2 axi_ad9671_core_2/rx_data
ad_connect axi_ad9671_core_0/adc_raddr_out axi_ad9671_core_2/adc_raddr_in
ad_connect axi_ad9671_core_0/adc_sync_out axi_ad9671_core_2/adc_sync_in

# adc peripherals (ad9671- 3)

ad_ip_instance axi_ad9671 axi_ad9671_core_3
ad_ip_parameter axi_ad9671_core_3 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_3 CONFIG.ID 3
ad_connect axi_usdrx1_xcvr_rx_core_clk axi_ad9671_core_3/rx_clk
ad_connect axi_usdrx1_jesd/rx_sof axi_ad9671_core_3/rx_sof
ad_connect util_bsplit_rx_data/split_data_3 axi_ad9671_core_3/rx_data
ad_connect axi_ad9671_core_0/adc_raddr_out axi_ad9671_core_3/adc_raddr_in
ad_connect axi_ad9671_core_0/adc_sync_out axi_ad9671_core_3/adc_sync_in

# adc peripherals (concat- data)

ad_ip_instance xlconcat util_concat_data
ad_ip_parameter util_concat_data CONFIG.NUM_PORTS 4
ad_connect axi_ad9671_core_0/adc_data util_concat_data/In0
ad_connect axi_ad9671_core_1/adc_data util_concat_data/In1
ad_connect axi_ad9671_core_2/adc_data util_concat_data/In2
ad_connect axi_ad9671_core_3/adc_data util_concat_data/In3

# adc peripherals (concat- valid)

ad_ip_instance xlconcat util_concat_valid
ad_ip_parameter util_concat_valid CONFIG.NUM_PORTS 4
ad_connect axi_ad9671_core_0/adc_valid util_concat_valid/In0
ad_connect axi_ad9671_core_1/adc_valid util_concat_valid/In1
ad_connect axi_ad9671_core_2/adc_valid util_concat_valid/In2
ad_connect axi_ad9671_core_3/adc_valid util_concat_valid/In3

# adc peripherals (valids-to-write)

ad_ip_instance util_reduced_logic util_or_valid
ad_ip_parameter util_or_valid CONFIG.C_SIZE 32
ad_ip_parameter util_or_valid CONFIG.C_OPERATION or
ad_connect util_concat_valid/dout util_or_valid/Op1

# adc peripherals (fifo, see system_bd.tcl)

ad_connect axi_usdrx1_xcvr_rx_core_clk axi_usdrx1_fifo/adc_clk
ad_connect util_or_valid/Res axi_usdrx1_fifo/adc_wr
ad_connect util_concat_data/dout axi_usdrx1_fifo/adc_wdata
ad_connect axi_usdrx1_fifo/adc_wovf axi_ad9671_core_0/adc_dovf
ad_connect axi_usdrx1_fifo/adc_wovf axi_ad9671_core_1/adc_dovf
ad_connect axi_usdrx1_fifo/adc_wovf axi_ad9671_core_2/adc_dovf
ad_connect axi_usdrx1_fifo/adc_wovf axi_ad9671_core_3/adc_dovf
ad_connect sys_200m_clk axi_usdrx1_fifo/dma_clk
ad_connect axi_usdrx1_fifo/adc_rst GND

# adc peripherals (dma)

ad_ip_instance axi_dmac axi_usdrx1_dma
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_usdrx1_dma CONFIG.ID 0
ad_ip_parameter axi_usdrx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_usdrx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_usdrx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_usdrx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_usdrx1_dma CONFIG.FIFO_SIZE 8
ad_connect sys_200m_clk axi_usdrx1_dma/s_axis_aclk
ad_connect sys_cpu_resetn axi_usdrx1_dma/m_dest_axi_aresetn
ad_connect axi_usdrx1_fifo/dma_wr axi_usdrx1_dma/s_axis_valid
ad_connect axi_usdrx1_fifo/dma_wdata axi_usdrx1_dma/s_axis_data
ad_connect axi_usdrx1_dma/s_axis_ready axi_usdrx1_fifo/dma_wready
ad_connect axi_usdrx1_dma/s_axis_xfer_req axi_usdrx1_fifo/dma_xfer_req

# address map

ad_cpu_interconnect 0x44A00000 axi_ad9671_core_0
ad_cpu_interconnect 0x44A10000 axi_ad9671_core_1
ad_cpu_interconnect 0x44A20000 axi_ad9671_core_2
ad_cpu_interconnect 0x44A30000 axi_ad9671_core_3
ad_cpu_interconnect 0x44A60000 axi_usdrx1_xcvr
ad_cpu_interconnect 0x44A90000 axi_usdrx1_jesd
ad_cpu_interconnect 0x7c400000 axi_usdrx1_dma
ad_cpu_interconnect 0x7c420000 axi_usdrx1_spi

# memory interconnects

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_usdrx1_dma/m_dest_axi

