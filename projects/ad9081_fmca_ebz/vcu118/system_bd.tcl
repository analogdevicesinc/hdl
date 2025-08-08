###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

if {$INTF_CFG != "TX"} {
  ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
}
if {$INTF_CFG != "RX"} {
  ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
KS/CH=$ad_project_params(RX_KS_PER_CHANNEL)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
KS/CH=$ad_project_params(TX_KS_PER_CHANNEL)"

sysid_gen_sys_init_file $sys_cstring 10

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

ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE default_250mhz_clk1
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE ddr4_sdram_c1_062

if {$ad_project_params(CORUNDUM) == "1"} {

  source $ad_hdl_dir/library/corundum/scripts/corundum_vcu118_cfg.tcl
  set APP_ENABLE 0
  source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

  ad_ip_parameter axi_dp_interconnect CONFIG.NUM_CLKS 3
  ad_connect axi_dp_interconnect/aclk2 sys_250m_clk

  ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ 125
  set_property name sys_125m_rstgen [get_bd_cells sys_500m_rstgen]

  ad_connect corundum_rstgen/slowest_sync_clk sys_250m_clk
  ad_connect corundum_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst

  create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi0
  create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi1
  create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp

  create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
  create_bd_port -dir O fpga_boot
  create_bd_port -dir O -type clk qspi_clk
  create_bd_port -dir I -type rst ptp_rst
  set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports ptp_rst]
  create_bd_port -dir I -type clk qsfp_mgt_refclk
  create_bd_port -dir I -type clk qsfp_mgt_refclk_bufg

  create_bd_port -dir O -type clk clk_125mhz
  create_bd_port -dir O -type clk clk_250mhz

  ad_connect sys_500m_clk clk_125mhz
  ad_connect sys_250m_clk clk_250mhz

  ad_connect corundum_hierarchy/clk_125mhz clk_125mhz
  ad_connect corundum_hierarchy/clk_corundum sys_250m_clk

  ad_connect corundum_hierarchy/rst_125mhz sys_125m_rstgen/peripheral_reset

  ad_connect corundum_hierarchy/qspi0 qspi0
  ad_connect corundum_hierarchy/qspi1 qspi1
  ad_connect corundum_hierarchy/qsfp qsfp
  ad_connect corundum_hierarchy/qsfp_rst qsfp_rst
  ad_connect corundum_hierarchy/fpga_boot fpga_boot
  ad_connect corundum_hierarchy/qspi_clk qspi_clk
  ad_connect corundum_hierarchy/ptp_rst ptp_rst
  ad_connect corundum_hierarchy/qsfp_mgt_refclk qsfp_mgt_refclk
  ad_connect corundum_hierarchy/qsfp_mgt_refclk_bufg qsfp_mgt_refclk_bufg

  ad_cpu_interconnect 0x50000000 corundum_hierarchy s_axil_corundum
  ad_cpu_interconnect 0x52000000 corundum_gpio_reset

  ad_mem_hp1_interconnect sys_250m_clk corundum_hierarchy/m_axi

  ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq

  if {$APP_ENABLE == 1} {
    set INPUT_CHANNELS $RX_NUM_OF_CONVERTERS
    set INPUT_SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL
    set INPUT_SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH

    set INPUT_WIDTH [expr $INPUT_CHANNELS*$INPUT_SAMPLES_PER_CHANNEL*$INPUT_SAMPLE_DATA_WIDTH]

    set OUTPUT_CHANNELS $TX_NUM_OF_CONVERTERS
    set OUTPUT_SAMPLES $TX_SAMPLES_PER_CHANNEL
    set OUTPUT_SAMPLE_WIDTH $TX_DMA_SAMPLE_WIDTH

    set OUTPUT_WIDTH [expr $OUTPUT_CHANNELS*$OUTPUT_SAMPLES*$OUTPUT_SAMPLE_WIDTH]

    ad_cpu_interconnect 0x51000000 corundum_hierarchy s_axil_application

    ad_ip_instance util_cpack2 util_corundum_cpack [list \
      NUM_OF_CHANNELS $INPUT_CHANNELS \
      SAMPLES_PER_CHANNEL $INPUT_SAMPLES_PER_CHANNEL \
      SAMPLE_DATA_WIDTH $INPUT_SAMPLE_DATA_WIDTH \
    ]

    ad_connect util_corundum_cpack/clk rx_device_clk
    ad_connect util_corundum_cpack/fifo_wr_en rx_mxfe_tpl_core/adc_valid_0
    for {set i 0} {$i<$INPUT_CHANNELS} {incr i} {
      ad_connect util_corundum_cpack/enable_${i} rx_mxfe_tpl_core/adc_enable_${i}
      ad_connect util_corundum_cpack/fifo_wr_data_${i} rx_mxfe_tpl_core/adc_data_${i}
    }

    ad_connect corundum_hierarchy/input_clk axi_mxfe_rx_jesd/device_clk
    ad_connect corundum_hierarchy/input_rstn rx_device_clk_rstgen/peripheral_aresetn

    ad_connect corundum_hierarchy/output_clk axi_mxfe_tx_jesd/device_clk
    ad_connect corundum_hierarchy/output_rstn tx_device_clk_rstgen/peripheral_aresetn

    ad_connect corundum_hierarchy/input_axis_tvalid util_corundum_cpack/packed_fifo_wr_en
    ad_connect corundum_hierarchy/input_axis_tdata util_corundum_cpack/packed_fifo_wr_data
    ad_connect corundum_hierarchy/input_axis_tready util_corundum_cpack/packed_fifo_wr_overflow

    ad_ip_instance ilreduced_logic cpack_rst_logic_corundum
    ad_ip_parameter cpack_rst_logic_corundum config.c_operation {or}
    ad_ip_parameter cpack_rst_logic_corundum config.c_size {4}

    ad_ip_instance ilvector_logic rx_do_rstout_logic_corundum
    ad_ip_parameter rx_do_rstout_logic_corundum config.c_operation {not}
    ad_ip_parameter rx_do_rstout_logic_corundum config.c_size {1}

    ad_ip_instance ilconcat cpack_reset_sources_corundum
    ad_ip_parameter cpack_reset_sources_corundum config.num_ports {4}

    ad_connect corundum_hierarchy/input_axis_tready rx_do_rstout_logic_corundum/Op1

    ad_connect rx_device_clk_rstgen/peripheral_reset cpack_reset_sources_corundum/in0
    ad_connect rx_mxfe_tpl_core/adc_tpl_core/adc_rst cpack_reset_sources_corundum/in1
    ad_connect rx_do_rstout_logic_corundum/res cpack_reset_sources_corundum/in2
    ad_connect corundum_hierarchy/input_packer_reset cpack_reset_sources_corundum/in3

    ad_connect cpack_reset_sources_corundum/dout cpack_rst_logic_corundum/op1
    ad_connect cpack_rst_logic_corundum/res util_corundum_cpack/reset

    ad_ip_instance ilconcat input_enable_concat_corundum
    ad_ip_parameter input_enable_concat_corundum config.num_ports $INPUT_CHANNELS

    for {set i 0} {$i<$INPUT_CHANNELS} {incr i} {
      ad_connect input_enable_concat_corundum/In${i} rx_mxfe_tpl_core/adc_enable_${i}
    }

    ad_connect input_enable_concat_corundum/dout corundum_hierarchy/input_enable

    ad_ip_instance ilconcat output_enable_concat_corundum
    ad_ip_parameter output_enable_concat_corundum config.num_ports $OUTPUT_CHANNELS

    for {set i 0} {$i<$OUTPUT_CHANNELS} {incr i} {
      ad_connect output_enable_concat_corundum/In${i} tx_mxfe_tpl_core/dac_enable_${i}
    }

    ad_connect output_enable_concat_corundum/dout corundum_hierarchy/output_enable
  }

}
