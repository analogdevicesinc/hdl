
# pluto_ng pinout

set_property -dict {PACKAGE_PIN J7 IOSTANDARD LVCMOS18} [get_ports gp_int]
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS18} [get_ports mode]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS18} [get_ports resetb]
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS18} [get_ports clksrc]

set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS18} [get_ports spi_di]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS18} [get_ports spi_do]
set_property -dict {PACKAGE_PIN M7 IOSTANDARD LVCMOS18} [get_ports spi_enb]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS18} [get_ports spi_clk]

set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS18} [get_ports usb_flash_prog_en]
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS18} [get_ports usb_pd_reset]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS18} [get_ports vin_poe_valid_n]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS18} [get_ports vin_usb2_valid_n]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS18} [get_ports vin_usb1_valid_n]

## MIPI camera # BANK 66 1V8

set_property -dict {PACKAGE_PIN H1 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports mipi_csi_clk_p]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports mipi_csi_clk_n]
set_property -dict {PACKAGE_PIN F4 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports {mipi_csi_data_p[0]}]
set_property -dict {PACKAGE_PIN E4 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports {mipi_csi_data_n[0]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports {mipi_csi_data_p[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD SLVS_400_18 DIFF_TERM_ADV TERM_100} [get_ports {mipi_csi_data_n[1]}]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS18} [get_ports mipi_csi_scl]
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS18} [get_ports mipi_csi_sda]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS18} [get_ports mipi_csi_phy_clk]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS18} [get_ports mipi_csi_pwup]

## ADRV9002 # BANK 65

set_property -dict {PACKAGE_PIN V1 IOSTANDARD LVCMOS18} [get_ports rx1_enable]
set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS18} [get_ports rx2_enable]
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS18} [get_ports tx1_enable]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS18} [get_ports tx2_enable]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_dclk_in_n]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_dclk_in_p]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_idata_in_n]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_idata_in_p]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_qdata_in_n]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_qdata_in_p]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_strobe_in_n]
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx1_strobe_in_p]

set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_dclk_in_n]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_dclk_in_p]
set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_idata_in_n]
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_idata_in_p]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_qdata_in_n]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_qdata_in_p]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_strobe_in_n]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx2_strobe_in_p]

set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVDS} [get_ports tx1_dclk_out_n]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVDS} [get_ports tx1_dclk_out_p]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx1_dclk_in_n]
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx1_dclk_in_p]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVDS} [get_ports tx1_idata_out_n]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVDS} [get_ports tx1_idata_out_p]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVDS} [get_ports tx1_qdata_out_n]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVDS} [get_ports tx1_qdata_out_p]
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVDS} [get_ports tx1_strobe_out_n]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVDS} [get_ports tx1_strobe_out_p]

set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVDS} [get_ports tx2_dclk_out_n]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVDS} [get_ports tx2_dclk_out_p]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx2_dclk_in_n]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx2_dclk_in_p]
set_property -dict {PACKAGE_PIN K5 IOSTANDARD LVDS} [get_ports tx2_idata_out_n]
set_property -dict {PACKAGE_PIN K6 IOSTANDARD LVDS} [get_ports tx2_idata_out_p]
set_property -dict {PACKAGE_PIN K7 IOSTANDARD LVDS} [get_ports tx2_qdata_out_n]
set_property -dict {PACKAGE_PIN L7 IOSTANDARD LVDS} [get_ports tx2_qdata_out_p]
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVDS} [get_ports tx2_strobe_out_n]
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVDS} [get_ports tx2_strobe_out_p]

# BANK 64

set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_ref_clk_n]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_ref_clk_p]

set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVDS} [get_ports dev_mcs_fpga_out_n]
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVDS} [get_ports dev_mcs_fpga_out_p]
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_mcs_in_n]
set_property -dict {PACKAGE_PIN Y5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_mcs_in_p]

set_property -dict {PACKAGE_PIN AE9 IOSTANDARD LVCMOS18} [get_ports adrv9002_mcssrc]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS18} [get_ports fan_en]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS18} [get_ports fan_ctl]


set_property -dict {PACKAGE_PIN AD6 IOSTANDARD LVCMOS18} [get_ports {dgpio[0]}]
set_property -dict {PACKAGE_PIN AD5 IOSTANDARD LVCMOS18} [get_ports {dgpio[1]}]
set_property -dict {PACKAGE_PIN AC9 IOSTANDARD LVCMOS18} [get_ports {dgpio[2]}]
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18} [get_ports {dgpio[3]}]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS18} [get_ports {dgpio[4]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS18} [get_ports {dgpio[5]}]
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports {dgpio[6]}]
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports {dgpio[7]}]
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18} [get_ports {dgpio[8]}]
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS18} [get_ports {dgpio[9]}]
set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVCMOS18} [get_ports {dgpio[10]}]
set_property -dict {PACKAGE_PIN AE4 IOSTANDARD LVCMOS18} [get_ports {dgpio[11]}]

#set_property  -dict {PACKAGE_PIN AB3   IOSTANDARD LVCMOS18}                      [get_ports adrv9002_dev_clk]  ; ## IO_L13P_64_ADRV9002_DEV_CLK_OUT
#set_property  -dict {PACKAGE_PIN W8    IOSTANDARD LVCMOS18}                      [get_ports  s_1pps]           ; ## IO_L10P_64_1PPS

