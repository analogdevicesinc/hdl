###############################################################################
# AD9083
###############################################################################

# ref clock
set_property  -dict {PACKAGE_PIN  G8}                       [get_ports ref_clk0_p]         ; ##  D04  FMC_HPC0 GBTCLK0 M2C_C_P
set_property  -dict {PACKAGE_PIN  G7}                       [get_ports ref_clk0_n]         ; ##  D05  FMC_HPC0_GBTCLK0_M2C_C_N

# device clock
set_property  -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS}      [get_ports glblclk_p]          ; ##  G06  FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS}      [get_ports glblclk_n]          ; ##  G07  FMC_HPC0_LA00_CC_N

set_property  -dict {PACKAGE_PIN  H2}                       [get_ports rx_data_p[0]]       ; ##  C06  FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1}                       [get_ports rx_data_n[0]]       ; ##  C07  FMC_HPC0_DP0_M2C_N

set_property  -dict {PACKAGE_PIN  J4}                       [get_ports rx_data_p[1]]       ; ##  A02  FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3}                       [get_ports rx_data_n[1]]       ; ##  A03  FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2}                       [get_ports rx_data_p[2]]       ; ##  A06  FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1}                       [get_ports rx_data_n[2]]       ; ##  A07  FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  K2}                       [get_ports rx_data_p[3]]       ; ##  A10  FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1}                       [get_ports rx_data_n[3]]       ; ##  A11  FMC_HPC0_DP3_M2C_N
# set_property  -dict {PACKAGE_PIN  J4}                       [get_ports rx_data_p[1]]       ; ##  A02  FMC_HPC0_DP1_M2C_P
# set_property  -dict {PACKAGE_PIN  J3}                       [get_ports rx_data_n[1]]       ; ##  A03  FMC_HPC0_DP1_M2C_N
# set_property  -dict {PACKAGE_PIN  F2}                       [get_ports rx_data_p[2]]       ; ##  A06  FMC_HPC0_DP2_M2C_P
# set_property  -dict {PACKAGE_PIN  F1}                       [get_ports rx_data_n[2]]       ; ##  A07  FMC_HPC0_DP2_M2C_N
# set_property  -dict {PACKAGE_PIN  K2}                       [get_ports rx_data_p[3]]       ; ##  A10  FMC_HPC0_DP3_M2C_P
# set_property  -dict {PACKAGE_PIN  K1}                       [get_ports rx_data_n[3]]       ; ##  A11  FMC_HPC0_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVDS}     [get_ports rx_sync_p]          ; ##  H10  FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVDS}     [get_ports rx_sync_n]          ; ##  H11  FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  V4   IOSTANDARD LVDS}     [get_ports sysrefadc_p]           ; ##  G12  FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  V3   IOSTANDARD LVDS}     [get_ports sysrefadc_n]           ; ##  G13  FMC_HPC0_LA08_N

set_property  -dict {PACKAGE_PIN  V1   IOSTANDARD LVCMOS18} [get_ports pwdn]               ; ##  H08  FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  U5   IOSTANDARD LVCMOS18} [get_ports rstb]               ; ##  H13  FMC_HPC0_LA07_P

# SPI
set_property  -dict {PACKAGE_PIN  V2   IOSTANDARD LVCMOS18} [get_ports fpga_csb]           ; ##  H07  FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  AB4  IOSTANDARD LVCMOS18} [get_ports fpga_clk]           ; ##  D08  FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4  IOSTANDARD LVCMOS18} [get_ports fpga_sdio]          ; ##  D09  FMC_HPC0_LA01_CC_N
set_property  -dict {PACKAGE_PIN  M10  IOSTANDARD LVCMOS18} [get_ports fpga_sdo]           ; ##  C26  FMC_HPC0_LA27_P

###############################################################################
# AD9173
###############################################################################

# ref clock
set_property  -dict {PACKAGE_PIN  L8}                       [get_ports br40_ext_p]         ; ##  B20  FMC_HPC0_GBTCLK1_M2C_C_P
set_property  -dict {PACKAGE_PIN  L7}                       [get_ports br40_ext_n]         ; ##  B21  FMC_HPC0_GBTCLK1_M2C_C_N

# The commented pins are not required when using modes that have 4 virtual converters

