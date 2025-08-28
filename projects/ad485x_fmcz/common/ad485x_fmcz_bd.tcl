###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set LVDS_CMOS_N $ad_project_params(LVDS_CMOS_N)
set DEVICE $ad_project_params(DEVICE)

set data_width [expr {$DEVICE eq {AD4858} ? 32 : \
                      $DEVICE eq {AD4857} ? 16 : \
                      $DEVICE eq {AD4856} ? 32 : \
                      $DEVICE eq {AD4855} ? 16 : \
                      $DEVICE eq {AD4854} ? 32 : \
                      $DEVICE eq {AD4853} ? 16 : \
                      $DEVICE eq {AD4852} ? 32 : \
                      $DEVICE eq {AD4851} ? 16 : 32}]

set numb_of_ch [expr {$DEVICE eq {AD4858} ? 8 : \
                      $DEVICE eq {AD4857} ? 8 : \
                      $DEVICE eq {AD4856} ? 8 : \
                      $DEVICE eq {AD4855} ? 8 : \
                      $DEVICE eq {AD4854} ? 4 : \
                      $DEVICE eq {AD4853} ? 4 : \
                      $DEVICE eq {AD4852} ? 4 : \
                      $DEVICE eq {AD4851} ? 4 : 8}]

# ad485x interface

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
  # clk0 = 200M
  ad_ip_parameter adc_clkgen CONFIG.VCO_MUL 6
  ad_ip_parameter adc_clkgen CONFIG.CLK0_DIV 6
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

# adc(ad485x-dma)

ad_ip_instance axi_dmac ad485x_dma
ad_ip_parameter ad485x_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad485x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad485x_dma CONFIG.CYCLIC 0
ad_ip_parameter ad485x_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad485x_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad485x_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad485x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad485x_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $data_width * $numb_of_ch]
ad_ip_parameter ad485x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  adc_clk ad485x_dma/fifo_wr_clk

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8

ad_connect cnv              axi_pwm_gen/pwm_0
ad_connect adc_clk          axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn   axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk      axi_pwm_gen/s_axi_aclk

# axi_ad485x

ad_ip_instance axi_ad485x axi_ad485x
ad_ip_parameter axi_ad485x CONFIG.LVDS_CMOS_N $LVDS_CMOS_N
ad_ip_parameter axi_ad485x CONFIG.EXTERNAL_CLK 1
ad_ip_parameter axi_ad485x CONFIG.DEVICE $DEVICE
ad_connect  axi_ad485x/external_clk adc_clk
if {$LVDS_CMOS_N == "0"} {
  if {$DEVICE == {AD4858} || \
      $DEVICE == {AD4857} || \
      $DEVICE == {AD4856} || \
      $DEVICE == {AD4855}} {
    ad_connect  adc_lane_0  axi_ad485x/lane_0
    ad_connect  adc_lane_1  axi_ad485x/lane_1
    ad_connect  adc_lane_2  axi_ad485x/lane_2
    ad_connect  adc_lane_3  axi_ad485x/lane_3
    ad_connect  adc_lane_4  axi_ad485x/lane_4
    ad_connect  adc_lane_5  axi_ad485x/lane_5
    ad_connect  adc_lane_6  axi_ad485x/lane_6
    ad_connect  adc_lane_7  axi_ad485x/lane_7
  } else {
    ad_connect  adc_lane_0  axi_ad485x/lane_0
    ad_connect  adc_lane_1  axi_ad485x/lane_1
    ad_connect  adc_lane_2  axi_ad485x/lane_2
    ad_connect  adc_lane_3  axi_ad485x/lane_3
  }
  ad_connect  scko  axi_ad485x/scko
  ad_connect  scki  axi_ad485x/scki

} else {
  ad_connect  axi_ad485x/external_fast_clk adc_fast_clk

  ad_connect  sdo_p   axi_ad485x/sdo_p
  ad_connect  sdo_n   axi_ad485x/sdo_n
  ad_connect  scko_p  axi_ad485x/scko_p
  ad_connect  scko_n  axi_ad485x/scko_n
  ad_connect  scki_p  axi_ad485x/scki_p
  ad_connect  scki_n  axi_ad485x/scki_n
}

ad_connect  busy  axi_ad485x/busy
ad_connect  lvds_cmos_n  axi_ad485x/lvds_cmos_n

# adc-path channel pack

ad_ip_instance util_cpack2 ad485x_adc_pack
ad_ip_parameter ad485x_adc_pack CONFIG.NUM_OF_CHANNELS $numb_of_ch
ad_ip_parameter ad485x_adc_pack CONFIG.SAMPLE_DATA_WIDTH $data_width

ad_connect adc_clk ad485x_adc_pack/clk
ad_connect adc_reset ad485x_adc_pack/reset
ad_connect axi_ad485x/adc_valid ad485x_adc_pack/fifo_wr_en
ad_connect ad485x_adc_pack/packed_fifo_wr ad485x_dma/fifo_wr
ad_connect ad485x_adc_pack/fifo_wr_overflow axi_ad485x/adc_dovf
ad_connect ad485x_adc_pack/packed_sync ad485x_dma/sync

for {set i 0} {$i < $numb_of_ch} {incr i} {
  ad_connect axi_ad485x/adc_data_$i ad485x_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad485x/adc_enable_$i ad485x_adc_pack/enable_$i
}

ad_connect  sys_cpu_clk         system_cpu_clk

ad_connect  sys_200m_clk        axi_ad485x/delay_clk
ad_connect  axi_pwm_gen/pwm_0   axi_ad485x/cnvs

# interrupts

ad_cpu_interrupt ps-10 mb-10  ad485x_dma/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x43c00000 axi_ad485x
ad_cpu_interconnect 0x43d00000 axi_pwm_gen
ad_cpu_interconnect 0x43e00000 ad485x_dma
ad_cpu_interconnect 0x44000000 adc_clkgen

ad_mem_hp1_interconnect sys_cpu_clk    sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk   ad485x_dma/m_dest_axi
ad_connect $sys_dma_resetn             ad485x_dma/m_dest_axi_aresetn
