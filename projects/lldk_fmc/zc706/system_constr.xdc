
# lldk

# rx_clk

set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVDS_25} [get_ports rx_clk_p[3]]                 ; ## D23  FMC_LA23_P     IO_L24P_T3_12
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVDS_25} [get_ports rx_clk_n[3]]                 ; ## D24  FMC_LA23_N     IO_L24N_T3_12
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVDS_25} [get_ports rx_clk_p[2]]                 ; ## H22  FMC_LA19_P     IO_L23P_T3_12
set_property -dict {PACKAGE_PIN AH27 IOSTANDARD LVDS_25} [get_ports rx_clk_n[2]]                 ; ## H23  FMC_LA19_N     IO_L23N_T3_12
set_property -dict {PACKAGE_PIN AE16 IOSTANDARD LVDS_25} [get_ports rx_clk_p[1]]                 ; ## D11  FMC_LA05_P     IO_L16P_T2_10
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVDS_25} [get_ports rx_clk_n[1]]                 ; ## D12  FMC_LA05_N     IO_L16N_T2_10
set_property -dict {PACKAGE_PIN AJ15 IOSTANDARD LVDS_25} [get_ports rx_clk_p[0]]                 ; ## H10  FMC_LA04_P     IO_L5P_T0_10
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVDS_25} [get_ports rx_clk_n[0]]                 ; ## H11  FMC_LA04_N     IO_L5N_T0_10

# rx_cnv

set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVDS_25} [get_ports rx_cnv_p[3]]                 ; ## H28  FMC_LA24_P     IO_L16P_T2_12
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVDS_25} [get_ports rx_cnv_n[3]]                 ; ## H29  FMC_LA24_N     IO_L16N_T2_12
set_property -dict {PACKAGE_PIN AG26 IOSTANDARD LVDS_25} [get_ports rx_cnv_p[2]]                 ; ## G21  FMC_LA20_P     IO_L17P_T2_12
set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVDS_25} [get_ports rx_cnv_n[2]]                 ; ## G22  FMC_LA20_N     IO_L17N_T2_12
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVDS_25} [get_ports rx_cnv_p[1]]                 ; ## C10  FMC_LA06_P     IO_L21P_T3_DQS_10
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVDS_25} [get_ports rx_cnv_n[1]]                 ; ## C11  FMC_LA06_N     IO_L21N_T3_DQS_10
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVDS_25} [get_ports rx_cnv_p[0]]                 ; ## G12  FMC_LA08_P     IO_L9P_T1_DQS_10
set_property -dict {PACKAGE_PIN AD13 IOSTANDARD LVDS_25} [get_ports rx_cnv_n[0]]                 ; ## G13  FMC_LA08_N     IO_L9N_T1_DQS_10

# rx_dco

set_property -dict {PACKAGE_PIN AE27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_p[3]]  ; ## C22  FMC_LA18_CC_P  IO_L14P_T2_SRCC_12
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_n[3]]  ; ## C23  FMC_LA18_CC_N  IO_L14N_T2_SRCC_12
set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_p[2]]  ; ## D20  FMC_LA17_CC_P  IO_L11P_T1_SRCC_12
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_n[2]]  ; ## D21  FMC_LA17_CC_N  IO_L11N_T1_SRCC_12
set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_p[1]]  ; ## D8   FMC_LA01_CC_P  IO_L14P_T2_SRCC_10
set_property -dict {PACKAGE_PIN AG15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_n[1]]  ; ## D9   FMC_LA01_CC_N  IO_L14N_T2_SRCC_10
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_p[0]]  ; ## G6   FMC_LA00_CC_P  IO_L11P_T1_SRCC_10
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_dco_n[0]]  ; ## G7   FMC_LA00_CC_N  IO_L11N_T1_SRCC_10

# rx_da

set_property -dict {PACKAGE_PIN AF29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_p[3]]   ; ## G27  FMC_LA25_P     IO_L15P_T2_DQS_12
set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_n[3]]   ; ## G28  FMC_LA25_N     IO_L15N_T2_DQS_12
set_property -dict {PACKAGE_PIN AH28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_p[2]]   ; ## H25  FMC_LA21_P     IO_L19P_T3_12
set_property -dict {PACKAGE_PIN AH29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_n[2]]   ; ## H26  FMC_LA21_N     IO_L19N_T3_VREF_12
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_p[1]]   ; ## H13  FMC_LA07_P     IO_L20P_T3_10
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_n[1]]   ; ## H14  FMC_LA07_N     IO_L20N_T3_10
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_p[0]]   ; ## H7   FMC_LA02_P     IO_L7P_T1_10
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_da_n[0]]   ; ## H8   FMC_LA02_N     IO_L7N_T1_10

# rx_db

