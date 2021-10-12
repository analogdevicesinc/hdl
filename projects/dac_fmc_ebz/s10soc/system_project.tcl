
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl
source ../common/config.tcl

adi_project dac_fmc_ebz_s10soc [list \
  JESD_L        [get_config_param L] \
  MODE          $mode \
  DEVICE        $device \
  DEVICE_CODE   $device_code \
]

set_global_assignment -name OPTIMIZATION_MODE "BALANCED"

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_assign.tcl

# lane-interface

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  LA01_P_CC
#    R228: R0 -> DNI
#    R232: DNI -> R0
#  LA01_N_CC
#    R229: R0 -> DNI
#    R233: DNI -> R0

set_location_assignment PIN_AP41  -to tx_ref_clk            ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_AP40  -to "tx_ref_clk(n)"       ; ## D05  FMCA_HPC_GBTCLK0_M2C_N

set_location_assignment PIN_BJ46  -to tx_serial_data[0]     ; ## C02  FMCA_HPC_DP0_C2M_P      SERDIN7_P
set_location_assignment PIN_BJ45  -to "tx_serial_data[0](n)"; ## C03  FMCA_HPC_DP0_C2M_N
set_location_assignment PIN_BF45  -to tx_serial_data[1]     ; ## A22  FMCA_HPC_DP1_C2M_P      SERDIN6_P
set_location_assignment PIN_BF44  -to "tx_serial_data[1](n)"; ## A23  FMCA_HPC_DP1_C2M_N
set_location_assignment PIN_BG47  -to tx_serial_data[2]     ; ## A26  FMCA_HPC_DP2_C2M_P      SERDIN5_P
set_location_assignment PIN_BG46  -to "tx_serial_data[2](n)"; ## A27  FMCA_HPC_DP2_C2M_N
set_location_assignment PIN_BE47  -to tx_serial_data[3]     ; ## A30  FMCA_HPC_DP3_C2M_P      SERDIN4_P
set_location_assignment PIN_BE46  -to "tx_serial_data[3](n)"; ## A31  FMCA_HPC_DP3_C2M_N
set_location_assignment PIN_BF49  -to tx_serial_data[4]     ; ## A34  FMCA_HPC_DP4_C2M_P      SERDIN2_N
set_location_assignment PIN_BF48  -to "tx_serial_data[4](n)"; ## A35  FMCA_HPC_DP4_C2M_N
set_location_assignment PIN_BC47  -to tx_serial_data[5]     ; ## A38  FMCA_HPC_DP5_C2M_P      SERDIN0_N
set_location_assignment PIN_BC46  -to "tx_serial_data[5](n)"; ## A39  FMCA_HPC_DP5_C2M_N
set_location_assignment PIN_BD49  -to tx_serial_data[6]     ; ## B36  FMCA_HPC_DP6_C2M_P      SERDIN1_N
set_location_assignment PIN_BD48  -to "tx_serial_data[6](n)"; ## B37  FMCA_HPC_DP6_C2M_N
set_location_assignment PIN_BA47  -to tx_serial_data[7]     ; ## B32  FMCA_HPC_DP7_C2M_P      SERDIN3_N
set_location_assignment PIN_BA46  -to "tx_serial_data[7](n)"; ## B33  FMCA_HPC_DP7_C2M_N

set_location_assignment PIN_BE31  -to tx_sync               ; ## D08  FMCA_HPC_LA01_P
set_location_assignment PIN_BD31  -to "tx_sync(n)"          ; ## D09  FMCA_HPC_LA01_N
# For AD9161/2/4-FMC-EBZ SYSREF is placed in other place
if {$device_code == 3} {
  set_location_assignment PIN_AN20  -to tx_sysref            ; ## H07  FMCA_HPC_LA02_P
  set_location_assignment PIN_AP20  -to "tx_sysref(n)"       ; ## H08  FMCA_HPC_LA02_N
} else {
  set_location_assignment PIN_AW30  -to tx_sysref            ; ## G06  FMCA_HPC_LA00_P
  set_location_assignment PIN_AW31  -to "tx_sysref(n)"       ; ## G07  FMCA_HPC_LA00_N
}

set_instance_assignment -name IO_STANDARD LVDS -to tx_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "tx_ref_clk(n)"
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

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_location_assignment PIN_BE32  -to dac_txen[0]            ; ## H13  FMCA_LA07_P
set_location_assignment PIN_BF32  -to dac_txen[1]            ; ## H14  FMCA_LA07_N

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_location_assignment PIN_BF31  -to dac_txen[2]            ; ## C10  FMCA_LA06_P
set_location_assignment PIN_BF30  -to dac_txen[3]            ; ## C11  FMCA_LA06_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen[3]

# spi

set_location_assignment PIN_BH30  -to spi_en                 ; ## D12  FMCA_LA05_N
set_location_assignment PIN_BC31  -to spi_clk                ; ## G09  FMCA_LA03_P
set_location_assignment PIN_BC32  -to spi_mosi               ; ## G10  FMCA_LA03_N
set_location_assignment PIN_BC30  -to spi_miso               ; ## H10  FMCA_LA04_P
set_location_assignment PIN_BD30  -to spi_csn_dac            ; ## H11  FMCA_LA04_N
set_location_assignment PIN_BG30  -to spi_csn_clk            ; ## D11  FMCA_LA05_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_dac
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

execute_flow -compile
