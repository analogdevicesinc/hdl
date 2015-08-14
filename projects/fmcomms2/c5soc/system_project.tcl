
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcomms2_c5soc -overwrite

source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

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

set_location_assignment PIN_H15 -to rx_clk_in
set_location_assignment PIN_G15 -to "rx_clk_in(n)"
set_location_assignment PIN_F13 -to rx_frame_in
set_location_assignment PIN_E13 -to "rx_frame_in(n)"
set_location_assignment PIN_D11 -to rx_data_in[0]
set_location_assignment PIN_D10 -to "rx_data_in[0](n)"
set_location_assignment PIN_E12 -to rx_data_in[1]
set_location_assignment PIN_D12 -to "rx_data_in[1](n)"
set_location_assignment PIN_E9  -to rx_data_in[2]
set_location_assignment PIN_D9  -to "rx_data_in[2](n)"
set_location_assignment PIN_B6  -to rx_data_in[3]
set_location_assignment PIN_B5  -to "rx_data_in[3](n)"
set_location_assignment PIN_F11 -to rx_data_in[4]
set_location_assignment PIN_E11 -to "rx_data_in[4](n)"
set_location_assignment PIN_C13 -to rx_data_in[5]
set_location_assignment PIN_B12 -to "rx_data_in[5](n)"

set_location_assignment PIN_A11 -to tx_clk_out
set_location_assignment PIN_A10 -to "tx_clk_out(n)"
set_location_assignment PIN_E3  -to tx_frame_out
set_location_assignment PIN_E2  -to "tx_frame_out(n)"
set_location_assignment PIN_E1  -to tx_data_out[0]
set_location_assignment PIN_D1  -to "tx_data_out[0](n)"
set_location_assignment PIN_D2  -to tx_data_out[1]
set_location_assignment PIN_C2  -to "tx_data_out[1](n)"
set_location_assignment PIN_C3  -to tx_data_out[2]
set_location_assignment PIN_B3  -to "tx_data_out[2](n)"
set_location_assignment PIN_B2  -to tx_data_out[3]
set_location_assignment PIN_B1  -to "tx_data_out[3](n)"
set_location_assignment PIN_A4  -to tx_data_out[4]
set_location_assignment PIN_A3  -to "tx_data_out[4](n)"
set_location_assignment PIN_E4  -to tx_data_out[5]
set_location_assignment PIN_D4  -to "tx_data_out[5](n)"

set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_resetb
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_en_agc
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_sync
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_enable
set_instance_assignment -name IO_STANDARD "2.5 V" -to ad9361_txnrx

set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_miso

set_location_assignment PIN_C4  -to ad9361_resetb
set_location_assignment PIN_C5  -to ad9361_en_agc
set_location_assignment PIN_D5  -to ad9361_sync
set_location_assignment PIN_B11 -to ad9361_enable
set_location_assignment PIN_C12 -to ad9361_txnrx
set_location_assignment PIN_A8  -to spi_csn
set_location_assignment PIN_H12 -to spi_clk
set_location_assignment PIN_H13 -to spi_mosi
set_location_assignment PIN_G11 -to spi_miso

execute_flow -compile

