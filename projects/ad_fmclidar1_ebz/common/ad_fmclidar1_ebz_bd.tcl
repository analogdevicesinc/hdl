
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# interfaces and IO ports

create_bd_port -dir I spi_vco_csn_i
create_bd_port -dir O spi_vco_csn_o
create_bd_port -dir I spi_vco_clk_i
create_bd_port -dir O spi_vco_clk_o
create_bd_port -dir I spi_vco_sdo_i
create_bd_port -dir O spi_vco_sdo_o
create_bd_port -dir I spi_vco_sdi_i
create_bd_port -dir I spi_afe_adc_csn_i
create_bd_port -dir O spi_afe_adc_csn_o
create_bd_port -dir I spi_afe_adc_clk_i
create_bd_port -dir O spi_afe_adc_clk_o
create_bd_port -dir I spi_afe_adc_sdo_i
create_bd_port -dir O spi_afe_adc_sdo_o
create_bd_port -dir I spi_afe_adc_sdi_i
create_bd_port -dir O laser_driver
create_bd_port -dir O laser_driver_en_n
create_bd_port -dir I laser_driver_otw_n
create_bd_port -dir O -from 7 -to 0 tia_chsel

# NOTE: adc peripherals - controlled by PS7/SPI0

# AD9694 data interface - JESD204B framework

ad_ip_instance axi_adxcvr axi_ad9694_xcvr [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 0 \
]

adi_axi_jesd204_rx_create ad9694_jesd $NUM_OF_LANES
adi_tpl_jesd204_rx_create ad9694_tpl_core $NUM_OF_LANES $NUM_OF_CHANNELS $SAMPLES_PER_FRAME $SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_ad9694_cpack [list \
  NUM_OF_CHANNELS [expr $NUM_OF_CHANNELS + 1] \
  SAMPLES_PER_CHANNEL [expr $CHANNEL_DATA_WIDTH / $SAMPLE_WIDTH] \
  SAMPLE_DATA_WIDTH $SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac ad9694_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  DMA_DATA_WIDTH_SRC $DMA_DATA_WIDTH \
  DMA_DATA_WIDTH_DEST 64 \
  SYNC_TRANSFER_START 1 \
  FIFO_SIZE 32 \
]

# 3-wire SPI for clock synthesizer & VCO - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_vco [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# 3-wire SPI for AFE board's ADC - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_afe_adc [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# shared transceiver core

ad_ip_instance util_adxcvr util_ad9694_xcvr [list \
  RX_NUM_OF_LANES $NUM_OF_LANES \
  TX_NUM_OF_LANES 0 \
]

ad_connect $sys_cpu_resetn util_ad9694_xcvr/up_rstn
ad_connect $sys_cpu_clk util_ad9694_xcvr/up_clk

# laser driver - runs in asynchronous mode, using a 250MHz reference clock
# NOTE: After power up the driver will not generate any pulses, the software
# must configure the AXI Memory Mapped registers and load the configuration.
# This is why the parameter PULSE_PERIOD is 0.

ad_ip_instance axi_laser_driver axi_laser_driver_0 [list \
 ASYNC_CLK_EN  1 \
 PULSE_WIDTH  1 \
 PULSE_PERIOD 0 \
]

# a synchronization module, which make sure that the DMA will catch the pulse as
# its sync signal
create_bd_cell -type module -reference util_axis_syncgen util_axis_syncgen_0
set_property -dict [list CONFIG.ASYNC_SYNC {0}] [get_bd_cells util_axis_syncgen_0]

# software needs to know the used TIA channel selection for each transfer, so
# we create an addition dummy ADC channel whit this information
create_bd_cell -type module -reference util_tia_chsel util_tia_chsel_0
set_property -dict [list CONFIG.DATA_WIDTH {32}] [get_bd_cells util_tia_chsel_0]

# reference clocks & resets

create_bd_port -dir I -type clk rx_ref_clk
create_bd_port -dir I -type clk rx_device_clk

ad_xcvrpll  rx_ref_clk util_ad9694_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk util_ad9694_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9694_xcvr/up_pll_rst util_ad9694_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9694_xcvr/up_pll_rst util_ad9694_xcvr/up_cpll_rst_*

# connections (adc)

ad_xcvrcon util_ad9694_xcvr axi_ad9694_xcvr ad9694_jesd {3 2 0 1} rx_device_clk
ad_connect rx_device_clk ad9694_tpl_core/link_clk
ad_connect ad9694_jesd/rx_sof ad9694_tpl_core/link_sof
ad_connect ad9694_jesd/rx_data_tvalid ad9694_tpl_core/link_valid
ad_connect ad9694_jesd/rx_data_tdata ad9694_tpl_core/link_data

ad_connect rx_device_clk util_ad9694_cpack/clk

