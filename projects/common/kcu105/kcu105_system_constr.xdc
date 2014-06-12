
# constraints

set_property -dict  {PACKAGE_PIN  AN8   IOSTANDARD  LVCMOS18} [get_ports sys_rst] 

set_false_path -through [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  AK17  IOSTANDARD  DIFF_SSTL12_DCI ODT RTT_48} [get_ports sys_clk_p] 
set_property -dict  {PACKAGE_PIN  AK16  IOSTANDARD  DIFF_SSTL12_DCI ODT RTT_48} [get_ports sys_clk_n]

create_clock -name sys_clk      -period  3.33 [get_ports sys_clk_p]

set_property -dict  {PACKAGE_PIN  G10   IOSTANDARD  LVDS DIFF_TERM TRUE} [get_ports sys_125m_clk_p] 
set_property -dict  {PACKAGE_PIN  F10   IOSTANDARD  LVDS DIFF_TERM TRUE} [get_ports sys_125m_clk_n] 

create_clock -name sys_clk      -period  8.00 [get_ports sys_125m_clk_p]

# ddr

set_property -dict  {PACKAGE_PIN  AH14  IOSTANDARD  SSTL12}     [get_ports ddr4_act_n] 
set_property -dict  {PACKAGE_PIN  AE17  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[0]] 
set_property -dict  {PACKAGE_PIN  AH17  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[1]] 
set_property -dict  {PACKAGE_PIN  AE18  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[2]] 
set_property -dict  {PACKAGE_PIN  AJ15  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[3]] 
set_property -dict  {PACKAGE_PIN  AG16  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[4]] 
set_property -dict  {PACKAGE_PIN  AL17  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[5]] 
set_property -dict  {PACKAGE_PIN  AK18  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[6]] 
set_property -dict  {PACKAGE_PIN  AG17  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[7]] 
set_property -dict  {PACKAGE_PIN  AF18  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[8]] 
set_property -dict  {PACKAGE_PIN  AH19  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[9]] 
set_property -dict  {PACKAGE_PIN  AF15  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[10]] 
set_property -dict  {PACKAGE_PIN  AD19  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[11]] 
set_property -dict  {PACKAGE_PIN  AJ14  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[12]] 
set_property -dict  {PACKAGE_PIN  AG19  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[13]] 
set_property -dict  {PACKAGE_PIN  AD16  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[14]] 
set_property -dict  {PACKAGE_PIN  AG14  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[15]] 
set_property -dict  {PACKAGE_PIN  AF14  IOSTANDARD  SSTL12}     [get_ports ddr4_addr[16]] 
set_property -dict  {PACKAGE_PIN  AF17  IOSTANDARD  SSTL12}     [get_ports ddr4_ba[0]] 
set_property -dict  {PACKAGE_PIN  AL15  IOSTANDARD  SSTL12}     [get_ports ddr4_ba[1]] 
set_property -dict  {PACKAGE_PIN  AG15  IOSTANDARD  SSTL12}     [get_ports ddr4_bg] 
set_property -dict  {PACKAGE_PIN  AE16  IOSTANDARD  DIFF_POD12} [get_ports ddr4_ck_p] 
set_property -dict  {PACKAGE_PIN  AE15  IOSTANDARD  DIFF_POD12} [get_ports ddr4_ck_n] 
set_property -dict  {PACKAGE_PIN  AD15  IOSTANDARD  SSTL12}     [get_ports ddr4_cke] 
set_property -dict  {PACKAGE_PIN  AL19  IOSTANDARD  SSTL12}     [get_ports ddr4_cs_n] 
set_property -dict  {PACKAGE_PIN  AD21  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[0]] 
set_property -dict  {PACKAGE_PIN  AE25  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[1]] 
set_property -dict  {PACKAGE_PIN  AJ21  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[2]] 
set_property -dict  {PACKAGE_PIN  AM21  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[3]] 
set_property -dict  {PACKAGE_PIN  AH26  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[4]] 
set_property -dict  {PACKAGE_PIN  AN26  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[5]] 
set_property -dict  {PACKAGE_PIN  AJ29  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[6]] 
set_property -dict  {PACKAGE_PIN  AL32  IOSTANDARD  POD12}      [get_ports ddr4_dm_n[7]] 

