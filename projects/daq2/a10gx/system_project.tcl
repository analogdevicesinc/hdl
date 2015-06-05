
load_package flow

source ../../scripts/adi_env.tcl
project_new daq2_a10gx -overwrite

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/ad_iobuf.v
set_global_assignment -name VERILOG_FILE ../common/daq2_spi.v

# lane interface

set_location_assignment PIN_AJ8   -to rx_ref_clk            ; ## B20  FMCA_GBTCLK1_M2C_P
set_location_assignment PIN_AJ7   -to "rx_ref_clk(n)"       ; ## B21  FMCA_GBTCLK1_M2C_N
set_location_assignment PIN_AV5   -to rx_data[0]            ; ## A10  FMCA_DP3_M2C_P
set_location_assignment PIN_AV6   -to "rx_data[0](n)"       ; ## A11  FMCA_DP3_M2C_N
set_location_assignment PIN_AW7   -to rx_data[1]            ; ## C06  FMCA_DP0_M2C_P
set_location_assignment PIN_AW8   -to "rx_data[1](n)"       ; ## C07  FMCA_DP0_M2C_N
set_location_assignment PIN_AY5   -to rx_data[2]            ; ## A06  FMCA_DP2_M2C_P
set_location_assignment PIN_AY6   -to "rx_data[2](n)"       ; ## A07  FMCA_DP2_M2C_N
set_location_assignment PIN_BA7   -to rx_data[3]            ; ## A02  FMCA_DP1_M2C_P
set_location_assignment PIN_BA8   -to "rx_data[3](n)"       ; ## A03  FMCA_DP1_M2C_N
set_location_assignment PIN_AT10  -to rx_sync               ; ## D08  FMCA_LA01_CC_P
set_location_assignment PIN_AR11  -to "rx_sync(n)"          ; ## D09  FMCA_LA01_CC_N
set_location_assignment PIN_AR20  -to rx_sysref             ; ## G09  FMCA_LA03_P
set_location_assignment PIN_AR19  -to "rx_sysref(n)"        ; ## G10  FMCA_LA03_N
set_location_assignment PIN_AL8   -to tx_ref_clk            ; ## D04  FMCA_GBTCLK0_M2C_P
set_location_assignment PIN_AL7   -to "tx_ref_clk(n)"       ; ## D05  FMCA_GBTCLK0_M2C_N
set_location_assignment PIN_BC3   -to tx_data[0]            ; ## A30  FMCA_DP3_C2M_P (tx_data_p[0])
set_location_assignment PIN_BC4   -to "tx_data[0](n)"       ; ## A31  FMCA_DP3_C2M_N (tx_data_n[0])
set_location_assignment PIN_BC7   -to tx_data[1]            ; ## C02  FMCA_DP0_C2M_P (tx_data_p[3])
set_location_assignment PIN_BC8   -to "tx_data[1](n)"       ; ## C03  FMCA_DP0_C2M_N (tx_data_n[3])
set_location_assignment PIN_BB5   -to tx_data[2]            ; ## A26  FMCA_DP2_C2M_P (tx_data_p[1])
set_location_assignment PIN_BB6   -to "tx_data[2](n)"       ; ## A27  FMCA_DP2_C2M_N (tx_data_n[1])
set_location_assignment PIN_BD5   -to tx_data[3]            ; ## A22  FMCA_DP1_C2M_P (tx_data_p[2])
set_location_assignment PIN_BD6   -to "tx_data[3](n)"       ; ## A23  FMCA_DP1_C2M_N (tx_data_n[2])
set_location_assignment PIN_AR22  -to tx_sync               ; ## H07  FMCA_LA02_P
set_location_assignment PIN_AT22  -to "tx_sync(n)"          ; ## H08  FMCA_LA02_N
set_location_assignment PIN_AN20  -to tx_sysref             ; ## H10  FMCA_LA04_P
set_location_assignment PIN_AP19  -to "tx_sysref(n)"        ; ## H11  FMCA_LA04_N

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[3]
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sysref
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data[0]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data[1]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data[2]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_data[3]
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to tx_sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sysref

# gpio

set_location_assignment PIN_AT17  -to trig                  ; ## H13  FMCA_LA07_P
set_location_assignment PIN_AU17  -to "trig(n)"             ; ## H14  FMCA_LA07_N
set_location_assignment PIN_AR14  -to adc_fdb               ; ## H17  FMCA_LA11_N
set_location_assignment PIN_AT14  -to adc_fda               ; ## H16  FMCA_LA11_P
set_location_assignment PIN_AR16  -to dac_irq               ; ## G15  FMCA_LA12_P
set_location_assignment PIN_AP17  -to clkd_status[1]        ; ## D18  FMCA_LA13_N
set_location_assignment PIN_AR17  -to clkd_status[0]        ; ## D17  FMCA_LA13_P
set_location_assignment PIN_AV14  -to adc_pd                ; ## C10  FMCA_LA06_P
set_location_assignment PIN_AP16  -to dac_txen              ; ## G16  FMCA_LA12_N
set_location_assignment PIN_AT15  -to dac_reset             ; ## C15  FMCA_LA10_N
set_location_assignment PIN_AP18  -to clkd_sync             ; ## G12  FMCA_LA08_P

set_instance_assignment -name IO_STANDARD LVDS -to trig

# spi

set_location_assignment PIN_AV11  -to spi_csn_clk           ; ## D11  FMCA_LA05_P
set_location_assignment PIN_AR15  -to spi_csn_dac           ; ## C14  FMCA_LA10_P
set_location_assignment PIN_AV13  -to spi_csn_adc           ; ## D15  FMCA_LA09_N
set_location_assignment PIN_AW11  -to spi_clk               ; ## D12  FMCA_LA05_N
set_location_assignment PIN_AW13  -to spi_sdio              ; ## D14  FMCA_LA09_P
set_location_assignment PIN_AN19  -to spi_dir               ; ## G13  FMCA_LA08_N

execute_flow -compile

