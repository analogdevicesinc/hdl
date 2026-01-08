###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# receive dma
ad_ip_instance axi_dmac axi_adc_dma
ad_ip_parameter axi_adc_dma CONFIG.DMA_TYPE_SRC {1}
ad_ip_parameter axi_adc_dma CONFIG.DMA_TYPE_DEST {0}
ad_ip_parameter axi_adc_dma CONFIG.CYCLIC {0}
ad_ip_parameter axi_adc_dma CONFIG.DMA_DATA_WIDTH_SRC {32}
ad_ip_parameter axi_adc_dma CONFIG.DMA_DATA_WIDTH_DEST {128}

# axi_pwm_gen

ad_ip_instance axi_pwm_gen pwm_trigger
ad_ip_parameter pwm_trigger CONFIG.PULSE_0_PERIOD {120}
ad_ip_parameter pwm_trigger CONFIG.PULSE_0_WIDTH {1}

# spi_clk pll

ad_ip_instance altera_pll spi_clk_pll
ad_ip_parameter spi_clk_pll CONFIG.gui_feedback_clock {Global Clock}
ad_ip_parameter spi_clk_pll CONFIG.gui_operation_mode {direct}
ad_ip_parameter spi_clk_pll CONFIG.gui_number_of_clocks {1}
ad_ip_parameter spi_clk_pll CONFIG.gui_output_clock_frequency0 {150}
ad_ip_parameter spi_clk_pll CONFIG.gui_phase_shift0 {0}
ad_ip_parameter spi_clk_pll CONFIG.gui_phase_shift1 {0}
ad_ip_parameter spi_clk_pll CONFIG.gui_phase_shift_deg0 {0.0}
ad_ip_parameter spi_clk_pll CONFIG.gui_phase_shift_deg1 {0.0}
ad_ip_parameter spi_clk_pll CONFIG.gui_phout_division {1}
ad_ip_parameter spi_clk_pll CONFIG.gui_pll_auto_reset {Off}
ad_ip_parameter spi_clk_pll CONFIG.gui_pll_bandwidth_preset {Auto}
ad_ip_parameter spi_clk_pll CONFIG.gui_pll_mode {Fractional-N PLL}
ad_ip_parameter spi_clk_pll CONFIG.gui_ps_units0 {ps}
ad_ip_parameter spi_clk_pll CONFIG.gui_refclk_switch {0}
ad_ip_parameter spi_clk_pll CONFIG.gui_reference_clock_frequency {50.0}
ad_ip_parameter spi_clk_pll CONFIG.gui_switchover_delay {0}
ad_ip_parameter spi_clk_pll CONFIG.gui_en_reconf {1}

ad_ip_instance altera_pll_reconfig spi_clk_pll_reconfig
ad_ip_parameter spi_clk_pll_reconfig CONFIG.ENABLE_BYTEENABLE {0}
ad_ip_parameter spi_clk_pll_reconfig CONFIG.ENABLE_MIF {0}
ad_ip_parameter spi_clk_pll_reconfig CONFIG.MIF_FILE_NAME {}

ad_connect spi_clk_pll.reconfig_from_pll spi_clk_pll_reconfig.reconfig_from_pll
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll endPort {}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll endPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll startPort {}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll startPortLSB {0}
set_connection_parameter_value spi_clk_pll.reconfig_from_pll/spi_clk_pll_reconfig.reconfig_from_pll width {0}

ad_connect spi_clk_pll.reconfig_to_pll spi_clk_pll_reconfig.reconfig_to_pll
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
ad_ip_parameter ${spi_engine_hier}_offload CONFIG.ASYNC_TRIG {1}
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

ad_connect sys_clk.clk spi_clk_pll.refclk
ad_connect sys_clk.clk spi_clk_pll_reconfig.mgmt_clk
ad_connect sys_clk.clk axi_adc_dma.s_axi_clock
ad_connect sys_clk.clk pwm_trigger.s_axi_clock

ad_connect spi_clk_pll.outclk0 pwm_trigger.if_ext_clk
ad_connect spi_clk_pll.outclk0 axi_adc_dma.if_s_axis_aclk

ad_connect sys_dma_clk.clk axi_adc_dma.m_dest_axi_clock

# resets

ad_connect sys_clk.clk_reset spi_clk_pll.reset
ad_connect sys_clk.clk_reset spi_clk_pll_reconfig.mgmt_reset
ad_connect sys_clk.clk_reset axi_adc_dma.s_axi_reset
ad_connect sys_clk.clk_reset pwm_trigger.s_axi_reset

ad_connect sys_dma_clk.clk_reset axi_adc_dma.m_dest_axi_reset

# interfaces

ad_connect ${spi_engine_hier}_offload.offload_sdi axi_adc_dma.s_axis

# cpu interconnects

ad_cpu_interconnect_intel 0x00020000 axi_adc_dma.s_axi
ad_cpu_interconnect_intel 0x00030000 ${spi_engine_hier}_axi_regmap.s_axi
ad_cpu_interconnect_intel 0x00040000 pwm_trigger.s_axi
ad_cpu_interconnect_intel 0x00050000 spi_clk_pll_reconfig.mgmt_avalon_slave

# dma interconnect

ad_dma_interconnect axi_adc_dma.m_dest_axi

#interrupts

ad_cpu_interrupt_intel 4 axi_adc_dma.interrupt_sender
ad_cpu_interrupt_intel 5 ${spi_engine_hier}_axi_regmap.interrupt_sender