set_property -dict  {PACKAGE_PIN  AE23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[0]] 
set_property -dict  {PACKAGE_PIN  AG20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[1]] 
set_property -dict  {PACKAGE_PIN  AF22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[2]] 
set_property -dict  {PACKAGE_PIN  AF20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[3]] 
set_property -dict  {PACKAGE_PIN  AE22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[4]] 
set_property -dict  {PACKAGE_PIN  AD20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[5]] 
set_property -dict  {PACKAGE_PIN  AG22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[6]] 
set_property -dict  {PACKAGE_PIN  AE20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[7]] 
set_property -dict  {PACKAGE_PIN  AJ24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[8]] 
set_property -dict  {PACKAGE_PIN  AG24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[9]] 
set_property -dict  {PACKAGE_PIN  AJ23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[10]] 
set_property -dict  {PACKAGE_PIN  AF23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[11]] 
set_property -dict  {PACKAGE_PIN  AH23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[12]] 
set_property -dict  {PACKAGE_PIN  AF24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[13]] 
set_property -dict  {PACKAGE_PIN  AH22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[14]] 
set_property -dict  {PACKAGE_PIN  AG25  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[15]] 
set_property -dict  {PACKAGE_PIN  AL22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[16]] 
set_property -dict  {PACKAGE_PIN  AL25  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[17]] 
set_property -dict  {PACKAGE_PIN  AM20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[18]] 
set_property -dict  {PACKAGE_PIN  AK23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[19]] 
set_property -dict  {PACKAGE_PIN  AK22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[20]] 
set_property -dict  {PACKAGE_PIN  AL24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[21]] 
set_property -dict  {PACKAGE_PIN  AL20  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[22]] 
set_property -dict  {PACKAGE_PIN  AL23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[23]] 
set_property -dict  {PACKAGE_PIN  AM24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[24]] 
set_property -dict  {PACKAGE_PIN  AN23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[25]] 
set_property -dict  {PACKAGE_PIN  AN24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[26]] 
set_property -dict  {PACKAGE_PIN  AP23  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[27]] 
set_property -dict  {PACKAGE_PIN  AP25  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[28]] 
set_property -dict  {PACKAGE_PIN  AN22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[29]] 
set_property -dict  {PACKAGE_PIN  AP24  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[30]] 
set_property -dict  {PACKAGE_PIN  AM22  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[31]] 
set_property -dict  {PACKAGE_PIN  AH28  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[32]] 
set_property -dict  {PACKAGE_PIN  AK26  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[33]] 
set_property -dict  {PACKAGE_PIN  AK28  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[34]] 
set_property -dict  {PACKAGE_PIN  AM27  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[35]] 
set_property -dict  {PACKAGE_PIN  AJ28  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[36]] 
set_property -dict  {PACKAGE_PIN  AH27  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[37]] 
set_property -dict  {PACKAGE_PIN  AK27  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[38]] 
set_property -dict  {PACKAGE_PIN  AM26  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[39]] 
set_property -dict  {PACKAGE_PIN  AL30  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[40]] 
set_property -dict  {PACKAGE_PIN  AP29  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[41]] 
set_property -dict  {PACKAGE_PIN  AM30  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[42]] 
set_property -dict  {PACKAGE_PIN  AN28  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[43]] 
set_property -dict  {PACKAGE_PIN  AL29  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[44]] 
set_property -dict  {PACKAGE_PIN  AP28  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[45]] 
set_property -dict  {PACKAGE_PIN  AM29  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[46]] 
set_property -dict  {PACKAGE_PIN  AN27  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[47]] 
set_property -dict  {PACKAGE_PIN  AH31  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[48]] 
set_property -dict  {PACKAGE_PIN  AH32  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[49]] 
set_property -dict  {PACKAGE_PIN  AJ34  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[50]] 
set_property -dict  {PACKAGE_PIN  AK31  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[51]] 
set_property -dict  {PACKAGE_PIN  AJ31  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[52]] 
set_property -dict  {PACKAGE_PIN  AJ30  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[53]] 
set_property -dict  {PACKAGE_PIN  AH34  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[54]] 
set_property -dict  {PACKAGE_PIN  AK32  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[55]] 
set_property -dict  {PACKAGE_PIN  AN33  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[56]] 
set_property -dict  {PACKAGE_PIN  AP33  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[57]] 
set_property -dict  {PACKAGE_PIN  AM34  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[58]] 
set_property -dict  {PACKAGE_PIN  AP31  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[59]] 
set_property -dict  {PACKAGE_PIN  AM32  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[60]] 
set_property -dict  {PACKAGE_PIN  AN31  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[61]] 
set_property -dict  {PACKAGE_PIN  AL34  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[62]] 
set_property -dict  {PACKAGE_PIN  AN32  IOSTANDARD  POD12_DCI}  [get_ports ddr4_dq[63]] 