#set_property  -dict {PACKAGE_PIN  T2}                       [get_ports dac_data_p[7]]      ; ##  B04  FMC_HPC0_DP6_M2C_P       SERDESP<7>   Wrong pins my recommendation B16
#set_property  -dict {PACKAGE_PIN  T1}                       [get_ports dac_data_n[7]]      ; ##  B05  FMC_HPC0_DP6_M2C_N       SERDESN<7>                                B17

#set_property  -dict {PACKAGE_PIN  H6}                       [get_ports dac_data_p[6]]      ; ##  A22  FMC_HPC0_DP1_C2M_P       SERDESP<6>
#set_property  -dict {PACKAGE_PIN  H5}                       [get_ports dac_data_n[6]]      ; ##  A23  FMC_HPC0_DP1_C2M_N       SERDESN<6>
#set_property  -dict {PACKAGE_PIN  F6}                       [get_ports dac_data_p[5]]      ; ##  A26  FMC_HPC0_DP2_C2M_P       SERDESP<5>
#set_property  -dict {PACKAGE_PIN  F5}                       [get_ports dac_data_n[5]]      ; ##  A27  FMC_HPC0_DP2_C2M_N       SERDESN<5>
#set_property  -dict {PACKAGE_PIN  K6}                       [get_ports dac_data_p[4]]      ; ##  A30  FMC_HPC0_DP3_C2M_P       SERDESP<4>
#set_property  -dict {PACKAGE_PIN  K5}                       [get_ports dac_data_n[4]]      ; ##  A31  FMC_HPC0_DP3_C2M_N       SERDESN<4>
set_property  -dict {PACKAGE_PIN  N4}                       [get_ports dac_data_p[3]]      ; ##  B32  FMC_HPC0_DP7_C2M_P       SERDESN<3>   P/N ~ N/P swapped polarity
set_property  -dict {PACKAGE_PIN  N3}                       [get_ports dac_data_n[3]]      ; ##  B33  FMC_HPC0_DP7_C2M_N       SERDESP<3>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  M6}                       [get_ports dac_data_p[2]]      ; ##  A34  FMC_HPC0_DP4_C2M_P       SERDESN<2>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  M5}                       [get_ports dac_data_n[2]]      ; ##  A35  FMC_HPC0_DP4_C2M_N       SERDESP<2>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  R4}                       [get_ports dac_data_p[1]]      ; ##  B36  FMC_HPC0_DP6_C2M_P       SERDESN<1>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  R3}                       [get_ports dac_data_n[1]]      ; ##  B37  FMC_HPC0_DP6_C2M_N       SERDESP<1>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  P6}                       [get_ports dac_data_p[0]]      ; ##  A38  FMC_HPC0_DP5_C2M_P       SERDESN<0>   P/N ~ N/P
set_property  -dict {PACKAGE_PIN  P5}                       [get_ports dac_data_n[0]]      ; ##  A39  FMC_HPC0_DP5_C2M_N       SERDESP<0>   P/N ~ N/P

set_property  -dict {PACKAGE_PIN  V8   IOSTANDARD LVDS}     [get_ports sync0_n]            ; ##  G33  FMC_HPC0_LA31_P  #P/N swapped polarity
set_property  -dict {PACKAGE_PIN  V7   IOSTANDARD LVDS}     [get_ports sync0_p]            ; ##  G34  FMC_HPC0_LA31_N

set_property  -dict {PACKAGE_PIN  V12  IOSTANDARD LVDS}     [get_ports sync1_n]            ; ##  G36  FMC_HPC0_LA33_P  #P/N swapped polarity
set_property  -dict {PACKAGE_PIN  V11  IOSTANDARD LVDS}     [get_ports sync1_p]            ; ##  G37  FMC_HPC0_LA33_N

set_property  -dict {PACKAGE_PIN  AA7  IOSTANDARD LVDS}     [get_ports sysrefdac_p]       ; ##  H04  FMC_HPC0_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AA6  IOSTANDARD LVDS}     [get_ports sysrefdac_n]       ; ##  H05  FMC_HPC0_CLK0_M2C_N

# SPI
set_property  -dict {PACKAGE_PIN  Y10  IOSTANDARD LVCMOS18} [get_ports fmcdac_sck]         ; ##  H19  FMC_HPC0_LA15_P
set_property  -dict {PACKAGE_PIN  AB5  IOSTANDARD LVCMOS18} [get_ports fmcdac_mosi]        ; ##  H17  FMC_HPC0_LA11_N
set_property  -dict {PACKAGE_PIN  Y9   IOSTANDARD LVCMOS18} [get_ports fmcdac_miso]        ; ##  H20  FMC_HPC0_LA15_N
set_property  -dict {PACKAGE_PIN  AB6  IOSTANDARD LVCMOS18} [get_ports fmcdac_cs1]         ; ##  H16  FMC_HPC0_LA11_P

