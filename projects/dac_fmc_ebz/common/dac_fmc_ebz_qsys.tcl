#
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# In this HDL repository, there are many different and unique modules, consisting
# of various HDL (Verilog or VHDL) components. The individual modules are
# developed independently, and may be accompanied by separate and unique license
# terms.
#
# The user should read each of these license terms, and understand the
# freedoms and responsibilities that he or she has by using this source/core.
#
# This core is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.
#
# Redistribution and use of source or resulting binaries, with or without modification
# of this file, are permitted under one of the following two license terms:
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory
#      of this repository (LICENSE_GPL2), and also online at:
#      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# OR
#
#   2. An ADI specific BSD license, which can be found in the top level directory
#      of this repository (LICENSE_ADIBSD), and also on-line at:
#      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
#      This will allow to generate bit files and not release the source code,
#      as long as it attaches to an ADI device.
#

# This design supports multiple device in multiple modes. Some of them have a
# higher lane rate, some of htem have a lower lane rate.
#
# If you are building the design for a specific part in a specific mode and the
# lane rate is less than the maximum specified here you can reduce it, which
# might improve timing closure.

set MODE  $ad_project_params(MODE)
set DEVICE $ad_project_params(DEVICE)
set NUM_OF_LANES $ad_project_params(JESD_L)
set DAC_DATA_WIDTH [expr $NUM_OF_LANES * 32]

set MAX_LANE_RATE 14200
set MAX_DEVICE_CLOCK [expr $MAX_LANE_RATE / 40]

proc set_instance_parameter_values {inst values} {
  foreach {k v} $values {
    set_instance_parameter_value $inst $k $v
  }
}

proc export_interface {name export_of {type conduit} {direction end}} {
  add_interface $name $type $direction
  set_interface_property $name EXPORT_OF $export_of
}

# DAC JESD204 Link + PHY Layer Core

add_instance dac_jesd204_link adi_jesd204
set_instance_parameter_values dac_jesd204_link [list \
  ID 0 \
  TX_OR_RX_N 1 \
  NUM_OF_LANES $NUM_OF_LANES \
  LANE_RATE $MAX_LANE_RATE \
  REFCLK_FREQUENCY $MAX_DEVICE_CLOCK \
  SOFT_PCS true \
  LANE_INVERT 0xf0 \
]

add_connection sys_clk.clk dac_jesd204_link.sys_clk
add_connection sys_clk.clk_reset dac_jesd204_link.sys_resetn

export_interface tx_ref_clk dac_jesd204_link.ref_clk clock source
export_interface tx_serial_data dac_jesd204_link.serial_data
export_interface tx_sysref dac_jesd204_link.sysref
export_interface tx_sync dac_jesd204_link.sync

# DAC Transport Layer Core

add_instance dac_jesd204_transport ad_ip_jesd204_tpl_dac
apply_preset dac_jesd204_transport "${DEVICE} Mode ${MODE}"

add_connection dac_jesd204_link.link_clk dac_jesd204_transport.link_clk
add_connection dac_jesd204_transport.link_data dac_jesd204_link.link_data
add_connection sys_clk.clk_reset dac_jesd204_transport.s_axi_reset
add_connection sys_clk.clk dac_jesd204_transport.s_axi_clock

# DAC channel unpack

# Propagate framer configuration to upack core
set NUM_OF_CHANNELS [get_instance_parameter_value dac_jesd204_transport NUM_CHANNELS]
set SAMPLE_DATA_WIDTH [get_instance_parameter_value dac_jesd204_transport BITS_PER_SAMPLE]
set SAMPLES_PER_CHANNEL [get_instance_parameter_value dac_jesd204_transport SAMPLES_PER_CHANNEL]

add_instance dac_upack util_upack2
set_instance_parameter_values dac_upack [list \
  NUM_OF_CHANNELS $NUM_OF_CHANNELS \
  SAMPLES_PER_CHANNEL $SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $SAMPLE_DATA_WIDTH \
  INTERFACE_TYPE 1 \
]

add_connection dac_jesd204_link.link_clk dac_upack.clk
add_connection dac_jesd204_link.link_reset dac_upack.reset
for {set i 0} {$i < $NUM_OF_CHANNELS} {incr i} {
  add_connection dac_jesd204_transport.dac_ch_$i dac_upack.dac_ch_$i
}

# DAC offload memory
ad_dacfifo_create avl_dac_fifo \
                  $DAC_DATA_WIDTH \
                  $DAC_DATA_WIDTH \
                  $dac_fifo_address_width

set_instance_parameter_value avl_dac_fifo DAC_DATA_WIDTH \
  [expr $NUM_OF_CHANNELS * $SAMPLE_DATA_WIDTH * $SAMPLES_PER_CHANNEL]

export_interface dac_fifo_bypass avl_dac_fifo.if_bypass

add_connection dac_jesd204_link.link_clk avl_dac_fifo.if_dac_clk
add_connection dac_jesd204_link.link_reset avl_dac_fifo.if_dac_rst
add_connection dac_upack.if_packed_fifo_rd_en avl_dac_fifo.if_dac_valid
add_connection avl_dac_fifo.if_dac_data dac_upack.if_packed_fifo_rd_data
add_connection avl_dac_fifo.if_dac_dunf dac_jesd204_transport.if_dac_dunf

# DAC DMA

add_instance dac_dma axi_dmac
set_instance_parameter_values dac_dma [list \
  DMA_DATA_WIDTH_SRC 128 \
  DMA_DATA_WIDTH_DEST $DAC_DATA_WIDTH \
  CYCLIC 1 \
  DMA_TYPE_DEST 1 \
  DMA_TYPE_SRC 0 \
  FIFO_SIZE 16 \
  HAS_AXIS_TLAST 1 \
  AXI_SLICE_DEST 1 \
  AXI_SLICE_SRC 1 \
]

add_connection sys_dma_clk.clk avl_dac_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_dac_fifo.if_dma_rst
add_connection sys_dma_clk.clk dac_dma.if_m_axis_aclk
add_connection dac_dma.m_axis avl_dac_fifo.s_axis
add_connection dac_dma.if_m_axis_xfer_req avl_dac_fifo.if_dma_xfer_req
add_connection sys_clk.clk_reset dac_dma.s_axi_reset
add_connection sys_clk.clk dac_dma.s_axi_clock
add_connection sys_dma_clk.clk_reset dac_dma.m_src_axi_reset
add_connection sys_dma_clk.clk dac_dma.m_src_axi_clock

# addresses

ad_cpu_interconnect 0x00020000 dac_jesd204_link.link_reconfig
ad_cpu_interconnect 0x00024000 dac_jesd204_link.link_management
ad_cpu_interconnect 0x00025000 dac_jesd204_link.link_pll_reconfig
ad_cpu_interconnect 0x00026000 dac_jesd204_link.lane_pll_reconfig
for {set i 0} {$i < $NUM_OF_LANES} {incr i} {
  ad_cpu_interconnect [expr 0x00028000 + $i * 0x1000] dac_jesd204_link.phy_reconfig_${i}
}
ad_cpu_interconnect 0x00030000 dac_jesd204_transport.s_axi
ad_cpu_interconnect 0x00040000 dac_dma.s_axi

# dma interconnects

ad_dma_interconnect dac_dma.m_src_axi

# interrupts

ad_cpu_interrupt 9 dac_jesd204_link.interrupt
ad_cpu_interrupt 11 dac_dma.interrupt_sender
