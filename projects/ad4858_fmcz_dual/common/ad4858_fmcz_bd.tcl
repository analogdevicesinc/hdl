###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set LVDS_CMOS_N 1

# ad4858_0 interface
create_bd_port -dir O adc_0_scki_p
create_bd_port -dir O adc_0_scki_n
create_bd_port -dir I adc_0_scko_p
create_bd_port -dir I adc_0_scko_n
create_bd_port -dir I adc_0_sdo_p
create_bd_port -dir I adc_0_sdo_n

create_bd_port -dir I adc_0_busy
create_bd_port -dir O adc_0_cnv

# ad4858_0 interface
create_bd_port -dir O adc_1_scki_p
create_bd_port -dir O adc_1_scki_n
create_bd_port -dir I adc_1_scko_p
create_bd_port -dir I adc_1_scko_n
create_bd_port -dir I adc_1_sdo_p
create_bd_port -dir I adc_1_sdo_n

create_bd_port -dir I adc_1_busy
create_bd_port -dir O adc_1_cnv

create_bd_port -dir O lvds_cmos_n
create_bd_port -dir O system_cpu_clk

# adc clock generator

ad_ip_instance axi_clkgen adc_clkgen
ad_ip_parameter adc_clkgen CONFIG.CLKIN_PERIOD 5
ad_ip_parameter adc_clkgen CONFIG.VCO_DIV 1
ad_connect  sys_200m_clk adc_clkgen/clk
# LVDS setup
# clk0 = 200M
# clk1 = 400M
ad_ip_parameter adc_clkgen CONFIG.VCO_MUL 6
ad_ip_parameter adc_clkgen CONFIG.CLK0_DIV 6
ad_ip_parameter adc_clkgen CONFIG.ENABLE_CLKOUT1 "true"
ad_ip_parameter adc_clkgen CONFIG.CLK1_DIV 3
ad_connect adc_clk adc_clkgen/clk_0
ad_connect adc_fast_clk adc_clkgen/clk_1

# adc clock domain reset

ad_ip_instance proc_sys_reset adc_rstgen
ad_ip_parameter adc_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect  adc_rstgen/ext_reset_in sys_cpu_resetn
ad_connect  adc_rstgen/slowest_sync_clk adc_clk
ad_connect  adc_resetn adc_rstgen/peripheral_aresetn
ad_connect  adc_reset adc_rstgen/peripheral_reset

# adc 0 (ad4858-dma)

ad_ip_instance axi_dmac ad4858_dma_0
ad_ip_parameter ad4858_dma_0 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad4858_dma_0 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad4858_dma_0 CONFIG.CYCLIC 0
ad_ip_parameter ad4858_dma_0 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad4858_dma_0 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad4858_dma_0 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad4858_dma_0 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad4858_dma_0 CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter ad4858_dma_0 CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  adc_clk ad4858_dma_0/fifo_wr_clk

# adc 1 (ad4858-dma)

ad_ip_instance axi_dmac ad4858_dma_1
ad_ip_parameter ad4858_dma_1 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad4858_dma_1 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad4858_dma_1 CONFIG.CYCLIC 0
ad_ip_parameter ad4858_dma_1 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad4858_dma_1 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad4858_dma_1 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad4858_dma_1 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad4858_dma_1 CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter ad4858_dma_1 CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  adc_clk ad4858_dma_1/fifo_wr_clk

# axi pwm gen adc 0

ad_ip_instance axi_pwm_gen axi_pwm_gen_0
ad_ip_parameter axi_pwm_gen_0 CONFIG.N_PWMS 1
ad_ip_parameter axi_pwm_gen_0 CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen_0 CONFIG.PULSE_0_PERIOD 8

ad_connect adc_0_cnv        axi_pwm_gen_0/pwm_0
ad_connect adc_clk          axi_pwm_gen_0/ext_clk
ad_connect sys_cpu_resetn   axi_pwm_gen_0/s_axi_aresetn
ad_connect sys_cpu_clk      axi_pwm_gen_0/s_axi_aclk

# axi pwm gen adc 1

ad_ip_instance axi_pwm_gen axi_pwm_gen_1
ad_ip_parameter axi_pwm_gen_1 CONFIG.N_PWMS 1
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_0_PERIOD 8

ad_connect adc_1_cnv        axi_pwm_gen_1/pwm_0
ad_connect adc_clk          axi_pwm_gen_1/ext_clk
ad_connect sys_cpu_resetn   axi_pwm_gen_1/s_axi_aresetn
ad_connect sys_cpu_clk      axi_pwm_gen_1/s_axi_aclk

# axi_ad4858_0

ad_ip_instance axi_ad4858 axi_ad4858_0
ad_ip_parameter axi_ad4858_0 CONFIG.LVDS_CMOS_N $LVDS_CMOS_N
ad_ip_parameter axi_ad4858_0 CONFIG.EXTERNAL_CLK 1
ad_ip_parameter axi_ad4858_0 CONFIG.ECHO_CLK_EN 1
ad_ip_parameter axi_ad4858_0 CONFIG.ID 0
ad_ip_parameter axi_ad4858_0 CONFIG.IODELAY_CTRL 1
ad_ip_parameter axi_ad4858_0 CONFIG.IODELAY_GROUP "dev_if_delay_group_0"

