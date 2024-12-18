###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set JESD_M    $ad_project_params(JESD_M)
set JESD_L    $ad_project_params(JESD_L)
set NUM_LINKS 1

set NUM_OF_CONVERTERS [expr $NUM_LINKS * $JESD_M]
set NUM_OF_LANES [expr $NUM_LINKS * $JESD_L]
set SAMPLES_PER_FRAME $ad_project_params(JESD_S)
set SAMPLE_WIDTH $ad_project_params(JESD_NP)

set DAC_DATA_WIDTH [expr $NUM_OF_LANES * 32]
set SAMPLES_PER_CHANNEL [expr $DAC_DATA_WIDTH / $NUM_OF_CONVERTERS / $SAMPLE_WIDTH]

set MAX_NUM_OF_LANES 8
# Top level ports

create_bd_port -dir I dac_fifo_bypass

# dac peripherals

# JESD204 PHY layer peripheral
ad_ip_instance axi_adxcvr dac_jesd204_xcvr [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 1 \
]

# JESD204 link layer peripheral
adi_axi_jesd204_tx_create dac_jesd204_link $NUM_OF_LANES $NUM_LINKS

# JESD204 transport layer peripheral
adi_tpl_jesd204_tx_create dac_jesd204_transport $NUM_OF_LANES \
                                                $NUM_OF_CONVERTERS \
                                                $SAMPLES_PER_FRAME \
                                                $SAMPLE_WIDTH

ad_ip_instance util_upack2 dac_upack [list \
  NUM_OF_CHANNELS $NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $SAMPLE_WIDTH \
]

set dac_dma_data_width $DAC_DATA_WIDTH
ad_ip_instance axi_dmac dac_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  DMA_DATA_WIDTH_SRC 64 \
  DMA_DATA_WIDTH_DEST $dac_dma_data_width \
]

ad_dacfifo_create axi_dac_fifo \
                  $DAC_DATA_WIDTH \
                  $dac_dma_data_width \
                  $dac_fifo_address_width

# shared transceiver core

ad_ip_instance util_adxcvr util_dac_jesd204_xcvr [list \
  RX_NUM_OF_LANES 0 \
  TX_NUM_OF_LANES $MAX_NUM_OF_LANES \
  TX_LANE_INVERT [expr 0x0F] \
  QPLL_REFCLK_DIV 1 \
  QPLL_FBDIV_RATIO 1 \
  QPLL_FBDIV 0x80 \
  TX_OUT_DIV 1 \
]

ad_connect sys_cpu_resetn util_dac_jesd204_xcvr/up_rstn
ad_connect sys_cpu_clk util_dac_jesd204_xcvr/up_clk

# reference clocks & resets

for {set i 0} {$i < $MAX_NUM_OF_LANES} {incr i} {
  if {$i % 4 == 0} {
    create_bd_port -dir I tx_ref_clk_${i}
    ad_xcvrpll tx_ref_clk_${i} util_dac_jesd204_xcvr/qpll_ref_clk_${i}
    set quad_ref_clk tx_ref_clk_${i}
  }
  ad_xcvrpll $quad_ref_clk util_dac_jesd204_xcvr/cpll_ref_clk_${i}
}

ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_qpll_rst_*
ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_cpll_rst_*

# connections (dac)

ad_xcvrcon util_dac_jesd204_xcvr dac_jesd204_xcvr dac_jesd204_link {} {} {} $MAX_NUM_OF_LANES

ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 dac_jesd204_transport/link_clk
ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 dac_upack/clk
ad_connect dac_jesd204_link_rstgen/peripheral_reset dac_upack/reset

ad_connect dac_jesd204_link/tx_data dac_jesd204_transport/link

ad_connect dac_jesd204_transport/dac_valid_0 dac_upack/fifo_rd_en
for {set i 0} {$i < $NUM_OF_CONVERTERS} {incr i} {
  ad_connect dac_upack/fifo_rd_data_$i dac_jesd204_transport/dac_data_$i
  ad_connect dac_jesd204_transport/dac_enable_$i  dac_upack/enable_$i
}

ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 axi_dac_fifo/dac_clk
ad_connect dac_jesd204_link_rstgen/peripheral_reset axi_dac_fifo/dac_rst
ad_connect dac_upack/s_axis_valid VCC
ad_connect dac_upack/s_axis_ready axi_dac_fifo/dac_valid
ad_connect dac_upack/s_axis_data axi_dac_fifo/dac_data
ad_connect dac_jesd204_transport/dac_dunf axi_dac_fifo/dac_dunf
ad_connect sys_cpu_clk axi_dac_fifo/dma_clk
ad_connect sys_cpu_reset axi_dac_fifo/dma_rst
ad_connect sys_cpu_clk dac_dma/m_axis_aclk
ad_connect sys_cpu_resetn dac_dma/m_src_axi_aresetn
ad_connect axi_dac_fifo/dma_xfer_req dac_dma/m_axis_xfer_req
ad_connect axi_dac_fifo/dma_ready dac_dma/m_axis_ready
ad_connect axi_dac_fifo/dma_data dac_dma/m_axis_data
ad_connect axi_dac_fifo/dma_valid dac_dma/m_axis_valid
ad_connect axi_dac_fifo/dma_xfer_last dac_dma/m_axis_last

# SPI for FMC interposer
# spi_fmc_csn [0] - FMC_CS1 (AD9166)
# spi_fmc_csn [1] - FMC_CS2 (HMC7044)
# spi_fmc_csn [2] - FMC_CS3 (ADF4372)
# spi_fmc_csn [3] - FMC_CS4 (Amplifier)
create_bd_port -dir O -from 3 -to 0 spi_fmc_csn_o
create_bd_port -dir I -from 3 -to 0 spi_fmc_csn_i
create_bd_port -dir I spi_fmc_clk_i
create_bd_port -dir O spi_fmc_clk_o
create_bd_port -dir I spi_fmc_sdo_i
create_bd_port -dir O spi_fmc_sdo_o
create_bd_port -dir I spi_fmc_sdi_i

# SPI at 100/4 = 25 MHz
ad_ip_instance axi_quad_spi axi_spi_fmc
ad_ip_parameter axi_spi_fmc CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fmc CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi_fmc CONFIG.C_SCK_RATIO 8

ad_connect spi_fmc_csn_i axi_spi_fmc/ss_i
ad_connect spi_fmc_csn_o axi_spi_fmc/ss_o
ad_connect spi_fmc_clk_i axi_spi_fmc/sck_i
ad_connect spi_fmc_clk_o axi_spi_fmc/sck_o
ad_connect spi_fmc_sdo_i axi_spi_fmc/io0_i
ad_connect spi_fmc_sdo_o axi_spi_fmc/io0_o
ad_connect spi_fmc_sdi_i axi_spi_fmc/io1_i

ad_connect $sys_cpu_clk axi_spi_fmc/ext_spi_clk

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 dac_jesd204_xcvr
ad_cpu_interconnect 0x44A04000 dac_jesd204_transport
ad_cpu_interconnect 0x44A90000 dac_jesd204_link
ad_cpu_interconnect 0x7c420000 dac_dma
ad_cpu_interconnect 0x45300000 axi_spi_fmc

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-9 mb-7 axi_spi_fmc/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-15 dac_jesd204_link/irq
ad_cpu_interrupt ps-12 mb-13 dac_dma/irq

ad_connect axi_dac_fifo/bypass dac_fifo_bypass
