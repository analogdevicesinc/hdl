###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Agilex5e carrier qsys

set system_type "Agilex 5"

# clocks & reset

add_instance sys_clk clock_source
add_interface sys_clk clock sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
add_interface sys_rst reset sink
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

add_instance agilex_reset altera_s10_user_rst_clkgate
add_interface rst_ninit_done reset source
set_interface_property rst EXPORT_OF agilex_reset.ninit_done

# gts reset sequencer
add_instance gts_reset intel_srcss_gts
set_instance_parameter_value gts_reset {SRC_RS_DISABLE} {1}
set_instance_parameter_value gts_reset {NUM_BANKS_SHORELINE} {1}

# hps
# round-about way - qsys-script doesn't support {*}?

variable  hps_io_list

proc set_hps_io {io_index io_type} {

  global hps_io_list
  lappend hps_io_list $io_type
}

set_hps_io HPS_IOA_1   GPIO0:IO0
set_hps_io HPS_IOA_2   GPIO0:IO1
set_hps_io HPS_IOA_3   UART0:TX
set_hps_io HPS_IOA_4   UART0:RX
set_hps_io HPS_IOA_5   EMAC2:PPS2
set_hps_io HPS_IOA_6   EMAC2:PPSTRIG2
set_hps_io HPS_IOA_7   MDIO2:MDIO
set_hps_io HPS_IOA_8   MDIO2:MDC
set_hps_io HPS_IOA_9   I3C1:SDA
set_hps_io HPS_IOA_10  I3C1:SCL
set_hps_io HPS_IOA_11  HCLK:HPS_OSC_CLK
set_hps_io HPS_IOA_12  GPIO0:IO11
set_hps_io HPS_IOA_13  USB1:CLK
set_hps_io HPS_IOA_14  USB1:STP
set_hps_io HPS_IOA_15  USB1:DIR
set_hps_io HPS_IOA_16  USB1:DATA0
set_hps_io HPS_IOA_17  USB1:DATA1
set_hps_io HPS_IOA_18  USB1:NXT
set_hps_io HPS_IOA_19  USB1:DATA2
set_hps_io HPS_IOA_20  USB1:DATA3
set_hps_io HPS_IOA_21  USB1:DATA4
set_hps_io HPS_IOA_22  USB1:DATA5
set_hps_io HPS_IOA_23  USB1:DATA6
set_hps_io HPS_IOA_24  USB1:DATA7
set_hps_io HPS_IOB_1   SDMMC:DATA0
set_hps_io HPS_IOB_2   SDMMC:DATA1
set_hps_io HPS_IOB_3   SDMMC:CCLK
set_hps_io HPS_IOB_4   GPIO1:IO3
set_hps_io HPS_IOB_5   GPIO1:IO4
set_hps_io HPS_IOB_6   SDMMC:DATA2
set_hps_io HPS_IOB_7   SDMMC:DATA3
set_hps_io HPS_IOB_8   SDMMC:CMD
set_hps_io HPS_IOB_9   JTAG:TCK
set_hps_io HPS_IOB_10  JTAG:TMS
set_hps_io HPS_IOB_11  JTAG:TDO
set_hps_io HPS_IOB_12  JTAG:TDI
set_hps_io HPS_IOB_13  EMAC2:TX_CLK
set_hps_io HPS_IOB_14  EMAC2:TX_CTL
set_hps_io HPS_IOB_15  EMAC2:RX_CLK
set_hps_io HPS_IOB_16  EMAC2:RX_CTL
set_hps_io HPS_IOB_17  EMAC2:TXD0
set_hps_io HPS_IOB_18  EMAC2:TXD1
set_hps_io HPS_IOB_19  EMAC2:RXD0
set_hps_io HPS_IOB_20  EMAC2:RXD1
set_hps_io HPS_IOB_21  EMAC2:TXD2
set_hps_io HPS_IOB_22  EMAC2:TXD3
set_hps_io HPS_IOB_23  EMAC2:RXD2
set_hps_io HPS_IOB_24  EMAC2:RXD3

