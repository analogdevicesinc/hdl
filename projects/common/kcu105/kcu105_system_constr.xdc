
# constraints

set_property -dict  {PACKAGE_PIN  AN8   IOSTANDARD  LVCMOS18} [get_ports sys_rst] 

set_false_path -through [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  AK17  IOSTANDARD  DIFF_SSTL12} [get_ports sys_clk_p] 
set_property -dict  {PACKAGE_PIN  AK16  IOSTANDARD  DIFF_SSTL12} [get_ports sys_clk_n]


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

