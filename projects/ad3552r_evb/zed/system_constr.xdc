###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad3552r_fmc SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[0]}]   ; # FMC_LA02_P    IO_L20P_T3_34   
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[1]}]   ; # FMC_LA02_N    IO_L20N_T3_34 
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[2]}]   ; # FMC_LA03_P    IO_L16P_T2_34    
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[3]}]   ; # FMC_LA03_N    IO_L16N_T2_34    

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 } [get_ports ad3552r_spi_sclk]       ; # FMC_LA00_CC_P IO_L13P_T2_MRCC_34   
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 } [get_ports ad3552r_spi_cs]         ; # FMC_LA00_CC_N IO_L13N_T2_MRCC_34   

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad3552r_ldacn]           ; # FMC_LA05_P    IO_L7P_T1_34   
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports ad3552r_resetn]          ; # FMC_LA05_N    IO_L7N_T1_34    
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad3552r_alertn]          ; # FMC_LA04_P    IO_L15P_T2_DQS_34     
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad3552r_qspi_sel]        ; # FMC_LA04_N    IO_L15N_T2_DQS_34   

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_6]          ; # FMC_LA06_P    IO_L10P_T1_34 
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_7]          ; # FMC_LA06_N    IO_L10N_T1_34 
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_8]          ; # FMC_LA07_P    IO_L21P_T3_DQS_34  
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_9]          ; # FMC_LA07_N    IO_L21N_T3_DQS_34