add_instance sys_hps intel_agilex_5_soc
set_instance_parameter_value sys_hps ATB_Enable {0}
set_instance_parameter_value sys_hps CM_Mode {N/A}
set_instance_parameter_value sys_hps CM_PinMuxing {Unused}
set_instance_parameter_value sys_hps CTI_Enable {0}
set_instance_parameter_value sys_hps DMA_Enable {No No No No No No No No}
set_instance_parameter_value sys_hps Debug_APB_Enable {0}
set_instance_parameter_value sys_hps EMAC0_Mode {N/A}
set_instance_parameter_value sys_hps EMAC0_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC0_PTP {0}
set_instance_parameter_value sys_hps EMAC0_PinMuxing {Unused}
set_instance_parameter_value sys_hps EMAC1_Mode {N/A}
set_instance_parameter_value sys_hps EMAC1_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC1_PTP {0}
set_instance_parameter_value sys_hps EMAC1_PinMuxing {Unused}
set_instance_parameter_value sys_hps EMAC2_Mode {RGMII_with_MDIO}
set_instance_parameter_value sys_hps EMAC2_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC2_PTP {0}
set_instance_parameter_value sys_hps EMAC2_PinMuxing {IO}
set_instance_parameter_value sys_hps EMIF_AXI_Enable {1}
set_instance_parameter_value sys_hps EMIF_Topology {1}
set_instance_parameter_value sys_hps F2H_IRQ_Enable {1}
set_instance_parameter_value sys_hps F2H_free_clk_mhz {125}
set_instance_parameter_value sys_hps F2H_free_clock_enable {0}
set_instance_parameter_value sys_hps FPGA_EMAC0_gtx_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_EMAC0_md_clk_mhz {2.5}
set_instance_parameter_value sys_hps FPGA_EMAC1_gtx_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_EMAC1_md_clk_mhz {2.5}
set_instance_parameter_value sys_hps FPGA_EMAC2_gtx_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_EMAC2_md_clk_mhz {2.5}
set_instance_parameter_value sys_hps FPGA_I2C0_sclk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I2C1_sclk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I2CEMAC0_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I2CEMAC1_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I2CEMAC2_clk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I3C0_sclk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_I3C1_sclk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_SPIM0_sclk_mhz {125.0}
set_instance_parameter_value sys_hps FPGA_SPIM1_sclk_mhz {125.0}
set_instance_parameter_value sys_hps GP_Enable {0}
set_instance_parameter_value sys_hps H2F_Address_Width {38}
set_instance_parameter_value sys_hps H2F_IRQ_DMA_Enable0 {0}
set_instance_parameter_value sys_hps H2F_IRQ_DMA_Enable1 {0}
set_instance_parameter_value sys_hps H2F_IRQ_ECC_SERR_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_EMAC0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_EMAC1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_EMAC2_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_GPIO0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_GPIO1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I2C0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I2C1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I2CEMAC0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I2CEMAC1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I2CEMAC2_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I3C0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_I3C1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_L4Timer_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_NAND_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_PeriphClock_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SDMMC_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SPIM0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SPIM1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SPIS0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SPIS1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_SYSTimer_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_UART0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_UART1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_USB0_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_USB1_Enable {0}
set_instance_parameter_value sys_hps H2F_IRQ_Watchdog_Enable {0}
set_instance_parameter_value sys_hps H2F_Width {128}
set_instance_parameter_value sys_hps HPS_IO_Enable $hps_io_list
set_instance_parameter_value sys_hps I2C0_Mode {N/A}
set_instance_parameter_value sys_hps I2C0_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2C1_Mode {N/A}
set_instance_parameter_value sys_hps I2C1_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2CEMAC0_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC0_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2CEMAC1_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC1_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2CEMAC2_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC2_PinMuxing {Unused}
set_instance_parameter_value sys_hps I3C0_Mode {N/A}
set_instance_parameter_value sys_hps I3C0_PinMuxing {Unused}
set_instance_parameter_value sys_hps I3C1_Mode {N/A}
set_instance_parameter_value sys_hps I3C1_PinMuxing {Unused}
set_instance_parameter_value sys_hps IO_INPUT_DELAY0 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY1 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY10 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY11 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY12 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY13 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY14 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY15 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY16 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY17 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY18 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY19 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY2 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY20 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY21 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY22 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY23 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY24 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY25 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY26 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY27 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY28 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY29 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY3 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY30 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY31 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY32 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY33 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY34 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY35 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY36 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY37 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY38 {21}
set_instance_parameter_value sys_hps IO_INPUT_DELAY39 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY4 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY40 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY41 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY42 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY43 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY44 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY45 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY46 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY47 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY5 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY6 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY7 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY8 {-1}
set_instance_parameter_value sys_hps IO_INPUT_DELAY9 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY0 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY1 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY10 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY11 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY12 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY13 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY14 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY15 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY16 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY17 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY18 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY19 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY2 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY20 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY21 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY22 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY23 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY24 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY25 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY26 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY27 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY28 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY29 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY3 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY30 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY31 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY32 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY33 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY34 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY35 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY36 {21}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY37 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY38 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY39 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY4 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY40 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY41 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY42 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY43 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY44 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY45 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY46 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY47 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY5 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY6 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY7 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY8 {-1}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY9 {-1}
set_instance_parameter_value sys_hps JTAG_Enable {0}
set_instance_parameter_value sys_hps LWH2F_Address_Width {29}
set_instance_parameter_value sys_hps LWH2F_Width {32}
set_instance_parameter_value sys_hps MPLL_C0_Override_mhz {800.0}
set_instance_parameter_value sys_hps MPLL_C1_Override_mhz {800.0}
set_instance_parameter_value sys_hps MPLL_C2_Override_mhz {533.33}
set_instance_parameter_value sys_hps MPLL_C3_Override_mhz {400.0}
set_instance_parameter_value sys_hps MPLL_Clock_Source {0}
set_instance_parameter_value sys_hps MPLL_Override {1}
set_instance_parameter_value sys_hps MPLL_VCO_Override_mhz {3200.0}
set_instance_parameter_value sys_hps MPU_Events_Enable {0}
set_instance_parameter_value sys_hps MPU_clk_freq_override_mhz {533.33}
set_instance_parameter_value sys_hps MPU_clk_override {1}
set_instance_parameter_value sys_hps MPU_clk_src_override {2}
set_instance_parameter_value sys_hps MPU_core01_freq_override_mhz {800.0}
set_instance_parameter_value sys_hps MPU_core01_src_override {1}
set_instance_parameter_value sys_hps MPU_core23_src_override {0}
set_instance_parameter_value sys_hps MPU_core2_freq_override_mhz {800.0}
set_instance_parameter_value sys_hps MPU_core3_freq_override_mhz {800.0}
set_instance_parameter_value sys_hps NAND_Mode {N/A}
set_instance_parameter_value sys_hps NAND_PinMuxing {Unused}
set_instance_parameter_value sys_hps NOC_clk_cs_debug_div {4}
set_instance_parameter_value sys_hps NOC_clk_cs_div {1}
set_instance_parameter_value sys_hps NOC_clk_cs_trace_div {4}
set_instance_parameter_value sys_hps NOC_clk_free_l4_div {4}
set_instance_parameter_value sys_hps NOC_clk_periph_l4_div {2}
set_instance_parameter_value sys_hps NOC_clk_phy_div {4}
set_instance_parameter_value sys_hps NOC_clk_slow_l4_div {4}
set_instance_parameter_value sys_hps NOC_clk_src_select {3}
set_instance_parameter_value sys_hps PLL_CLK0 {Unused}
set_instance_parameter_value sys_hps PLL_CLK1 {Unused}
set_instance_parameter_value sys_hps PLL_CLK2 {Unused}
set_instance_parameter_value sys_hps PLL_CLK3 {Unused}
set_instance_parameter_value sys_hps PLL_CLK4 {Unused}
set_instance_parameter_value sys_hps PPLL_C0_Override_mhz {600.0}
set_instance_parameter_value sys_hps PPLL_C1_Override_mhz {600.0}
set_instance_parameter_value sys_hps PPLL_C2_Override_mhz {24.0}
set_instance_parameter_value sys_hps PPLL_C3_Override_mhz {500.0}
set_instance_parameter_value sys_hps PPLL_Clock_Source {0}
set_instance_parameter_value sys_hps PPLL_Override {1}
set_instance_parameter_value sys_hps PPLL_VCO_Override_mhz {3000.0}
set_instance_parameter_value sys_hps Periph_clk_emac0_sel {50}
set_instance_parameter_value sys_hps Periph_clk_emac1_sel {50}
set_instance_parameter_value sys_hps Periph_clk_emac2_sel {50}
set_instance_parameter_value sys_hps Periph_clk_override {0}
set_instance_parameter_value sys_hps Periph_emac_ptp_freq_override {400.0}
set_instance_parameter_value sys_hps Periph_emac_ptp_src_override {7}
set_instance_parameter_value sys_hps Periph_emaca_src_override {7}
set_instance_parameter_value sys_hps Periph_emacb_src_override {7}
set_instance_parameter_value sys_hps Periph_gpio_freq_override {400.0}
set_instance_parameter_value sys_hps Periph_gpio_src_override {3}
set_instance_parameter_value sys_hps Periph_psi_freq_override {500.0}
set_instance_parameter_value sys_hps Periph_psi_src_override {7}
set_instance_parameter_value sys_hps Periph_usb_freq_override {20.0}
set_instance_parameter_value sys_hps Periph_usb_src_override {3}
set_instance_parameter_value sys_hps Pwr_a55_core0_1_on {1}
set_instance_parameter_value sys_hps Pwr_a76_core2_on {1}
set_instance_parameter_value sys_hps Pwr_a76_core3_on {1}
set_instance_parameter_value sys_hps Pwr_boot_core_sel {0}
set_instance_parameter_value sys_hps Pwr_cpu_app_select {0}
set_instance_parameter_value sys_hps Pwr_mpu_l3_cache_size {2}
set_instance_parameter_value sys_hps Rst_h2f_cold_en {0}
set_instance_parameter_value sys_hps Rst_hps_warm_en {0}
set_instance_parameter_value sys_hps Rst_sdm_wd_config {0}
set_instance_parameter_value sys_hps Rst_watchdog_en {0}
set_instance_parameter_value sys_hps SDMMC_Mode {N/A}
set_instance_parameter_value sys_hps SDMMC_PinMuxing {Unused}
set_instance_parameter_value sys_hps SPIM0_Mode {N/A}
set_instance_parameter_value sys_hps SPIM0_PinMuxing {Unused}
set_instance_parameter_value sys_hps SPIM1_Mode {N/A}
set_instance_parameter_value sys_hps SPIM1_PinMuxing {Unused}
set_instance_parameter_value sys_hps SPIS0_Mode {N/A}
set_instance_parameter_value sys_hps SPIS0_PinMuxing {Unused}
set_instance_parameter_value sys_hps SPIS1_Mode {N/A}
set_instance_parameter_value sys_hps SPIS1_PinMuxing {Unused}
set_instance_parameter_value sys_hps STM_Enable {0}
set_instance_parameter_value sys_hps TPIU_Select {HPS Clock Manager}
set_instance_parameter_value sys_hps TRACE_Mode {N/A}
set_instance_parameter_value sys_hps TRACE_PinMuxing {Unused}
set_instance_parameter_value sys_hps UART0_Mode {No_flow_control}
set_instance_parameter_value sys_hps UART0_PinMuxing {IO}
set_instance_parameter_value sys_hps UART1_Mode {N/A}
set_instance_parameter_value sys_hps UART1_PinMuxing {Unused}
set_instance_parameter_value sys_hps USB0_Mode {N/A}
set_instance_parameter_value sys_hps USB0_PinMuxing {Unused}
set_instance_parameter_value sys_hps USB1_Mode {default}
set_instance_parameter_value sys_hps USB1_PinMuxing {IO}
set_instance_parameter_value sys_hps User0_clk_enable {1}
set_instance_parameter_value sys_hps User0_clk_freq {250}
set_instance_parameter_value sys_hps User0_clk_src_select {7}
set_instance_parameter_value sys_hps User1_clk_enable {0}
set_instance_parameter_value sys_hps User1_clk_freq {500.0}
set_instance_parameter_value sys_hps User1_clk_src_select {7}
set_instance_parameter_value sys_hps eosc1_clk_mhz {25.0}
set_instance_parameter_value sys_hps f2s_SMMU {0}
set_instance_parameter_value sys_hps f2s_address_width {32}
set_instance_parameter_value sys_hps f2s_data_width {256}
set_instance_parameter_value sys_hps f2s_mode {ace5lite}
set_instance_parameter_value sys_hps f2sdram_SMMU {0}
set_instance_parameter_value sys_hps f2sdram_address_width {32}
set_instance_parameter_value sys_hps f2sdram_data_width {Unused}
set_instance_parameter_value sys_hps hps_ioa10_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa11_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa12_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa13_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa14_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa15_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa16_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa17_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa18_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa19_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa1_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa20_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa21_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa22_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa23_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa24_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa2_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa3_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa4_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa5_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa6_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa7_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa8_opd_en {0}
set_instance_parameter_value sys_hps hps_ioa9_opd_en {0}
set_instance_parameter_value sys_hps hps_iob10_opd_en {0}
set_instance_parameter_value sys_hps hps_iob11_opd_en {0}
set_instance_parameter_value sys_hps hps_iob12_opd_en {0}
set_instance_parameter_value sys_hps hps_iob13_opd_en {0}
set_instance_parameter_value sys_hps hps_iob14_opd_en {0}
set_instance_parameter_value sys_hps hps_iob15_opd_en {0}
set_instance_parameter_value sys_hps hps_iob16_opd_en {0}
set_instance_parameter_value sys_hps hps_iob17_opd_en {0}
set_instance_parameter_value sys_hps hps_iob18_opd_en {0}
set_instance_parameter_value sys_hps hps_iob19_opd_en {0}
set_instance_parameter_value sys_hps hps_iob1_opd_en {0}
set_instance_parameter_value sys_hps hps_iob20_opd_en {0}
set_instance_parameter_value sys_hps hps_iob21_opd_en {0}
set_instance_parameter_value sys_hps hps_iob22_opd_en {0}
set_instance_parameter_value sys_hps hps_iob23_opd_en {0}
set_instance_parameter_value sys_hps hps_iob24_opd_en {0}
set_instance_parameter_value sys_hps hps_iob2_opd_en {0}
set_instance_parameter_value sys_hps hps_iob3_opd_en {0}
set_instance_parameter_value sys_hps hps_iob4_opd_en {0}
set_instance_parameter_value sys_hps hps_iob5_opd_en {0}
set_instance_parameter_value sys_hps hps_iob6_opd_en {0}
set_instance_parameter_value sys_hps hps_iob7_opd_en {0}
set_instance_parameter_value sys_hps hps_iob8_opd_en {0}
set_instance_parameter_value sys_hps hps_iob9_opd_en {0}

