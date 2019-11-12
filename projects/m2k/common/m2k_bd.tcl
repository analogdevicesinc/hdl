
if {[info exists DEBUG_BUILD] == 0} {
  set DEBUG_BUILD 1
}

set DISABLE_DMAC_DEBUG [expr !$DEBUG_BUILD]

create_bd_port -dir I -from 15 -to 0  data_i
create_bd_port -dir I -from  1 -to 0  trigger_i

create_bd_port -dir O -from 15 -to 0 data_o
create_bd_port -dir O -from 15 -to 0 data_t
create_bd_port -dir O -from  1 -to 0 trigger_o
create_bd_port -dir O -from  1 -to 0 trigger_t

create_bd_port -dir I rx_clk
create_bd_port -dir I rxiq
create_bd_port -dir I -from 11 -to 0 rxd
create_bd_port -dir I tx_clk
create_bd_port -dir O txiq
create_bd_port -dir O -from 11 -to 0 txd

# AXI control interface and logic analyzer DMA (FCLK0): 27.8 MHz
# Logic analyzer (FCLK2): 100 MHz
# Converter DMA (FCLK3): 55.6 MHz

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK3_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 27.778
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ 55.556

#ad_connect logic_analyzer_clk_in sys_ps7/FCLK_CLK2
ad_connect converter_dma_clk sys_ps7/FCLK_CLK3

ad_ip_instance axi_logic_analyzer logic_analyzer

ad_ip_instance util_var_fifo la_trigger_fifo
ad_ip_parameter la_trigger_fifo CONFIG.DATA_WIDTH 16
ad_ip_parameter la_trigger_fifo CONFIG.ADDRESS_WIDTH 13

ad_ip_instance blk_mem_gen bram_la
ad_ip_parameter bram_la CONFIG.use_bram_block {Stand_Alone}
ad_ip_parameter bram_la CONFIG.Memory_Type {Simple_Dual_Port_RAM}
ad_ip_parameter bram_la CONFIG.Assume_Synchronous_Clk {true}
ad_ip_parameter bram_la CONFIG.Algorithm {Low_Power}
ad_ip_parameter bram_la CONFIG.Use_Byte_Write_Enable {false}
ad_ip_parameter bram_la CONFIG.Operating_Mode_A {NO_CHANGE}
ad_ip_parameter bram_la CONFIG.Register_PortB_Output_of_Memory_Primitives {true}
ad_ip_parameter bram_la CONFIG.Use_RSTA_Pin {false}
ad_ip_parameter bram_la CONFIG.Port_B_Clock {100}
ad_ip_parameter bram_la CONFIG.Port_B_Enable_Rate {100}
ad_ip_parameter bram_la CONFIG.Write_Width_A {16}
ad_ip_parameter bram_la CONFIG.Write_Width_B {16}
ad_ip_parameter bram_la CONFIG.Read_Width_B {16}
ad_ip_parameter bram_la CONFIG.Write_Depth_A {8192}

ad_ip_instance axi_dmac logic_analyzer_dmac
ad_ip_parameter logic_analyzer_dmac CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter logic_analyzer_dmac CONFIG.DMA_AXI_PROTOCOL_DEST 1
ad_ip_parameter logic_analyzer_dmac CONFIG.SYNC_TRANSFER_START true
ad_ip_parameter logic_analyzer_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac pattern_generator_dmac
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter pattern_generator_dmac CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter pattern_generator_dmac CONFIG.CYCLIC true
ad_ip_parameter pattern_generator_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_ad9963 axi_ad9963
ad_ip_parameter axi_ad9963 CONFIG.DAC_DATAPATH_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_USERPORTS_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_DATAFORMAT_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_DCFILTER_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_IQCORRECTION_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_SCALECORRECTION_ONLY 1

ad_ip_instance util_var_fifo adc_trigger_fifo
ad_ip_parameter adc_trigger_fifo CONFIG.DATA_WIDTH 32
ad_ip_parameter adc_trigger_fifo CONFIG.ADDRESS_WIDTH 13

