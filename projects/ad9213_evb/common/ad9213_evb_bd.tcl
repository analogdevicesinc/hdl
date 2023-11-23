###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX parameters for each converter
set RX_NUM_OF_LANES 16     ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 16 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 32 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name axi_ad9213_fifo
set adc_data_width 512
set adc_dma_data_width 512

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

# system level parameters
set NUM_OF_SDI  $ad_project_params(NUM_OF_SDI)
set CAPTURE_ZONE $ad_project_params(CAPTURE_ZONE)
set CLK_MODE $ad_project_params(CLK_MODE)
set DDR_EN $ad_project_params(DDR_EN)

puts "build parameters: NUM_OF_SDI: $NUM_OF_SDI ; CAPTURE_ZONE: $CAPTURE_ZONE ; CLK_MODE: $CLK_MODE ;DDR_EN: $DDR_EN"

# block design ports and interfaces
# specify the CNV generator's reference clock frequency in MHz
# NOTE: this is a default value, software may or may not change this
set cnv_ref_clk 100

# specify ADC sampling rate in samples/seconds
# NOTE: this is a default value, software may or may not change this
set adc_sampling_rate 1000000

#create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad463x_spi

create_bd_port -dir O ad463x_spi_sclk
create_bd_port -dir O ad463x_spi_cs
create_bd_port -dir O ad463x_spi_sdo
create_bd_port -dir I -from [expr $NUM_OF_SDI-1] -to 0 ad463x_spi_sdi

create_bd_port -dir I ad463x_echo_sclk

create_bd_port -dir I ad463x_busy
create_bd_port -dir O ad463x_cnv
create_bd_port -dir I ad463x_ext_clk

## To support the 2MSPS (SCLK == 80 MHz), set the spi clock to 160 MHz

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8
ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

# create a SPI Engine architecture

#spi_engine_create "spi_ad463x" 32         1             1       $NUM_OF_SDI 0          1

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       $NUM_OF_SDI
set num_sdo       1
set sdi_delay     1
set echo_sclk     1

set hier_spi_engine spi_ad463x

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_execution CONFIG.DEFAULT_SPI_CFG 1   ; # latching MISO on negative edge - hardware only

ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_axi_regmap CONFIG.CFG_INFO_0 $NUM_OF_SDI
ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_axi_regmap CONFIG.CFG_INFO_1 $CAPTURE_ZONE
ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_axi_regmap CONFIG.CFG_INFO_2 $CLK_MODE
ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_axi_regmap CONFIG.CFG_INFO_3 $DDR_EN

## to setup the sample rate of the system change the PULSE_PERIOD value of the
## CNV generator; the actual sample rate will be PULSE_PERIOD * (1/cnv_ref_clk)
set sampling_cycle [expr int(ceil(double($cnv_ref_clk * 1000000) / $adc_sampling_rate))]

ad_ip_instance axi_pwm_gen cnv_generator
ad_ip_parameter cnv_generator CONFIG.N_PWMS 2
ad_ip_parameter cnv_generator CONFIG.PULSE_0_PERIOD $sampling_cycle
ad_ip_parameter cnv_generator CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter cnv_generator CONFIG.PULSE_1_PERIOD $sampling_cycle
ad_ip_parameter cnv_generator CONFIG.PULSE_1_WIDTH 1
ad_ip_parameter cnv_generator CONFIG.PULSE_1_OFFSET 1

