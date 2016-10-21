
# ad9361 (SWAP == 0x1)

set_property  -dict {PACKAGE_PIN  L18   IOSTANDARD  LVCMOS18} [get_ports rx_clk_in]
set_property  -dict {PACKAGE_PIN  N18   IOSTANDARD  LVCMOS18} [get_ports rx_frame_in]
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[0]]
set_property  -dict {PACKAGE_PIN  K18   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[1]]
set_property  -dict {PACKAGE_PIN  L17   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[2]]
set_property  -dict {PACKAGE_PIN  J17   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[3]]
set_property  -dict {PACKAGE_PIN  M16   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[4]]
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[5]]
set_property  -dict {PACKAGE_PIN  K16   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[6]]
set_property  -dict {PACKAGE_PIN  J16   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[7]]
set_property  -dict {PACKAGE_PIN  N20   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[8]]
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[9]]
set_property  -dict {PACKAGE_PIN  N17   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[10]]
set_property  -dict {PACKAGE_PIN  M17   IOSTANDARD  LVCMOS18} [get_ports rx_data_in[11]]

set_property  -dict {PACKAGE_PIN  R21   IOSTANDARD  LVCMOS18} [get_ports tx_clk_out]
set_property  -dict {PACKAGE_PIN  P22   IOSTANDARD  LVCMOS18} [get_ports tx_frame_out]
set_property  -dict {PACKAGE_PIN  N19   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[0]]
set_property  -dict {PACKAGE_PIN  M21   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[1]]
set_property  -dict {PACKAGE_PIN  P20   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[2]]
set_property  -dict {PACKAGE_PIN  P15   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[3]]
set_property  -dict {PACKAGE_PIN  P17   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[4]]
set_property  -dict {PACKAGE_PIN  P18   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[5]]
set_property  -dict {PACKAGE_PIN  R20   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[6]]
set_property  -dict {PACKAGE_PIN  P21   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[7]]
set_property  -dict {PACKAGE_PIN  M22   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[8]]
set_property  -dict {PACKAGE_PIN  T17   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[9]]
set_property  -dict {PACKAGE_PIN  N22   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[10]]
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD  LVCMOS18} [get_ports tx_data_out[11]]

set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD  LVCMOS18} [get_ports enable]
set_property  -dict {PACKAGE_PIN  AB1   IOSTANDARD  LVCMOS18} [get_ports txnrx]
set_property  -dict {PACKAGE_PIN  M19   IOSTANDARD  LVCMOS18} [get_ports out_clk]

set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD  LVCMOS18} [get_ports gpio_resetb]
set_property  -dict {PACKAGE_PIN  T16   IOSTANDARD  LVCMOS18} [get_ports gpio_sync]
set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD  LVCMOS18} [get_ports gpio_en_agc]
set_property  -dict {PACKAGE_PIN  V4    IOSTANDARD  LVCMOS18} [get_ports gpio_ctl[0]]
set_property  -dict {PACKAGE_PIN  V5    IOSTANDARD  LVCMOS18} [get_ports gpio_ctl[1]]
set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD  LVCMOS18} [get_ports gpio_ctl[2]]
set_property  -dict {PACKAGE_PIN  U6    IOSTANDARD  LVCMOS18} [get_ports gpio_ctl[3]]
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD  LVCMOS18} [get_ports gpio_status[0]]
set_property  -dict {PACKAGE_PIN  AB6   IOSTANDARD  LVCMOS18} [get_ports gpio_status[1]]
set_property  -dict {PACKAGE_PIN  AB7   IOSTANDARD  LVCMOS18} [get_ports gpio_status[2]]
set_property  -dict {PACKAGE_PIN  AA4   IOSTANDARD  LVCMOS18} [get_ports gpio_status[3]]
set_property  -dict {PACKAGE_PIN  K20   IOSTANDARD  LVCMOS18} [get_ports gpio_status[4]]
set_property  -dict {PACKAGE_PIN  L19   IOSTANDARD  LVCMOS18} [get_ports gpio_status[5]]
set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD  LVCMOS18} [get_ports gpio_status[6]]
set_property  -dict {PACKAGE_PIN  W12   IOSTANDARD  LVCMOS18} [get_ports gpio_status[7]]

# not-connected?

set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[0]]
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[1]]
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[2]]
set_property  -dict {PACKAGE_PIN  J18   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[3]]
set_property  -dict {PACKAGE_PIN  J20   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[4]]
set_property  -dict {PACKAGE_PIN  K19   IOSTANDARD  LVCMOS18} [get_ports gpio_rf[5]]
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD  LVCMOS18} [get_ports gpio_rf[6]]
set_property  -dict {PACKAGE_PIN  T6    IOSTANDARD  LVCMOS18} [get_ports gpio_rf[7]]
set_property  -dict {PACKAGE_PIN  R6    IOSTANDARD  LVCMOS18} [get_ports gpio_rf[8]]

# forwarded clocks (not-connected?)

set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD  LVCMOS18} [get_ports gpio_tcxo_clk]
set_property  -dict {PACKAGE_PIN  T4    IOSTANDARD  LVCMOS18} [get_ports gpio_out_clk]

# spi

set_property  -dict {PACKAGE_PIN  W6    IOSTANDARD  LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]
set_property  -dict {PACKAGE_PIN  W5    IOSTANDARD  LVCMOS18} [get_ports spi_clk]
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD  LVCMOS18} [get_ports spi_mosi]
set_property  -dict {PACKAGE_PIN  W7    IOSTANDARD  LVCMOS18} [get_ports spi_miso]

