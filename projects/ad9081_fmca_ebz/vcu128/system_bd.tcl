## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/library/util_hbm/scripts/adi_util_hbm.tcl
ad_create_hbm HBM

source $ad_hdl_dir/projects/common/vcu128/vcu128_system_bd.tcl
source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl


ad_connect_hbm HBM mxfe_rx_data_offload/storage_unit $sys_hbm_clk $sys_hbm_resetn 0
ad_connect_hbm HBM mxfe_tx_data_offload/storage_unit $sys_hbm_clk $sys_hbm_resetn 4

ad_ip_parameter $adc_data_offload_name/i_data_offload CONFIG.HAS_BYPASS false
ad_ip_parameter $dac_data_offload_name/i_data_offload CONFIG.HAS_BYPASS false

ad_connect HBM/HBM_REF_CLK_0 $sys_cpu_clk
ad_connect HBM/APB_0_PCLK $sys_cpu_clk
ad_connect HBM/APB_0_PRESET_N $sys_cpu_resetn

ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Parameters for 15.5Gpbs lane rate

ad_ip_parameter util_mxfe_xcvr CONFIG.RX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG1 0x2b
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_mxfe_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_mxfe_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_mxfe_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2 0x1E9
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_WIDEMODE_CDR 0x1
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_XMODE_SEL 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TXDRV_FREQBAND 1
ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG1 0xAA00
ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG2 0xAA00
ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG3 0xAA00
ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG0 0x3100
ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG1 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_PI_BIASSET 1
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0x54

ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_mxfe_xcvr CONFIG.PPF0_CFG 0xB00
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_LPF 0x2ff

# 204C params 16.5Gbps..24.75Gpbs
if {$ad_project_params(JESD_MODE) == "64B66B"} {

  # Set higher swing for the diff driver, other case 16.5Gbps won't work
  ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.TX_DIFFCTRL 0xC

  # Lane rate indepentent parameters
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0x0
  ad_ip_parameter util_mxfe_xcvr CONFIG.RX_WIDEMODE_CDR 0x2
  ad_ip_parameter util_mxfe_xcvr CONFIG.CH_HSPMUX 0x6060
  ad_ip_parameter util_mxfe_xcvr CONFIG.PREIQ_FREQ_BST 2
  ad_ip_parameter util_mxfe_xcvr CONFIG.TX_PI_BIASSET 2
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXDFE_KH_CFG2 0x281C
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXDFE_KH_CFG3 0x4120

  # Lane rate indepentent QPLL parameters
  ad_ip_parameter util_mxfe_xcvr CONFIG.PPF0_CFG 0x600
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG0 0x331c

  # Lane rate dependent QPLL params (these match for 16.5 Gbps and 24.75 Gpbs)
  ad_ip_parameter util_mxfe_xcvr CONFIG.PPF1_CFG 0x400
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_LPF 0x33f
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG2 0x0FC1
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG2_G3 0x0FC1
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG4 0x03

  # set dividers for 24.75Gbps, are overwritten by software
  ad_ip_parameter util_mxfe_xcvr CONFIG.RX_CLK25_DIV 10
  ad_ip_parameter util_mxfe_xcvr CONFIG.TX_CLK25_DIV 10
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_FBDIV 66
  ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_REFCLK_DIV 2

  if {$ad_project_params(RX_LANE_RATE) < 20} {
    ad_ip_parameter util_mxfe_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
    ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x0104
  } else {
    ad_ip_parameter util_mxfe_xcvr CONFIG.RTX_BUF_CML_CTRL 0x6
    ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x3004
  }

  if {$ad_project_params(TX_LANE_RATE) < 20} {
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXDRV_FREQBAND   1
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG0 0x3C2
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG1 0xAA00
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG2 0xAA00
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG3 0xAA00
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG0 0x0100
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG1 0x1000
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXSWBST_EN 0
  } else {
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXDRV_FREQBAND   3
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG0 0x3C6
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG1 0xF800
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG2 0xF800
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXFE_CFG3 0xF800
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG0 0x3000
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG1 0x0
    ad_ip_parameter util_mxfe_xcvr CONFIG.TXSWBST_EN 1
  }

}

