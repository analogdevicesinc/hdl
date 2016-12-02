
load_package flow

source ../../scripts/adi_env.tcl
project_new daq1_a10gx -overwrite

source "../../common/a10gx/a10gx_system_assign.tcl"

set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name QSYS_FILE system_bd.qsys

set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# physical interface


set_location_assignment PIN_AC28  -to dac_clk_in                  ; ##  G02  FMC_LPC_CLK1_M2C_P
set_location_assignment PIN_AD28  -to "dac_clk_in(n)"             ; ##  G03  FMC_LPC_CLK1_M2C_N
set_location_assignment PIN_AF29  -to dac_clk_out                 ; ##  G27  FMC_LPC_LA25_P
set_location_assignment PIN_AG29  -to "dac_clk_out(n)"            ; ##  G28  FMC_LPC_LA25_N
set_location_assignment PIN_Y26   -to dac_frame_out               ; ##  H37  FMC_LPC_LA32_P
set_location_assignment PIN_Y27   -to "dac_frame_out(n)"          ; ##  H38  FMC_LPC_LA32_N
set_location_assignment PIN_AB15  -to dac_data_out[0]             ; ##  H19  FMC_LPC_LA15_P
set_location_assignment PIN_AB14  -to "dac_data_out[0](n)"        ; ##  H20  FMC_LPC_LA15_N
set_location_assignment PIN_AG26  -to dac_data_out[1]             ; ##  G21  FMC_LPC_LA20_P
set_location_assignment PIN_AG27  -to "dac_data_out[1](n)"        ; ##  G22  FMC_LPC_LA20_N
set_location_assignment PIN_AH26  -to dac_data_out[2]             ; ##  H22  FMC_LPC_LA19_P
set_location_assignment PIN_AH27  -to "dac_data_out[2](n)"        ; ##  H23  FMC_LPC_LA19_N
set_location_assignment PIN_AB27  -to dac_data_out[3]             ; ##  D20  FMC_LPC_LA17_CC_P
set_location_assignment PIN_AC27  -to "dac_data_out[3](n)"        ; ##  D21  FMC_LPC_LA17_CC_N
set_location_assignment PIN_AJ26  -to dac_data_out[4]             ; ##  D23  FMC_LPC_LA23_P
set_location_assignment PIN_AK26  -to "dac_data_out[4](n)"        ; ##  D24  FMC_LPC_LA23_N
set_location_assignment PIN_AK27  -to dac_data_out[5]             ; ##  G24  FMC_LPC_LA22_P
set_location_assignment PIN_AK28  -to "dac_data_out[5](n)"        ; ##  G25  FMC_LPC_LA22_N
set_location_assignment PIN_AE27  -to dac_data_out[6]             ; ##  C22  FMC_LPC_LA18_CC_P
set_location_assignment PIN_AF27  -to "dac_data_out[6](n)"        ; ##  C23  FMC_LPC_LA18_CC_N
set_location_assignment PIN_AH28  -to dac_data_out[7]             ; ##  H25  FMC_LPC_LA21_P
set_location_assignment PIN_AH29  -to "dac_data_out[7](n)"        ; ##  H26  FMC_LPC_LA21_N
set_location_assignment PIN_AJ30  -to dac_data_out[8]             ; ##  D26  FMC_LPC_LA26_P
set_location_assignment PIN_AK30  -to "dac_data_out[8](n)"        ; ##  D27  FMC_LPC_LA26_N
set_location_assignment PIN_AF30  -to dac_data_out[9]             ; ##  H28  FMC_LPC_LA24_P
set_location_assignment PIN_AG30  -to "dac_data_out[9](n)"        ; ##  H29  FMC_LPC_LA24_N
set_location_assignment PIN_AJ28  -to dac_data_out[10]            ; ##  C26  FMC_LPC_LA27_P
set_location_assignment PIN_AJ29  -to "dac_data_out[10](n)"       ; ##  C27  FMC_LPC_LA27_N
set_location_assignment PIN_AE25  -to dac_data_out[11]            ; ##  G30  FMC_LPC_LA29_P
set_location_assignment PIN_AF25  -to "dac_data_out[11](n)"       ; ##  G31  FMC_LPC_LA29_N
set_location_assignment PIN_AD25  -to dac_data_out[12]            ; ##  H31  FMC_LPC_LA28_P
set_location_assignment PIN_AE26  -to "dac_data_out[12](n)"       ; ##  H32  FMC_LPC_LA28_N
set_location_assignment PIN_AC29  -to dac_data_out[13]            ; ##  G33  FMC_LPC_LA31_P
set_location_assignment PIN_AD29  -to "dac_data_out[13](n)"       ; ##  G34  FMC_LPC_LA31_N
set_location_assignment PIN_AB29  -to dac_data_out[14]            ; ##  H34  FMC_LPC_LA30_P
set_location_assignment PIN_AB30  -to "dac_data_out[14](n)"       ; ##  H35  FMC_LPC_LA30_N
set_location_assignment PIN_Y30   -to dac_data_out[15]            ; ##  G36  FMC_LPC_LA33_P
set_location_assignment PIN_AA30  -to "dac_data_out[15](n)"       ; ##  G37  FMC_LPC_LA33_N

