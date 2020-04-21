
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project cn0557_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

set_location_assignment -remove   -to eth1_tx_clk
set_location_assignment -remove   -to eth1_tx_ctl
set_location_assignment -remove   -to eth1_tx_d[0]
set_location_assignment -remove   -to eth1_tx_d[1]
set_location_assignment -remove   -to eth1_tx_d[2]
set_location_assignment -remove   -to eth1_tx_d[3]
set_location_assignment -remove   -to eth1_rx_clk
set_location_assignment -remove   -to eth1_rx_ctl
set_location_assignment -remove   -to eth1_rx_d[0]
set_location_assignment -remove   -to eth1_rx_d[1]
set_location_assignment -remove   -to eth1_rx_d[2]
set_location_assignment -remove   -to eth1_rx_d[3]
set_location_assignment -remove   -to eth1_mdc
set_location_assignment -remove   -to eth1_mdio

                                                                # Generic conector     CN055x
set_location_assignment PIN_AG13 -to rgmii_rxc]                   ; # Arduino_IO0        1 *
set_location_assignment PIN_AF13 -to rgmii_rx_ctl                 ; # Arduino_IO1        2 *
set_location_assignment PIN_AG10 -to rgmii_rxd[0]                 ; # Arduino_IO2        3 *
set_location_assignment PIN_AG9  -to rgmii_rxd[1]                 ; # Arduino_IO3        4 *DIGI0
set_location_assignment PIN_U14  -to rgmii_rxd[2]                 ; # Arduino_IO4        5 *
set_location_assignment PIN_U13  -to rgmii_rxd[3]                 ; # Arduino_IO5        6 *
set_location_assignment PIN_AG8  -to rgmii_txc]                   ; # Arduino_IO6        7 *
set_location_assignment PIN_AH8  -to rgmii_tx_ctl                 ; # Arduino_IO7        8 *
set_location_assignment PIN_AF17 -to rgmii_txd[0]                 ; # Arduino_IO8        1 |
set_location_assignment PIN_AE15 -to rgmii_txd[1]                 ; # Arduino_IO9        2 |
set_location_assignment PIN_AF15 -to rgmii_txd[2]                 ; # Arduino_IO10       3 |
set_location_assignment PIN_AG16 -to rgmii_txd[3]                 ; # Arduino_IO11       4 |DIGI1
set_location_assignment PIN_AH12 -to int_n                        ; # Arduino_IO13       5 |
set_location_assignment PIN_AH9  -to mdc             ; # pull-up  ; # Arduino_IO12       5 |
set_location_assignment PIN_AH11 -to mdio                         ; # Arduino_IO14       9 |

#set_location_assignment PIN_AH11 -to link_st

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rxc
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rxd[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rxd[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rxd[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_rxd[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_txc]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_tx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_txd[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_txd[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_txd[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rgmii_txd[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to link_st
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to int_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to mdc     ; # pull-up
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to mdio

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdc

# Arduino shield connections on de10_nano

                  ####################################
                  #                                  #       ## JP2 ##
                  #                             *1   #    1  Arduino_IO15
                  #                             *2   #    2  Arduino_IO14
                  #                             *3   #    3  Arduino_VREF
   ## JP5 ##      #                             *4   #    4  Arduino_GND
 # 1  NC          #                             *5   #    5  Arduino_IO13
 # 2  VCC3P3      #     *1                      *6   #    6  Arduino_IO12
 # 3  Reset_n     #     *2                      *7   #    7  Arduino_IO11
 # 4  VCC3P3      #     *3                  JP2 *8   #    8  Arduino_IO10
 # 5  VCC5        #     *4                      *9   #    9  Arduino_IO9
 # 6  GND         # JP5 *5                      *10  #    10 Arduino_IO8
 # 7  GND         #     *6                           #
 # 8  VCC9        #     *7                           #       ## JP3 ##
                  #     *8                      *1   #    1  Arduino_IO7
                  #                             *2   #    2  Arduino_IO6
   ## JP6 ##      #     *1                      *3   #    3  Arduino_IO5
 # 1 ADC_IN0      #     *2                      *4   #    4  Arduino_IO4
 # 2 ADC_IN1      # JP6 *3          531     JP3 *5   #    5  Arduino_IO3
 # 3 ADC_IN2      #     *4      JP4 ***         *6   #    6  Arduino_IO2
 # 4 ADC_IN3      #     *5          ***         *7   #    7  Arduino_IO1
 # 5 ADC_IN4      #     *6          642         *8   #    8  Arduino_IO0
 # 6 ADC_IN5      #                                  #
                   #                                #
                    #                              #
                     ##############################

                                ## JP4 ##
                              # 1 Arduino_I12
                              # 2 VCC5
                              # 3 Arduino_I13
                              # 4 Arduino_IO11
                              # 5 Arduino_Reset_n
                              # 6 GND


execute_flow -compile
