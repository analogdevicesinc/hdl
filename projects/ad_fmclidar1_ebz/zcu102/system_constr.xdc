
#
## LIDAR-A
#

# ADC digital interface (JESD204B)

set_property  -dict {PACKAGE_PIN  G8 } [get_ports rx_ref_clk_a_p]                              ; ## D04  FMC0_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G7 } [get_ports rx_ref_clk_a_n]                              ; ## D05  FMC0_HPC_GBTCLK0_M2C_N

set_property  -dict {PACKAGE_PIN  T8   IOSTANDARD LVDS} [get_ports rx_device_clk_a_p]          ; ## D08  FMC0_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  R8   IOSTANDARD LVDS} [get_ports rx_device_clk_a_n]          ; ## D09  FMC0_HPC_LA01_CC_N

set_property  -dict {PACKAGE_PIN  H2 } [get_ports rx_data_a_p[0]]                              ; ## C06  FMC0_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1 } [get_ports rx_data_a_n[0]]                              ; ## C07  FMC0_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  J4 } [get_ports rx_data_a_p[1]]                              ; ## A02  FMC0_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3 } [get_ports rx_data_a_n[1]]                              ; ## A03  FMC0_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2 } [get_ports rx_data_a_p[2]]                              ; ## A06  FMC0_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1 } [get_ports rx_data_a_n[2]]                              ; ## A07  FMC0_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  K2 } [get_ports rx_data_a_p[3]]                              ; ## A10  FMC0_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1 } [get_ports rx_data_a_n[3]]                              ; ## A11  FMC0_HPC_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  U5   IOSTANDARD LVDS} [get_ports rx_sync0_a_p]               ; ## H13  FMC0_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  U4   IOSTANDARD LVDS} [get_ports rx_sync0_a_n]               ; ## H14  FMC0_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVDS} [get_ports rx_sync1_a_p]               ; ## H10  FMC0_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVDS} [get_ports rx_sync1_a_n]               ; ## H11  FMC0_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AB4  IOSTANDARD LVDS} [get_ports rx_sysref_a_p]              ; ## G02  FMC0_HPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AC4  IOSTANDARD LVDS} [get_ports rx_sysref_a_n]              ; ## G03  FMC0_HPC_CLK1_M2C_N

# ADC control lines

set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVCMOS18} [get_ports adc_pdwn_a]              ; ## H08  FMC0_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18} [get_ports adc_fda_a]               ; ## G09  FMC0_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVCMOS18} [get_ports adc_fdb_a]               ; ## G10  FMC0_HPC_LA03_N

# SPI interfaces

set_property  -dict {PACKAGE_PIN  AC2  IOSTANDARD LVCMOS18} [get_ports spi_adc_csn_a]          ; ## C10  FMC0_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  V12  IOSTANDARD LVCMOS18} [get_ports spi_adc_clk_a]          ; ## G36  FMC0_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  V2   IOSTANDARD LVCMOS18} [get_ports spi_adc_miso_a]         ; ## H07  FMC0_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  V11  IOSTANDARD LVCMOS18} [get_ports spi_adc_mosi_a]         ; ## G37  FMC0_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  Y10  IOSTANDARD LVCMOS18} [get_ports spi_vco_csn_a]          ; ## H19  FMC0_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB6  IOSTANDARD LVCMOS18} [get_ports spi_vco_clk_a]          ; ## H16  FMC0_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AB5  IOSTANDARD LVCMOS18} [get_ports spi_vco_mosi_a]         ; ## H17  FMC0_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  P12   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_csn_a]      ; ## H25  FMC0_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  L13   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_clk_a]      ; ## H22  FMC0_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  N12   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_miso_a]     ; ## H26  FMC0_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  K13   IOSTANDARD LVCMOS18} [get_ports spi_clkgen_mosi_a]     ; ## H23  FMC0_HPC_LA19_N

# Laser driver and GPIOs

