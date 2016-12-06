
load_package flow

source ../../scripts/adi_env.tcl
project_new daq1_a10gx -overwrite

source "../../common/a10gx/a10gx_system_assign.tcl"

set_global_assignment -name VERILOG_FILE ../common/daq1_spi.v
set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name QSYS_FILE system_bd.qsys

set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# physical interface

set_location_assignment PIN_BA12  -to dac_clk_in                  ; ##  G02  FMC_LPC_CLK1_M2C_P
set_location_assignment PIN_BA13  -to "dac_clk_in(n)"             ; ##  G03  FMC_LPC_CLK1_M2C_N
set_location_assignment PIN_AY15  -to dac_clk_out                 ; ##  G27  FMC_LPC_LA25_P
set_location_assignment PIN_AY14  -to "dac_clk_out(n)"            ; ##  G28  FMC_LPC_LA25_N
set_location_assignment PIN_AV20  -to dac_frame_out               ; ##  H37  FMC_LPC_LA32_P
set_location_assignment PIN_AU20  -to "dac_frame_out(n)"          ; ##  H38  FMC_LPC_LA32_N
set_location_assignment PIN_AR9   -to dac_data_out[0]             ; ##  H19  FMC_LPC_LA15_P
set_location_assignment PIN_AT9   -to "dac_data_out[0](n)"        ; ##  H20  FMC_LPC_LA15_N
set_location_assignment PIN_AU8   -to dac_data_out[1]             ; ##  G21  FMC_LPC_LA20_P
set_location_assignment PIN_AT8   -to "dac_data_out[1](n)"        ; ##  G22  FMC_LPC_LA20_N
set_location_assignment PIN_AU11  -to dac_data_out[2]             ; ##  H22  FMC_LPC_LA19_P
set_location_assignment PIN_AU12  -to "dac_data_out[2](n)"        ; ##  H23  FMC_LPC_LA19_N
set_location_assignment PIN_AV19  -to dac_data_out[3]             ; ##  D20  FMC_LPC_LA17_CC_P
set_location_assignment PIN_AW19  -to "dac_data_out[3](n)"        ; ##  D21  FMC_LPC_LA17_CC_N
set_location_assignment PIN_AU18  -to dac_data_out[4]             ; ##  D23  FMC_LPC_LA23_P
set_location_assignment PIN_AT18  -to "dac_data_out[4](n)"        ; ##  D24  FMC_LPC_LA23_N
set_location_assignment PIN_AW12  -to dac_data_out[5]             ; ##  G24  FMC_LPC_LA22_P
set_location_assignment PIN_AY12  -to "dac_data_out[5](n)"        ; ##  G25  FMC_LPC_LA22_N
set_location_assignment PIN_AU21  -to dac_data_out[6]             ; ##  C22  FMC_LPC_LA18_CC_P
set_location_assignment PIN_AV21  -to "dac_data_out[6](n)"        ; ##  C23  FMC_LPC_LA18_CC_N
set_location_assignment PIN_AY10  -to dac_data_out[7]             ; ##  H25  FMC_LPC_LA21_P
set_location_assignment PIN_AY11  -to "dac_data_out[7](n)"        ; ##  H26  FMC_LPC_LA21_N
set_location_assignment PIN_AT19  -to dac_data_out[8]             ; ##  D26  FMC_LPC_LA26_P
set_location_assignment PIN_AT20  -to "dac_data_out[8](n)"        ; ##  D27  FMC_LPC_LA26_N
set_location_assignment PIN_BB15  -to dac_data_out[9]             ; ##  H28  FMC_LPC_LA24_P
set_location_assignment PIN_BC15  -to "dac_data_out[9](n)"        ; ##  H29  FMC_LPC_LA24_N
set_location_assignment PIN_AP21  -to dac_data_out[10]            ; ##  C26  FMC_LPC_LA27_P
set_location_assignment PIN_AR21  -to "dac_data_out[10](n)"       ; ##  C27  FMC_LPC_LA27_N
set_location_assignment PIN_BA15  -to dac_data_out[11]            ; ##  G30  FMC_LPC_LA29_P
set_location_assignment PIN_BA14  -to "dac_data_out[11](n)"       ; ##  G31  FMC_LPC_LA29_N
set_location_assignment PIN_AY16  -to dac_data_out[12]            ; ##  H31  FMC_LPC_LA28_P
set_location_assignment PIN_AW16  -to "dac_data_out[12](n)"       ; ##  H32  FMC_LPC_LA28_N
set_location_assignment PIN_BB17  -to dac_data_out[13]            ; ##  G33  FMC_LPC_LA31_P
set_location_assignment PIN_BB18  -to "dac_data_out[13](n)"       ; ##  G34  FMC_LPC_LA31_N
set_location_assignment PIN_BC18  -to dac_data_out[14]            ; ##  H34  FMC_LPC_LA30_P
set_location_assignment PIN_BD18  -to "dac_data_out[14](n)"       ; ##  H35  FMC_LPC_LA30_N
set_location_assignment PIN_AY17  -to dac_data_out[15]            ; ##  G36  FMC_LPC_LA33_P
set_location_assignment PIN_AW17  -to "dac_data_out[15](n)"       ; ##  G37  FMC_LPC_LA33_N

