
# constraints

set_property -dict  {PACKAGE_PIN  U4    IOSTANDARD  LVCMOS15} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  R3    IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  P3    IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_n]

create_clock -name sys_clk      -period  5.00 [get_ports sys_clk_p]

# ethernet

set_property PACKAGE_PIN AC10 [get_ports sfp_txp]
set_property PACKAGE_PIN AD10 [get_ports sfp_txn]
set_property PACKAGE_PIN AC12 [get_ports sfp_rxp]
set_property PACKAGE_PIN AD12 [get_ports sfp_rxn]

set_property PACKAGE_PIN AA13 [get_ports mgt_clk_p]
set_property PACKAGE_PIN AB13 [get_ports mgt_clk_n]

set_property -dict  {PACKAGE_PIN  C24   IOSTANDARD  LVCMOS18} [get_ports mgt_clk_sel[1]]
set_property -dict  {PACKAGE_PIN  B26   IOSTANDARD  LVCMOS18} [get_ports mgt_clk_sel[0]]

# uart

set_property -dict  {PACKAGE_PIN  T19   IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  U19   IOSTANDARD  LVCMOS18} [get_ports uart_sout]

# fan

set_property -dict  {PACKAGE_PIN  J26   IOSTANDARD  LVCMOS25} [get_ports fan_pwm]

# lcd

set_property -dict  {PACKAGE_PIN  L20   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[6]]   ; ## lcd_e    
set_property -dict  {PACKAGE_PIN  L23   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[5]]   ; ## lcd_rs   
set_property -dict  {PACKAGE_PIN  L24   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[4]]   ; ## lcd_rw   
set_property -dict  {PACKAGE_PIN  L22   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[3]]   ; ## lcd_db[7]
set_property -dict  {PACKAGE_PIN  M25   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[2]]   ; ## lcd_db[6]
set_property -dict  {PACKAGE_PIN  M24   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[1]]   ; ## lcd_db[5]
set_property -dict  {PACKAGE_PIN  L25   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[0]]   ; ## lcd_db[4]
set_property -dict  {PACKAGE_PIN  R8    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[0]]    ; ## GPIO_DIP_SW0  
set_property -dict  {PACKAGE_PIN  P8    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[1]]    ; ## GPIO_DIP_SW1  
set_property -dict  {PACKAGE_PIN  R7    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[2]]    ; ## GPIO_DIP_SW2  
set_property -dict  {PACKAGE_PIN  R6    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[3]]    ; ## GPIO_DIP_SW3  
set_property -dict  {PACKAGE_PIN  P6    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[4]]    ; ## GPIO_SW_N     
set_property -dict  {PACKAGE_PIN  U5    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[5]]    ; ## GPIO_SW_E     
set_property -dict  {PACKAGE_PIN  T5    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[6]]    ; ## GPIO_SW_S     
set_property -dict  {PACKAGE_PIN  R5    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[7]]    ; ## GPIO_SW_W     
set_property -dict  {PACKAGE_PIN  U6    IOSTANDARD  LVCMOS15} [get_ports gpio_sw[8]]    ; ## GPIO_SW_C     
set_property -dict  {PACKAGE_PIN  M26   IOSTANDARD  LVCMOS15} [get_ports gpio_led[0]]   ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  T24   IOSTANDARD  LVCMOS15} [get_ports gpio_led[1]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  T25   IOSTANDARD  LVCMOS15} [get_ports gpio_led[2]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  R26   IOSTANDARD  LVCMOS15} [get_ports gpio_led[3]]   ; ## GPIO_LED_3_LS

# iic

set_property -dict  {PACKAGE_PIN  R17   IOSTANDARD  LVCMOS15} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  N18   IOSTANDARD  LVCMOS15  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  K25   IOSTANDARD  LVCMOS15  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

# hdmi

set_property -dict  {PACKAGE_PIN  V21   IOSTANDARD  LVCMOS18} [get_ports hdmi_out_clk]
set_property -dict  {PACKAGE_PIN  AC26  IOSTANDARD  LVCMOS18} [get_ports hdmi_hsync]
set_property -dict  {PACKAGE_PIN  AA22  IOSTANDARD  LVCMOS18} [get_ports hdmi_vsync]
set_property -dict  {PACKAGE_PIN  AB26  IOSTANDARD  LVCMOS18} [get_ports hdmi_data_e]
set_property -dict  {PACKAGE_PIN  AA24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[0]]
set_property -dict  {PACKAGE_PIN  Y25   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[1]]
set_property -dict  {PACKAGE_PIN  Y26   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[2]]
set_property -dict  {PACKAGE_PIN  V26   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[3]]
set_property -dict  {PACKAGE_PIN  W26   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[4]]
set_property -dict  {PACKAGE_PIN  W25   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[5]]
set_property -dict  {PACKAGE_PIN  W24   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[6]]
set_property -dict  {PACKAGE_PIN  U26   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[7]]
set_property -dict  {PACKAGE_PIN  U25   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[8]]
set_property -dict  {PACKAGE_PIN  V24   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[9]]
set_property -dict  {PACKAGE_PIN  U20   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[10]]
set_property -dict  {PACKAGE_PIN  W23   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[11]]
set_property -dict  {PACKAGE_PIN  W20   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[12]]
set_property -dict  {PACKAGE_PIN  U24   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[13]]
set_property -dict  {PACKAGE_PIN  Y20   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[14]]
set_property -dict  {PACKAGE_PIN  V23   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[15]]
set_property -dict  {PACKAGE_PIN  AA23  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[16]]
set_property -dict  {PACKAGE_PIN  AA25  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[17]]
set_property -dict  {PACKAGE_PIN  AB25  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[18]]
set_property -dict  {PACKAGE_PIN  AC24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[19]]
set_property -dict  {PACKAGE_PIN  AB24  IOSTANDARD  LVCMOS18} [get_ports hdmi_data[20]]
set_property -dict  {PACKAGE_PIN  Y22   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[21]]
set_property -dict  {PACKAGE_PIN  Y23   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[22]]
set_property -dict  {PACKAGE_PIN  V22   IOSTANDARD  LVCMOS18} [get_ports hdmi_data[23]]

# spdif

set_property -dict  {PACKAGE_PIN  Y21   IOSTANDARD  LVCMOS18} [get_ports spdif]

# clocks

# create_generated_clock -source sys_clk  -name cpu_clk      -multiply_by 1 [get_pins i_system_wrapper/system_i/axi_ddr_cntrl_1/ui_clk]
# create_generated_clock -source cpu_clk  -name m200_clk     -multiply_by 2 [get_pins i_system_wrapper/system_i/proc_sys_clock_1/clk_out1]
# create_generated_clock -source m200_clk -name hdmi_clk     -period  6.73 [get_pins i_system_wrapper/system_i/axi_hdmi_clkgen/clk_0]
# create_generated_clock -source m200_clk -name spdif_clk    -period 50.00 [get_pins i_system_wrapper/system_i/sys_audio_clkgen/clk_out1]

# set_clock_groups -asynchronous -group {cpu_clk}
# set_clock_groups -asynchronous -group {m200_clk}
# set_clock_groups -asynchronous -group {hdmi_clk}
# set_clock_groups -asynchronous -group {spdif_clk}



