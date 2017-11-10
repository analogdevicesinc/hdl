
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_alt.tcl

adi_project_altera ad9694_500ebz_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

set NUM_LANES 2

# files

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

#set_location_assignment PIN_N29   -to rx_ref_clk            ; ## D04 FMCA_HPC_GBTCLK0_M2C_P
#set_location_assignment PIN_N28   -to "rx_ref_clk(n)"       ; ## D05 FMCA_HPC_GBTCLK0_M2C_N

set_location_assignment PIN_J29   -to rx_ref_clk            ; ## REFCLK_GXBL1I_CHTP
set_location_assignment PIN_J28   -to "rx_ref_clk(n)"       ; ## REFCLK_GXBL1I_CHTN

## A18 FMCA_HPC_DP05_M2C_P / A19 FMCA_HPC_DP05_M2C_N
## B16 FMCA_HPC_DP06_M2C_P / B17 FMCA_HPC_DP06_M2C_N
## C06 FMCA_HPC_DP00_M2C_P / C07 FMCA_HPC_DP00_M2C_N
## A02 FMCA_HPC_DP01_M2C_P / A03 FMCA_HPC_DP01_M2C_N
set rx_loc {
  {PIN_M35 PIN_M34}
  {PIN_M31 PIN_M30}
  {PIN_T31 PIN_T30}
  {PIN_R33 PIN_R32}
}

for {set i 0} {$i < $NUM_LANES} {incr i} {
  lassign [lindex $rx_loc $i] pin_p pin_n
  set_location_assignment $pin_p -to "rx_serial_data[${i}]"
  set_location_assignment $pin_n -to "rx_serial_data[${i}](n)";
}

set_location_assignment PIN_H12   -to rx_sync_0             ; ## H13 FMCA_HPC_LA07_P
set_location_assignment PIN_H13   -to "rx_sync_0(n)"        ; ## H14 FMCA_HPC_LA07_N
set_location_assignment PIN_A9    -to rx_sync_1             ; ## H10 FMCA_HPC_LA04_P
set_location_assignment PIN_B9    -to "rx_sync_1(n)"        ; ## H11 FMCA_HPC_LA04_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_ref_clk(n)"
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_ref_clk
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_0
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync_0(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync_1
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync_1(n)"

# gpio

set_location_assignment PIN_C14  -to adc_fda               ; ## G09 FMCA_HPC_LA03_P
set_location_assignment PIN_D14  -to adc_fdb               ; ## G10 FMCA_HPC_LA03_N


set_instance_assignment -name IO_STANDARD "1.8 V" -to adc_fdb
set_instance_assignment -name IO_STANDARD "1.8 V" -to adc_fda

# spi

set_location_assignment PIN_E12  -to spi_clk               ; ## D08 FMCA_HPC_LA01_CC_P
set_location_assignment PIN_C13  -to spi_sdo               ; ## H07 FMCA_HPC_LA02_P
set_location_assignment PIN_E13  -to spi_sdi               ; ## D09 FMCA_HPC_LA01_CC_N
set_location_assignment PIN_A10  -to spi_csn_adc           ; ## C10 FMCA_HPC_LA06_P
set_location_assignment PIN_D13  -to spi_csn_clk           ; ## H08 FMCA_HPC_LA02_N -- PWDN_TO_FPGA

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adc
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_sdi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_sdo

# spi mirror to fmc_breakout

set_location_assignment PIN_AH12  -to spi_fmcbk_clk        ; ## D20 FMCB_HPC_LA17_CC_P
set_location_assignment PIN_AH13  -to spi_fmcbk_sdi        ; ## D21 FMCB_HPC_LA17_CC_N
set_location_assignment PIN_AK13  -to spi_fmcbk_csn        ; ## C22 FMCB_HPC_LA18_CC_P
set_location_assignment PIN_AJ13  -to spi_fmcbk_sdo        ; ## C23 FMCB_HPC_LA18_CC_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_fmckb_csn_adc
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_fmckb_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_fmckb_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_fmckb_sdi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_fmckb_sdo

execute_flow -compile