set_property -dict  {PACKAGE_PIN  AG21  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[0]] 
set_property -dict  {PACKAGE_PIN  AH21  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[0]] 
set_property -dict  {PACKAGE_PIN  AH24  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[1]] 
set_property -dict  {PACKAGE_PIN  AJ25  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[1]] 
set_property -dict  {PACKAGE_PIN  AJ20  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[2]] 
set_property -dict  {PACKAGE_PIN  AK20  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[2]] 
set_property -dict  {PACKAGE_PIN  AP20  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[3]] 
set_property -dict  {PACKAGE_PIN  AP21  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[3]] 
set_property -dict  {PACKAGE_PIN  AL27  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[4]] 
set_property -dict  {PACKAGE_PIN  AL28  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[4]] 
set_property -dict  {PACKAGE_PIN  AN29  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[5]] 
set_property -dict  {PACKAGE_PIN  AP30  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[5]] 
set_property -dict  {PACKAGE_PIN  AH33  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[6]] 
set_property -dict  {PACKAGE_PIN  AJ33  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[6]] 
set_property -dict  {PACKAGE_PIN  AN34  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_p[7]] 
set_property -dict  {PACKAGE_PIN  AP34  IOSTANDARD  DIFF_POD12} [get_ports ddr4_dqs_n[7]] 

set_property -dict  {PACKAGE_PIN  AJ18  IOSTANDARD  SSTL12}     [get_ports ddr4_odt] 
set_property -dict  {PACKAGE_PIN  AD18  IOSTANDARD  SSTL12}     [get_ports ddr4_par] 
set_property -dict  {PACKAGE_PIN  AL18  IOSTANDARD  LVCMOS12}   [get_ports ddr4_reset_n] 

# ethernet

set_property -dict  {PACKAGE_PIN  L25   IOSTANDARD  LVCMOS18}       [get_ports mdio_mdc] 
set_property -dict  {PACKAGE_PIN  H26   IOSTANDARD  LVCMOS18}       [get_ports mdio_mdio] 
set_property -dict  {PACKAGE_PIN  J23   IOSTANDARD  LVCMOS18}       [get_ports phy_rst_n] 
set_property -dict  {PACKAGE_PIN  N24   IOSTANDARD  DIFF_HSTL_I_18} [get_ports phy_tx_p] 
set_property -dict  {PACKAGE_PIN  M24   IOSTANDARD  DIFF_HSTL_I_18} [get_ports phy_tx_n] 
set_property -dict  {PACKAGE_PIN  P24   IOSTANDARD  DIFF_HSTL_I_18} [get_ports phy_rx_p] 
set_property -dict  {PACKAGE_PIN  P25   IOSTANDARD  DIFF_HSTL_I_18} [get_ports phy_rx_n] 

# uart

set_property -dict  {PACKAGE_PIN  K26   IOSTANDARD  LVCMOS18} [get_ports uart_sout]
set_property -dict  {PACKAGE_PIN  G25   IOSTANDARD  LVCMOS18} [get_ports uart_sin] 

# fan & pwr-good

set_property -dict  {PACKAGE_PIN  AJ9   IOSTANDARD  LVCMOS18} [get_ports fan_pwm] 
set_property -dict  {PACKAGE_PIN  L24   IOSTANDARD  LVCMOS18} [get_ports pwr_good] 

# sw/led

set_property -dict  {PACKAGE_PIN  AN16  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_sw[0]];   ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  AN19  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_sw[1]];   ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  AP18  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_sw[2]];   ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  AN14  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_sw[3]];   ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  AD10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_sw[4]];   ## GPIO_SW_N
set_property -dict  {PACKAGE_PIN  AE8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_sw[5]];   ## GPIO_SW_E
set_property -dict  {PACKAGE_PIN  AF8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_sw[6]];   ## GPIO_SW_S
set_property -dict  {PACKAGE_PIN  AF9   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_sw[7]];   ## GPIO_SW_W
set_property -dict  {PACKAGE_PIN  AE10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_sw[8]];   ## GPIO_SW_C