###############################################################################
# AD9528
###############################################################################

set_property  -dict {PACKAGE_PIN  U8   IOSTANDARD LVCMOS18} [get_ports fpga_adclk_refsel]  ; ##  G31  FMC_HPC0_LA29_N

###############################################################################
# GPIOs
###############################################################################

set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVCMOS18} [get_ports gpio_sw1_v1]        ; ##  D11  FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVCMOS18} [get_ports gpio_sw1_v2]        ; ##  D12  FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN  W2   IOSTANDARD LVCMOS18} [get_ports gpio_sw2]           ; ##  D14  FMC_HPC0_LA09_P
set_property  -dict {PACKAGE_PIN  W1   IOSTANDARD LVCMOS18} [get_ports gpio_sw3_v1]        ; ##  D15  FMC_HPC0_LA09_N
set_property  -dict {PACKAGE_PIN  AB8  IOSTANDARD LVCMOS18} [get_ports gpio_sw3_v2]        ; ##  D17  FMC_HPC0_LA13_P
set_property  -dict {PACKAGE_PIN  AC8  IOSTANDARD LVCMOS18} [get_ports gpio_sw4_v1]        ; ##  D18  FMC_HPC0_LA13_N
set_property  -dict {PACKAGE_PIN  P11  IOSTANDARD LVCMOS18} [get_ports gpio_sw4_v2]        ; ##  D20  FMC_HPC0_LA17_P_CC

set_property  -dict {PACKAGE_PIN  N11  IOSTANDARD LVCMOS18} [get_ports adl5960x_sync1]     ; ##  D21  FMC_HPC0_LA17_N_CC

###############################################################################
# SPIs
###############################################################################

set_property  -dict {PACKAGE_PIN  Y12  IOSTANDARD LVCMOS18} [get_ports spi_bus0_sck]       ; ##  G18  FMC_HPC0_LA16_P
set_property  -dict {PACKAGE_PIN  W7   IOSTANDARD LVCMOS18} [get_ports spi_bus0_sdi]       ; ##  G15  FMC_HPC0_LA12_P
set_property  -dict {PACKAGE_PIN  W6   IOSTANDARD LVCMOS18} [get_ports spi_bus0_sdo]       ; ##  G16  FMC_HPC0_LA12_N
set_property  -dict {PACKAGE_PIN  N13  IOSTANDARD LVCMOS18} [get_ports spi_bus0_cs_4372]   ; ##  G21  FMC_HPC0_LA20_P
set_property  -dict {PACKAGE_PIN  M13  IOSTANDARD LVCMOS18} [get_ports gpio_sw_pg]         ; ##  G22  FMC_HPC0_LA20_N

set_property  -dict {PACKAGE_PIN  M11  IOSTANDARD LVCMOS18} [get_ports spi_bus1_sck]       ; ##  G27  FMC_HPC0_LA25_P
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS18} [get_ports spi_bus1_sdi]       ; ##  G24  FMC_HPC0_LA22_P
set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS18} [get_ports spi_bus1_sdo]       ; ##  G25  FMC_HPC0_LA22_N
set_property  -dict {PACKAGE_PIN  L11  IOSTANDARD LVCMOS18} [get_ports spi_bus1_csn_dat1]  ; ##  G28  FMC_HPC0_LA25_N
set_property  -dict {PACKAGE_PIN  U9   IOSTANDARD LVCMOS18} [get_ports spi_bus1_csn_dat2]  ; ##  G30  FMC_HPC0_LA29_P

set_property  -dict {PACKAGE_PIN  L16  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_sck]  ; ##  D23  FMC_HPC0_LA23_P
set_property  -dict {PACKAGE_PIN  K16  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_sdio] ; ##  D24  FMC_HPC0_LA23_N
set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_csn1] ; ##  D26  FMC_HPC0_LA26_P
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_csn2] ; ##  D27  FMC_HPC0_LA26_N
set_property  -dict {PACKAGE_PIN  AC2  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_csn3] ; ##  C10  FMC_HPC0_LA06_P
set_property  -dict {PACKAGE_PIN  AC1  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_1_csn4] ; ##  C11  FMC_HPC0_LA06_N

