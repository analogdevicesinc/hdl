
# dac interface

set dac_clk_in_p    [create_bd_port -dir I dac_clk_in_p]
set dac_clk_in_n    [create_bd_port -dir I dac_clk_in_n]
set dac_clk_out_p   [create_bd_port -dir O dac_clk_out_p]
set dac_clk_out_n   [create_bd_port -dir O dac_clk_out_n]
set dac_frame_out_p [create_bd_port -dir O dac_frame_out_p]
set dac_frame_out_n [create_bd_port -dir O dac_frame_out_n]
set dac_data_out_p  [create_bd_port -dir O -from 15 -to 0 dac_data_out_p]
set dac_data_out_n  [create_bd_port -dir O -from 15 -to 0 dac_data_out_n]

# adc interface

set adc_clk_in_p    [create_bd_port -dir I adc_clk_in_p]
set adc_clk_in_n    [create_bd_port -dir I adc_clk_in_n]
set adc_or_in_p     [create_bd_port -dir I adc_or_in_p]
set adc_or_in_n     [create_bd_port -dir I adc_or_in_n]
set adc_data_in_p   [create_bd_port -dir I -from 13 -to 0 adc_data_in_p]
set adc_data_in_n   [create_bd_port -dir I -from 13 -to 0 adc_data_in_n]

# reference clock

set ref_clk         [create_bd_port -dir O ref_clk]

# dac peripherals

set axi_ad9122 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122]

set axi_ad9122_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_ADDR_ALIGN_BITS {4}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9122_dma
set_property -dict [list CONFIG.C_M_DEST_AXI_DATA_WIDTH {64}] $axi_ad9122_dma

set axi_ad9122_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9122_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9122_dma_interconnect

# adc peripherals

set axi_ad9643 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9643:1.0 axi_ad9643]

set sys_ad9643_fifo  [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:11.0 sys_ad9643_fifo]
set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $sys_ad9643_fifo
set_property -dict [list CONFIG.Input_Data_Width {32}] $sys_ad9643_fifo
set_property -dict [list CONFIG.Input_Depth {32}] $sys_ad9643_fifo
set_property -dict [list CONFIG.Output_Data_Width {64}] $sys_ad9643_fifo
set_property -dict [list CONFIG.Overflow_Flag {true}] $sys_ad9643_fifo
set_property -dict [list CONFIG.Reset_Pin {true}] $sys_ad9643_fifo

set sys_ad9643_util_wfifo [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 sys_ad9643_util_wfifo]
set_property -dict [list CONFIG.M_DATA_WIDTH {32}] $sys_ad9643_util_wfifo
set_property -dict [list CONFIG.S_DATA_WIDTH {64}] $sys_ad9643_util_wfifo

set axi_ad9643_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9643_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9643_dma
set_property -dict [list CONFIG.C_M_DEST_AXI_DATA_WIDTH {64}] $axi_ad9643_dma

set axi_ad9643_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9643_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9643_dma_interconnect

# additions to default configuration

set_property -dict [list CONFIG.NUM_MI {11}] $axi_cpu_interconnect
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125.0}] $sys_ps7

# reference clock shared with audio clock

set_property -dict [list CONFIG.CLKOUT2_USED {true}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {30}] $sys_audio_clkgen

# connections (dac)

connect_bd_net -net dac_div_clk [get_bd_pins axi_ad9122/dac_div_clk]
connect_bd_net -net dac_div_clk [get_bd_pins axi_ad9122_dma/fifo_rd_clk]

