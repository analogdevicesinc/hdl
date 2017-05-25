
# constraints (ccpci.b)
# reference-only & not-effective
# using axi_pcie_x0y0.xdc

set_property  -dict {PACKAGE_PIN  U6 }  [get_ports pcie_ref_clk_p]                                      ; ## U1,U6,UNNAMED_7_CAP_I126_N2,JX3,2,MGTREFCLK1_112_JX3_P,P2,A13
set_property  -dict {PACKAGE_PIN  U5 }  [get_ports pcie_ref_clk_n]                                      ; ## U1,U5,UNNAMED_7_CAP_I124_N2,JX3,4,MGTREFCLK1_112_JX3_N,P2,A14
set_property  -dict {PACKAGE_PIN  T4 }  [get_ports pcie_data_rx_p[0]]                                   ; ## U1,T4,MGTXRX3_112_JX1_P,JX1,97,MGTXRX3_112_JX1_P,P2,B14
set_property  -dict {PACKAGE_PIN  T3 }  [get_ports pcie_data_rx_n[0]]                                   ; ## U1,T3,MGTXRX3_112_JX1_N,JX1,99,MGTXRX3_112_JX1_N,P2,B15
set_property  -dict {PACKAGE_PIN  V4 }  [get_ports pcie_data_rx_p[1]]                                   ; ## U1,V4,MGTXRX2_112_JX1_P,JX1,92,MGTXRX2_112_JX1_P,P2,B19
set_property  -dict {PACKAGE_PIN  V3 }  [get_ports pcie_data_rx_n[1]]                                   ; ## U1,V3,MGTXRX2_112_JX1_N,JX1,94,MGTXRX2_112_JX1_N,P2,B20
set_property  -dict {PACKAGE_PIN  Y4 }  [get_ports pcie_data_rx_p[2]]                                   ; ## U1,Y4,MGTXRX1_112_JX1_P,JX1,91,MGTXRX1_112_JX1_P,P2,B23
set_property  -dict {PACKAGE_PIN  Y3 }  [get_ports pcie_data_rx_n[2]]                                   ; ## U1,Y3,MGTXRX1_112_JX1_N,JX1,93,MGTXRX1_112_JX1_N,P2,B24
set_property  -dict {PACKAGE_PIN  AB4}  [get_ports pcie_data_rx_p[3]]                                   ; ## U1,AB4,MGTXRX0_112_JX1_P,JX1,88,MGTXRX0_112_JX1_P,P2,B27
set_property  -dict {PACKAGE_PIN  AB3}  [get_ports pcie_data_rx_n[3]]                                   ; ## U1,AB3,MGTXRX0_112_JX1_N,JX1,90,MGTXRX0_112_JX1_N,P2,B28
set_property  -dict {PACKAGE_PIN  R2 }  [get_ports pcie_data_tx_p[0]]                                   ; ## U1,R2,MGTXTX3_112_JX3_P,JX3,19,MGTXTX3_112_JX3_P,P2,A16
set_property  -dict {PACKAGE_PIN  R1 }  [get_ports pcie_data_tx_n[0]]                                   ; ## U1,R1,MGTXTX3_112_JX3_N,JX3,21,MGTXTX3_112_JX3_N,P2,A17
set_property  -dict {PACKAGE_PIN  U2 }  [get_ports pcie_data_tx_p[1]]                                   ; ## U1,U2,MGTXTX2_112_JX3_P,JX3,14,MGTXTX2_112_JX3_P,P2,A21
set_property  -dict {PACKAGE_PIN  U1 }  [get_ports pcie_data_tx_n[1]]                                   ; ## U1,U1,MGTXTX2_112_JX3_N,JX3,16,MGTXTX2_112_JX3_N,P2,A22
set_property  -dict {PACKAGE_PIN  W2 }  [get_ports pcie_data_tx_p[2]]                                   ; ## U1,W2,MGTXTX1_112_JX3_P,JX3,13,MGTXTX1_112_JX3_P,P2,A25
set_property  -dict {PACKAGE_PIN  W1 }  [get_ports pcie_data_tx_n[2]]                                   ; ## U1,W1,MGTXTX1_112_JX3_N,JX3,15,MGTXTX1_112_JX3_N,P2,A26
set_property  -dict {PACKAGE_PIN  AA2}  [get_ports pcie_data_tx_p[3]]                                   ; ## U1,AA2,MGTXTX0_112_JX3_P,JX3,8,MGTXTX0_112_JX3_P,P2,A29
set_property  -dict {PACKAGE_PIN  AA1}  [get_ports pcie_data_tx_n[3]]                                   ; ## U1,AA1,MGTXTX0_112_JX3_N,JX3,10,MGTXTX0_112_JX3_N,P2,A30
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25} [get_ports pcie_rstn]                      ; ## U1,W20,IO_L19_13_JX2_P,JX2,61,PCIE_PRSNT,P2,A11
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS25} [get_ports pcie_waken]                     ; ## U1,AB20,IO_L20_13_JX2_N,JX2,64,PCIE_WAKEB,P2,B11
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS25} [get_ports pcie_reset_done]                ; ## IO_L22N_T3_12, NOT-CONNECTED ????

set_property PULLUP true [get_ports pcie_rstn]
create_clock -name pcie_ref_clock -period 10 [get_ports pcie_ref_clk_p]