ad_ip_instance blk_mem_gen bram_adc
ad_ip_parameter bram_adc CONFIG.use_bram_block {Stand_Alone}
ad_ip_parameter bram_adc CONFIG.Memory_Type {Simple_Dual_Port_RAM}
ad_ip_parameter bram_adc CONFIG.Assume_Synchronous_Clk true
ad_ip_parameter bram_adc CONFIG.Algorithm {Low_Power}
ad_ip_parameter bram_adc CONFIG.Enable_32bit_Address false
ad_ip_parameter bram_adc CONFIG.Use_Byte_Write_Enable false
ad_ip_parameter bram_adc CONFIG.Operating_Mode_A {NO_CHANGE}
ad_ip_parameter bram_adc CONFIG.Register_PortB_Output_of_Memory_Primitives true
ad_ip_parameter bram_adc CONFIG.Use_RSTA_Pin {false}
ad_ip_parameter bram_adc CONFIG.Port_B_Clock 100
ad_ip_parameter bram_adc CONFIG.Port_B_Enable_Rate 100
ad_ip_parameter bram_adc CONFIG.Write_Width_A 32
ad_ip_parameter bram_adc CONFIG.Write_Width_B 32
ad_ip_parameter bram_adc CONFIG.Read_Width_B 32
ad_ip_parameter bram_adc CONFIG.Write_Depth_A 8192

# FIXME: Bring this back eventually
#ad_ip_instance util_cpack util_cpack_ad9963
#ad_ip_parameter util_cpack_ad9963 CONFIG.NUM_OF_CHANNELS 2
#ad_ip_parameter util_cpack_ad9963 CONFIG.CHANNEL_DATA_WIDTH 16

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ad9963_adc_concat

ad_ip_instance axi_dmac ad9963_adc_dmac
ad_ip_parameter ad9963_adc_dmac CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter ad9963_adc_dmac CONFIG.DMA_AXI_PROTOCOL_DEST 1
ad_ip_parameter ad9963_adc_dmac CONFIG.SYNC_TRANSFER_START true
ad_ip_parameter ad9963_adc_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac ad9963_dac_dmac_a
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter ad9963_dac_dmac_a CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9963_dac_dmac_a CONFIG.CYCLIC {true}
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac ad9963_dac_dmac_b
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter ad9963_dac_dmac_b CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9963_dac_dmac_b CONFIG.CYCLIC {true}
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_adc_trigger adc_trigger

ad_ip_instance axi_adc_decimate axi_adc_decimate
ad_ip_parameter axi_adc_decimate CONFIG.CORRECTION_DISABLE {0}

ad_ip_instance axi_dac_interpolate axi_dac_interpolate
ad_ip_parameter axi_dac_interpolate CONFIG.CORRECTION_DISABLE {0}

ad_ip_instance proc_sys_reset logic_analyzer_reset

ad_ip_instance axi_rd_wr_combiner axi_rd_wr_combiner_logic
ad_ip_instance axi_rd_wr_combiner axi_rd_wr_combiner_converter

ad_connect data_i     logic_analyzer/data_i
ad_connect trigger_i  logic_analyzer/trigger_i
ad_connect data_o     logic_analyzer/data_o
ad_connect data_t     logic_analyzer/data_t

ad_connect axi_ad9963/adc_clk logic_analyzer/clk
ad_connect logic_analyzer_clk logic_analyzer/clk_out

ad_connect logic_analyzer_clk pattern_generator_dmac/fifo_rd_clk

ad_connect logic_analyzer_clk la_trigger_fifo/clk
ad_connect logic_analyzer_clk bram_la/clkb
ad_connect logic_analyzer_clk bram_la/clka
ad_connect logic_analyzer_clk logic_analyzer_dmac/fifo_wr_clk
ad_connect logic_analyzer_clk logic_analyzer_reset/slowest_sync_clk
ad_connect logic_analyzer_reset/ext_reset_in sys_rstgen/peripheral_aresetn
ad_connect logic_analyzer_reset/bus_struct_reset la_trigger_fifo/rst

