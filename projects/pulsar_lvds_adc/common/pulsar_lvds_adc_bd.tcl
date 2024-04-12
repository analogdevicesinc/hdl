###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set RESOLUTION_16_18N $ad_project_params(RESOLUTION_16_18N)
puts "build parameters: RESOLUTION_16_18N: $RESOLUTION_16_18N"

set ADC_DATA_WIDTH [expr {$RESOLUTION_16_18N == 1 ? 16 : 18}]
set BITS_PER_SAMPLE [expr {$RESOLUTION_16_18N == 1 ? 16 : 32}]

create_bd_port -dir O sampling_clk
create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir O cnv
create_bd_port -dir I d_p
create_bd_port -dir I d_n
create_bd_port -dir O clk_gate

# adc peripheral

ad_ip_instance axi_pulsar_lvds axi_pulsar_lvds
ad_ip_parameter axi_pulsar_lvds CONFIG.ADC_DATA_WIDTH $ADC_DATA_WIDTH
ad_ip_parameter axi_pulsar_lvds CONFIG.BITS_PER_SAMPLE $BITS_PER_SAMPLE

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 2
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 25
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 25
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

# dma

ad_ip_instance axi_dmac axi_pulsar_lvds_dma
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.DMA_DATA_WIDTH_SRC $BITS_PER_SAMPLE
ad_ip_parameter axi_pulsar_lvds_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi clk_gen

ad_ip_instance axi_clkgen reference_clkgen
ad_ip_parameter reference_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter reference_clkgen CONFIG.VCO_MUL 10
ad_ip_parameter reference_clkgen CONFIG.CLK0_DIV 6

ad_connect reference_clkgen/clk   $sys_cpu_clk
ad_connect reference_clkgen/clk_0 sampling_clk
ad_connect reference_clkgen/clk_0 axi_pulsar_lvds/ref_clk

# connections

ad_connect sys_200m_clk axi_pulsar_lvds/delay_clk

ad_connect clk_gate   axi_pulsar_lvds/clk_gate
ad_connect dco_p      axi_pulsar_lvds/dco_p
ad_connect dco_n      axi_pulsar_lvds/dco_n
ad_connect d_p        axi_pulsar_lvds/d_p
ad_connect d_n        axi_pulsar_lvds/d_n

ad_connect reference_clkgen/clk_0    axi_pulsar_lvds_dma/fifo_wr_clk
ad_connect axi_pulsar_lvds/fifo_wr   axi_pulsar_lvds_dma/fifo_wr

ad_connect cnv                    axi_pwm_gen/pwm_0
ad_connect clk_gate               axi_pwm_gen/pwm_1
ad_connect reference_clkgen/clk_0 axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn         axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk            axi_pwm_gen/s_axi_aclk

# address mapping

ad_cpu_interconnect 0x44A00000 axi_pulsar_lvds
ad_cpu_interconnect 0x44A30000 axi_pulsar_lvds_dma
ad_cpu_interconnect 0x44A60000 axi_pwm_gen
ad_cpu_interconnect 0x44A80000 reference_clkgen

# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_pulsar_lvds_dma/m_dest_axi
ad_connect $sys_cpu_resetn axi_pulsar_lvds_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_pulsar_lvds_dma/irq
