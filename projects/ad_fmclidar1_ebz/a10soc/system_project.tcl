
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project ad_fmclidar1_ebz_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../common/util_tia_chsel.v
set_global_assignment -name VERILOG_FILE ../common/util_axis_syncgen.v
set_global_assignment -name VERILOG_FILE ../../../library/util_cdc/sync_bits.v

#
# Note: This project requires a hardware rework to function correctly.
# The rework connects FMC_A header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#
# REMOVE:   R575, R576, R621, R633, R612, R613
#
# POPULATE: R574, R577, R620, R632, R610, R611
#

# ADC digital interface (JESD204B)

set_location_assignment  PIN_N29  -to rx_ref_clk            ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment  PIN_N28  -to "rx_ref_clk(n)"       ; ## D05  FMCA_HPC_GBTCLK0_M2C_N

## NOTE: Need hardware rework
set_location_assignment  PIN_W5   -to rx_device_clk         ; ## G02  FMCA_HPC_CLK1_M2C_P
set_location_assignment  PIN_W6   -to "rx_device_clk(n)"    ; ## G03  FMCA_HPC_CLK1_M2C_N

set_location_assignment  PIN_T31  -to rx_data[0]            ; ## C06  FMCA_HPC_DP00_M2C_P
set_location_assignment  PIN_T30  -to "rx_data[0](n)"       ; ## C07  FMCA_HPC_DP00_M2C_N
set_location_assignment  PIN_R33  -to rx_data[1]            ; ## A02  FMCA_HPC_DP01_M2C_P
set_location_assignment  PIN_R32  -to "rx_data[1](n)"       ; ## A03  FMCA_HPC_DP01_M2C_N
set_location_assignment  PIN_P35  -to rx_data[2]            ; ## A06  FMCA_HPC_DP02_M2C_P
set_location_assignment  PIN_P34  -to "rx_data[2](n)"       ; ## A07  FMCA_HPC_DP02_M2C_N
set_location_assignment  PIN_P31  -to rx_data[3]            ; ## A10  FMCA_HPC_DP03_M2C_P
set_location_assignment  PIN_P30  -to "rx_data[3](n)"       ; ## A11  FMCA_HPC_DP03_M2C_N

set_location_assignment  PIN_A9  -to rx_sync_0              ; ## H13  FMCA_HPC_LA07_P
set_location_assignment  PIN_B9  -to "rx_sync_0(n)"         ; ## H14  FMCA_HPC_LA07_N
set_location_assignment  PIN_H12  -to rx_sync_1             ; ## H10  FMCA_HPC_LA04_P
set_location_assignment  PIN_H13  -to "rx_sync_1(n)"        ; ## H11  FMCA_HPC_LA04_N