set_property -dict  {PACKAGE_PIN  AP8   IOSTANDARD  LVCMOS18} [get_ports gpio_led[0]]
set_property -dict  {PACKAGE_PIN  H23   IOSTANDARD  LVCMOS18} [get_ports gpio_led[1]]
set_property -dict  {PACKAGE_PIN  P20   IOSTANDARD  LVCMOS18} [get_ports gpio_led[2]]
set_property -dict  {PACKAGE_PIN  P21   IOSTANDARD  LVCMOS18} [get_ports gpio_led[3]]
set_property -dict  {PACKAGE_PIN  N22   IOSTANDARD  LVCMOS18} [get_ports gpio_led[4]]
set_property -dict  {PACKAGE_PIN  M22   IOSTANDARD  LVCMOS18} [get_ports gpio_led[5]]
set_property -dict  {PACKAGE_PIN  R23   IOSTANDARD  LVCMOS18} [get_ports gpio_led[6]]
set_property -dict  {PACKAGE_PIN  P23   IOSTANDARD  LVCMOS18} [get_ports gpio_led[7]]

# iic

set_property -dict  {PACKAGE_PIN  AP10  IOSTANDARD  LVCMOS18} [get_ports iic_rstn] 
set_property -dict  {PACKAGE_PIN  J24   IOSTANDARD  LVCMOS18} [get_ports iic_scl] 
set_property -dict  {PACKAGE_PIN  J25   IOSTANDARD  LVCMOS18} [get_ports iic_sda] 

# hdmi

set_property -dict  {PACKAGE_PIN  AF13  IOSTANDARD  LVCMOS18} [get_ports hdmi_out_clk]
set_property -dict  {PACKAGE_PIN  AE13  IOSTANDARD  LVCMOS18} [get_ports hdmi_hsync]
set_property -dict  {PACKAGE_PIN  AH13  IOSTANDARD  LVCMOS18} [get_ports hdmi_vsync]
set_property -dict  {PACKAGE_PIN  AE11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data_e]
set_property -dict  {PACKAGE_PIN  AK11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[0]]
set_property -dict  {PACKAGE_PIN  AP11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[1]]
set_property -dict  {PACKAGE_PIN  AP13  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[2]]
set_property -dict  {PACKAGE_PIN  AN13  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[3]]
set_property -dict  {PACKAGE_PIN  AN11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[4]]
set_property -dict  {PACKAGE_PIN  AM11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[5]]
set_property -dict  {PACKAGE_PIN  AN12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[6]]
set_property -dict  {PACKAGE_PIN  AM12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[7]]
set_property -dict  {PACKAGE_PIN  AL12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[8]]
set_property -dict  {PACKAGE_PIN  AK12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[9]]
set_property -dict  {PACKAGE_PIN  AL13  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[10]]
set_property -dict  {PACKAGE_PIN  AK13  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[11]]
set_property -dict  {PACKAGE_PIN  AD11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[12]]
set_property -dict  {PACKAGE_PIN  AH12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[13]]
set_property -dict  {PACKAGE_PIN  AG12  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[14]]
set_property -dict  {PACKAGE_PIN  AJ11  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[15]]

# spdif

set_property -dict  {PACKAGE_PIN  AE12  IOSTANDARD  LVCMOS18} [get_ports spdif]

# clocks

create_clock -name cpu_clk      -period 10.00 [get_pins i_system_wrapper/system_i/axi_ddr_cntrl/addn_ui_clkout1]
#create_clock -name mem_clk      -period  5.00 [get_pins i_system_wrapper/system_i/axi_ddr_cntrl/c0_ddr4_ui_clk]
create_clock -name m200_clk     -period  5.00 [get_pins i_system_wrapper/system_i/axi_ddr_cntrl/addn_ui_clkout2]
create_clock -name hdmi_clk     -period  6.73 [get_pins i_system_wrapper/system_i/axi_hdmi_clkgen/clk_0]
create_clock -name spdif_clk    -period 50.00 [get_pins i_system_wrapper/system_i/sys_audio_clkgen/clk_out1]

set_clock_groups -asynchronous -group {cpu_clk}
#set_clock_groups -asynchronous -group {mem_clk}
set_clock_groups -asynchronous -group {m200_clk}
set_clock_groups -asynchronous -group {hdmi_clk}
set_clock_groups -asynchronous -group {spdif_clk}

