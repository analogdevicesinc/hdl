###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/axi_tdd/scripts/axi_tdd.tcl

# ada4355 interfaces for 4 instances

# Instance 0
create_bd_port -dir I dco_0_p
create_bd_port -dir I dco_0_n
create_bd_port -dir I d0a_0_p
create_bd_port -dir I d0a_0_n
create_bd_port -dir I d1a_0_p
create_bd_port -dir I d1a_0_n
create_bd_port -dir I sync_0_n
create_bd_port -dir I frame_0_p
create_bd_port -dir I frame_0_n

# Instance 1
create_bd_port -dir I dco_1_p
create_bd_port -dir I dco_1_n
create_bd_port -dir I d0a_1_p
create_bd_port -dir I d0a_1_n
create_bd_port -dir I d1a_1_p
create_bd_port -dir I d1a_1_n
create_bd_port -dir I sync_1_n
create_bd_port -dir I frame_1_p
create_bd_port -dir I frame_1_n

# Instance 2
create_bd_port -dir I dco_2_p
create_bd_port -dir I dco_2_n
create_bd_port -dir I d0a_2_p
create_bd_port -dir I d0a_2_n
create_bd_port -dir I d1a_2_p
create_bd_port -dir I d1a_2_n
create_bd_port -dir I sync_2_n
create_bd_port -dir I frame_2_p
create_bd_port -dir I frame_2_n

# Instance 3
create_bd_port -dir I dco_3_p
create_bd_port -dir I dco_3_n
create_bd_port -dir I d0a_3_p
create_bd_port -dir I d0a_3_n
create_bd_port -dir I d1a_3_p
create_bd_port -dir I d1a_3_n
create_bd_port -dir I sync_3_n
create_bd_port -dir I frame_3_p
create_bd_port -dir I frame_3_n

# TDD external ports
create_bd_port -dir I trig_fmc_in
create_bd_port -dir O trig_fmc_out

# axi_ada4355 instances and DMAs
#
# On Zedboard FMC LPC, LVDS pins span two IO banks:
#   Instances 0,1 -> bank 34 (IO_DELAY_GROUP adc_if_delay_group_0)
#   Instances 2,3 -> bank 35 (IO_DELAY_GROUP adc_if_delay_group_1)
# Only one IDELAYCTRL per group (instance 0 for bank 34, instance 2 for bank 35).

# Instance 0 - Creates IDELAYCTRL for bank 34
ad_ip_instance axi_ada4355 axi_ada4355_adc_0
ad_ip_parameter axi_ada4355_adc_0 CONFIG.IODELAY_CTRL 1
ad_ip_parameter axi_ada4355_adc_0 CONFIG.IO_DELAY_GROUP {adc_if_delay_group_0}

ad_ip_instance axi_dmac axi_ada4355_dma_0
ad_ip_parameter axi_ada4355_dma_0 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma_0 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma_0 CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma_0 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ada4355_dma_0 CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma_0 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma_0 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma_0 CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma_0 CONFIG.DMA_DATA_WIDTH_DEST 64

# Instance 1 - Shares IDELAYCTRL with instance 0 (bank 34)
ad_ip_instance axi_ada4355 axi_ada4355_adc_1
ad_ip_parameter axi_ada4355_adc_1 CONFIG.IODELAY_CTRL 0
ad_ip_parameter axi_ada4355_adc_1 CONFIG.IO_DELAY_GROUP {adc_if_delay_group_0}

ad_ip_instance axi_dmac axi_ada4355_dma_1
ad_ip_parameter axi_ada4355_dma_1 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma_1 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma_1 CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma_1 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ada4355_dma_1 CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma_1 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma_1 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma_1 CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma_1 CONFIG.DMA_DATA_WIDTH_DEST 64

# Instance 2 - Creates IDELAYCTRL for bank 35
ad_ip_instance axi_ada4355 axi_ada4355_adc_2
ad_ip_parameter axi_ada4355_adc_2 CONFIG.IODELAY_CTRL 1
ad_ip_parameter axi_ada4355_adc_2 CONFIG.IO_DELAY_GROUP {adc_if_delay_group_1}

ad_ip_instance axi_dmac axi_ada4355_dma_2
ad_ip_parameter axi_ada4355_dma_2 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma_2 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma_2 CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma_2 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ada4355_dma_2 CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma_2 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma_2 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma_2 CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma_2 CONFIG.DMA_DATA_WIDTH_DEST 64

