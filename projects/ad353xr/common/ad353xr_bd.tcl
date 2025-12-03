###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir O ldacb_tgp
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux1
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 spi

#spi_engine reference clock
ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 5

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

#spi_engine
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set sdi_delay     1
set hier_spi_engine spi_ad353xr_dac

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $sdi_delay
ad_connect $hier_spi_engine/m_spi spi

#spi_engine pwm for trigger/sample rate
ad_ip_instance axi_pwm_gen spi_engine_pwm_gen
ad_ip_parameter spi_engine_pwm_gen CONFIG.PULSE_0_PERIOD 120
ad_ip_parameter spi_engine_pwm_gen CONFIG.PULSE_0_WIDTH 1

ad_connect spi_clk spi_engine_pwm_gen/ext_clk
ad_connect $sys_cpu_clk spi_engine_pwm_gen/s_axi_aclk
ad_connect sys_cpu_resetn spi_engine_pwm_gen/s_axi_aresetn
ad_connect spi_engine_pwm_gen/pwm_0  $hier_spi_engine/trigger

#spi_engine dma for data
ad_ip_instance axi_dmac spi_engine_dma
ad_ip_parameter spi_engine_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter spi_engine_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter spi_engine_dma CONFIG.CYCLIC 1
ad_ip_parameter spi_engine_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter spi_engine_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter spi_engine_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter spi_engine_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter spi_engine_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter spi_engine_dma CONFIG.DMA_DATA_WIDTH_DEST 64

#clocks and resets
ad_connect $hier_spi_engine/m_axis_sample spi_engine_dma/s_axis
ad_connect $sys_cpu_resetn spi_engine_dma/m_dest_axi_aresetn
ad_connect spi_clk spi_engine_dma/s_axis_aclk

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect $sys_cpu_resetn $hier_spi_engine/resetn

# Xilinx's XADC
ad_ip_instance xadc_wiz xadc_in

ad_ip_parameter xadc_in CONFIG.TIMING_MODE Continuous
ad_ip_parameter xadc_in CONFIG.XADC_STARUP_SELECTION channel_sequencer
ad_ip_parameter xadc_in CONFIG.SEQUENCER_MODE Continuous
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCDDRO_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPINT_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_AXI4STREAM false
ad_ip_parameter xadc_in CONFIG.ENABLE_EXTERNAL_MUX false
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VP_VN false
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 true
ad_ip_parameter xadc_in CONFIG.OT_ALARM false
ad_ip_parameter xadc_in CONFIG.SINGLE_CHANNEL_SELECTION TEMPERATURE
ad_ip_parameter xadc_in CONFIG.USER_TEMP_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCINT_ALARM false

ad_connect xadc_in/Vaux1                xadc_vaux1

# interconnects (cpu)
ad_cpu_interconnect 0x44a00000          xadc_in
ad_cpu_interconnect 0x44b00000          $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44c00000          spi_clkgen
ad_cpu_interconnect 0x44d00000          spi_engine_pwm_gen
ad_cpu_interconnect 0x44e00000          spi_engine_dma

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" spi_engine_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

# interconnect to memory interface
ad_mem_hp2_interconnect $sys_cpu_clk    sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk    spi_engine_dma/m_dest_axi