set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVDS}  [get_ports laser_driver_a_p]          ; ## C22  FMC0_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVDS}  [get_ports laser_driver_a_n]          ; ## C23  FMC0_HPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  M10   IOSTANDARD LVCMOS18} [get_ports laser_driver_en_a_n]   ; ## C26  FMC0_HPC_LA27_P
set_property  -dict {PACKAGE_PIN  L10   IOSTANDARD LVCMOS18} [get_ports laser_driver_otw_a_n]  ; ## C27  FMC0_HPC_LA27_N

set_property  -dict {PACKAGE_PIN  P11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[0]]       ; ## D20  FMC0_HPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  N11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[1]]       ; ## D21  FMC0_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[2]]       ; ## D23  FMC0_HPC_LA23_P
set_property  -dict {PACKAGE_PIN  K16   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[3]]       ; ## D24  FMC0_HPC_LA23_N
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[4]]       ; ## D26  FMC0_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[5]]       ; ## D27  FMC0_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[6]]       ; ## G24  FMC0_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  M14   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[7]]       ; ## G25  FMC0_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  M11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[8]]       ; ## G27  FMC0_HPC_LA25_P
set_property  -dict {PACKAGE_PIN  L11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[9]]       ; ## G28  FMC0_HPC_LA25_N
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[10]]      ; ## G30  FMC0_HPC_LA29_P
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[11]]      ; ## G31  FMC0_HPC_LA29_N
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[12]]      ; ## G33  FMC0_HPC_LA31_P
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS18} [get_ports laser_gpio_a[13]]      ; ## G34  FMC0_HPC_LA31_N

# TIA channel selection

set_property  -dict {PACKAGE_PIN  AC1  IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[0]]         ; ## afe_sel0_1 C11  FMC0_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  W5   IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[1]]         ; ## afe_sel1_1 C14  FMC0_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  W4   IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[2]]         ; ## afe_sel0_2 C15  FMC0_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  AC7  IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[3]]         ; ## afe_sel1_2 C18  FMC0_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AC6  IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[4]]         ; ## afe_sel0_3 C19  FMC0_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[5]]         ; ## afe_sel1_3 D11  FMC0_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[6]]         ; ## afe_sel0_4 D12  FMC0_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  W2   IOSTANDARD LVCMOS18} [get_ports tia_chsel_a[7]]         ; ## afe_sel1_4 D14  FMC0_HPC_LA09_P

# AFE DAC I2C and control

set_property  -dict {PACKAGE_PIN  W1   IOSTANDARD LVCMOS18} [get_ports afe_dac_sda_a]          ; ## D15  FMC0_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AB8  IOSTANDARD LVCMOS18} [get_ports afe_dac_scl_a]          ; ## D17  FMC0_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AC8  IOSTANDARD LVCMOS18} [get_ports afe_dac_clr_n_a]        ; ## D18  FMC0_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  Y4   IOSTANDARD LVCMOS18} [get_ports afe_dac_load_a]         ; ## G06  FMC0_HPC_LA00_CC_P

# AFE ADC SPI and control

set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVCMOS18} [get_ports afe_adc_sclk_a]          ; ## G07  FMC0_HPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  V4  IOSTANDARD LVCMOS18} [get_ports afe_adc_scn_a]           ; ## G12  FMC0_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  V3  IOSTANDARD LVCMOS18} [get_ports afe_adc_convst_a]        ; ## G13  FMC0_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  W7  IOSTANDARD LVCMOS18} [get_ports afe_adc_sdi_a]           ; ## G15  FMC0_HPC_LA12_P

#
## LIDAR-B
#

# ADC digital interface (JESD204B)

set_property  -dict {PACKAGE_PIN  G27 } [get_ports rx_ref_clk_b_p]                              ; ## D04  FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G28 } [get_ports rx_ref_clk_b_n]                              ; ## D05  FMC1_HPC_GBTCLK0_M2C_N

set_property  -dict {PACKAGE_PIN  P10  IOSTANDARD LVDS} [get_ports rx_device_clk_b_p]          ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  P9   IOSTANDARD LVDS} [get_ports rx_device_clk_b_n]          ; ## D09  FMC1_HPC_LA01_CC_N

