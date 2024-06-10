###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

# if {![info exists NUM_OF_SDI]} {
#      set NUM_OF_SDI $::env(NUM_OF_SDI)
#      puts "inside info exists IF"
#    }

if {[info exists ::env(NUM_OF_SDI)]} {
  set NUM_OF_SDI $::env(NUM_OF_SDI)
   puts "inside info exists IF"
} else {
  set env(NUM_OF_SDI) 4
  puts "inside info exists ELSE"
}

 puts "NUM_OF_SDI_set: $NUM_OF_SDI"

    switch $NUM_OF_SDI {
      1 {
        set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdia]; ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
        puts "Inside NUM_OF_SDI = 1"
        }
      2 {
       set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdia];  ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
       set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdib];  ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
       puts "Inside NUM_OF_SDI = 2"
        }
      4 {
       set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdia];  ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
       set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdib];  ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
       set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdic];  ## H8  FMC_LA02_N     IO_L20N_T3_34
       set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdid];  ## G9  FMC_LA03_P     IO_L16P_T2_34
       puts "Inside NUM_OF_SDI = 4"
        }
    }

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports spi_sclk];         ## G6 FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports spi_sdo];          ## H7  FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports spi_cs];           ## G7  FMC_LA00_CC_N  IO_L13N_T2_MRCC_34
