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

if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir $::env(ADI_HDL_DIR)
}

global ad_project_params
# transfer tcl parameters as defines to verilog
foreach {k v} [array get ad_project_params] {
  adi_sim_add_define $k=$v
}

global rx_dma_cfg
global tx_dma_cfg

create_bd_port -dir I mng_rst
create_bd_port -dir I mng_rst_n
create_bd_port -dir I -type clk mng_clk
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports mng_clk]

create_bd_port -dir I dma_rst
create_bd_port -dir I dma_rst_n
create_bd_port -dir I -type clk dma_clk
set_property CONFIG.FREQ_HZ 250000000 [get_bd_ports dma_clk]

create_bd_port -dir I device_clk
set_property CONFIG.FREQ_HZ 250000000 [get_bd_ports device_clk]

set sys_cpu_resetn mng_rst_n
set sys_cpu_reset mng_rst
set sys_cpu_clk mng_clk

set sys_dma_reset dma_rst
set sys_dma_resetn dma_rst_n
set sys_dma_clk dma_clk

set device_clk device_clk

#
# Copy part of the block design below
#

ad_ip_instance axi_dmac dut_rx_dma $rx_dma_cfg

ad_ip_instance axi_dmac dut_tx_dma $tx_dma_cfg

ad_connect  $device_clk dut_rx_dma/s_axis_aclk
ad_connect  $device_clk dut_tx_dma/m_axis_aclk

# connect resets
ad_connect  $sys_dma_resetn dut_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn dut_tx_dma/m_src_axi_aresetn

# create loopback
ad_connect  dut_tx_dma/m_axis dut_rx_dma/s_axis

#  ------------------
#  Test harness
#  ------------------

global mng_axi_cfg
global ddr_axi_cfg

# add interconnect
# config
ad_ip_instance axi_interconnect axi_cfg_interconnect [ list \
  NUM_SI {1} \
  NUM_MI {2} \
]

# Create instance: mng_axi , and set properties
# VIP for management port
ad_ip_instance axi_vip mng_axi_vip $mng_axi_cfg
adi_sim_add_define "MNG_AXI=mng_axi_vip"

ad_connect mng_axi_vip/M_AXI  axi_cfg_interconnect/S00_AXI
ad_connect axi_cfg_interconnect/M00_AXI dut_rx_dma/s_axi
ad_connect axi_cfg_interconnect/M01_AXI dut_tx_dma/s_axi


ad_connect mng_rst_n axi_cfg_interconnect/ARESETN
ad_connect mng_rst_n axi_cfg_interconnect/S00_ARESETN
ad_connect mng_rst_n axi_cfg_interconnect/M00_ARESETN
ad_connect mng_rst_n axi_cfg_interconnect/M01_ARESETN

ad_connect mng_clk axi_cfg_interconnect/ACLK
ad_connect mng_clk axi_cfg_interconnect/S00_ACLK
ad_connect mng_clk axi_cfg_interconnect/M00_ACLK
ad_connect mng_clk axi_cfg_interconnect/M01_ACLK

# connect clocks

ad_connect mng_clk /dut_rx_dma/s_axi_aclk
ad_connect mng_clk /dut_tx_dma/s_axi_aclk
ad_connect mng_clk /mng_axi_vip/aclk
ad_connect dma_clk /dut_rx_dma/m_dest_axi_aclk
ad_connect dma_clk /dut_tx_dma/m_src_axi_aclk

# connect resets
ad_connect mng_rst_n /dut_rx_dma/s_axi_aresetn
ad_connect mng_rst_n /dut_tx_dma/s_axi_aresetn
ad_connect mng_rst_n mng_axi_vip/aresetn

assign_bd_address

# Create data storage (AXI slave)
ad_ip_instance axi_vip ddr_axi_vip $ddr_axi_cfg
adi_sim_add_define "DDR_AXI=ddr_axi_vip"

# data
ad_ip_instance axi_interconnect axi_ddr_interconnect [ list \
  NUM_SI {2} \
  NUM_MI {1} \
]

# ddr interconnect to ddr AXI VIP
ad_connect axi_ddr_interconnect/M00_AXI ddr_axi_vip/S_AXI

ad_connect /dut_rx_dma/m_dest_axi axi_ddr_interconnect/S00_AXI
ad_connect /dut_tx_dma/m_src_axi axi_ddr_interconnect/S01_AXI

ad_connect $sys_dma_resetn axi_ddr_interconnect/ARESETN
ad_connect $sys_dma_resetn axi_ddr_interconnect/S00_ARESETN
ad_connect $sys_dma_resetn axi_ddr_interconnect/S01_ARESETN
ad_connect $sys_dma_resetn axi_ddr_interconnect/M00_ARESETN

ad_connect $sys_dma_clk axi_ddr_interconnect/ACLK
ad_connect $sys_dma_clk axi_ddr_interconnect/S00_ACLK
ad_connect $sys_dma_clk axi_ddr_interconnect/S01_ACLK
ad_connect $sys_dma_clk axi_ddr_interconnect/M00_ACLK
ad_connect $sys_dma_clk /ddr_axi_vip/aclk

assign_bd_address [get_bd_addr_segs {ddr_axi_vip/S_AXI/Reg }]
set_property offset 0x00000000 [get_bd_addr_segs {dut_rx_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
set_property range 4G [get_bd_addr_segs {dut_rx_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
set_property offset 0x00000000 [get_bd_addr_segs {dut_tx_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]
set_property range 4G [get_bd_addr_segs {dut_tx_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]

# assign fixed addresses

delete_bd_objs\
  [get_bd_addr_segs mng_axi_vip/Master_AXI/SEG_dut_rx_dma_axi_lite]\
  [get_bd_addr_segs mng_axi_vip/Master_AXI/SEG_dut_tx_dma_axi_lite]

assign_bd_address [get_bd_addr_segs {dut_rx_dma/s_axi/axi_lite}]
set_property offset 0x7c420000 [get_bd_addr_segs mng_axi_vip/Master_AXI/SEG_dut_rx_dma_axi_lite]

assign_bd_address [get_bd_addr_segs {dut_tx_dma/s_axi/axi_lite}]
set_property offset 0x7c430000 [get_bd_addr_segs mng_axi_vip/Master_AXI/SEG_dut_tx_dma_axi_lite]

