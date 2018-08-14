
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adrv9009_a10gx

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

# lane interface

set_location_assignment PIN_AL8   -to ref_clk0               ; ## D04  FMCA_GBTCLK0_M2C_P
set_location_assignment PIN_AL7   -to "ref_clk0(n)"          ; ## D05  FMCA_GBTCLK0_M2C_N
set_location_assignment PIN_AJ8   -to ref_clk1               ; ## B20  FMCA_GBTCLK1_M2C_P
set_location_assignment PIN_AJ7   -to "ref_clk1(n)"          ; ## B21  FMCA_GBTCLK1_M2C_N
set_location_assignment PIN_BA7   -to rx_serial_data[0]      ; ## A02  FMCA_DP1_M2C_P
set_location_assignment PIN_BA8   -to "rx_serial_data[0](n)" ; ## A03  FMCA_DP1_M2C_N
set_location_assignment PIN_AY5   -to rx_serial_data[1]      ; ## A06  FMCA_DP2_M2C_P
set_location_assignment PIN_AY6   -to "rx_serial_data[1](n)" ; ## A07  FMCA_DP2_M2C_N
set_location_assignment PIN_AW7   -to rx_serial_data[2]      ; ## C06  FMCA_DP0_M2C_P
set_location_assignment PIN_AW8   -to "rx_serial_data[2](n)" ; ## C07  FMCA_DP0_M2C_N
set_location_assignment PIN_AV5   -to rx_serial_data[3]      ; ## A10  FMCA_DP3_M2C_P
set_location_assignment PIN_AV6   -to "rx_serial_data[3](n)" ; ## A11  FMCA_DP3_M2C_N
set_location_assignment PIN_BD5   -to tx_serial_data[0]      ; ## A22  FMCA_DP1_C2M_P (tx_serial_data_p[0])
set_location_assignment PIN_BD6   -to "tx_serial_data[0](n)" ; ## A23  FMCA_DP1_C2M_N (tx_serial_data_n[0])
set_location_assignment PIN_BB5   -to tx_serial_data[1]      ; ## A26  FMCA_DP2_C2M_P (tx_serial_data_p[1])
set_location_assignment PIN_BB6   -to "tx_serial_data[1](n)" ; ## A27  FMCA_DP2_C2M_N (tx_serial_data_n[1])
set_location_assignment PIN_BC7   -to tx_serial_data[2]      ; ## C02  FMCA_DP0_C2M_P (tx_serial_data_p[2])
set_location_assignment PIN_BC8   -to "tx_serial_data[2](n)" ; ## C03  FMCA_DP0_C2M_N (tx_serial_data_n[2])
set_location_assignment PIN_BC3   -to tx_serial_data[3]      ; ## A30  FMCA_DP3_C2M_P (tx_serial_data_p[3])
set_location_assignment PIN_BC4   -to "tx_serial_data[3](n)" ; ## A31  FMCA_DP3_C2M_N (tx_serial_data_n[3])

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_data
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_data

set_instance_assignment -name IO_STANDARD LVDS -to ref_clk0
set_instance_assignment -name IO_STANDARD LVDS -to ref_clk1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data

# Merge RX and TX into single transceiver
for {set i 0} {$i < 4} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_serial_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_serial_data[${i}]
}

set_location_assignment PIN_AR20  -to rx_sync               ; ## G09  FMCA_HPC_LA03_P
set_location_assignment PIN_AR19  -to rx_sync(n)            ; ## G10  FMCA_HPC_LA03_N
set_location_assignment PIN_AY15  -to rx_os_sync            ; ## G27  FMCA_HPC_LA25_P (Sniffer)
set_location_assignment PIN_AY14  -to rx_os_sync(n)         ; ## G28  FMCA_HPC_LA25_N (Sniffer)
set_location_assignment PIN_AR22  -to tx_sync               ; ## H07  FMCA_HPC_LA02_P
set_location_assignment PIN_AT22  -to tx_sync(n)            ; ## H08  FMCA_HPC_LA02_N
set_location_assignment PIN_AV15  -to sysref                ; ## G06  FMC_HPC_LA00_CC_P
set_location_assignment PIN_AU15  -to sysref(n)             ; ## G07  FMC_HPC_LA00_CC_N
set_location_assignment PIN_BB15  -to tx_sync_1             ; ## H28  FMC_HPC_LA24_P
set_location_assignment PIN_BC15    -to tx_sync_1(n)          ; ## H29  FMC_HPC_LA24_N


set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to rx_os_sync
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to sysref
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref

