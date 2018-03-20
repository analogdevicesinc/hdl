
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_alt.tcl

adi_project_altera ad9172_fmc_ebz_a10soc

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

set_location_assignment PIN_N29   -to tx_ref_clk0           ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "tx_ref_clk0(n)"      ; ## D05  FMCA_HPC_GBTCLK0_M2C_N
# set_location_assignment PIN_R29   -to tx_ref_clk1           ; ## B20  FMCA_HPC_GBTCLK1_M2C_P (DNI on the board)
# set_location_assignment PIN_R28   -to "tx_ref_clk1(n)"      ; ## B21  FMCA_HPC_GBTCLK1_M2C_N (DNI on the board)

set_location_assignment PIN_N37   -to tx_serial_data[0]     ; ## C02  FMCA_HPC_DP0_C2M_P
set_location_assignment PIN_N36   -to "tx_serial_data[0](n)"; ## C03  FMCA_HPC_DP0_C2M_N
set_location_assignment PIN_M39   -to tx_serial_data[1]     ; ## A22  FMCA_HPC_DP1_C2M_P
set_location_assignment PIN_M38   -to "tx_serial_data[1](n)"; ## A23  FMCA_HPC_DP1_C2M_N
set_location_assignment PIN_L37   -to tx_serial_data[2]     ; ## A26  FMCA_HPC_DP2_C2M_P
set_location_assignment PIN_L36   -to "tx_serial_data[2](n)"; ## A27  FMCA_HPC_DP2_C2M_N
set_location_assignment PIN_K39   -to tx_serial_data[3]     ; ## A30  FMCA_HPC_DP3_C2M_P
set_location_assignment PIN_K38   -to "tx_serial_data[3](n)"; ## A31  FMCA_HPC_DP3_C2M_N
set_location_assignment PIN_J37   -to tx_serial_data[4]     ; ## A34  FMCA_HPC_DP4_C2M_P
set_location_assignment PIN_J36   -to "tx_serial_data[4](n)"; ## A35  FMCA_HPC_DP4_C2M_N
set_location_assignment PIN_H39   -to tx_serial_data[5]     ; ## A38  FMCA_HPC_DP5_C2M_P
set_location_assignment PIN_H38   -to "tx_serial_data[5](n)"; ## A39  FMCA_HPC_DP5_C2M_N
set_location_assignment PIN_G37   -to tx_serial_data[6]     ; ## B36  FMCA_HPC_DP6_C2M_P
set_location_assignment PIN_G36   -to "tx_serial_data[6](n)"; ## B37  FMCA_HPC_DP6_C2M_N
set_location_assignment PIN_F39   -to tx_serial_data[7]     ; ## B32  FMCA_HPC_DP7_C2M_P
set_location_assignment PIN_F38   -to "tx_serial_data[7](n)"; ## B33  FMCA_HPC_DP7_C2M_N

set_location_assignment PIN_E12   -to tx_sync               ; ## D08  FMCA_HPC_LA01_P
set_location_assignment PIN_E13   -to "tx_sync(n)"          ; ## D09  FMCA_HPC_LA01_N
set_location_assignment PIN_G14   -to tx_sysref             ; ## G06  FMCA_HPC_LA00_P
set_location_assignment PIN_H14   -to "tx_sysref(n)"        ; ## G07  FMCA_HPC_LA00_N

set_instance_assignment -name IO_STANDARD LVDS -to tx_ref_clk0
set_instance_assignment -name IO_STANDARD LVDS -to "tx_ref_clk0(n)"
#set_instance_assignment -name IO_STANDARD LVDS -to tx_ref_clk1
#set_instance_assignment -name IO_STANDARD LVDS -to "tx_ref_clk1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to "tx_sync(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "tx_sync(n)"
set_instance_assignment -name IO_STANDARD LVDS -to tx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to "tx_sysref(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to "tx_sysref(n)"

# gpio

set_location_assignment PIN_A10  -to txen_0                ; ## C10  FMCA_LA06_P
set_location_assignment PIN_B10  -to txen_1                ; ## C11  FMCA_LA06_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to txen_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to txen_1

# spi

set_location_assignment PIN_F14  -to spi_en_n              ; ## D12  FMCA_LA05_N
set_location_assignment PIN_C14  -to spi_clk               ; ## G09  FMCA_LA03_P
set_location_assignment PIN_D14  -to spi_mosi              ; ## G10  FMCA_LA03_N
set_location_assignment PIN_H12  -to spi_miso              ; ## H10  FMCA_LA04_P
set_location_assignment PIN_H13  -to spi_csn_dac           ; ## H11  FMCA_LA04_N
set_location_assignment PIN_F13  -to spi_csn_clk           ; ## D11  FMCA_LA05_P


set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_en_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_dac

execute_flow -compile
