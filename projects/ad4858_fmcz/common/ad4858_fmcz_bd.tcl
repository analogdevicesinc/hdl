###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set LVDS_CMOS_N $ad_project_params(LVDS_CMOS_N)

# ad4858 interface

if {$LVDS_CMOS_N == "0"} {
  create_bd_port -dir O scki
  create_bd_port -dir I scko
  create_bd_port -dir I adc_lane_0
  create_bd_port -dir I adc_lane_1
  create_bd_port -dir I adc_lane_2
  create_bd_port -dir I adc_lane_3
  create_bd_port -dir I adc_lane_4
  create_bd_port -dir I adc_lane_5
  create_bd_port -dir I adc_lane_6
  create_bd_port -dir I adc_lane_7
} else {
  create_bd_port -dir O scki_p
  create_bd_port -dir O scki_n
  create_bd_port -dir I scko_p
  create_bd_port -dir I scko_n
  create_bd_port -dir I sdo_p
  create_bd_port -dir I sdo_n
}

create_bd_port -dir I busy
create_bd_port -dir O cnv
create_bd_port -dir O lvds_cmos_n

create_bd_port -dir O system_cpu_clk

# adc clock generator

ad_ip_instance axi_clkgen adc_clkgen
ad_ip_parameter adc_clkgen CONFIG.CLKIN_PERIOD 5
ad_ip_parameter adc_clkgen CONFIG.VCO_DIV 1
ad_connect  sys_200m_clk adc_clkgen/clk
if {$LVDS_CMOS_N == "0"} {
  # CMOS setup
  # clk0 = 100M
  ad_ip_parameter adc_clkgen CONFIG.VCO_MUL 5
  ad_ip_parameter adc_clkgen CONFIG.CLK0_DIV 10
  ad_connect adc_clk adc_clkgen/clk_0
} else {
  # LVDS setup
  # clk0 = 200M
  # clk1 = 400M
  ad_ip_parameter adc_clkgen CONFIG.VCO_MUL 6
  ad_ip_parameter adc_clkgen CONFIG.CLK0_DIV 6
  ad_ip_parameter adc_clkgen CONFIG.ENABLE_CLKOUT1 "true"
  ad_ip_parameter adc_clkgen CONFIG.CLK1_DIV 3
  ad_connect adc_clk adc_clkgen/clk_0
  ad_connect adc_fast_clk adc_clkgen/clk_1
}

# adc clock domain reset

ad_ip_instance proc_sys_reset adc_rstgen
ad_ip_parameter adc_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect  adc_rstgen/ext_reset_in sys_cpu_resetn
ad_connect  adc_rstgen/slowest_sync_clk adc_clk
ad_connect  adc_resetn adc_rstgen/peripheral_aresetn
ad_connect  adc_reset adc_rstgen/peripheral_reset

# adc(ad4858-dma)

ad_ip_instance axi_dmac ad4858_dma
ad_ip_parameter ad4858_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad4858_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad4858_dma CONFIG.CYCLIC 0
ad_ip_parameter ad4858_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad4858_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad4858_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad4858_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad4858_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter ad4858_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  adc_clk ad4858_dma/fifo_wr_clk

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8

ad_connect cnv              axi_pwm_gen/pwm_0
ad_connect adc_clk          axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn   axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk      axi_pwm_gen/s_axi_aclk

# axi_ad4858

ad_ip_instance axi_ad4858 axi_ad4858
ad_ip_parameter axi_ad4858 CONFIG.LVDS_CMOS_N $LVDS_CMOS_N
ad_ip_parameter axi_ad4858 CONFIG.EXTERNAL_CLK 1
ad_connect  axi_ad4858/external_clk adc_clk
if {$LVDS_CMOS_N == "0"} {
  ad_connect  adc_lane_0  axi_ad4858/lane_0
  ad_connect  adc_lane_1  axi_ad4858/lane_1
  ad_connect  adc_lane_2  axi_ad4858/lane_2
  ad_connect  adc_lane_3  axi_ad4858/lane_3
  ad_connect  adc_lane_4  axi_ad4858/lane_4
  ad_connect  adc_lane_5  axi_ad4858/lane_5
  ad_connect  adc_lane_6  axi_ad4858/lane_6
  ad_connect  adc_lane_7  axi_ad4858/lane_7
  ad_connect  scko  axi_ad4858/scko
  ad_connect  scki  axi_ad4858/scki

} else {
  ad_connect  axi_ad4858/external_fast_clk adc_fast_clk

  ad_connect  sdo_p   axi_ad4858/sdo_p
  ad_connect  sdo_n   axi_ad4858/sdo_n
  ad_connect  scko_p  axi_ad4858/scko_p
  ad_connect  scko_n  axi_ad4858/scko_n
  ad_connect  scki_p  axi_ad4858/scki_p
  ad_connect  scki_n  axi_ad4858/scki_n
}

ad_connect  busy  axi_ad4858/busy
ad_connect  lvds_cmos_n  axi_ad4858/lvds_cmos_n

# adc-path channel pack

ad_ip_instance util_cpack2 ad4858_adc_pack
ad_ip_parameter ad4858_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad4858_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect adc_clk ad4858_adc_pack/clk
ad_connect adc_reset ad4858_adc_pack/reset
ad_connect axi_ad4858/adc_valid ad4858_adc_pack/fifo_wr_en
ad_connect ad4858_adc_pack/packed_fifo_wr ad4858_dma/fifo_wr
ad_connect ad4858_adc_pack/fifo_wr_overflow axi_ad4858/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad4858/adc_data_$i ad4858_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad4858/adc_enable_$i ad4858_adc_pack/enable_$i
}

ad_connect  sys_cpu_clk         system_cpu_clk

ad_connect  sys_200m_clk        axi_ad4858/delay_clk
ad_connect  axi_pwm_gen/pwm_0   axi_ad4858/cnvs

# interrupts

ad_cpu_interrupt ps-10 mb-10  ad4858_dma/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x43c00000 axi_ad4858
ad_cpu_interconnect 0x43d00000 axi_pwm_gen
ad_cpu_interconnect 0x43e00000 ad4858_dma
ad_cpu_interconnect 0x44000000 adc_clkgen

ad_mem_hp1_interconnect sys_cpu_clk    sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk   ad4858_dma/m_dest_axi
ad_connect $sys_dma_resetn             ad4858_dma/m_dest_axi_aresetn
