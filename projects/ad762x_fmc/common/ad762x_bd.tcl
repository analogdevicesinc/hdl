###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ltc2387
create_bd_port -dir I ref_clk
create_bd_port -dir O sampling_clk
create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir O cnv
create_bd_port -dir I d_p
create_bd_port -dir I d_n
create_bd_port -dir O clk_gate

# adc peripheral

ad_ip_instance axi_ad762x axi_ad762x
ad_ip_parameter axi_ad762x CONFIG.ADC_INIT_DELAY 27

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 2
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 25
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 25
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

# dma

ad_ip_instance axi_dmac axi_ad762x_dma
ad_ip_parameter axi_ad762x_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad762x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad762x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad762x_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad762x_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad762x_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad762x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad762x_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad762x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi clk_gen

ad_ip_instance axi_clkgen reference_clkgen
ad_ip_parameter reference_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter reference_clkgen CONFIG.VCO_MUL 10
ad_ip_parameter reference_clkgen CONFIG.CLK0_DIV 8
ad_ip_parameter reference_clkgen CONFIG.CLK1_DIV 4

ad_connect reference_clkgen/clk   $sys_cpu_clk             
ad_connect reference_clkgen/clk_0 sampling_clk
ad_connect reference_clkgen/clk_0 axi_ad762x/ref_clk

# connections

ad_connect sys_200m_clk axi_ad762x/delay_clk

ad_connect clk_gate   axi_ad762x/clk_gate
ad_connect dco_p      axi_ad762x/dco_p
ad_connect dco_n      axi_ad762x/dco_n
ad_connect d_p       axi_ad762x/d_p
ad_connect d_n       axi_ad762x/d_n

ad_connect reference_clkgen/clk_0 axi_ad762x_dma/fifo_wr_clk
ad_connect axi_ad762x/adc_valid  axi_ad762x_dma/fifo_wr_en
ad_connect axi_ad762x/adc_data   axi_ad762x_dma/fifo_wr_din
ad_connect axi_ad762x/adc_dovf   axi_ad762x_dma/fifo_wr_overflow

ad_connect cnv                    axi_pwm_gen/pwm_0
ad_connect clk_gate               axi_pwm_gen/pwm_1
ad_connect reference_clkgen/clk_0 axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn         axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk            axi_pwm_gen/s_axi_aclk

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ad762x
ad_cpu_interconnect 0x44A30000 axi_ad762x_dma
ad_cpu_interconnect 0x44A60000 axi_pwm_gen
ad_cpu_interconnect 0x44a80000 reference_clkgen
# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad762x_dma/m_dest_axi
ad_connect $sys_cpu_resetn axi_ad762x_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad762x_dma/irq