add_interface h2f_reset reset source
set_interface_property h2f_reset EXPORT_OF sys_hps.h2f_reset

add_connection sys_clk.clk sys_hps.hps2fpga_axi_clock
add_connection sys_clk.clk_reset sys_hps.hps2fpga_axi_reset
add_connection sys_clk.clk sys_hps.lwhps2fpga_axi_clock
add_connection sys_clk.clk_reset sys_hps.lwhps2fpga_axi_reset
add_connection sys_clk.clk sys_hps.fpga2hps_clock
add_connection sys_clk.clk_reset sys_hps.fpga2hps_reset
add_connection sys_clk.clk sys_hps.usb31_phy_reconfig_clk
add_connection sys_clk.clk_reset sys_hps.usb31_phy_reconfig_rst

add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io

# common dma interfaces

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_clk {clockFrequency} {250000000.0}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {true}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clk sys_dma_clk.clk_in

# hps emif

add_component emif_hps ip/template_a5ed065es/emif_io96b_hps.ip emif_io96b_hps emif_io96b_hps_inst
load_component emif_hps
set_component_parameter_value EMIF_PROTOCOL {DDR4_COMP}
set_component_parameter_value EMIF_REF_CLK_SHARING {0}
set_component_parameter_value EMIF_RZQ_SHARING {0}
set_component_parameter_value EMIF_SHOW_INTERNAL_SETTINGS {0}
set_component_parameter_value EMIF_TOPOLOGY {1x32}
set_component_project_property HIDE_FROM_IP_CATALOG {false}

