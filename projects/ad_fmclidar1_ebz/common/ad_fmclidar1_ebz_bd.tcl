
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set TOTAL_NUM_OF_CHANNELS [expr $NUM_OF_CHANNELS * 2]
set TOTAL_NUM_OF_LANES [expr $NUM_OF_LANES * 2]

###############################################################################
# LIDAR_A data & control path
###############################################################################

# interfaces and IO ports

create_bd_port -dir I spi_vco_csn_a_i
create_bd_port -dir O spi_vco_csn_a_o
create_bd_port -dir I spi_vco_clk_a_i
create_bd_port -dir O spi_vco_clk_a_o
create_bd_port -dir I spi_vco_sdo_a_i
create_bd_port -dir O spi_vco_sdo_a_o
create_bd_port -dir I spi_vco_sdi_a_i
create_bd_port -dir I spi_afe_adc_csn_a_i
create_bd_port -dir O spi_afe_adc_csn_a_o
create_bd_port -dir I spi_afe_adc_clk_a_i
create_bd_port -dir O spi_afe_adc_clk_a_o
create_bd_port -dir I spi_afe_adc_sdo_a_i
create_bd_port -dir O spi_afe_adc_sdo_a_o
create_bd_port -dir I spi_afe_adc_sdi_a_i
create_bd_port -dir O laser_driver_a
create_bd_port -dir O laser_driver_en_a_n
create_bd_port -dir I laser_driver_otw_a_n
create_bd_port -dir O -from 7 -to 0 tia_chsel_a

# adc peripherals - controlled by PS7/SPI0

ad_ip_instance axi_adxcvr axi_ad9694_xcvr_a [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 0 \
]

adi_axi_jesd204_rx_create ad9694_jesd_a $NUM_OF_LANES
adi_tpl_jesd204_rx_create ad9694_tpl_core $TOTAL_NUM_OF_LANES $TOTAL_NUM_OF_CHANNELS $SAMPLES_PER_FRAME $SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_ad9694_cpack [list \
  NUM_OF_CHANNELS [expr $TOTAL_NUM_OF_CHANNELS + 1] \
  SAMPLES_PER_CHANNEL [expr $CHANNEL_DATA_WIDTH / $SAMPLE_WIDTH] \
  SAMPLE_DATA_WIDTH $SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac ad9694_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  DMA_DATA_WIDTH_SRC [expr $DMA_DATA_WIDTH * 2] \
  DMA_DATA_WIDTH_DEST 64 \
  SYNC_TRANSFER_START 1 \
  FIFO_SIZE 32 \
]

# 3-wire SPI for clock synthesizer & VCO - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_vco_a [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# 3-wire SPI for AFE board's ADC - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_afe_adc_a [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# transceiver core

ad_ip_instance util_adxcvr util_ad9694_xcvr_a [list \
  RX_NUM_OF_LANES $NUM_OF_LANES \
  TX_NUM_OF_LANES 0 \
]

ad_connect $sys_cpu_resetn util_ad9694_xcvr_a/up_rstn
ad_connect $sys_cpu_clk util_ad9694_xcvr_a/up_clk

# laser driver - runs in asynchronous mode, using a 250MHz reference clock
# NOTE: After power up the driver will not generate any pulses, the software
# must configure the AXI Memory Mapped registers and load the configuration.
# This is why the parameter PULSE_PERIOD is 0.

ad_ip_instance axi_laser_driver axi_laser_driver_0_a [list \
 ASYNC_CLK_EN  1 \
 PULSE_WIDTH  1 \
 PULSE_PERIOD 0 \
]

# a synchronization module, which make sure that the DMA will catch the pulse as
# its sync signal
create_bd_cell -type module -reference util_axis_syncgen util_axis_syncgen_0_a
set_property -dict [list CONFIG.ASYNC_SYNC {0}] [get_bd_cells util_axis_syncgen_0_a]

# software needs to know the used TIA channel selection for each transfer, so
# we create an addition dummy ADC channel whit this information
create_bd_cell -type module -reference util_tia_chsel util_tia_chsel_0_a
set_property -dict [list CONFIG.DATA_WIDTH {32}] [get_bd_cells util_tia_chsel_0_a]

# reference clocks & resets

create_bd_port -dir I -type clk rx_ref_clk_a
create_bd_port -dir I -type clk rx_device_clk_a

ad_xcvrpll  rx_ref_clk_a util_ad9694_xcvr_a/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_a util_ad9694_xcvr_a/cpll_ref_clk_*
ad_xcvrpll  axi_ad9694_xcvr_a/up_pll_rst util_ad9694_xcvr_a/up_qpll_rst_*
ad_xcvrpll  axi_ad9694_xcvr_a/up_pll_rst util_ad9694_xcvr_a/up_cpll_rst_*