# Instance 3 - Shares IDELAYCTRL with instance 2 (bank 35)
ad_ip_instance axi_ada4355 axi_ada4355_adc_3
ad_ip_parameter axi_ada4355_adc_3 CONFIG.IODELAY_CTRL 0
ad_ip_parameter axi_ada4355_adc_3 CONFIG.IO_DELAY_GROUP {adc_if_delay_group_1}

ad_ip_instance axi_dmac axi_ada4355_dma_3
ad_ip_parameter axi_ada4355_dma_3 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ada4355_dma_3 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ada4355_dma_3 CONFIG.CYCLIC 0
ad_ip_parameter axi_ada4355_dma_3 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ada4355_dma_3 CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ada4355_dma_3 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ada4355_dma_3 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ada4355_dma_3 CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ada4355_dma_3 CONFIG.DMA_DATA_WIDTH_DEST 64

# TDD controller for LiDAR timing control
# Channel 0: Laser trigger output
# Channels 1-4: Per-DMA sync (controls when each DMA starts capturing)

set TDD_CHANNEL_CNT 5
set TDD_DEFAULT_POL 0b00000
set TDD_REG_WIDTH 32
set TDD_BURST_WIDTH 32
set TDD_SYNC_WIDTH 64
set TDD_SYNC_INT 1
set TDD_SYNC_EXT 1
set TDD_SYNC_EXT_CDC 1

ad_tdd_gen_create axi_tdd_0 $TDD_CHANNEL_CNT \
  $TDD_DEFAULT_POL \
  $TDD_REG_WIDTH \
  $TDD_BURST_WIDTH \
  $TDD_SYNC_WIDTH \
  $TDD_SYNC_INT \
  $TDD_SYNC_EXT \
  $TDD_SYNC_EXT_CDC

ad_ip_instance ilvector_logic logic_inv [list \
  C_OPERATION {not} \
  C_SIZE 1]

# connect interfaces to axi_ada4355 instances

# Instance 0
ad_connect dco_0_p              axi_ada4355_adc_0/dco_p
ad_connect dco_0_n              axi_ada4355_adc_0/dco_n
ad_connect d0a_0_p              axi_ada4355_adc_0/d0a_p
ad_connect d0a_0_n              axi_ada4355_adc_0/d0a_n
ad_connect d1a_0_p              axi_ada4355_adc_0/d1a_p
ad_connect d1a_0_n              axi_ada4355_adc_0/d1a_n
ad_connect sync_0_n             axi_ada4355_adc_0/sync_n
ad_connect frame_0_p            axi_ada4355_adc_0/fco_p
ad_connect frame_0_n            axi_ada4355_adc_0/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc_0/delay_clk

# Instance 1
ad_connect dco_1_p              axi_ada4355_adc_1/dco_p
ad_connect dco_1_n              axi_ada4355_adc_1/dco_n
ad_connect d0a_1_p              axi_ada4355_adc_1/d0a_p
ad_connect d0a_1_n              axi_ada4355_adc_1/d0a_n
ad_connect d1a_1_p              axi_ada4355_adc_1/d1a_p
ad_connect d1a_1_n              axi_ada4355_adc_1/d1a_n
ad_connect sync_1_n             axi_ada4355_adc_1/sync_n
ad_connect frame_1_p            axi_ada4355_adc_1/fco_p
ad_connect frame_1_n            axi_ada4355_adc_1/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc_1/delay_clk

# Instance 2
ad_connect dco_2_p              axi_ada4355_adc_2/dco_p
ad_connect dco_2_n              axi_ada4355_adc_2/dco_n
ad_connect d0a_2_p              axi_ada4355_adc_2/d0a_p
ad_connect d0a_2_n              axi_ada4355_adc_2/d0a_n
ad_connect d1a_2_p              axi_ada4355_adc_2/d1a_p
ad_connect d1a_2_n              axi_ada4355_adc_2/d1a_n
ad_connect sync_2_n             axi_ada4355_adc_2/sync_n
ad_connect frame_2_p            axi_ada4355_adc_2/fco_p
ad_connect frame_2_n            axi_ada4355_adc_2/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc_2/delay_clk

# Instance 3
ad_connect dco_3_p              axi_ada4355_adc_3/dco_p
ad_connect dco_3_n              axi_ada4355_adc_3/dco_n
ad_connect d0a_3_p              axi_ada4355_adc_3/d0a_p
ad_connect d0a_3_n              axi_ada4355_adc_3/d0a_n
ad_connect d1a_3_p              axi_ada4355_adc_3/d1a_p
ad_connect d1a_3_n              axi_ada4355_adc_3/d1a_n
ad_connect sync_3_n             axi_ada4355_adc_3/sync_n
ad_connect frame_3_p            axi_ada4355_adc_3/fco_p
ad_connect frame_3_n            axi_ada4355_adc_3/fco_n
ad_connect $sys_iodelay_clk     axi_ada4355_adc_3/delay_clk

