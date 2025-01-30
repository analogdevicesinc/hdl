###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

create_bd_port -dir I -from 2 -to 0 spi0_probe_csn
create_bd_port -dir I spi0_probe_sclk
create_bd_port -dir I spi0_probe_mosi
create_bd_port -dir I spi0_probe_miso

set my_ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $my_ila
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $my_ila
set_property -dict [list CONFIG.C_DATA_DEPTH {8192}] $my_ila
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $my_ila
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $my_ila
set_property -dict [list CONFIG.C_PROBE1_MU_CNT {2} ] $my_ila
set_property -dict [list CONFIG.C_PROBE0_MU_CNT {2} ] $my_ila
set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] $my_ila
set_property -dict [list CONFIG.C_PROBE0_WIDTH {3}] $my_ila
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $my_ila
set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $my_ila
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $my_ila

ad_connect $my_ila/clk     sys_ps8/pl_clk0
ad_connect $my_ila/probe0  spi0_probe_csn
ad_connect $my_ila/probe1  spi0_probe_sclk
ad_connect $my_ila/probe2  spi0_probe_mosi
ad_connect $my_ila/probe3  spi0_probe_miso

set JESD_M    $ad_project_params(JESD_M)
set JESD_L    $ad_project_params(JESD_L)
set NUM_LINKS $ad_project_params(NUM_LINKS)

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
  TX_NUM_OF_LANES $MAX_NUM_OF_LANES
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

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 dac_jesd204_xcvr
ad_cpu_interconnect 0x44A04000 dac_jesd204_transport
ad_cpu_interconnect 0x44A90000 dac_jesd204_link
ad_cpu_interconnect 0x7c420000 dac_dma

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 dac_jesd204_link/irq
ad_cpu_interrupt ps-12 mb-13 dac_dma/irq

ad_connect axi_dac_fifo/bypass dac_fifo_bypass

