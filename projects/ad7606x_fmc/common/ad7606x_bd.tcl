###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# system level parameters
set DEV_CONFIG $ad_project_params(DEV_CONFIG)
set ADC_N_BITS [expr {$DEV_CONFIG == 2 ? 18 : 16}]
set ADC_CH_DW [expr {$ADC_N_BITS == 16 ? 16 : 32}]
set EXT_CLK $ad_project_params(EXT_CLK)
set TOTAL_N_BITS_DMA [expr {$ADC_CH_DW*8}]

puts "build parameters: DEV_CONFIG: $DEV_CONFIG"
puts "build parameters: EXT_CLK: $EXT_CLK"

# data, read and write lines

create_bd_port -dir O -from 15 -to 0 rx_db_o
create_bd_port -dir I -from 15 -to 0 rx_db_i
create_bd_port -dir O rx_db_t
create_bd_port -dir O rx_rd_n
create_bd_port -dir O rx_wr_n

# control lines

create_bd_port -dir I rx_busy
create_bd_port -dir O rx_cnvst_n
create_bd_port -dir O rx_cs_n
create_bd_port -dir I rx_first_data

# instantiation

ad_ip_instance axi_ad7606x axi_ad7606x
ad_ip_parameter axi_ad7606x CONFIG.DEV_CONFIG $DEV_CONFIG
ad_ip_parameter axi_ad7606x CONFIG.ADC_N_BITS $ADC_N_BITS
ad_ip_parameter axi_ad7606x CONFIG.ADC_CH_DW $ADC_CH_DW
ad_ip_parameter axi_ad7606x CONFIG.EXTERNAL_CLK $EXT_CLK

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.ASYNC_CLK_EN 0
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 1
if {$DEV_CONFIG == 0} { 
  ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 124
  ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 125
} else {
  ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 99
  ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 100
} 

ad_ip_instance axi_dmac axi_ad7606x_dma
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7606x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_DATA_WIDTH_SRC $TOTAL_N_BITS_DMA
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_cpack2 ad7606x_adc_pack
ad_ip_parameter ad7606x_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad7606x_adc_pack CONFIG.SAMPLE_DATA_WIDTH $ADC_CH_DW

if {$EXT_CLK == 1} {
  # use Xilinx's clocking wizard in order to generate th clock from the CPU clock, this being then assigned to the adc_clk in the axi_ad7606x IP
  ad_ip_instance clk_wiz adc_clk_generator
  ad_ip_parameter adc_clk_generator CONFIG.PRIMITIVE PLL
  ad_ip_parameter adc_clk_generator CONFIG.RESET_TYPE ACTIVE_LOW
  ad_ip_parameter adc_clk_generator CONFIG.USE_LOCKED false
  ad_ip_parameter adc_clk_generator CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 100.000
  ad_ip_parameter adc_clk_generator CONFIG.CLKOUT1_REQUESTED_PHASE 0.000
  ad_ip_parameter adc_clk_generator CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE 50.000
  ad_ip_parameter adc_clk_generator CONFIG.PRIM_SOURCE Global_buffer
  ad_ip_parameter adc_clk_generator CONFIG.CLKIN1_UI_JITTER 0
  ad_ip_parameter adc_clk_generator CONFIG.PRIM_IN_FREQ 100.000 

  ad_connect  sys_cpu_clk adc_clk_generator/clk_in1
  ad_connect  sys_cpu_resetn adc_clk_generator/resetn
  ad_connect  adc_clk_generator/clk_out1 axi_ad7606x/external_clk
} else {
  ad_connect  sys_cpu_clk axi_ad7606x/external_clk
}

# interface connections

ad_connect  rx_db_o axi_ad7606x/rx_db_o
ad_connect  rx_db_i axi_ad7606x/rx_db_i
ad_connect  rx_db_t axi_ad7606x/rx_db_t
ad_connect  rx_rd_n axi_ad7606x/rx_rd_n
ad_connect  rx_wr_n axi_ad7606x/rx_wr_n

ad_connect  rx_cs_n axi_ad7606x/rx_cs_n
ad_connect  rx_cnvst_n axi_pwm_gen/pwm_0
ad_connect  rx_busy axi_ad7606x/rx_busy
ad_connect  rx_first_data axi_ad7606x/first_data

ad_connect  sys_cpu_clk axi_ad7606x_dma/s_axi_aclk
ad_connect  sys_cpu_clk axi_pwm_gen/s_axi_aclk
ad_connect  sys_cpu_resetn axi_pwm_gen/s_axi_aresetn

ad_connect  axi_ad7606x/adc_clk ad7606x_adc_pack/clk
ad_connect  axi_ad7606x/adc_clk axi_ad7606x_dma/fifo_wr_clk
ad_connect  axi_ad7606x/adc_reset ad7606x_adc_pack/reset
ad_connect  axi_ad7606x/adc_valid ad7606x_adc_pack/fifo_wr_en
ad_connect  ad7606x_adc_pack/packed_fifo_wr axi_ad7606x_dma/fifo_wr
ad_connect  ad7606x_adc_pack/fifo_wr_overflow axi_ad7606x/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad7606x/adc_data_$i ad7606x_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad7606x/adc_enable_$i ad7606x_adc_pack/enable_$i
}

# interconnect

ad_cpu_interconnect  0x44A00000 axi_ad7606x
ad_cpu_interconnect  0x44A30000 axi_ad7606x_dma
ad_cpu_interconnect  0x44A60000 axi_pwm_gen

# memory interconnect

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad7606x_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_ad7606x_dma/m_dest_axi_aresetn

#interrupt

ad_cpu_interrupt ps-13 mb-12 axi_ad7606x_dma/irq
