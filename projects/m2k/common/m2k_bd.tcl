
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

set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK3_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {27.778}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {55.556}] $sys_ps7

ad_connect logic_analyzer_clk_in sys_ps7/FCLK_CLK2
ad_connect converter_dma_clk sys_ps7/FCLK_CLK3

set logic_analyzer [create_bd_cell -type ip -vlnv analog.com:user:axi_logic_analyzer:1.0 logic_analyzer]

set la_trigger_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_var_fifo:1.0 la_trigger_fifo]
set_property -dict [list CONFIG.DATA_WIDTH {16} ] $la_trigger_fifo
set_property -dict [list CONFIG.ADDRESS_WIDTH {13} ] $la_trigger_fifo

set bram_la [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 bram_la]
set_property -dict [list CONFIG.use_bram_block {Stand_Alone}] $bram_la
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM}] $bram_la
set_property -dict [list CONFIG.Assume_Synchronous_Clk {true}] $bram_la
set_property -dict [list CONFIG.Algorithm {Low_Power}] $bram_la
set_property -dict [list CONFIG.Use_Byte_Write_Enable {false}] $bram_la
set_property -dict [list CONFIG.Operating_Mode_A {NO_CHANGE}] $bram_la
set_property -dict [list CONFIG.Register_PortB_Output_of_Memory_Primitives {true}] $bram_la
set_property -dict [list CONFIG.Use_RSTA_Pin {false} CONFIG.Port_B_Clock {100}] $bram_la
set_property -dict [list CONFIG.Port_B_Enable_Rate {100}] $bram_la
set_property -dict [list CONFIG.Write_Width_A {16}] $bram_la
set_property -dict [list CONFIG.Write_Width_B {16}] $bram_la
set_property -dict [list CONFIG.Read_Width_B {16}] $bram_la
set_property -dict [list CONFIG.Write_Depth_A {8192}] $bram_la

set logic_analyzer_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 logic_analyzer_dmac]
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {16} ] $logic_analyzer_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_DEST {1} ] $logic_analyzer_dmac
set_property -dict [list CONFIG.SYNC_TRANSFER_START {true} ] $logic_analyzer_dmac
set_property -dict [list CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG] $logic_analyzer_dmac

set pattern_generator_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 pattern_generator_dmac]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2} ] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $pattern_generator_dmac
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {128}] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16} ] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $pattern_generator_dmac
set_property -dict [list CONFIG.CYCLIC {true}] $pattern_generator_dmac
set_property -dict [list CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG] $pattern_generator_dmac

set axi_ad9963 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9963:1.0 axi_ad9963]
set_property -dict [list CONFIG.DAC_DATAPATH_DISABLE {1}] $axi_ad9963
set_property -dict [list CONFIG.ADC_DATAPATH_DISABLE {1}] $axi_ad9963

set adc_trigger_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_var_fifo:1.0 adc_trigger_fifo]
set_property -dict [list CONFIG.DATA_WIDTH {32} ] $adc_trigger_fifo
set_property -dict [list CONFIG.ADDRESS_WIDTH {13} ] $adc_trigger_fifo

set bram_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 bram_adc]
set_property -dict [list CONFIG.use_bram_block {Stand_Alone}] $bram_adc
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM}] $bram_adc
set_property -dict [list CONFIG.Assume_Synchronous_Clk {true}] $bram_adc
set_property -dict [list CONFIG.Algorithm {Low_Power}] $bram_adc
set_property -dict [list CONFIG.Enable_32bit_Address {false}] $bram_adc
set_property -dict [list CONFIG.Use_Byte_Write_Enable {false}] $bram_adc
set_property -dict [list CONFIG.Operating_Mode_A {NO_CHANGE}] $bram_adc
set_property -dict [list CONFIG.Register_PortB_Output_of_Memory_Primitives {true}] $bram_adc
set_property -dict [list CONFIG.Use_RSTA_Pin {false} CONFIG.Port_B_Clock {100}] $bram_adc
set_property -dict [list CONFIG.Port_B_Enable_Rate {100}] $bram_adc
set_property -dict [list CONFIG.Write_Width_A {32}] $bram_adc
set_property -dict [list CONFIG.Write_Width_B {32}] $bram_adc
set_property -dict [list CONFIG.Read_Width_B {32}] $bram_adc
set_property -dict [list CONFIG.Write_Depth_A {8192}] $bram_adc

