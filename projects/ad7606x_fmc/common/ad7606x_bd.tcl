###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# system level parameters
set INTF $ad_project_params(INTF)
set NUM_OF_SDI $ad_project_params(NUM_OF_SDI)
set ADC_N_BITS $ad_project_params(ADC_N_BITS)
set ADC_TO_DMA_N_BITS [expr {$ADC_N_BITS == 16 ? 16 : 32}]
set TOTAL_N_BITS_DMA [expr {$ADC_TO_DMA_N_BITS*8}]

puts "build parameters: INTF: $INTF"
puts "build parameters: NUM_OF_SDI: $NUM_OF_SDI"
puts "build parameters: ADC_N_BITS: $ADC_N_BITS"

# control lines
create_bd_port -dir I rx_busy
create_bd_port -dir O rx_cnvst_n

# axi_pwm_gen
ad_ip_instance axi_pwm_gen ad7606_pwm_gen
ad_ip_parameter ad7606_pwm_gen CONFIG.N_PWMS 1

# dma
ad_ip_instance axi_dmac axi_ad7606x_dma
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7606x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

switch $INTF {
  0 {
    # data, read and write lines
    create_bd_port -dir O -from 15 -to 0 rx_db_o
    create_bd_port -dir I -from 15 -to 0 rx_db_i
    create_bd_port -dir O rx_db_t
    create_bd_port -dir O rx_rd_n
    create_bd_port -dir O rx_wr_n

    # control lines
    create_bd_port -dir O rx_cs_n
    create_bd_port -dir I rx_first_data

    # instantiation
    ad_ip_instance axi_ad7606x axi_ad7606x
    ad_ip_parameter axi_ad7606x CONFIG.ADC_N_BITS $ADC_N_BITS
    ad_ip_parameter axi_ad7606x CONFIG.ADC_TO_DMA_N_BITS $ADC_TO_DMA_N_BITS

    # axi_pwm_gen
    ad_ip_parameter ad7606_pwm_gen CONFIG.ASYNC_CLK_EN 0
    ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_WIDTH 124
    ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_PERIOD 125

    # dma
    ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_TYPE_SRC 2
    ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_DATA_WIDTH_SRC $TOTAL_N_BITS_DMA

    ad_ip_instance util_cpack2 ad7606x_adc_pack
    ad_ip_parameter ad7606x_adc_pack CONFIG.NUM_OF_CHANNELS 8
    ad_ip_parameter ad7606x_adc_pack CONFIG.SAMPLE_DATA_WIDTH $ADC_TO_DMA_N_BITS

    # interface connections
    ad_connect rx_db_o axi_ad7606x/rx_db_o
    ad_connect rx_db_i axi_ad7606x/rx_db_i
    ad_connect rx_db_t axi_ad7606x/rx_db_t
    ad_connect rx_rd_n axi_ad7606x/rx_rd_n
    ad_connect rx_wr_n axi_ad7606x/rx_wr_n

    ad_connect rx_cs_n axi_ad7606x/rx_cs_n
    ad_connect rx_cnvst_n ad7606_pwm_gen/pwm_0
    ad_connect rx_busy axi_ad7606x/rx_busy
    ad_connect rx_first_data axi_ad7606x/first_data

    ad_connect sys_cpu_clk axi_ad7606x_dma/s_axi_aclk
    ad_connect sys_cpu_clk ad7606_pwm_gen/s_axi_aclk
    ad_connect sys_cpu_resetn ad7606_pwm_gen/s_axi_aresetn

    ad_connect axi_ad7606x/adc_clk ad7606x_adc_pack/clk
    ad_connect axi_ad7606x/adc_clk axi_ad7606x_dma/fifo_wr_clk
    ad_connect axi_ad7606x/adc_reset ad7606x_adc_pack/reset
    ad_connect axi_ad7606x/adc_valid ad7606x_adc_pack/fifo_wr_en
    ad_connect ad7606x_adc_pack/packed_fifo_wr axi_ad7606x_dma/fifo_wr
    ad_connect ad7606x_adc_pack/fifo_wr_overflow axi_ad7606x/adc_dovf

    for {set i 0} {$i < 8} {incr i} {
      ad_connect axi_ad7606x/adc_data_$i ad7606x_adc_pack/fifo_wr_data_$i
      ad_connect axi_ad7606x/adc_enable_$i ad7606x_adc_pack/enable_$i
    }

    # interconnect
    ad_cpu_interconnect 0x44a00000 axi_ad7606x

    # memory interconnect
    ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
    ad_mem_hp1_interconnect sys_cpu_clk axi_ad7606x_dma/m_dest_axi
    ad_connect sys_cpu_resetn axi_ad7606x_dma/m_dest_axi_aresetn

    # interrupt
    ad_cpu_interrupt ps-13 mb-12 axi_ad7606x_dma/irq
    }
  1 {

    # instantiation
    create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad7606_spi

    ad_ip_instance axi_clkgen spi_clkgen
    ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
    ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
    ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 6

    ad_connect $sys_cpu_clk spi_clkgen/clk

    # spi engine
    source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

    set data_width    32
    set async_spi_clk 1
    set num_cs        1
    set num_sdi       $NUM_OF_SDI
    set num_sdo       1
    set sdi_delay     1

    set hier_spi_engine spi_ad7606

    spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay

    # axi_pwm_gen
    ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_PERIOD 120
    ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_WIDTH 1

     # trigger to BUSY's negative edge
    create_bd_cell -type module -reference sync_bits busy_sync
    create_bd_cell -type module -reference ad_edge_detect busy_capture
    set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

    ad_connect spi_clk busy_capture/clk
    ad_connect busy_capture/rst GND

    ad_connect busy_sync/out_resetn $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn
    ad_connect spi_clk busy_sync/out_clk
    ad_connect busy_sync/in_bits rx_busy
    ad_connect busy_sync/out_bits busy_capture/signal_in
    ad_connect busy_capture/signal_out $hier_spi_engine/trigger

    # dma
    ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_TYPE_SRC 1
    ad_ip_parameter axi_ad7606x_dma CONFIG.SYNC_TRANSFER_START 0
    ad_ip_parameter axi_ad7606x_dma CONFIG.AXI_SLICE_SRC 0
    ad_ip_parameter axi_ad7606x_dma CONFIG.AXI_SLICE_DEST 1
    ad_ip_parameter axi_ad7606x_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $data_width * $num_sdi]

    # interface connections
    ad_connect $sys_cpu_clk $hier_spi_engine/clk
    ad_connect $sys_cpu_clk ad7606_pwm_gen/s_axi_aclk

    ad_connect spi_clk spi_clkgen/clk_0
    ad_connect spi_clk $hier_spi_engine/spi_clk
    ad_connect spi_clk ad7606_pwm_gen/ext_clk
    ad_connect spi_clk axi_ad7606x_dma/s_axis_aclk

    ad_connect sys_cpu_resetn ad7606_pwm_gen/s_axi_aresetn
    ad_connect sys_cpu_resetn $hier_spi_engine/resetn
    ad_connect sys_cpu_resetn axi_ad7606x_dma/m_dest_axi_aresetn

    ad_connect rx_cnvst_n ad7606_pwm_gen/pwm_0

    ad_connect axi_ad7606x_dma/s_axis $hier_spi_engine/m_axis_sample

    ad_connect ad7606_spi $hier_spi_engine/m_spi

    # interconnect
    ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
    ad_cpu_interconnect 0x44a70000 spi_clkgen

    # interrupts
    ad_cpu_interrupt ps-13 mb-13 axi_ad7606x_dma/irq
    ad_cpu_interrupt ps-12 mb-12 /$hier_spi_engine/irq

    # memory interconnect
    ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
    ad_mem_hp1_interconnect $sys_cpu_clk axi_ad7606x_dma/m_dest_axi
    }
}

ad_cpu_interconnect 0x44a30000 axi_ad7606x_dma
ad_cpu_interconnect 0x44b00000 ad7606_pwm_gen
