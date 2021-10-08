
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/fmcomms2_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_port -dir I -from 0 -to 0 debug_btn_trig_ext


# instances

ad_ip_instance axi_dmac trigger_dmac
ad_ip_parameter trigger_dmac CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter trigger_dmac CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter trigger_dmac CONFIG.CYCLIC 0
ad_ip_parameter trigger_dmac CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter trigger_dmac CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter trigger_dmac CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter trigger_dmac CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter trigger_dmac CONFIG.DMA_DATA_WIDTH_SRC 64


# util cpack trigger

ad_ip_instance util_cpack2 util_cpack_trigger { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}


# axi trigger

ad_ip_instance axi_trigger axi_trigger
ad_ip_parameter axi_trigger CONFIG.DW0 16
ad_ip_parameter axi_trigger CONFIG.DW1 16
ad_ip_parameter axi_trigger CONFIG.DW2 16
ad_ip_parameter axi_trigger CONFIG.DW3 16


# connections ---------------------------------------------------------------------------

# trigger_dmac
ad_connect util_cpack_trigger/packed_fifo_wr              trigger_dmac/fifo_wr
ad_connect util_ad9361_divclk/clk_out                     trigger_dmac/fifo_wr_clk
ad_connect axi_trigger/trigger_out                        trigger_dmac/fifo_wr_sync
ad_connect $sys_cpu_resetn                                trigger_dmac/m_dest_axi_aresetn

# util_cpack_trigger
ad_connect util_ad9361_divclk/clk_out                     util_cpack_trigger/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset      util_cpack_trigger/reset
ad_connect util_ad9361_adc_fifo/dout_data_0               util_cpack_trigger/fifo_wr_data_0
ad_connect util_ad9361_adc_fifo/dout_data_1               util_cpack_trigger/fifo_wr_data_1
ad_connect util_ad9361_adc_fifo/dout_data_2               util_cpack_trigger/fifo_wr_data_2
ad_connect util_ad9361_adc_fifo/dout_data_3               util_cpack_trigger/fifo_wr_data_3
#ad_connect axi_trigger/data_out0                          util_cpack_trigger/fifo_wr_data_0
#ad_connect axi_trigger/data_out1                          util_cpack_trigger/fifo_wr_data_1
#ad_connect axi_trigger/data_out2                          util_cpack_trigger/fifo_wr_data_2
#ad_connect axi_trigger/data_out3                          util_cpack_trigger/fifo_wr_data_3
ad_connect util_ad9361_adc_fifo/dout_valid_0               util_cpack_trigger/fifo_wr_en

ad_connect util_ad9361_adc_fifo/dout_enable_0             util_cpack_trigger/enable_0
ad_connect util_ad9361_adc_fifo/dout_enable_1             util_cpack_trigger/enable_1
ad_connect util_ad9361_adc_fifo/dout_enable_2             util_cpack_trigger/enable_2
ad_connect util_ad9361_adc_fifo/dout_enable_3             util_cpack_trigger/enable_3

# axi_trigger
ad_connect util_ad9361_divclk/clk_out                     axi_trigger/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset      axi_trigger/rst
ad_connect debug_btn_trig_ext                             axi_trigger/trigger_ext
ad_connect sys_rstgen/peripheral_aresetn                  axi_trigger/s_axi_aresetn
ad_connect util_ad9361_adc_fifo/dout_data_0               axi_trigger/data_in0
ad_connect util_ad9361_adc_fifo/dout_data_1               axi_trigger/data_in1
ad_connect util_ad9361_adc_fifo/dout_data_2               axi_trigger/data_in2
ad_connect util_ad9361_adc_fifo/dout_data_3               axi_trigger/data_in3

# interconnects
ad_cpu_interconnect 0x43C00000 axi_trigger
ad_cpu_interconnect 0x43C10000 trigger_dmac
ad_mem_hp1_interconnect $sys_cpu_clk trigger_dmac/m_dest_axi


# system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 23

ad_ip_parameter axi_ad9361 CONFIG.TDD_DISABLE 1


# interrupts
ad_cpu_interrupt ps-10 mb-11 trigger_dmac/irq

set top_ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 top_ila]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $top_ila
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $top_ila
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $top_ila
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $top_ila
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $top_ila

ad_connect top_ila/clk util_ad9361_divclk/clk_out
ad_connect top_ila/probe0 axi_trigger/trigger_out
ad_connect top_ila/probe1 util_ad9361_adc_fifo/dout_data_0
