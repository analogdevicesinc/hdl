
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project fmcomms2_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

# lane interface

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0 -> DNI
#  R633: R0 -> DNI


# constraints
# ad9361

set_location_assignment PIN_G14   -to  rx_clk_in           ; ## G06   FMCA_HPC_LA00_CC_P
set_location_assignment PIN_H14   -to  "rx_clk_in(n)"      ; ## G07   FMCA_HPC_LA00_CC_N
set_location_assignment PIN_E12   -to  rx_frame_in         ; ## D08   FMCA_HPC_LA01_CC_P
set_location_assignment PIN_E13   -to  "rx_frame_in(n)"    ; ## D09   FMCA_HPC_LA01_CC_N
set_location_assignment PIN_C13   -to  rx_data_in[0]       ; ## H07   FMCA_HPC_LA02_P
set_location_assignment PIN_D13   -to  "rx_data_in[0](n)"  ; ## H08   FMCA_HPC_LA02_N
set_location_assignment PIN_C14   -to  rx_data_in[1]       ; ## G09   FMCA_HPC_LA03_P
set_location_assignment PIN_D14   -to  "rx_data_in[1](n)"  ; ## G10  FMCA_HPC_LA03_N
set_location_assignment PIN_H12   -to  rx_data_in[2]       ; ## H10  FMCA_HPC_LA04_P
set_location_assignment PIN_H13   -to  "rx_data_in[2](n)"  ; ## H11  FMCA_HPC_LA04_N
set_location_assignment PIN_F13   -to  rx_data_in[3]       ; ## D11  FMCA_HPC_LA05_P
set_location_assignment PIN_F14   -to  "rx_data_in[3](n)"  ; ## D12  FMCA_HPC_LA05_N
set_location_assignment PIN_A10   -to  rx_data_in[4]       ; ## C10  FMCA_HPC_LA06_P
set_location_assignment PIN_B10   -to  "rx_data_in[4](n)"  ; ## C11  FMCA_HPC_LA06_N
set_location_assignment PIN_A9    -to  rx_data_in[5]       ; ## H13  FMCA_HPC_LA07_P
set_location_assignment PIN_B9    -to  "rx_data_in[5](n)"  ; ## H14  FMCA_HPC_LA07_N
set_location_assignment PIN_B11   -to  tx_clk_out          ; ## G12  FMCA_HPC_LA08_P
set_location_assignment PIN_B12   -to  "tx_clk_out(n)"     ; ## G13  FMCA_HPC_LA08_N
set_location_assignment PIN_A12   -to  tx_frame_out        ; ## D14  FMCA_HPC_LA09_P
set_location_assignment PIN_A13   -to  "tx_frame_out(n)"   ; ## D15  FMCA_HPC_LA09_N

set_location_assignment PIN_C9    -to  tx_data_out[0]      ; ## H16  FMCA_HPC_LA11_P
set_location_assignment PIN_D9    -to  "tx_data_out[0](n)" ; ## H17  FMCA_HPC_LA11_N
set_location_assignment PIN_M12   -to  tx_data_out[1]      ; ## G15  FMCA_HPC_LA12_P
set_location_assignment PIN_N13   -to  "tx_data_out[1](n)" ; ## G16  FMCA_HPC_LA12_N
set_location_assignment PIN_J11   -to  tx_data_out[2]      ; ## D17  FMCA_HPC_LA13_P
set_location_assignment PIN_K11   -to  "tx_data_out[2](n)" ; ## D18  FMCA_HPC_LA13_N
set_location_assignment PIN_A7    -to  tx_data_out[3]      ; ## C14  FMCA_HPC_LA10_P
set_location_assignment PIN_A8    -to  "tx_data_out[3](n)" ; ## C15  FMCA_HPC_LA10_N
set_location_assignment PIN_J9    -to  tx_data_out[4]      ; ## C18  FMCA_HPC_LA14_P
set_location_assignment PIN_J10   -to  "tx_data_out[4](n)" ; ## C19  FMCA_HPC_LA14_N
set_location_assignment PIN_D4    -to  tx_data_out[5]      ; ## H19  FMCA_HPC_LA15_P
set_location_assignment PIN_D5    -to  "tx_data_out[5](n)" ; ## H20  FMCA_HPC_LA15_N


set_instance_assignment -name IO_STANDARD LVDS               -to rx_clk_in
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_clk_in
set_instance_assignment -name IO_STANDARD LVDS               -to rx_frame_in
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_frame_in
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[0]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[1]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[2]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[3]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[4]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[4]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in[5]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in[5]

set_instance_assignment -name IO_STANDARD LVDS               -to tx_clk_out
set_instance_assignment -name IO_STANDARD LVDS               -to tx_frame_out
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[0]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[1]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[2]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[3]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[4]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out[5]


set_location_assignment PIN_C3   -to   gpio_status[0]                   ; ## G21  FMCA_HPC_LA20_P
set_location_assignment PIN_C4   -to   gpio_status[1]                   ; ## G22  FMCA_HPC_LA20_N
set_location_assignment PIN_C2   -to   gpio_status[2]                   ; ## H25  FMCA_HPC_LA21_P
set_location_assignment PIN_D3   -to   gpio_status[3]                   ; ## H26  FMCA_HPC_LA21_N
set_location_assignment PIN_F4   -to   gpio_status[4]                   ; ## G24  FMCA_HPC_LA22_P
set_location_assignment PIN_G4   -to   gpio_status[5]                   ; ## G25  FMCA_HPC_LA22_N
set_location_assignment PIN_C1   -to   gpio_status[6]                   ; ## D23  FMCA_HPC_LA23_P
set_location_assignment PIN_D1   -to   gpio_status[7]                   ; ## D24  FMCA_HPC_LA23_N
set_location_assignment PIN_E1   -to   gpio_ctl[0]                      ; ## H28  FMCA_HPC_LA24_P
set_location_assignment PIN_E2   -to   gpio_ctl[1]                      ; ## H29  FMCA_HPC_LA24_N
set_location_assignment PIN_E3   -to   gpio_ctl[2]                      ; ## G27  FMCA_HPC_LA25_P
set_location_assignment PIN_F3   -to   gpio_ctl[3]                      ; ## G28  FMCA_HPC_LA25_N
set_location_assignment PIN_G5   -to   gpio_en_agc                      ; ## H22  FMCA_HPC_LA19_P
set_location_assignment PIN_G6   -to   gpio_sync                        ; ## H23  FMCA_HPC_LA19_N
set_location_assignment PIN_L5   -to   gpio_resetb                      ; ## H31  FMCA_HPC_LA28_P
set_location_assignment PIN_D6   -to   enable                           ; ## G18  FMCA_HPC_LA16_P
set_location_assignment PIN_E6   -to   txnrx                            ; ## G19  FMCA_HPC_LA16_N

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
set_instance_assignment -name IO_STANDARD "1.8 V" -to enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to txnrx

set_location_assignment PIN_F2   -to    spi_csn                          ; ## D26  FMCA_HPC_LA26_P
set_location_assignment PIN_G2   -to    spi_clk                          ; ## D27  FMCA_HPC_LA26_N
set_location_assignment PIN_G1   -to    spi_mosi                         ; ## C26  FMCA_HPC_LA27_P
set_location_assignment PIN_H2   -to    spi_miso                         ; ## C27  FMCA_HPC_LA27_N

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

execute_flow -compile

