
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_alt.tcl

adi_project_altera usdrx1_a10gx

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../common/usdrx1_spi.v
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_sysref_gen.v

# lane interface

set_location_assignment PIN_AL8   -to ref_clk               ; ## D04 FMCA_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_AL7   -to "ref_clk(n)"          ; ## D05 FMCA_HPC_GBTCLK0_M2C_N
set_location_assignment PIN_AW7   -to rx_data[0]            ; ## C06 FMCA_HPC_DP00_M2C_P
set_location_assignment PIN_AW8   -to "rx_data[0](n)"       ; ## C07 FMCA_HPC_DP00_M2C_N
set_location_assignment PIN_BA7   -to rx_data[1]            ; ## A02 FMCA_HPC_DP01_M2C_P
set_location_assignment PIN_BA8   -to "rx_data[1](n)"       ; ## A03 FMCA_HPC_DP01_M2C_N
set_location_assignment PIN_AY5   -to rx_data[2]            ; ## A06 FMCA_HPC_DP02_M2C_P
set_location_assignment PIN_AY6   -to "rx_data[2](n)"       ; ## A07 FMCA_HPC_DP02_M2C_N
set_location_assignment PIN_AV5   -to rx_data[3]            ; ## A10 FMCA_HPC_DP03_M2C_P
set_location_assignment PIN_AV6   -to "rx_data[3](n)"       ; ## A11 FMCA_HPC_DP03_M2C_N
set_location_assignment PIN_AT5   -to rx_data[4]            ; ## A14 FMCA_HPC_DP04_M2C_P
set_location_assignment PIN_AT6   -to "rx_data[4](n)"       ; ## A15 FMCA_HPC_DP04_M2C_N
set_location_assignment PIN_AP5   -to rx_data[5]            ; ## A18 FMCA_HPC_DP05_M2C_P
set_location_assignment PIN_AP6   -to "rx_data[5](n)"       ; ## A19 FMCA_HPC_DP05_M2C_N
set_location_assignment PIN_AN3   -to rx_data[6]            ; ## B16 FMCA_HPC_DP06_M2C_P
set_location_assignment PIN_AN4   -to "rx_data[6](n)"       ; ## B17 FMCA_HPC_DP06_M2C_N
set_location_assignment PIN_AM5   -to rx_data[7]            ; ## B12 FMCA_HPC_DP07_M2C_P
set_location_assignment PIN_AM6   -to "rx_data[7](n)"       ; ## B13 FMCA_HPC_DP07_M2C_N
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to ref_clk
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[3]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[4]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[5]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[6]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[7]

# sysref & sync

set_location_assignment PIN_AU18  -to rx_sysref             ; ## D23 FMCA_HPC_LA23_P
set_location_assignment PIN_AT18  -to "rx_sysref(n)"        ; ## D24 FMCA_HPC_LA23_N
set_location_assignment PIN_AT19  -to rx_sync               ; ## D26 FMCA_HPC_LA26_P
set_location_assignment PIN_AT20  -to "rx_sync(n)"          ; ## D27 FMCA_HPC_LA26_N
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync

# mlo, reset & trigger

set_location_assignment PIN_AV19  -to afe_mlo               ; ## D20 FMCA_HPC_LA17_CC_P
set_location_assignment PIN_AW19  -to "afe_mlo(n)"          ; ## D21 FMCA_HPC_LA17_CC_N
set_location_assignment PIN_AY15  -to afe_rst               ; ## G27 FMCA_HPC_LA25_P
set_location_assignment PIN_AY14  -to "afe_rst(n)"          ; ## G28 FMCA_HPC_LA25_N
set_location_assignment PIN_BB15  -to afe_trig              ; ## H28 FMCA_HPC_LA24_P
set_location_assignment PIN_BC15  -to "afe_trig(n)"         ; ## H29 FMCA_HPC_LA24_N
set_instance_assignment -name IO_STANDARD LVDS -to afe_mlo
set_instance_assignment -name IO_STANDARD LVDS -to afe_rst
set_instance_assignment -name IO_STANDARD LVDS -to afe_trig

# spi, gpio & misc
# remove termination resistor on D08 & D09
# D08 FMCA_HPC_LA01_CC_P PIN_AT10 LVDS fmca_la_rx_clk_p[1] (3C)
# D09 FMCA_HPC_LA01_CC_N PIN_AR11 LVDS fmca_la_rx_clk_n[1] (3C)