set_property -dict {PACKAGE_PIN AJ30 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_p[3]]   ; ## D26  FMC_LA26_P     IO_L20P_T3_12
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_n[3]]   ; ## D27  FMC_LA26_N     IO_L20N_T3_12
set_property -dict {PACKAGE_PIN AK27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_p[2]]   ; ## G24  FMC_LA22_P     IO_L22P_T3_12
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_n[2]]   ; ## G25  FMC_LA22_N     IO_L22N_T3_12
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_p[1]]   ; ## D14  FMC_LA09_P     IO_L8P_T1_10
set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_n[1]]   ; ## D15  FMC_LA09_N     IO_L8N_T1_10
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_p[0]]   ; ## G9   FMC_LA03_P     IO_L10P_T1_10
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_db_n[0]]   ; ## G10  FMC_LA03_N     IO_L10N_T1_10

# dac spi

set_property -dict {PACKAGE_PIN AJ29 IOSTANDARD LVCMOS25} [get_ports dac_sclk[1]]                ; ## C27  FMC_LA27_N     IO_L21N_T3_DQS_12
set_property -dict {PACKAGE_PIN AC13 IOSTANDARD LVCMOS25} [get_ports dac_sclk[0]]                ; ## C15  FMC_LA10_N     IO_L19N_T3_VREF_10
set_property -dict {PACKAGE_PIN AJ28 IOSTANDARD LVCMOS25} [get_ports dac_cs[1]]                  ; ## C26  FMC_LA27_P     IO_L21P_T3_DQS_12
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS25} [get_ports dac_cs[0]]                  ; ## C14  FMC_LA10_P     IO_L19P_T3_10
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS25} [get_ports dac_sdio3[1]]               ; ## G31  FMC_LA29_N     IO_L18N_T2_12
set_property -dict {PACKAGE_PIN AD15 IOSTANDARD LVCMOS25} [get_ports dac_sdio3[0]]               ; ## G16  FMC_LA12_N     IO_L18N_T2_10
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS25} [get_ports dac_sdio2[1]]               ; ## G30  FMC_LA29_P     IO_L18P_T2_12
set_property -dict {PACKAGE_PIN AD16 IOSTANDARD LVCMOS25} [get_ports dac_sdio2[0]]               ; ## G15  FMC_LA12_P     IO_L18P_T2_10
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS25} [get_ports dac_sdio1[1]]               ; ## H32  FMC_LA28_N     IO_L10N_T1_12
set_property -dict {PACKAGE_PIN AK16 IOSTANDARD LVCMOS25} [get_ports dac_sdio1[0]]               ; ## H17  FMC_LA11_N     IO_L4N_T0_10
set_property -dict {PACKAGE_PIN AD25 IOSTANDARD LVCMOS25} [get_ports dac_sdio0[1]]               ; ## H31  FMC_LA28_P     IO_L10P_T1_12
set_property -dict {PACKAGE_PIN AJ16 IOSTANDARD LVCMOS25} [get_ports dac_sdio0[0]]               ; ## H16  FMC_LA11_P     IO_L4P_T0_10

# spi

set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS25} [get_ports spi_miso]                   ; ## D17  FMC_LA13_P     IO_L6P_T0_10
set_property -dict {PACKAGE_PIN AH16 IOSTANDARD LVCMOS25} [get_ports spi_mosi]                   ; ## D18  FMC_LA13_N     IO_L6N_T0_VREF_10
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS25} [get_ports spi_sck]                    ; ## H19  FMC_LA15_P     IO_L22P_T3_10
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS25} [get_ports spi_csb]                    ; ## H20  FMC_LA15_N     IO_L22N_T3_10

# control signals

set_property -dict {PACKAGE_PIN Y26  IOSTANDARD LVCMOS25} [get_ports direction]                  ; ## H37  FMC_LA32_P     IO_L3P_T0_DQS_12
set_property -dict {PACKAGE_PIN Y27  IOSTANDARD LVCMOS25} [get_ports reset]                      ; ## H38  FMC_LA32_N     IO_L3N_T0_DQS_12
set_property -dict {PACKAGE_PIN Y30  IOSTANDARD LVCMOS25} [get_ports alert_2]                    ; ## G36  FMC_LA33_P     IO_L1P_T0_12
set_property -dict {PACKAGE_PIN AE18 IOSTANDARD LVCMOS25} [get_ports alert_1]                    ; ## G18  FMC_LA16_P     IO_L17P_T2_10
set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS25} [get_ports ldac_2]                     ; ## G37  FMC_LA33_N     IO_L1N_T0_12
set_property -dict {PACKAGE_PIN AE17 IOSTANDARD LVCMOS25} [get_ports ldac_1]                     ; ## G19  FMC_LA16_N     IO_L17N_T2_10

# clocks

set clk_period 8.333
set data_delay 0.200

create_clock -period $clk_period -name dco_0 [get_ports rx_dco_p[0]]
create_clock -period $clk_period -name dco_1 [get_ports rx_dco_p[1]]
create_clock -period $clk_period -name dco_2 [get_ports rx_dco_p[2]]
create_clock -period $clk_period -name dco_3 [get_ports rx_dco_p[3]]

