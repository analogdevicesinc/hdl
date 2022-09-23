source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adrv9001_a10soc

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

## constraints
## adrv9001
#
set_location_assignment PIN_E5   -to dev_clk_in          ; ## FMCA_HPC_CLK0_M2C_P
set_location_assignment PIN_J10  -to dev_mcs_fpga_out_n  ; ## FMCA_HPC_LA14_N
set_location_assignment PIN_J9   -to dev_mcs_fpga_out_p  ; ## FMCA_HPC_LA14_P
set_location_assignment PIN_D6   -to dgpio_0             ; ## FMCA_HPC_LA16_P
set_location_assignment PIN_E6   -to dgpio_1             ; ## FMCA_HPC_LA16_N
set_location_assignment PIN_D5   -to dgpio_2             ; ## FMCA_HPC_LA15_N
set_location_assignment PIN_D9   -to dgpio_3             ; ## FMCA_HPC_LA11_N
set_location_assignment PIN_A13  -to dgpio_4             ; ## FMCA_HPC_LA09_N
set_location_assignment PIN_A8   -to dgpio_5             ; ## FMCA_HPC_LA10_N
set_location_assignment PIN_G1   -to dgpio_6             ; ## FMCA_HPC_LA27_P
set_location_assignment PIN_F2   -to dgpio_7             ; ## FMCA_HPC_LA26_P
set_location_assignment PIN_L5   -to dgpio_8             ; ## FMCA_HPC_LA28_P
set_location_assignment PIN_M5   -to dgpio_9             ; ## FMCA_HPC_LA28_N
set_location_assignment PIN_C9   -to dgpio_10            ; ## FMCA_HPC_LA11_P
set_location_assignment PIN_H2   -to dgpio_11            ; ## FMCA_HPC_LA27_N
set_location_assignment PIN_L9   -to fpga_mcs_in_n       ; ## FMCA_HPC_LA32_N
set_location_assignment PIN_L8   -to fpga_mcs_in_p       ; ## FMCA_HPC_LA32_P
set_location_assignment PIN_W6   -to fpga_ref_clk_n      ; ## FMCA_HPC_CLK1_M2C_N
set_location_assignment PIN_W5   -to fpga_ref_clk_p      ; ## FMCA_HPC_CLK1_M2C_P
set_location_assignment PIN_P9   -to gp_int              ; ## FMCA_HPC_LA30_P
set_location_assignment PIN_J11  -to mode                ; ## FMCA_HPC_LA13_P
set_location_assignment PIN_K11  -to reset_trx           ; ## FMCA_HPC_LA13_N
set_location_assignment PIN_A7   -to rx1_enable          ; ## FMCA_HPC_LA10_P
set_location_assignment PIN_G2   -to rx2_enable          ; ## FMCA_HPC_LA26_N
set_location_assignment PIN_F5   -to sm_fan_tach         ; ## FMCA_HPC_CLK0_M2C_N
set_location_assignment PIN_M12  -to spi_clk             ; ## FMCA_HPC_LA12_P
set_location_assignment PIN_P10  -to spi_dio             ; ## FMCA_HPC_LA29_N
set_location_assignment PIN_N13  -to spi_do              ; ## FMCA_HPC_LA12_N
set_location_assignment PIN_D4   -to spi_en              ; ## FMCA_HPC_LA15_P
set_location_assignment PIN_A12  -to tx1_enable          ; ## FMCA_HPC_LA09_P
set_location_assignment PIN_N9   -to tx2_enable          ; ## FMCA_HPC_LA29_P
set_location_assignment PIN_P8   -to vadj_err            ; ## FMCA_HPC_LA31_P
set_location_assignment PIN_R8   -to platform_status     ; ## FMCA_HPC_LA31_N
set_location_assignment PIN_H14  -to rx1_dclk_in_n       ; ## FMCA_HPC_LA00_CC_N
set_location_assignment PIN_G14  -to rx1_dclk_in_p       ; ## FMCA_HPC_LA00_CC_P
set_location_assignment PIN_D14  -to rx1_idata_in_n      ; ## FMCA_HPC_LA03_N
set_location_assignment PIN_C14  -to rx1_idata_in_p      ; ## FMCA_HPC_LA03_P
set_location_assignment PIN_H13  -to rx1_qdata_in_n      ; ## FMCA_HPC_LA04_N
set_location_assignment PIN_H12  -to rx1_qdata_in_p      ; ## FMCA_HPC_LA04_P
set_location_assignment PIN_D13  -to rx1_strobe_in_n     ; ## FMCA_HPC_LA02_N
set_location_assignment PIN_C13  -to rx1_strobe_in_p     ; ## FMCA_HPC_LA02_P
set_location_assignment PIN_G9   -to rx2_dclk_in_n       ; ## FMCA_HPC_LA17_CC_N
set_location_assignment PIN_F9   -to rx2_dclk_in_p       ; ## FMCA_HPC_LA17_CC_P
set_location_assignment PIN_C4   -to rx2_idata_in_n      ; ## FMCA_HPC_LA20_N
set_location_assignment PIN_C3   -to rx2_idata_in_p      ; ## FMCA_HPC_LA20_P
set_location_assignment PIN_G6   -to rx2_qdata_in_n      ; ## FMCA_HPC_LA19_N
set_location_assignment PIN_G5   -to rx2_qdata_in_p      ; ## FMCA_HPC_LA19_P
set_location_assignment PIN_D3   -to rx2_strobe_in_n     ; ## FMCA_HPC_LA21_N
set_location_assignment PIN_C2   -to rx2_strobe_in_p     ; ## FMCA_HPC_LA21_P
set_location_assignment PIN_B9   -to tx1_dclk_out_n      ; ## FMCA_HPC_LA07_N
set_location_assignment PIN_A9   -to tx1_dclk_out_p      ; ## FMCA_HPC_LA07_P
set_location_assignment PIN_E13  -to tx1_dclk_in_n       ; ## FMCA_HPC_LA01_CC_N
set_location_assignment PIN_E12  -to tx1_dclk_in_p       ; ## FMCA_HPC_LA01_CC_P
set_location_assignment PIN_B12  -to tx1_idata_out_n     ; ## FMCA_HPC_LA08_N
set_location_assignment PIN_B11  -to tx1_idata_out_p     ; ## FMCA_HPC_LA08_P
set_location_assignment PIN_F14  -to tx1_qdata_out_n     ; ## FMCA_HPC_LA05_N
set_location_assignment PIN_F13  -to tx1_qdata_out_p     ; ## FMCA_HPC_LA05_P
set_location_assignment PIN_B10  -to tx1_strobe_out_n    ; ## FMCA_HPC_LA06_N
set_location_assignment PIN_A10  -to tx1_strobe_out_p    ; ## FMCA_HPC_LA06_P
set_location_assignment PIN_G4   -to tx2_dclk_out_n      ; ## FMCA_HPC_LA22_N
set_location_assignment PIN_F4   -to tx2_dclk_out_p      ; ## FMCA_HPC_LA22_P
set_location_assignment PIN_H7   -to tx2_dclk_in_n       ; ## FMCA_HPC_LA18_CC_N
set_location_assignment PIN_G7   -to tx2_dclk_in_p       ; ## FMCA_HPC_LA18_CC_P
set_location_assignment PIN_D1   -to tx2_idata_out_n     ; ## FMCA_HPC_LA23_N
set_location_assignment PIN_C1   -to tx2_idata_out_p     ; ## FMCA_HPC_LA23_P
set_location_assignment PIN_F3   -to tx2_qdata_out_n     ; ## FMCA_HPC_LA25_N
set_location_assignment PIN_E3   -to tx2_qdata_out_p     ; ## FMCA_HPC_LA25_P
set_location_assignment PIN_E2   -to tx2_strobe_out_n    ; ## FMCA_HPC_LA24_N
set_location_assignment PIN_E1   -to tx2_strobe_out_p    ; ## FMCA_HPC_LA24_P

execute_flow -compile

