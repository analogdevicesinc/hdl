
## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr 64*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr 64*1024]


source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0

source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Parameters for 15.5Gpbs lane rate

ad_ip_parameter util_mxfe_xcvr CONFIG.RX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG1 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_mxfe_xcvr CONFIG.A_TXDIFFCTRL 0xc
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG0 0x3
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN2 0x265
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
ad_ip_parameter util_mxfe_xcvr CONFIG.CH_HSPMUX 0x6868
ad_ip_parameter util_mxfe_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x4
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_PI_BIASSET 3

ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_mxfe_xcvr CONFIG.POR_CFG 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG4 0x45
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_mxfe_xcvr CONFIG.PPF0_CFG 0xF00
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP 0xFF
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP_G3 0xF
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_LPF 0x2FF

# Overwrite parameter for lower lane rates which use CPLL
if {$ad_project_params(RX_LANE_RATE) < 12} {
  ad_ip_parameter util_mxfe_xcvr CONFIG.RX_WIDEMODE_CDR 0x0
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x200
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0xFD

  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
}

# spi

create_bd_port -dir O -from 3 -to 0 spi_csn_o
create_bd_port -dir I -from 3 -to 0 spi_csn_i
create_bd_port -dir I spi_clk_i
create_bd_port -dir O spi_clk_o
create_bd_port -dir I spi_sdo_i
create_bd_port -dir O spi_sdo_o
create_bd_port -dir I spi_sdi_i

ad_ip_instance axi_quad_spi axi_spi
ad_ip_parameter axi_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 8

ad_connect spi_csn_i axi_spi/ss_i
ad_connect spi_csn_o axi_spi/ss_o
ad_connect spi_clk_i axi_spi/sck_i
ad_connect spi_clk_o axi_spi/sck_o
ad_connect spi_sdo_i axi_spi/io0_i
ad_connect spi_sdo_o axi_spi/io0_o
ad_connect spi_sdi_i axi_spi/io1_i

ad_connect sys_cpu_clk axi_spi/ext_spi_clk

# iic

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_ka_band

ad_ip_instance axi_iic axi_iic_ka_band
ad_connect iic_ka_band axi_iic_ka_band/iic

# AXI address definitions

ad_cpu_interconnect 0x44000000 axi_spi
ad_cpu_interconnect 0x44500000 axi_iic_ka_band

# interrupts

ad_cpu_interrupt "ps-3" "mb-3" axi_spi/ip2intc_irpt
ad_cpu_interrupt "ps-4" "mb-4" axi_iic_ka_band/iic2intc_irpt
