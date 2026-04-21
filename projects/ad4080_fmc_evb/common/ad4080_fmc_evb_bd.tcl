###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set ADC_N_BITS $ad_project_params(ADC_N_BITS)
if {$ADC_N_BITS <= 16} {
    set DMA_DATA_WIDTH_SRC 16
} else {
    set DMA_DATA_WIDTH_SRC 32
}

# ad4080 interface

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I da_p
create_bd_port -dir I da_n
create_bd_port -dir I db_p
create_bd_port -dir I db_n
create_bd_port -dir I sync_n
create_bd_port -dir I cnv_in_p
create_bd_port -dir I cnv_in_n
create_bd_port -dir I filter_data_ready_n
create_bd_port -dir I fpga_ref_clk
create_bd_port -dir I fpga_100_clk

# ad4080_clock_monitor

ad_ip_instance axi_clock_monitor ad4080_clock_monitor
ad_ip_parameter ad4080_clock_monitor CONFIG.NUM_OF_CLOCKS 2
ad_ip_parameter ad4080_clock_monitor CONFIG.DIV_RATE 4

ad_connect fpga_ref_clk  ad4080_clock_monitor/clock_0
ad_connect fpga_100_clk  ad4080_clock_monitor/clock_1

# axi_ad408x

ad_ip_instance axi_ad408x axi_ad4080_adc
ad_ip_parameter axi_ad4080_adc CONFIG.ADC_N_BITS $ADC_N_BITS

# dma for rx data

ad_ip_instance axi_dmac axi_ad4080_dma
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4080_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_DATA_WIDTH_SRC $DMA_DATA_WIDTH_SRC
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connect interface to axi_ad4080_adc

ad_connect dco_p                axi_ad4080_adc/dclk_in_p
ad_connect dco_n                axi_ad4080_adc/dclk_in_n
ad_connect da_p                 axi_ad4080_adc/data_a_in_p
ad_connect da_n                 axi_ad4080_adc/data_a_in_n
ad_connect db_p                 axi_ad4080_adc/data_b_in_p
ad_connect db_n                 axi_ad4080_adc/data_b_in_n
ad_connect sync_n               axi_ad4080_adc/sync_n
ad_connect cnv_in_p             axi_ad4080_adc/cnv_in_p
ad_connect cnv_in_n             axi_ad4080_adc/cnv_in_n
ad_connect filter_data_ready_n  axi_ad4080_adc/filter_data_ready_n
ad_connect $sys_iodelay_clk     axi_ad4080_adc/delay_clk

# connect datapath

ad_connect axi_ad4080_adc/adc_data  axi_ad4080_dma/fifo_wr_din
ad_connect axi_ad4080_adc/adc_valid axi_ad4080_dma/fifo_wr_en
ad_connect axi_ad4080_adc/adc_dovf  axi_ad4080_dma/fifo_wr_overflow

# system runs on phy's received clock

ad_connect axi_ad4080_adc/adc_clk axi_ad4080_dma/fifo_wr_clk

ad_connect $sys_cpu_resetn axi_ad4080_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44A00000 axi_ad4080_adc
ad_cpu_interconnect 0x44A30000 axi_ad4080_dma
ad_cpu_interconnect 0x44A40000 ad4080_clock_monitor

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4080_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ad4080_dma/irq

# Add PMOD interface ports for SPI slave and data ready
create_bd_port -dir O pmod_spi_miso
create_bd_port -dir I pmod_spi_mosi
create_bd_port -dir I pmod_spi_sclk
create_bd_port -dir I pmod_spi_cs
create_bd_port -dir O pmod_data_ready