# connections (adc)

ad_xcvrcon util_ad9694_xcvr_a axi_ad9694_xcvr_a ad9694_jesd_a {3 2 0 1} rx_device_clk_a
ad_connect rx_device_clk_a ad9694_tpl_core/link_clk
ad_connect ad9694_jesd_a/rx_sof ad9694_tpl_core/link_sof


ad_connect rx_device_clk_a util_ad9694_cpack/clk

for {set i 0} {$i < $TOTAL_NUM_OF_CHANNELS} {incr i} {
  ad_connect ad9694_tpl_core/adc_enable_$i util_ad9694_cpack/enable_$i
  ad_connect ad9694_tpl_core/adc_data_$i util_ad9694_cpack/fifo_wr_data_$i
}
ad_connect ad9694_tpl_core/adc_valid_0 util_ad9694_cpack/fifo_wr_en
ad_connect ad9694_tpl_core/adc_dovf GND

ad_connect rx_device_clk_a ad9694_dma/s_axis_aclk
ad_connect util_ad9694_cpack/packed_fifo_wr_en ad9694_dma/s_axis_valid
ad_connect util_ad9694_cpack/packed_fifo_wr_data ad9694_dma/s_axis_data
ad_connect $sys_dma_resetn ad9694_dma/m_dest_axi_aresetn

ad_connect $sys_cpu_clk  axi_spi_vco_a/ext_spi_clk
ad_connect spi_vco_a axi_spi_vco_a/SPI_0
ad_connect spi_vco_csn_a_i axi_spi_vco_a/ss_i
ad_connect spi_vco_csn_a_o axi_spi_vco_a/ss_o
ad_connect spi_vco_clk_a_i axi_spi_vco_a/sck_i
ad_connect spi_vco_clk_a_o axi_spi_vco_a/sck_o
ad_connect spi_vco_sdo_a_i axi_spi_vco_a/io0_i
ad_connect spi_vco_sdo_a_o axi_spi_vco_a/io0_o
ad_connect spi_vco_sdi_a_i axi_spi_vco_a/io1_i

ad_connect $sys_cpu_clk  axi_spi_afe_adc_a/ext_spi_clk
ad_connect spi_afe_adc_a axi_spi_afe_adc_a/SPI_0
ad_connect spi_afe_adc_csn_a_i axi_spi_afe_adc_a/ss_i
ad_connect spi_afe_adc_csn_a_o axi_spi_afe_adc_a/ss_o
ad_connect spi_afe_adc_clk_a_i axi_spi_afe_adc_a/sck_i
ad_connect spi_afe_adc_clk_a_o axi_spi_afe_adc_a/sck_o
ad_connect spi_afe_adc_sdo_a_i axi_spi_afe_adc_a/io0_i
ad_connect spi_afe_adc_sdo_a_o axi_spi_afe_adc_a/io0_o
ad_connect spi_afe_adc_sdi_a_i axi_spi_afe_adc_a/io1_i

# laser driver and sync synchronizer

ad_connect rx_device_clk_a axi_laser_driver_0_a/ext_clk
ad_connect laser_driver_a axi_laser_driver_0_a/driver_pulse
ad_connect laser_driver_en_a_n axi_laser_driver_0_a/driver_en_n
ad_connect laser_driver_otw_a_n axi_laser_driver_0_a/driver_otw_n
ad_connect axi_laser_driver_0_a/driver_dp_reset util_ad9694_cpack/reset
ad_connect tia_chsel_a axi_laser_driver_0_a/tia_chsel

ad_connect rx_device_clk_a util_axis_syncgen_0_a/s_axis_aclk
ad_connect util_axis_syncgen_0_a/s_axis_aresetn VCC
ad_connect util_axis_syncgen_0_a/s_axis_valid util_ad9694_cpack/packed_fifo_wr_en
ad_connect util_axis_syncgen_0_a/s_axis_ready VCC
ad_connect util_axis_syncgen_0_a/ext_sync axi_laser_driver_0_a/driver_pulse
ad_connect util_axis_syncgen_0_a/s_axis_sync ad9694_dma/s_axis_user

# connect the dummy ADC channel to cpack -- channel is always active

ad_connect rx_device_clk_a util_tia_chsel_0_a/clk
ad_connect util_ad9694_cpack/fifo_wr_data_$TOTAL_NUM_OF_CHANNELS util_tia_chsel_0_a/adc_data_tia_chsel
ad_connect axi_laser_driver_0_a/driver_pulse util_tia_chsel_0_a/adc_tia_chsel_en
ad_connect util_ad9694_cpack/enable_$TOTAL_NUM_OF_CHANNELS VCC
ad_connect axi_laser_driver_0_a/tia_chsel util_tia_chsel_0_a/tia_chsel

