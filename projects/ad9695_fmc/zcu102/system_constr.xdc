
# ad9695

set_property  -dict {PACKAGE_PIN  G8}                        [get_ports ref_clk0_p]      ; ## FMC_HPC0_GBTCLK0_M2C_C_P
set_property  -dict {PACKAGE_PIN  G7}                        [get_ports ref_clk0_n]      ; ## FMC_HPC0_GBTCLK0_M2C_C_N

set_property  -dict {PACKAGE_PIN  J4}                        [get_ports rx_data_p[3]]    ; ## FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3}                        [get_ports rx_data_n[3]]    ; ## FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2}                        [get_ports rx_data_p[1]]    ; ## FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1}                        [get_ports rx_data_n[1]]    ; ## FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  H2}                        [get_ports rx_data_p[2]]    ; ## FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1}                        [get_ports rx_data_n[2]]    ; ## FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  K2}                        [get_ports rx_data_p[0]]    ; ## FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1}                        [get_ports rx_data_n[0]]    ; ## FMC_HPC0_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  AC2 IOSTANDARD LVCMOS18}   [get_ports spi_csn]         ; ## FMC_HPC0_LA06_P
set_property  -dict {PACKAGE_PIN  V2  IOSTANDARD LVCMOS18}   [get_ports spi_miso]        ; ## FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD LVCMOS18}   [get_ports spi_clk]         ; ## FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD LVCMOS18}   [get_ports spi_mosi]        ; ## FMC_HPC0_LA01_CC_N

set_property  -dict {PACKAGE_PIN  A20 IOSTANDARD LVCMOS33}   [get_ports pmod_spi_csn]    ; ## PMOD0_0
set_property  -dict {PACKAGE_PIN  B20 IOSTANDARD LVCMOS33}   [get_ports pmod_spi_mosi]   ; ## PMOD0_1
set_property  -dict {PACKAGE_PIN  A22 IOSTANDARD LVCMOS33}   [get_ports pmod_spi_miso]   ; ## PMOD0_2
set_property  -dict {PACKAGE_PIN  A21 IOSTANDARD LVCMOS33}   [get_ports pmod_spi_clk]    ; ## PMOD0_3

set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVCMOS18}   [get_ports pwdn]            ; ## FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18}   [get_ports fda]             ; ## FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVCMOS18}   [get_ports fdb]             ; ## FMC_HPC0_LA03_N

set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVDS}      [get_ports rx_sync_p]       ; ## FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVDS}      [get_ports rx_sync_n]       ; ## FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  J27}                       [get_ports sysref_p]        ; ## USER_SMA_MGT_CLOCK_P
set_property  -dict {PACKAGE_PIN  J28}                       [get_ports sysref_n]        ; ## USER_SMA_MGT_CLOCK_N

# clocks
create_clock -period 3.07 -name rx_ref_clk [get_ports ref_clk0_p]

set_input_delay -clock [get_clocks rx_ref_clk] [get_property PERIOD [get_clocks rx_ref_clk]] \
                [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]