ad_connect la_trigger_fifo/data_in        logic_analyzer/adc_data
ad_connect la_trigger_fifo/data_in_valid  logic_analyzer/adc_valid

ad_connect bram_la/addra                    la_trigger_fifo/addr_w
ad_connect bram_la/dina                     la_trigger_fifo/din_w
ad_connect bram_la/ena                      la_trigger_fifo/en_w
ad_connect bram_la/wea                      la_trigger_fifo/wea_w
ad_connect bram_la/addrb                    la_trigger_fifo/addr_r
ad_connect bram_la/doutb                    la_trigger_fifo/dout_r
ad_connect bram_la/enb                      la_trigger_fifo/en_r

ad_connect logic_analyzer_dmac/fifo_wr_din  la_trigger_fifo/data_out
ad_connect logic_analyzer_dmac/fifo_wr_en   la_trigger_fifo/data_out_valid

ad_connect logic_analyzer/fifo_depth la_trigger_fifo/depth

ad_connect logic_analyzer/trigger_out logic_analyzer_dmac/fifo_wr_sync
ad_connect logic_analyzer/trigger_in adc_trigger/trigger_out_la

ad_connect pattern_generator_dmac/fifo_rd_en      logic_analyzer/dac_read
ad_connect pattern_generator_dmac/fifo_rd_dout    logic_analyzer/dac_data
ad_connect pattern_generator_dmac/fifo_rd_valid   logic_analyzer/dac_valid


ad_connect axi_ad9963/adc_clk  adc_trigger_fifo/clk
#ad_connect axi_ad9963/adc_clk  util_cpack_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_clk axi_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_rst axi_ad9963/adc_rst

ad_connect ad9963_adc_dmac/fifo_wr_clk     axi_ad9963/adc_clk
ad_connect bram_adc/clka                   axi_ad9963/adc_clk
ad_connect bram_adc/clkb                   axi_ad9963/adc_clk

#ad_connect axi_ad9963/adc_rst    util_cpack_ad9963/adc_rst
ad_connect axi_ad9963/adc_rst    adc_trigger_fifo/rst

ad_connect axi_adc_decimate/adc_data_a axi_ad9963/adc_data_i
ad_connect axi_adc_decimate/adc_data_b axi_ad9963/adc_data_q
ad_connect axi_adc_decimate/adc_valid_a axi_ad9963/adc_valid_i
ad_connect axi_adc_decimate/adc_valid_b axi_ad9963/adc_valid_q

#ad_connect axi_ad9963/adc_enable_i        util_cpack_ad9963/adc_enable_0
#ad_connect adc_trigger/data_valid_a_trig  util_cpack_ad9963/adc_valid_0
#ad_connect adc_trigger/data_a_trig        util_cpack_ad9963/adc_data_0
#ad_connect axi_ad9963/adc_enable_q        util_cpack_ad9963/adc_enable_1
#ad_connect adc_trigger/data_valid_b_trig  util_cpack_ad9963/adc_valid_1
#ad_connect adc_trigger/data_b_trig        util_cpack_ad9963/adc_data_1

#ad_connect adc_trigger_fifo/data_in        util_cpack_ad9963/adc_data
#ad_connect adc_trigger_fifo/data_in_valid  util_cpack_ad9963/adc_valid
#ad_connect util_cpack_ad9963/adc_data      adc_trigger_extract/data_in_trigger

ad_connect adc_trigger_fifo/din_w       bram_adc/dina
ad_connect adc_trigger_fifo/en_w        bram_adc/ena
ad_connect adc_trigger_fifo/wea_w       bram_adc/wea
ad_connect adc_trigger_fifo/addr_w      bram_adc/addra
ad_connect bram_adc/addrb               adc_trigger_fifo/addr_r
ad_connect bram_adc/doutb               adc_trigger_fifo/dout_r
ad_connect bram_adc/enb                 adc_trigger_fifo/en_r

