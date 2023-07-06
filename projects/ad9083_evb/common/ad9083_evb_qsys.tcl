###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# JESD204B attributes
set RX_NUM_OF_LANES 4           ; # L
set RX_NUM_OF_CONVERTERS 16     ; # M
set RX_SAMPLES_PER_FRAME 1      ; # S
set RX_SAMPLE_WIDTH 16          ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 64 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]

#
## IP instantiations and configuration
#

add_instance device_clk altera_clock_bridge
set_instance_parameter_value device_clk {EXPLICIT_CLOCK_RATE} {125000000}

# ad9083_jesd204 JESD204B phy-link layer

add_instance ad9083_jesd204 adi_jesd204
set_instance_parameter_value ad9083_jesd204 {ID} {0}
set_instance_parameter_value ad9083_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9083_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value ad9083_jesd204 {LANE_RATE} {10000.0}
set_instance_parameter_value ad9083_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value ad9083_jesd204 {REFCLK_FREQUENCY} {500.0}
set_instance_parameter_value ad9083_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value ad9083_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value ad9083_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value ad9083_jesd204 {TPL_DATA_PATH_WIDTH} {8}

add_connection sys_clk.clk ad9083_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9083_jesd204.sys_resetn
add_connection device_clk.out_clk ad9083_jesd204.device_clk

# ad9083_tpl_0 JESD204B transport layer

add_instance axi_ad9083 ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_ad9083 {ID} {0}
set_instance_parameter_value axi_ad9083 {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_ad9083 {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value axi_ad9083 {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_ad9083 {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_ad9083 {TWOS_COMPLEMENT} {1}
set_instance_parameter_value axi_ad9083 {OCTETS_PER_BEAT} {8}

add_connection ad9083_jesd204.link_sof axi_ad9083.if_link_sof
add_connection ad9083_jesd204.link_data axi_ad9083.link_data
add_connection sys_clk.clk_reset axi_ad9083.s_axi_reset
add_connection sys_clk.clk axi_ad9083.s_axi_clock

# ad9083-pack

add_instance util_ad9083_cpack util_cpack2
set_instance_parameter_value util_ad9083_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value util_ad9083_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_FRAME
set_instance_parameter_value util_ad9083_cpack {SAMPLE_DATA_WIDTH} $RX_SAMPLE_WIDTH

add_connection ad9083_jesd204.link_reset util_ad9083_cpack.reset
add_connection device_clk.out_clk util_ad9083_cpack.clk

for {set i 0} {$i< $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_ad9083.adc_ch_${i} util_ad9083_cpack.adc_ch_${i}
}

# ADC FIFO's

add_instance ad9083_adcfifo util_adcfifo
set_instance_parameter_value ad9083_adcfifo {ADC_DATA_WIDTH} $adc_data_width
set_instance_parameter_value ad9083_adcfifo {DMA_DATA_WIDTH} $adc_data_width
set_instance_parameter_value ad9083_adcfifo {DMA_ADDRESS_WIDTH} {16}

add_connection sys_clk.clk_reset ad9083_adcfifo.if_adc_rst
add_connection device_clk.out_clk ad9083_adcfifo.if_adc_clk
add_connection util_ad9083_cpack.if_packed_fifo_wr_en ad9083_adcfifo.if_adc_wr
add_connection util_ad9083_cpack.if_packed_fifo_wr_data ad9083_adcfifo.if_adc_wdata
add_connection sys_dma_clk.clk ad9083_adcfifo.if_dma_clk
add_connection sys_dma_clk.clk_reset ad9083_adcfifo.if_adc_rst

# DMA instances

add_instance axi_ad9083_dma axi_dmac
set_instance_parameter_value axi_ad9083_dma {ID} {0}
set_instance_parameter_value axi_ad9083_dma {DMA_DATA_WIDTH_SRC} $adc_data_width
set_instance_parameter_value axi_ad9083_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9083_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9083_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9083_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9083_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9083_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9083_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9083_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9083_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_ad9083_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value axi_ad9083_dma {MAX_BYTES_PER_BURST} {128}
set_instance_parameter_value axi_ad9083_dma {FIFO_SIZE} {16}

add_connection sys_clk.clk axi_ad9083_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9083_dma.s_axi_reset
add_connection device_clk.out_clk axi_ad9083.link_clk
add_connection ad9083_adcfifo.m_axis axi_ad9083_dma.s_axis
add_connection ad9083_adcfifo.if_dma_xfer_req axi_ad9083_dma.if_s_axis_xfer_req
add_connection ad9083_adcfifo.if_adc_wovf axi_ad9083.if_adc_dovf
add_connection sys_dma_clk.clk axi_ad9083_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk_reset axi_ad9083_dma.m_dest_axi_reset
add_connection sys_dma_clk.clk axi_ad9083_dma.m_dest_axi_clock

#
## exported signals
#

add_interface rx_ref_clk                  clock     sink
add_interface rx_device_clk               clock     sink
add_interface rx_sysref                   conduit   end
add_interface rx_sync                     conduit   end
add_interface rx_serial_data              conduit   end

set_interface_property rx_ref_clk                  EXPORT_OF ad9083_jesd204.ref_clk
set_interface_property rx_device_clk               EXPORT_OF device_clk.in_clk
set_interface_property rx_sysref                   EXPORT_OF ad9083_jesd204.sysref
set_interface_property rx_sync                     EXPORT_OF ad9083_jesd204.sync
set_interface_property rx_serial_data              EXPORT_OF ad9083_jesd204.serial_data

#
## data interfaces / data path
#

# addresses

ad_cpu_interconnect 0x00040000 ad9083_jesd204.link_reconfig
ad_cpu_interconnect 0x00044000 ad9083_jesd204.link_management
ad_cpu_interconnect 0x00045000 ad9083_jesd204.link_pll_reconfig

for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
  ad_cpu_interconnect [expr 0x00048000 + $i * 0x1000] ad9083_jesd204.phy_reconfig_${i}
}

ad_cpu_interconnect 0x0004c000 axi_ad9083_dma.s_axi
ad_cpu_interconnect 0x00050000 axi_ad9083.s_axi

# dma interconnects
ad_dma_interconnect axi_ad9083_dma.m_dest_axi

#
## interrupts
#

ad_cpu_interrupt 11 ad9083_jesd204.interrupt
ad_cpu_interrupt 12 axi_ad9083_dma.interrupt_sender
