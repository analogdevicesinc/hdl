
# adar3000 - hpc1

set_property  -dict {PACKAGE_PIN  Y5   IOSTANDARD LVCMOS18}  [get_ports spi_sel_a]               ; ## D20  FMC_HPC1_LA17_CC_P
set_property  -dict {PACKAGE_PIN  AA5  IOSTANDARD LVCMOS18}  [get_ports spi_mosi]                ; ## D21  FMC_HPC1_LA17_CC_N
set_property  -dict {PACKAGE_PIN  Y8   IOSTANDARD LVCMOS18}  [get_ports spi_miso]                ; ## C22  FMC_HPC1_LA18_CC_P
set_property  -dict {PACKAGE_PIN  AE12 IOSTANDARD LVCMOS18}  [get_ports spi_clk]                 ; ## D23  FMC_HPC1_LA23_P

set_property  -dict {PACKAGE_PIN  AC12 IOSTANDARD LVCMOS18}  [get_ports gpio0]                   ; ## H25  FMC_HPC1_LA21_P
set_property  -dict {PACKAGE_PIN  T12  IOSTANDARD LVCMOS18}  [get_ports gpio1]                   ; ## D26  FMC_HPC1_LA26_P
set_property  -dict {PACKAGE_PIN  AG11 IOSTANDARD LVCMOS18}  [get_ports gpio2]                   ; ## G25  FMC_HPC1_LA22_N
set_property  -dict {PACKAGE_PIN  U10  IOSTANDARD LVCMOS18}  [get_ports gpio3]                   ; ## C26  FMC_HPC1_LA27_P
set_property  -dict {PACKAGE_PIN  AC11 IOSTANDARD LVCMOS18}  [get_ports gpio4]                   ; ## H26  FMC_HPC1_LA21_N
set_property  -dict {PACKAGE_PIN  R12  IOSTANDARD LVCMOS18}  [get_ports gpio5]                   ; ## D27  FMC_HPC1_LA26_N
set_property  -dict {PACKAGE_PIN  AE10 IOSTANDARD LVCMOS18}  [get_ports gpio6]                   ; ## G27  FMC_HPC1_LA25_P
set_property  -dict {PACKAGE_PIN  T10  IOSTANDARD LVCMOS18}  [get_ports gpio7]                   ; ## C27  FMC_HPC1_LA27_N

