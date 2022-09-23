## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/ad_quadmxfe1_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# Set SPI clock to 100/16 =  6.25 MHz
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 16

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

if {$ad_project_params(JESD_MODE) == "8B10B"} {
  # Parameters for 10Gpbs lane rate
  ad_ip_parameter util_mxfe_xcvr CONFIG.RX_CLK25_DIV 20
  ad_ip_parameter util_mxfe_xcvr CONFIG.TX_CLK25_DIV 20
  ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG0 0x3fe
  ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG1 0x29
  ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG2 0x203
  ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV 2
  ad_ip_parameter util_mxfe_xcvr CONFIG.A_TXDIFFCTRL 0xc
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG0 0x3
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN2 0x265
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.CH_HSPMUX 0x2020
  ad_ip_parameter util_mxfe_xcvr CONFIG.PREIQ_FREQ_BST 0
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x1002
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0x15
  ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG 0x54
  ad_ip_parameter util_mxfe_xcvr CONFIG.TX_PI_BIASSET 0

  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_REFCLK_DIV 1
  ad_ip_parameter util_mxfe_xcvr CONFIG.POR_CFG 0x0
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG0 0x331c
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG2 0xFC1
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG2_G3 0xFC1
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG4 0x1
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_FBDIV 20
  ad_ip_parameter util_mxfe_xcvr CONFIG.PPF0_CFG 0x400
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP 0xFF
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP_G3 0xF
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_LPF 0x27F
} else {
  ad_ip_instance util_ds_buf sys_cpu_clk_BUFGCE
  ad_ip_parameter sys_cpu_clk_BUFGCE CONFIG.C_BUF_TYPE {BUFGCE_DIV}
  ad_ip_parameter sys_cpu_clk_BUFGCE CONFIG.C_BUFGCE_DIV 2
  ad_connect sys_cpu_clk_BUFGCE/BUFGCE_CE VCC
  ad_connect sys_cpu_clk_BUFGCE/BUFGCE_CLR GND
  ad_connect sys_cpu_clk_BUFGCE/BUFGCE_I $sys_cpu_clk

  ad_connect  sys_cpu_clk_BUFGCE/BUFGCE_O jesd204_phy_121_122/drpclk
  ad_connect  sys_cpu_clk_BUFGCE/BUFGCE_O jesd204_phy_125_126/drpclk
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

ad_cpu_interrupt ps-15 mb-6 axi_spi_3/ip2intc_irpt

ad_cpu_interconnect 0x44B80000 axi_spi_3
