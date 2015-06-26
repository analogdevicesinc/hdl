
# constraints

set_property -dict  {PACKAGE_PIN  AB7   IOSTANDARD  LVCMOS15} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  AD12  IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  AD11  IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_n]

# ddr

set_property -dict  {PACKAGE_PIN  AF11  IOSTANDARD SSTL15} [get_ports {ddr3_1_p[0]}]
set_property -dict  {PACKAGE_PIN  AE8   IOSTANDARD SSTL15} [get_ports {ddr3_1_p[1]}]
set_property -dict  {PACKAGE_PIN  AE11  IOSTANDARD SSTL15} [get_ports {ddr3_1_n[0]}]
set_property -dict  {PACKAGE_PIN  AE10  IOSTANDARD SSTL15} [get_ports {ddr3_1_n[1]}]
set_property -dict  {PACKAGE_PIN  AC10  IOSTANDARD SSTL15} [get_ports {ddr3_1_n[2]}]

set_property slave_banks {32 34} [get_iobanks 33]

# ethernet

set_property -dict  {PACKAGE_PIN  L20   IOSTANDARD  LVCMOS25} [get_ports mii_rst_n]
set_property -dict  {PACKAGE_PIN  W19   IOSTANDARD  LVCMOS25} [get_ports mii_col]
set_property -dict  {PACKAGE_PIN  R30   IOSTANDARD  LVCMOS25} [get_ports mii_crs]
set_property -dict  {PACKAGE_PIN  R23   IOSTANDARD  LVCMOS25} [get_ports mdio_mdc]
set_property -dict  {PACKAGE_PIN  J21   IOSTANDARD  LVCMOS25} [get_ports mdio_mdio]
set_property -dict  {PACKAGE_PIN  U27   IOSTANDARD  LVCMOS25} [get_ports mii_rx_clk]
set_property -dict  {PACKAGE_PIN  R28   IOSTANDARD  LVCMOS25} [get_ports mii_rx_dv]
set_property -dict  {PACKAGE_PIN  V26   IOSTANDARD  LVCMOS25} [get_ports mii_rx_er]
set_property -dict  {PACKAGE_PIN  U30   IOSTANDARD  LVCMOS25} [get_ports mii_rxd[0]]
set_property -dict  {PACKAGE_PIN  U25   IOSTANDARD  LVCMOS25} [get_ports mii_rxd[1]]
set_property -dict  {PACKAGE_PIN  T25   IOSTANDARD  LVCMOS25} [get_ports mii_rxd[2]]
set_property -dict  {PACKAGE_PIN  U28   IOSTANDARD  LVCMOS25} [get_ports mii_rxd[3]]
set_property -dict  {PACKAGE_PIN  M28   IOSTANDARD  LVCMOS25} [get_ports mii_tx_clk]
set_property -dict  {PACKAGE_PIN  M27   IOSTANDARD  LVCMOS25} [get_ports mii_tx_en]
set_property -dict  {PACKAGE_PIN  N27   IOSTANDARD  LVCMOS25} [get_ports mii_txd[0]]
set_property -dict  {PACKAGE_PIN  N25   IOSTANDARD  LVCMOS25} [get_ports mii_txd[1]]
set_property -dict  {PACKAGE_PIN  M29   IOSTANDARD  LVCMOS25} [get_ports mii_txd[2]]
set_property -dict  {PACKAGE_PIN  L28   IOSTANDARD  LVCMOS25} [get_ports mii_txd[3]]

# uart

set_property -dict  {PACKAGE_PIN  M19   IOSTANDARD  LVCMOS25} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  K24   IOSTANDARD  LVCMOS25} [get_ports uart_sout]

# fan

set_property -dict  {PACKAGE_PIN  L26   IOSTANDARD  LVCMOS25} [get_ports fan_pwm]

# lcd

set_property -dict  {PACKAGE_PIN  AB10  IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[6]]
set_property -dict  {PACKAGE_PIN  Y11   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[5]]
set_property -dict  {PACKAGE_PIN  AB13  IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[4]]
set_property -dict  {PACKAGE_PIN  Y10   IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[3]]
set_property -dict  {PACKAGE_PIN  AA11  IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[2]]
set_property -dict  {PACKAGE_PIN  AA10  IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[1]]
set_property -dict  {PACKAGE_PIN  AA13  IOSTANDARD  LVCMOS15} [get_ports gpio_lcd[0]]

# sw & led

set_property -dict  {PACKAGE_PIN  Y29   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[0]]
set_property -dict  {PACKAGE_PIN  W29   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[1]]
set_property -dict  {PACKAGE_PIN  AA28  IOSTANDARD  LVCMOS25} [get_ports gpio_bd[2]]
set_property -dict  {PACKAGE_PIN  Y28   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[3]]
set_property -dict  {PACKAGE_PIN  AA12  IOSTANDARD  LVCMOS15} [get_ports gpio_bd[4]]
set_property -dict  {PACKAGE_PIN  AG5   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[5]]
set_property -dict  {PACKAGE_PIN  AB12  IOSTANDARD  LVCMOS15} [get_ports gpio_bd[6]]
set_property -dict  {PACKAGE_PIN  AC6   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[7]]
set_property -dict  {PACKAGE_PIN  G12   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[8]]
set_property -dict  {PACKAGE_PIN  AB8   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[9]]
set_property -dict  {PACKAGE_PIN  AA8   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[10]]
set_property -dict  {PACKAGE_PIN  AC9   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[11]]
set_property -dict  {PACKAGE_PIN  AB9   IOSTANDARD  LVCMOS15} [get_ports gpio_bd[12]]
set_property -dict  {PACKAGE_PIN  AE26  IOSTANDARD  LVCMOS25} [get_ports gpio_bd[13]]
set_property -dict  {PACKAGE_PIN  G19   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[14]]
set_property -dict  {PACKAGE_PIN  E18   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[15]]
set_property -dict  {PACKAGE_PIN  F16   IOSTANDARD  LVCMOS25} [get_ports gpio_bd[16]]

# iic

set_property -dict  {PACKAGE_PIN  P23   IOSTANDARD  LVCMOS25} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  K21   IOSTANDARD  LVCMOS25  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  L21   IOSTANDARD  LVCMOS25  DRIVE 8 SLEW SLOW} [get_ports iic_sda]