set_input_delay -clock dco_0 -max  $data_delay [get_ports rx_da_p[0]]
set_input_delay -clock dco_0 -min -$data_delay [get_ports rx_da_p[0]]
set_input_delay -clock dco_0 -clock_fall -max -add_delay  $data_delay [get_ports rx_da_p[0]]
set_input_delay -clock dco_0 -clock_fall -min -add_delay -$data_delay [get_ports rx_da_p[0]]
set_input_delay -clock dco_0 -max  $data_delay [get_ports rx_db_p[0]]
set_input_delay -clock dco_0 -min -$data_delay [get_ports rx_db_p[0]]
set_input_delay -clock dco_0 -clock_fall -max -add_delay  $data_delay [get_ports rx_db_p[0]]
set_input_delay -clock dco_0 -clock_fall -min -add_delay -$data_delay [get_ports rx_db_p[0]]

set_input_delay -clock dco_1 -max  $data_delay [get_ports rx_da_p[1]]
set_input_delay -clock dco_1 -min -$data_delay [get_ports rx_da_p[1]]
set_input_delay -clock dco_1 -clock_fall -max -add_delay  $data_delay [get_ports rx_da_p[1]]
set_input_delay -clock dco_1 -clock_fall -min -add_delay -$data_delay [get_ports rx_da_p[1]]
set_input_delay -clock dco_1 -max  $data_delay [get_ports rx_db_p[1]]
set_input_delay -clock dco_1 -min -$data_delay [get_ports rx_db_p[1]]
set_input_delay -clock dco_1 -clock_fall -max -add_delay  $data_delay [get_ports rx_db_p[1]]
set_input_delay -clock dco_1 -clock_fall -min -add_delay -$data_delay [get_ports rx_db_p[1]]

set_input_delay -clock dco_2 -max  $data_delay [get_ports rx_da_p[2]]
set_input_delay -clock dco_2 -min -$data_delay [get_ports rx_da_p[2]]
set_input_delay -clock dco_2 -clock_fall -max -add_delay  $data_delay [get_ports rx_da_p[2]]
set_input_delay -clock dco_2 -clock_fall -min -add_delay -$data_delay [get_ports rx_da_p[2]]
set_input_delay -clock dco_2 -max  $data_delay [get_ports rx_db_p[2]]
set_input_delay -clock dco_2 -min -$data_delay [get_ports rx_db_p[2]]
set_input_delay -clock dco_2 -clock_fall -max -add_delay  $data_delay [get_ports rx_db_p[2]]
set_input_delay -clock dco_2 -clock_fall -min -add_delay -$data_delay [get_ports rx_db_p[2]]

set_input_delay -clock dco_3 -max  $data_delay [get_ports rx_da_p[3]]
set_input_delay -clock dco_3 -min -$data_delay [get_ports rx_da_p[3]]
set_input_delay -clock dco_3 -clock_fall -max -add_delay  $data_delay [get_ports rx_da_p[3]]
set_input_delay -clock dco_3 -clock_fall -min -add_delay -$data_delay [get_ports rx_da_p[3]]
set_input_delay -clock dco_3 -max  $data_delay [get_ports rx_db_p[3]]
set_input_delay -clock dco_3 -min -$data_delay [get_ports rx_db_p[3]]
set_input_delay -clock dco_3 -clock_fall -max -add_delay  $data_delay [get_ports rx_db_p[3]]
set_input_delay -clock dco_3 -clock_fall -min -add_delay -$data_delay [get_ports rx_db_p[3]]

set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_0/inst/i_if/i_rx_da/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_0/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_1/inst/i_if/i_rx_da/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_1/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_2/inst/i_if/i_rx_da/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387_2/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 28 [get_cells i_system_wrapper/system_i/axi_ltc2387_3/inst/i_if/i_rx_da/i_rx_data_idelay]
set_property IDELAY_VALUE 28 [get_cells i_system_wrapper/system_i/axi_ltc2387_3/inst/i_if/i_rx_db/i_rx_data_idelay]




#create_generated_clock -name dco_0 [get_ports rx_clk_p[0]]
#create_generated_clock -name dco_1 [get_ports rx_clk_p[1]]
#create_generated_clock -name dco_2 [get_ports rx_clk_p[2]]
#create_generated_clock -name dco_3 [get_ports rx_clk_p[3]]
#
#create_generated_clock -name dco_0 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[0]] -objects [get_ports rx_clk_p[0]]
#create_generated_clock -name dco_1 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[1]] -objects [get_ports rx_clk_p[1]]
#create_generated_clock -name dco_2 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[2]] -objects [get_ports rx_clk_p[2]]
#create_generated_clock -name dco_3 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[3]] -objects [get_ports rx_clk_p[3]]