# Dual-clock FIFO for bridging ADC clock domain to SPI clock domain
ad_ip_instance fifo_generator ad4080_adc_fifo
ad_ip_parameter ad4080_adc_fifo CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}
ad_ip_parameter ad4080_adc_fifo CONFIG.Input_Data_Width 32
ad_ip_parameter ad4080_adc_fifo CONFIG.Input_Depth 1024
ad_ip_parameter ad4080_adc_fifo CONFIG.Output_Data_Width 32
ad_ip_parameter ad4080_adc_fifo CONFIG.Output_Depth 1024
ad_ip_parameter ad4080_adc_fifo CONFIG.Use_Embedded_Registers {false}
ad_ip_parameter ad4080_adc_fifo CONFIG.Reset_Type {Asynchronous_Reset}
ad_ip_parameter ad4080_adc_fifo CONFIG.Full_Flags_Reset_Value 0
ad_ip_parameter ad4080_adc_fifo CONFIG.Valid_Flag {true}
ad_ip_parameter ad4080_adc_fifo CONFIG.Data_Count_Width 10
ad_ip_parameter ad4080_adc_fifo CONFIG.Write_Data_Count_Width 10
ad_ip_parameter ad4080_adc_fifo CONFIG.Read_Data_Count_Width 10
ad_ip_parameter ad4080_adc_fifo CONFIG.Full_Threshold_Assert_Value 1022
ad_ip_parameter ad4080_adc_fifo CONFIG.Full_Threshold_Negate_Value 1021

# AXI Quad SPI in slave mode for microcontroller interface
ad_ip_instance axi_quad_spi ad4080_spi_slave
ad_ip_parameter ad4080_spi_slave CONFIG.C_USE_STARTUP {0}
ad_ip_parameter ad4080_spi_slave CONFIG.C_NUM_SS_BITS {1}
ad_ip_parameter ad4080_spi_slave CONFIG.C_SCK_RATIO {4}
ad_ip_parameter ad4080_spi_slave CONFIG.C_NUM_TRANSFER_BITS {32}
ad_ip_parameter ad4080_spi_slave CONFIG.C_SPI_MEMORY {1}
ad_ip_parameter ad4080_spi_slave CONFIG.C_TYPE_OF_AXI4_INTERFACE {1}
ad_ip_parameter ad4080_spi_slave CONFIG.C_XIP_MODE {0}
ad_ip_parameter ad4080_spi_slave CONFIG.C_USE_SLAVE {1}

# Connect ADC data to FIFO write side (tee off from existing DMA path)
ad_connect axi_ad4080_adc/adc_data  ad4080_adc_fifo/din
ad_connect axi_ad4080_adc/adc_valid ad4080_adc_fifo/wr_en
ad_connect axi_ad4080_adc/adc_clk   ad4080_adc_fifo/wr_clk

# Connect FIFO read side to SPI slave
ad_connect ad4080_adc_fifo/dout     ad4080_spi_slave/s2mm_cmd_tdata
ad_connect ad4080_adc_fifo/valid    ad4080_spi_slave/s2mm_cmd_tvalid
ad_connect ad4080_adc_fifo/rd_en    ad4080_spi_slave/s2mm_cmd_tready

# Connect SPI slave clock domain
ad_connect $sys_cpu_clk ad4080_adc_fifo/rd_clk
ad_connect $sys_cpu_clk ad4080_spi_slave/s_axi4_aclk
ad_connect $sys_cpu_clk ad4080_spi_slave/ext_spi_clk

# Connect resets
ad_connect $sys_cpu_resetn ad4080_adc_fifo/rst
ad_connect $sys_cpu_resetn ad4080_spi_slave/s_axi4_aresetn

# Connect SPI slave external interface
ad_connect pmod_spi_miso  ad4080_spi_slave/io0_o
ad_connect pmod_spi_mosi  ad4080_spi_slave/io1_i
ad_connect pmod_spi_sclk  ad4080_spi_slave/sck_i
ad_connect pmod_spi_cs    ad4080_spi_slave/ss_i

# Data ready signal - indicate when FIFO has data available
ad_connect ad4080_adc_fifo/empty pmod_data_ready

# Add SPI slave to CPU interconnect
ad_cpu_interconnect 0x44A50000 ad4080_spi_slave
