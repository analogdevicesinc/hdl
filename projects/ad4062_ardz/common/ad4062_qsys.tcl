###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

source $ad_hdl_dir/library/i3c_controller/scripts/i3c_controller_qsys.tcl

# disable I2C1

set_instance_parameter_value sys_hps {I2C1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {Unused}

set async_clk 0
set i2c_mod 4
set offload $ad_project_params(OFFLOAD)
set max_devs 16

i3c_controller_create i3c $async_clk $i2c_mod $offload $max_devs

if {$offload} {
  # axi pwm gen

  add_instance i3c_offload_pwm axi_pwm_gen
  set_instance_parameter_value i3c_offload_pwm {N_PWMS} {1}
  set_instance_parameter_value i3c_offload_pwm {PULSE_0_PERIOD} {120}
  set_instance_parameter_value i3c_offload_pwm {PULSE_0_WIDTH} {1}

  # receive dma

  add_instance i3c_offload_dma axi_dmac
  set_instance_parameter_value i3c_offload_dma {DMA_TYPE_SRC} {1}
  set_instance_parameter_value i3c_offload_dma {DMA_TYPE_DEST} {0}
  set_instance_parameter_value i3c_offload_dma {AXI_SLICE_SRC} {0}
  set_instance_parameter_value i3c_offload_dma {AXI_SLICE_DEST} {1}
  set_instance_parameter_value i3c_offload_dma {DMA_DATA_WIDTH_SRC} {32}
  set_instance_parameter_value i3c_offload_dma {DMA_DATA_WIDTH_DEST} {64}
}

# clocks

add_connection sys_clk.clk i3c_host_interface.s_axi_clock
add_connection sys_clk.clk i3c_core.if_clk
if {$offload} {
  add_connection sys_clk.clk i3c_offload_dma.s_axi_clock
  add_connection sys_clk.clk i3c_offload_dma.if_s_axis_aclk
  add_connection sys_clk.clk i3c_offload_dma.m_dest_axi_clock
  add_connection sys_clk.clk i3c_offload_pwm.s_axi_clock
  add_connection sys_clk.clk i3c_offload_pwm.if_ext_clk
}

# resets

add_connection sys_clk.clk_reset i3c_host_interface.s_axi_reset
if {$offload} {
  add_connection sys_clk.clk_reset i3c_offload_dma.s_axi_reset
  add_connection sys_clk.clk_reset i3c_offload_dma.m_dest_axi_reset
  add_connection sys_clk.clk_reset i3c_offload_pwm.s_axi_reset
}

# interfaces

if {$offload} {
  add_connection i3c_host_interface.offload_sdi i3c_offload_dma.s_axis
  add_connection i3c_offload_pwm.if_pwm_0 i3c_host_interface.if_offload_trigger
}

# exported interface

set_interface_property i3c EXPORT_OF i3c_core.i3c

# cpu interconnects

ad_cpu_interconnect 0x00030000 i3c_host_interface.s_axi
if {$offload} {
  ad_cpu_interconnect 0x00020000 i3c_offload_dma.s_axi
  ad_cpu_interconnect 0x00040000 i3c_offload_pwm.s_axi
}

# dma interconnect

if {$offload} {
  ad_dma_interconnect i3c_offload_dma.m_dest_axi
}

# interrupts

if {$offload} {
  ad_cpu_interrupt 4 i3c_offload_dma.interrupt_sender
}
ad_cpu_interrupt 5 i3c_host_interface.interrupt_sender