ad_connect adc_trigger/data_a_trig       ad9963_adc_concat/In0
ad_connect adc_trigger/data_b_trig       ad9963_adc_concat/In1
ad_connect adc_trigger/data_valid_a_trig adc_trigger_fifo/data_in_valid
ad_connect ad9963_adc_concat/dout        adc_trigger_fifo/data_in
ad_connect axi_ad9963/adc_rst            adc_trigger/reset

ad_connect adc_trigger_fifo/depth        adc_trigger/fifo_depth

ad_connect adc_trigger/trigger_in        logic_analyzer/trigger_out_adc

ad_connect adc_trigger_fifo/data_out        ad9963_adc_dmac/fifo_wr_din
ad_connect adc_trigger/trigger_out          ad9963_adc_dmac/fifo_wr_sync
ad_connect adc_trigger_fifo/data_out_valid  ad9963_adc_dmac/fifo_wr_en

ad_connect axi_dac_interpolate/dac_clk      axi_ad9963/dac_clk
ad_connect axi_dac_interpolate/dac_rst      axi_ad9963/dac_rst

ad_connect axi_dac_interpolate/dac_valid_a      axi_ad9963/dac_valid_i
ad_connect axi_dac_interpolate/dac_valid_b      axi_ad9963/dac_valid_q
ad_connect axi_dac_interpolate/dac_int_data_a   axi_ad9963/dac_data_i
ad_connect axi_dac_interpolate/dac_int_data_b   axi_ad9963/dac_data_q

ad_connect ad9963_dac_dmac_a/fifo_rd_clk axi_ad9963/dac_clk
ad_connect ad9963_dac_dmac_b/fifo_rd_clk axi_ad9963/dac_clk

ad_connect axi_dac_interpolate/dac_data_a         ad9963_dac_dmac_a/fifo_rd_dout
ad_connect axi_dac_interpolate/dac_int_valid_a    ad9963_dac_dmac_a/fifo_rd_en
ad_connect ad9963_dac_dmac_a/fifo_rd_valid        axi_dac_interpolate/dma_valid_a
ad_connect axi_dac_interpolate/dac_data_b         ad9963_dac_dmac_b/fifo_rd_dout
ad_connect axi_dac_interpolate/dac_int_valid_b    ad9963_dac_dmac_b/fifo_rd_en
ad_connect ad9963_dac_dmac_b/fifo_rd_valid        axi_dac_interpolate/dma_valid_b

ad_connect axi_dac_interpolate/trigger_i   trigger_i
ad_connect axi_dac_interpolate/trigger_adc adc_trigger/trigger_out_la
ad_connect axi_dac_interpolate/trigger_la  logic_analyzer/trigger_out_adc

ad_connect /axi_ad9963/tx_data    txd
ad_connect /axi_ad9963/tx_iq      txiq
ad_connect /axi_ad9963/tx_clk     tx_clk
ad_connect /axi_ad9963/trx_data   rxd
ad_connect /axi_ad9963/trx_clk    rx_clk
ad_connect /axi_ad9963/trx_iq     rxiq

ad_connect adc_trigger/data_a axi_adc_decimate/adc_dec_data_a
ad_connect adc_trigger/data_valid_a axi_adc_decimate/adc_dec_valid_a
ad_connect adc_trigger/data_b axi_adc_decimate/adc_dec_data_b
ad_connect adc_trigger/data_valid_b axi_adc_decimate/adc_dec_valid_b

ad_connect adc_trigger/clk axi_ad9963/adc_clk
ad_connect trigger_i adc_trigger/trigger_i
ad_connect trigger_o adc_trigger/trigger_o
ad_connect trigger_t adc_trigger/trigger_t

ad_connect axi_ad9963/dac_sync_in axi_ad9963/dac_sync_out
ad_connect axi_ad9963/adc_dovf    ad9963_adc_dmac/fifo_wr_overflow
ad_connect axi_ad9963/dac_dunf    ad9963_dac_dmac_a/fifo_rd_underflow

# interconnects

