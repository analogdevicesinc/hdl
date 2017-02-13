
create_bd_port -dir I -from 15 -to 0  data_i
create_bd_port -dir I -from  1 -to 0  trigger_i

create_bd_port -dir O -from 15 -to 0 data_o
create_bd_port -dir O -from 15 -to 0 data_t
create_bd_port -dir O -from  1 -to 0 trigger_o
create_bd_port -dir O -from  1 -to 0 trigger_t

create_bd_port -dir I rx_clk
create_bd_port -dir I rxiq
create_bd_port -dir I -from 11 -to 0 rxd
create_bd_port -dir O tx_clk
create_bd_port -dir O txiq
create_bd_port -dir O -from 11 -to 0 txd

set clk_generator [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 clk_generator]
set_property -dict [list CONFIG.VCO_DIV {1}] $clk_generator
set_property -dict [list CONFIG.VCO_MUL {8}] $clk_generator
set_property -dict [list CONFIG.CLK0_DIV {10}] $clk_generator
set_property -dict [list CONFIG.CLK1_DIV {5}] $clk_generator
set_property -dict [list CONFIG.CLK0_PHASE {180}] $clk_generator
set_property -dict [list CONFIG.CLK1_PHASE {180}] $clk_generator
set_property -dict [list CONFIG.CLKIN_PERIOD {10}] $clk_generator
set_property -dict [list CONFIG.CLKIN2_PERIOD {12.5}] $clk_generator

set logic_analyzer [create_bd_cell -type ip -vlnv analog.com:user:axi_logic_analyzer:1.0 logic_analyzer]

set la_trigger_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_var_fifo:1.0 la_trigger_fifo]
set_property -dict [list CONFIG.DATA_WIDTH {16} ] $la_trigger_fifo
set_property -dict [list CONFIG.ADDRESS_WIDTH {13} ] $la_trigger_fifo

set logic_analyzer_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 logic_analyzer_dmac]
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {16} ] $logic_analyzer_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_DEST {1} ] $logic_analyzer_dmac
set_property -dict [list CONFIG.SYNC_TRANSFER_START {true} ] $logic_analyzer_dmac

set pattern_generator_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 pattern_generator_dmac]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2} ] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $pattern_generator_dmac
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {32}] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16} ] $pattern_generator_dmac
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $pattern_generator_dmac
set_property -dict [list CONFIG.CYCLIC {true}] $pattern_generator_dmac

set axi_ad9963 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9963:1.0 axi_ad9963]

set adc_trigger_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_var_fifo:1.0 adc_trigger_fifo]
set_property -dict [list CONFIG.DATA_WIDTH {32} ] $adc_trigger_fifo
set_property -dict [list CONFIG.ADDRESS_WIDTH {13} ] $adc_trigger_fifo

set adc_trigger_extract [create_bd_cell -type ip -vlnv analog.com:user:util_extract:1.0 adc_trigger_extract]

set util_cpack_ad9963 [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_cpack_ad9963]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $util_cpack_ad9963
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_cpack_ad9963

set ad9963_adc_dmac [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_adc_dmac]
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $ad9963_adc_dmac
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_DEST {1}] $ad9963_adc_dmac
set_property -dict [list CONFIG.SYNC_TRANSFER_START {true}]  $ad9963_adc_dmac

set ad9963_dac_dmac_a [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_dac_dmac_a]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {64}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.CYCLIC {true}] $ad9963_dac_dmac_a

set ad9963_dac_dmac_b [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad9963_dac_dmac_b]
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_SRC {1}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.MAX_BYTES_PER_BURST {64}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16}] $ad9963_dac_dmac_b
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $ad9963_dac_dmac_a
set_property -dict [list CONFIG.CYCLIC {true}] $ad9963_dac_dmac_b

set adc_trigger [create_bd_cell -type ip -vlnv analog.com:user:axi_adc_trigger:1.0 adc_trigger]

set axi_adc_decimate [create_bd_cell -type ip -vlnv analog.com:user:axi_adc_decimate:1.0 axi_adc_decimate]
set axi_dac_interpolate [create_bd_cell -type ip -vlnv analog.com:user:axi_dac_interpolate:1.0 axi_dac_interpolate]

set logic_analyzer_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 logic_analyzer_reset]


ad_connect data_i     logic_analyzer/data_i
ad_connect trigger_i  logic_analyzer/trigger_i
ad_connect data_o     logic_analyzer/data_o
ad_connect data_t     logic_analyzer/data_t

ad_connect sys_cpu_clk            clk_generator/clk
#ad_connect logic_analyzer/clk_out clk_generator/clk2

ad_connect logic_analyzer/clk     clk_generator/clk_0

ad_connect pattern_generator_dmac/fifo_rd_clk clk_generator/clk_0

