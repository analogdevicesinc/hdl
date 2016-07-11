
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcomms2_a10gx -overwrite

source "../../common/a10gx/a10gx_system_assign.tcl"

set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name QSYS_FILE system_bd.qsys

set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# lane interface

set_location_assignment PIN_AV15 -to rx_clk_in             ; ## G6   FMC_LPC_LA00_CC_P
set_location_assignment PIN_AU15 -to "rx_clk_in(n)"        ; ## G7   FMC_LPC_LA00_CC_N
set_location_assignment PIN_AT10 -to rx_frame_in           ; ## D8   FMC_LPC_LA01_CC_P
set_location_assignment PIN_AR11 -to "rx_frame_in(n)"      ; ## D9   FMC_LPC_LA01_CC_N
set_location_assignment PIN_AR22 -to rx_data_in[0]         ; ## H7   FMC_LPC_LA02_P
set_location_assignment PIN_AT22 -to "rx_data_in[0](n)"    ; ## H8   FMC_LPC_LA02_N
set_location_assignment PIN_AR20 -to rx_data_in[1]         ; ## G9   FMC_LPC_LA03_P
set_location_assignment PIN_AR19 -to "rx_data_in[1](n)"    ; ## G10  FMC_LPC_LA03_N
set_location_assignment PIN_AN20 -to rx_data_in[2]         ; ## H10  FMC_LPC_LA04_P
set_location_assignment PIN_AP19 -to "rx_data_in[2](n)"    ; ## H11  FMC_LPC_LA04_N
set_location_assignment PIN_AV11 -to rx_data_in[3]         ; ## D11  FMC_LPC_LA05_P
set_location_assignment PIN_AW11 -to "rx_data_in[3](n)"    ; ## D12  FMC_LPC_LA05_N
set_location_assignment PIN_AV14 -to rx_data_in[4]         ; ## C10  FMC_LPC_LA06_P
set_location_assignment PIN_AW14 -to "rx_data_in[4](n)"    ; ## C11  FMC_LPC_LA06_N
set_location_assignment PIN_AT17 -to rx_data_in[5]         ; ## H13  FMC_LPC_LA07_P
set_location_assignment PIN_AU17 -to "rx_data_in[5](n)"    ; ## H14  FMC_LPC_LA07_N
set_location_assignment PIN_AP18 -to tx_clk_out            ; ## G12  FMC_LPC_LA08_P
set_location_assignment PIN_AN19 -to "tx_clk_out(n)"       ; ## G13  FMC_LPC_LA08_N
set_location_assignment PIN_AW13 -to tx_frame_out          ; ## D14  FMC_LPC_LA09_P
set_location_assignment PIN_AV13 -to "tx_frame_out(n)"     ; ## D15  FMC_LPC_LA09_N
set_location_assignment PIN_AT14 -to tx_data_out[0]        ; ## H16  FMC_LPC_LA11_P
set_location_assignment PIN_AR14 -to "tx_data_out[0](n)"   ; ## H17  FMC_LPC_LA11_N
set_location_assignment PIN_AR16 -to tx_data_out[1]        ; ## G15  FMC_LPC_LA12_P
set_location_assignment PIN_AP16 -to "tx_data_out[1](n)"   ; ## G16  FMC_LPC_LA12_N
set_location_assignment PIN_AR17 -to tx_data_out[2]        ; ## D17  FMC_LPC_LA13_P
set_location_assignment PIN_AP17 -to "tx_data_out[2](n)"   ; ## D18  FMC_LPC_LA13_N
set_location_assignment PIN_AR15 -to tx_data_out[3]        ; ## C14  FMC_LPC_LA10_P
set_location_assignment PIN_AT15 -to "tx_data_out[3](n)"   ; ## C15  FMC_LPC_LA10_N
set_location_assignment PIN_AW18 -to tx_data_out[4]        ; ## C18  FMC_LPC_LA14_P
set_location_assignment PIN_AV18 -to "tx_data_out[4](n)"   ; ## C19  FMC_LPC_LA14_N
set_location_assignment PIN_AR9  -to tx_data_out[5]        ; ## H19  FMC_LPC_LA15_P
set_location_assignment PIN_AT9  -to "tx_data_out[5](n)"   ; ## H20  FMC_LPC_LA15_N
set_location_assignment PIN_AT13 -to enable]               ; ## G18  FMC_LPC_LA16_P
set_location_assignment PIN_AU13 -to txnrx]                ; ## G19  FMC_LPC_LA16_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_clk_in
set_instance_assignment -name IO_STANDARD LVDS -to rx_frame_in
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[0]
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[1]
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[2]
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[3]
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[4]
set_instance_assignment -name IO_STANDARD LVDS -to rx_data_in[5]
set_instance_assignment -name IO_STANDARD LVDS -to tx_clk_out
set_instance_assignment -name IO_STANDARD LVDS -to tx_frame_out
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[0]
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[1]
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[2]
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[3]
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[4]
set_instance_assignment -name IO_STANDARD LVDS -to tx_data_out[5]
set_instance_assignment -name IO_STANDARD LVDS -to enable
set_instance_assignment -name IO_STANDARD LVDS -to txnrx

# gpio

set_location_assignment PIN_AU8   -to gpio_status[0]                   ; ## G21  FMC_LPC_LA20_P
set_location_assignment PIN_AT8   -to gpio_status[1]                   ; ## G22  FMC_LPC_LA20_N
set_location_assignment PIN_AY10  -to gpio_status[2]                   ; ## H25  FMC_LPC_LA21_P
set_location_assignment PIN_AY11  -to gpio_status[3]                   ; ## H26  FMC_LPC_LA21_N
set_location_assignment PIN_AW12  -to gpio_status[4]                   ; ## G24  FMC_LPC_LA22_P
set_location_assignment PIN_AY12  -to gpio_status[5]                   ; ## G25  FMC_LPC_LA22_N
set_location_assignment PIN_AU18  -to gpio_status[6]                   ; ## D23  FMC_LPC_LA23_P
set_location_assignment PIN_AT18  -to gpio_status[7]                   ; ## D24  FMC_LPC_LA23_N
set_location_assignment PIN_BB15  -to gpio_ctl[0]                      ; ## H28  FMC_LPC_LA24_P
set_location_assignment PIN_BC15  -to gpio_ctl[1]                      ; ## H29  FMC_LPC_LA24_N
set_location_assignment PIN_AY15  -to gpio_ctl[2]                      ; ## G27  FMC_LPC_LA25_P
set_location_assignment PIN_AY14  -to gpio_ctl[3]                      ; ## G28  FMC_LPC_LA25_N
set_location_assignment PIN_AU11  -to gpio_en_agc                      ; ## H22  FMC_LPC_LA19_P
set_location_assignment PIN_AU12  -to gpio_sync                        ; ## H23  FMC_LPC_LA19_N
set_location_assignment PIN_AY16  -to gpio_resetb                      ; ## H31  FMC_LPC_LA28_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_en_agc
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_sync
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_resetb

# spi

set_location_assignment PIN_AT19  -to spi_csn                          ; ## D26  FMC_LPC_LA26_P
set_location_assignment PIN_AT20  -to spi_clk                          ; ## D27  FMC_LPC_LA26_N
set_location_assignment PIN_AP21  -to spi_mosi                         ; ## C26  FMC_LPC_LA27_P
set_location_assignment PIN_AR21  -to spi_miso                         ; ## C27  FMC_LPC_LA27_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

execute_flow -compile