# connect datapaths for all instances

# Instance 0
ad_connect axi_ada4355_adc_0/adc_data  axi_ada4355_dma_0/fifo_wr_din
ad_connect axi_ada4355_adc_0/adc_valid axi_ada4355_dma_0/fifo_wr_en
ad_connect axi_ada4355_adc_0/adc_dovf  axi_ada4355_dma_0/fifo_wr_overflow
ad_connect axi_ada4355_adc_0/adc_clk   axi_ada4355_dma_0/fifo_wr_clk
ad_connect $sys_cpu_resetn axi_ada4355_dma_0/m_dest_axi_aresetn

# Instance 1
ad_connect axi_ada4355_adc_1/adc_data  axi_ada4355_dma_1/fifo_wr_din
ad_connect axi_ada4355_adc_1/adc_valid axi_ada4355_dma_1/fifo_wr_en
ad_connect axi_ada4355_adc_1/adc_dovf  axi_ada4355_dma_1/fifo_wr_overflow
ad_connect axi_ada4355_adc_1/adc_clk   axi_ada4355_dma_1/fifo_wr_clk
ad_connect $sys_cpu_resetn axi_ada4355_dma_1/m_dest_axi_aresetn

# Instance 2
ad_connect axi_ada4355_adc_2/adc_data  axi_ada4355_dma_2/fifo_wr_din
ad_connect axi_ada4355_adc_2/adc_valid axi_ada4355_dma_2/fifo_wr_en
ad_connect axi_ada4355_adc_2/adc_dovf  axi_ada4355_dma_2/fifo_wr_overflow
ad_connect axi_ada4355_adc_2/adc_clk   axi_ada4355_dma_2/fifo_wr_clk
ad_connect $sys_cpu_resetn axi_ada4355_dma_2/m_dest_axi_aresetn

# Instance 3
ad_connect axi_ada4355_adc_3/adc_data  axi_ada4355_dma_3/fifo_wr_din
ad_connect axi_ada4355_adc_3/adc_valid axi_ada4355_dma_3/fifo_wr_en
ad_connect axi_ada4355_adc_3/adc_dovf  axi_ada4355_dma_3/fifo_wr_overflow
ad_connect axi_ada4355_adc_3/adc_clk   axi_ada4355_dma_3/fifo_wr_clk
ad_connect $sys_cpu_resetn axi_ada4355_dma_3/m_dest_axi_aresetn

# TDD connections

ad_connect axi_ada4355_adc_0/adc_clk axi_tdd_0/clk
ad_connect $sys_cpu_reset logic_inv/Op1
ad_connect logic_inv/Res axi_tdd_0/resetn
ad_connect axi_tdd_0/sync_in trig_fmc_in
ad_connect axi_tdd_0/tdd_channel_0 trig_fmc_out
ad_connect axi_tdd_0/tdd_channel_1 axi_ada4355_dma_0/sync
ad_connect axi_tdd_0/tdd_channel_2 axi_ada4355_dma_1/sync
ad_connect axi_tdd_0/tdd_channel_3 axi_ada4355_dma_2/sync
ad_connect axi_tdd_0/tdd_channel_4 axi_ada4355_dma_3/sync

# interconnects

ad_cpu_interconnect 0x44A00000 axi_ada4355_adc_0
ad_cpu_interconnect 0x44A10000 axi_ada4355_adc_1
ad_cpu_interconnect 0x44A20000 axi_ada4355_adc_2
ad_cpu_interconnect 0x44A30000 axi_ada4355_adc_3

ad_cpu_interconnect 0x44A40000 axi_ada4355_dma_0
ad_cpu_interconnect 0x44A50000 axi_ada4355_dma_1
ad_cpu_interconnect 0x44A60000 axi_ada4355_dma_2
ad_cpu_interconnect 0x44A70000 axi_ada4355_dma_3

ad_cpu_interconnect 0x44A80000 axi_tdd_0

# Memory interconnect for all DMAs
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma_0/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma_1/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma_2/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_ada4355_dma_3/m_dest_axi

# interrupts
ad_cpu_interrupt ps-13 mb-13 axi_ada4355_dma_0/irq
ad_cpu_interrupt ps-14 mb-14 axi_ada4355_dma_1/irq
ad_cpu_interrupt ps-15 mb-15 axi_ada4355_dma_2/irq
ad_cpu_interrupt ps-10 mb-10 axi_ada4355_dma_3/irq
