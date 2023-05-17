###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# LTC235x attributes

set LVDS_CMOS_N ${ad_project_params(LVDS_CMOS_N)}
set CHIP_SELECT_N 0
set ADC_EXTERNAL_CLK 0
set LTC235X_FAMILY ${ad_project_params(LTC235X_FAMILY)}
set ADC_LANE_0_ENABLE 1
set ADC_LANE_1_ENABLE 1

if {$LTC235X_FAMILY <= 1} {
    set ADC_NUM_CHANNELS 8
    set ADC_LANE_2_ENABLE 1
    set ADC_LANE_3_ENABLE 1
    set ADC_LANE_4_ENABLE 1
    set ADC_LANE_5_ENABLE 1
    set ADC_LANE_6_ENABLE 1
    set ADC_LANE_7_ENABLE 1
} elseif {$LTC235X_FAMILY <= 3} {
    set ADC_NUM_CHANNELS 4
    set ADC_LANE_2_ENABLE 1
    set ADC_LANE_3_ENABLE 1
    set ADC_LANE_4_ENABLE 0
    set ADC_LANE_5_ENABLE 0
    set ADC_LANE_6_ENABLE 0
    set ADC_LANE_7_ENABLE 0
} else {
    set ADC_NUM_CHANNELS 2
    set ADC_LANE_2_ENABLE 0
    set ADC_LANE_3_ENABLE 0
    set ADC_LANE_4_ENABLE 0
    set ADC_LANE_5_ENABLE 0
    set ADC_LANE_6_ENABLE 0
    set ADC_LANE_7_ENABLE 0
}

if {$LTC235X_FAMILY % 2 == 0} {
    set ADC_DATA_WIDTH 18
} else {
    set ADC_DATA_WIDTH 16
}

# axi_ltc235x

add_instance axi_ltc235x axi_ltc235x
set_instance_parameter_value axi_ltc235x {ID} {0}
set_instance_parameter_value axi_ltc235x {XILINX_INTEL_N} $xilinx_intel_n
set_instance_parameter_value axi_ltc235x {LVDS_CMOS_N} $LVDS_CMOS_N
set_instance_parameter_value axi_ltc235x {LANE_0_ENABLE} $ADC_LANE_0_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_1_ENABLE} $ADC_LANE_1_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_2_ENABLE} $ADC_LANE_2_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_3_ENABLE} $ADC_LANE_3_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_4_ENABLE} $ADC_LANE_4_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_5_ENABLE} $ADC_LANE_5_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_6_ENABLE} $ADC_LANE_6_ENABLE
set_instance_parameter_value axi_ltc235x {LANE_7_ENABLE} $ADC_LANE_7_ENABLE
set_instance_parameter_value axi_ltc235x {EXTERNAL_CLK} $ADC_EXTERNAL_CLK
set_instance_parameter_value axi_ltc235x {LTC235X_FAMILY} $LTC235X_FAMILY
set_instance_parameter_value axi_ltc235x {NUM_CHANNELS} $ADC_NUM_CHANNELS
set_instance_parameter_value axi_ltc235x {DATA_WIDTH} $ADC_DATA_WIDTH
add_interface axi_ltc235x_device_if conduit end
set_interface_property axi_ltc235x_device_if EXPORT_OF axi_ltc235x.device_if
add_connection sys_clk.clk axi_ltc235x.if_external_clk
add_connection sys_clk.clk axi_ltc235x.s_axi_clock
add_connection sys_clk.clk_reset axi_ltc235x.s_axi_reset

# pwm gen

add_instance adc_pwm_gen axi_pwm_gen
set_instance_parameter_value adc_pwm_gen {ID} {0}
set_instance_parameter_value adc_pwm_gen {ASYNC_CLK_EN} {0}
set_instance_parameter_value adc_pwm_gen {N_PWMS} {1}
set_instance_parameter_value adc_pwm_gen {PWM_EXT_SYNC} {0}
set_instance_parameter_value adc_pwm_gen {EXT_ASYNC_SYNC} {0}
set_instance_parameter_value adc_pwm_gen {PULSE_0_WIDTH} {3}
set_instance_parameter_value adc_pwm_gen {PULSE_0_PERIOD} {400}
set_instance_parameter_value adc_pwm_gen {PULSE_0_OFFSET} {0}
add_interface axi_ltc235x_cnv_if conduit end
set_interface_property axi_ltc235x_cnv_if EXPORT_OF adc_pwm_gen.if_pwm_0
add_connection sys_clk.clk adc_pwm_gen.if_ext_clk
add_connection sys_clk.clk adc_pwm_gen.s_axi_clock
add_connection sys_clk.clk_reset adc_pwm_gen.s_axi_reset

# pack

add_instance util_adc_pack util_cpack2
set_instance_parameter_value util_adc_pack {NUM_OF_CHANNELS} $ADC_NUM_CHANNELS
set_instance_parameter_value util_adc_pack {SAMPLES_PER_CHANNEL} {1}
set_instance_parameter_value util_adc_pack {SAMPLE_DATA_WIDTH} {32}
add_connection sys_clk.clk util_adc_pack.clk
add_connection sys_clk.clk_reset util_adc_pack.reset
for {set i 0} {$i < $ADC_NUM_CHANNELS} {incr i} {
    add_connection axi_ltc235x.adc_ch_$i util_adc_pack.adc_ch_$i
}
add_connection util_adc_pack.if_fifo_wr_overflow axi_ltc235x.if_adc_dovf

# dmac

add_instance axi_adc_dma axi_dmac
set_instance_parameter_value axi_adc_dma {ID} {0}
if {$ADC_NUM_CHANNELS == 8} {
    set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {256}
} elseif {$ADC_NUM_CHANNELS == 4} {
    set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {128}
} else {
    set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {64}
}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value axi_adc_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adc_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_adc_dma {CYCLIC} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_adc_dma {FIFO_SIZE} {4}
add_connection sys_clk.clk axi_adc_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_adc_dma.s_axi_reset
add_connection sys_clk.clk axi_adc_dma.m_dest_axi_clock
add_connection sys_clk.clk_reset axi_adc_dma.m_dest_axi_reset
add_connection sys_clk.clk axi_adc_dma.if_fifo_wr_clk
add_connection util_adc_pack.if_packed_fifo_wr_en axi_adc_dma.if_fifo_wr_en
add_connection util_adc_pack.if_packed_fifo_wr_sync axi_adc_dma.if_fifo_wr_sync
add_connection util_adc_pack.if_packed_fifo_wr_data axi_adc_dma.if_fifo_wr_din
add_connection axi_adc_dma.if_fifo_wr_overflow util_adc_pack.if_packed_fifo_wr_overflow

# interrupts / cpu interrupts

ad_cpu_interrupt 2 axi_adc_dma.interrupt_sender

# cpu interconnects / address map

ad_cpu_interconnect 0x00120000 axi_ltc235x.s_axi
ad_cpu_interconnect 0x00140000 adc_pwm_gen.s_axi
ad_cpu_interconnect 0x00100000 axi_adc_dma.s_axi

# mem interconnects / dma interconnects

ad_dma_interconnect axi_adc_dma.m_dest_axi 1