set_location_assignment PIN_AV13  -to spi_csn_ad9528        ; ## D15  FMCA_HPC_LA09_N
set_location_assignment PIN_AW13  -to spi_csn_adrv9009      ; ## D14  FMCA_HPC_LA09_P
set_location_assignment PIN_AT17  -to spi_clk               ; ## H13  FMCA_HPC_LA07_P
set_location_assignment PIN_AU17  -to spi_mosi              ; ## H14  FMCA_HPC_LA07_N
set_location_assignment PIN_AP18  -to spi_miso              ; ## G12  FMCA_HPC_LA08_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_ad9528
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adrv9009
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

set_location_assignment PIN_AT19  -to ad9528_reset_b          ; ## D26  FMCA_HPC_LA26_P
set_location_assignment PIN_AT20  -to ad9528_sysref_req       ; ## D27  FMCA_HPC_LA26_N
set_location_assignment PIN_AR17  -to adrv9009_tx1_enable     ; ## D17  FMCA_HPC_LA13_P
set_location_assignment PIN_AW18  -to adrv9009_tx2_enable     ; ## C18  FMCA_HPC_LA14_P
set_location_assignment PIN_AP17  -to adrv9009_rx1_enable     ; ## D18  FMCA_HPC_LA13_N
set_location_assignment PIN_AV18  -to adrv9009_rx2_enable     ; ## C19  FMCA_HPC_LA14_N
set_location_assignment PIN_AT14  -to adrv9009_test           ; ## H16  FMC_HPC_LA11_P
set_location_assignment PIN_AN20  -to adrv9009_reset_b        ; ## H10  FMCA_HPC_LA04_P
set_location_assignment PIN_AP19  -to adrv9009_gpint          ; ## H11  FMCA_HPC_LA04_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_sysref_req
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_test
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpint

# single ended default

set_location_assignment PIN_AR9   -to adrv9009_gpio[0]        ; ## H19  FMCA_HPC_LA15_P
set_location_assignment PIN_AT9   -to adrv9009_gpio[1]        ; ## H20  FMCA_HPC_LA15_N
set_location_assignment PIN_AT13  -to adrv9009_gpio[2]        ; ## G18  FMCA_HPC_LA16_P
set_location_assignment PIN_AU13  -to adrv9009_gpio[3]        ; ## G19  FMCA_HPC_LA16_N
set_location_assignment PIN_AY10  -to adrv9009_gpio[4]        ; ## H25  FMCA_HPC_LA21_P
set_location_assignment PIN_AY11  -to adrv9009_gpio[5]        ; ## H26  FMCA_HPC_LA21_N
set_location_assignment PIN_AU21  -to adrv9009_gpio[6]        ; ## C22  FMCA_HPC_LA18_CC_P
set_location_assignment PIN_AV21  -to adrv9009_gpio[7]        ; ## C23  FMCA_HPC_LA18_CC_N
set_location_assignment PIN_AY12  -to adrv9009_gpio[8]        ; ## G25  FMCA_HPC_LA22_N     (LVDS_1N)
set_location_assignment PIN_AU11  -to adrv9009_gpio[9]        ; ## H22  FMCA_HPC_LA19_P     (LVDS_2P)
set_location_assignment PIN_AU12  -to adrv9009_gpio[10]       ; ## H23  FMCA_HPC_LA19_N     (LVDS_2N)
set_location_assignment PIN_AU8   -to adrv9009_gpio[11]       ; ## G21  FMCA_HPC_LA20_P     (LVDS_3P)
set_location_assignment PIN_AT8   -to adrv9009_gpio[12]       ; ## G22  FMCA_HPC_LA20_N     (LVDS_3N)
set_location_assignment PIN_AP16  -to adrv9009_gpio[13]       ; ## G16  FMC_HPC_LA12_N     (LVDS_4N)
set_location_assignment PIN_AR16  -to adrv9009_gpio[14]       ; ## G15  FMC_HPC_LA12_P     (LVDS_4P)
set_location_assignment PIN_AW12  -to adrv9009_gpio[15]       ; ## G24  FMCA_HPC_LA22_P     (LVDS_1P)
set_location_assignment PIN_AW14  -to adrv9009_gpio[16]       ; ## C11  FMC_HPC_LA06_N     (LVDS_5N)
set_location_assignment PIN_AV14  -to adrv9009_gpio[17]       ; ## C10  FMC_HPC_LA06_P     (LVDS_5P)
set_location_assignment PIN_AW11  -to adrv9009_gpio[18]       ; ## D12  FMCA_HPC_LA05_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[18]

# set optimization to get a better timing closure
#set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
