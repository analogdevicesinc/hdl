
# constraints

set_property -dict  {PACKAGE_PIN  AN8   IOSTANDARD  LVCMOS18} [get_ports sys_rst] 

# clocks

set_property -dict  {PACKAGE_PIN  P26   IOSTANDARD  LVDS_25} [get_ports phy_clk_p] 
set_property -dict  {PACKAGE_PIN  N26   IOSTANDARD  LVDS_25} [get_ports phy_clk_n] 

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

# fan 

set_property -dict  {PACKAGE_PIN  AJ9   IOSTANDARD  LVCMOS18} [get_ports fan_pwm] 

# sw/led

set_property -dict  {PACKAGE_PIN  AP8   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[0]]
set_property -dict  {PACKAGE_PIN  H23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[1]]
set_property -dict  {PACKAGE_PIN  P20   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[2]]
set_property -dict  {PACKAGE_PIN  P21   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[3]]
set_property -dict  {PACKAGE_PIN  N22   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[4]]
set_property -dict  {PACKAGE_PIN  M22   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[5]]
set_property -dict  {PACKAGE_PIN  R23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[6]]
set_property -dict  {PACKAGE_PIN  P23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[7]]
set_property -dict  {PACKAGE_PIN  AN16  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[8]];   ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  AN19  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[9]];   ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  AP18  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[10]];  ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  AN14  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[11]];  ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  AD10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[12]];  ## GPIO_SW_N
set_property -dict  {PACKAGE_PIN  AE8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[13]];  ## GPIO_SW_E
set_property -dict  {PACKAGE_PIN  AF8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[14]];  ## GPIO_SW_S
set_property -dict  {PACKAGE_PIN  AF9   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[15]];  ## GPIO_SW_W
set_property -dict  {PACKAGE_PIN  AE10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[16]];  ## GPIO_SW_C

# iic

set_property -dict  {PACKAGE_PIN  J24   IOSTANDARD  LVCMOS18} [get_ports iic_scl] 
set_property -dict  {PACKAGE_PIN  J25   IOSTANDARD  LVCMOS18} [get_ports iic_sda] 

# ddr