## NOTE: Need hardware rework
set_location_assignment  PIN_E12 -to rx_sysref              ; ## D08  FMCA_HPC_LA01_CC_P
set_location_assignment  PIN_E13 -to "rx_sysref(n)"         ; ## D09  FMCA_HPC_LA01_CC_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_ref_clk(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_device_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_device_clk(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_0
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync_0(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_1
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync_1(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sysref(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sync_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "rx_sync_0(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sync_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "rx_sync_1(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "rx_sysref(n)"

# ADC control lines

set_location_assignment  PIN_D13  -to adc_pdwn              ; ## H08  FMCA_HPC_LA02_N
set_location_assignment  PIN_C14  -to adc_fda               ; ## G09  FMCA_HPC_LA03_P
set_location_assignment  PIN_D14  -to adc_fdb               ; ## G10  FMCA_HPC_LA03_N

set_instance_assignment -name IO_STANDARD "1.8V" -to adc_pdwn
set_instance_assignment -name IO_STANDARD "1.8V" -to adc_fda
set_instance_assignment -name IO_STANDARD "1.8V" -to adc_fdb

# SPI interfaces

set_location_assignment  PIN_A10  -to spi_adc_csn           ; ## C10  FMCA_HPC_LA06_P
set_location_assignment  PIN_P11  -to spi_adc_clk           ; ## G36  FMCA_HPC_LA33_P
set_location_assignment  PIN_C13  -to spi_adc_miso          ; ## H07  FMCA_HPC_LA02_P
set_location_assignment  PIN_R11  -to spi_adc_mosi          ; ## G37  FMCA_HPC_LA33_N

set_location_assignment  PIN_D4   -to spi_vco_csn           ; ## H19  FMCA_HPC_LA15_P
set_location_assignment  PIN_C9   -to spi_vco_clk           ; ## H16  FMCA_HPC_LA11_P
set_location_assignment  PIN_D9   -to spi_vco_mosi          ; ## H17  FMCA_HPC_LA11_N

set_location_assignment  PIN_C2   -to spi_clkgen_csn        ; ## H25  FMCA_HPC_LA21_P
set_location_assignment  PIN_G5   -to spi_clkgen_clk        ; ## H22  FMCA_HPC_LA19_P
set_location_assignment  PIN_D3   -to spi_clkgen_miso       ; ## H26  FMCA_HPC_LA21_N
set_location_assignment  PIN_G6   -to spi_clkgen_mosi       ; ## H23  FMCA_HPC_LA19_N

set_instance_assignment -name IO_STANDARD "1.8V" -to spi_adc_csn
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_adc_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_adc_miso
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_adc_mosi

set_instance_assignment -name IO_STANDARD "1.8V" -to spi_vco_csn
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_vco_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_vco_mosi

set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clkgen_csn
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clkgen_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clkgen_miso
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clkgen_mosi

# Laser driver and GPIOs

set_location_assignment  PIN_G7  -to  laser_driver           ; ## C22  FMCA_HPC_LA18_CC_P
set_location_assignment  PIN_H7  -to  "laser_driver(n)"      ; ## C23  FMCA_HPC_LA18_CC_N

set_location_assignment  PIN_G1  -to  laser_driver_en_n      ; ## C26  FMCA_HPC_LA27_P
set_location_assignment  PIN_P8  -to  laser_driver_otw_n     ; ## G33  FMCA_HPC_LA31_P

set_location_assignment  PIN_H2  -to  laser_gpio[0]          ; ## C27  FMCA_HPC_LA27_N
set_location_assignment  PIN_F9  -to  laser_gpio[1]          ; ## D20  FMCA_HPC_LA17_CC_P
set_location_assignment  PIN_G9  -to  laser_gpio[2]          ; ## D21  FMCA_HPC_LA17_CC_N
set_location_assignment  PIN_C1  -to  laser_gpio[3]          ; ## D23  FMCA_HPC_LA23_P
set_location_assignment  PIN_D1  -to  laser_gpio[4]          ; ## D24  FMCA_HPC_LA23_N
set_location_assignment  PIN_F2  -to  laser_gpio[5]          ; ## D26  FMCA_HPC_LA26_P
set_location_assignment  PIN_G2  -to  laser_gpio[6]          ; ## D27  FMCA_HPC_LA26_N
set_location_assignment  PIN_F4  -to  laser_gpio[7]          ; ## G24  FMCA_HPC_LA22_P
set_location_assignment  PIN_G4  -to  laser_gpio[8]          ; ## G25  FMCA_HPC_LA22_N
set_location_assignment  PIN_E3  -to  laser_gpio[9]          ; ## G27  FMCA_HPC_LA25_P
set_location_assignment  PIN_F3  -to  laser_gpio[10]         ; ## G28  FMCA_HPC_LA25_N
set_location_assignment  PIN_N9  -to  laser_gpio[11]         ; ## G30  FMCA_HPC_LA29_P
set_location_assignment  PIN_P10 -to  laser_gpio[12]         ; ## G31  FMCA_HPC_LA29_N
set_location_assignment  PIN_R8  -to  laser_gpio[13]         ; ## G34  FMCA_HPC_LA31_N

set_instance_assignment -name IO_STANDARD LVDS -to  laser_driver
set_instance_assignment -name IO_STANDARD LVDS -to  "laser_driver(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to  laser_driver
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to  "laser_driver(n)"

set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_driver_en_n
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_driver_otw_n

set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[3]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[4]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[5]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[6]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[7]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[8]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[9]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[10]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[11]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[12]
set_instance_assignment -name IO_STANDARD "1.8V" -to  laser_gpio[13]

# TIA channel selection

set_location_assignment  PIN_B10  -to tia_chsel[0]          ; ## afe_sel0_1 C11  FMCA_HPC_LA06_N
set_location_assignment  PIN_A7   -to tia_chsel[1]          ; ## afe_sel1_1 C14  FMCA_HPC_LA10_P
set_location_assignment  PIN_A8   -to tia_chsel[2]          ; ## afe_sel0_2 C15  FMCA_HPC_LA10_N
set_location_assignment  PIN_J9   -to tia_chsel[3]          ; ## afe_sel1_2 C18  FMCA_HPC_LA14_P
set_location_assignment  PIN_J10  -to tia_chsel[4]          ; ## afe_sel0_3 C19  FMCA_HPC_LA14_N

## NOTE: Need hardware rework
set_location_assignment  PIN_F13  -to tia_chsel[5]          ; ## afe_sel1_3 D11  FMCB_HPC_LA05_P
set_location_assignment  PIN_F14  -to tia_chsel[6]          ; ## afe_sel0_4 D12  FMCA_HPC_LA05_N

set_location_assignment  PIN_A12  -to tia_chsel[7]          ; ## afe_sel1_4 D14  FMCA_HPC_LA09_P

set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[2]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[3]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[4]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[5]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[6]
set_instance_assignment -name IO_STANDARD "1.8V" -to tia_chsel[7]

# AFE DAC I2C and control

set_location_assignment PIN_A13  -to afe_dac_sda            ; ## D15  FMCA_HPC_LA09_N
set_location_assignment PIN_J11  -to afe_dac_scl            ; ## D17  FMCA_HPC_LA13_P
set_location_assignment PIN_K11  -to afe_dac_clr_n          ; ## D18  FMCA_HPC_LA13_N
set_location_assignment PIN_G14  -to afe_dac_load           ; ## G06  FMCA_HPC_LA00_CC_P

set_instance_assignment -name IO_STANDARD "1.8V" -to afe_dac_sda
set_instance_assignment -name IO_STANDARD "1.8V" -to afe_dac_scl
set_instance_assignment -name IO_STANDARD "1.8V" -to afe_dac_clr_n
set_instance_assignment -name IO_STANDARD "1.8V" -to afe_dac_load

# AFE ADC SPI and control

set_location_assignment  PIN_H14  -to afe_adc_sclk          ; ## G07  FMCA_HPC_LA00_CC_N
set_location_assignment  PIN_B11  -to afe_adc_scn           ; ## G12  FMCA_HPC_LA08_P
set_location_assignment  PIN_B12  -to afe_adc_convst        ; ## G13  FMCA_HPC_LA08_N
set_location_assignment  PIN_M12  -to afe_adc_sdi           ; ## G15  FMCA_HPC_LA12_P

set_instance_assignment  -name IO_STANDARD "1.8V" -to afe_adc_sclk
set_instance_assignment  -name IO_STANDARD "1.8V" -to afe_adc_scn
set_instance_assignment  -name IO_STANDARD "1.8V" -to afe_adc_convst
set_instance_assignment  -name IO_STANDARD "1.8V" -to afe_adc_sdi

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
