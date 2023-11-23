###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# reference LVDS CLOCK
create_clock -name     {clk_125Mhz} -period 8 -waveform {0 4}      [get_ports ref_clk_125_p];
ldc_set_port -iobuf    {IO_TYPE=LVDS}                              [get_ports ref_clk_125_p];
ldc_set_location -site {AD21}                                      [get_ports ref_clk_125_p]; ## H04  FMC_LPC_CLK0_M2C_P
create_clock -name     {rx_clk_125Mhz} -period 8 -waveform {0 4}   [get_ports ref_clk_125_p];

# RGMII A

ldc_set_location -site {AC12} [get_ports  rgmii_rxc_a    ];    ## G06 FMC_LPC_LA00_CC_
ldc_set_location -site {AB7}  [get_ports  rgmii_rx_ctl_a ];    ## H14 FMC_LPC_LA07_N
ldc_set_location -site {AF4}  [get_ports {rgmii_rxd_a[0]}];    ## H07 FMC_LPC_LA02_P
ldc_set_location -site {AF3}  [get_ports {rgmii_rxd_a[1]}];    ## H08 FMC_LPC_LA02_N
ldc_set_location -site {AD4}  [get_ports {rgmii_rxd_a[2]}];    ## G09 FMC_LPC_LA03_P
ldc_set_location -site {AE4}  [get_ports {rgmii_rxd_a[3]}];    ## G10 FMC_LPC_LA03_N
ldc_set_location -site {AC6}  [get_ports  rgmii_txc_a    ];    ## H11 FMC_LPC_LA04_N
ldc_set_location -site {AC7}  [get_ports  rgmii_tx_ctl_a ];    ## H13 FMC_LPC_LA07_P
ldc_set_location -site {AD6}  [get_ports {rgmii_txd_a[0]}];    ## D14 FMC_LPC_LA09_P
ldc_set_location -site {AE6}  [get_ports {rgmii_txd_a[1]}];    ## D15 FMC_LPC_LA09_N
ldc_set_location -site {AD5}  [get_ports {rgmii_txd_a[2]}];    ## C10 FMC_LPC_LA06_P
ldc_set_location -site {AE5}  [get_ports {rgmii_txd_a[3]}];    ## C11 FMC_LPC_LA06_N

ldc_set_location -site {AF10} [get_ports mdio_fmc_a];          ## H16 FMC_LPC_LA11_P
ldc_set_location -site {AF9}  [get_ports mdc_fmc_a];           ## H17 FMC_LPC_LA11_N


ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_rxc_a]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_rx_ctl_a]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_a[0]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_a[1]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_a[2]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_a[3]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_txc_a]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_tx_ctl_a]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_a[0]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_a[1]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_a[2]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_a[3]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H PULLMODE=UP} [get_ports mdio_fmc_a]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports mdc_fmc_a]

# RGMII B

ldc_set_location -site {AC25} [get_ports  mdio_fmc_b     ];    ## H31 FMC_LPC_LA28_P
ldc_set_location -site {AD26} [get_ports  mdc_fmc_b      ];    ## H32 FMC_LPC_LA28_N
ldc_set_location -site {AD25} [get_ports  rgmii_rxc_b    ];    ## C22 FMC_LPC_LA18_CC_
ldc_set_location -site {AF25} [get_ports  rgmii_rx_ctl_b ];    ## H29 FMC_LPC_LA24_N
ldc_set_location -site {AD9}  [get_ports {rgmii_rxd_b[0]}];    ## H22 FMC_LPC_LA19_P
ldc_set_location -site {AE9}  [get_ports {rgmii_rxd_b[1]}];    ## H23 FMC_LPC_LA19_N
ldc_set_location -site {AB9}  [get_ports {rgmii_rxd_b[2]}];    ## G21 FMC_LPC_LA20_P
ldc_set_location -site {AC9}  [get_ports {rgmii_rxd_b[3]}];    ## G22 FMC_LPC_LA20_N
ldc_set_location -site {AF24} [get_ports  rgmii_txc_b    ];    ## G28 FMC_LPC_LA25_N
ldc_set_location -site {AE26} [get_ports  rgmii_tx_ctl_b ];    ## H28 FMC_LPC_LA24_P
ldc_set_location -site {AC22} [get_ports {rgmii_txd_b[0]}];    ## H25 FMC_LPC_LA21_P
ldc_set_location -site {AD23} [get_ports {rgmii_txd_b[1]}];    ## H26 FMC_LPC_LA21_N
ldc_set_location -site {AB22} [get_ports {rgmii_txd_b[2]}];    ## G24 FMC_LPC_LA22_P
ldc_set_location -site {AA22} [get_ports {rgmii_txd_b[3]}];    ## G25 FMC_LPC_LA22_N


ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_rxc_b]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_rx_ctl_b]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_b[0]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_b[1]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_b[2]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_rxd_b[3]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_txc_b]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports rgmii_tx_ctl_b]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_b[0]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_b[1]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_b[2]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports {rgmii_txd_b[3]}]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H PULLMODE=UP} [get_ports mdio_fmc_b]
ldc_set_port -iobuf {IO_TYPE=LVCMOS18H}             [get_ports mdc_fmc_b]

