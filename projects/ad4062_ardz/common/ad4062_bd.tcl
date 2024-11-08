###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 i3c

source $ad_hdl_dir/library/i3c_controller/scripts/i3c_controller_bd.tcl

set async_clk 0
set i2c_mod 4
set offload $ad_project_params(OFFLOAD)
set max_devs 16

i3c_controller_create i3c $async_clk $i2c_mod $offload $max_devs

if {$offload == 1} {
  # pwm to trigger on offload data burst
  ad_ip_instance axi_pwm_gen i3c_offload_pwm
  ad_ip_parameter i3c_offload_pwm CONFIG.PULSE_0_PERIOD 120
  ad_ip_parameter i3c_offload_pwm CONFIG.PULSE_0_WIDTH 1

  # dma to receive offload data stream
  ad_ip_instance axi_dmac i3c_offload_dma
  ad_ip_parameter i3c_offload_dma CONFIG.DMA_TYPE_SRC 1
  ad_ip_parameter i3c_offload_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter i3c_offload_dma CONFIG.CYCLIC 0
  ad_ip_parameter i3c_offload_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter i3c_offload_dma CONFIG.AXI_SLICE_SRC 0
  ad_ip_parameter i3c_offload_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter i3c_offload_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter i3c_offload_dma CONFIG.DMA_DATA_WIDTH_SRC 32
  ad_ip_parameter i3c_offload_dma CONFIG.DMA_DATA_WIDTH_DEST 64

  ad_connect sys_cpu_clk i3c_offload_pwm/ext_clk
  ad_connect sys_cpu_clk i3c_offload_pwm/s_axi_aclk
  ad_connect sys_cpu_resetn i3c_offload_pwm/s_axi_aresetn
  ad_connect i3c_offload_pwm/pwm_0 i3c/trigger

  ad_connect i3c_offload_dma/s_axis i3c/offload_sdi
}
ad_connect i3c/m_i3c i3c

ad_connect sys_cpu_clk i3c/clk
ad_connect sys_cpu_resetn i3c/reset_n
if {$offload == 1} {
  ad_connect sys_cpu_clk i3c_offload_dma/s_axis_aclk
  ad_connect sys_cpu_resetn i3c_offload_dma/m_dest_axi_aresetn
}

ad_cpu_interconnect 0x44a00000 i3c/host_interface
if {$offload == 1} {
  ad_cpu_interconnect 0x44a30000 i3c_offload_dma
  ad_cpu_interconnect 0x44b00000 i3c_offload_pwm
}

if {$offload == 1} {
  ad_cpu_interrupt "ps-13" "mb-13" i3c_offload_dma/irq
}
ad_cpu_interrupt "ps-12" "mb-12" i3c/irq

if {$offload == 1} {
  ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect sys_cpu_clk i3c_offload_dma/m_dest_axi
}
