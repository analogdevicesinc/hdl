
# ltc2387

set_property -dict {PACKAGE_PIN D18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports osc_clk_p]         ; ## G02  FMC_LPC_CLK1_M2C_P
set_property -dict {PACKAGE_PIN C19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports osc_clk_n]         ; ## G03  FMC_LPC_CLK1_M2C_N 
set_property -dict {PACKAGE_PIN M19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports out_clk_p]         ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports out_clk_n]         ; ## G07  FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN L18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_p]             ; ## H04  FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN L19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_n]             ; ## H05  FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN P17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_da_in_p]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_da_in_n]       ; ## H08  FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN M21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_db_in_p]       ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_db_in_n]       ; ## H11  FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN N19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports cnv_p]             ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports cnv_n]             ; ## D09  FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN L21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports muxcntrl]          ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN L22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports mux_en]            ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN N22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports pll_sync_fmc]      ; ## G09  FMC_LPC_LA03_P 

# clocks

create_clock -name adc_clk -period 66.666   [get_ports dco_p]
create_clock -name osc_clk -period 10.00    [get_ports osc_clk_p]

# Not used, extra options for conversion on schematic
# set_property -dict {PACKAGE_PIN P22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports cnv_en]            ; ## G10  FMC_LPC_LA03_N
# set_property -dict {PACKAGE_PIN J18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fpga_pll_cnv_p]    ; ## D11  FMC_LPC_LA05_P 
# set_property -dict {PACKAGE_PIN K18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fpga_pll_cnv_n]    ; ## D12  FMC_LPC_LA05_N 
