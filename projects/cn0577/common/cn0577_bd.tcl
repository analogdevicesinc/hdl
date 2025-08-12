###############################################################################
## Copyright (C) 2022-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# env params

set ADC_RES $ad_project_params(ADC_RES);    # ADC resolution; default 18 bits
if {$ADC_RES == 16} {
  set OUT_RES 16
} else {
  # if ADC_RES == 18
  set OUT_RES 32
}
set TWOLANES $ad_project_params(TWOLANES);  # two-lane mode (1) or one-lane mode (0); default two-lane

# ltc2387 i/o

create_bd_port -dir I ref_clk
create_bd_port -dir O sampling_clk
create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir O cnv
create_bd_port -dir I da_p
create_bd_port -dir I da_n
create_bd_port -dir I db_p
create_bd_port -dir I db_n
create_bd_port -dir O clk_gate

# adc peripheral

ad_ip_instance axi_ltc2387 axi_ltc2387
ad_ip_parameter axi_ltc2387 CONFIG.ADC_RES $ADC_RES
ad_ip_parameter axi_ltc2387 CONFIG.OUT_RES $OUT_RES
ad_ip_parameter axi_ltc2387 CONFIG.TWOLANES $TWOLANES
ad_ip_parameter axi_ltc2387 CONFIG.ADC_INIT_DELAY 27

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 2
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

# dma

ad_ip_instance axi_dmac axi_ltc2387_dma
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_SRC $OUT_RES
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connections

ad_connect ref_clk sampling_clk

ad_connect sys_200m_clk axi_ltc2387/delay_clk

ad_connect ref_clk    axi_ltc2387/ref_clk
ad_connect clk_gate   axi_ltc2387/clk_gate
ad_connect dco_p      axi_ltc2387/dco_p
ad_connect dco_n      axi_ltc2387/dco_n
ad_connect da_p       axi_ltc2387/da_p
ad_connect da_n       axi_ltc2387/da_n
ad_connect db_p       axi_ltc2387/db_p
ad_connect db_n       axi_ltc2387/db_n

ad_connect ref_clk                axi_ltc2387_dma/fifo_wr_clk
ad_connect axi_ltc2387/adc_valid  axi_ltc2387_dma/fifo_wr_en
ad_connect axi_ltc2387/adc_data   axi_ltc2387_dma/fifo_wr_din
ad_connect axi_ltc2387/adc_dovf   axi_ltc2387_dma/fifo_wr_overflow

ad_connect cnv               axi_pwm_gen/pwm_0
ad_connect clk_gate          axi_pwm_gen/pwm_1
ad_connect ref_clk           axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn    axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk       axi_pwm_gen/s_axi_aclk

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ltc2387
ad_cpu_interconnect 0x44A30000 axi_ltc2387_dma
ad_cpu_interconnect 0x44A60000 axi_pwm_gen

# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ltc2387_dma/m_dest_axi
ad_connect $sys_cpu_resetn axi_ltc2387_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ltc2387_dma/irq
