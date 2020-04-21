
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rxc    }];  #IO_L11P_T1_SRCC_34      IO0   1 *
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rx_ctl }];  #IO_L3N_T0_DQS_34        IO1   2 *
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rxd[0] }];  #IO_L5P_T0_34            IO2   3 *
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rxd[1] }];  #IO_L5N_T0_34            IO3   4 *DIGI0
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rxd[2] }];  #IO_L21P_T3_DQS_34       IO4   5 *
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports { rgmii_rxd[3] }];  #IO_L21N_T3_DQS_34       IO5   6 *
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { rgmii_txc    }];  #IO_L19N_T3_VREF_34      IO6   7 *
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports { rgmii_tx_ctl }];  #IO_L6N_T0_VREF_34       IO7   8 *
set_property -dict { PACKAGE_PIN N18 IOSTANDARD LVCMOS33 } [get_ports { rgmii_txd[0] }];  #IO_L13P_T2_MRCC_34      IO8   1 |
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { rgmii_txd[1] }];  #IO_L8N_T1_AD10N_35      IO9   2 |
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { rgmii_txd[2] }];  #IO_L11N_T1_SRCC_34      IO10  3 |
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { rgmii_txd[3] }];  #IO_L12N_T1_MRCC_35      IO11  4 |DIGI1
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { int_n        }];  #IO_L19N_T3_VREF_35      IO13  5 |
set_property -dict { PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports { mdc          }];  #IO_L14P_T2_AD4P_SRCC_35 IO12  5 |
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { mdio         }];  #IO_L24P_T3_34           SDA   9 |

create_clock -name rx_clk   -period  8.0 [get_ports rgmii_rxc]

# Arduino shield connections on coraz7

    #######################################
    #                                     #
    #                         J3  *2 SCL  #
    #                             *1 SDA  #
    #                            *15 IOA  #
    #                            *13 GND  #
    #     *1 N/C                 *11 IO13 #
    #     *2 IOREF            J4  *9 IO12 #
    #     *3 Reset_n              *7 IO11 #
    #     *4 3V3                  *5 IO10 #
    #  J8 *5 5V0                  *3 IO9  #
    #     *6 GND                  *1 IO8  #
    #     *7 GND                          #
    #     *8 N/C                 *15 IO7  #
    #                            *13 IO6  #
    #     *1 A0                  *11 IO5  #
    #     *3 A1                   *9 IO4  #
    #  J2 *5 A2       531     J5  *7 IO3  #
    #     *7 A3    J7 ***         *5 IO2  #
    #     *9 A4       ***         *3 IO1  #
    #    *11 A5       642         *1 IO0  #
    #                                     #
     #                                   #
      #                                 #
       #################################

                #  ## JP7 ##
                #  1  MISO
                #  2  N/C
                #  3  SCK
                #  4  MOSI
                #  5  SS
                #  6  GND