set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVCMOS18} [get_ports rf_rx1a_mux_ctl]
set_property -dict {PACKAGE_PIN AD2 IOSTANDARD LVCMOS18} [get_ports rf_rx1b_mux_ctl]
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS18} [get_ports rf_rx2a_mux_ctl]
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS18} [get_ports rf_rx2b_mux_ctl]
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports rf_tx1_mux_ctl1]
set_property -dict {PACKAGE_PIN AD3 IOSTANDARD LVCMOS18} [get_ports rf_tx1_mux_ctl2]
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVCMOS18} [get_ports rf_tx2_mux_ctl1]
set_property -dict {PACKAGE_PIN AE1 IOSTANDARD LVCMOS18} [get_ports rf_tx2_mux_ctl2]

# EXTERNAL GPIO CONNECTOR # BANK 26 3V3

set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[0]}]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[1]}]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[2]}]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[3]}]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[4]}]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[5]}]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[6]}]
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[7]}]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[8]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[9]}]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[10]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[11]}]
set_property -dict {PACKAGE_PIN F9 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[12]}]
set_property -dict {PACKAGE_PIN E9 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[13]}]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[14]}]
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS33} [get_ports {ext_gpio[15]}]

# add-on board connector

# BANK 26 3V3

set_property -dict {PACKAGE_PIN H10 IOSTANDARD LVCMOS33} [get_ports {add_on[0]}]
set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVCMOS33} [get_ports {add_on[1]}]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports {add_on[2]}]
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports {add_on[3]}]
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports {add_on[4]}]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports {add_on[5]}]
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVCMOS33} [get_ports {add_on[6]}]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports {add_on[7]}]

# BANK 64 1V8

set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports {add_on[8]}]
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS18} [get_ports {add_on[9]}]
set_property -dict {PACKAGE_PIN AD8 IOSTANDARD LVCMOS18} [get_ports {add_on[10]}]
set_property -dict {PACKAGE_PIN AD7 IOSTANDARD LVCMOS18} [get_ports {add_on[11]}]
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS18} [get_ports {add_on[12]}]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS18} [get_ports {add_on[13]}]
set_property -dict {PACKAGE_PIN W1 IOSTANDARD LVCMOS18} [get_ports {add_on[14]}]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS18} [get_ports {add_on[15]}]

## connect to system management (monitor)

set_property -dict {PACKAGE_PIN G8 IOSTANDARD ANALOG} [get_ports s_1p0_rf_sns_p]
set_property -dict {PACKAGE_PIN F8 IOSTANDARD ANALOG} [get_ports s_1p0_rf_sns_n]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD ANALOG} [get_ports s_1p8_rf_sns_p]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD ANALOG} [get_ports s_1p8_rf_sns_n]
set_property -dict {PACKAGE_PIN G7 IOSTANDARD ANALOG} [get_ports s_1p3_rf_sns_p]
set_property -dict {PACKAGE_PIN F7 IOSTANDARD ANALOG} [get_ports s_1p3_rf_sns_n]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD ANALOG} [get_ports s_5v0_rf_sns_p]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD ANALOG} [get_ports s_5v0_rf_sns_n]
set_property -dict {PACKAGE_PIN C8 IOSTANDARD ANALOG} [get_ports s_2v5_sns_p]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD ANALOG} [get_ports s_2v5_sns_n]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD ANALOG} [get_ports s_vtt_ps_ddr4_sns_p]
set_property -dict {PACKAGE_PIN B5 IOSTANDARD ANALOG} [get_ports s_vtt_ps_ddr4_sns_n]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD ANALOG} [get_ports s_1v2_ps_ddr4_sns_p]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD ANALOG} [get_ports s_1v2_ps_ddr4_sns_n]

set_property -dict {PACKAGE_PIN G3 IOSTANDARD ANALOG} [get_ports s_0v85_mgtravcc_sns_p]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD ANALOG} [get_ports s_0v85_mgtravcc_sns_n]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD ANALOG} [get_ports s_5v0_sns_p]
set_property -dict {PACKAGE_PIN H3 IOSTANDARD ANALOG} [get_ports s_5v0_sns_n]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD ANALOG} [get_ports s_1v2_sns_p]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD ANALOG} [get_ports s_1v2_sns_n]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD ANALOG} [get_ports s_1v8_mgtravtt_sns_p]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD ANALOG} [get_ports s_1v8_mgtravtt_sns_n]

# clocks

create_clock -period 100.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]

create_clock -period 8.000 -name ref_clk [get_ports fpga_ref_clk_p]

create_clock -period 2.034 -name rx1_dclk_out [get_ports rx1_dclk_in_p]
create_clock -period 2.034 -name rx2_dclk_out [get_ports rx2_dclk_in_p]
create_clock -period 2.034 -name tx1_dclk_out [get_ports tx1_dclk_in_p]
create_clock -period 2.034 -name tx2_dclk_out [get_ports tx2_dclk_in_p]

create_clock -period 41.666 -name csi_phy_clk [get_ports mipi_csi_phy_clk]

