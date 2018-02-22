# constraints
# ad9361 (SWAP == 0x1)

set_property  -dict {PACKAGE_PIN  N11  IOSTANDARD LVCMOS18 } [get_ports rx_clk_in]
set_property  -dict {PACKAGE_PIN  N13  IOSTANDARD LVCMOS18 } [get_ports rx_frame_in]
set_property  -dict {PACKAGE_PIN  P15  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[0]]
set_property  -dict {PACKAGE_PIN  R15  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[1]]
set_property  -dict {PACKAGE_PIN  P14  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[2]]
set_property  -dict {PACKAGE_PIN  R13  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[3]]
set_property  -dict {PACKAGE_PIN  P13  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[4]]
set_property  -dict {PACKAGE_PIN  R12  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[5]]
set_property  -dict {PACKAGE_PIN  P11  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[6]]
set_property  -dict {PACKAGE_PIN  R11  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[7]]
set_property  -dict {PACKAGE_PIN  P10  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[8]]
set_property  -dict {PACKAGE_PIN  R10  IOSTANDARD LVCMOS18 } [get_ports rx_data_in[9]]
set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVCMOS18 } [get_ports rx_data_in[10]]
set_property  -dict {PACKAGE_PIN  P9   IOSTANDARD LVCMOS18 } [get_ports rx_data_in[11]]

set_property  -dict {PACKAGE_PIN  N12  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_clk_out]
set_property  -dict {PACKAGE_PIN  N14  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_frame_out]
set_property  -dict {PACKAGE_PIN  L14  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[0]]
set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[1]]
set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[2]]
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[3]]
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[4]]
set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[5]]
set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[6]]
set_property  -dict {PACKAGE_PIN  M12  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[7]]
set_property  -dict {PACKAGE_PIN  K11  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[8]]
set_property  -dict {PACKAGE_PIN  M11  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[9]]
set_property  -dict {PACKAGE_PIN  M10  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[10]]
set_property  -dict {PACKAGE_PIN  M9   IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports tx_data_out[11]]

set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]
set_property  -dict {PACKAGE_PIN  G11  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]
set_property  -dict {PACKAGE_PIN  G12  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]
set_property  -dict {PACKAGE_PIN  H14  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]
set_property  -dict {PACKAGE_PIN  H13  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]
set_property  -dict {PACKAGE_PIN  H12  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]
set_property  -dict {PACKAGE_PIN  H11  IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]
set_property  -dict {PACKAGE_PIN  J11  IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]

set_property  -dict {PACKAGE_PIN  E11  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]
set_property  -dict {PACKAGE_PIN  E12  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]
set_property  -dict {PACKAGE_PIN  E13  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]
set_property  -dict {PACKAGE_PIN  F12  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]

set_property  -dict {PACKAGE_PIN  J13  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]

set_property  -dict {PACKAGE_PIN  J14  IOSTANDARD LVCMOS18} [get_ports enable]
set_property  -dict {PACKAGE_PIN  N8  IOSTANDARD LVCMOS18} [get_ports txnrx]

set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports iic_sda]

set_property  -dict {PACKAGE_PIN  P8   IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports spi_csn]
set_property  -dict {PACKAGE_PIN  R7   IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports spi_clk]
set_property  -dict {PACKAGE_PIN  N7   IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports spi_mosi]
set_property  -dict {PACKAGE_PIN  R8   IOSTANDARD LVCMOS18 OFFCHIP_TERM NONE} [get_ports spi_miso]

set_property  -dict {PACKAGE_PIN  L12  IOSTANDARD LVCMOS18} [get_ports clk_out]

create_clock -name rx_clk -period  16.27 [get_ports rx_clk_in]

set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18} [get_ports pl_gpio[1]]
set_property  -dict {PACKAGE_PIN  F15  IOSTANDARD LVCMOS18} [get_ports pl_gpio[2]]
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18} [get_ports pl_gpio[3]]
set_property  -dict {PACKAGE_PIN  F13  IOSTANDARD LVCMOS18} [get_ports pl_gpio[4]]

set_false_path -from [get_pins {i_system_wrapper/system_i/axi_ad9361/inst/i_rx/i_up_adc_common/up_adc_gpio_out_int_reg[0]*/C}]
set_false_path -from [get_pins {i_system_wrapper/system_i/axi_ad9361/inst/i_tx/i_up_dac_common/up_dac_gpio_out_int_reg[0]*/C}]