connect_bd_net -net axi_ad9122_dac_clk_in_p     [get_bd_ports dac_clk_in_p]                       [get_bd_pins axi_ad9122/dac_clk_in_p]
connect_bd_net -net axi_ad9122_dac_clk_in_n     [get_bd_ports dac_clk_in_n]                       [get_bd_pins axi_ad9122/dac_clk_in_n]
connect_bd_net -net axi_ad9122_dac_clk_out_p    [get_bd_ports dac_clk_out_p]                      [get_bd_pins axi_ad9122/dac_clk_out_p]
connect_bd_net -net axi_ad9122_dac_clk_out_n    [get_bd_ports dac_clk_out_n]                      [get_bd_pins axi_ad9122/dac_clk_out_n]
connect_bd_net -net axi_ad9122_dac_frame_out_p  [get_bd_ports dac_frame_out_p]                    [get_bd_pins axi_ad9122/dac_frame_out_p]
connect_bd_net -net axi_ad9122_dac_frame_out_n  [get_bd_ports dac_frame_out_n]                    [get_bd_pins axi_ad9122/dac_frame_out_n]
connect_bd_net -net axi_ad9122_dac_data_out_p   [get_bd_ports dac_data_out_p]                     [get_bd_pins axi_ad9122/dac_data_out_p]
connect_bd_net -net axi_ad9122_dac_data_out_n   [get_bd_ports dac_data_out_n]                     [get_bd_pins axi_ad9122/dac_data_out_n]
connect_bd_net -net axi_ad9122_dac_drd          [get_bd_pins axi_ad9122/dac_drd]                  [get_bd_pins axi_ad9122_dma/fifo_rd_en]
connect_bd_net -net axi_ad9122_dac_ddata        [get_bd_pins axi_ad9122/dac_ddata_64]             [get_bd_pins axi_ad9122_dma/fifo_rd_dout]
connect_bd_net -net axi_ad9122_dac_dunf         [get_bd_pins axi_ad9122/dac_dunf]                 [get_bd_pins axi_ad9122_dma/fifo_rd_underflow]
connect_bd_net -net axi_ad9122_dma_irq          [get_bd_pins axi_ad9122_dma/irq]                  [get_bd_pins sys_concat_intc/In3]

# connections (adc)

connect_bd_net -net adc_clk [get_bd_pins axi_ad9643/adc_clk]
connect_bd_net -net adc_clk [get_bd_pins axi_ad9643_dma/fifo_wr_clk]
connect_bd_net -net adc_clk [get_bd_pins sys_ad9643_util_wfifo/clk]
connect_bd_net -net adc_clk [get_bd_pins sys_ad9643_fifo/wr_clk]
connect_bd_net -net adc_clk [get_bd_pins sys_ad9643_fifo/rd_clk]
connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9643/delay_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins sys_ad9643_util_wfifo/rstn]

