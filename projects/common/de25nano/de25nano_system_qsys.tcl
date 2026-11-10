###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Intel specific helper proc/ compatibility with xilinx procs on adi_board.tcl
source $ad_hdl_dir/projects/scripts/adi_board_intel.tcl

# de25nano carrier qsys
set system_type "Agilex 5"

variable hps_io_list

proc set_hps_io {io_index io_type} {

  global hps_io_list
  lappend hps_io_list $io_type
}

# HPS I/O bank A

set_hps_io HPS_IOA_1   USB0:CLK
set_hps_io HPS_IOA_2   USB0:STP
set_hps_io HPS_IOA_3   USB0:DIR
set_hps_io HPS_IOA_4   USB0:DATA0
set_hps_io HPS_IOA_5   USB0:DATA1
set_hps_io HPS_IOA_6   USB0:NXT
set_hps_io HPS_IOA_7   USB0:DATA2
set_hps_io HPS_IOA_8   USB0:DATA3
set_hps_io HPS_IOA_9   USB0:DATA4
set_hps_io HPS_IOA_10  USB0:DATA5
set_hps_io HPS_IOA_11  USB0:DATA6
set_hps_io HPS_IOA_12  USB0:DATA7
set_hps_io HPS_IOA_13  EMAC0:TX_CLK
set_hps_io HPS_IOA_14  EMAC0:TX_CTL
set_hps_io HPS_IOA_15  EMAC0:RX_CLK
set_hps_io HPS_IOA_16  EMAC0:RX_CTL
set_hps_io HPS_IOA_17  EMAC0:TXD0
set_hps_io HPS_IOA_18  EMAC0:TXD1
set_hps_io HPS_IOA_19  EMAC0:RXD0
set_hps_io HPS_IOA_20  EMAC0:RXD1
set_hps_io HPS_IOA_21  EMAC0:TXD2
set_hps_io HPS_IOA_22  EMAC0:TXD3
set_hps_io HPS_IOA_23  EMAC0:RXD2
set_hps_io HPS_IOA_24  EMAC0:RXD3

# HPS I/O bank B

set_hps_io HPS_IOB_1   SDMMC:DATA0
set_hps_io HPS_IOB_2   SDMMC:DATA1
set_hps_io HPS_IOB_3   SDMMC:CCLK
set_hps_io HPS_IOB_4   HCLK:HPS_OSC_CLK
set_hps_io HPS_IOB_5   NONE
set_hps_io HPS_IOB_6   SDMMC:DATA2
set_hps_io HPS_IOB_7   SDMMC:DATA3
set_hps_io HPS_IOB_8   SDMMC:CMD
set_hps_io HPS_IOB_9   NONE
set_hps_io HPS_IOB_10  NONE
set_hps_io HPS_IOB_11  NONE
set_hps_io HPS_IOB_12  NONE
set_hps_io HPS_IOB_13  I2C1:SDA
set_hps_io HPS_IOB_14  I2C1:SCL
set_hps_io HPS_IOB_15  UART1:TX
set_hps_io HPS_IOB_16  UART1:RX
set_hps_io HPS_IOB_17  GPIO1:IO16
set_hps_io HPS_IOB_18  GPIO1:IO17
set_hps_io HPS_IOB_19  NONE
set_hps_io HPS_IOB_20  NONE
set_hps_io HPS_IOB_21  NONE
set_hps_io HPS_IOB_22  NONE
set_hps_io HPS_IOB_23  MDIO0:MDIO
set_hps_io HPS_IOB_24  MDIO0:MDC

# system clock

