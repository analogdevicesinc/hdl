
# constraints
# reference-only & not-effective
# (axi_pcie_x0y0.xdc)

set_property  -dict {PACKAGE_PIN  U6 }  [get_ports pcie_ref_clk_p]                                      ; ## MGTREFCLK1P_112 (JX3.2) (P2.A13)
set_property  -dict {PACKAGE_PIN  U5 }  [get_ports pcie_ref_clk_n]                                      ; ## MGTREFCLK1N_112 (JX3.4) (P2.A14)
set_property  -dict {PACKAGE_PIN  T4 }  [get_ports pcie_data_rx_p[0]]                                   ; ## MGTXRXP3_112 (JX1.97) (P2.B14)
set_property  -dict {PACKAGE_PIN  T3 }  [get_ports pcie_data_rx_n[0]]                                   ; ## MGTXRXN3_112 (JX1.99) (P2.B15)
set_property  -dict {PACKAGE_PIN  V4 }  [get_ports pcie_data_rx_p[1]]                                   ; ## MGTXRXP2_112 (JX1.92) (P2.B19)
set_property  -dict {PACKAGE_PIN  V3 }  [get_ports pcie_data_rx_n[1]]                                   ; ## MGTXRXN2_112 (JX1.94) (P2.B20)
set_property  -dict {PACKAGE_PIN  Y4 }  [get_ports pcie_data_rx_p[2]]                                   ; ## MGTXRXP1_112 (JX1.91) (P2.B23)
set_property  -dict {PACKAGE_PIN  Y3 }  [get_ports pcie_data_rx_n[2]]                                   ; ## MGTXRXN1_112 (JX1.93) (P2.B24)
set_property  -dict {PACKAGE_PIN  AB4}  [get_ports pcie_data_rx_p[3]]                                   ; ## MGTXRXP0_112 (JX1.88) (P2.B27)
set_property  -dict {PACKAGE_PIN  AB3}  [get_ports pcie_data_rx_n[3]]                                   ; ## MGTXRXN0_112 (JX1.90) (P2.B28)
set_property  -dict {PACKAGE_PIN  R2 }  [get_ports pcie_data_tx_p[0]]                                   ; ## MGTXTXP3_112 (JX3.19) (P2.A16)
set_property  -dict {PACKAGE_PIN  R1 }  [get_ports pcie_data_tx_n[0]]                                   ; ## MGTXTXN3_112 (JX3.21) (P2.A17)
set_property  -dict {PACKAGE_PIN  U2 }  [get_ports pcie_data_tx_p[1]]                                   ; ## MGTXTXP2_112 (JX3.14) (P2.A21)
set_property  -dict {PACKAGE_PIN  U1 }  [get_ports pcie_data_tx_n[1]]                                   ; ## MGTXTXN2_112 (JX3.16) (P2.A22)
set_property  -dict {PACKAGE_PIN  W2 }  [get_ports pcie_data_tx_p[2]]                                   ; ## MGTXTXP1_112 (JX3.13) (P2.A25)
set_property  -dict {PACKAGE_PIN  W1 }  [get_ports pcie_data_tx_n[2]]                                   ; ## MGTXTXN1_112 (JX3.15) (P2.A26)
set_property  -dict {PACKAGE_PIN  AA2}  [get_ports pcie_data_tx_p[3]]                                   ; ## MGTXTXP0_112 (JX3.8 ) (P2.A29)
set_property  -dict {PACKAGE_PIN  AA1}  [get_ports pcie_data_tx_n[3]]                                   ; ## MGTXTXN0_112 (JX3.10) (P2.A30)
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS33} [get_ports pcie_rstn]                      ; ## IO_L19P_T3_13
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS33} [get_ports pcie_waken]                     ; ## IO_L20N_T3_13
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS33} [get_ports pcie_rstn_good]                 ; ## IO_L22N_T3_12

# Default constraints have LVCMOS25, overwite it

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports iic_scl]                                           ; ## IO_L5P_T0_13
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports iic_sda]                                           ; ## IO_L5N_T0_13

set_property PULLUP true [get_ports pcie_rstn]
create_clock -name pcie_ref_clock -period 10 [get_ports pcie_ref_clk_p]


