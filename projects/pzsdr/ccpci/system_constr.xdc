
# constraints

set_property  -dict {PACKAGE_PIN  AA6}  [get_ports pcie_ref_clk_p]                                      ; ## MGTREFCLK1P_111
set_property  -dict {PACKAGE_PIN  AA5}  [get_ports pcie_ref_clk_n]                                      ; ## MGTREFCLK1N_111
set_property  -dict {PACKAGE_PIN  AD8}  [get_ports pcie_data_rx_p[0]]                                   ; ## MGTXRXP0_111
set_property  -dict {PACKAGE_PIN  AD7}  [get_ports pcie_data_rx_n[0]]                                   ; ## MGTXRXN0_111
set_property  -dict {PACKAGE_PIN  AE6}  [get_ports pcie_data_rx_p[1]]                                   ; ## MGTXRXP1_111
set_property  -dict {PACKAGE_PIN  AE5}  [get_ports pcie_data_rx_n[1]]                                   ; ## MGTXRXN1_111
set_property  -dict {PACKAGE_PIN  AC6}  [get_ports pcie_data_rx_p[2]]                                   ; ## MGTXRXP2_111
set_property  -dict {PACKAGE_PIN  AC5}  [get_ports pcie_data_rx_n[2]]                                   ; ## MGTXRXN2_111
set_property  -dict {PACKAGE_PIN  AD4}  [get_ports pcie_data_rx_p[3]]                                   ; ## MGTXRXP3_111
set_property  -dict {PACKAGE_PIN  AD3}  [get_ports pcie_data_rx_n[3]]                                   ; ## MGTXRXN3_111
set_property  -dict {PACKAGE_PIN  AF8}  [get_ports pcie_data_tx_p[0]]                                   ; ## MGTXTXP0_111
set_property  -dict {PACKAGE_PIN  AF7}  [get_ports pcie_data_tx_n[0]]                                   ; ## MGTXTXN0_111
set_property  -dict {PACKAGE_PIN  AF4}  [get_ports pcie_data_tx_p[1]]                                   ; ## MGTXTXP1_111
set_property  -dict {PACKAGE_PIN  AF3}  [get_ports pcie_data_tx_n[1]]                                   ; ## MGTXTXN1_111
set_property  -dict {PACKAGE_PIN  AE2}  [get_ports pcie_data_tx_p[2]]                                   ; ## MGTXTXP2_111
set_property  -dict {PACKAGE_PIN  AE1}  [get_ports pcie_data_tx_n[2]]                                   ; ## MGTXTXN2_111
set_property  -dict {PACKAGE_PIN  AC2}  [get_ports pcie_data_tx_p[3]]                                   ; ## MGTXTXP3_111
set_property  -dict {PACKAGE_PIN  AC1}  [get_ports pcie_data_tx_n[3]]                                   ; ## MGTXTXN3_111
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25} [get_ports pcie_rstn]                      ; ## IO_L19P_T3_13      
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS25} [get_ports pcie_prsntn]                    ; ## IO_L19N_T3_VREF_13 
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS25} [get_ports pcie_prsnt1n]                   ; ## IO_L21P_T3_DQS_13  
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS25} [get_ports pcie_prsnt4n]                   ; ## IO_L21N_T3_DQS_13  
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS25} [get_ports pcie_waken]                     ; ## IO_L20N_T3_13      