set_property -dict  {PACKAGE_PIN  AK17} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  AK16} [get_ports sys_clk_n]
set_property -dict  {PACKAGE_PIN  AH14} [get_ports ddr4_act_n]
set_property -dict  {PACKAGE_PIN  AE17} [get_ports ddr4_addr[0]]
set_property -dict  {PACKAGE_PIN  AH17} [get_ports ddr4_addr[1]]
set_property -dict  {PACKAGE_PIN  AE18} [get_ports ddr4_addr[2]]
set_property -dict  {PACKAGE_PIN  AJ15} [get_ports ddr4_addr[3]]
set_property -dict  {PACKAGE_PIN  AG16} [get_ports ddr4_addr[4]]
set_property -dict  {PACKAGE_PIN  AL17} [get_ports ddr4_addr[5]]
set_property -dict  {PACKAGE_PIN  AK18} [get_ports ddr4_addr[6]]
set_property -dict  {PACKAGE_PIN  AG17} [get_ports ddr4_addr[7]]
set_property -dict  {PACKAGE_PIN  AF18} [get_ports ddr4_addr[8]]
set_property -dict  {PACKAGE_PIN  AH19} [get_ports ddr4_addr[9]]
set_property -dict  {PACKAGE_PIN  AF15} [get_ports ddr4_addr[10]]
set_property -dict  {PACKAGE_PIN  AD19} [get_ports ddr4_addr[11]]
set_property -dict  {PACKAGE_PIN  AJ14} [get_ports ddr4_addr[12]]
set_property -dict  {PACKAGE_PIN  AG19} [get_ports ddr4_addr[13]]
set_property -dict  {PACKAGE_PIN  AD16} [get_ports ddr4_addr[14]]
set_property -dict  {PACKAGE_PIN  AG14} [get_ports ddr4_addr[15]]
set_property -dict  {PACKAGE_PIN  AF14} [get_ports ddr4_addr[16]]
set_property -dict  {PACKAGE_PIN  AF17} [get_ports ddr4_ba[0]]
set_property -dict  {PACKAGE_PIN  AL15} [get_ports ddr4_ba[1]]
set_property -dict  {PACKAGE_PIN  AG15} [get_ports ddr4_bg[0]]
set_property -dict  {PACKAGE_PIN  AE16} [get_ports ddr4_ck_p]
set_property -dict  {PACKAGE_PIN  AE15} [get_ports ddr4_ck_n]
set_property -dict  {PACKAGE_PIN  AD15} [get_ports ddr4_cke[0]]
set_property -dict  {PACKAGE_PIN  AL19} [get_ports ddr4_cs_n[0]]
set_property -dict  {PACKAGE_PIN  AD21} [get_ports ddr4_dm_n[0]]
set_property -dict  {PACKAGE_PIN  AE25} [get_ports ddr4_dm_n[1]]
set_property -dict  {PACKAGE_PIN  AJ21} [get_ports ddr4_dm_n[2]]
set_property -dict  {PACKAGE_PIN  AM21} [get_ports ddr4_dm_n[3]]
set_property -dict  {PACKAGE_PIN  AH26} [get_ports ddr4_dm_n[4]]
set_property -dict  {PACKAGE_PIN  AN26} [get_ports ddr4_dm_n[5]]
set_property -dict  {PACKAGE_PIN  AJ29} [get_ports ddr4_dm_n[6]]
set_property -dict  {PACKAGE_PIN  AL32} [get_ports ddr4_dm_n[7]]
set_property -dict  {PACKAGE_PIN  AE23} [get_ports ddr4_dq[0]]
set_property -dict  {PACKAGE_PIN  AG20} [get_ports ddr4_dq[1]]
set_property -dict  {PACKAGE_PIN  AF22} [get_ports ddr4_dq[2]]
set_property -dict  {PACKAGE_PIN  AF20} [get_ports ddr4_dq[3]]
set_property -dict  {PACKAGE_PIN  AE22} [get_ports ddr4_dq[4]]
set_property -dict  {PACKAGE_PIN  AD20} [get_ports ddr4_dq[5]]
set_property -dict  {PACKAGE_PIN  AG22} [get_ports ddr4_dq[6]]
set_property -dict  {PACKAGE_PIN  AE20} [get_ports ddr4_dq[7]]
set_property -dict  {PACKAGE_PIN  AJ24} [get_ports ddr4_dq[8]]
set_property -dict  {PACKAGE_PIN  AG24} [get_ports ddr4_dq[9]]
set_property -dict  {PACKAGE_PIN  AJ23} [get_ports ddr4_dq[10]]
set_property -dict  {PACKAGE_PIN  AF23} [get_ports ddr4_dq[11]]
set_property -dict  {PACKAGE_PIN  AH23} [get_ports ddr4_dq[12]]
set_property -dict  {PACKAGE_PIN  AF24} [get_ports ddr4_dq[13]]
set_property -dict  {PACKAGE_PIN  AH22} [get_ports ddr4_dq[14]]
set_property -dict  {PACKAGE_PIN  AG25} [get_ports ddr4_dq[15]]
set_property -dict  {PACKAGE_PIN  AL22} [get_ports ddr4_dq[16]]
set_property -dict  {PACKAGE_PIN  AL25} [get_ports ddr4_dq[17]]
set_property -dict  {PACKAGE_PIN  AM20} [get_ports ddr4_dq[18]]
set_property -dict  {PACKAGE_PIN  AK23} [get_ports ddr4_dq[19]]
set_property -dict  {PACKAGE_PIN  AK22} [get_ports ddr4_dq[20]]
set_property -dict  {PACKAGE_PIN  AL24} [get_ports ddr4_dq[21]]
set_property -dict  {PACKAGE_PIN  AL20} [get_ports ddr4_dq[22]]
set_property -dict  {PACKAGE_PIN  AL23} [get_ports ddr4_dq[23]]
set_property -dict  {PACKAGE_PIN  AM24} [get_ports ddr4_dq[24]]
set_property -dict  {PACKAGE_PIN  AN23} [get_ports ddr4_dq[25]]
set_property -dict  {PACKAGE_PIN  AN24} [get_ports ddr4_dq[26]]
set_property -dict  {PACKAGE_PIN  AP23} [get_ports ddr4_dq[27]]
set_property -dict  {PACKAGE_PIN  AP25} [get_ports ddr4_dq[28]]
set_property -dict  {PACKAGE_PIN  AN22} [get_ports ddr4_dq[29]]
set_property -dict  {PACKAGE_PIN  AP24} [get_ports ddr4_dq[30]]
set_property -dict  {PACKAGE_PIN  AM22} [get_ports ddr4_dq[31]]
set_property -dict  {PACKAGE_PIN  AH28} [get_ports ddr4_dq[32]]
set_property -dict  {PACKAGE_PIN  AK26} [get_ports ddr4_dq[33]]
set_property -dict  {PACKAGE_PIN  AK28} [get_ports ddr4_dq[34]]
set_property -dict  {PACKAGE_PIN  AM27} [get_ports ddr4_dq[35]]
set_property -dict  {PACKAGE_PIN  AJ28} [get_ports ddr4_dq[36]]
set_property -dict  {PACKAGE_PIN  AH27} [get_ports ddr4_dq[37]]
set_property -dict  {PACKAGE_PIN  AK27} [get_ports ddr4_dq[38]]
set_property -dict  {PACKAGE_PIN  AM26} [get_ports ddr4_dq[39]]
set_property -dict  {PACKAGE_PIN  AL30} [get_ports ddr4_dq[40]]
set_property -dict  {PACKAGE_PIN  AP29} [get_ports ddr4_dq[41]]
set_property -dict  {PACKAGE_PIN  AM30} [get_ports ddr4_dq[42]]
set_property -dict  {PACKAGE_PIN  AN28} [get_ports ddr4_dq[43]]
set_property -dict  {PACKAGE_PIN  AL29} [get_ports ddr4_dq[44]]
set_property -dict  {PACKAGE_PIN  AP28} [get_ports ddr4_dq[45]]
set_property -dict  {PACKAGE_PIN  AM29} [get_ports ddr4_dq[46]]
set_property -dict  {PACKAGE_PIN  AN27} [get_ports ddr4_dq[47]]
set_property -dict  {PACKAGE_PIN  AH31} [get_ports ddr4_dq[48]]
set_property -dict  {PACKAGE_PIN  AH32} [get_ports ddr4_dq[49]]
set_property -dict  {PACKAGE_PIN  AJ34} [get_ports ddr4_dq[50]]
set_property -dict  {PACKAGE_PIN  AK31} [get_ports ddr4_dq[51]]
set_property -dict  {PACKAGE_PIN  AJ31} [get_ports ddr4_dq[52]]
set_property -dict  {PACKAGE_PIN  AJ30} [get_ports ddr4_dq[53]]
set_property -dict  {PACKAGE_PIN  AH34} [get_ports ddr4_dq[54]]
set_property -dict  {PACKAGE_PIN  AK32} [get_ports ddr4_dq[55]]
set_property -dict  {PACKAGE_PIN  AN33} [get_ports ddr4_dq[56]]
set_property -dict  {PACKAGE_PIN  AP33} [get_ports ddr4_dq[57]]
set_property -dict  {PACKAGE_PIN  AM34} [get_ports ddr4_dq[58]]
set_property -dict  {PACKAGE_PIN  AP31} [get_ports ddr4_dq[59]]
set_property -dict  {PACKAGE_PIN  AM32} [get_ports ddr4_dq[60]]
set_property -dict  {PACKAGE_PIN  AN31} [get_ports ddr4_dq[61]]
set_property -dict  {PACKAGE_PIN  AL34} [get_ports ddr4_dq[62]]
set_property -dict  {PACKAGE_PIN  AN32} [get_ports ddr4_dq[63]]
set_property -dict  {PACKAGE_PIN  AG21} [get_ports ddr4_dqs_p[0]]
set_property -dict  {PACKAGE_PIN  AH24} [get_ports ddr4_dqs_p[1]]
set_property -dict  {PACKAGE_PIN  AJ20} [get_ports ddr4_dqs_p[2]]
set_property -dict  {PACKAGE_PIN  AP20} [get_ports ddr4_dqs_p[3]]
set_property -dict  {PACKAGE_PIN  AL27} [get_ports ddr4_dqs_p[4]]
set_property -dict  {PACKAGE_PIN  AN29} [get_ports ddr4_dqs_p[5]]
set_property -dict  {PACKAGE_PIN  AH33} [get_ports ddr4_dqs_p[6]]
set_property -dict  {PACKAGE_PIN  AN34} [get_ports ddr4_dqs_p[7]]
set_property -dict  {PACKAGE_PIN  AH21} [get_ports ddr4_dqs_n[0]]
set_property -dict  {PACKAGE_PIN  AJ25} [get_ports ddr4_dqs_n[1]]
set_property -dict  {PACKAGE_PIN  AK20} [get_ports ddr4_dqs_n[2]]
set_property -dict  {PACKAGE_PIN  AP21} [get_ports ddr4_dqs_n[3]]
set_property -dict  {PACKAGE_PIN  AL28} [get_ports ddr4_dqs_n[4]]
set_property -dict  {PACKAGE_PIN  AP30} [get_ports ddr4_dqs_n[5]]
set_property -dict  {PACKAGE_PIN  AJ33} [get_ports ddr4_dqs_n[6]]
set_property -dict  {PACKAGE_PIN  AP34} [get_ports ddr4_dqs_n[7]]
set_property -dict  {PACKAGE_PIN  AJ18} [get_ports ddr4_odt[0]]
set_property -dict  {PACKAGE_PIN  AL18} [get_ports ddr4_reset_n]

set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 44]
set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 45]
set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 46]

set_false_path -to [get_pins -hier -filter {name =~ *axi_ethernet_idelayctrl*/RST}]

