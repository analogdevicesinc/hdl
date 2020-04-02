# This file contains all IP cores related to JESD framework suited to link 16 MxFEs
# to the FPGA through 64 Rx and 64 Tx lanes.

# The block design consists of four identical sub-blocks controlling a quad MxFE
# each.

# Interface:
#  $sys_cpu_clk - global variable pointing to system clock AXI Lite control interface (100MHz)
#  $sys_cpu_resetn - global variable pointing to active low synchronous reset in system clock domain

# Control interface:
#  Each quad block has an AXI interconnect IP that handles the control register read/writes for each IP.
#  User must connect an AXI master to the interconnect slave port.
#
# Data interface:
#  Rx - user must connect to ADC transport layer (rx_mxfe_tpl_core) to get the samples,
#       32 channels, 1 sample per channel
#  Tx - user must connect to DAC transport layer (tx_mxfe_tpl_core) to drive the samples
#       32 channels, 1 sample per channel


source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

create_bd_port -dir I device_clk

# Create physical and link layer group for one quad MxFE
proc create_phy_ll_group {H_NAME INDEX {LANE_MAP {}} } {

  upvar sys_cpu_resetn sys_cpu_resetn
  upvar sys_cpu_clk sys_cpu_clk

  set RX_NUM_OF_LINKS 4
  set TX_NUM_OF_LINKS 4
  set MAX_RX_LANES 16
  set MAX_TX_LANES 16
  set RX_NUM_OF_LANES 16
  set TX_NUM_OF_LANES 16

  set DATAPATH_WIDTH 4
  set RX_NUM_OF_CONVERTERS 32
  set RX_SAMPLES_PER_FRAME 1 ; # S
  set RX_SAMPLE_WIDTH 16
  set TX_NUM_OF_CONVERTERS 32
  set TX_SAMPLES_PER_FRAME 1 ; # S
  set TX_SAMPLE_WIDTH 16

  set ENCODER_SEL 1; # 204B

  set MAX_LANES [expr max($MAX_TX_LANES,$MAX_RX_LANES)]

  create_bd_cell -type hier  $H_NAME

  # Physical layer
  ad_ip_instance util_adxcvr $H_NAME/util_mxfe_xcvr [list \
    CPLL_FBDIV_4_5 5 \
    TX_NUM_OF_LANES $MAX_TX_LANES \
    RX_NUM_OF_LANES $MAX_RX_LANES \
    RX_OUT_DIV 1 \
  ]

  # Physical layer rx control interface
  ad_ip_instance axi_adxcvr $H_NAME/axi_mxfe_rx_xcvr [list \
    ID 0 \
    NUM_OF_LANES $RX_NUM_OF_LANES\
    TX_OR_RX_N 0 \
    QPLL_ENABLE 0 \
    LPM_OR_DFE_N 1 \
    SYS_CLK_SEL 0x0 \
  ]

  # Physical layer tx control interface
  ad_ip_instance axi_adxcvr $H_NAME/axi_mxfe_tx_xcvr [list \
    ID 0 \
    NUM_OF_LANES $TX_NUM_OF_LANES \
    TX_OR_RX_N 1 \
    QPLL_ENABLE 1 \
    SYS_CLK_SEL 0x3 \
  ]

  # Link layer
  adi_axi_jesd204_rx_create $H_NAME/axi_mxfe_rx_jesd $RX_NUM_OF_LANES $RX_NUM_OF_LINKS $ENCODER_SEL
  ad_ip_parameter $H_NAME/axi_mxfe_rx_jesd/rx CONFIG.SYSREF_IOB false

  adi_axi_jesd204_tx_create $H_NAME/axi_mxfe_tx_jesd $TX_NUM_OF_LANES $TX_NUM_OF_LINKS $ENCODER_SEL
  ad_ip_parameter $H_NAME/axi_mxfe_tx_jesd/tx CONFIG.SYSREF_IOB false


  # Transport layer
  adi_tpl_jesd204_rx_create $H_NAME/rx_mxfe_tpl_core $RX_NUM_OF_LANES \
                                                     $RX_NUM_OF_CONVERTERS \
                                                     $RX_SAMPLES_PER_FRAME \
                                                     $RX_SAMPLE_WIDTH \
                                                     $DATAPATH_WIDTH

  adi_tpl_jesd204_tx_create $H_NAME/tx_mxfe_tpl_core $TX_NUM_OF_LANES \
                                                     $TX_NUM_OF_CONVERTERS \
                                                     $TX_SAMPLES_PER_FRAME \
                                                     $TX_SAMPLE_WIDTH \
                                                     $DATAPATH_WIDTH

  ad_ip_parameter $H_NAME/tx_mxfe_tpl_core CONFIG.DATAPATH_DISABLE 1

  ad_connect  device_clk $H_NAME/rx_mxfe_tpl_core/link_clk
  ad_connect  device_clk $H_NAME/tx_mxfe_tpl_core/link_clk

  # connect physical to link layer
  ad_xcvrcon  $H_NAME/util_mxfe_xcvr $H_NAME/axi_mxfe_rx_xcvr $H_NAME/axi_mxfe_rx_jesd $LANE_MAP device_clk

  ad_xcvrcon  $H_NAME/util_mxfe_xcvr $H_NAME/axi_mxfe_tx_xcvr $H_NAME/axi_mxfe_tx_jesd $LANE_MAP device_clk


  # connect link layer to transport layer
  ad_connect  $H_NAME/axi_mxfe_rx_jesd/rx_sof $H_NAME/rx_mxfe_tpl_core/link_sof
  ad_connect  $H_NAME/axi_mxfe_rx_jesd/rx_data_tdata $H_NAME/rx_mxfe_tpl_core/link_data
  ad_connect  $H_NAME/axi_mxfe_rx_jesd/rx_data_tvalid $H_NAME/rx_mxfe_tpl_core/link_valid

  ad_connect  $H_NAME/tx_mxfe_tpl_core/link $H_NAME/axi_mxfe_tx_jesd/tx_data

  # connect ref clocks to the PHY
  for {set i 0} {$i < [expr $MAX_LANES/4]} {incr i} {
    set ref_clk_name ref_clk_${INDEX}_q$i
    create_bd_port -dir I $ref_clk_name

    ad_xcvrpll  $ref_clk_name $H_NAME/util_mxfe_xcvr/qpll_ref_clk_[expr $i*4+0]
    ad_xcvrpll  $ref_clk_name $H_NAME/util_mxfe_xcvr/cpll_ref_clk_[expr $i*4+0]
    ad_xcvrpll  $ref_clk_name $H_NAME/util_mxfe_xcvr/cpll_ref_clk_[expr $i*4+1]
    ad_xcvrpll  $ref_clk_name $H_NAME/util_mxfe_xcvr/cpll_ref_clk_[expr $i*4+2]
    ad_xcvrpll  $ref_clk_name $H_NAME/util_mxfe_xcvr/cpll_ref_clk_[expr $i*4+3]
  }

  ad_xcvrpll  $H_NAME/axi_mxfe_rx_xcvr/up_pll_rst $H_NAME/util_mxfe_xcvr/up_cpll_rst_*
  ad_xcvrpll  $H_NAME/axi_mxfe_tx_xcvr/up_pll_rst $H_NAME/util_mxfe_xcvr/up_qpll_rst_*

  ad_connect  $sys_cpu_clk $H_NAME/util_mxfe_xcvr/up_clk
  ad_connect  $sys_cpu_resetn $H_NAME/util_mxfe_xcvr/up_rstn

  # list of peripherals to connect to the control interface
  set peripherals {axi_mxfe_rx_jesd axi_mxfe_tx_jesd axi_mxfe_rx_xcvr axi_mxfe_tx_xcvr rx_mxfe_tpl_core tx_mxfe_tpl_core}

  # create local interconnect for register control
  ad_ip_instance smartconnect $H_NAME/interconnect [list \
    NUM_MI [llength $peripherals] \
    NUM_SI 1 \
  ]
  ad_connect  $sys_cpu_clk $H_NAME/interconnect/aclk
  ad_connect  $sys_cpu_resetn $H_NAME/interconnect/aresetn

  set i 0
  foreach p $peripherals {
    ad_connect  $H_NAME/interconnect/M0${i}_AXI $H_NAME/$p/s_axi
    ad_connect  $sys_cpu_clk $H_NAME/$p/s_axi_aclk
    ad_connect  $sys_cpu_resetn $H_NAME/$p/s_axi_aresetn
    incr i
  }

  # connect data interface of TPL to hierarchy level
  for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
    create_bd_pin -dir O  "${H_NAME}/adc_data_${i}"
    ad_connect $H_NAME/rx_mxfe_tpl_core/adc_data_$i ${H_NAME}/adc_data_${i}
  }
  for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
    create_bd_pin -dir I "${H_NAME}/dac_data_${i}"
    ad_connect $H_NAME/tx_mxfe_tpl_core/dac_data_$i ${H_NAME}/dac_data_${i}
  }


}

create_phy_ll_group qmxfe0 0
create_phy_ll_group qmxfe1 1
create_phy_ll_group qmxfe2 2
create_phy_ll_group qmxfe3 3

