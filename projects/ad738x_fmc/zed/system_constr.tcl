###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

 if {![info exists NUM_OF_SDI]} {
      set NUM_OF_SDI $::env(NUM_OF_SDI)
    }

    switch $NUM_OF_SDI {
      1 {
        set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports spi_sdia]; ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
        }
      2 {
       set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports spi_sdia];  ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
       set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports spi_sdib];  ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
        }
      4 {
       set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports spi_sdia];  ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
       set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports spi_sdib];  ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
       set_property -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS25} [get_ports spi_sdic];  ## D11 FMC_LA05_P     IO_L7P_T1_34
       set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS25} [get_ports spi_sdid];  ## D14 FMC_LA09_P     IO_L17P_T2_34
        }
    }

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports spi_sclk];         ## G6 FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports spi_sdo];          ## H7  FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports spi_cs];           ## G7  FMC_LA00_CC_N  IO_L13N_T2_MRCC_34
