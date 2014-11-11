
# constraints

set_property -dict  {PACKAGE_PIN  AV40  IOSTANDARD  LVCMOS18} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  E19   IOSTANDARD  LVDS} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  E18   IOSTANDARD  LVDS} [get_ports sys_clk_n]

create_clock -name sys_clk      -period  5.00 [get_ports sys_clk_p]

# ethernet

set_property PACKAGE_PIN AN2 [get_ports sgmii_txp]
set_property PACKAGE_PIN AN1 [get_ports sgmii_txn]
set_property PACKAGE_PIN AM8 [get_ports sgmii_rxp]
set_property PACKAGE_PIN AM7 [get_ports sgmii_rxn]

set_property PACKAGE_PIN AH8 [get_ports mgt_clk_p]
set_property PACKAGE_PIN AH7 [get_ports mgt_clk_n]

set_property -dict  {PACKAGE_PIN  AJ33  IOSTANDARD  LVCMOS18} [get_ports phy_rstn]
set_property -dict  {PACKAGE_PIN  AH31  IOSTANDARD  LVCMOS18} [get_ports mdio_mdc]
set_property -dict  {PACKAGE_PIN  AK33  IOSTANDARD  LVCMOS18} [get_ports mdio_mdio]

set_false_path -through [get_nets phy_rstn]

# uart

set_property -dict  {PACKAGE_PIN  AU33  IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  AU36  IOSTANDARD  LVCMOS18} [get_ports uart_sout]

# fan

set_property -dict  {PACKAGE_PIN  BA37  IOSTANDARD  LVCMOS18} [get_ports fan_pwm]

# lcd

set_property -dict  {PACKAGE_PIN  AT40  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[6]]   ; ## lcd_e    
set_property -dict  {PACKAGE_PIN  AN41  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[5]]   ; ## lcd_rs   
set_property -dict  {PACKAGE_PIN  AR42  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[4]]   ; ## lcd_rw   
set_property -dict  {PACKAGE_PIN  AN40  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[3]]   ; ## lcd_db[7]
set_property -dict  {PACKAGE_PIN  AR39  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[2]]   ; ## lcd_db[6]
set_property -dict  {PACKAGE_PIN  AR38  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[1]]   ; ## lcd_db[5]
set_property -dict  {PACKAGE_PIN  AT42  IOSTANDARD  LVCMOS18} [get_ports gpio_lcd[0]]   ; ## lcd_db[4]
set_property -dict  {PACKAGE_PIN  AV30  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[0]]    ; ## GPIO_DIP_SW0  
set_property -dict  {PACKAGE_PIN  AY33  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[1]]    ; ## GPIO_DIP_SW1  
set_property -dict  {PACKAGE_PIN  BA31  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[2]]    ; ## GPIO_DIP_SW2  
set_property -dict  {PACKAGE_PIN  BA32  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[3]]    ; ## GPIO_DIP_SW3  
set_property -dict  {PACKAGE_PIN  AW30  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[4]]    ; ## GPIO_DIP_SW4  
set_property -dict  {PACKAGE_PIN  AY30  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[5]]    ; ## GPIO_DIP_SW5  
set_property -dict  {PACKAGE_PIN  BA30  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[6]]    ; ## GPIO_DIP_SW6  
set_property -dict  {PACKAGE_PIN  BB31  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[7]]    ; ## GPIO_DIP_SW7  
set_property -dict  {PACKAGE_PIN  AR40  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[8]]    ; ## GPIO_SW_N     
set_property -dict  {PACKAGE_PIN  AU38  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[9]]    ; ## GPIO_SW_E     
set_property -dict  {PACKAGE_PIN  AP40  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[10]]   ; ## GPIO_SW_S     
set_property -dict  {PACKAGE_PIN  AW40  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[11]]   ; ## GPIO_SW_W     
set_property -dict  {PACKAGE_PIN  AV39  IOSTANDARD  LVCMOS18} [get_ports gpio_sw[12]]   ; ## GPIO_SW_C     
set_property -dict  {PACKAGE_PIN  AM39  IOSTANDARD  LVCMOS18} [get_ports gpio_led[0]]   ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  AN39  IOSTANDARD  LVCMOS18} [get_ports gpio_led[1]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  AR37  IOSTANDARD  LVCMOS18} [get_ports gpio_led[2]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  AT37  IOSTANDARD  LVCMOS18} [get_ports gpio_led[3]]   ; ## GPIO_LED_3_LS
set_property -dict  {PACKAGE_PIN  AR35  IOSTANDARD  LVCMOS18} [get_ports gpio_led[4]]   ; ## GPIO_LED_4_LS
set_property -dict  {PACKAGE_PIN  AP41  IOSTANDARD  LVCMOS18} [get_ports gpio_led[5]]   ; ## GPIO_LED_5_LS
set_property -dict  {PACKAGE_PIN  AP42  IOSTANDARD  LVCMOS18} [get_ports gpio_led[6]]   ; ## GPIO_LED_6_LS
set_property -dict  {PACKAGE_PIN  AU39  IOSTANDARD  LVCMOS18} [get_ports gpio_led[7]]   ; ## GPIO_LED_7_LS

