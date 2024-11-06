## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../../quad_apollo/common/ad_xband16_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 3
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

# Set SPI clock to 100/32 = 3.125 MHz
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi CONFIG.Multiples16 2

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Parameters for 15.5Gpbs lane rate

ad_ip_parameter util_apollo_xcvr CONFIG.RX_CLK25_DIV 31
ad_ip_parameter util_apollo_xcvr CONFIG.TX_CLK25_DIV 31
ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_CFG1 0x2b
ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_apollo_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_apollo_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_apollo_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_apollo_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG2 0x1E9
ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3 0x23
ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN2 0x23
ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN3 0x23
ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN4 0x23
ad_ip_parameter util_apollo_xcvr CONFIG.RX_WIDEMODE_CDR 0x1
ad_ip_parameter util_apollo_xcvr CONFIG.RX_XMODE_SEL 0x0
ad_ip_parameter util_apollo_xcvr CONFIG.TXDRV_FREQBAND 1
ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG1 0xAA00
ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG2 0xAA00
ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG3 0xAA00
ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG0 0x3100
ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG1 0x0
ad_ip_parameter util_apollo_xcvr CONFIG.TX_PI_BIASSET 1
ad_ip_parameter util_apollo_xcvr CONFIG.RXPI_CFG1 0x54

ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_apollo_xcvr CONFIG.PPF0_CFG 0xB00
ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_LPF 0x2ff

# 204C params 26.4 Gpbs
if {$ad_project_params(JESD_MODE) == "64B66B"} {

  # Set higher swing for the diff driver, other case 16.5Gbps won't work
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.TX_DIFFCTRL 0xC

  # Lane rate indepentent parameters
  ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3 0x10
  ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN2 0x10
  ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN3 0x10
  ad_ip_parameter util_apollo_xcvr CONFIG.RXCDR_CFG3_GEN4 0x10
  ad_ip_parameter util_apollo_xcvr CONFIG.RXPI_CFG1 0x0
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_WIDEMODE_CDR 0x2
  ad_ip_parameter util_apollo_xcvr CONFIG.CH_HSPMUX 0x9090
  ad_ip_parameter util_apollo_xcvr CONFIG.PREIQ_FREQ_BST 3
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_PI_BIASSET 3
  ad_ip_parameter util_apollo_xcvr CONFIG.RXDFE_KH_CFG2 0x281C
  ad_ip_parameter util_apollo_xcvr CONFIG.RXDFE_KH_CFG3 0x4120

  # Lane rate indepentent QPLL parameters
  ad_ip_parameter util_apollo_xcvr CONFIG.PPF0_CFG 0x900
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG0 0x331c

  # Lane rate dependent QPLL params (these match for 26.4 Gpbs)
  ad_ip_parameter util_apollo_xcvr CONFIG.PPF1_CFG 0x600
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_LPF 0x37f
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG2 0x0FC1
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG2_G3 0x0FC1
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_CFG4 0x84

  # set dividers for 26.4 Gbps, are overwritten by software
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_CLK25_DIV 16
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_CLK25_DIV 16
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_FBDIV 33
  ad_ip_parameter util_apollo_xcvr CONFIG.QPLL_REFCLK_DIV 1

  if {$ad_project_params(RX_LANE_RATE) < 20} {
    ad_ip_parameter util_apollo_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
    ad_ip_parameter util_apollo_xcvr CONFIG.RXPI_CFG0 0x0104
  } else {
    ad_ip_parameter util_apollo_xcvr CONFIG.RTX_BUF_CML_CTRL 0x7
    ad_ip_parameter util_apollo_xcvr CONFIG.RXPI_CFG0 0x3006
  }

  if {$ad_project_params(TX_LANE_RATE) < 20} {
    ad_ip_parameter util_apollo_xcvr CONFIG.TXDRV_FREQBAND   1
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG0 0x3C2
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG1 0xAA00
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG2 0xAA00
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG3 0xAA00
    ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG0 0x0100
    ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG1 0x1000
    ad_ip_parameter util_apollo_xcvr CONFIG.TXSWBST_EN 0
  } else {
    ad_ip_parameter util_apollo_xcvr CONFIG.TXDRV_FREQBAND   3
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG0 0x3C6
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG1 0xF800
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG2 0xF800
    ad_ip_parameter util_apollo_xcvr CONFIG.TXFE_CFG3 0xF800
    ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG0 0x3000
    ad_ip_parameter util_apollo_xcvr CONFIG.TXPI_CFG1 0x0
    ad_ip_parameter util_apollo_xcvr CONFIG.TXSWBST_EN 1
  }

}