for {set i 0} {$i < $NUM_OF_CHANNELS} {incr i} {
  ad_connect ad9694_tpl_core/adc_enable_$i util_ad9694_cpack/enable_$i
  ad_connect ad9694_tpl_core/adc_data_$i util_ad9694_cpack/fifo_wr_data_$i
}
ad_connect ad9694_tpl_core/adc_valid_0 util_ad9694_cpack/fifo_wr_en
ad_connect ad9694_tpl_core/adc_dovf GND

ad_connect rx_device_clk ad9694_dma/s_axis_aclk
ad_connect util_ad9694_cpack/packed_fifo_wr_en ad9694_dma/s_axis_valid
ad_connect util_ad9694_cpack/packed_fifo_wr_data ad9694_dma/s_axis_data
ad_connect $sys_dma_resetn ad9694_dma/m_dest_axi_aresetn

#ad_connect ad9694_tpl_core/adc_dovf axi_ad9694_fifo/adc_wovf

ad_connect $sys_cpu_clk  axi_spi_vco/ext_spi_clk
ad_connect spi_vco axi_spi_vco/SPI_0
ad_connect spi_vco_csn_i axi_spi_vco/ss_i
ad_connect spi_vco_csn_o axi_spi_vco/ss_o
ad_connect spi_vco_clk_i axi_spi_vco/sck_i
ad_connect spi_vco_clk_o axi_spi_vco/sck_o
ad_connect spi_vco_sdo_i axi_spi_vco/io0_i
ad_connect spi_vco_sdo_o axi_spi_vco/io0_o
ad_connect spi_vco_sdi_i axi_spi_vco/io1_i

ad_connect $sys_cpu_clk  axi_spi_afe_adc/ext_spi_clk
ad_connect spi_afe_adc axi_spi_afe_adc/SPI_0
ad_connect spi_afe_adc_csn_i axi_spi_afe_adc/ss_i
ad_connect spi_afe_adc_csn_o axi_spi_afe_adc/ss_o
ad_connect spi_afe_adc_clk_i axi_spi_afe_adc/sck_i
ad_connect spi_afe_adc_clk_o axi_spi_afe_adc/sck_o
ad_connect spi_afe_adc_sdo_i axi_spi_afe_adc/io0_i
ad_connect spi_afe_adc_sdo_o axi_spi_afe_adc/io0_o
ad_connect spi_afe_adc_sdi_i axi_spi_afe_adc/io1_i

# laser driver and sync synchronizer

ad_connect rx_device_clk axi_laser_driver_0/ext_clk
ad_connect laser_driver axi_laser_driver_0/driver_pulse
ad_connect laser_driver_en_n axi_laser_driver_0/driver_en_n
ad_connect laser_driver_otw_n axi_laser_driver_0/driver_otw_n
ad_connect axi_laser_driver_0/driver_dp_reset util_ad9694_cpack/reset
ad_connect tia_chsel axi_laser_driver_0/tia_chsel

ad_connect rx_device_clk util_axis_syncgen_0/s_axis_aclk
ad_connect util_axis_syncgen_0/s_axis_aresetn VCC
ad_connect util_axis_syncgen_0/s_axis_valid util_ad9694_cpack/packed_fifo_wr_en
ad_connect util_axis_syncgen_0/s_axis_ready VCC
ad_connect util_axis_syncgen_0/ext_sync axi_laser_driver_0/driver_pulse
ad_connect util_axis_syncgen_0/s_axis_sync ad9694_dma/s_axis_user

# connect the dummy ADC channel to cpack -- channel is always active

ad_connect rx_device_clk util_tia_chsel_0/clk
ad_connect util_ad9694_cpack/fifo_wr_data_$NUM_OF_CHANNELS util_tia_chsel_0/adc_data_tia_chsel
ad_connect axi_laser_driver_0/driver_pulse util_tia_chsel_0/adc_tia_chsel_en
ad_connect util_ad9694_cpack/enable_$NUM_OF_CHANNELS VCC
ad_connect axi_laser_driver_0/tia_chsel util_tia_chsel_0/tia_chsel

# interconnect (cpu)

ad_cpu_interconnect 0x44A50000 axi_ad9694_xcvr
ad_cpu_interconnect 0x44A10000 ad9694_tpl_core
ad_cpu_interconnect 0x44AA0000 ad9694_jesd
ad_cpu_interconnect 0x7c400000 ad9694_dma
ad_cpu_interconnect 0x7c500000 axi_spi_vco
ad_cpu_interconnect 0x7c600000 axi_spi_afe_adc
ad_cpu_interconnect 0x7c700000 axi_laser_driver_0

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9694_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk ad9694_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-11 mb-14 ad9694_jesd/irq
ad_cpu_interrupt ps-13 mb-12 ad9694_dma/irq
ad_cpu_interrupt ps-10 mb-15 axi_spi_vco/ip2intc_irpt
ad_cpu_interrupt ps-9  mb-8  axi_spi_afe_adc/ip2intc_irpt
ad_cpu_interrupt ps-8  mb-7  axi_laser_driver_0/irq
