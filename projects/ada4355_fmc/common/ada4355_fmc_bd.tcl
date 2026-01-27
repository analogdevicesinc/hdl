###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Source the TDD library
source $ad_hdl_dir/library/axi_tdd/scripts/axi_tdd.tcl

# system level parameter

set BUFMRCE_EN $ad_project_params(BUFMRCE_EN)
puts "build parameters: BUFMRCE_EN: $BUFMRCE_EN"

# TDD parameters for LiDAR control
set TDD_CHANNEL_CNT 3
set TDD_DEFAULT_POL 0b000
set TDD_REG_WIDTH 32
set TDD_BURST_WIDTH 32
set TDD_SYNC_WIDTH 64
set TDD_SYNC_INT 1
set TDD_SYNC_EXT 1
set TDD_SYNC_EXT_CDC 1

# ada4355 interface

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I d0a_p
create_bd_port -dir I d0a_n
create_bd_port -dir I d1a_p
create_bd_port -dir I d1a_n
create_bd_port -dir I sync_n
create_bd_port -dir I frame_p
create_bd_port -dir I frame_n

# TDD external ports for LiDAR control (directly connected to FMC J3/J4 SMA connectors)
create_bd_port -dir I trig_fmc_in
create_bd_port -dir O trig_fmc_out

# axi_ada4355

ad_ip_instance axi_ada4355 axi_ada4355_adc
ad_ip_parameter axi_ada4355_adc CONFIG.BUFMRCE_EN $BUFMRCE_EN

# dma for rx data

ad_ip_instance axi_dmac axi_ada4355_dma
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ada4355_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# TDD controller instantiation
# Channel allocation for LiDAR:
# Channel 0: Laser trigger output
# Channel 1: DMA sync (controls when DMA starts capturing)

ad_tdd_gen_create axi_tdd_0 $TDD_CHANNEL_CNT \
  $TDD_DEFAULT_POL \
  $TDD_REG_WIDTH \
  $TDD_BURST_WIDTH \
  $TDD_SYNC_WIDTH \
  $TDD_SYNC_INT \
  $TDD_SYNC_EXT \
  $TDD_SYNC_EXT_CDC

# Create reset inverter for TDD (needs active high reset)
ad_ip_instance util_vector_logic logic_inv [list \
  C_SIZE 1 \
  C_OPERATION not \
]

# Note: ADC valid signal connected directly to DMA (no TDD gating)
# Data flow controlled by DMA SYNC_TRANSFER_START with CH2

# connect interface to axi_ad4355_adc

ad_connect dco_p                axi_ada4355_adc/dco_p
ad_connect dco_n                axi_ada4355_adc/dco_n
ad_connect d0a_p                axi_ada4355_adc/d0a_p
ad_connect d0a_n                axi_ada4355_adc/d0a_n
ad_connect d1a_p                axi_ada4355_adc/d1a_p
ad_connect d1a_n                axi_ada4355_adc/d1a_n
ad_connect sync_n               axi_ada4355_adc/sync_n
ad_connect frame_p              axi_ada4355_adc/fco_p
ad_connect frame_n              axi_ada4355_adc/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc/delay_clk

# connect datapath with TDD gating

ad_connect axi_ada4355_adc/adc_data  axi_ada4355_dma/fifo_wr_din
ad_connect axi_ada4355_adc/adc_dovf  axi_ada4355_dma/fifo_wr_overflow

# Connect ADC valid directly to DMA (no gating)
# DMA will use SYNC (CH2) to control when to start capturing
ad_connect axi_ada4355_adc/adc_valid axi_ada4355_dma/fifo_wr_en

# system runs on if.v's received clock

ad_connect axi_ada4355_adc/adc_clk axi_ada4355_dma/fifo_wr_clk

# TDD connections
# Connect TDD to ADC clock domain for precise timing control
ad_connect axi_ada4355_adc/adc_clk axi_tdd_0/clk
ad_connect $sys_cpu_reset logic_inv/Op1
ad_connect logic_inv/Res axi_tdd_0/resetn

# TDD synchronization (from FMC J3 SMA input)
ad_connect axi_tdd_0/sync_in trig_fmc_in

# TDD channel connections (to FMC J4 SMA output)
ad_connect axi_tdd_0/tdd_channel_0 trig_fmc_out
ad_connect axi_tdd_0/tdd_channel_1 axi_ada4355_dma/sync

ad_connect $sys_cpu_resetn axi_ada4355_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44A00000 axi_ada4355_adc
ad_cpu_interconnect 0x44A30000 axi_ada4355_dma
ad_cpu_interconnect 0x44A40000 axi_tdd_0

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ada4355_dma/irq