ad_connect  axi_ad4858_0/external_clk adc_clk
ad_connect  axi_ad4858_0/external_fast_clk adc_fast_clk

ad_connect  adc_0_sdo_p   axi_ad4858_0/sdo_p
ad_connect  adc_0_sdo_n   axi_ad4858_0/sdo_n
ad_connect  adc_0_scko_p  axi_ad4858_0/scko_p
ad_connect  adc_0_scko_n  axi_ad4858_0/scko_n
ad_connect  adc_0_scki_p  axi_ad4858_0/scki_p
ad_connect  adc_0_scki_n  axi_ad4858_0/scki_n

ad_connect  adc_0_busy    axi_ad4858_0/busy

# axi_ad4858_1

ad_ip_instance axi_ad4858 axi_ad4858_1
ad_ip_parameter axi_ad4858_1 CONFIG.LVDS_CMOS_N $LVDS_CMOS_N
ad_ip_parameter axi_ad4858_1 CONFIG.EXTERNAL_CLK 1
ad_ip_parameter axi_ad4858_1 CONFIG.ECHO_CLK_EN 0
ad_ip_parameter axi_ad4858_1 CONFIG.ID 1
ad_ip_parameter axi_ad4858_1 CONFIG.IODELAY_CTRL 0
ad_ip_parameter axi_ad4858_1 CONFIG.IODELAY_GROUP "dev_if_delay_group_0"

ad_connect  axi_ad4858_1/external_clk adc_clk
ad_connect  axi_ad4858_1/external_fast_clk adc_fast_clk

ad_connect  adc_1_sdo_p   axi_ad4858_1/sdo_p
ad_connect  adc_1_sdo_n   axi_ad4858_1/sdo_n
# non source sync interface
#ad_connect  adc_1_scko_p  axi_ad4858_1/scko_p
#ad_connect  adc_1_scko_n  axi_ad4858_1/scko_n
ad_connect  adc_1_scki_p  axi_ad4858_1/scki_p
ad_connect  adc_1_scki_n  axi_ad4858_1/scki_n

ad_connect  adc_1_busy    axi_ad4858_1/busy

ad_connect  lvds_cmos_n  axi_ad4858_0/lvds_cmos_n

# adc0-path

ad_ip_instance util_cpack2 ad4858_adc_pack_0
ad_ip_parameter ad4858_adc_pack_0 CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad4858_adc_pack_0 CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect adc_clk ad4858_adc_pack_0/clk
ad_connect adc_reset ad4858_adc_pack_0/reset
ad_connect axi_ad4858_0/adc_valid ad4858_adc_pack_0/fifo_wr_en
ad_connect ad4858_adc_pack_0/packed_fifo_wr ad4858_dma_0/fifo_wr
ad_connect ad4858_adc_pack_0/fifo_wr_overflow axi_ad4858_0/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad4858_0/adc_data_$i ad4858_adc_pack_0/fifo_wr_data_$i
  ad_connect axi_ad4858_0/adc_enable_$i ad4858_adc_pack_0/enable_$i
}

ad_connect  sys_200m_clk        axi_ad4858_0/delay_clk
ad_connect  axi_pwm_gen_0/pwm_0   axi_ad4858_0/cnvs

# adc0-path

ad_ip_instance util_cpack2 ad4858_adc_pack_1
ad_ip_parameter ad4858_adc_pack_1 CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad4858_adc_pack_1 CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect adc_clk ad4858_adc_pack_1/clk
ad_connect adc_reset ad4858_adc_pack_1/reset
ad_connect axi_ad4858_1/adc_valid ad4858_adc_pack_1/fifo_wr_en
ad_connect ad4858_adc_pack_1/packed_fifo_wr ad4858_dma_1/fifo_wr
ad_connect ad4858_adc_pack_1/fifo_wr_overflow axi_ad4858_1/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad4858_1/adc_data_$i ad4858_adc_pack_1/fifo_wr_data_$i
  ad_connect axi_ad4858_1/adc_enable_$i ad4858_adc_pack_1/enable_$i
}

ad_connect  sys_200m_clk        axi_ad4858_1/delay_clk
ad_connect  axi_pwm_gen_1/pwm_0   axi_ad4858_1/cnvs

ad_connect  sys_cpu_clk         system_cpu_clk

# interrupts

ad_cpu_interrupt ps-10 mb-10  ad4858_dma_0/irq
ad_cpu_interrupt ps-11 mb-9   ad4858_dma_1/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x43c00000 axi_ad4858_0
ad_cpu_interconnect 0x43d00000 axi_pwm_gen_0
ad_cpu_interconnect 0x43e00000 ad4858_dma_0
ad_cpu_interconnect 0x44c00000 axi_ad4858_1
ad_cpu_interconnect 0x44d00000 axi_pwm_gen_1
ad_cpu_interconnect 0x44e00000 ad4858_dma_1
ad_cpu_interconnect 0x44000000 adc_clkgen

ad_mem_hp1_interconnect sys_cpu_clk    sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk   ad4858_dma_0/m_dest_axi
ad_connect $sys_dma_resetn             ad4858_dma_0/m_dest_axi_aresetn
ad_mem_hp1_interconnect $sys_dma_clk   ad4858_dma_1/m_dest_axi
ad_connect $sys_dma_resetn             ad4858_dma_1/m_dest_axi_aresetn