set_property  -dict {PACKAGE_PIN  W5   IOSTANDARD LVCMOS18} [get_ports spiad_sdo]          ; ##  C14  FMC_HPC0_LA10_P
set_property  -dict {PACKAGE_PIN  W4   IOSTANDARD LVCMOS18} [get_ports spiad_sck]          ; ##  C15  FMC_HPC0_LA10_N
set_property  -dict {PACKAGE_PIN  AC7  IOSTANDARD LVCMOS18} [get_ports spiad_sdi]          ; ##  C18  FMC_HPC0_LA14_P
set_property  -dict {PACKAGE_PIN  AC6  IOSTANDARD LVCMOS18} [get_ports spiad_csn]          ; ##  C19  FMC_HPC0_LA14_N


set_property  -dict {PACKAGE_PIN  U4   IOSTANDARD LVCMOS18} [get_ports fpga_bus0_csb_9528] ; ##  H14  FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18} [get_ports fpga_bus0_csb_5752] ; ##  H22  FMC_HPC0_LA19_P
set_property  -dict {PACKAGE_PIN  Y2   IOSTANDARD LVCMOS18} [get_ports fpga_bus0_rstn]     ; ##  G09  FMC_HPC0_LA03_P

set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sfl]      ; ##  H23  FMC_HPC0_LA19_N
set_property  -dict {PACKAGE_PIN  P12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_csb]      ; ##  H25  FMC_HPC0_LA21_P
set_property  -dict {PACKAGE_PIN  N12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sdo]      ; ##  H26  FMC_HPC0_LA21_N
set_property  -dict {PACKAGE_PIN  L12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sdi]      ; ##  H28  FMC_HPC0_LA24_P
set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sck]      ; ##  H29  FMC_HPC0_LA24_N

set_property  -dict {PACKAGE_PIN  T7   IOSTANDARD LVCMOS18} [get_ports adcscko]            ; ##  H31  FMC_HPC0_LA28_P
set_property  -dict {PACKAGE_PIN  T6   IOSTANDARD LVCMOS18} [get_ports adcscki]            ; ##  H32  FMC_HPC0_LA28_N

set_property  -dict {PACKAGE_PIN  U11  IOSTANDARD LVCMOS18} [get_ports adcsdo0]            ; ##  H37  FMC_HPC0_LA32_P
set_property  -dict {PACKAGE_PIN  T11  IOSTANDARD LVCMOS18} [get_ports adcsdo2]            ; ##  H38  FMC_HPC0_LA32_N
set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVCMOS18} [get_ports adcsdo4]            ; ##  C22  FMC_HPC0_LA18_P_CC
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVCMOS18} [get_ports adcsdo6]            ; ##  C23  FMC_HPC0_LA18_N_CC

set_property  -dict {PACKAGE_PIN  V6   IOSTANDARD LVCMOS18} [get_ports adccnv]             ; ##  H34  FMC_HPC0_LA30_P
set_property  -dict {PACKAGE_PIN  U6   IOSTANDARD LVCMOS18} [get_ports adcbusy]            ; ##  H35  FMC_HPC0_LA30_N
set_property  -dict {PACKAGE_PIN  Y1   IOSTANDARD LVCMOS18} [get_ports adcpd]              ; ##  G10  FMC_HPC0_LA03_N

set_property  -dict {PACKAGE_PIN  L10  IOSTANDARD LVCMOS18} [get_ports gpio_mix2en]        ; ##  C27  FMC_HPC0_LA27_N

# fix xcvr location assignment
set_property LOC GTHE4_CHANNEL_X1Y10  [get_cells -hierarchical -filter {NAME =~ *util_ad9083_xcvr/inst/i_xch_0/i_gthe4_channel}]

# clocks
create_clock -period 2 -name rx_ref_clk [get_ports ref_clk0_p]
create_clock -period 8 -name rx_ref_clk2 [get_ports glblclk_p]

create_clock -period 3.2 -name tx_ref_clk [get_ports br40_ext_p]

set_input_delay -clock [get_clocks rx_ref_clk2] [get_property PERIOD [get_clocks rx_ref_clk2]] \
                [get_ports -regexp -filter { NAME =~  ".*sysrefadc.*" && DIRECTION == "IN" }]

create_generated_clock -name clk_sck0  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_bus1/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_bus1/sck_o]

create_generated_clock -name clk_sck1  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_adl5960_1/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_adl5960_1/sck_o]


# For transceiver output clocks use reference clock divided by two
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]
