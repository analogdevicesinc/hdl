###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# receive dma
add_instance axi_dmac_0 axi_dmac
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_0 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_SRC} {32}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_DEST} {128}

# axi_pwm_gen

add_instance pwm_trigger axi_pwm_gen
set_instance_parameter_value pwm_trigger {PULSE_0_PERIOD} {120}
set_instance_parameter_value pwm_trigger {PULSE_0_WIDTH} {1}

# spi_clk pll

add_instance spi_clk_pll altera_pll
set_instance_parameter_value spi_clk_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value spi_clk_pll {gui_operation_mode} {direct}
set_instance_parameter_value spi_clk_pll {gui_number_of_clocks} {1}
set_instance_parameter_value spi_clk_pll {gui_output_clock_frequency0} {150}
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

set spi_engine_hier spi_ad4052

set data_width 32
set async_spi_clk 1
set num_cs 1
set num_sdi 1
set num_sdo 1
set sdi_delay 0
set echo_sclk 0
set sdo_streaming 0

set axi_clk sys_clk.clk
set axi_reset sys_clk.clk_reset
set spi_clk spi_clk_pll.outclk0

spi_engine_create $spi_engine_hier $axi_clk $axi_reset $spi_clk $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk $sdo_streaming
set_instance_parameter_value ${spi_engine_hier}_offload {ASYNC_TRIG} {1}
# exported interface

add_interface adc_spi_sclk    clock source
add_interface adc_spi_sdi     conduit end
add_interface adc_spi_sdo     conduit end
add_interface adc_spi_cs      conduit end
add_interface adc_drdy        conduit end

set_interface_property adc_spi_sclk     EXPORT_OF ${spi_engine_hier}_execution.if_sclk
set_interface_property adc_spi_sdi      EXPORT_OF ${spi_engine_hier}_execution.if_sdi
set_interface_property adc_spi_sdo      EXPORT_OF ${spi_engine_hier}_execution.if_sdo
set_interface_property adc_spi_cs       EXPORT_OF ${spi_engine_hier}_execution.if_cs
set_interface_property adc_drdy_trigger EXPORT_OF ${spi_engine_hier}_offload.if_trigger
set_interface_property adc_cnv          EXPORT_OF pwm_trigger.if_pwm_0

# clocks

add_connection sys_clk.clk spi_clk_pll.refclk
add_connection sys_clk.clk spi_clk_pll_reconfig.mgmt_clk
add_connection sys_clk.clk axi_dmac_0.s_axi_clock
add_connection sys_clk.clk pwm_trigger.s_axi_clock

add_connection spi_clk_pll.outclk0 pwm_trigger.if_ext_clk
add_connection spi_clk_pll.outclk0 axi_dmac_0.if_s_axis_aclk

add_connection sys_dma_clk.clk axi_dmac_0.m_dest_axi_clock

# resets

add_connection sys_clk.clk_reset spi_clk_pll.reset
add_connection sys_clk.clk_reset spi_clk_pll_reconfig.mgmt_reset
add_connection sys_clk.clk_reset axi_dmac_0.s_axi_reset
add_connection sys_clk.clk_reset pwm_trigger.s_axi_reset

add_connection sys_dma_clk.clk_reset axi_dmac_0.m_dest_axi_reset

# interfaces

add_connection ${spi_engine_hier}_offload.offload_sdi axi_dmac_0.s_axis

# cpu interconnects

ad_cpu_interconnect 0x00020000 axi_dmac_0.s_axi
ad_cpu_interconnect 0x00030000 ${spi_engine_hier}_axi_regmap.s_axi
ad_cpu_interconnect 0x00040000 pwm_trigger.s_axi
ad_cpu_interconnect 0x00050000 spi_clk_pll_reconfig.mgmt_avalon_slave

# dma interconnect

ad_dma_interconnect axi_dmac_0.m_dest_axi

#interrupts

ad_cpu_interrupt 4 axi_dmac_0.interrupt_sender
ad_cpu_interrupt 5 ${spi_engine_hier}_axi_regmap.interrupt_sender