# Second SPI controller
create_bd_port -dir O -from 7 -to 0 spi_2_csn_o
create_bd_port -dir I -from 7 -to 0 spi_2_csn_i
create_bd_port -dir I spi_2_clk_i
create_bd_port -dir O spi_2_clk_o
create_bd_port -dir I spi_2_sdo_i
create_bd_port -dir O spi_2_sdo_o
create_bd_port -dir I spi_2_sdi_i

ad_ip_instance axi_quad_spi axi_spi_2
ad_ip_parameter axi_spi_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_2 CONFIG.C_SCK_RATIO 8
# ad_ip_parameter axi_spi_2 CONFIG.Multiples16 8

ad_connect spi_2_csn_i axi_spi_2/ss_i
ad_connect spi_2_csn_o axi_spi_2/ss_o
ad_connect spi_2_clk_i axi_spi_2/sck_i
ad_connect spi_2_clk_o axi_spi_2/sck_o
ad_connect spi_2_sdo_i axi_spi_2/io0_i
ad_connect spi_2_sdo_o axi_spi_2/io0_o
ad_connect spi_2_sdi_i axi_spi_2/io1_i

ad_connect sys_cpu_clk axi_spi_2/ext_spi_clk

ad_cpu_interrupt ps-15 mb-7 axi_spi_2/ip2intc_irpt

ad_cpu_interconnect 0x44A80000 axi_spi_2

# Third SPI controller
create_bd_port -dir O -from 7 -to 0 spi_3_csn_o
create_bd_port -dir I -from 7 -to 0 spi_3_csn_i
create_bd_port -dir I spi_3_clk_i
create_bd_port -dir O spi_3_clk_o
create_bd_port -dir I spi_3_sdo_i
create_bd_port -dir O spi_3_sdo_o
create_bd_port -dir I spi_3_sdi_i

ad_ip_instance axi_quad_spi axi_spi_3
ad_ip_parameter axi_spi_3 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_3 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_3 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_3 CONFIG.Multiples16 16

ad_connect spi_3_csn_i axi_spi_3/ss_i
ad_connect spi_3_csn_o axi_spi_3/ss_o
ad_connect spi_3_clk_i axi_spi_3/sck_i
ad_connect spi_3_clk_o axi_spi_3/sck_o
ad_connect spi_3_sdo_i axi_spi_3/io0_i
ad_connect spi_3_sdo_o axi_spi_3/io0_o
ad_connect spi_3_sdi_i axi_spi_3/io1_i

ad_connect sys_cpu_clk axi_spi_3/ext_spi_clk

ad_cpu_interrupt ps-9 mb-16 axi_spi_3/ip2intc_irpt

ad_cpu_interconnect 0x44B80000 axi_spi_3

set_property range 256K [get_bd_addr_segs {sys_mb/Data/SEG_data_axi_hsci_0}]
set_property range 256K [get_bd_addr_segs {sys_mb/Data/SEG_data_axi_hsci_1}]
set_property range 256K [get_bd_addr_segs {sys_mb/Data/SEG_data_axi_hsci_2}]
set_property range 256K [get_bd_addr_segs {sys_mb/Data/SEG_data_axi_hsci_3}]
