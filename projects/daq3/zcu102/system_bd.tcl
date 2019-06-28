
## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

## NOTE: With this configuration the #36Kb BRAM utilization is at ~28%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq3_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

# configure the CPLL's to support 12.33Gbps
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG0 0x03fe
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG1 0x0021
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG2 0x0203

create_bd_port -dir I dac_fifo_bypass

ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_ad9152_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9152_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9152_dma CONFIG.MAX_BYTES_PER_BURST 256

ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9680_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9680_dma CONFIG.MAX_BYTES_PER_BURST 256

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance proc_sys_reset sys_dma_rstgen

ad_connect sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect sys_cpu_resetn dma_clk_wiz/resetn

ad_connect sys_dma_clk dma_clk_wiz/clk_out1

ad_connect sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect sys_cpu_resetn sys_dma_rstgen/ext_reset_in

ad_connect sys_dma_reset sys_dma_rstgen/peripheral_reset
ad_connect sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

ad_connect sys_dma_clk axi_ad9152_fifo/dma_clk
ad_connect sys_dma_reset axi_ad9152_fifo/dma_rst
ad_connect sys_dma_clk axi_ad9152_dma/m_axis_aclk
ad_connect sys_dma_resetn axi_ad9152_dma/m_src_axi_aresetn
ad_connect axi_ad9152_fifo/bypass dac_fifo_bypass

ad_connect sys_dma_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect axi_ad9680_dma/fifo_wr_clk util_daq3_xcvr/rx_out_clk_0
ad_connect axi_ad9680_cpack/packed_fifo_wr axi_ad9680_dma/fifo_wr

ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9680_xcvr/m_axi
ad_mem_hp1_interconnect sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_dma_clk axi_ad9680_dma/m_dest_axi
ad_mem_hp3_interconnect sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_dma_clk axi_ad9152_dma/m_src_axi