# interconnect (cpu)

ad_cpu_interconnect 0x44A50000 axi_ad9694_xcvr_a
ad_cpu_interconnect 0x44A10000 ad9694_tpl_core
ad_cpu_interconnect 0x44AA0000 ad9694_jesd_a
ad_cpu_interconnect 0x7c400000 ad9694_dma
ad_cpu_interconnect 0x7c500000 axi_spi_vco_a
ad_cpu_interconnect 0x7c600000 axi_spi_afe_adc_a
ad_cpu_interconnect 0x7c700000 axi_laser_driver_0_a

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9694_xcvr_a/m_axi

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk ad9694_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-11 mb-14 ad9694_jesd_a/irq
ad_cpu_interrupt ps-13 mb-12 ad9694_dma/irq
ad_cpu_interrupt ps-10 mb-15 axi_spi_vco_a/ip2intc_irpt
ad_cpu_interrupt ps-9  mb-8  axi_spi_afe_adc_a/ip2intc_irpt
ad_cpu_interrupt ps-8  mb-7  axi_laser_driver_0_a/irq

###############################################################################
# LIDAR_B data & control path
###############################################################################

# interfaces and IO ports

create_bd_port -dir I spi_adc_csn_b_i
create_bd_port -dir O spi_adc_csn_b_o
create_bd_port -dir I spi_adc_clk_b_i
create_bd_port -dir O spi_adc_clk_b_o
create_bd_port -dir I spi_adc_sdo_b_i
create_bd_port -dir O spi_adc_sdo_b_o
create_bd_port -dir I spi_adc_sdi_b_i
create_bd_port -dir I spi_clkgen_csn_b_i
create_bd_port -dir O spi_clkgen_csn_b_o
create_bd_port -dir I spi_clkgen_clk_b_i
create_bd_port -dir O spi_clkgen_clk_b_o
create_bd_port -dir I spi_clkgen_sdo_b_i
create_bd_port -dir O spi_clkgen_sdo_b_o
create_bd_port -dir I spi_clkgen_sdi_b_i
create_bd_port -dir I spi_vco_csn_b_i
create_bd_port -dir O spi_vco_csn_b_o
create_bd_port -dir I spi_vco_clk_b_i
create_bd_port -dir O spi_vco_clk_b_o
create_bd_port -dir I spi_vco_sdo_b_i
create_bd_port -dir O spi_vco_sdo_b_o
create_bd_port -dir I spi_vco_sdi_b_i
create_bd_port -dir I spi_afe_adc_csn_b_i
create_bd_port -dir O spi_afe_adc_csn_b_o
create_bd_port -dir I spi_afe_adc_clk_b_i
create_bd_port -dir O spi_afe_adc_clk_b_o
create_bd_port -dir I spi_afe_adc_sdo_b_i
create_bd_port -dir O spi_afe_adc_sdo_b_o
create_bd_port -dir I spi_afe_adc_sdi_b_i

ad_ip_instance axi_adxcvr axi_ad9694_xcvr_b [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 0 \
]

adi_axi_jesd204_rx_create ad9694_jesd_b $NUM_OF_LANES

# CLKGEN SPI interface