set_property  -dict {PACKAGE_PIN  E31 } [get_ports rx_data_b_p[0]]                              ; ## C06  FMC1_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E32 } [get_ports rx_data_b_n[0]]                              ; ## C07  FMC1_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  D33 } [get_ports rx_data_b_p[1]]                              ; ## A02  FMC1_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D34 } [get_ports rx_data_b_n[1]]                              ; ## A03  FMC1_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  C31 } [get_ports rx_data_b_p[2]]                              ; ## A06  FMC1_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  C32 } [get_ports rx_data_b_n[2]]                              ; ## A07  FMC1_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  B33 } [get_ports rx_data_b_p[3]]                              ; ## A10  FMC1_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  B34 } [get_ports rx_data_b_n[3]]                              ; ## A11  FMC1_HPC_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  AD4  IOSTANDARD LVDS} [get_ports rx_sync0_b_p]               ; ## H13  FMC1_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AE4  IOSTANDARD LVDS} [get_ports rx_sync0_b_n]               ; ## H14  FMC1_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AF2  IOSTANDARD LVDS} [get_ports rx_sync1_b_p]               ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AF1  IOSTANDARD LVDS} [get_ports rx_sync1_b_n]               ; ## H11  FMC1_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AJ6  IOSTANDARD LVDS} [get_ports rx_sysref_b_p]              ; ## G02  FMC1_HPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ5  IOSTANDARD LVDS} [get_ports rx_sysref_b_n]              ; ## G03  FMC1_HPC_CLK1_M2C_N

# ADC control lines

set_property  -dict {PACKAGE_PIN  AD1  IOSTANDARD LVCMOS18} [get_ports adc_pdwn_b]              ; ## H08  FMC1_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AH1  IOSTANDARD LVCMOS18} [get_ports adc_fda_b]               ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1  IOSTANDARD LVCMOS18} [get_ports adc_fdb_b]               ; ## G10  FMC1_HPC_LA03_N

# SPI interfaces

set_property  -dict {PACKAGE_PIN  AH2  IOSTANDARD LVCMOS18} [get_ports spi_adc_csn_b]          ; ## C10  FMC1_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AE12 IOSTANDARD LVCMOS18} [get_ports spi_adc_clk_b]          ; ## G36  FMC1_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  AD2  IOSTANDARD LVCMOS18} [get_ports spi_adc_miso_b]         ; ## H07  FMC1_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  Y5   IOSTANDARD LVCMOS18} [get_ports spi_adc_mosi_b]         ; ## G37  FMC1_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  AD10 IOSTANDARD LVCMOS18} [get_ports spi_vco_csn_b]          ; ## H19  FMC1_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  AE8  IOSTANDARD LVCMOS18} [get_ports spi_vco_clk_b]          ; ## H16  FMC1_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AF8  IOSTANDARD LVCMOS18} [get_ports spi_vco_mosi_b]         ; ## H17  FMC1_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  AC12 IOSTANDARD LVCMOS18} [get_ports spi_clkgen_csn_b]       ; ## H25  FMC1_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  AA11 IOSTANDARD LVCMOS18} [get_ports spi_clkgen_clk_b]       ; ## H22  FMC1_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  AC11 IOSTANDARD LVCMOS18} [get_ports spi_clkgen_miso_b]      ; ## H26  FMC1_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  AA10 IOSTANDARD LVCMOS18} [get_ports spi_clkgen_mosi_b]      ; ## H23  FMC1_HPC_LA19_N

# Laser driver and GPIOs

set_property  -dict {PACKAGE_PIN  Y8   IOSTANDARD LVDS}  [get_ports laser_driver_b_p]          ; ## C22  FMC1_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  Y7   IOSTANDARD LVDS}  [get_ports laser_driver_b_n]          ; ## C23  FMC1_HPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS18} [get_ports laser_driver_en_b_n]   ; ## C26  FMC1_HPC_LA27_P
set_property  -dict {PACKAGE_PIN  T10   IOSTANDARD LVCMOS18} [get_ports laser_driver_otw_b_n]  ; ## C27  FMC1_HPC_LA27_N

