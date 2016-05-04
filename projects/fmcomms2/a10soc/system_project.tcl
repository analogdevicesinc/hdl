
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcomms2_a10soc -overwrite

source "../../common/a10soc/a10soc_system_assign.tcl"

set_global_assignment -name QSYS_FILE system_bd.qsys
set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# data-path

set_location_assignment PIN_G14   -to rx_clk_in             ; ## G6   FMC_LPC_LA00_CC_P
set_location_assignment PIN_H14   -to "rx_clk_in(n)"        ; ## G7   FMC_LPC_LA00_CC_N
set_location_assignment PIN_E12   -to rx_frame_in           ; ## D8   FMC_LPC_LA01_CC_P
set_location_assignment PIN_E13   -to "rx_frame_in(n)"      ; ## D9   FMC_LPC_LA01_CC_N
set_location_assignment PIN_C13   -to rx_data_in[0]         ; ## H7   FMC_LPC_LA02_P
set_location_assignment PIN_D13   -to "rx_data_in[0](n)"    ; ## H8   FMC_LPC_LA02_N
set_location_assignment PIN_C14   -to rx_data_in[1]         ; ## G9   FMC_LPC_LA03_P
set_location_assignment PIN_D14   -to "rx_data_in[1](n)"    ; ## G10  FMC_LPC_LA03_N
set_location_assignment PIN_H12   -to rx_data_in[2]         ; ## H10  FMC_LPC_LA04_P
set_location_assignment PIN_H13   -to "rx_data_in[2](n)"    ; ## H11  FMC_LPC_LA04_N
set_location_assignment PIN_F13   -to rx_data_in[3]         ; ## D11  FMC_LPC_LA05_P
set_location_assignment PIN_F14   -to "rx_data_in[3](n)"    ; ## D12  FMC_LPC_LA05_N
set_location_assignment PIN_A10   -to rx_data_in[4]         ; ## C10  FMC_LPC_LA06_P
set_location_assignment PIN_B10   -to "rx_data_in[4](n)"    ; ## C11  FMC_LPC_LA06_N
set_location_assignment PIN_A9    -to rx_data_in[5]         ; ## H13  FMC_LPC_LA07_P
set_location_assignment PIN_B9    -to "rx_data_in[5](n)"    ; ## H14  FMC_LPC_LA07_N
set_location_assignment PIN_B11   -to tx_clk_out            ; ## G12  FMC_LPC_LA08_P
set_location_assignment PIN_B12   -to "tx_clk_out(n)"       ; ## G13  FMC_LPC_LA08_N
set_location_assignment PIN_A12   -to tx_frame_out          ; ## D14  FMC_LPC_LA09_P
set_location_assignment PIN_A13   -to "tx_frame_out(n)"     ; ## D15  FMC_LPC_LA09_N
set_location_assignment PIN_C9    -to tx_data_out[0]        ; ## H16  FMC_LPC_LA11_P
set_location_assignment PIN_D9    -to "tx_data_out[0](n)"   ; ## H17  FMC_LPC_LA11_N
set_location_assignment PIN_M12   -to tx_data_out[1]        ; ## G15  FMC_LPC_LA12_P
set_location_assignment PIN_N13   -to "tx_data_out[1](n)"   ; ## G16  FMC_LPC_LA12_N
set_location_assignment PIN_J11   -to tx_data_out[2]        ; ## D17  FMC_LPC_LA13_P
set_location_assignment PIN_K11   -to "tx_data_out[2](n)"   ; ## D18  FMC_LPC_LA13_N
set_location_assignment PIN_A7    -to tx_data_out[3]        ; ## C14  FMC_LPC_LA10_P
set_location_assignment PIN_A8    -to "tx_data_out[3](n)"   ; ## C15  FMC_LPC_LA10_N
set_location_assignment PIN_J9    -to tx_data_out[4]        ; ## C18  FMC_LPC_LA14_P
set_location_assignment PIN_J10   -to "tx_data_out[4](n)"   ; ## C19  FMC_LPC_LA14_N
set_location_assignment PIN_D4    -to tx_data_out[5]        ; ## H19  FMC_LPC_LA15_P
set_location_assignment PIN_D5    -to "tx_data_out[5](n)"   ; ## H20  FMC_LPC_LA15_N

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

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_clk_in
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_frame_in
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[4]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[5]

# ensm/tdd control

set_location_assignment PIN_D6    -to enable                ; ## G18  FMC_LPC_LA16_P
set_location_assignment PIN_E6    -to txnrx                 ; ## G19  FMC_LPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to txnrx

# control & status

set_location_assignment PIN_C3    -to gpio_status[0]        ; ## G21  FMC_LPC_LA20_P
set_location_assignment PIN_C4    -to gpio_status[1]        ; ## G22  FMC_LPC_LA20_N
set_location_assignment PIN_C2    -to gpio_status[2]        ; ## H25  FMC_LPC_LA21_P
set_location_assignment PIN_D3    -to gpio_status[3]        ; ## H26  FMC_LPC_LA21_N
set_location_assignment PIN_F4    -to gpio_status[4]        ; ## G24  FMC_LPC_LA22_P
set_location_assignment PIN_G4    -to gpio_status[5]        ; ## G25  FMC_LPC_LA22_N
set_location_assignment PIN_C1    -to gpio_status[6]        ; ## D23  FMC_LPC_LA23_P
set_location_assignment PIN_D1    -to gpio_status[7]        ; ## D24  FMC_LPC_LA23_N
set_location_assignment PIN_E1    -to gpio_ctl[0]           ; ## H28  FMC_LPC_LA24_P
set_location_assignment PIN_E2    -to gpio_ctl[1]           ; ## H29  FMC_LPC_LA24_N
set_location_assignment PIN_E3    -to gpio_ctl[2]           ; ## G27  FMC_LPC_LA25_P
set_location_assignment PIN_F3    -to gpio_ctl[3]           ; ## G28  FMC_LPC_LA25_N
set_location_assignment PIN_G5    -to gpio_en_agc           ; ## H22  FMC_LPC_LA19_P
set_location_assignment PIN_G6    -to gpio_sync             ; ## H23  FMC_LPC_LA19_N
set_location_assignment PIN_L5    -to gpio_resetb           ; ## H31  FMC_LPC_LA28_P

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

set_location_assignment PIN_F2    -to spi_csn               ; ## D26  FMC_LPC_LA26_P
set_location_assignment PIN_G2    -to spi_clk               ; ## D27  FMC_LPC_LA26_N
set_location_assignment PIN_G1    -to spi_mosi              ; ## C26  FMC_LPC_LA27_P
set_location_assignment PIN_H2    -to spi_miso              ; ## C27  FMC_LPC_LA27_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

execute_flow -compile