ad_ip_instance axi_quad_spi axi_spi_clkgen_b [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# DAQ ADC SPI interface

ad_ip_instance axi_quad_spi axi_spi_adc_b [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# 3-wire SPI for clock synthesizer & VCO - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_vco_b [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# 3-wire SPI for AFE board's ADC - 12.5MHz SCLK rate

ad_ip_instance axi_quad_spi axi_spi_afe_adc_b [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 8 \
]

# shared transceiver core

ad_ip_instance util_adxcvr util_ad9694_xcvr_b [list \
  RX_NUM_OF_LANES $NUM_OF_LANES \
  TX_NUM_OF_LANES 0 \
]

ad_connect $sys_cpu_resetn util_ad9694_xcvr_b/up_rstn
ad_connect $sys_cpu_clk util_ad9694_xcvr_b/up_clk

# reference clocks & resets

create_bd_port -dir I -type clk rx_ref_clk_b
create_bd_port -dir I -type clk rx_device_clk_b

ad_xcvrpll  rx_ref_clk_b util_ad9694_xcvr_b/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_b util_ad9694_xcvr_b/cpll_ref_clk_*
ad_xcvrpll  axi_ad9694_xcvr_b/up_pll_rst util_ad9694_xcvr_b/up_qpll_rst_*
ad_xcvrpll  axi_ad9694_xcvr_b/up_pll_rst util_ad9694_xcvr_b/up_cpll_rst_*

# connections (adc)

ad_xcvrcon util_ad9694_xcvr_b axi_ad9694_xcvr_b ad9694_jesd_b {3 2 0 1} rx_device_clk_a

# connect the two links to the tpl

ad_ip_instance xlconcat merge_link [list \
  NUM_PORTS 2 \
  INO_WIDTH.VALUE_SRC "PROPAGATED" \
]

# merge the two link into one tpl

ad_connect ad9694_jesd_a/rx_data_tvalid ad9694_tpl_core/link_valid
ad_connect ad9694_jesd_a/rx_data_tdata merge_link/In0
ad_connect ad9694_jesd_b/rx_data_tdata merge_link/In1
ad_connect merge_link/dout ad9694_tpl_core/link_data

ad_connect $sys_cpu_clk  axi_spi_clkgen_b/ext_spi_clk
ad_connect spi_clkgen_b axi_spi_clkgen_b/SPI_0
ad_connect spi_clkgen_csn_b_i axi_spi_clkgen_b/ss_i
ad_connect spi_clkgen_csn_b_o axi_spi_clkgen_b/ss_o
ad_connect spi_clkgen_clk_b_i axi_spi_clkgen_b/sck_i
ad_connect spi_clkgen_clk_b_o axi_spi_clkgen_b/sck_o
ad_connect spi_clkgen_sdo_b_i axi_spi_clkgen_b/io0_i
ad_connect spi_clkgen_sdo_b_o axi_spi_clkgen_b/io0_o
ad_connect spi_clkgen_sdi_b_i axi_spi_clkgen_b/io1_i

ad_connect $sys_cpu_clk  axi_spi_adc_b/ext_spi_clk
ad_connect spi_adc_b axi_spi_adc_b/SPI_0
ad_connect spi_adc_csn_b_i axi_spi_adc_b/ss_i
ad_connect spi_adc_csn_b_o axi_spi_adc_b/ss_o
ad_connect spi_adc_clk_b_i axi_spi_adc_b/sck_i
ad_connect spi_adc_clk_b_o axi_spi_adc_b/sck_o
ad_connect spi_adc_sdo_b_i axi_spi_adc_b/io0_i
ad_connect spi_adc_sdo_b_o axi_spi_adc_b/io0_o
ad_connect spi_adc_sdi_b_i axi_spi_adc_b/io1_i

ad_connect $sys_cpu_clk  axi_spi_vco_b/ext_spi_clk
ad_connect spi_vco_b axi_spi_vco_b/SPI_0
ad_connect spi_vco_csn_b_i axi_spi_vco_b/ss_i
ad_connect spi_vco_csn_b_o axi_spi_vco_b/ss_o
ad_connect spi_vco_clk_b_i axi_spi_vco_b/sck_i
ad_connect spi_vco_clk_b_o axi_spi_vco_b/sck_o
ad_connect spi_vco_sdo_b_i axi_spi_vco_b/io0_i
ad_connect spi_vco_sdo_b_o axi_spi_vco_b/io0_o
ad_connect spi_vco_sdi_b_i axi_spi_vco_b/io1_i

ad_connect $sys_cpu_clk  axi_spi_afe_adc_b/ext_spi_clk
ad_connect spi_afe_adc_b axi_spi_afe_adc_b/SPI_0
ad_connect spi_afe_adc_csn_b_i axi_spi_afe_adc_b/ss_i
ad_connect spi_afe_adc_csn_b_o axi_spi_afe_adc_b/ss_o
ad_connect spi_afe_adc_clk_b_i axi_spi_afe_adc_b/sck_i
ad_connect spi_afe_adc_clk_b_o axi_spi_afe_adc_b/sck_o
ad_connect spi_afe_adc_sdo_b_i axi_spi_afe_adc_b/io0_i
ad_connect spi_afe_adc_sdo_b_o axi_spi_afe_adc_b/io0_o
ad_connect spi_afe_adc_sdi_b_i axi_spi_afe_adc_b/io1_i

# interconnect (cpu)

ad_cpu_interconnect 0x7D000000 axi_ad9694_xcvr_b
ad_cpu_interconnect 0x7D080000 ad9694_jesd_b
ad_cpu_interconnect 0x7D100000 axi_spi_vco_b
ad_cpu_interconnect 0x7D200000 axi_spi_afe_adc_b
ad_cpu_interconnect 0x7D400000 axi_spi_adc_b
ad_cpu_interconnect 0x7D500000 axi_spi_clkgen_b


# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9694_xcvr_b/m_axi

# interrupts

ad_cpu_interrupt ps-7 mb-6 ad9694_jesd_b/irq
ad_cpu_interrupt ps-5 mb-4 axi_spi_vco_b/ip2intc_irpt
ad_cpu_interrupt ps-4 mb-3 axi_spi_afe_adc_b/ip2intc_irpt
ad_cpu_interrupt ps-2 mb-1 axi_spi_adc_b/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-0 axi_spi_clkgen_b/ip2intc_irpt