set_location_assignment PIN_AE13  -to adc_clk_in                  ; ##    G06  FMC_LPC_LA00_CC_P
set_location_assignment PIN_AF13  -to "adc_clk_in(n)"             ; ##  G07  FMC_LPC_LA00_CC_N
set_location_assignment PIN_AC14  -to adc_data_in[0]              ; ##  C14  FMC_LPC_LA10_P
set_location_assignment PIN_AC13  -to "adc_data_in[0](n)"         ; ##  C15  FMC_LPC_LA10_N
set_location_assignment PIN_AF18  -to adc_data_in[1]              ; ##  C18  FMC_LPC_LA14_P
set_location_assignment PIN_AF17  -to "adc_data_in[1](n)"         ; ##  C19  FMC_LPC_LA14_N
set_location_assignment PIN_AH17  -to adc_data_in[2]              ; ##  D17  FMC_LPC_LA13_P
set_location_assignment PIN_AH16  -to "adc_data_in[2](n)"         ; ##  D18  FMC_LPC_LA13_N
set_location_assignment PIN_AJ16  -to adc_data_in[3]              ; ##  H16  FMC_LPC_LA11_P
set_location_assignment PIN_AK16  -to "adc_data_in[3](n)"         ; ##  H17  FMC_LPC_LA11_N
set_location_assignment PIN_AD16  -to adc_data_in[4]              ; ##  G15  FMC_LPC_LA12_P
set_location_assignment PIN_AD15  -to "adc_data_in[4](n)"         ; ##  G16  FMC_LPC_LA12_N
set_location_assignment PIN_AH14  -to adc_data_in[5]              ; ##  D14  FMC_LPC_LA09_P
set_location_assignment PIN_AH13  -to "adc_data_in[5](n)"         ; ##  D15  FMC_LPC_LA09_N
set_location_assignment PIN_AA15  -to adc_data_in[6]              ; ##  H13  FMC_LPC_LA07_P
set_location_assignment PIN_AA14  -to "adc_data_in[6](n)"         ; ##  H14  FMC_LPC_LA07_N
set_location_assignment PIN_AD14  -to adc_data_in[7]              ; ##  G12  FMC_LPC_LA08_P
set_location_assignment PIN_AD13  -to "adc_data_in[7](n)"         ; ##  G13  FMC_LPC_LA08_N
set_location_assignment PIN_AE16  -to adc_data_in[8]              ; ##  D11  FMC_LPC_LA05_P
set_location_assignment PIN_AE15  -to "adc_data_in[8](n)"         ; ##  D12  FMC_LPC_LA05_N
set_location_assignment PIN_AJ15  -to adc_data_in[9]              ; ##  H10  FMC_LPC_LA04_P
set_location_assignment PIN_AK15  -to "adc_data_in[9](n)"         ; ##  H11  FMC_LPC_LA04_N
set_location_assignment PIN_AG12  -to adc_data_in[10]             ; ##  G09  FMC_LPC_LA03_P
set_location_assignment PIN_AH12  -to "adc_data_in[10](n)"        ; ##  G10  FMC_LPC_LA03_N
set_location_assignment PIN_AB12  -to adc_data_in[11]             ; ##  C10  FMC_LPC_LA06_P
set_location_assignment PIN_AC12  -to "adc_data_in[11](n)"        ; ##  C11  FMC_LPC_LA06_N
set_location_assignment PIN_AE12  -to adc_data_in[12]             ; ##  H07  FMC_LPC_LA02_P
set_location_assignment PIN_AF12  -to "adc_data_in[12](n)"        ; ##  H08  FMC_LPC_LA02_N
set_location_assignment PIN_AF15  -to adc_data_in[13]             ; ##  D08  FMC_LPC_LA01_CC_P
set_location_assignment PIN_AG15  -to "adc_data_in[13](n)"        ; ##  D09  FMC_LPC_LA01_CC_N

set_instance_assignment -name IO_STANDARD LVDS -to dac_clk_in
set_instance_assignment -name IO_STANDARD LVDS -to dac_clk_out
set_instance_assignment -name IO_STANDARD LVDS -to dac_frame_out
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[0]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[1]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[2]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[3]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[4]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[5]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[6]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[7]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[8]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[9]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[10]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[11]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[12]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[13]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[14]
set_instance_assignment -name IO_STANDARD LVDS -to dac_data_out[15]
set_instance_assignment -name IO_STANDARD LVDS -to adc_clk_in
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[0]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[1]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[2]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[3]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[4]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[5]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[6]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[7]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[8]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[9]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[10]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[11]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[12]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[13]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[14]
set_instance_assignment -name IO_STANDARD LVDS -to adc_data_in[15]

# SPI interface

set_location_assignment PIN_AG16  -to spi_csn                                ; ##  H05  FMC_LPC_CLK0_M2C_N
set_location_assignment PIN_AG17  -to spi_clk                                ; ##  H04  FMC_LPC_CLK0_M2C_P
set_location_assignment PIN_AE18  -to spi_sdio                               ; ##  G18  FMC_LPC_LA16_P
set_location_assignment PIN_AE17  -to spi_int                                ; ##  G19  FMC_LPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8V" -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_sdio
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_int

execute_flow -compile
