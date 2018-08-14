
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project daq2_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../common/daq2_spi.v

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

set_location_assignment PIN_R29   -to rx_ref_clk            ; ## B20  FMCA_HPC_GBTCLK1_M2C_P
set_location_assignment PIN_R28   -to "rx_ref_clk(n)"       ; ## B21  FMCA_HPC_GBTCLK1_M2C_N

set_location_assignment PIN_P31   -to rx_serial_data[0]     ; ## A10  FMCA_HPC_DP3_M2C_P
set_location_assignment PIN_P30   -to "rx_serial_data[0](n)"; ## A11  FMCA_HPC_DP3_M2C_N
set_location_assignment PIN_T31   -to rx_serial_data[1]     ; ## C06  FMCA_HPC_DP0_M2C_P
set_location_assignment PIN_T30   -to "rx_serial_data[1](n)"; ## C07  FMCA_HPC_DP0_M2C_N
set_location_assignment PIN_P35   -to rx_serial_data[2]     ; ## A06  FMCA_HPC_DP2_M2C_P
set_location_assignment PIN_P34   -to "rx_serial_data[2](n)"; ## A07  FMCA_HPC_DP2_M2C_N
set_location_assignment PIN_R33   -to rx_serial_data[3]     ; ## A02  FMCA_HPC_DP1_M2C_P
set_location_assignment PIN_R32   -to "rx_serial_data[3](n)"; ## A03  FMCA_HPC_DP1_M2C_N
set_location_assignment PIN_E12   -to rx_sync               ; ## D08  FMCA_HPC_LA01_CC_P
set_location_assignment PIN_E13   -to "rx_sync(n)"          ; ## D09  FMCA_HPC_LA01_CC_N
set_location_assignment PIN_C14   -to rx_sysref             ; ## G09  FMCA_HPC_LA03_P
set_location_assignment PIN_D14   -to "rx_sysref(n)"        ; ## G10  FMCA_HPC_LA03_N

set_location_assignment PIN_N29   -to tx_ref_clk            ; ## D04  FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "tx_ref_clk(n)"       ; ## D05  FMCA_HPC_GBTCLK0_M2C_N

set_location_assignment PIN_K39   -to tx_serial_data[0]     ; ## A30  FMCA_HPC_DP3_C2M_P (tx_data_p[0])
set_location_assignment PIN_K38   -to "tx_serial_data[0](n)"; ## A31  FMCA_HPC_DP3_C2M_N (tx_data_n[0])
set_location_assignment PIN_N37   -to tx_serial_data[1]     ; ## C02  FMCA_HPC_DP0_C2M_P (tx_data_p[3])
set_location_assignment PIN_N36   -to "tx_serial_data[1](n)"; ## C03  FMCA_HPC_DP0_C2M_N (tx_data_n[3])
set_location_assignment PIN_L37   -to tx_serial_data[2]     ; ## A26  FMCA_HPC_DP2_C2M_P (tx_data_p[1])
set_location_assignment PIN_L36   -to "tx_serial_data[2](n)"; ## A27  FMCA_HPC_DP2_C2M_N (tx_data_n[1])
set_location_assignment PIN_M39   -to tx_serial_data[3]     ; ## A22  FMCA_HPC_DP1_C2M_P (tx_data_p[2])
set_location_assignment PIN_M38   -to "tx_serial_data[3](n)"; ## A23  FMCA_HPC_DP1_C2M_N (tx_data_n[2])
set_location_assignment PIN_C13   -to tx_sync               ; ## H07  FMCA_HPC_LA02_P
set_location_assignment PIN_D13   -to "tx_sync(n)"          ; ## H08  FMCA_HPC_LA02_N
set_location_assignment PIN_H12   -to tx_sysref             ; ## H10  FMCA_HPC_LA04_P
set_location_assignment PIN_H13   -to "tx_sysref(n)"        ; ## H11  FMCA_HPC_LA04_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "rx_ref_clk(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sync(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to "rx_sysref(n)"
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_sysref

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

# Merge RX and TX into single transceiver
for {set i 0} {$i < 4} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_serial_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_serial_data[${i}]
}

# gpio

set_location_assignment PIN_A9   -to trig                  ; ## H13  FMCA_LA07_P
set_location_assignment PIN_B9   -to "trig(n)"             ; ## H14  FMCA_LA07_N
set_location_assignment PIN_D9   -to adc_fdb               ; ## H17  FMCA_LA11_N
set_location_assignment PIN_C9   -to adc_fda               ; ## H16  FMCA_LA11_P
set_location_assignment PIN_M12  -to dac_irq               ; ## G15  FMCA_LA12_P
set_location_assignment PIN_K11  -to clkd_status[1]        ; ## D18  FMCA_LA13_N
set_location_assignment PIN_J11  -to clkd_status[0]        ; ## D17  FMCA_LA13_P
set_location_assignment PIN_A10  -to adc_pd                ; ## C10  FMCA_LA06_P
set_location_assignment PIN_N13  -to dac_txen              ; ## G16  FMCA_LA12_N
set_location_assignment PIN_A8   -to dac_reset             ; ## C15  FMCA_LA10_N
set_location_assignment PIN_B11  -to clkd_sync             ; ## G12  FMCA_LA08_P

set_instance_assignment -name IO_STANDARD LVDS -to trig
set_instance_assignment -name IO_STANDARD LVDS -to "trig(n)"
set_instance_assignment -name IO_STANDARD "1.8 V" -to adc_fdb
set_instance_assignment -name IO_STANDARD "1.8 V" -to adc_fda
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_irq
set_instance_assignment -name IO_STANDARD "1.8 V" -to clkd_status[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to clkd_status[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adc_pd
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_txen
set_instance_assignment -name IO_STANDARD "1.8 V" -to dac_reset
set_instance_assignment -name IO_STANDARD "1.8 V" -to clkd_sync

# spi

set_location_assignment PIN_F13  -to spi_csn_clk           ; ## D11  FMCA_LA05_P
set_location_assignment PIN_A7   -to spi_csn_dac           ; ## C14  FMCA_LA10_P
set_location_assignment PIN_A13  -to spi_csn_adc           ; ## D15  FMCA_LA09_N
set_location_assignment PIN_F14  -to spi_clk               ; ## D12  FMCA_LA05_N
set_location_assignment PIN_A12  -to spi_sdio              ; ## D14  FMCA_LA09_P
set_location_assignment PIN_B12  -to spi_dir               ; ## G13  FMCA_LA08_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_dac
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adc
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_sdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_dir

execute_flow -compile