add_instance sys_clk clock_source
set_instance_parameter_value sys_clk {clockFrequency} {50000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset

# reset release, holds the fabric in reset until the device is initialized

add_instance sys_rstgate altera_s10_user_rst_clkgate
set_instance_parameter_value sys_rstgate {outputType} {Conduit Interface}
add_interface rst_ninit_done conduit end
set_interface_property rst_ninit_done EXPORT_OF sys_rstgate.ninit_done

# hps
add_instance sys_hps intel_agilex_5_soc
set_instance_parameter_value sys_hps ATB_Enable {0}
set_instance_parameter_value sys_hps CM_Mode {N/A}
set_instance_parameter_value sys_hps CM_PinMuxing {Unused}
set_instance_parameter_value sys_hps CTI_Enable {0}
set_instance_parameter_value sys_hps DMA_Enable {No No No No No No No No}
set_instance_parameter_value sys_hps Debug_APB_Enable {0}
set_instance_parameter_value sys_hps EMAC0_Mode {RGMII_with_MDIO}
set_instance_parameter_value sys_hps EMAC0_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC0_PTP {0}
set_instance_parameter_value sys_hps EMAC0_PinMuxing {IO}
set_instance_parameter_value sys_hps EMAC1_Mode {N/A}
set_instance_parameter_value sys_hps EMAC1_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC1_PTP {0}
set_instance_parameter_value sys_hps EMAC1_PinMuxing {Unused}
set_instance_parameter_value sys_hps EMAC2_Mode {N/A}
set_instance_parameter_value sys_hps EMAC2_PPS_Enable {false}
set_instance_parameter_value sys_hps EMAC2_PTP {0}
set_instance_parameter_value sys_hps EMAC2_PinMuxing {Unused}
set_instance_parameter_value sys_hps EMIF_AXI_Enable {1}
set_instance_parameter_value sys_hps EMIF_Topology {1}
set_instance_parameter_value sys_hps F2H_IRQ_Enable {0}
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
set_instance_parameter_value sys_hps I2C1_Mode {default}
set_instance_parameter_value sys_hps I2C1_PinMuxing {IO}
set_instance_parameter_value sys_hps I2CEMAC0_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC0_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2CEMAC1_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC1_PinMuxing {Unused}
set_instance_parameter_value sys_hps I2CEMAC2_Mode {N/A}
set_instance_parameter_value sys_hps I2CEMAC2_PinMuxing {Unused}
set_instance_parameter_value sys_hps I3C0_Mode {N/A}
set_instance_parameter_value sys_hps I3C0_PinMuxing {Unused}
set_instance_parameter_value sys_hps I3C1_Mode {N/A}
set_instance_parameter_value sys_hps I3C1_PinMuxing {IO}
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
set_instance_parameter_value sys_hps NOC_clk_phy_div {1}
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
set_instance_parameter_value sys_hps Periph_clk_emac0_sel {250}
set_instance_parameter_value sys_hps Periph_clk_emac1_sel {250}
set_instance_parameter_value sys_hps Periph_clk_emac2_sel {250}
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
set_instance_parameter_value sys_hps SDMMC_Mode {4-bit}
set_instance_parameter_value sys_hps SDMMC_PinMuxing {IO}
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
set_instance_parameter_value sys_hps UART0_Mode {N/A}
set_instance_parameter_value sys_hps UART0_PinMuxing {Unused}
set_instance_parameter_value sys_hps UART1_Mode {No_flow_control}
set_instance_parameter_value sys_hps UART1_PinMuxing {IO}
set_instance_parameter_value sys_hps USB0_Mode {default}
set_instance_parameter_value sys_hps USB0_PinMuxing {IO}
set_instance_parameter_value sys_hps USB1_Mode {N/A}
set_instance_parameter_value sys_hps USB1_PinMuxing {Unused}
set_instance_parameter_value sys_hps User0_clk_enable {1}
set_instance_parameter_value sys_hps User0_clk_freq {250}
set_instance_parameter_value sys_hps User0_clk_src_select {7}
set_instance_parameter_value sys_hps User1_clk_enable {0}
set_instance_parameter_value sys_hps User1_clk_freq {500.0}
set_instance_parameter_value sys_hps User1_clk_src_select {7}
set_instance_parameter_value sys_hps eosc1_clk_mhz {25.0}
set_instance_parameter_value sys_hps f2s_SMMU {0}
set_instance_parameter_value sys_hps f2s_address_width {32}
set_instance_parameter_value sys_hps f2s_data_width {Unused}
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

add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io

# hps emif

# LPDDR4 attached to the HPS (the board's LPDDR4A device). Single channel, x32:
# this matches LPDDR4A_DQ[31:0], LPDDR4A_CA[5:0], LPDDR4A_DQS[3:0] and
# LPDDR4A_DM[3:0] in system_top.v. MEM_NUM_CHANNELS and the DQ width are derived
# from EMIF_TOPOLOGY by the HPS EMIF wrapper, so they are not set here.
# The component is created from the stock emif_io96b_hps IP and written to
# ip/emif_hps.ip in the project directory.

add_component emif_hps ip/emif_hps.ip emif_io96b_hps emif_io96b_hps_inst
load_component emif_hps

# Top level: LPDDR4, 1 channel x32, HPS owned, own reference clock and RZQ.

set_component_parameter_value EMIF_PROTOCOL {LPDDR4}
set_component_parameter_value EMIF_TOPOLOGY {1x32}
set_component_parameter_value EMIF_REF_CLK_SHARING {0}
set_component_parameter_value EMIF_SHOW_INTERNAL_SETTINGS {0}

set_component_sub_module_parameter_value emif_0_lpddr4 IS_HPS {1}

# Memory clock. 1333.333 MHz (LPDDR4-2667) is the fastest rate this device
# supports: for the Agilex 5 'sm' family a speed grade of 4 maps to speed grade
# bucket 1, which rules out 1600 MHz / LPDDR4-3200.

set_component_sub_module_parameter_value emif_0_lpddr4 MEM_OPERATING_FREQ_MHZ_AUTOSET_EN {0}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_OPERATING_FREQ_MHZ {1333.333}

# Reference clock. The board supplies a fixed 166.6666 MHz on LPDDR4A_REFCLK_p
# (see system_constr.sdc); autoset would ask for 173.913 MHz. 1333.333/166.6666
# is an exact 8:1 ratio. Values this far off the shortlist need the advanced
# selection.

set_component_sub_module_parameter_value emif_0_lpddr4 PHY_REFCLK_FREQ_MHZ_AUTOSET_EN {0}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_REFCLK_ADVANCED_SELECT_EN {1}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_REFCLK_FREQ_MHZ {166.6666}

# Memory device: 16 Gb die, one chip select, per-bank refresh. The ns / clock
# cycle timings (CL, CWL, tRCD, tRFC, ...) follow from the frequency and die
# density, so they are left at the IP's derived values.

set_component_sub_module_parameter_value emif_0_lpddr4 MEM_DIE_DENSITY_GBITS {16}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_CHANNEL_CS_WIDTH {1}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_PER_BANK_REF_EN {1}

# Memory mode registers: DQ output drive (RON 40 ohm) and CA on-die termination.

set_component_sub_module_parameter_value emif_0_lpddr4 MEM_ODT_DQ_X_RON {6}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_ODT_DQ_X_IDLE {off}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_ODT_CA_X_CA_ENABLE {1}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_ODT_CA_X_CK_ENABLE {1}
set_component_sub_module_parameter_value emif_0_lpddr4 MEM_ODT_CA_X_CS_ENABLE {1}

# FPGA I/O: LVSTL / differential LVSTL signalling, 40 ohm calibrated output
# drive on DQ, CA, CK and CS, 50 ohm calibrated input termination on DQ.

set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_DQ_IO_STD_TYPE {LVSTL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_DQS_IO_STD_TYPE {DF_LVSTL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_CK_OUTPUT_IO_STD_TYPE {DF_LVSTL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_AC_OUTPUT_IO_STD_TYPE {LVSTL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_CS_OUTPUT_IO_STD_TYPE {LVSTL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_R_S_DQ_OUTPUT_OHM {SERIES_40_OHM_CAL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_R_S_AC_OUTPUT_OHM {SERIES_40_OHM_CAL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_R_S_CK_OUTPUT_OHM {SERIES_40_OHM_CAL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_R_S_CS_OUTPUT_OHM {SERIES_40_OHM_CAL}
set_component_sub_module_parameter_value emif_0_lpddr4 PHY_TERM_X_R_T_DQ_INPUT_OHM {RT_50_OHM_CAL}

# Controller: sequential address profile, scrambler on, no ECC, no DM or DBI.

set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_PERFORMANCE_PROFILE {SEQ}
set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_SCRAMBLER_EN {1}
set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_DM_EN {0}
set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_RD_DBI_EN {0}
set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_WR_DBI_EN {0}
set_component_sub_module_parameter_value emif_0_lpddr4 CTRL_ECC_INLINE_EN {0}

# Board DQ wiring. The LPDDR4A DQ pins are not wired in lane order; this is the
# swizzle from the Terasic DE25-Nano GHRD (space separated, which is the form
# that round-trips intact).

set_component_sub_module_parameter_value emif_0_lpddr4 PHY_SWIZZLE_MAP {PIN_SWIZZLE_CH0_DQS0=5 4 0 7 1 6 2 3;PIN_SWIZZLE_CH0_DQS1=15 8 14 9 12 13 11 10;PIN_SWIZZLE_CH0_DQS2=18 22 19 20 21 23 16 17;PIN_SWIZZLE_CH0_DQS3=27 29 28 26 24 25 31 30;}

save_component

add_interface emif_hps_ref_clk     clock   sink
add_interface emif_hps_mem         conduit end
add_interface emif_hps_mem_ck      conduit end
add_interface emif_hps_mem_reset_n conduit end
add_interface emif_hps_oct         conduit end

set_interface_property emif_hps_ref_clk     EXPORT_OF emif_hps.ref_clk
set_interface_property emif_hps_mem         EXPORT_OF emif_hps.mem_0
set_interface_property emif_hps_mem_ck      EXPORT_OF emif_hps.mem_ck_0
set_interface_property emif_hps_mem_reset_n EXPORT_OF emif_hps.mem_reset_n
set_interface_property emif_hps_oct         EXPORT_OF emif_hps.oct_0

add_connection emif_hps.io96b0_to_hps sys_hps.io96b0_to_hps

# Everything below is disabled for the UART + LPDDR4 only bring-up.
# Change to "if {1}" to bring back sysid, gpio, spi, f2sdram and the cpu
# interconnect/interrupts.
if {0} {
# dma

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk {clockFrequency} {250000000.0}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {true}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clk sys_dma_clk.clk_in

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

# ltc2308 adc spi (single slave, 16 bit frames covers the 12 bit conversion)

add_instance ltc2308_spi altera_avalon_spi
set_instance_parameter_value ltc2308_spi {clockPhase} {0}
set_instance_parameter_value ltc2308_spi {clockPolarity} {0}
set_instance_parameter_value ltc2308_spi {dataWidth} {16}
set_instance_parameter_value ltc2308_spi {masterSPI} {1}
set_instance_parameter_value ltc2308_spi {numberOfSlaves} {1}
set_instance_parameter_value ltc2308_spi {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset ltc2308_spi.reset
add_connection sys_clk.clk ltc2308_spi.clk
add_interface ltc2308_spi conduit end
set_interface_property ltc2308_spi EXPORT_OF ltc2308_spi.external

# hps warm reset handshake

add_interface h2f_warm_reset conduit end
set_interface_property h2f_warm_reset EXPORT_OF sys_hps.h2f_warm_reset_handshake

# f2sdram bridge
# The bridge can only be enabled if it is used, so it is set up here (default
# 128 bits) and ad_dma_interconnect only connects to it, resizing if needed.
# This adapter is needed, otherwise the bridge doesn't work...

set_instance_parameter_value sys_hps f2sdram_data_width {Unused}
add_connection sys_dma_clk.clk sys_hps.f2sdram_axi_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2sdram_axi_reset

add_instance f2sdram_adapter f2sdram_adapter
set_instance_parameter_value f2sdram_adapter {DATA_WIDTH} {128}
set_instance_parameter_value f2sdram_adapter {ADDRESS_WIDTH} {32}

add_connection sys_dma_clk.clk f2sdram_adapter.clock
add_connection sys_dma_clk.clk_reset f2sdram_adapter.reset
add_connection f2sdram_adapter.axi4_man sys_hps.f2sdram

# The f2sdram read data must reach a top level pin or the read path is
# optimised away and synthesis fails with Error (129015) on the MPFE's
# dangling F2SDRAM_RDATA. A fabric-only consumer is not enough, even with
# (* preserve *), and masking it into another output with a constant gets
# folded away. system_top.v has to drive a pin from this conduit.

add_interface f2sdram_rdata_observe conduit end
set_interface_property f2sdram_rdata_observe EXPORT_OF f2sdram_adapter.rdata_observe

# cpu/hps handling

proc ad_dma_interconnect {m_port {m_addr 0x00000000} {data_width 128}} {
    if {$data_width > 256} {
      send_message error "Agilex 5 supports interconnects up to 256 bits"
    }
    if {$data_width != 128} {
      set_instance_parameter_value sys_hps f2sdram_data_width $data_width
      set_instance_parameter_value f2sdram_adapter {DATA_WIDTH} $data_width
    }
    add_connection ${m_port} f2sdram_adapter.axi4_sub
    set_connection_parameter_value ${m_port}/f2sdram_adapter.axi4_sub baseAddress ${m_addr}
}

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_hps.fpga2hps_interrupt_irq0 ${m_port}
  set_connection_parameter_value sys_hps.fpga2hps_interrupt_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_hps.lwhps2fpga ${m_port}
  set_connection_parameter_value sys_hps.lwhps2fpga/${m_port} baseAddress ${m_base}
}

# cpu interconnect

ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port
ad_cpu_interconnect 0x00000060 ltc2308_spi.spi_control_port
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi

# interrupts

ad_cpu_interrupt 0 sys_gpio_in.irq
ad_cpu_interrupt 1 sys_gpio_bd.irq
ad_cpu_interrupt 2 sys_spi.irq
ad_cpu_interrupt 3 ltc2308_spi.irq
}
