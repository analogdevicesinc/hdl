
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project arradio_c5soc

source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

# ad9361 interface

set_location_assignment PIN_H15 -to rx_clk_in               ; ##  HSMC_CLKIN_p2   P201.156
set_location_assignment PIN_G15 -to "rx_clk_in(n)"          ; ##  HSMC_CLKIN_n2   P201.158
set_location_assignment PIN_F13 -to rx_frame_in             ; ##  HSMC_RX_p14     P201.138
set_location_assignment PIN_E13 -to "rx_frame_in(n)"        ; ##  HSMC_RX_n14     P201.140
set_location_assignment PIN_D11 -to rx_data_in[0]           ; ##  HSMC_RX_p12     P201.126
set_location_assignment PIN_D10 -to "rx_data_in[0](n)"      ; ##  HSMC_RX_n12     P201.128
set_location_assignment PIN_E12 -to rx_data_in[1]           ; ##  HSMC_RX_p11     P201.120
set_location_assignment PIN_D12 -to "rx_data_in[1](n)"      ; ##  HSMC_RX_n11     P201.122
set_location_assignment PIN_E9  -to rx_data_in[2]           ; ##  HSMC_RX_p10     P201.114
set_location_assignment PIN_D9  -to "rx_data_in[2](n)"      ; ##  HSMC_RX_n10     P201.116
set_location_assignment PIN_B6  -to rx_data_in[3]           ; ##  HSMC_RX_p9      P201.108
set_location_assignment PIN_B5  -to "rx_data_in[3](n)"      ; ##  HSMC_RX_n9      P201.110
set_location_assignment PIN_F11 -to rx_data_in[4]           ; ##  HSMC_RX_p8      P201.102
set_location_assignment PIN_E11 -to "rx_data_in[4](n)"      ; ##  HSMC_RX_n8      P201.104
set_location_assignment PIN_C13 -to rx_data_in[5]           ; ##  HSMC_RX_p13     P201.132
set_location_assignment PIN_B12 -to "rx_data_in[5](n)"      ; ##  HSMC_RX_n13     P201.134
set_location_assignment PIN_A11 -to tx_clk_out              ; ##  HSMC_CLKOUT_p2  P201.155
set_location_assignment PIN_A10 -to "tx_clk_out(n)"         ; ##  HSMC_CLKOUT_n2  P201.157
set_location_assignment PIN_E3  -to tx_frame_out            ; ##  HSMC_TX_p5      P201.77
set_location_assignment PIN_E2  -to "tx_frame_out(n)"       ; ##  HSMC_TX_n5      P201.79
set_location_assignment PIN_E1  -to tx_data_out[0]          ; ##  HSMC_TX_p8      P201.101
set_location_assignment PIN_D1  -to "tx_data_out[0](n)"     ; ##  HSMC_TX_n8      P201.103
set_location_assignment PIN_D2  -to tx_data_out[1]          ; ##  HSMC_TX_p9      P201.107
set_location_assignment PIN_C2  -to "tx_data_out[1](n)"     ; ##  HSMC_TX_n9      P201.109
set_location_assignment PIN_C3  -to tx_data_out[2]          ; ##  HSMC_TX_p7      P201.89
set_location_assignment PIN_B3  -to "tx_data_out[2](n)"     ; ##  HSMC_TX_n7      P201.91
set_location_assignment PIN_B2  -to tx_data_out[3]          ; ##  HSMC_TX_p10     P201.113
set_location_assignment PIN_B1  -to "tx_data_out[3](n)"     ; ##  HSMC_TX_n10     P201.115
set_location_assignment PIN_A4  -to tx_data_out[4]          ; ##  HSMC_TX_p11     P201.119
set_location_assignment PIN_A3  -to "tx_data_out[4](n)"     ; ##  HSMC_TX_n11     P201.121
set_location_assignment PIN_E4  -to tx_data_out[5]          ; ##  HSMC_TX_p6      P201.83
set_location_assignment PIN_D4  -to "tx_data_out[5](n)"     ; ##  HSMC_TX_n6      P201.85

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