set_location_assignment PIN_AV15  -to adc_clk_in                  ; ##  G06  FMC_LPC_LA00_CC_P
set_location_assignment PIN_AU15  -to "adc_clk_in(n)"             ; ##  G07  FMC_LPC_LA00_CC_N
set_location_assignment PIN_AR15  -to adc_data_in[0]              ; ##  C14  FMC_LPC_LA10_P
set_location_assignment PIN_AT15  -to "adc_data_in[0](n)"         ; ##  C15  FMC_LPC_LA10_N
set_location_assignment PIN_AW18  -to adc_data_in[1]              ; ##  C18  FMC_LPC_LA14_P
set_location_assignment PIN_AV18  -to "adc_data_in[1](n)"         ; ##  C19  FMC_LPC_LA14_N
set_location_assignment PIN_AR17  -to adc_data_in[2]              ; ##  D17  FMC_LPC_LA13_P
set_location_assignment PIN_AP17  -to "adc_data_in[2](n)"         ; ##  D18  FMC_LPC_LA13_N
set_location_assignment PIN_AT14  -to adc_data_in[3]              ; ##  H16  FMC_LPC_LA11_P
set_location_assignment PIN_AR14  -to "adc_data_in[3](n)"         ; ##  H17  FMC_LPC_LA11_N
set_location_assignment PIN_AR16  -to adc_data_in[4]              ; ##  G15  FMC_LPC_LA12_P
set_location_assignment PIN_AP16  -to "adc_data_in[4](n)"         ; ##  G16  FMC_LPC_LA12_N
set_location_assignment PIN_AW13  -to adc_data_in[5]              ; ##  D14  FMC_LPC_LA09_P
set_location_assignment PIN_AV13  -to "adc_data_in[5](n)"         ; ##  D15  FMC_LPC_LA09_N
set_location_assignment PIN_AT17  -to adc_data_in[6]              ; ##  H13  FMC_LPC_LA07_P
set_location_assignment PIN_AU17  -to "adc_data_in[6](n)"         ; ##  H14  FMC_LPC_LA07_N
set_location_assignment PIN_AP18  -to adc_data_in[7]              ; ##  G12  FMC_LPC_LA08_P
set_location_assignment PIN_AN19  -to "adc_data_in[7](n)"         ; ##  G13  FMC_LPC_LA08_N
set_location_assignment PIN_AV11  -to adc_data_in[8]              ; ##  D11  FMC_LPC_LA05_P
set_location_assignment PIN_AW11  -to "adc_data_in[8](n)"         ; ##  D12  FMC_LPC_LA05_N
set_location_assignment PIN_AN20  -to adc_data_in[9]              ; ##  H10  FMC_LPC_LA04_P
set_location_assignment PIN_AP19  -to "adc_data_in[9](n)"         ; ##  H11  FMC_LPC_LA04_N
set_location_assignment PIN_AR20  -to adc_data_in[10]             ; ##  G09  FMC_LPC_LA03_P
set_location_assignment PIN_AR19  -to "adc_data_in[10](n)"        ; ##  G10  FMC_LPC_LA03_N
set_location_assignment PIN_AV14  -to adc_data_in[11]             ; ##  C10  FMC_LPC_LA06_P
set_location_assignment PIN_AW14  -to "adc_data_in[11](n)"        ; ##  C11  FMC_LPC_LA06_N
set_location_assignment PIN_AR22  -to adc_data_in[12]             ; ##  H07  FMC_LPC_LA02_P
set_location_assignment PIN_AT22  -to "adc_data_in[12](n)"        ; ##  H08  FMC_LPC_LA02_N
set_location_assignment PIN_AT10  -to adc_data_in[13]             ; ##  D08  FMC_LPC_LA01_CC_P
set_location_assignment PIN_AR11  -to "adc_data_in[13](n)"        ; ##  D09  FMC_LPC_LA01_CC_N

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

set_location_assignment PIN_AY19  -to spi_csn                                ; ##  H05  FMC_LPC_CLK0_M2C_N
set_location_assignment PIN_AY20  -to spi_clk                                ; ##  H04  FMC_LPC_CLK0_M2C_P
set_location_assignment PIN_AT13  -to spi_sdio                               ; ##  G18  FMC_LPC_LA16_P
set_location_assignment PIN_AU13  -to spi_int                                ; ##  G19  FMC_LPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8V" -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_sdio
set_instance_assignment -name IO_STANDARD "1.8V" -to spi_int

execute_flow -compile