# GPIOs

ldc_set_location -site {V7} [get_ports refl_uc];        ## PMOD1_1
ldc_set_location -site {V6} [get_ports refr_uc];        ## PMOD1_2
ldc_set_location -site {V5} [get_ports drv_enn_cfg6];   ## PMOD1_3
ldc_set_location -site {V4} [get_ports enca_dcin_cfg5]; ## PMOD1_4
ldc_set_location -site {V8} [get_ports encb_dcen_cfg4]; ## PMOD1_5
ldc_set_location -site {W7} [get_ports encn_dco];       ## PMOD1_6
ldc_set_location -site {W6} [get_ports swsel];          ## PMOD1_7
ldc_set_location -site {W5} [get_ports swn_diag0];      ## PMOD1_8

ldc_set_location -site {W4} [get_ports swp_diag1];      ## PMOD2_5
ldc_set_location -site {Y4} [get_ports ain_ref_sw];     ## PMOD2_6
ldc_set_location -site {AB2} [get_ports ain_ref_pwm];   ## PMOD2_7

#GLOBAL

create_clock -name {cdro_srclk} -period 8 [get_pins {ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/Itq3L2tct7FerB3d8hGvfrtpro75mshmvyIfv8pKD9htr5uaIF56su/Ic8mD3mf7ca3d/Ib3jrtbc5zKHeHhc.SGMIICDR_inst/SRCLK }]
create_generated_clock -name {clk_625m_pllo} -source [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/I3tJjeqII8tr4nAKC2Exhjp59nzwq0quimx2nc4IB/Ie7u3I1okj5gspDg7v8u/IFkuqAIm.PLL_inst/REFCK] -multiply_by 5 [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/I3tJjeqII8tr4nAKC2Exhjp59nzwq0quimx2nc4IB/Ie7u3I1okj5gspDg7v8u/IFkuqAIm.PLL_inst/CLKOS]
create_generated_clock -name {clk_125m_pllo} -source [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/I3tJjeqII8tr4nAKC2Exhjp59nzwq0quimx2nc4IB/Ie7u3I1okj5gspDg7v8u/IFkuqAIm.PLL_inst/REFCK] -divide_by 1 [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/I3tJjeqII8tr4nAKC2Exhjp59nzwq0quimx2nc4IB/Ie7u3I1okj5gspDg7v8u/IFkuqAIm.PLL_inst/CLKOP]
create_generated_clock -name {usr_clk_o} -source [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/Itq3L2tct7FerB3d8hGvfrtpro75mshmvyIfv8pKD9htr5uaIF56su/Ic8mD3mf7ca3d/Ie1D4cusnc/Ib3d1wzatFFA23xg.ECLKDIV_inst/ECLKIN] -divide_by 5 [get_pins ether_control_inst/Ethercon_IP_top_inst/Ethercon_IP_inst/IbIKu9Euqsdu5EvdFwxj4nB23qKA1cbeKy5hkyxle428hA/Itq3L2tct7FerB3d8hGvfrtpro75mshmvyIfv8pKD9htr5uaIF56su/Ic8mD3mf7ca3d/Ie1D4cusnc/Ib3d1wzatFFA23xg.ECLKDIV_inst/DIVOUT]

set_false_path -from [get_clocks clk_125Mhz] -to [get_clocks usr_clk_o]
set_false_path -from [get_clocks usr_clk_o] -to [get_clocks clk_125Mhz]

#clk_125Mhz

set_max_delay -from [get_clocks rx_clk_125Mhz] -to [get_clocks clk_125Mhz] 8
set_max_delay -from [get_clocks clk_125m_pllo] -to [get_clocks clk_125Mhz] 8


#rx_clk_125Mhz

set_max_delay -from [get_clocks clk_125Mhz] -to [get_clocks rx_clk_125Mhz] 8

#cdro_srclk

set_max_delay -from [get_clocks clk_125Mhz] -to [get_clocks cdro_srclk] 8
set_max_delay -from [get_clocks usr_clk_o] -to [get_clocks cdro_srclk] 8
set_max_delay -from [get_clocks clk_125m_pllo] -to [get_clocks cdro_srclk] 8

#usr_clk_o

set_max_delay -from [get_clocks cdro_srclk] -to [get_clocks usr_clk_o] 8
set_max_delay -from [get_clocks clk_125m_pllo] -to [get_clocks usr_clk_o] 8

#clk_625m_pllo

set_max_delay -from [get_clocks clk_125m_pllo] -to [get_clocks clk_625m_pllo] 6.5
set_max_delay -from [get_clocks usr_clk_o] -to [get_clocks clk_625m_pllo] 6.5

#clk_125m_pllo

set_max_delay -from [get_clocks clk_125Mhz] -to [get_clocks clk_125m_pllo] 8
set_max_delay -from [get_clocks cdro_srclk] -to [get_clocks clk_125m_pllo] 8
set_max_delay -from [get_clocks usr_clk_o] -to [get_clocks clk_125m_pllo] 8