set_location_assignment PIN_G10 -to gpio_status[0]          ; ##  HSMC_RX_p2      P201.60
set_location_assignment PIN_J12 -to gpio_status[1]          ; ##  HSMC_RX_n1      P201.56
set_location_assignment PIN_K12 -to gpio_status[2]          ; ##  HSMC_RX_p1      P201.54
set_location_assignment PIN_G12 -to gpio_status[3]          ; ##  HSMC_RX_p0      P201.48
set_location_assignment PIN_K7  -to gpio_status[4]          ; ##  HSMC_RX_p4      P201.72
set_location_assignment PIN_F10 -to gpio_status[5]          ; ##  HSMC_RX_n2      P201.62
set_location_assignment PIN_J10 -to gpio_status[6]          ; ##  HSMC_RX_p3      P201.66
set_location_assignment PIN_J9  -to gpio_status[7]          ; ##  HSMC_RX_n3      P201.68
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_status[7]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[4]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[5]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[6]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_status[7]

set_location_assignment PIN_E8  -to gpio_ctl[0]             ; ##  HSMC_TX_p1      P201.53
set_location_assignment PIN_D7  -to gpio_ctl[1]             ; ##  HSMC_TX_n1      P201.55
set_location_assignment PIN_G7  -to gpio_ctl[2]             ; ##  HSMC_TX_p2      P201.59
set_location_assignment PIN_F6  -to gpio_ctl[3]             ; ##  HSMC_TX_n2      P201.61
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_ctl[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_ctl[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_ctl[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to gpio_ctl[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_ctl[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_ctl[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_ctl[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to gpio_ctl[3]

set_location_assignment PIN_B11 -to enable                  ; ##  HSMC_TX_n15     P201.145
set_location_assignment PIN_C12 -to txnrx                   ; ##  HSMC_TX_p15     P201.143
set_instance_assignment -name IO_STANDARD "2.5 V" -to enable
set_instance_assignment -name IO_STANDARD "2.5 V" -to txnrx
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to enable
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to txnrx

set_location_assignment PIN_AA26  -to ad9361_clk_out        ; ##  HSMC_CLKIN_p1   P201.96
set_location_assignment PIN_C4    -to ad9361_resetb         ; ##  HSMC_TX_n3      P201.67
set_location_assignment PIN_C5    -to ad9361_en_agc         ; ##  HSMC_TX_p4      P201.71
set_location_assignment PIN_D5    -to ad9361_sync           ; ##  HSMC_TX_n4      P201.73
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_resetb
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_en_agc
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_sync
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to ad9361_resetb
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to ad9361_en_agc
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to ad9361_sync

set_location_assignment PIN_A8  -to spi_csn                 ; ##  HSMC_TX_n0      P201.49
set_location_assignment PIN_H12 -to spi_clk                 ; ##  HSMC_D3         P201.44
set_location_assignment PIN_H13 -to spi_mosi                ; ##  HSMC_D1         P201.42
set_location_assignment PIN_G11 -to spi_miso                ; ##  HSMC_RX_n0      P201.50
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_miso
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to spi_csn
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to spi_clk
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to spi_mosi
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to spi_miso

set_location_assignment PIN_F15 -to scl                     ; ##  HSMC_RX_p16     P201.150
set_location_assignment PIN_G13 -to sda                     ; ##  HSMC_RX_n15     P201.146
set_location_assignment PIN_C7  -to ga0                     ; ##  HSMC_TX_p13     P201.131
set_location_assignment PIN_H14 -to ga1                     ; ##  HSMC_RX_p15     P201.144
set_instance_assignment -name IO_STANDARD "2.5 V" -to scl
set_instance_assignment -name IO_STANDARD "2.5 V" -to sda
set_instance_assignment -name IO_STANDARD "2.5 V" -to ga0
set_instance_assignment -name IO_STANDARD "2.5 V" -to ga1
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to scl
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to sda
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to ga0
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to ga1

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sda

set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity axi_ad9361

execute_flow -compile

