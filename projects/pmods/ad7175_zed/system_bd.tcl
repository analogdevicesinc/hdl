
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {32}] $sys_ps7
set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect

set_property LEFT 31 [get_bd_ports GPIO_I]
set_property LEFT 31 [get_bd_ports GPIO_O]
set_property LEFT 31 [get_bd_ports GPIO_T]

set adc_sdo_i    [create_bd_port -dir I adc_sdo_i]
set adc_sdi_o    [create_bd_port -dir O adc_sdi_o]
set adc_cs_o     [create_bd_port -dir O adc_cs_o]
set adc_sclk_o   [create_bd_port -dir O adc_sclk_o]
set led_clk_o    [create_bd_port -dir O led_clk_o]
set dma_data     [create_bd_port -dir I -from 127 -to 0  dma_data]
set adc_data_0   [create_bd_port -dir O -from 31 -to 0  adc_data_0]
set adc_data_1   [create_bd_port -dir O -from 31 -to 0  adc_data_1]
set adc_data_2   [create_bd_port -dir O -from 31 -to 0  adc_data_2]
set adc_data_3   [create_bd_port -dir O -from 31 -to 0  adc_data_3]

set axi_ad7175  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad7175:1.0 axi_ad7175]

set axi_ad7175_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad7175_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad7175_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad7175_dma

set axi_ad7175_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad7175_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad7175_dma_interconnect

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {10.0}] $sys_ps7

set sys_adc_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]

connect_bd_net -net axi_ad7175_adc_sdo_i     [get_bd_ports adc_sdo_i]     [get_bd_pins axi_ad7175/adc_sdo_i]
connect_bd_net -net axi_ad7175_adc_sdi_o     [get_bd_ports adc_sdi_o]     [get_bd_pins axi_ad7175/adc_sdi_o]
connect_bd_net -net axi_ad7175_adc_cs_o      [get_bd_ports adc_cs_o]      [get_bd_pins axi_ad7175/adc_cs_o]
connect_bd_net -net axi_ad7175_adc_sclk_o    [get_bd_ports adc_sclk_o]    [get_bd_pins axi_ad7175/adc_sclk_o]
connect_bd_net -net axi_ad7175_led_clk_o     [get_bd_ports led_clk_o]     [get_bd_pins axi_ad7175/led_clk_o]

connect_bd_net -net axi_ad7175_dma_valid       [get_bd_pins axi_ad7175/adc_valid_o] [get_bd_pins axi_ad7175_dma/fifo_wr_en]

connect_bd_net -net axi_ad7175_dma_data_0      [get_bd_pins axi_ad7175/adc_data_0]  [get_bd_ports adc_data_0]
connect_bd_net -net axi_ad7175_dma_data_1      [get_bd_pins axi_ad7175/adc_data_1]  [get_bd_ports adc_data_1]
connect_bd_net -net axi_ad7175_dma_data_2      [get_bd_pins axi_ad7175/adc_data_2]  [get_bd_ports adc_data_2]
connect_bd_net -net axi_ad7175_dma_data_3      [get_bd_pins axi_ad7175/adc_data_3]  [get_bd_ports adc_data_3]
connect_bd_net -net axi_ad7175_dma_data        [get_bd_ports dma_data]              [get_bd_pins axi_ad7175_dma/fifo_wr_din]

connect_bd_net -net axi_ad7175_dma_dovf        [get_bd_pins axi_ad7175/adc_dovf]  [get_bd_pins axi_ad7175_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad7175_dma_irq         [get_bd_pins axi_ad7175_dma/irq]   [get_bd_pins sys_concat_intc/In13]

connect_bd_net -net sys_adc_clk_source     [get_bd_pins axi_ad7175/adc_clk_i] $sys_adc_clk_source
connect_bd_net -net sys_adc_dma_clk        [get_bd_pins axi_ad7175_dma/fifo_wr_clk] [get_bd_pins axi_ad7175/adc_clk]

connect_bd_net -net sys_100m_clk        [get_bd_pins axi_ad7175/s_axi_aclk] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk        [get_bd_pins axi_ad7175_dma/s_axi_aclk] $sys_100m_clk_source

connect_bd_net -net sys_100m_resetn        [get_bd_pins axi_ad7175/s_axi_aresetn] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn        [get_bd_pins axi_ad7175_dma/s_axi_aresetn] $sys_100m_resetn_source

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07 [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad7175_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08 [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad7175/s_axi]

connect_bd_net -net sys_100m_clk      [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk      [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source

connect_bd_intf_net -intf_net axi_ad7175_dma_interconnect_s0 [get_bd_intf_pins axi_ad7175_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad7175_dma/m_dest_axi]
connect_bd_intf_net -intf_net axi_ad7175_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad7175_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]

connect_bd_net -net sys_100m_clk  [get_bd_pins axi_ad7175_dma_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk  [get_bd_pins axi_ad7175_dma/m_dest_axi_aclk]
connect_bd_net -net sys_100m_clk  [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
connect_bd_net -net sys_100m_clk  [get_bd_pins axi_ad7175_dma_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk  [get_bd_pins axi_ad7175_dma_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad7175_dma_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad7175_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source

connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad7175_dma/m_dest_axi_aresetn]
connect_bd_net -net sys_100m_resetn   [get_bd_pins axi_ad7175_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source

create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad7175/s_axi/axi_lite]      SEG_data_ad7175_core
create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad7175_dma/s_axi/axi_lite]  SEG_data_ad7175_dma

create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad7175_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm