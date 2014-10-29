
# daq2

set_property  -dict {PACKAGE_PIN  H6} [get_ports rx_ref_clk_p]                                      ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  H5} [get_ports rx_ref_clk_n]                                      ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_property  -dict {PACKAGE_PIN  A4} [get_ports rx_data_p[0]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  A3} [get_ports rx_data_n[0]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  E4} [get_ports rx_data_p[1]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E3} [get_ports rx_data_n[1]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  B2} [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  B1} [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  D2} [get_ports rx_data_p[3]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D1} [get_ports rx_data_n[3]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  G9  IOSTANDARD LVDS} [get_ports rx_sync_p]                        ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  F9  IOSTANDARD LVDS} [get_ports rx_sync_n]                        ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  A13 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_p]       ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  A12 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_n]       ; ## G10  FMC_HPC_LA03_N


set_property  -dict {PACKAGE_PIN  K6} [get_ports tx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  K5} [get_ports tx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  B6} [get_ports tx_data_p[0]]                                      ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  B5} [get_ports tx_data_n[0]]                                      ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[1]]                                      ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[1]]                                      ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  C4} [get_ports tx_data_p[2]]                                      ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  C3} [get_ports tx_data_n[2]]                                      ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  D6} [get_ports tx_data_p[3]]                                      ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  D5} [get_ports tx_data_n[3]]                                      ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[2])
set_property  -dict {PACKAGE_PIN  K10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]         ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  J10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]         ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  L12 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sysref_p]       ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  K12 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sysref_n]       ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  L13 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L8  IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                  ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  H9  IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                  ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  K13 IOSTANDARD LVCMOS18} [get_ports spi_clk]                      ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  J9  IOSTANDARD LVCMOS18} [get_ports spi_sdio]                     ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  H8  IOSTANDARD LVCMOS18} [get_ports spi_dir]                      ; ## G13  FMC_HPC_LA08_N

set_property  -dict {PACKAGE_PIN  J8  IOSTANDARD LVCMOS18} [get_ports clkd_sync]                    ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  K8  IOSTANDARD LVCMOS18} [get_ports dac_reset]                    ; ## C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  D10 IOSTANDARD LVCMOS18} [get_ports dac_txen]                     ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  D13 IOSTANDARD LVCMOS18} [get_ports adc_pd]                       ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  D9  IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]               ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  C9  IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]               ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  E10 IOSTANDARD LVCMOS18} [get_ports dac_irq]                      ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  K11 IOSTANDARD LVCMOS18} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  J11 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  F8  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports trig_p]            ; ## H13  FMC_HPC_LA07_P          
set_property  -dict {PACKAGE_PIN  E8  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports trig_n]            ; ## H14  FMC_HPC_LA07_N          

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_nets i_system_wrapper/system_i/axi_daq2_gt_tx_clk]
create_clock -name rx_div_clk   -period  4.00 [get_nets i_system_wrapper/system_i/axi_daq2_gt_rx_clk]


# LUTRAM Constraint Information
#
# Luc_Board=KCU105 SN=1280723c158 DV=N8F250_3_3_6 LOCs=151
# Doug_Board=KCU105 SN=1280723c199 DV=N8F246_2_19_10 LOCs=131
# Rejeesh_Board=KCU105 SN=1280723c020 DV=N8F245_3_10_3 LOCs=0
# Michael_Board=KCU105 SN=1280723c031 DV=N8F245_3_0_7 LOCs=2
#
###################################################
# NOTE: Ensure that the following constraints are  
# in place for ALL Designs                         
###################################################
set_property PROHIBIT true [get_bels {SLICE_X23Y295/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y282/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y279/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X58Y277/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y231/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y202/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X82Y185/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X58Y184/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y172/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y146/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X20Y141/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y134/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X66Y122/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y101/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X82Y87/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y83/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X79Y75/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X82Y71/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X5Y56/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y38/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y13/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y49/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X67Y68/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X18Y101/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X4Y119/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y145/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y170/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y175/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y176/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y185/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X45Y202/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X53Y227/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y254/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X64Y271/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y289/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y263/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y254/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X20Y246/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y245/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X79Y188/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X66Y185/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y158/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X20Y154/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y133/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X13Y125/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y73/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X40Y41/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y27/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y13/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y23/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X94Y57/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y154/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y183/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y202/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X23Y214/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y216/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y218/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y219/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y222/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y228/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y260/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X71Y285/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X79Y183/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X58Y164/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y137/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X64Y159/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y220/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y198/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X76Y170/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y20/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y149/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y256/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y236/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y158/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y129/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y84/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X18Y82/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X26Y50/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y30/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y24/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X26Y10/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y44/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y68/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y82/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y82/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y164/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y184/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y190/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y196/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y200/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X94Y204/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y230/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y240/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y260/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y268/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X53Y272/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y286/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y290/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y296/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y266/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y242/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X76Y240/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y212/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y190/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y176/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X20Y176/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y130/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X58Y112/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y102/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y100/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y90/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y71/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y67/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X4Y27/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y1/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X32Y29/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y33/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y55/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y69/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y85/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X71Y93/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X78Y95/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y111/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y129/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y191/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y205/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y219/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X67Y225/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X11Y227/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X64Y231/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X45Y245/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y267/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y271/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y271/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y293/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y293/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y299/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y281/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y269/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y265/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X1Y257/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X76Y255/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X13Y227/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y219/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y217/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y215/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X72Y215/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y205/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y195/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y183/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y119/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y222/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y256/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y268/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y239/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y232/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y179/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y166/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X69Y149/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y134/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X72Y52/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y9/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X13Y1/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y22/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y33/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X18Y47/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y72/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y77/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X67Y107/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y122/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y148/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y173/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X94Y179/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X45Y200/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X71Y213/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X94Y234/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y221/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X32Y220/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X1Y166/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X32Y158/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y95/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X32Y85/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X82Y77/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y42/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X1Y21/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X29Y16/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X5Y14/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X67Y20/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y28/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X61Y40/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y70/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y71/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X67Y76/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y92/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X23Y130/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y151/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X4Y180/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X7Y198/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X43Y268/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y48/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X81Y3/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y76/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X13Y192/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y149/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y137/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X13Y135/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X1Y105/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y62/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y56/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X30Y76/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y82/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X38Y74/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y8/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X79Y58/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X79Y74/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y98/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X57Y238/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y254/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y284/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y274/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X52Y252/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X48Y246/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X100Y236/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X58Y228/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X55Y138/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X17Y122/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y96/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X5Y90/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X50Y55/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y51/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X53Y45/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X42Y15/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X71Y3/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y7/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X24Y25/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y39/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X75Y93/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X35Y95/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X23Y103/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y157/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X15Y251/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X53Y287/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X62Y283/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X20Y265/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X82Y245/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y231/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X66Y199/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X40Y143/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X32Y121/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X36Y119/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X18Y166/*LUT}]
set_property PROHIBIT true [get_bels {SLICE_X10Y246/*LUT}]

# Total  Slices for all devices 284
# Unique Slices for all devices 252

