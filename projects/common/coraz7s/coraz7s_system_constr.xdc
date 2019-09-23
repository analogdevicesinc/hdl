
# constraints


# gpio 

set_property  -dict {PACKAGE_PIN  D20   IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]       ; ## BTN0
set_property  -dict {PACKAGE_PIN  D19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]       ; ## BTN1
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]       ; ## LED0_B
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]       ; ## LED0_R
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]       ; ## LED0_G
set_property  -dict {PACKAGE_PIN  G14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## LED1_B
set_property  -dict {PACKAGE_PIN  L14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## LED1_R
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## LED_G


## ChipKit Outer Analog Header - as Digital I/O
## NOTE: The following constraints should be used when using these ports as digital I/O.
#set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { ck_a0 }]; #IO_L6N_T0_VREF_35 Sch=ck_a[0]
#set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports { ck_a1 }]; #IO_L10N_T1_AD11N_35 Sch=ck_a[1]
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { ck_a2 }]; #IO_L12P_T1_MRCC_35 Sch=ck_a[2]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ck_a3 }]; #IO_L11P_T1_SRCC_35 Sch=ck_a[3]
#set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ck_a4 }]; #IO_L21N_T3_DQS_AD14N_35 Sch=ck_a[4]
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { ck_a5 }]; #IO_L6P_T0_34 Sch=ck_a[5]

## ChipKit Outer Digital Header
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { ck_io0 }]; #IO_L11P_T1_SRCC_34 Sch=ck_io[0]
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { ck_io1 }]; #IO_L3N_T0_DQS_34 Sch=ck_io[1]
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { ck_io2 }]; #IO_L5P_T0_34 Sch=ck_io[2]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { ck_io3 }]; #IO_L5N_T0_34 Sch=ck_io[3]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ck_io4 }]; #IO_L21P_T3_DQS_34 Sch=ck_io[4]
#set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { ck_io5 }]; #IO_L21N_T3_DQS_34 Sch=ck_io[5]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ck_io6 }]; #IO_L19N_T3_VREF_34 Sch=ck_io[6]
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { ck_io7 }]; #IO_L6N_T0_VREF_34 Sch=ck_io[7]
#set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports { ck_io8 }]; #IO_L13P_T2_MRCC_34 Sch=ck_io[8]
#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ck_io9 }]; #IO_L8N_T1_AD10N_35 Sch=ck_io[9]
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { ck_io10 }]; #IO_L11N_T1_SRCC_34 Sch=ck_io[10]
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { ck_io11 }]; #IO_L12N_T1_MRCC_35 Sch=ck_io[11]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { ck_io12 }]; #IO_L14P_T2_AD4P_SRCC_35 Sch=ck_io[12]
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { ck_io13 }]; #IO_L19N_T3_VREF_35 Sch=ck_io[13]

## ChipKit Inner Digital Header
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ck_io26 }]; #IO_L19P_T3_34 Sch=ck_io[26]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { ck_io27 }]; #IO_L2N_T0_34 Sch=ck_io[27]
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { ck_io28 }]; #IO_L3P_T0_DQS_PUDC_B_34 Sch=ck_io[28]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ck_io29 }]; #IO_L10P_T1_34 Sch=ck_io[29]
#set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { ck_io30 }]; #IO_L9P_T1_DQS_34 Sch=ck_io[30]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ck_io31 }]; #IO_L9N_T1_DQS_34 Sch=ck_io[31]
#set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { ck_io32 }]; #IO_L20P_T3_34 Sch=ck_io[32]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { ck_io33 }]; #IO_L20N_T3_34 Sch=ck_io[33]
#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { ck_io34 }]; #IO_L23N_T3_34 Sch=ck_io[34]
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ck_io35 }]; #IO_L23P_T3_34 Sch=ck_io[35]
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ck_io36 }]; #IO_L8P_T1_AD10P_35 Sch=ck_io[36]
#set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { ck_io37 }]; #IO_L11N_T1_SRCC_35 Sch=ck_io[37]
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { ck_io38 }]; #IO_L13N_T2_MRCC_35 Sch=ck_io[38]
#set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { ck_io39 }]; #IO_L14N_T2_AD4N_SRCC_35 Sch=ck_io[39]
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { ck_io40 }]; #IO_L16N_T2_35 Sch=ck_io[40]
#set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { ck_io41 }]; #IO_L9N_T1_DQS_AD3N_35 Sch=ck_io[41]

## ChipKit SPI
#set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { ck_miso }]; #IO_L10N_T1_34 Sch=ck_miso
#set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { ck_mosi }]; #IO_L2P_T0_34 Sch=ck_mosi
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { ck_sck }]; #IO_L19P_T3_35 Sch=ck_sck
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { ck_ss }]; #IO_L6P_T0_35 Sch=ck_ss

## ChipKit I2C
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { ck_scl }]; #IO_L24N_T3_34 Sch=ck_scl
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { ck_sda }]; #IO_L24P_T3_34 Sch=ck_sda

##Misc. ChipKit signals
#set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]; #IO_L7N_T1_AD2N_35 Sch=ck_ioa