#ad_cpu_interconnect 0x70000000 clk_generator
ad_cpu_interconnect 0x70100000 logic_analyzer
ad_cpu_interconnect 0x70200000 axi_ad9963
ad_cpu_interconnect 0x7C400000 logic_analyzer_dmac
ad_cpu_interconnect 0x7C420000 pattern_generator_dmac
ad_cpu_interconnect 0x7C440000 ad9963_adc_dmac
ad_cpu_interconnect 0x7C460000 ad9963_dac_dmac_b
ad_cpu_interconnect 0x7C480000 ad9963_dac_dmac_a
ad_cpu_interconnect 0x7C4c0000 adc_trigger
ad_cpu_interconnect 0x7C500000 axi_adc_decimate
ad_cpu_interconnect 0x7C5a0000 axi_dac_interpolate

# Logic analyzer DMA
ad_connect sys_cpu_clk axi_rd_wr_combiner_logic/clk
ad_connect sys_cpu_clk logic_analyzer_dmac/m_dest_axi_aclk
ad_connect sys_cpu_clk pattern_generator_dmac/m_src_axi_aclk

ad_connect logic_analyzer_dmac/m_dest_axi axi_rd_wr_combiner_logic/s_wr_axi
ad_connect pattern_generator_dmac/m_src_axi axi_rd_wr_combiner_logic/s_rd_axi

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 {1}
ad_connect sys_cpu_clk sys_ps7/S_AXI_HP1_ACLK
ad_connect axi_rd_wr_combiner_logic/m_axi sys_ps7/S_AXI_HP1

# Converter DMA
ad_connect converter_dma_clk axi_rd_wr_combiner_converter/clk
ad_connect converter_dma_clk ad9963_adc_dmac/m_dest_axi_aclk
ad_connect converter_dma_clk ad9963_dac_dmac_a/m_src_axi_aclk

ad_connect ad9963_adc_dmac/m_dest_axi axi_rd_wr_combiner_converter/s_wr_axi
ad_connect ad9963_dac_dmac_a/m_src_axi axi_rd_wr_combiner_converter/s_rd_axi

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 {1}
ad_connect converter_dma_clk sys_ps7/S_AXI_HP2_ACLK
ad_connect axi_rd_wr_combiner_converter/m_axi sys_ps7/S_AXI_HP2

# Only 16-bit we can run at a slower clock
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP3 {1}

ad_connect sys_cpu_clk sys_ps7/S_AXI_HP3_ACLK
ad_connect sys_cpu_clk ad9963_dac_dmac_b/m_src_axi_aclk
ad_connect ad9963_dac_dmac_b/m_src_axi sys_ps7/S_AXI_HP3

create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces ad9963_dac_dmac_b/m_src_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_sys_ps7_HP3_DDR_LOWOCM

# Map rd-wr combiner
assign_bd_address [get_bd_addr_segs { \
  axi_rd_wr_combiner_converter/s_rd_axi/reg0 \
  axi_rd_wr_combiner_converter/s_wr_axi/reg0 \
  axi_rd_wr_combiner_logic/s_rd_axi/reg0 \
  axi_rd_wr_combiner_logic/s_wr_axi/reg0 \
}]

set_property range 512M [get_bd_addr_segs { \
  ad9963_dac_dmac_a/m_src_axi/SEG_axi_rd_wr_combiner_converter_reg0 \
  ad9963_adc_dmac/m_dest_axi/SEG_axi_rd_wr_combiner_converter_reg0 \
  pattern_generator_dmac/m_src_axi/SEG_axi_rd_wr_combiner_logic_reg0 \
  logic_analyzer_dmac/m_dest_axi/SEG_axi_rd_wr_combiner_logic_reg0 \
}]

ad_connect  sys_cpu_resetn logic_analyzer_dmac/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn pattern_generator_dmac/m_src_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_adc_dmac/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_dac_dmac_a/m_src_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_dac_dmac_b/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 logic_analyzer_dmac/irq
ad_cpu_interrupt ps-12 mb-13 pattern_generator_dmac/irq
ad_cpu_interrupt ps-10 mb-14 ad9963_adc_dmac/irq
ad_cpu_interrupt ps-9 mb-15 ad9963_dac_dmac_a/irq
ad_cpu_interrupt ps-8 mb-16 ad9963_dac_dmac_b/irq
