
# ADC digital interface (JESD204B)

set_property  -dict {PACKAGE_PIN  G8 } [get_ports rx_ref_clk_p]                              ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G7 } [get_ports rx_ref_clk_n]                              ; ## D05  FMC_HPC_GBTCLK0_M2C_N

set_property  -dict {PACKAGE_PIN  T8   IOSTANDARD LVDS} [get_ports rx_device_clk_p]          ; ## G02  FMC_HPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  R8   IOSTANDARD LVDS} [get_ports rx_device_clk_n]          ; ## G03  FMC_HPC_CLK1_M2C_N

set_property  -dict {PACKAGE_PIN  H2 } [get_ports rx_data_p[0]]                              ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1 } [get_ports rx_data_n[0]]                              ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  J4 } [get_ports rx_data_p[1]]                              ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3 } [get_ports rx_data_n[1]]                              ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2 } [get_ports rx_data_p[2]]                              ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1 } [get_ports rx_data_n[2]]                              ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  K2 } [get_ports rx_data_p[3]]                              ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1 } [get_ports rx_data_n[3]]                              ; ## A11  FMC_HPC_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  U5   IOSTANDARD LVDS} [get_ports rx_sync0_p]               ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  U4   IOSTANDARD LVDS} [get_ports rx_sync0_n]               ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVDS} [get_ports rx_sync1_p]               ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVDS} [get_ports rx_sync1_n]               ; ## H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AB4  IOSTANDARD LVDS} [get_ports rx_sysref_p]              ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4  IOSTANDARD LVDS} [get_ports rx_sysref_n]              ; ## D09  FMC_HPC_LA01_CC_N

# ADC control lines

set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVCMOS18} [get_ports adc_pdwn]              ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18} [get_ports adc_fda]               ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVCMOS18} [get_ports adc_fdb]               ; ## G10  FMC_HPC_LA03_N

# SPI interfaces

set_property  -dict {PACKAGE_PIN  AC2  IOSTANDARD LVCMOS18} [get_ports spi_adc_csn]          ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  V12  IOSTANDARD LVCMOS18} [get_ports spi_adc_clk]          ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  V2   IOSTANDARD LVCMOS18} [get_ports spi_adc_miso]         ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  V11  IOSTANDARD LVCMOS18} [get_ports spi_adc_mosi]         ; ## G37  FMC_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  Y10  IOSTANDARD LVCMOS18} [get_ports spi_vco_csn]          ; ## H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB6  IOSTANDARD LVCMOS18} [get_ports spi_vco_clk]          ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AB5  IOSTANDARD LVCMOS18} [get_ports spi_vco_mosi]         ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  P12   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_csn]      ; ## H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  L13   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_clk]      ; ## H22  FMC_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  N12   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_miso]     ; ## H26  FMC_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  K13   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_mosi]     ; ## H23  FMC_HPC_LA19_N

# Laser driver and GPIOs

set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVDS}  [get_ports laser_driver_p]          ; ## C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVDS}  [get_ports laser_driver_n]          ; ## C23  FMC_HPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  M10   IOSTANDARD LVCMOS18} [get_ports laser_driver_en_n]   ; ## C26  FMC_HPC_LA27_P
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD LVCMOS18} [get_ports laser_driver_otw_n]  ; ## G33  FMC_HPC_LA31_P

set_property  -dict {PACKAGE_PIN  L10   IOSTANDARD LVCMOS18} [get_ports laser_gpio[0]]       ; ## C27  FMC_HPC_LA27_N
set_property  -dict {PACKAGE_PIN  P11   IOSTANDARD LVCMOS18} [get_ports laser_gpio[1]]       ; ## D20  FMC_HPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  N11   IOSTANDARD LVCMOS18} [get_ports laser_gpio[2]]       ; ## D21  FMC_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18} [get_ports laser_gpio[3]]       ; ## D23  FMC_HPC_LA23_P
set_property  -dict {PACKAGE_PIN  K16   IOSTANDARD LVCMOS18} [get_ports laser_gpio[4]]       ; ## D24  FMC_HPC_LA23_N
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS18} [get_ports laser_gpio[5]]       ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18} [get_ports laser_gpio[6]]       ; ## D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18} [get_ports laser_gpio[7]]       ; ## G24  FMC_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  M14   IOSTANDARD LVCMOS18} [get_ports laser_gpio[8]]       ; ## G25  FMC_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  M11   IOSTANDARD LVCMOS18} [get_ports laser_gpio[9]]       ; ## G27  FMC_HPC_LA25_P
set_property  -dict {PACKAGE_PIN  L11   IOSTANDARD LVCMOS18} [get_ports laser_gpio[10]]      ; ## G28  FMC_HPC_LA25_N
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS18} [get_ports laser_gpio[11]]      ; ## G30  FMC_HPC_LA29_P
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD LVCMOS18} [get_ports laser_gpio[12]]      ; ## G31  FMC_HPC_LA29_N
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS18} [get_ports laser_gpio[13]]      ; ## G34  FMC_HPC_LA31_N

# TIA channel selection

set_property  -dict {PACKAGE_PIN  AC1  IOSTANDARD LVCMOS18} [get_ports tia_chsel[0]]         ; ## afe_sel0_1 C11  FMC_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  W5   IOSTANDARD LVCMOS18} [get_ports tia_chsel[1]]         ; ## afe_sel1_1 C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  W4   IOSTANDARD LVCMOS18} [get_ports tia_chsel[2]]         ; ## afe_sel0_2 C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  AC7  IOSTANDARD LVCMOS18} [get_ports tia_chsel[3]]         ; ## afe_sel1_2 C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AC6  IOSTANDARD LVCMOS18} [get_ports tia_chsel[4]]         ; ## afe_sel0_3 C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVCMOS18} [get_ports tia_chsel[5]]         ; ## afe_sel1_3 D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVCMOS18} [get_ports tia_chsel[6]]         ; ## afe_sel0_4 D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  W2   IOSTANDARD LVCMOS18} [get_ports tia_chsel[7]]         ; ## afe_sel1_4 D14  FMC_HPC_LA09_P

# AFE DAC I2C and control

set_property  -dict {PACKAGE_PIN  W1   IOSTANDARD LVCMOS18} [get_ports afe_dac_sda]          ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AB8  IOSTANDARD LVCMOS18} [get_ports afe_dac_scl]          ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AC8  IOSTANDARD LVCMOS18} [get_ports afe_dac_clr_n]        ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  Y4   IOSTANDARD LVCMOS18} [get_ports afe_dac_load]         ; ## G06  FMC_HPC_LA00_CC_P

# AFE ADC SPI and control

set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVCMOS18} [get_ports afe_adc_sclk]          ; ## G07  FMC_HPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  V4  IOSTANDARD LVCMOS18} [get_ports afe_adc_scn]           ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  V3  IOSTANDARD LVCMOS18} [get_ports afe_adc_convst]        ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  W7  IOSTANDARD LVCMOS18} [get_ports afe_adc_sdi]           ; ## G15  FMC_HPC_LA12_P

# clocks

create_clock -period 4.000 -name rx_device_clk [get_ports rx_device_clk_p]
create_clock -period 4.000 -name rx_ref_clk [get_ports rx_ref_clk_p]

# SYSREF is edge-aligned rising edge source synchronous input

set_input_delay -clock [get_clocks rx_device_clk] [get_property PERIOD [get_clocks rx_device_clk]] \
                [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]