ad_connect clk_generator/clk_0  la_trigger_fifo/clk
ad_connect logic_analyzer_dmac/fifo_wr_clk clk_generator/clk_0
ad_connect logic_analyzer_reset/slowest_sync_clk clk_generator/clk_0
ad_connect logic_analyzer_reset/ext_reset_in sys_rstgen/peripheral_aresetn
ad_connect logic_analyzer_reset/bus_struct_reset la_trigger_fifo/rst

ad_connect la_trigger_fifo/data_in        logic_analyzer/adc_data
ad_connect la_trigger_fifo/data_in_valid  logic_analyzer/adc_valid

ad_connect logic_analyzer_dmac/fifo_wr_din la_trigger_fifo/data_out
ad_connect logic_analyzer_dmac/fifo_wr_en  la_trigger_fifo/data_out_valid

ad_connect logic_analyzer/trigger_offset la_trigger_fifo/depth

ad_connect logic_analyzer/trigger_out logic_analyzer_dmac/fifo_wr_sync

ad_connect pattern_generator_dmac/fifo_rd_en      logic_analyzer/dac_read
ad_connect pattern_generator_dmac/fifo_rd_dout    logic_analyzer/dac_data
ad_connect pattern_generator_dmac/fifo_rd_valid   logic_analyzer/dac_valid


ad_connect sys_cpu_clk logic_analyzer/s_axi_aclk
ad_connect sys_cpu_resetn logic_analyzer/s_axi_aresetn

ad_connect sys_200m_clk             axi_ad9963/delay_clk

ad_connect axi_ad9963/l_clk  adc_trigger_fifo/clk
ad_connect axi_ad9963/l_clk  util_cpack_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_clk axi_ad9963/l_clk
ad_connect adc_trigger_extract/clk         axi_ad9963/l_clk
ad_connect ad9963_adc_dmac/fifo_wr_clk     axi_ad9963/l_clk

ad_connect axi_ad9963/rst    util_cpack_ad9963/adc_rst
ad_connect axi_ad9963/rst    adc_trigger_fifo/rst

ad_connect axi_adc_decimate/adc_data_a axi_ad9963/adc_data_i
ad_connect axi_adc_decimate/adc_data_b axi_ad9963/adc_data_q
ad_connect axi_adc_decimate/adc_valid_a axi_ad9963/adc_valid_i
ad_connect axi_adc_decimate/adc_valid_b axi_ad9963/adc_valid_q

ad_connect axi_ad9963/adc_enable_i        util_cpack_ad9963/adc_enable_0
ad_connect adc_trigger/data_valid_a_trig  util_cpack_ad9963/adc_valid_0
ad_connect adc_trigger/data_a_trig        util_cpack_ad9963/adc_data_0
ad_connect axi_ad9963/adc_enable_q        util_cpack_ad9963/adc_enable_1
ad_connect adc_trigger/data_valid_b_trig  util_cpack_ad9963/adc_valid_1
ad_connect adc_trigger/data_b_trig        util_cpack_ad9963/adc_data_1

ad_connect adc_trigger_fifo/data_in        util_cpack_ad9963/adc_data
ad_connect adc_trigger_fifo/data_in_valid  util_cpack_ad9963/adc_valid
ad_connect adc_trigger_fifo/depth          adc_trigger/trigger_offset

ad_connect adc_trigger_fifo/data_out       adc_trigger_extract/data_in
ad_connect adc_trigger_fifo/data_out_valid adc_trigger_extract/data_valid
ad_connect util_cpack_ad9963/adc_data      adc_trigger_extract/data_in_trigger

ad_connect adc_trigger_extract/data_out     ad9963_adc_dmac/fifo_wr_din
ad_connect adc_trigger_extract/trigger_out  ad9963_adc_dmac/fifo_wr_sync
ad_connect adc_trigger_fifo/data_out_valid  ad9963_adc_dmac/fifo_wr_en

ad_connect axi_dac_interpolate/dac_clk      axi_ad9963/dac_clk

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

ad_connect adc_trigger/clk axi_ad9963/l_clk
ad_connect trigger_i adc_trigger/trigger_i
ad_connect trigger_o adc_trigger/trigger_o
ad_connect trigger_t adc_trigger/trigger_t

ad_connect axi_ad9963/dac_sync_in axi_ad9963/dac_sync_out
ad_connect axi_ad9963/adc_dovf    ad9963_adc_dmac/fifo_wr_overflow
ad_connect axi_ad9963/dac_dunf    ad9963_dac_dmac_a/fifo_rd_underflow

# interconnects

ad_cpu_interconnect 0x70000000 clk_generator
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

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk logic_analyzer_dmac/m_dest_axi
ad_mem_hp1_interconnect sys_cpu_clk pattern_generator_dmac/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk ad9963_adc_dmac/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk ad9963_dac_dmac_a/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk ad9963_dac_dmac_b/m_src_axi
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