create_clock -name rx_clk -period  16 [get_ports rx_clk_in]

# rf filter selects

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD  LVCMOS33} [get_ports tx_bandsel[0]]
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD  LVCMOS33} [get_ports tx_bandsel[1]]
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD  LVCMOS33} [get_ports tx_bandsel[2]]
set_property  -dict {PACKAGE_PIN  E19   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1[0]]
set_property  -dict {PACKAGE_PIN  G21   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1[1]]
set_property  -dict {PACKAGE_PIN  G20   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1[2]]
set_property  -dict {PACKAGE_PIN  F19   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1b[0]]
set_property  -dict {PACKAGE_PIN  G19   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1b[1]]
set_property  -dict {PACKAGE_PIN  A19   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1c[0]]
set_property  -dict {PACKAGE_PIN  B15   IOSTANDARD  LVCMOS33} [get_ports rx_bandsel_1c[1]]
set_property  -dict {PACKAGE_PIN  AB9   IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2[0]]
set_property  -dict {PACKAGE_PIN  AA9   IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2[1]]
set_property  -dict {PACKAGE_PIN  AA8   IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2[2]]
set_property  -dict {PACKAGE_PIN  Y4    IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2b[0]]
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2b[1]]
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2c[0]]
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD  LVCMOS18} [get_ports rx_bandsel_2c[1]]

# rf enables

set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD  LVCMOS33} [get_ports tx_enable_1a]
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD  LVCMOS33} [get_ports tx_enable_2a]
set_property  -dict {PACKAGE_PIN  A17   IOSTANDARD  LVCMOS33} [get_ports tx_enable_1b]
set_property  -dict {PACKAGE_PIN  B16   IOSTANDARD  LVCMOS33} [get_ports tx_enable_2b]

# antennae selects

set_property  -dict {PACKAGE_PIN  C15   IOSTANDARD  LVCMOS33} [get_ports txrx1_antsel_v1]
set_property  -dict {PACKAGE_PIN  B17   IOSTANDARD  LVCMOS33} [get_ports txrx1_antsel_v2]
set_property  -dict {PACKAGE_PIN  A16   IOSTANDARD  LVCMOS33} [get_ports txrx2_antsel_v1]
set_property  -dict {PACKAGE_PIN  E20   IOSTANDARD  LVCMOS33} [get_ports txrx2_antsel_v2]
set_property  -dict {PACKAGE_PIN  E18   IOSTANDARD  LVCMOS33} [get_ports rx1_antsel_v1]
set_property  -dict {PACKAGE_PIN  F18   IOSTANDARD  LVCMOS33} [get_ports rx1_antsel_v2]
set_property  -dict {PACKAGE_PIN  F17   IOSTANDARD  LVCMOS33} [get_ports rx2_antsel_v1]
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD  LVCMOS33} [get_ports rx2_antsel_v2]

# fancy stuff

set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD  LVCMOS18} [get_ports txrx1_tx_led]
set_property  -dict {PACKAGE_PIN  AB10  IOSTANDARD  LVCMOS18} [get_ports txrx1_rx_led]
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD  LVCMOS18} [get_ports txrx2_tx_led]
set_property  -dict {PACKAGE_PIN  AB11  IOSTANDARD  LVCMOS18} [get_ports txrx2_rx_led]
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD  LVCMOS18} [get_ports rx1_rx_led]
set_property  -dict {PACKAGE_PIN  AA11  IOSTANDARD  LVCMOS18} [get_ports rx2_rx_led]

# xtal tuning (ad5662)

set_property  -dict {PACKAGE_PIN  K21   IOSTANDARD  LVCMOS18} [get_ports tcxo_dac_csn]
set_property  -dict {PACKAGE_PIN  L22   IOSTANDARD  LVCMOS18} [get_ports tcxo_dac_clk]
set_property  -dict {PACKAGE_PIN  L21   IOSTANDARD  LVCMOS18} [get_ports tcxo_dac_mosi]
set_property  -dict {PACKAGE_PIN  M20   IOSTANDARD  LVCMOS18} [get_ports tcxo_clk]

# board power

set_property  -dict {PACKAGE_PIN  A22   IOSTANDARD  LVCMOS33} [get_ports avr_csn]
set_property  -dict {PACKAGE_PIN  D22   IOSTANDARD  LVCMOS33} [get_ports avr_clk]
set_property  -dict {PACKAGE_PIN  A21   IOSTANDARD  LVCMOS33} [get_ports avr_mosi]
set_property  -dict {PACKAGE_PIN  C22   IOSTANDARD  LVCMOS33} [get_ports avr_miso]
set_property  -dict {PACKAGE_PIN  B22   IOSTANDARD  LVCMOS33} [get_ports avr_irq]

set_property  -dict {PACKAGE_PIN  E21   IOSTANDARD  LVCMOS33} [get_ports pwr_switch]

# gps-sync

set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD  LVCMOS18} [get_ports pps_gps]
set_property  -dict {PACKAGE_PIN  D18   IOSTANDARD  LVCMOS33} [get_ports pps_ext]

# board-gpio

set_property  -dict {PACKAGE_PIN  E16   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[0]]
set_property  -dict {PACKAGE_PIN  C18   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[1]]
set_property  -dict {PACKAGE_PIN  D17   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[2]]
set_property  -dict {PACKAGE_PIN  D16   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[3]]
set_property  -dict {PACKAGE_PIN  D15   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[4]]
set_property  -dict {PACKAGE_PIN  E15   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[5]]