ad_ip_instance spi_axis_reorder data_reorder
ad_ip_parameter data_reorder CONFIG.NUM_OF_LANES $NUM_OF_SDI

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad463x_dma
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad463x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad463x_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad463x_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# Trigger for SPI offload
if {$CAPTURE_ZONE == 1} {

  ## SPI mode is using the echo SCLK, on echo SPI and Master mode the BUSY
  #  is used for SDI latching
  switch $CLK_MODE {
    0 {
      ad_connect $hier_spi_engine/echo_sclk ad463x_echo_sclk
    }
    1 -
    2 {
      puts "ERROR: Invalid configuration option. CAPTURE_ZONE 1 can be used only in SPI mode (CLK_MODE == 1)."
      exit 2
    }
    default {
      puts "ERROR: Invalid value for CLK_MODE. (valid values are 0 or 1 or 2)"
      exit 2
    }
  }

  # Zone 1 - trigger to BUSY's negative edge
  create_bd_cell -type module -reference sync_bits busy_sync
  create_bd_cell -type module -reference ad_edge_detect busy_capture
  set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

  ad_connect spi_clk busy_capture/clk
  ad_connect spi_clk busy_sync/out_clk
  ad_connect busy_capture/rst GND
  ad_connect $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn busy_sync/out_resetn

  ad_connect ad463x_busy busy_sync/in_bits
  ad_connect busy_sync/out_bits busy_capture/signal_in
  ad_connect $hier_spi_engine/trigger busy_capture/signal_out
  ## SDI is latched by the SPIE execution module
  ad_connect  $hier_spi_engine/m_axis_sample data_reorder/s_axis

} elseif {$CAPTURE_ZONE == 2} {

  # Zone 2 - trigger to next consecutive CNV
  ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_offload CONFIG.ASYNC_TRIG 1
  ad_connect cnv_generator/pwm_0 $hier_spi_engine/trigger

  ## SPI mode is using the echo SCLK, on echo SPI and Master mode the BUSY
  #  is used for SDI latching

  ad_connect $hier_spi_engine/echo_sclk ad463x_echo_sclk
  switch $CLK_MODE {
    0 {
      ## SDI is latched by the SPIE execution module
      ad_connect  $hier_spi_engine/m_axis_sample data_reorder/s_axis
    }
    1 -
    2 {
      ## SDI is latched by the data capture
      ad_ip_instance ad463x_data_capture data_capture
      ad_ip_parameter data_capture CONFIG.DDR_EN $DDR_EN
      ad_ip_parameter data_capture CONFIG.NUM_OF_LANES $NUM_OF_SDI

      ad_connect spi_clk data_capture/clk
      ad_connect ad463x_spi_cs data_capture/csn
      ad_connect ad463x_busy data_capture/echo_sclk
      ad_connect ad463x_spi_sdi data_capture/data_in

      ad_connect data_capture/m_axis data_reorder/s_axis

    }
    default {
      puts "ERROR: Invalid value for CLK_MODE. (valid values are 0 or 1 or 2)"
      exit 2
    }
  }

} else {

  puts "ERROR: Invalid capture zone, please choose 1 or 2."
  exit 2

}
ad_connect ad463x_cnv cnv_generator/pwm_1

# clocks

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect $sys_cpu_clk cnv_generator/s_axi_aclk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect spi_clk data_reorder/axis_aclk
ad_connect spi_clk axi_ad463x_dma/s_axis_aclk
ad_connect ad463x_ext_clk cnv_generator/ext_clk

# resets

ad_connect $sys_cpu_resetn cnv_generator/s_axi_aresetn
ad_connect data_reorder/axis_aresetn VCC
ad_connect $sys_cpu_resetn $hier_spi_engine/resetn
ad_connect $sys_cpu_resetn axi_ad463x_dma/m_dest_axi_aresetn

# data path

ad_connect  $hier_spi_engine/${hier_spi_engine}_execution/cs ad463x_spi_cs
ad_connect  $hier_spi_engine/${hier_spi_engine}_execution/sclk ad463x_spi_sclk
ad_connect  $hier_spi_engine/${hier_spi_engine}_execution/sdo ad463x_spi_sdo
ad_connect  $hier_spi_engine/${hier_spi_engine}_execution/sdi ad463x_spi_sdi

ad_connect  axi_ad463x_dma/s_axis data_reorder/m_axis

# JESD204 architecture

create_bd_port -dir I glbl_clk_0

create_bd_port -dir O -from 1 -to 0 hmc7044_csn_o
create_bd_port -dir I -from 1 -to 0 hmc7044_csn_i
create_bd_port -dir I hmc7044_clk_i
create_bd_port -dir O hmc7044_clk_o
create_bd_port -dir I hmc7044_sdo_i
create_bd_port -dir O hmc7044_sdo_o
create_bd_port -dir I hmc7044_sdi_i

# adc peripherals

ad_ip_instance util_adxcvr util_adc_xcvr
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_adc_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_adc_xcvr CONFIG.RX_NUM_OF_LANES 16
ad_ip_parameter util_adc_xcvr CONFIG.RX_LANE_INVERT 390
ad_ip_parameter util_adc_xcvr CONFIG.RX_OUT_DIV 1

ad_ip_instance axi_adxcvr axi_ad9213_xcvr
ad_ip_parameter axi_ad9213_xcvr CONFIG.ID 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.NUM_OF_LANES 16
ad_ip_parameter axi_ad9213_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.SYS_CLK_SEL 0x3

adi_axi_jesd204_rx_create axi_ad9213_jesd 16
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2