set_component_sub_module_parameter_value emif_0_ddr4comp ADV_CAL_ENABLE_MARGIN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp ADV_CAL_ENABLE_REQ {1}
set_component_sub_module_parameter_value emif_0_ddr4comp ADV_CAL_ENABLE_WEQ {1}
set_component_sub_module_parameter_value emif_0_ddr4comp ANALOG_PARAM_DERIVATION_PARAM_NAME {}
set_component_sub_module_parameter_value emif_0_ddr4comp AXI4_ADDR_WIDTH {40}
set_component_sub_module_parameter_value emif_0_ddr4comp AXI4_USER_WIDTH {32}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_AUTO_PRECHARGE_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_DMDBI_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_DM_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_ECC_AUTOCORRECT_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_PERFORMANCE_PROFILE {default}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_RD_DBI_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_SCRAMBLER_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp CTRL_WR_DBI_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp DIAG_EXTRA_PARAMETERS {}
set_component_sub_module_parameter_value emif_0_ddr4comp DIAG_HMC_ADDR_SWAP_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp EX_DESIGN_PMON_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp EX_DESIGN_PMON_INTERNAL_JAMB_EN {1}
set_component_sub_module_parameter_value emif_0_ddr4comp HPS_EMIF_RZQ_SHARING {0}
set_component_sub_module_parameter_value emif_0_ddr4comp INSTANCE_ID {0}
set_component_sub_module_parameter_value emif_0_ddr4comp IS_HPS {1}
set_component_sub_module_parameter_value emif_0_ddr4comp JEDEC_OVERRIDE_TABLE_PARAM_NAME {MEM_TRAS_NS MEM_TCCD_L_NS MEM_TCCD_S_NS MEM_TRRD_L_NS MEM_TFAW_NS MEM_TWTR_L_NS MEM_TWTR_S_NS MEM_TMRD_NS MEM_TCKSRE_NS MEM_TCKSRX_NS MEM_TCKE_NS MEM_TMPRR_NS MEM_TDSH_NS MEM_TDSS_NS MEM_TIH_NS MEM_TIS_NS MEM_TQSH_NS MEM_TWLH_NS MEM_TWLS_NS MEM_TRFC_DLR_NS MEM_TRRD_DLR_NS MEM_TFAW_DLR_NS MEM_TCCD_DLR_NS MEM_TXP_NS MEM_TXS_DLL_NS MEM_TCPDED_NS MEM_TMOD_NS MEM_TZQCS_NS}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_3DS_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_AC_MIRRORING_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_AC_PARITY_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_AC_PARITY_LATENCY_MODE {0.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_AL_CYC {0.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_A_WIDTH {17}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_BANK_ADDR_WIDTH {2}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_BANK_GROUP_ADDR_WIDTH {2}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CHANNEL_ADDR_NUM_BITS {36}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CHANNEL_CAPACITY_GBITS {64}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CHANNEL_CS_WIDTH {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CHANNEL_ECC_DQ_WIDTH {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CKE_WIDTH {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CK_WIDTH {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CLAMSHELL_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CL_CYC {12.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_COL_ADDR_WIDTH {10}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CS_WIDTH {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CS_WIDTH_PHYSICAL {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_CWL_CYC {9.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_C_WIDTH {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_DIE_DENSITY_GBITS {16}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_DIE_DQ_WIDTH {8}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_DQ_PER_DQS {8}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_DQ_VREF {35}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_FINE_GRANULARITY_REFRESH_MODE {1.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_NUM_CHANNELS {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_NUM_CHANNELS_PER_IO96 {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_NUM_IO96 {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_DQ_X_IDLE {off}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_DQ_X_NON_TGT_RD {off}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_DQ_X_NON_TGT_WR {off}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_DQ_X_RON {7}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_DQ_X_TGT_WR {4}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_NOM {off}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_PARK {4}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ODT_WR {off}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_OPERATING_FREQ_MHZ {800}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_OPERATING_FREQ_MHZ_AUTOSET_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_PAGE_SIZE {1024.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_RANKS_SHARE_CK_EN {1}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_RD_PREAMBLE_MODE {1.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_ROW_ADDR_WIDTH {17}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_SPEEDBIN {1600L}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_SPEEDBIN_DATARATE {1600}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCCD_DLR_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCCD_L_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCCD_S_NS {4.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCKESR_CYC {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCKE_NS {4.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCKSRE_NS {8.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCKSRX_NS {8.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCK_CL_CWL_MAX_NS {1.5}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCK_CL_CWL_MIN_NS {1.25}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TCPDED_NS {4.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TDQSCK_MAX_MIN_NS {0.225}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TDQSCK_NS {0.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TDQSS_CYC {0.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TDSH_NS {0.18}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TDSS_NS {0.18}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TFAW_DLR_NS {20.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TFAW_NS {35.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TIH_NS {140000.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TIS_NS {115000.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TMOD_NS {24.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TMPRR_NS {1.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TMRD_NS {8.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TQSH_NS {0.4}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRAS_MAX_NS {70200.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRAS_MIN_NS {35.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRAS_NS {35.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRCD_NS {15.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRC_NS {50.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TREFI_NS {7800.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRFC_DLR_NS {190.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRFC_NS {550.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRP_NS {15.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRRD_DLR_NS {4.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRRD_L_NS {6.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRRD_S_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TRTP_NS {7.5}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWLH_NS {0.13}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWLS_NS {0.13}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWR_CRC_DM_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWR_NS {15.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWTR_L_CRC_DM_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWTR_L_NS {6.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWTR_S_CRC_DM_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TWTR_S_NS {2.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TXP_NS {5.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TXS_DLL_NS {597.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TXS_NS {560.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TZQCS_NS {128.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TZQINIT_CYC {1024.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_TZQOPER_CYC {512.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_VREF_DQ_X_RANGE {2}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_VREF_DQ_X_VALUE {67.75}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_WR_CRC_EN {0.0}
set_component_sub_module_parameter_value emif_0_ddr4comp MEM_WR_PREAMBLE_MODE {1.0}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_AC_PLACEMENT {BOT}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_ALERT_N_PLACEMENT {AC2}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_FORCE_MIN_4_AC_LANES_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_REFCLK_ADVANCED_SELECT_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_REFCLK_FREQ_MHZ {100.0}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_REFCLK_FREQ_MHZ_AUTOSET_EN {0}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_SWIZZLE_MAP {BYTE_SWIZZLE_CH0=3 X X X 0 2 1 X;PIN_SWIZZLE_CH0_DQS0=7 1 2 3 4 5 6 0;PIN_SWIZZLE_CH0_DQS1=15 14 13 12 11 10 9 8;PIN_SWIZZLE_CH0_DQS2=20 21 22 23 16 17 18 19;PIN_SWIZZLE_CH0_DQS3=31 24 25 26 27 28 29 30;}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_AC_OUTPUT_IO_STD_TYPE {SSTL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_CK_OUTPUT_IO_STD_TYPE {DF_SSTL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_CS_OUTPUT_IO_STD_TYPE {SSTL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_DQS_IO_STD_TYPE {DF_POD}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_DQ_IO_STD_TYPE {POD}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_DQ_SLEW_RATE {FASTEST}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_DQ_VREF {68.3}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_GPIO_IO_STD_TYPE {LVCMOS}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_REFCLK_IO_STD_TYPE {TRUE_DIFF}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_S_AC_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_S_CK_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_S_CS_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_S_DQ_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_T_DQ_INPUT_OHM {RT_50_OHM_CAL}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_T_GPIO_INPUT_OHM {RT_OFF}
set_component_sub_module_parameter_value emif_0_ddr4comp PHY_TERM_X_R_T_REFCLK_INPUT_OHM {RT_DIFF}
set_component_sub_module_parameter_value emif_0_ddr4comp PLACEMENT_SCHEMES {DDR4_X32_3AC_BOT}
set_component_sub_module_parameter_value emif_0_ddr4comp S0_AXID_WIDTH {7}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_BOARD {default}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_BOARD_TRAIT {}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE {A5ED065BB32AE6SR0}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_BASE_DIE {SM7}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_DIE_REVISIONS {MAIN_SM7_REVA}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_FAMILY {Agilex 5}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_GROUP {B}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_IOBANK_REVISION {IO96B}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_POWER_MODEL {STANDARD_POWER_FIXED}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_SPEEDGRADE {6}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_DEVICE_TEMPERATURE_GRADE {EXTENDED}
set_component_sub_module_parameter_value emif_0_ddr4comp SYSINFO_SUPPORTS_VID {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_R2R_DIFFCS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_R2R_SAMECS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_R2W_DIFFCS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_R2W_SAMECS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_W2R_DIFFCS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_W2R_SAMECS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_W2W_DIFFCS_CYC {0}
set_component_sub_module_parameter_value emif_0_ddr4comp TURNAROUND_W2W_SAMECS_CYC {0}
save_component

add_connection emif_hps.io96b0_to_hps sys_hps.io96b0_to_hps

# cache coherency

add_instance sys_hps_cache_coherency altera_ace5lite_cache_coherency_translator
set_instance_parameter_value sys_hps_cache_coherency F2H_ADDRESS_WIDTH {32}

add_connection sys_clk.clk sys_hps_cache_coherency.clock
add_connection sys_clk.clk_reset sys_hps_cache_coherency.reset
add_connection sys_hps_cache_coherency.m0 sys_hps.fpga2hps

# jtag

add_instance fpga_m altera_jtag_avalon_master
add_instance hps_m  altera_jtag_avalon_master

add_connection sys_clk.clk hps_m.clk
add_connection sys_clk.clk fpga_m.clk
add_connection sys_clk.clk_reset hps_m.clk_reset
add_connection sys_clk.clk_reset fpga_m.clk_reset

add_connection hps_m.master sys_hps_cache_coherency.s0
add_connection fpga_m.master sys_hps.usb31_phy_reconfig_slave

# system id

add_instance axi_sysid_0 axi_sysid
add_instance rom_sys_0 sysid_rom

add_connection axi_sysid_0.if_rom_addr rom_sys_0.if_rom_addr
add_connection rom_sys_0.if_rom_data axi_sysid_0.if_sys_rom_data
add_connection sys_clk.clk rom_sys_0.if_clk
add_connection sys_clk.clk axi_sysid_0.s_axi_clock
add_connection sys_clk.clk_reset axi_sysid_0.s_axi_reset

add_interface pr_rom_data_nc conduit end
set_interface_property pr_rom_data_nc EXPORT_OF axi_sysid_0.if_pr_rom_data

# cpu/hps handling

proc ad_dma_interconnect {m_port} {
    # We cannot enable the f2sdram bridge if we don't use it
    # So we instantiate it as disabled and only enable it
    # if we are using it in the design
    set f2sdram_data_width [get_instance_parameter_value sys_hps f2sdram_data_width]
    if {$f2sdram_data_width == 0} {
      set_instance_parameter_value sys_hps f2sdram_data_width {256}
      add_connection sys_dma_clk.clk sys_hps.f2sdram_axi_clock
      add_connection sys_dma_clk.clk_reset sys_hps.f2sdram_axi_reset
    }
    add_connection ${m_port} sys_hps.f2sdram
    set_connection_parameter_value ${m_port}/sys_hps.f2sdram baseAddress {0x0}
}

proc ad_cpu_interrupt {m_irq m_port} {

    add_connection sys_hps.fpga2hps_interrupt_irq0 ${m_port}
    set_connection_parameter_value sys_hps.fpga2hps_interrupt_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port {avl_bridge ""} {avl_bridge_base 0x00000000} {avl_address_width 18}} {
  if {[string equal ${avl_bridge} ""]} {
    add_connection sys_hps.lwhps2fpga ${m_port}
    set_connection_parameter_value sys_hps.lwhps2fpga/${m_port} baseAddress ${m_base}
  } else {
    if {[lsearch -exact [get_instances] ${avl_bridge}] == -1} {
      ## Instantiate the bridge and connect the interfaces
      add_instance ${avl_bridge} altera_avalon_mm_bridge
      set_instance_parameter_value ${avl_bridge} {ADDRESS_WIDTH} $avl_address_width
      set_instance_parameter_value ${avl_bridge} {SYNC_RESET} {1}
      add_connection sys_hps.lwhps2fpga ${avl_bridge}.s0
      set_connection_parameter_value sys_hps.lwhps2fpga/${avl_bridge}.s0 baseAddress ${avl_bridge_base}
      add_connection sys_clk.clk ${avl_bridge}.clk
      add_connection sys_clk.clk_reset ${avl_bridge}.reset
    }
    add_connection ${avl_bridge}.m0 ${m_port}
    set_connection_parameter_value ${avl_bridge}.m0/${m_port} baseAddress ${m_base}
  }
}

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {32}

add_connection sys_clk.clk sys_gpio_bd.clk
add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_interface sys_gpio_bd conduit end
set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection

# gpio-in

add_instance sys_gpio_in altera_avalon_pio
set_instance_parameter_value sys_gpio_in {direction} {Input}
set_instance_parameter_value sys_gpio_in {generateIRQ} {1}
set_instance_parameter_value sys_gpio_in {width} {32}

add_connection sys_clk.clk_reset sys_gpio_in.reset
add_connection sys_clk.clk sys_gpio_in.clk
add_interface sys_gpio_in conduit end
set_interface_property sys_gpio_in EXPORT_OF sys_gpio_in.external_connection

# gpio-out

add_instance sys_gpio_out altera_avalon_pio
set_instance_parameter_value sys_gpio_out {direction} {Output}
set_instance_parameter_value sys_gpio_out {generateIRQ} {0}
set_instance_parameter_value sys_gpio_out {width} {32}

add_connection sys_clk.clk_reset sys_gpio_out.reset
add_connection sys_clk.clk sys_gpio_out.clk
add_interface sys_gpio_out conduit end
set_interface_property sys_gpio_out EXPORT_OF sys_gpio_out.external_connection

# spi

add_instance sys_spi altera_avalon_spi
set_instance_parameter_value sys_spi {clockPhase} {0}
set_instance_parameter_value sys_spi {clockPolarity} {0}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {8}
set_instance_parameter_value sys_spi {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset sys_spi.reset
add_connection sys_clk.clk sys_spi.clk
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external

## connections

# exports

set_interface_property o_pma_cu_clk EXPORT_OF gts_reset.o_pma_cu_clk
set_interface_property i_refclk_bus_out EXPORT_OF gts_reset.i_refclk_bus_out
set_interface_property o_shoreline_refclk_fail_stat EXPORT_OF gts_reset.o_shoreline_refclk_fail_stat

set_interface_property h2f_warm_reset_handshake EXPORT_OF sys_hps.h2f_warm_reset_handshake

set_interface_property f2h_irq1_in EXPORT_OF sys_hps.fpga2hps_interrupt_irq1
set_interface_property usb31_io EXPORT_OF sys_hps.usb31_io
set_interface_property usb31_phy_refclk_p EXPORT_OF sys_hps.usb31_phy_refclk_p
set_interface_property usb31_phy_refclk_n EXPORT_OF sys_hps.usb31_phy_refclk_n
set_interface_property usb31_phy_rx_serial_n EXPORT_OF sys_hps.usb31_phy_rx_serial_n
set_interface_property usb31_phy_rx_serial_p EXPORT_OF sys_hps.usb31_phy_rx_serial_p
set_interface_property usb31_phy_tx_serial_n EXPORT_OF sys_hps.usb31_phy_tx_serial_n
set_interface_property usb31_phy_tx_serial_p EXPORT_OF sys_hps.usb31_phy_tx_serial_p
set_interface_property usb31_phy_pma_cpu_clk EXPORT_OF sys_hps.usb31_phy_pma_cpu_clk

set_interface_property hps_emif_mem_0 EXPORT_OF emif_hps.mem_0
set_interface_property hps_emif_mem_ck_0 EXPORT_OF emif_hps.mem_ck_0
set_interface_property hps_emif_mem_reset_n EXPORT_OF emif_hps.mem_reset_n
set_interface_property hps_emif_oct_0 EXPORT_OF emif_hps.oct_0
set_interface_property hps_emif_ref_clk_0 EXPORT_OF emif_hps.ref_clk

# cpu interconnect

ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi "avl_peripheral_mm_bridge"

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq

set xcvr_reconfig_addr_width 11