## four line is disconnected, to have ports for ADC SPI and there
## are lines which are not connected to the FPGA
set_property  -dict {PACKAGE_PIN  AA5    IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[0]]      ; ## D21  FMC1_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  AF12   IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[1]]      ; ## D24  FMC1_HPC_LA23_N
set_property  -dict {PACKAGE_PIN  T12    IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[2]]      ; ## D26  FMC1_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  R12    IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[3]]      ; ## D27  FMC1_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  AF11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[4]]      ; ## G24  FMC1_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  AG11   IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[5]]      ; ## G25  FMC1_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  AE10   IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[6]]      ; ## G27  FMC1_HPC_LA25_P
set_property  -dict {PACKAGE_PIN  AF10   IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[7]]      ; ## G28  FMC1_HPC_LA25_N
set_property  -dict {PACKAGE_PIN  W12    IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[8]]      ; ## G30  FMC1_HPC_LA29_P
set_property  -dict {PACKAGE_PIN  W11    IOSTANDARD LVCMOS18} [get_ports laser_gpio_b[9]]      ; ## G31  FMC1_HPC_LA29_N

# TIA channel selection

set_property  -dict {PACKAGE_PIN  AJ2  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[0]]         ; ## afe_sel0_1 C11  FMC1_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  AH4  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[1]]         ; ## afe_sel1_1 C14  FMC1_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AJ4  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[2]]         ; ## afe_sel0_2 C15  FMC1_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  AH7  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[3]]         ; ## afe_sel1_2 C18  FMC1_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AH6  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[4]]         ; ## afe_sel0_3 C19  FMC1_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AG3  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[5]]         ; ## afe_sel1_3 D11  FMC1_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AH3  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[6]]         ; ## afe_sel0_4 D12  FMC1_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AE2  IOSTANDARD LVCMOS18} [get_ports tia_chsel_b[7]]         ; ## afe_sel1_4 D14  FMC1_HPC_LA09_P

# AFE DAC I2C and control

set_property  -dict {PACKAGE_PIN  AE1  IOSTANDARD LVCMOS18} [get_ports afe_dac_sda_b]          ; ## D15  FMC1_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AG8  IOSTANDARD LVCMOS18} [get_ports afe_dac_scl_b]          ; ## D17  FMC1_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AH8  IOSTANDARD LVCMOS18} [get_ports afe_dac_clr_n_b]        ; ## D18  FMC1_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AE5  IOSTANDARD LVCMOS18} [get_ports afe_dac_load_b]         ; ## G06  FMC1_HPC_LA00_CC_P

# AFE ADC SPI and control

set_property  -dict {PACKAGE_PIN  AF5  IOSTANDARD LVCMOS18} [get_ports afe_adc_sclk_b]          ; ## G07  FMC1_HPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AE3  IOSTANDARD LVCMOS18} [get_ports afe_adc_scn_b]           ; ## G12  FMC1_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AF3  IOSTANDARD LVCMOS18} [get_ports afe_adc_convst_b]        ; ## G13  FMC1_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AD7  IOSTANDARD LVCMOS18} [get_ports afe_adc_sdi_b]           ; ## G15  FMC1_HPC_LA12_P

# clocks

create_clock -period 4.000 -name rx_device_clk_a [get_ports rx_device_clk_a_p]
create_clock -period 4.000 -name rx_ref_clk_a [get_ports rx_ref_clk_a_p]
create_clock -period 4.000 -name rx_device_clk_b [get_ports rx_device_clk_b_p]
create_clock -period 4.000 -name rx_ref_clk_b [get_ports rx_ref_clk_b_p]

# SYSREF is in phase with the device clock

set_input_delay -clock [get_clocks rx_device_clk_a] -rise -max 0.200 [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks rx_device_clk_a] -rise -min -0.200 [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks rx_device_clk_b] -rise -max 0.200 [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks rx_device_clk_b] -rise -min -0.200 [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]

set_property IOBDELAY NONE [get_cells -hierarchical -regexp -filter { NAME =~ ".*sysref_r_reg"}]