adi_tpl_jesd204_rx_create rx_ad9213_tpl_core $RX_NUM_OF_LANES \
                                             $RX_NUM_OF_CONVERTERS \
                                             $RX_SAMPLES_PER_FRAME \
                                             $RX_SAMPLE_WIDTH

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

ad_ip_instance axi_dmac axi_ad9213_dma
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9213_dma CONFIG.ID 0
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9213_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9213_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_ad9213_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_dma_data_width

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_1

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/qpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_12

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_1
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_2
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_3
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_5
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_6
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_7
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_9
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_10
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_11
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_12
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_13
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_14
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_cpll_rst_*

ad_connect  $sys_cpu_resetn util_adc_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_adc_xcvr/up_clk

# connections (adc)

ad_xcvrcon util_adc_xcvr axi_ad9213_xcvr axi_ad9213_jesd {4 0 2 1 3 8 9 7 6 11 10 15 12 14 13 5} glbl_clk_0

## use global clock as device clock instead of rx_out_clk
delete_bd_objs [get_bd_nets util_adc_xcvr_rx_out_clk_0]

# connect clocks
# device clock domain
ad_connect  glbl_clk_0 rx_ad9213_tpl_core/link_clk

ad_connect  glbl_clk_0 axi_ad9213_fifo/adc_clk

# dma clock domain
ad_connect  $sys_cpu_clk axi_ad9213_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_ad9213_dma/s_axis_aclk

# connect resets
ad_connect  glbl_clk_0_rstgen/peripheral_reset axi_ad9213_fifo/adc_rst
ad_connect  $sys_cpu_resetn axi_ad9213_dma/m_dest_axi_aresetn

# connect dataflow
ad_connect  axi_ad9213_jesd/rx_sof rx_ad9213_tpl_core/link_sof
ad_connect  axi_ad9213_jesd/rx_data_tdata rx_ad9213_tpl_core/link_data
ad_connect  axi_ad9213_jesd/rx_data_tvalid rx_ad9213_tpl_core/link_valid

ad_connect rx_ad9213_tpl_core/adc_valid_0 axi_ad9213_fifo/adc_wr
ad_connect rx_ad9213_tpl_core/adc_data_0 axi_ad9213_fifo/adc_wdata

ad_connect rx_ad9213_tpl_core/adc_dovf axi_ad9213_fifo/adc_wovf

ad_connect  axi_ad9213_fifo/dma_wr axi_ad9213_dma/s_axis_valid
ad_connect  axi_ad9213_fifo/dma_wdata axi_ad9213_dma/s_axis_data
ad_connect  axi_ad9213_fifo/dma_wready axi_ad9213_dma/s_axis_ready
ad_connect  axi_ad9213_fifo/dma_xfer_req axi_ad9213_dma/s_axis_xfer_req

ad_ip_instance axi_quad_spi hmc7044_spi
ad_ip_parameter hmc7044_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter hmc7044_spi CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter hmc7044_spi CONFIG.C_SCK_RATIO 8

ad_connect hmc7044_csn_i hmc7044_spi/ss_i
ad_connect hmc7044_csn_o hmc7044_spi/ss_o
ad_connect hmc7044_clk_i hmc7044_spi/sck_i
ad_connect hmc7044_clk_o hmc7044_spi/sck_o
ad_connect hmc7044_sdo_i hmc7044_spi/io0_i
ad_connect hmc7044_sdo_o hmc7044_spi/io0_o
ad_connect hmc7044_sdi_i hmc7044_spi/io1_i

ad_connect $sys_cpu_clk hmc7044_spi/ext_spi_clk

# interconnect (cpu)
ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44b00000 cnv_generator
ad_cpu_interconnect 0x44a30000 axi_ad463x_dma
ad_cpu_interconnect 0x44a80000 spi_clkgen

ad_cpu_interconnect 0x44a60000 axi_ad9213_xcvr
ad_cpu_interconnect 0x44a10000 rx_ad9213_tpl_core
ad_cpu_interconnect 0x44a90000 axi_ad9213_jesd
ad_cpu_interconnect 0x44a71000 hmc7044_spi
ad_cpu_interconnect 0x7c420000 axi_ad9213_dma

# interconnect (gt/adc)
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_dma/m_dest_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad463x_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-17 mb-7 hmc7044_spi/ip2intc_irpt
ad_cpu_interrupt ps-12 mb-12 axi_ad9213_dma/irq
ad_cpu_interrupt ps-11 mb-13 axi_ad9213_jesd/irq

ad_cpu_interrupt ps-14 mb-10 axi_ad463x_dma/irq
ad_cpu_interrupt ps-13 mb-11 $hier_spi_engine/irq
