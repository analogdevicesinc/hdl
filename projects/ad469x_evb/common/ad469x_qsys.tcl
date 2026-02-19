###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# receive dma
set_instance_parameter_value sys_hps {F2SDRAM_Width} {128 64}

add_instance axi_dmac_0 axi_dmac
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_0 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_SRC} {32}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_DEST} {64}

# axi pwm gen

add_instance ad469x_trigger_gen axi_pwm_gen
set_instance_parameter_value ad469x_trigger_gen {N_PWMS} {1}
set_instance_parameter_value ad469x_trigger_gen {PULSE_0_PERIOD} {160}
set_instance_parameter_value ad469x_trigger_gen {PULSE_0_WIDTH} {1}

# spi_clk pll

add_instance spi_clk_pll altera_pll
set_instance_parameter_value spi_clk_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value spi_clk_pll {gui_operation_mode} {direct}
set_instance_parameter_value spi_clk_pll {gui_number_of_clocks} {1}
set_instance_parameter_value spi_clk_pll {gui_output_clock_frequency0} {160}
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

set spi_engine_hier  ad469x_spi
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
set sdo_streaming    0

spi_engine_create $spi_engine_hier $axi_clk $axi_reset $spi_clk $data_width $async_spi_clk $offload_en $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk $sdo_streaming
set_instance_parameter_value ${spi_engine_hier}_offload {ASYNC_TRIG} {1}

# exported interface

add_interface ad469x_spi_sclk       clock source
add_interface ad469x_spi_cs         conduit end
add_interface ad469x_spi_sdi        conduit end
add_interface ad469x_spi_sdo        conduit end
add_interface ad469x_spi_trigger    conduit end
add_interface ad469x_spi_cnv        conduit end

set_interface_property ad469x_spi_cs      EXPORT_OF ${spi_engine_hier}_execution.if_cs
set_interface_property ad469x_spi_sclk    EXPORT_OF ${spi_engine_hier}_execution.if_sclk
set_interface_property ad469x_spi_sdi     EXPORT_OF ${spi_engine_hier}_execution.if_sdi
set_interface_property ad469x_spi_sdo     EXPORT_OF ${spi_engine_hier}_execution.if_sdo
set_interface_property ad469x_spi_trigger EXPORT_OF ${spi_engine_hier}_offload.if_trigger
set_interface_property ad469x_spi_cnv     EXPORT_OF ad469x_trigger_gen.if_pwm_0

# clocks

add_connection sys_clk.clk spi_clk_pll.refclk
add_connection sys_clk.clk spi_clk_pll_reconfig.mgmt_clk
add_connection sys_clk.clk ad469x_trigger_gen.s_axi_clock
add_connection sys_clk.clk axi_dmac_0.s_axi_clock

add_connection spi_clk_pll.outclk0 ad469x_trigger_gen.if_ext_clk
add_connection spi_clk_pll.outclk0 axi_dmac_0.if_s_axis_aclk

add_connection sys_dma_clk.clk axi_dmac_0.m_dest_axi_clock

# resets

add_connection sys_clk.clk_reset spi_clk_pll.reset
add_connection sys_clk.clk_reset spi_clk_pll_reconfig.mgmt_reset
add_connection sys_clk.clk_reset axi_dmac_0.s_axi_reset
add_connection sys_clk.clk_reset ad469x_trigger_gen.s_axi_reset

add_connection sys_dma_clk.clk_reset axi_dmac_0.m_dest_axi_reset

# interfaces

add_connection ${spi_engine_hier}_offload.offload_sdi axi_dmac_0.s_axis

add_interface dma_xfer_req conduit end

set_interface_property dma_xfer_req EXPORT_OF axi_dmac_0.if_s_axis_xfer_req

# cpu interconnects

ad_cpu_interconnect 0x00020000 axi_dmac_0.s_axi
ad_cpu_interconnect 0x00030000 ${spi_engine_hier}_axi_regmap.s_axi
ad_cpu_interconnect 0x00040000 ad469x_trigger_gen.s_axi

# dma interconnect

ad_dma_interconnect axi_dmac_0.m_dest_axi

#interrupts

ad_cpu_interrupt 4 axi_dmac_0.interrupt_sender
ad_cpu_interrupt 5 ${spi_engine_hier}_axi_regmap.interrupt_sender