set_location_assignment PIN_AR15  -to spi_fout_enb_clk      ; ## C14 FMCA_HPC_LA10_P
set_location_assignment PIN_AT15  -to spi_fout_enb_mlo      ; ## C15 FMCA_HPC_LA10_N
set_location_assignment PIN_AW18  -to spi_fout_enb_rst      ; ## C18 FMCA_HPC_LA14_P
set_location_assignment PIN_AV18  -to spi_fout_enb_sync     ; ## C19 FMCA_HPC_LA14_N
set_location_assignment PIN_AU21  -to spi_fout_enb_sysref   ; ## C22 FMCA_HPC_LA18_CC_P
set_location_assignment PIN_AV21  -to spi_fout_enb_trig     ; ## C23 FMCA_HPC_LA18_CC_N
set_location_assignment PIN_AV14  -to spi_fout_clk          ; ## C10 FMCA_HPC_LA06_P
set_location_assignment PIN_AW14  -to spi_fout_sdio         ; ## C11 FMCA_HPC_LA06_N
set_location_assignment PIN_AV11  -to spi_afe_csn[0]        ; ## D11 FMCA_HPC_LA05_P
set_location_assignment PIN_AW11  -to spi_afe_csn[1]        ; ## D12 FMCA_HPC_LA05_N
set_location_assignment PIN_AW13  -to spi_afe_csn[2]        ; ## D14 FMCA_HPC_LA09_P
set_location_assignment PIN_AV13  -to spi_afe_csn[3]        ; ## D15 FMCA_HPC_LA09_N
set_location_assignment PIN_AT10  -to spi_afe_clk           ; ## D08 FMCA_HPC_LA01_CC_P
set_location_assignment PIN_AR11  -to spi_afe_sdio          ; ## D09 FMCA_HPC_LA01_CC_N
set_location_assignment PIN_AR19  -to spi_clk_csn           ; ## G10 FMCA_HPC_LA03_N
set_location_assignment PIN_AN19  -to spi_clk_clk           ; ## G13 FMCA_HPC_LA08_N
set_location_assignment PIN_AP18  -to spi_clk_sdio          ; ## G12 FMCA_HPC_LA08_P
set_location_assignment PIN_AR17  -to afe_pdn               ; ## D17 FMCA_HPC_LA13_P
set_location_assignment PIN_AP17  -to afe_stby              ; ## D18 FMCA_HPC_LA13_N
set_location_assignment PIN_AP16  -to clk_resetn            ; ## G16 FMCA_HPC_LA12_N
set_location_assignment PIN_AR16  -to clk_syncn             ; ## G15 FMCA_HPC_LA12_P
set_location_assignment PIN_AT13  -to clk_status            ; ## G18 FMCA_HPC_LA16_P
set_location_assignment PIN_AU13  -to amp_disbn             ; ## G19 FMCA_HPC_LA16_N
set_location_assignment PIN_AU8   -to prc_sck               ; ## G21 FMCA_HPC_LA20_P
set_location_assignment PIN_AT8   -to prc_cnv               ; ## G22 FMCA_HPC_LA20_N
set_location_assignment PIN_AW12  -to prc_sdo_i             ; ## G24 FMCA_HPC_LA22_P
set_location_assignment PIN_AY12  -to prc_sdo_q             ; ## G25 FMCA_HPC_LA22_N
set_location_assignment PIN_AR20  -to dac_sleep             ; ## G09 FMCA_HPC_LA03_P
set_location_assignment PIN_AY11  -to dac_data[0]           ; ## H26 FMCA_HPC_LA21_N
set_location_assignment PIN_AY10  -to dac_data[1]           ; ## H25 FMCA_HPC_LA21_P
set_location_assignment PIN_AU12  -to dac_data[2]           ; ## H23 FMCA_HPC_LA19_N
set_location_assignment PIN_AU11  -to dac_data[3]           ; ## H22 FMCA_HPC_LA19_P
set_location_assignment PIN_AT9   -to dac_data[4]           ; ## H20 FMCA_HPC_LA15_N
set_location_assignment PIN_AR9   -to dac_data[5]           ; ## H19 FMCA_HPC_LA15_P
set_location_assignment PIN_AR14  -to dac_data[6]           ; ## H17 FMCA_HPC_LA11_N
set_location_assignment PIN_AT14  -to dac_data[7]           ; ## H16 FMCA_HPC_LA11_P
set_location_assignment PIN_AU17  -to dac_data[8]           ; ## H14 FMCA_HPC_LA07_N
set_location_assignment PIN_AT17  -to dac_data[9]           ; ## H13 FMCA_HPC_LA07_P
set_location_assignment PIN_AP19  -to dac_data[10]          ; ## H11 FMCA_HPC_LA04_N
set_location_assignment PIN_AN20  -to dac_data[11]          ; ## H10 FMCA_HPC_LA04_P
set_location_assignment PIN_AT22  -to dac_data[12]          ; ## H08 FMCA_HPC_LA02_N
set_location_assignment PIN_AR22  -to dac_data[13]          ; ## H07 FMCA_HPC_LA02_P

execute_flow -compile

