
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0506_rmii_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

#files
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_iobuf.v

set_location_assignment PIN_G14    -to  rmii_rx_ref_clk_a            ; ## G06 FMCA_HPC_LA00_CC_P
set_location_assignment PIN_E13    -to  rmii_rx_er_a             ; ## D09 FMCA_HPC_LA01_CC_N
set_location_assignment PIN_B9     -to  rmii_rx_dv_a             ; ## H14 FMCA_HPC_LA07_N
set_location_assignment PIN_C13    -to  rmii_rxd_a[0]            ; ## H07 FMCA_HPC_LA02_P
set_location_assignment PIN_D13    -to  rmii_rxd_a[1]            ; ## H08 FMCA_HPC_LA02_N
set_location_assignment PIN_A9     -to  rmii_tx_en_a             ; ## H13 FMCA_HPC_LA07_P
set_location_assignment PIN_A12    -to  rmii_txd_a[0]            ; ## D14 FMCA_HPC_LA09_P
set_location_assignment PIN_A13    -to  rmii_txd_a[1]            ; ## D15 FMCA_HPC_LA09_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rx_ref_clk_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rx_dv_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rxd_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_tx_en_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_txd_a

set_location_assignment PIN_C9     -to  mdio_fmc_a                ; ## H16 FMCA_HPC_LA11_P
set_location_assignment PIN_D9     -to  mdc_fmc_a                 ; ## H17 FMCA_HPC_LA11_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc_a
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc_a

set_location_assignment PIN_D4     -to  reset_a                   ; ## H19 FMCA_HPC_LA15_P
set_location_assignment PIN_H12    -to  link_st_a                 ; ## H10 FMCA_HPC_LA04_P
set_location_assignment PIN_B11    -to  led_0_a                   ; ## G12 FMCA_HPC_LA08_P
set_location_assignment PIN_M12    -to  led_ar_c_c2m              ; ## G15 FMCA_HPC_LA12_P
set_location_assignment PIN_N13    -to  led_ar_a_c2m              ; ## G16 FMCA_HPC_LA12_N
set_location_assignment PIN_J11    -to  led_al_c_c2m              ; ## D17 FMCA_HPC_LA13_P
set_location_assignment PIN_K11    -to  led_al_a_c2m              ; ## D18 FMCA_HPC_LA13_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_0_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_ar_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_ar_a_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_al_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_al_a_c2m

set_location_assignment PIN_G7     -to  rmii_rx_ref_clk_b            ; ## C22 FMCA_HPC_LA18_CC_P
set_location_assignment PIN_G9     -to  rmii_rx_er_b             ; ## D21 FMCA_HPC_LA17_CC_N
set_location_assignment PIN_E2     -to  rmii_rx_dv_b             ; ## H29 FMCA_HPC_LA24_N
set_location_assignment PIN_G5     -to  rmii_rxd_b[0]            ; ## H22 FMCA_HPC_LA19_P
set_location_assignment PIN_G6     -to  rmii_rxd_b[1]            ; ## H23 FMCA_HPC_LA19_N
set_location_assignment PIN_E1     -to  rmii_tx_en_b             ; ## H28 FMCA_HPC_LA24_P
set_location_assignment PIN_C2     -to  rmii_txd_b[0]            ; ## H25 FMCA_HPC_LA21_P
set_location_assignment PIN_D3     -to  rmii_txd_b[1]            ; ## H26 FMCA_HPC_LA21_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rx_ref_clk_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rx_dv_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_rxd_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_tx_en_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to rmii_txd_b

set_location_assignment PIN_L5     -to  mdio_fmc_b                ; ## H31 FMCA_HPC_LA28_P
set_location_assignment PIN_M5     -to  mdc_fmc_b                 ; ## H32 FMCA_HPC_LA28_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc_b
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc_b

set_location_assignment PIN_D5     -to  reset_b                   ; ## H20 FMCA_HPC_LA15_N
set_location_assignment PIN_E3     -to  link_st_b                 ; ## G27 FMCA_HPC_LA25_P
set_location_assignment PIN_C1     -to  led_0_b                   ; ## D23 FMCA_HPC_LA23_P
set_location_assignment PIN_F2     -to  led_bl_c_c2m              ; ## D26 FMCA_HPC_LA26_P
set_location_assignment PIN_G2     -to  led_bl_a_c2m              ; ## D27 FMCA_HPC_LA26_N
set_location_assignment PIN_D6     -to  led_br_c_c2m              ; ## G18 FMCA_HPC_LA16_P
set_location_assignment PIN_E6     -to  led_br_a_c2m              ; ## G19 FMCA_HPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_0_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_bl_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_bl_a_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_br_c_c2m
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_br_a_c2m

execute_flow -compile
