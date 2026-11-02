###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

log -r /system_tb/*
add wave -divider {Testbench clocks and AD9361 LVDS}
add wave /system_tb/refclk_p
add wave /system_tb/rx_clk_p
add wave /system_tb/tx_clk_p
add wave -radix hex /system_tb/tx_data_p

add wave -divider {DAC DMA AXIS source}
add wave /system_tb/dut/i_system_lb/axi_ad9361_dac_dma_0_m_axis_TVALID
add wave /system_tb/dut/i_system_lb/axi_ad9361_dac_dma_0_m_axis_TREADY
add wave /system_tb/dut/i_system_lb/axi_ad9361_dac_dma_0_m_axis_TLAST
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_dac_dma_0_m_axis_TDATA

add wave -divider {DAC stream unpack and RFIFO}
add wave /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_valid
add wave /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_underflow
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_data_0
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_data_1
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_data_2
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_upack_0_fifo_rd_data_3
add wave /system_tb/dut/i_system_lb/util_ad9361_dac_fifo_0_dout_unf
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_fifo_0_dout_data_0
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_fifo_0_dout_data_1
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_fifo_0_dout_data_2
add wave -radix hex /system_tb/dut/i_system_lb/util_ad9361_dac_fifo_0_dout_data_3

add wave -divider {AD9361 LVDS formatter}
add wave /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/dac_valid_s
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/dac_data_s
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/tx_data
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/tx_data_0
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/tx_data_1
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/rx_frame_s
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/rx_data_1_s
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/rx_data_0_s
add wave /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/adc_valid
add wave -radix hex /system_tb/dut/i_system_lb/axi_ad9361_0_inst_0/i_original/genblk2/i_dev_if/adc_data
