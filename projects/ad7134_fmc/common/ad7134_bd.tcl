###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad713x_di
create_bd_port -dir O ad713x_odr
create_bd_port -dir O ad713x_sdpclk

# create a SPI Engine architecture for the parallel data interface of AD713x
# this design supports AD7132/AD7134/AD7136

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set hier_spi_engine  dual_ad7134
set data_width       32
set async_spi_clk    1
set offload_en       1
set num_cs           1
set num_sdi          8
set num_sdo          0
set sdi_delay        0
set echo_sclk        0

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $offload_en $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

ad_ip_parameter ${hier_spi_engine}/${hier_spi_engine}_offload CONFIG.ASYNC_TRIG 1

# clkgen

ad_ip_instance axi_clkgen axi_ad7134_clkgen
ad_ip_parameter axi_ad7134_clkgen CONFIG.VCO_DIV 5
ad_ip_parameter axi_ad7134_clkgen CONFIG.VCO_MUL 50
ad_ip_parameter axi_ad7134_clkgen CONFIG.CLK0_DIV 10

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad7134_dma
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7134_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7134_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_DEST 128

# sdpclk clock - 48 MHz
# Reference: on-board 100 MHz oscillator IC17 (Fox 767-100-136, 25 ppm).
# MMCM: 100 × 48/5 = 960 MHz VCO → 960/20 = 48 MHz output.
# clk_1 = 960/10 = 96 MHz, a free-running (ungated) 2x-of-XTAL clock used as the
# ILA sample clock to observe XTAL2_CLKIN / ODR / edge_cnt. Off the same VCO so
# it is phase-coherent with the 48 MHz. Not routed off-chip.

ad_ip_instance axi_clkgen axi_sdpclk_clkgen
ad_ip_parameter axi_sdpclk_clkgen CONFIG.VCO_DIV 5
ad_ip_parameter axi_sdpclk_clkgen CONFIG.VCO_MUL 48
ad_ip_parameter axi_sdpclk_clkgen CONFIG.CLK0_DIV 20
ad_ip_parameter axi_sdpclk_clkgen CONFIG.ENABLE_CLKOUT1 1
ad_ip_parameter axi_sdpclk_clkgen CONFIG.CLK1_DIV 10

create_bd_port -dir I -type clk sys_clk
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports sys_clk]
ad_connect sys_clk axi_sdpclk_clkgen/clk

# clkin aligner — gates sdpclk for deterministic dig_clk phase alignment
# (Sequence.txt). Sits between axi_sdpclk_clkgen/clk_0 and the two sdpclk
# consumers (the FMC pin and the ODR generator).

ad_ip_instance clkin_aligner clkin_aligner

# Startup calibration per Fused_part_sequence.docx (designer's revised video
# capture, supersedes Sequence.txt 36/3): 39 XTAL2_CLKIN startup pulses, with
# div32_cnt landing on 5 at the end of the burst. The RTL derives the div32
# seed as (DIV32_TARGET_DEFAULT - STARTUP_CYCLES_DEFAULT) mod 32 = (5-39) mod 32
# = 30, so after 39 edges (30+39) mod 32 = 5.
#
# EDGE_TARGET_DEFAULT lowered 146 -> 137 to compensate the measured +9.5-cycle
# pipeline between the odr_sync anchor (fired at edge_target) and the first ODR
# pulse (evt reg +1, ext_sync double-flop +2, PWM pulse_1 phase ~5, F.10 negedge
# +0.5). ILA-confirmed over 5 boots: with 137 the first ODR lands on the falling
# edge of CLKin edge 146 (Fused_part_sequence), boot-invariant. NOTE: this also
# moves the F.7 edge_target_reached IRQ to edge 137 (~187 ns earlier); harmless
# (the driver uses it only as a "clock aligned, proceed" signal).
ad_ip_parameter clkin_aligner CONFIG.STARTUP_CYCLES_DEFAULT 39
ad_ip_parameter clkin_aligner CONFIG.DIV32_TARGET_DEFAULT 5
ad_ip_parameter clkin_aligner CONFIG.EDGE_TARGET_DEFAULT 137

ad_connect $sys_cpu_clk            clkin_aligner/s_axi_aclk
ad_connect sys_cpu_resetn          clkin_aligner/s_axi_aresetn
ad_connect axi_sdpclk_clkgen/clk_0 clkin_aligner/clk_in
ad_connect clkin_aligner/clk_out   ad713x_sdpclk

# odr generator

ad_ip_instance axi_pwm_gen odr_generator
ad_ip_parameter odr_generator CONFIG.N_PWMS 2
ad_ip_parameter odr_generator CONFIG.PULSE_0_PERIOD 85
ad_ip_parameter odr_generator CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter odr_generator CONFIG.PULSE_0_OFFSET 3
ad_ip_parameter odr_generator CONFIG.PULSE_1_PERIOD 85
ad_ip_parameter odr_generator CONFIG.PULSE_1_WIDTH 13

# Sequence.txt §F.7 — anchor the PWM period counter to edge 146 via ext_sync,
# so the first ODR pulse lands on a boot-invariant CLKin cycle. FORCE_ALIGN +
# EXT_SYNC_PHASE_ALIGN make the per-channel pulse_period_cnt re-zero on the
# ext_sync strobe (bare ext_sync only re-zeros the offset counter, which is
# insufficient). EXT_ASYNC_SYNC double-flops the strobe into the PWM clk domain.

ad_ip_parameter odr_generator CONFIG.PWM_EXT_SYNC 1
ad_ip_parameter odr_generator CONFIG.EXT_ASYNC_SYNC 1
ad_ip_parameter odr_generator CONFIG.EXT_SYNC_PHASE_ALIGN 1
ad_ip_parameter odr_generator CONFIG.FORCE_ALIGN 1

ad_connect odr_generator/ext_clk clkin_aligner/clk_out
ad_connect odr_generator/pwm_0 $hier_spi_engine/trigger

# Sequence.txt §F.10 — re-register ODR on negedge of XTAL2_CLKIN inside
# clkin_aligner so transitions align with the CLKin falling edge.

ad_connect odr_generator/pwm_1 clkin_aligner/odr_in
ad_connect clkin_aligner/odr_out ad713x_odr

# Sequence.txt §F.7 — edge-146 anchor strobe into the PWM external sync.

ad_connect clkin_aligner/odr_sync odr_generator/ext_sync

ad_connect  axi_ad7134_clkgen/clk_0 $hier_spi_engine/spi_clk
ad_connect  $sys_cpu_clk axi_ad7134_clkgen/clk
ad_connect  $sys_cpu_clk $hier_spi_engine/clk
ad_connect  axi_ad7134_clkgen/clk_0 axi_ad7134_dma/s_axis_aclk
ad_connect  sys_cpu_resetn $hier_spi_engine/resetn
ad_connect  sys_cpu_resetn axi_ad7134_dma/m_dest_axi_aresetn

ad_connect  $hier_spi_engine/m_spi ad713x_di
ad_connect  axi_ad7134_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE

# AXI address definitions

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad7134_dma
ad_cpu_interconnect 0x44b00000 odr_generator
ad_cpu_interconnect 0x44b10000 axi_ad7134_clkgen
ad_cpu_interconnect 0x44b20000 axi_sdpclk_clkgen
ad_cpu_interconnect 0x44b30000 clkin_aligner

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_ad7134_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq
ad_cpu_interrupt "ps-10" "mb-10" clkin_aligner/irq

# memory interconnects

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7134_dma/m_dest_axi