connect_bd_net -net axi_ad9643_adc_clk_in_p     [get_bd_ports adc_clk_in_p]                       [get_bd_pins axi_ad9643/adc_clk_in_p]
connect_bd_net -net axi_ad9643_adc_clk_in_n     [get_bd_ports adc_clk_in_n]                       [get_bd_pins axi_ad9643/adc_clk_in_n]
connect_bd_net -net axi_ad9643_adc_or_in_p      [get_bd_ports adc_or_in_p]                        [get_bd_pins axi_ad9643/adc_or_in_p]
connect_bd_net -net axi_ad9643_adc_or_in_n      [get_bd_ports adc_or_in_n]                        [get_bd_pins axi_ad9643/adc_or_in_n]
connect_bd_net -net axi_ad9643_adc_data_in_p    [get_bd_ports adc_data_in_p]                      [get_bd_pins axi_ad9643/adc_data_in_p]
connect_bd_net -net axi_ad9643_adc_data_in_n    [get_bd_ports adc_data_in_n]                      [get_bd_pins axi_ad9643/adc_data_in_n]
connect_bd_net -net axi_ad9643_adc_dsync        [get_bd_pins axi_ad9643/adc_dsync]                [get_bd_pins axi_ad9643_dma/fifo_wr_sync]
connect_bd_net -net axi_ad9643_adc_dwr          [get_bd_pins axi_ad9643/adc_dwr]                  [get_bd_pins sys_ad9643_util_wfifo/m_wr]
connect_bd_net -net axi_ad9643_adc_ddata        [get_bd_pins axi_ad9643/adc_ddata]                [get_bd_pins sys_ad9643_util_wfifo/m_wdata]
connect_bd_net -net axi_ad9643_adc_dovf         [get_bd_pins axi_ad9643/adc_dovf]                 [get_bd_pins sys_ad9643_util_wfifo/m_wovf]
connect_bd_net -net axi_ad9643_dma_dwr          [get_bd_pins sys_ad9643_util_wfifo/s_wr]          [get_bd_pins axi_ad9643_dma/fifo_wr_en]
connect_bd_net -net axi_ad9643_dma_ddata        [get_bd_pins sys_ad9643_util_wfifo/s_wdata]       [get_bd_pins axi_ad9643_dma/fifo_wr_din]
connect_bd_net -net axi_ad9643_dma_dovf         [get_bd_pins sys_ad9643_util_wfifo/s_wovf]        [get_bd_pins axi_ad9643_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9643_dma_irq          [get_bd_pins axi_ad9643_dma/irq]                  [get_bd_pins sys_concat_intc/In2]

connect_bd_net -net axi_ad9643_fifo_rst         [get_bd_pins sys_ad9643_util_wfifo/fifo_rst]      [get_bd_pins sys_ad9643_fifo/rst]
connect_bd_net -net axi_ad9643_fifo_wr          [get_bd_pins sys_ad9643_util_wfifo/fifo_wr]       [get_bd_pins sys_ad9643_fifo/wr_en]
connect_bd_net -net axi_ad9643_fifo_wdata       [get_bd_pins sys_ad9643_util_wfifo/fifo_wdata]    [get_bd_pins sys_ad9643_fifo/din]
connect_bd_net -net axi_ad9643_fifo_wfull       [get_bd_pins sys_ad9643_util_wfifo/fifo_wfull]    [get_bd_pins sys_ad9643_fifo/full]
connect_bd_net -net axi_ad9643_fifo_wovf        [get_bd_pins sys_ad9643_util_wfifo/fifo_wovf]     [get_bd_pins sys_ad9643_fifo/overflow]
connect_bd_net -net axi_ad9643_fifo_rd          [get_bd_pins sys_ad9643_util_wfifo/fifo_rd]       [get_bd_pins sys_ad9643_fifo/rd_en]
connect_bd_net -net axi_ad9643_fifo_rdata       [get_bd_pins sys_ad9643_util_wfifo/fifo_rdata]    [get_bd_pins sys_ad9643_fifo/dout]
connect_bd_net -net axi_ad9643_fifo_rempty      [get_bd_pins sys_ad9643_util_wfifo/fifo_rempty]   [get_bd_pins sys_ad9643_fifo/empty]

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9122/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9643/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9643_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9122_dma/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9122_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9122_dma/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9643/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9643_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9643_dma/s_axi_aresetn]

# memory interconnects share the same clock (fclk2)

set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
set sys_fmc_dma_resetn_source [get_bd_pins sys_ps7/FCLK_RESET2_N]

connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_resetn $sys_fmc_dma_resetn_source

# interconnect (mem/dac)

connect_bd_intf_net -intf_net axi_ad9122_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9122_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9122_dma/m_src_axi]
connect_bd_intf_net -intf_net axi_ad9122_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9122_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9122_dma/m_src_axi_aclk]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]

# interconnect (mem/adc)

connect_bd_intf_net -intf_net axi_ad9643_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9643_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9643_dma/m_dest_axi]
connect_bd_intf_net -intf_net axi_ad9643_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9643_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9643_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9643_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9643_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9643_dma/m_dest_axi_aclk]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9643_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9643_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9643_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_ad9643_dma/m_dest_axi_aresetn]

# ila (adc)

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {28}] $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc

connect_bd_net -net adc_clk [get_bd_pins ila_adc/clk]
connect_bd_net -net axi_ad9643_adc_mon_data   [get_bd_pins axi_ad9643/adc_mon_data]   [get_bd_pins ila_adc/probe0]

# reference clock

connect_bd_net -net fmcomms1_ref_clk [get_bd_pins sys_audio_clkgen/clk_out2] [get_bd_ports ref_clk]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x74200000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9122/s_axi/axi_lite]      SEG_data_ad9122
create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9643_dma/s_axi/axi_lite]  SEG_data_ad9122_dma
create_bd_addr_seg -range 0x00010000 -offset 0x79020000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9643/s_axi/axi_lite]      SEG_data_ad9643
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9122_dma/s_axi/axi_lite]  SEG_data_ad9643_dma

create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9643_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9122_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm

