# ***************************************************************************
# ***************************************************************************
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
# ***************************************************************************
# ***************************************************************************

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set NUM_LINKS 2
set NUM_OF_LANES 8
set NUM_OF_CHANNELS 2
set SAMPLE_WIDTH 16

set DAC_DATA_WIDTH [expr $NUM_OF_LANES * 32]
set SAMPLES_PER_CHANNEL [expr $DAC_DATA_WIDTH / $NUM_OF_CHANNELS / $SAMPLE_WIDTH]

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
ad_ip_instance ad_ip_jesd204_tpl_dac dac_jesd204_transport [list \
  NUM_LANES $NUM_OF_LANES \
  NUM_CHANNELS $NUM_OF_CHANNELS \
  SAMPLES_PER_FRAME 2 \
]

ad_ip_instance util_upack2 dac_upack [list \
  NUM_OF_CHANNELS $NUM_OF_CHANNELS \
  SAMPLES_PER_CHANNEL $SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac dac_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  DMA_DATA_WIDTH_SRC 64 \
  DMA_DATA_WIDTH_DEST 256 \
]

# shared transceiver core

ad_ip_instance util_adxcvr util_dac_jesd204_xcvr [list \
  RX_NUM_OF_LANES 0 \
  TX_NUM_OF_LANES $NUM_OF_LANES \
  TX_LANE_INVERT [expr 0xf0] \
  QPLL_REFCLK_DIV 1 \
  QPLL_FBDIV_RATIO 1 \
  QPLL_FBDIV 0x80 \
  TX_OUT_DIV 1 \
]

ad_connect sys_cpu_resetn util_dac_jesd204_xcvr/up_rstn
ad_connect sys_cpu_clk util_dac_jesd204_xcvr/up_clk

# reference clocks & resets

create_bd_port -dir I tx_ref_clk
create_bd_port -dir I tx_device_clk

ad_xcvrpll tx_ref_clk util_dac_jesd204_xcvr/qpll_ref_clk_*
ad_xcvrpll tx_ref_clk util_dac_jesd204_xcvr/cpll_ref_clk_*
ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_qpll_rst_*
ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_cpll_rst_*

# connections (dac)

ad_xcvrcon util_dac_jesd204_xcvr dac_jesd204_xcvr dac_jesd204_link \
  {5 6 4 7 3 2 1 0} \
  tx_device_clk
ad_connect tx_device_clk dac_jesd204_transport/link_clk
ad_connect tx_device_clk dac_upack/clk
ad_connect tx_device_clk_rstgen/peripheral_reset dac_upack/reset

ad_connect dac_jesd204_link/tx_data dac_jesd204_transport/link

ad_ip_instance xlconcat dac_data_concat [list \
  NUM_PORTS $NUM_OF_CHANNELS
]

ad_ip_instance xlslice dac_valid_slice [list \
  DIN_WIDTH $NUM_OF_CHANNELS \
  DIN_FROM 0 \
  DIN_TO 0 \
]

ad_connect dac_jesd204_transport/dac_valid dac_valid_slice/Din
ad_connect dac_valid_slice/Dout dac_upack/fifo_rd_en

for {set i 0} {$i < $NUM_OF_CHANNELS} {incr i} {
  ad_ip_instance xlslice dac_enable_slice_$i [list \
    DIN_WIDTH $NUM_OF_CHANNELS \
    DIN_FROM $i \
    DIN_TO $i \
  ]

  ad_connect dac_jesd204_transport/enable dac_enable_slice_$i/Din

  ad_connect dac_enable_slice_$i/Dout dac_upack/enable_$i
  ad_connect dac_upack/fifo_rd_data_$i dac_data_concat/In$i
}

ad_connect dac_jesd204_transport/dac_ddata dac_data_concat/dout

ad_connect tx_device_clk axi_dac_fifo/dac_clk
ad_connect tx_device_clk_rstgen/peripheral_reset axi_dac_fifo/dac_rst
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

ad_cpu_interconnect 0x44A00000 dac_jesd204_xcvr
ad_cpu_interconnect 0x44A10000 dac_jesd204_transport
ad_cpu_interconnect 0x44A20000 dac_jesd204_link
ad_cpu_interconnect 0x7c420000 dac_dma

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 dac_jesd204_link/irq
ad_cpu_interrupt ps-12 mb-13 dac_dma/irq

ad_connect axi_dac_fifo/bypass dac_fifo_bypass
