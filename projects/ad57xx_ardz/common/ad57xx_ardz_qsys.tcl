###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# send dma

add_instance ad57xx_dma axi_dmac
set_instance_parameter_value ad57xx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value ad57xx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value ad57xx_dma {CYCLIC} {0}
set_instance_parameter_value ad57xx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value ad57xx_dma {DMA_DATA_WIDTH_DEST} {32}

# axi pwm gen

add_instance trig_gen axi_pwm_gen
set_instance_parameter_value trig_gen {N_PWMS} {2}
set_instance_parameter_value trig_gen {PULSE_0_PERIOD} {98}
set_instance_parameter_value trig_gen {PULSE_0_WIDTH} {1}

# spi_clk pll

add_instance spi_clk_pll altera_pll
set_instance_parameter_value spi_clk_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value spi_clk_pll {gui_operation_mode} {direct}
set_instance_parameter_value spi_clk_pll {gui_number_of_clocks} {1}
set_instance_parameter_value spi_clk_pll {gui_output_clock_frequency0} {140};
set_instance_parameter_value spi_clk_pll {gui_phase_shift0} {0}
set_instance_parameter_value spi_clk_pll {gui_phase_shift1} {0}
set_instance_parameter_value spi_clk_pll {gui_phase_shift_deg0} {0.0}
set_instance_parameter_value spi_clk_pll {gui_phase_shift_deg1} {0.0}
set_instance_parameter_value spi_clk_pll {gui_phout_division} {1}
set_instance_parameter_value spi_clk_pll {gui_pll_auto_reset} {Off}
set_instance_parameter_value spi_clk_pll {gui_pll_bandwidth_preset} {Auto}
set_instance_parameter_value spi_clk_pll {gui_pll_mode} {Fractional-N PLL}
set_instance_parameter_value spi_clk_pll {gui_ps_units0} {ps}
set_instance_parameter_value spi_clk_pll {gui_refclk_switch} {0}
set_instance_parameter_value spi_clk_pll {gui_reference_clock_frequency} {50.0}
set_instance_parameter_value spi_clk_pll {gui_switchover_delay} {0}
set_instance_parameter_value spi_clk_pll {gui_en_reconf} {1}

add_instance spi_clk_pll_reconfig altera_pll_reconfig
set_instance_parameter_value spi_clk_pll_reconfig {ENABLE_BYTEENABLE} {0}
set_instance_parameter_value spi_clk_pll_reconfig {ENABLE_MIF} {0}
set_instance_parameter_value spi_clk_pll_reconfig {MIF_FILE_NAME} {}

add_connection spi_clk_pll.reconfig_from_pll spi_clk_pll_reconfig.reconfig_from_pll
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll endPort {}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll endPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll startPort {}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll startPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll width {0}

add_connection spi_clk_pll.reconfig_to_pll spi_clk_pll_reconfig.reconfig_to_pll
set_connection_parameter_value spi_clk_pll.reconfig_to_pll/spi_clk_pll_reconfig.reconfig_to_pll endPort {}
set_connection_parameter_value spi_clk_pll.reconfig_to_pll/spi_clk_pll_reconfig.reconfig_to_pll endPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_to_pll/spi_clk_pll_reconfig.reconfig_to_pll startPort {}
set_connection_parameter_value spi_clk_pll.reconfig_to_pll/spi_clk_pll_reconfig.reconfig_to_pll startPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_to_pll/spi_clk_pll_reconfig.reconfig_to_pll width {0}

# spi engine
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set spi_engine_hier  spi_ad57xx
set axi_clk          sys_clk.clk
set axi_reset        sys_clk.clk_reset
set spi_clk          spi_clk_pll.outclk0
set data_width       32
set async_spi_clk    1
set offload_en       1
set num_cs           1
set num_sdi          1
set num_sdo          1
set sdi_delay        0
set echo_sclk        0
set sdo_streaming    1

spi_engine_create $spi_engine_hier $axi_clk $axi_reset $spi_clk $data_width $async_spi_clk $offload_en $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk $sdo_streaming

# exported interface

add_interface ad57xx_spi_sclk    clock      source
add_interface ad57xx_spi_cs      conduit    end
add_interface ad57xx_spi_miso    conduit    end
add_interface ad57xx_spi_mosi    conduit    end
add_interface m_axis_offload_sdi axi4stream end

set_interface_property ad57xx_spi_cs      EXPORT_OF ${spi_engine_hier}_execution.if_cs
set_interface_property ad57xx_spi_sclk    EXPORT_OF ${spi_engine_hier}_execution.if_sclk
set_interface_property ad57xx_spi_miso    EXPORT_OF ${spi_engine_hier}_execution.if_sdi
set_interface_property ad57xx_spi_mosi    EXPORT_OF ${spi_engine_hier}_execution.if_sdo
set_interface_property m_axis_offload_sdi EXPORT_OF ${spi_engine_hier}_offload.offload_sdi

# clocks

add_connection sys_clk.clk spi_clk_pll.refclk
add_connection sys_clk.clk spi_clk_pll_reconfig.mgmt_clk

add_connection sys_clk.clk ad57xx_dma.s_axi_clock
add_connection sys_clk.clk trig_gen.s_axi_clock

add_connection spi_clk_pll.outclk0 trig_gen.if_ext_clk
add_connection spi_clk_pll.outclk0 ad57xx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk ad57xx_dma.m_src_axi_clock

# resets

add_connection sys_clk.clk_reset spi_clk_pll.reset
add_connection sys_clk.clk_reset spi_clk_pll_reconfig.mgmt_reset
add_connection sys_clk.clk_reset ad57xx_dma.s_axi_reset
add_connection sys_clk.clk_reset trig_gen.s_axi_reset

add_connection sys_dma_clk.clk_reset ad57xx_dma.m_src_axi_reset

# interfaces
add_connection ${spi_engine_hier}_offload.if_trigger        trig_gen.if_pwm_0
add_connection ad57xx_dma.m_axis ${spi_engine_hier}_offload.s_axis_sdo

# cpu interconnects

ad_cpu_interconnect 0x00030000 ad57xx_dma.s_axi
ad_cpu_interconnect 0x00040000 ${spi_engine_hier}_axi_regmap.s_axi
ad_cpu_interconnect 0x00050000 trig_gen.s_axi
ad_cpu_interconnect 0x00060000 spi_clk_pll_reconfig.mgmt_avalon_slave

# dma interconnect

ad_dma_interconnect ad57xx_dma.m_src_axi

#interrupts

ad_cpu_interrupt 4 ad57xx_dma.interrupt_sender
ad_cpu_interrupt 5 ${spi_engine_hier}_axi_regmap.interrupt_sender