set adc_trigger_extract [create_bd_cell -type ip -vlnv analog.com:user:util_extract:1.0 adc_trigger_extract]

# FIXME: Bring this back eventually
#set util_cpack_ad9963 [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_cpack_ad9963]
#set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_cpack_ad9963
#set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_cpack_ad9963

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ad9963_adc_concat

set ad9963_adc_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_adc_dmac]
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $ad9963_adc_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_DEST {1}] $ad9963_adc_dmac
set_property -dict [list CONFIG.SYNC_TRANSFER_START {true}]  $ad9963_adc_dmac
set_property -dict [list CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG] $ad9963_adc_dmac

set ad9963_dac_dmac_a [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_dac_dmac_a]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {128}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.CYCLIC {true}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG] $ad9963_dac_dmac_a

set ad9963_dac_dmac_b [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_dac_dmac_b]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {128}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.CYCLIC {true}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG] $ad9963_dac_dmac_b

set adc_trigger [create_bd_cell -type ip -vlnv analog.com:user:axi_adc_trigger:1.0 adc_trigger]

set axi_adc_decimate [create_bd_cell -type ip -vlnv analog.com:user:axi_adc_decimate:1.0 axi_adc_decimate]
set axi_dac_interpolate [create_bd_cell -type ip -vlnv analog.com:user:axi_dac_interpolate:1.0 axi_dac_interpolate]

set logic_analyzer_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 logic_analyzer_reset]

set axi_rd_wr_combiner_logic [create_bd_cell -type ip -vlnv analog.com:user:axi_rd_wr_combiner:1.0 axi_rd_wr_combiner_logic]
set axi_rd_wr_combiner_converter [create_bd_cell -type ip -vlnv analog.com:user:axi_rd_wr_combiner:1.0 axi_rd_wr_combiner_converter]

ad_connect data_i     logic_analyzer/data_i
ad_connect trigger_i  logic_analyzer/trigger_i
ad_connect data_o     logic_analyzer/data_o
ad_connect data_t     logic_analyzer/data_t

ad_connect logic_analyzer_clk_in logic_analyzer/clk
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

ad_connect logic_analyzer/trigger_offset la_trigger_fifo/depth

ad_connect logic_analyzer/trigger_out logic_analyzer_dmac/fifo_wr_sync

ad_connect pattern_generator_dmac/fifo_rd_en      logic_analyzer/dac_read
ad_connect pattern_generator_dmac/fifo_rd_dout    logic_analyzer/dac_data
ad_connect pattern_generator_dmac/fifo_rd_valid   logic_analyzer/dac_valid


ad_connect axi_ad9963/adc_clk  adc_trigger_fifo/clk
#ad_connect axi_ad9963/adc_clk  util_cpack_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_clk axi_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_rst axi_ad9963/adc_rst

ad_connect adc_trigger_extract/clk         axi_ad9963/adc_clk
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
ad_connect ad9963_adc_concat/dout        adc_trigger_extract/data_in_trigger

ad_connect adc_trigger_fifo/depth          adc_trigger/trigger_offset

ad_connect adc_trigger_fifo/data_out       adc_trigger_extract/data_in
ad_connect adc_trigger_fifo/data_out_valid adc_trigger_extract/data_valid

ad_connect adc_trigger_extract/data_out     ad9963_adc_dmac/fifo_wr_din
ad_connect adc_trigger_extract/trigger_out  ad9963_adc_dmac/fifo_wr_sync
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
ad_connect axi_dac_interpolate/dac_data_b         ad9963_dac_dmac_b/fifo_rd_dout
ad_connect axi_dac_interpolate/dac_int_valid_b    ad9963_dac_dmac_b/fifo_rd_en

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

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_rd_wr_combiner_logic/m_axi

# Converter DMA
ad_connect converter_dma_clk axi_rd_wr_combiner_converter/clk
ad_connect converter_dma_clk ad9963_adc_dmac/m_dest_axi_aclk
ad_connect converter_dma_clk ad9963_dac_dmac_a/m_src_axi_aclk

ad_connect ad9963_adc_dmac/m_dest_axi axi_rd_wr_combiner_converter/s_wr_axi
ad_connect ad9963_dac_dmac_a/m_src_axi axi_rd_wr_combiner_converter/s_rd_axi

ad_mem_hp2_interconnect converter_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect converter_dma_clk axi_rd_wr_combiner_converter/m_axi

# Only 16-bit we can run at a slower clock
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk ad9963_dac_dmac_b/m_src_axi

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