# iic

set_property -dict  {PACKAGE_PIN  AY42  IOSTANDARD  LVCMOS18} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  AT35  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  AU32  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

# hdmi

set_property -dict  {PACKAGE_PIN  AU23  IOSTANDARD  LVCMOS18} [get_ports hdmi_out_clk]
set_property -dict  {PACKAGE_PIN  AU22  IOSTANDARD  LVCMOS18} [get_ports hdmi_hsync]
set_property -dict  {PACKAGE_PIN  AT22  IOSTANDARD  LVCMOS18} [get_ports hdmi_vsync]
set_property -dict  {PACKAGE_PIN  AP21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data_e]
set_property -dict  {PACKAGE_PIN  AM22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[0]]
set_property -dict  {PACKAGE_PIN  AL22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[1]]
set_property -dict  {PACKAGE_PIN  AJ20  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[2]]
set_property -dict  {PACKAGE_PIN  AJ21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[3]]
set_property -dict  {PACKAGE_PIN  AM21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[4]]
set_property -dict  {PACKAGE_PIN  AL21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[5]]
set_property -dict  {PACKAGE_PIN  AK22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[6]]
set_property -dict  {PACKAGE_PIN  AJ22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[7]]
set_property -dict  {PACKAGE_PIN  AL20  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[8]]
set_property -dict  {PACKAGE_PIN  AK20  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[9]]
set_property -dict  {PACKAGE_PIN  AK23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[10]]
set_property -dict  {PACKAGE_PIN  AJ23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[11]]
set_property -dict  {PACKAGE_PIN  AN21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[12]]
set_property -dict  {PACKAGE_PIN  AP22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[13]]
set_property -dict  {PACKAGE_PIN  AP23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[14]]
set_property -dict  {PACKAGE_PIN  AN23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[15]]
set_property -dict  {PACKAGE_PIN  AM23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[16]]
set_property -dict  {PACKAGE_PIN  AN24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[17]]
set_property -dict  {PACKAGE_PIN  AY24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[18]]
set_property -dict  {PACKAGE_PIN  BB22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[19]]
set_property -dict  {PACKAGE_PIN  BA22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[20]]
set_property -dict  {PACKAGE_PIN  BA25  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[21]]
set_property -dict  {PACKAGE_PIN  AY25  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[22]]
set_property -dict  {PACKAGE_PIN  AY22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[23]]
set_property -dict  {PACKAGE_PIN  AY23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[24]]
set_property -dict  {PACKAGE_PIN  AV24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[25]]
set_property -dict  {PACKAGE_PIN  AU24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[26]]
set_property -dict  {PACKAGE_PIN  AW21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[27]]
set_property -dict  {PACKAGE_PIN  AV21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[28]]
set_property -dict  {PACKAGE_PIN  AT24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[29]]
set_property -dict  {PACKAGE_PIN  AR24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[30]]
set_property -dict  {PACKAGE_PIN  AU21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[31]]
set_property -dict  {PACKAGE_PIN  AT21  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[32]]
set_property -dict  {PACKAGE_PIN  AW22  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[33]]
set_property -dict  {PACKAGE_PIN  AW23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[34]]
set_property -dict  {PACKAGE_PIN  AV23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[35]]

# spdif

set_property -dict  {PACKAGE_PIN  AR23  IOSTANDARD  LVCMOS18} [get_ports spdif]
