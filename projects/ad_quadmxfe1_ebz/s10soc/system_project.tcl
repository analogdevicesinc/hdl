
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make JESD_MODE=8B10B  RX_JESD_L=4 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=8
#      make JESD_MODE=64B66B RX_JESD_L=2 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=16
#
#  RX_RATE,TX_RATE,REF_CLK_RATE used only in 64B66B mode
#
# Parameter description:
#   JESD_MODE : used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C, uses Xilinx IP as Physical layer
#      8B10B  - 8b10b link layer defined in JESD 204B, uses ADI IP as Physical layer
#
#    RX_RATE :  line rate of the Rx link ( MxFE to FPGA ) used in 64B66B mode
#    TX_RATE :  line rate of the Tx link ( FPGA to MxFE ) used in 64B66B mode
#    REF_CLK_RATE : frequency of reference clock in MHz used in 64B66B mode
#    [RX/TX]_JESD_M : number of converters per link
#    [RX/TX]_JESD_L : number of lanes per link
#    [RX/TX]_JESD_NP : number of bits per sample, only 16 is supported
#    [RX/TX]_NUM_LINKS : number of links, matches numer of MxFE devices

adi_project ad_quadmxfe1_ebz_s10soc [list \
  JESD_MODE          [get_env_param JESD_MODE    8B10B ] \
  RX_RATE            [get_env_param RX_RATE      10.0 ] \
  TX_RATE            [get_env_param TX_RATE      10.0 ] \
  REF_CLK_RATE       [get_env_param REF_CLK_RATE 250 ] \
  RX_JESD_M          [get_env_param RX_JESD_M    8 ] \
  RX_JESD_L          [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S          [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP         [get_env_param RX_JESD_NP   16 ] \
  RX_NUM_LINKS       [get_env_param RX_NUM_LINKS 4 ] \
  TX_JESD_M          [get_env_param TX_JESD_M    8 ] \
  TX_JESD_L          [get_env_param TX_JESD_L    4 ] \
  TX_JESD_S          [get_env_param TX_JESD_S    1 ] \
  TX_JESD_NP         [get_env_param TX_JESD_NP   16 ] \
  TX_NUM_LINKS       [get_env_param TX_NUM_LINKS 4 ] \
  RX_KS_PER_CHANNEL  [get_env_param RX_KS_PER_CHANNEL 32 ] \
  TX_KS_PER_CHANNEL  [get_env_param TX_KS_PER_CHANNEL 16 ] \
]

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_assign.tcl

## quad_mxfe

set_location_assignment   PIN_BJ19    -to adf4371_cs[0]    ;   ## C26  IO_L5P_T0U_N8_AD14P_4
set_location_assignment   PIN_BJ20    -to adf4371_cs[1]    ;   ## C27  IO_L5N_T0U_N9_AD14N_4
set_location_assignment   PIN_BH18    -to adf4371_cs[2]    ;   ## D26  IO_L2P_T0L_N2_45
set_location_assignment   PIN_BJ18    -to adf4371_cs[3]    ;   ## D27  IO_L2N_T0L_N3_45
set_location_assignment   PIN_BG17    -to adf4371_sclk     ;   ## C22  IO_L10P_T1U_N6_QBC_AD4P_45
set_location_assignment   PIN_BH17    -to adf4371_sdio     ;   ## C23  IO_L10N_T1U_N7_QBC_AD4N_45
set_location_assignment   PIN_BC35    -to adrf5020_ctrl    ;   ## D24  IO_L1N_T0L_N1_DBC_45

set_instance_assignment -name IO_STANDARD "1.8 V" -to adf4371_cs
set_instance_assignment -name IO_STANDARD "1.8 V" -to adf4371_sclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to adf4371_sdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrf5020_ctrl

set_location_assignment    PIN_BC47   -to c2m[0]           ;   ## A38  MGTYTXP1_126
set_location_assignment    PIN_BC46   -to "c2m[ 0](n)"     ;   ## A39  MGTYTXN1_126
set_location_assignment    PIN_AV49   -to c2m[1]           ;   ## Z28  MGTYTXP0_125
set_location_assignment    PIN_AV48   -to "c2m[ 1](n)"     ;   ## Z29  MGTYTXN0_125
set_location_assignment    PIN_AR47   -to c2m[2]           ;   ## Y30  MGTYTXP1_125
set_location_assignment    PIN_AR46   -to "c2m[ 2](n)"     ;   ## Y31  MGTYTXN1_125
set_location_assignment    PIN_AU47   -to c2m[3]           ;   ## Y26  MGTYTXP3_122
set_location_assignment    PIN_AU46   -to "c2m[ 3](n)"     ;   ## Y27  MGTYTXN3_122
set_location_assignment    PIN_BE47   -to c2m[4]           ;   ## A30  MGTYTXP3_121
set_location_assignment    PIN_BE46   -to "c2m[ 4](n)"     ;   ## A31  MGTYTXN3_121
set_location_assignment    PIN_BA47   -to c2m[5]           ;   ## B32  MGTYTXP3_126
set_location_assignment    PIN_BA46   -to "c2m[ 5](n)"     ;   ## B33  MGTYTXN3_126
set_location_assignment    PIN_BF49   -to c2m[6]           ;   ## A34  MGTYTXP0_126
set_location_assignment    PIN_BF48   -to "c2m[ 6](n)"     ;   ## A35  MGTYTXN0_126
set_location_assignment    PIN_BD49   -to c2m[7]           ;   ## B36  MGTYTXP2_126
set_location_assignment    PIN_BD48   -to "c2m[ 7](n)"     ;   ## B37  MGTYTXN2_126
set_location_assignment    PIN_AY49   -to c2m[8]           ;   ## Z24  MGTYTXP2_122
set_location_assignment    PIN_AY48   -to "c2m[ 8](n)"     ;   ## Z25  MGTYTXN2_122
set_location_assignment    PIN_AW47   -to c2m[9]           ;   ## B24  MGTYTXP1_122
set_location_assignment    PIN_AW46   -to "c2m[ 9](n)"     ;   ## B25  MGTYTXN1_122
set_location_assignment    PIN_BG47   -to c2m[10]          ;   ## A26  MGTYTXP2_121
set_location_assignment    PIN_BG46   -to "c2m[10](n)"     ;   ## A27  MGTYTXN2_121
set_location_assignment    PIN_BB49   -to c2m[11]          ;   ## B28  MGTYTXP0_122
set_location_assignment    PIN_BB48   -to "c2m[11](n)"     ;   ## B29  MGTYTXN0_122
set_location_assignment    PIN_BJ46   -to c2m[12]          ;   ## C02  MGTYTXP0_121
set_location_assignment    PIN_BJ45   -to "c2m[12](n)"     ;   ## C03  MGTYTXN0_121
set_location_assignment    PIN_AT49   -to c2m[13]          ;   ## M18  MGTYTXP2_125
set_location_assignment    PIN_AT48   -to "c2m[13](n)"     ;   ## M19  MGTYTXN2_125
set_location_assignment    PIN_BF45   -to c2m[14]          ;   ## A22  MGTYTXP1_121
set_location_assignment    PIN_BF44   -to "c2m[14](n)"     ;   ## A23  MGTYTXN1_121
set_location_assignment    PIN_AP49   -to c2m[15]          ;   ## M22  MGTYTXP3_125
set_location_assignment    PIN_AP48   -to "c2m[15](n)"     ;   ## M23  MGTYTXN3_125

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to c2m
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to m2c

set_location_assignment   PIN_AP41  -to fpga_clk_m2c[0]          ;   ## D04  MGTREFCLK0P_121
set_location_assignment   PIN_AP40  -to "fpga_clk_m2c[0](n)"     ;   ## D05  MGTREFCLK0N_121
set_location_assignment   PIN_AK41  -to fpga_clk_m2c[1]          ;   ## B20  MGTREFCLK1P_120
set_location_assignment   PIN_AK40  -to "fpga_clk_m2c[1](n)"     ;   ## B21  MGTREFCLK1N_120
set_location_assignment   PIN_AF41  -to fpga_clk_m2c[2]          ;   ## L12  MGTREFCLK0P_122
set_location_assignment   PIN_AF40  -to "fpga_clk_m2c[2](n)"     ;   ## L13  MGTREFCLK0N_122
set_location_assignment   PIN_AM41  -to fpga_clk_m2c[3]          ;   ## L08  MGTREFCLK0P_125
set_location_assignment   PIN_AM40  -to "fpga_clk_m2c[3](n)"     ;   ## L09  MGTREFCLK0N_125
set_location_assignment   PIN_BF21  -to fpga_clk_m2c[4]          ;   ## H04  IO_L13P_T2L_N0_GC_QBC_4
set_location_assignment   PIN_BE21  -to "fpga_clk_m2c[4](n)"     ;   ## H05  IO_L13N_T2L_N1_GC_QBC_4
set_location_assignment   PIN_AW30  -to fpga_sysref_c2m          ;   ## G06  IO_L7P_T1L_N0_QBC_AD13P_43
set_location_assignment   PIN_AW31  -to "fpga_sysref_c2m(n)"     ;   ## G07  IO_L7N_T1L_N1_QBC_AD13N_43
set_location_assignment   PIN_AR19  -to fpga_sysref_m2c          ;   ## G02  IO_L14P_T2L_N2_GC_45
set_location_assignment   PIN_AT19  -to "fpga_sysref_m2c(n)"     ;   ## G03  IO_L14N_T2L_N3_GC_45

set_location_assignment   PIN_AT32  -to hmc425a_v[1]             ;   ## C19  IO_L23N_T3U_N9_43
set_location_assignment   PIN_AU32  -to hmc425a_v[2]             ;   ## C18  IO_L23P_T3U_N8_43
set_location_assignment   PIN_BB34  -to hmc425a_v[3]             ;   ## C15  IO_L3N_T0L_N5_AD15N_43
set_location_assignment   PIN_BB33  -to hmc425a_v[4]             ;   ## C14  IO_L3P_T0L_N4_AD15P_43
set_location_assignment   PIN_BF30  -to hmc425a_v[5]             ;   ## C11  IO_L2N_T0L_N3_43
set_location_assignment   PIN_BF31  -to hmc425a_v[6]             ;   ## C10  IO_L2P_T0L_N2_43
set_location_assignment   PIN_BC36  -to hmc7043_gpio             ;   ## D23  IO_L1P_T0L_N0_DBC_45
set_location_assignment   PIN_AT21  -to hmc7043_reset            ;   ## D17  IO_L20P_T3L_N2_AD1P_43
set_location_assignment   PIN_AT17  -to hmc7043_sclk             ;   ## D20  IO_L13P_T2L_N0_GC_QBC_45
set_location_assignment   PIN_AU17  -to hmc7043_sdata            ;   ## D21  IO_L13N_T2L_N1_GC_QBC_45
set_location_assignment   PIN_AR21  -to hmc7043_slen             ;   ## D18  IO_L20N_T3L_N3_AD1N_43

set_location_assignment -name IO_STANDARD LVDS -to fpga_clk_m2c
set_location_assignment -name IO_STANDARD LVDS -to fpga_clk_m2c
set_location_assignment -name IO_STANDARD LVDS -to fpga_sysref_c2m
set_location_assignment -name IO_STANDARD LVDS -to fpga_sysref_m2c
set_location_assignment -name INPUT_TERMINATION DIFFERENTIAL -to fpga_sysref_m2c

set_location_assignment -name IO_STANDARD "1.8 V" -to hmc425a_v
set_location_assignment -name IO_STANDARD "1.8 V" -to hmc7043_gpio
set_location_assignment -name IO_STANDARD "1.8 V" -to hmc7043_reset
set_location_assignment -name IO_STANDARD "1.8 V" -to hmc7043_sclk
set_location_assignment -name IO_STANDARD "1.8 V" -to hmc7043_sdata
set_location_assignment -name IO_STANDARD "1.8 V" -to hmc7043_slen

set_location_assignment  PIN_BD45  -to m2c[0]                   ;   ## A18  MGTYRXP1_126
set_location_assignment  PIN_BD44  -to "m2c[ 0](n)"             ;   ## A19  MGTYRXN1_126
set_location_assignment  PIN_AP45  -to m2c[1]                   ;   ## Y18  MGTYRXP2_125
set_location_assignment  PIN_AP44  -to "m2c[ 1](n)"             ;   ## Y19  MGTYRXN2_125
set_location_assignment  PIN_AN43  -to m2c[2]                   ;   ## Y22  MGTYRXP3_125
set_location_assignment  PIN_AN42  -to "m2c[ 2](n)"             ;   ## Y23  MGTYRXN3_125
set_location_assignment  PIN_AT45  -to m2c[3]                   ;   ## Z16  MGTYRXP1_125
set_location_assignment  PIN_AT44  -to "m2c[ 3](n)"             ;   ## Z17  MGTYRXN1_125
set_location_assignment  PIN_BE43  -to m2c[4]                   ;   ## A10  MGTYRXP3_121
set_location_assignment  PIN_BE42  -to "m2c[ 4](n)"             ;   ## A11  MGTYRXN3_121
set_location_assignment  PIN_BB45  -to m2c[5]                   ;   ## B12  MGTYRXP3_126
set_location_assignment  PIN_BB44  -to "m2c[ 5](n)"             ;   ## B13  MGTYRXN3_126
set_location_assignment  PIN_BC43  -to m2c[6]                   ;   ## A14  MGTYRXP0_126
set_location_assignment  PIN_BC42  -to "m2c[ 6](n)"             ;   ## A15  MGTYRXN0_126
set_location_assignment  PIN_BA43  -to m2c[7]                   ;   ## B16  MGTYRXP2_126
set_location_assignment  PIN_BA42  -to "m2c[ 7](n)"             ;   ## B17  MGTYRXN2_126
set_location_assignment  PIN_BG43  -to m2c[8]                   ;   ## A06  MGTYRXP2_121
set_location_assignment  PIN_BG42  -to "m2c[ 8](n)"             ;   ## A07  MGTYRXN2_121
set_location_assignment  PIN_AY45  -to m2c[9]                   ;   ## B04  MGTYRXP1_122
set_location_assignment  PIN_AY44  -to "m2c[ 9](n)"             ;   ## B05  MGTYRXN1_122
set_location_assignment  PIN_BH41  -to m2c[10]                  ;   ## C06  MGTYRXP0_121
set_location_assignment  PIN_BH40  -to "m2c[10](n)"             ;   ## C07  MGTYRXN0_121
set_location_assignment  PIN_AW43  -to m2c[11]                  ;   ## B08  MGTYRXP0_122
set_location_assignment  PIN_AW42  -to "m2c[11](n)"             ;   ## B09  MGTYRXN0_122
set_location_assignment  PIN_AR43  -to m2c[12]                  ;   ## Y14  MGTYRXP0_125
set_location_assignment  PIN_AR42  -to "m2c[12](n)"             ;   ## Y15  MGTYRXN0_125
set_location_assignment  PIN_AV45  -to m2c[13]                  ;   ## Z12  MGTYRXP3_122
set_location_assignment  PIN_AV44  -to "m2c[13](n)"             ;   ## Z13  MGTYRXN3_122
set_location_assignment  PIN_AU43  -to m2c[14]                  ;   ## Y10  MGTYRXP2_122
set_location_assignment  PIN_AU42  -to "m2c[14](n)"             ;   ## Y11  MGTYRXN2_122
set_location_assignment  PIN_BJ43  -to m2c[15]                  ;   ## A02  MGTYRXP1_121
set_location_assignment  PIN_BJ42  -to "m2c[15](n)"             ;   ## A03  MGTYRXN1_121

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to c2m
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to m2c

set_location_assignment  PIN_AV32  -to mxfe_cs[0]                 ;   ## F08  IO_L1N_T0L_N1_DBC_70
set_location_assignment  PIN_BD30  -to mxfe_cs[1]                 ;   ## H11  IO_L6N_T0U_N11_AD6N_43
set_location_assignment  PIN_BA11  -to mxfe_cs[2]                 ;   ## K20  IO_L23N_T3U_N9_70
set_location_assignment  PIN_BH30  -to mxfe_cs[3]                 ;   ## D12  IO_L1N_T0L_N1_DBC_43
set_location_assignment  PIN_BB12  -to mxfe_miso[0]               ;   ## F05  IO_L13N_T2L_N1_GC_QBC_70
set_location_assignment  PIN_BC32  -to mxfe_miso[1]               ;   ## G10  IO_L4N_T0U_N7_DBC_AD7N_43
set_location_assignment  PIN_AW11  -to mxfe_miso[2]               ;   ## K17  IO_L16N_T2U_N7_QBC_AD3N_70
set_location_assignment  PIN_BE31  -to mxfe_miso[3]               ;   ## D09  IO_L16N_T2U_N7_QBC_AD3N_43
set_location_assignment  PIN_AV33  -to mxfe_mosi[0]               ;   ## F07  IO_L1P_T0L_N0_DBC_70
set_location_assignment  PIN_BC30  -to mxfe_mosi[1]               ;   ## H10  IO_L6P_T0U_N10_AD6P_43
set_location_assignment  PIN_BA10  -to mxfe_mosi[2]               ;   ## K19  IO_L23P_T3U_N8_70
set_location_assignment  PIN_BG30  -to mxfe_mosi[3]               ;   ## D11  IO_L1P_T0L_N0_DBC_43
set_location_assignment  PIN_BH32  -to mxfe_reset[0]              ;   ## G12  IO_L18P_T2U_N10_AD2P_43
set_location_assignment  PIN_BE18  -to mxfe_reset[1]              ;   ## H23  IO_L22P_T3U_N6_DBC_AD0P_45
set_location_assignment  PIN_BB30  -to mxfe_reset[2]              ;   ## J06  IO_L3P_T0L_N4_AD15P_70
set_location_assignment  PIN_AW28  -to mxfe_reset[3]              ;   ## F13  IO_L9P_T1L_N4_AD12P_70
set_location_assignment  PIN_BE31  -to mxfe_rx_en0[0]             ;   ## G36  IO_L19P_T3L_N0_DBC_AD9P_45
set_location_assignment  PIN_BE32  -to mxfe_rx_en0[1]             ;   ## H13  IO_L5P_T0U_N8_AD14P_43
set_location_assignment  PIN_AW19  -to mxfe_rx_en0[2]             ;   ## K13  IO_L8P_T1L_N2_AD5P_70
set_location_assignment  PIN_BA12  -to mxfe_rx_en0[3]             ;   ## E18  IO_L17P_T2U_N8_AD10P_70
set_location_assignment  PIN_BD31  -to mxfe_rx_en1[0]             ;   ## G37  IO_L19N_T3L_N1_DBC_AD9N_45
set_location_assignment  PIN_BF32  -to mxfe_rx_en1[1]             ;   ## H14  IO_L5N_T0U_N9_AD14N_43
set_location_assignment  PIN_AW20  -to mxfe_rx_en1[2]             ;   ## K14  IO_L8N_T1L_N3_AD5N_70
set_location_assignment  PIN_AY12  -to mxfe_rx_en1[3]             ;   ## E19  IO_L17N_T2U_N9_AD10N_70
set_location_assignment  PIN_BC12  -to mxfe_sclk[0]               ;   ## F04  IO_L13P_T2L_N0_GC_QBC_70
set_location_assignment  PIN_BC31  -to mxfe_sclk[1]               ;   ## G09  IO_L4P_T0U_N6_DBC_AD7P_43
set_location_assignment  PIN_AY11  -to mxfe_sclk[2]               ;   ## K16  IO_L16P_T2U_N6_QBC_AD3P_70
set_location_assignment  PIN_BD31  -to mxfe_sclk[3]               ;   ## D08  IO_L16P_T2U_N6_QBC_AD3P_43
set_location_assignment  PIN_AU35  -to mxfe_sync1_inb_n[0]        ;   ## G31  IO_L4N_T0U_N7_DBC_AD7N_45
set_location_assignment  PIN_AT16  -to mxfe_sync1_inb_n[1]        ;   ## H17  IO_L17N_T2U_N9_AD10N_43
set_location_assignment  PIN_BB20  -to mxfe_sync1_inb_n[2]        ;   ## K08  IO_L5N_T0U_N9_AD14N_70
set_location_assignment  PIN_BJ31  -to mxfe_sync1_inb_n[3]        ;   ## E13  IO_L4N_T0U_N7_DBC_AD7N_70
set_location_assignment  PIN_AV35  -to mxfe_sync1_inb_p[0]        ;   ## G30  IO_L4P_T0U_N6_DBC_AD7P_45
set_location_assignment  PIN_AT15  -to mxfe_sync1_inb_p[1]        ;   ## H16  IO_L17P_T2U_N8_AD10P_43
set_location_assignment  PIN_BC20  -to mxfe_sync1_inb_p[2]        ;   ## K07  IO_L5P_T0U_N8_AD14P_70
set_location_assignment  PIN_BH31  -to mxfe_sync1_inb_p[3]        ;   ## E12  IO_L4P_T0U_N6_DBC_AD7P_70
set_location_assignment  PIN_BG35  -to mxfe_sync1_outb_n[0]       ;   ## G34  IO_L16N_T2U_N7_QBC_AD3N_45
set_location_assignment  PIN_AN18  -to mxfe_sync1_outb_n[1]       ;   ## H20  IO_L24N_T3U_N11_43
set_location_assignment  PIN_BD20  -to mxfe_sync1_outb_n[2]       ;   ## K11  IO_L12N_T1U_N11_GC_70
set_location_assignment  PIN_AV20  -to mxfe_sync1_outb_n[3]       ;   ## E16  IO_L11N_T1U_N9_GC_70
set_location_assignment  PIN_BH35  -to mxfe_sync1_outb_p[0]       ;   ## G33  IO_L16P_T2U_N6_QBC_AD3P_45
set_location_assignment  PIN_AN17  -to mxfe_sync1_outb_p[1]       ;   ## H19  IO_L24P_T3U_N10_43
set_location_assignment  PIN_BD19  -to mxfe_sync1_outb_p[2]       ;   ## K10  IO_L12P_T1U_N10_GC_70
set_location_assignment  PIN_AV21  -to mxfe_sync1_outb_p[3]       ;   ## E15  IO_L11P_T1U_N8_GC_70
set_location_assignment  PIN_BD33  -to mxfe_tx_en0[0]             ;   ## F10  IO_L10P_T1U_N6_QBC_AD4P_70
set_location_assignment  PIN_AN20  -to mxfe_tx_en0[1]             ;   ## H07  IO_L14P_T2L_N2_GC_43
set_location_assignment  PIN_BC18  -to mxfe_tx_en0[2]             ;   ## K22  IO_L21P_T3L_N4_AD8P_70
set_location_assignment  PIN_BA31  -to mxfe_tx_en0[3]             ;   ## D14  IO_L19P_T3L_N0_DBC_AD9P_43
set_location_assignment  PIN_BC33  -to mxfe_tx_en1[0]             ;   ## F11  IO_L10N_T1U_N7_QBC_AD4N_70
set_location_assignment  PIN_AP20  -to mxfe_tx_en1[1]             ;   ## H08  IO_L14N_T2L_N3_GC_43
set_location_assignment  PIN_BB18  -to mxfe_tx_en1[2]             ;   ## K23  IO_L21N_T3L_N5_AD8N_70
set_location_assignment  PIN_BA30  -to mxfe_tx_en1[3]             ;   ## D15  IO_L19N_T3L_N1_DBC_AD9N_43
set_location_assignment  PIN_BG32  -to mxfe0_gpio[0]              ;   ## G13  IO_L18N_T2U_N11_AD2N_43
set_location_assignment  PIN_AU29  -to mxfe0_gpio[1]              ;   ## G15  IO_L21P_T3L_N4_AD8P_43
set_location_assignment  PIN_AU28  -to mxfe0_gpio[2]              ;   ## G16  IO_L21N_T3L_N5_AD8N_43
set_location_assignment  PIN_BA20  -to mxfe0_gpio[3]              ;   ## G18  IO_L22P_T3U_N6_DBC_AD0P_43
set_location_assignment  PIN_BA21  -to mxfe0_gpio[4]              ;   ## G19  IO_L22N_T3U_N7_DBC_AD0N_43
set_location_assignment  PIN_AN21  -to mxfe0_gpio[5]              ;   ## G21  IO_L23P_T3U_N8_45
set_location_assignment  PIN_AP21  -to mxfe0_gpio[6]              ;   ## G22  IO_L23N_T3U_N9_45
set_location_assignment  PIN_BJ35  -to mxfe0_gpio[7]              ;   ## G24  IO_L20P_T3L_N2_AD1P_45
set_location_assignment  PIN_BJ36  -to mxfe0_gpio[8]              ;   ## G25  IO_L20N_T3L_N3_AD1N_45
set_location_assignment  PIN_BF20  -to mxfe0_gpio[9]              ;   ## G27  IO_L3P_T0L_N4_AD15P_45
set_location_assignment  PIN_BG20  -to mxfe0_gpio[10]             ;   ## G28  IO_L3N_T0L_N5_AD15N_45
set_location_assignment  PIN_BD18  -to mxfe1_gpio[0]              ;   ## H23  IO_L22N_T3U_N7_DBC_AD0N_45
set_location_assignment  PIN_BG18  -to mxfe1_gpio[1]              ;   ## H25  IO_L24P_T3U_N10_45
set_location_assignment  PIN_BG19  -to mxfe1_gpio[2]              ;   ## H26  IO_L24N_T3U_N11_45
set_location_assignment  PIN_BH20  -to mxfe1_gpio[3]              ;   ## H28  IO_L6P_T0U_N10_AD6P_45
set_location_assignment  PIN_BH21  -to mxfe1_gpio[4]              ;   ## H29  IO_L6N_T0U_N11_AD6N_45
set_location_assignment  PIN_BF36  -to mxfe1_gpio[5]              ;   ## H31  IO_L17P_T2U_N8_AD10P_45
set_location_assignment  PIN_BF35  -to mxfe1_gpio[6]              ;   ## H32  IO_L17N_T2U_N9_AD10N_45
set_location_assignment  PIN_BE36  -to mxfe1_gpio[7]              ;   ## H34  IO_L18P_T2U_N10_AD2P_45
set_location_assignment  PIN_BD36  -to mxfe1_gpio[8]              ;   ## H35  IO_L18N_T2U_N11_AD2N_45
set_location_assignment  PIN_BE33  -to mxfe1_gpio[9]              ;   ## H37  IO_L21P_T3L_N4_AD8P_45
set_location_assignment  PIN_BE34  -to mxfe1_gpio[10]             ;   ## H38  IO_L21N_T3L_N5_AD8N_45
set_location_assignment  PIN_BB29  -to mxfe2_gpio[0]              ;   ## J07  IO_L3N_T0L_N5_AD15N_70
set_location_assignment  PIN_BD29  -to mxfe2_gpio[1]              ;   ## J09  IO_L2P_T0L_N2_70
set_location_assignment  PIN_BE29  -to mxfe2_gpio[2]              ;   ## J10  IO_L2N_T0L_N3_70
set_location_assignment  PIN_AW21  -to mxfe2_gpio[3]              ;   ## J12  IO_L18P_T2U_N10_AD2P_70
set_location_assignment  PIN_AY21  -to mxfe2_gpio[4]              ;   ## J13  IO_L18N_T2U_N11_AD2N_70
set_location_assignment  PIN_AW13  -to mxfe2_gpio[5]              ;   ## J15  IO_L22P_T3U_N6_DBC_AD0P_70
set_location_assignment  PIN_AY13  -to mxfe2_gpio[6]              ;   ## J16  IO_L22N_T3U_N7_DBC_AD0N_70
set_location_assignment  PIN_AV11  -to mxfe2_gpio[7]              ;   ## J18  IO_L15P_T2L_N4_AD11P_70
set_location_assignment  PIN_AV12  -to mxfe2_gpio[8]              ;   ## J19  IO_L15N_T2L_N5_AD11N_70
set_location_assignment  PIN_BE17  -to mxfe2_gpio[9]              ;   ## J21  IO_L24P_T3U_N10_70
set_location_assignment  PIN_BF17  -to mxfe2_gpio[10]             ;   ## J22  IO_L24N_T3U_N11_70
set_location_assignment  PIN_AV28  -to mxfe3_gpio[0]              ;   ## F14  IO_L9N_T1L_N5_AD12N_70
set_location_assignment  PIN_BB19  -to mxfe3_gpio[1]              ;   ## F16  IO_L19P_T3L_N0_DBC_AD9P_70
set_location_assignment  PIN_BA19  -to mxfe3_gpio[2]              ;   ## F17  IO_L19N_T3L_N1_DBC_AD9N_70
set_location_assignment  PIN_AT20  -to mxfe3_gpio[3]              ;   ## F19  IO_L20P_T3L_N2_AD1P_70
set_location_assignment  PIN_AU20  -to mxfe3_gpio[4]              ;   ## F20  IO_L20N_T3L_N3_AD1N_70
set_location_assignment  PIN_BC10  -to mxfe3_gpio[5]              ;   ## E02  IO_L7P_T1L_N0_QBC_AD13P_70
set_location_assignment  PIN_BB10  -to mxfe3_gpio[6]              ;   ## E03  IO_L7N_T1L_N1_QBC_AD13N_70
set_location_assignment  PIN_AU30  -to mxfe3_gpio[7]              ;   ## E06  IO_L14P_T2L_N2_GC_70
set_location_assignment  PIN_AV30  -to mxfe3_gpio[8]              ;   ## E07  IO_L14N_T2L_N3_GC_70
set_location_assignment  PIN_AY31  -to mxfe3_gpio[9]              ;   ## E09  IO_L6P_T0U_N10_AD6P_70
set_location_assignment  PIN_AY32  -to mxfe3_gpio[10]             ;   ## E10  IO_L6N_T0U_N11_AD6N_70

set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_cs
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_miso
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_mosi
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_reset
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_rx_en0
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_rx_en1
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_sclk
set_instance_assignment IO_STANDARD  LVDS      -to mxfe_sync1_inb
set_instance_assignment IO_STANDARD  LVDS      -to mxfe_sync1_outb
set_instance_assignment INPUT_TERMINATION DIFFERENTIAL  -to mxfe_sync1_inb
set_instance_assignment INPUT_TERMINATION DIFFERENTIAL  -to mxfe_sync1_outb
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_tx_en0
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe_tx_en1
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe0_gpio
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe1_gpio
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe2_gpio
set_instance_assignment IO_STANDARD  "1.8 V"   -to mxfe3_gpio

## TODO: Find an port for these!
## external HMC SPI interface
#set_property  -dict {PACKAGE_PIN AY14  IOSTANDARD LVCMOS12                       } [get_ports ext_hmc7044_sclk          ];  ##
#set_property  -dict {PACKAGE_PIN AY15  IOSTANDARD LVCMOS12                       } [get_ports ext_hmc7044_slen          ];  ##
#set_property  -dict {PACKAGE_PIN AW15  IOSTANDARD LVCMOS12                       } [get_ports ext_hmc7044_sdata         ];  ##
#set_property  -dict {PACKAGE_PIN AV15  IOSTANDARD LVCMOS12                       } [get_ports ext_hmc7044_miso          ];  ##
#
#
#set_property  -dict {PACKAGE_PIN R32  IOSTANDARD LVCMOS18                       } [get_ports ext_sync                   ]; ## IO_L11P_T1U_N8_GC_45_R32
#















































































































































































































## adrv9009

set_location_assignment PIN_AP41   -to ref_clk0               ; ## D04  FMC_HPC_GBTCLK0_M2C_P (NC)
set_location_assignment PIN_AP40   -to "ref_clk0(n)"          ; ## D05  FMC_HPC_GBTCLK0_M2C_N (NC)
set_location_assignment PIN_AK41   -to ref_clk1               ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_location_assignment PIN_AK40   -to "ref_clk1(n)"          ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_location_assignment PIN_BJ43   -to rx_serial_data[0]      ; ## A02  FMC_HPC_DP1_M2C_P
set_location_assignment PIN_BJ42   -to "rx_serial_data[0](n)" ; ## A03  FMC_HPC_DP1_M2C_N
set_location_assignment PIN_BG43   -to rx_serial_data[1]      ; ## A06  FMC_HPC_DP2_M2C_P
set_location_assignment PIN_BG42   -to "rx_serial_data[1](n)" ; ## A07  FMC_HPC_DP2_M2C_N
set_location_assignment PIN_BH41   -to rx_serial_data[2]      ; ## C06  FMC_HPC_DP0_M2C_P
set_location_assignment PIN_BH40   -to "rx_serial_data[2](n)" ; ## C07  FMC_HPC_DP0_M2C_N
set_location_assignment PIN_BE43   -to rx_serial_data[3]      ; ## A10  FMC_HPC_DP3_M2C_P
set_location_assignment PIN_BE42   -to "rx_serial_data[3](n)" ; ## A11  FMC_HPC_DP3_M2C_N
set_location_assignment PIN_BF45   -to tx_serial_data[0]      ; ## A22  FMC_HPC_DP1_C2M_P (tx_serial_data_p[0])
set_location_assignment PIN_BF44   -to "tx_serial_data[0](n)" ; ## A23  FMC_HPC_DP1_C2M_N (tx_serial_data_n[0])
set_location_assignment PIN_BG47   -to tx_serial_data[1]      ; ## A26  FMC_HPC_DP2_C2M_P (tx_serial_data_p[3])
set_location_assignment PIN_BG46   -to "tx_serial_data[1](n)" ; ## A27  FMC_HPC_DP2_C2M_N (tx_serial_data_n[3])
set_location_assignment PIN_BJ46   -to tx_serial_data[2]      ; ## C02  FMC_HPC_DP0_C2M_P (tx_serial_data_p[2])
set_location_assignment PIN_BJ45   -to "tx_serial_data[2](n)" ; ## C03  FMC_HPC_DP0_C2M_N (tx_serial_data_n[2])
set_location_assignment PIN_BE47   -to tx_serial_data[3]      ; ## A30  FMC_HPC_DP3_C2M_P (tx_serial_data_p[1])
set_location_assignment PIN_BE46  -to "tx_serial_data[3](n)"  ; ## A31  FMC_HPC_DP3_C2M_N (tx_serial_data_n[1])

set_instance_assignment -name IO_STANDARD LVDS -to ref_clk0
set_instance_assignment -name IO_STANDARD LVDS -to ref_clk1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_serial_data
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to tx_serial_data

# Merge RX and TX into single transceiver
for {set i 0} {$i < 4} {incr i} {
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to rx_serial_data[${i}]
  set_instance_assignment -name XCVR_RECONFIG_GROUP xcvr_${i} -to tx_serial_data[${i}]
}

set_location_assignment PIN_BC31   -to rx_sync               ; ## G09  FMC_HPC_LA03_P
set_location_assignment PIN_BC32   -to rx_sync(n)            ; ## G10  FMC_HPC_LA03_N
set_location_assignment PIN_BF20   -to rx_os_sync            ; ## G27  FMC_HPC_LA25_P (Sniffer)
set_location_assignment PIN_BG20   -to rx_os_sync(n)         ; ## G28  FMC_HPC_LA25_N (Sniffer)
set_location_assignment PIN_AN20   -to tx_sync               ; ## H07  FMC_HPC_LA02_P
set_location_assignment PIN_AP20   -to tx_sync(n)            ; ## H08  FMC_HPC_LA02_N
set_location_assignment PIN_AW30   -to sysref                ; ## G06  FMC_HPC_LA00_CC_P
set_location_assignment PIN_AW31   -to sysref(n)             ; ## G07  FMC_HPC_LA00_CC_N
set_location_assignment PIN_BH20   -to tx_sync_1             ; ## H28  FMC_HPC_LA24_P
set_location_assignment PIN_BH21   -to tx_sync_1(n)          ; ## H29  FMC_HPC_LA24_N

set_instance_assignment -name IO_STANDARD LVDS -to rx_sync
set_instance_assignment -name IO_STANDARD LVDS -to rx_os_sync
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync
set_instance_assignment -name IO_STANDARD LVDS -to tx_sync_1
set_instance_assignment -name IO_STANDARD LVDS -to sysref
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to tx_sync_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sysref

set_location_assignment PIN_BA30   -to spi_csn_ad9528        ; ## D15  FMC_HPC_LA09_N
set_location_assignment PIN_BA31   -to spi_csn_adrv9009      ; ## D14  FMC_HPC_LA09_P
set_location_assignment PIN_BE32   -to spi_clk               ; ## H13  FMC_HPC_LA07_P
set_location_assignment PIN_BF32   -to spi_mosi              ; ## H14  FMC_HPC_LA07_N
set_location_assignment PIN_BH32   -to spi_miso              ; ## G12  FMC_HPC_LA08_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_ad9528
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_csn_adrv9009
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

set_location_assignment PIN_BH18   -to ad9528_reset_b        ; ## D26  FMC_HPC_LA26_P
set_location_assignment PIN_BJ18   -to ad9528_sysref_req     ; ## D27  FMC_HPC_LA26_N
set_location_assignment PIN_AT21   -to adrv9009_tx1_enable   ; ## D17  FMC_HPC_LA13_P
set_location_assignment PIN_AU32   -to adrv9009_tx2_enable   ; ## C18  FMC_HPC_LA14_P
set_location_assignment PIN_AR21   -to adrv9009_rx1_enable   ; ## D18  FMC_HPC_LA13_N
set_location_assignment PIN_AT32   -to adrv9009_rx2_enable   ; ## C19  FMC_HPC_LA14_N
set_location_assignment PIN_AT15    -to adrv9009_test         ; ## H16  FMC_HPC_LA11_P
set_location_assignment PIN_BC30   -to adrv9009_reset_b      ; ## H10  FMC_HPC_LA04_P
set_location_assignment PIN_BD30   -to adrv9009_gpint        ; ## H11  FMC_HPC_LA04_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to ad9528_sysref_req
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_tx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx1_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_rx2_enable
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_test
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_reset_b
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpint

# single ended default

set_location_assignment PIN_AN17    -to adrv9009_gpio[0]        ; ## H19  FMC_HPC_LA15_P
set_location_assignment PIN_AN18    -to adrv9009_gpio[1]        ; ## H20  FMC_HPC_LA15_N
set_location_assignment PIN_BA20    -to adrv9009_gpio[2]        ; ## G18  FMC_HPC_LA16_P
set_location_assignment PIN_BA21    -to adrv9009_gpio[3]        ; ## G19  FMC_HPC_LA16_N
set_location_assignment PIN_BG18    -to adrv9009_gpio[4]        ; ## H25  FMC_HPC_LA21_P
set_location_assignment PIN_BG19    -to adrv9009_gpio[5]        ; ## H26  FMC_HPC_LA21_N
set_location_assignment PIN_BG17    -to adrv9009_gpio[6]        ; ## C22  FMC_HPC_LA18_CC_P
set_location_assignment PIN_BH17    -to adrv9009_gpio[7]        ; ## C23  FMC_HPC_LA18_CC_N
set_location_assignment PIN_BJ36    -to adrv9009_gpio[8]        ; ## G25  FMC_HPC_LA22_N     (LVDS_1N)
set_location_assignment PIN_BE18    -to adrv9009_gpio[9]        ; ## H22  FMC_HPC_LA19_P     (LVDS_2P)
set_location_assignment PIN_BD18    -to adrv9009_gpio[10]       ; ## H23  FMC_HPC_LA19_N     (LVDS_2N)
set_location_assignment PIN_AN21    -to adrv9009_gpio[11]       ; ## G21  FMC_HPC_LA20_P     (LVDS_3P)
set_location_assignment PIN_AP21    -to adrv9009_gpio[12]       ; ## G22  FMC_HPC_LA20_N     (LVDS_3N)
set_location_assignment PIN_AU28    -to adrv9009_gpio[13]       ; ## G16  FMC_HPC_LA12_N     (LVDS_4N)
set_location_assignment PIN_AU29    -to adrv9009_gpio[14]       ; ## G15  FMC_HPC_LA12_P     (LVDS_4P)
set_location_assignment PIN_BJ35    -to adrv9009_gpio[15]       ; ## G24  FMC_HPC_LA22_P     (LVDS_1P)
set_location_assignment PIN_BF30    -to adrv9009_gpio[16]       ; ## C11  FMC_HPC_LA06_N     (LVDS_5N)
set_location_assignment PIN_BF31    -to adrv9009_gpio[17]       ; ## C10  FMC_HPC_LA06_P     (LVDS_5P)
set_location_assignment PIN_BH30    -to adrv9009_gpio[18]       ; ## D12  FMC_HPC_LA05_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to adrv9009_gpio[18]

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

#execute_flow -compile
