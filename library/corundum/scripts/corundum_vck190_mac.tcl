###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
# tx_polarity / rx_polarity are 4-bit masks, bit n inverting GT channel n.
# tx_ch_map / rx_ch_map (4x25G only) give, 2 bits per MRMAC port with port 0 in
# [1:0], the GT channel that carries the port's TX / RX lane.

proc corundum_vck190_build_mac {{rs_fec_enable 1} {loopback_enable 0} \
                                {gt_type GTY} {tx_polarity 0} {rx_polarity 0} \
                                {mode 1x100G} {tx_ch_map 0xE4} {rx_ch_map 0xE4} \
                                {tx_drive {}}} {
  global ad_hdl_dir

  switch -- $mode {
    1x100G { set ports 1 }
    1x40G  { set ports 1 }
    4x25G  { set ports 4 }
    default { error "corundum_vck190_build_mac: unknown mode '$mode', expected 1x100G, 1x40G or 4x25G" }
  }
  set is_4x25g [expr {$mode eq "4x25G"}]
  set is_1x40g [expr {$mode eq "1x40G"}]

  for {set c 0} {$c < 4} {incr c} {
    if {$is_4x25g} {
      set gt_tx($c) INTF${c}_TX0
      set gt_rx($c) INTF${c}_RX0
    } else {
      set gt_tx($c) INTF0_TX${c}
      set gt_rx($c) INTF0_RX${c}
    }
    set sfx($c) [expr {$c ? "_$c" : ""}]
  }

  if {$is_4x25g} {
    foreach dir {tx rx} map [list $tx_ch_map $rx_ch_map] {
      set used {}
      for {set n 0} {$n < 4} {incr n} {
        set ch [expr {($map >> (2 * $n)) & 3}]
        set ${dir}_ch($n) $ch
        lappend used $ch
      }
      if {[lsort -integer $used] ne {0 1 2 3}} {
        error "corundum_vck190_build_mac: ${dir}_ch_map $map is not a permutation of GT channels 0..3"
      }
    }
  }

  if {[llength $tx_drive] ni {0 3}} {
    error "corundum_vck190_build_mac: tx_drive '$tx_drive' is not {diffctrl precursor postcursor}"
  }
  foreach code $tx_drive {
    if {![string is integer -strict $code] || $code < 0 || $code > 31} {
      error "corundum_vck190_build_mac: tx_drive code $code is not 0..31"
    }
  }

  foreach rtl [list \
    "$ad_hdl_dir/library/corundum/versal/mrmac_versal_glue.v" \
    "$ad_hdl_dir/library/corundum/versal/mrmac_axis_loopback.v" \
    "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_fifo.v" \
    "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_register.v" \
    "$ad_hdl_dir/library/corundum/versal/mrmac_init.v" \
    "$ad_hdl_dir/library/corundum/versal/mrmac_gt_regs.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "$ad_hdl_dir/library/util_cdc/sync_event.v" \
    "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  ] {
    if {[lsearch -exact [get_files -quiet -of_objects [get_filesets sources_1]] $rtl] < 0} {
      add_files -norecurse -fileset sources_1 $rtl
    }
  }
  update_compile_order -fileset sources_1

  create_bd_cell -type ip -vlnv xilinx.com:ip:mrmac mrmac_0
  if {$is_4x25g} {
    set_property -dict [list \
      CONFIG.MRMAC_PRESET_C0 {4x25GE Wide} \
      CONFIG.MRMAC_MODE_C0 {MAC+PCS} \
      CONFIG.GT_TYPE_C0 $gt_type \
      CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
      CONFIG.MRMAC_IS_GT_WIZ_OLD {0} \
      CONFIG.INCLUDE_AUTO_NEG_LT_LOGIC_C0 {None} \
      CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0} \
    ] [get_bd_cells mrmac_0]
    set _cfg {}
    for {set n 0} {$n < 4} {incr n} {
      lappend _cfg \
        CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT${n}_C0 {Independent 64b  Non-Segmented} \
        CONFIG.MAC_PORT${n}_RATE_C0 {25GE} \
        CONFIG.MAC_PORT${n}_TX_FLOW_C0 {1} \
        CONFIG.MAC_PORT${n}_RX_FLOW_C0 {1} \
        CONFIG.MAC_PORT${n}_ENABLE_TIME_STAMPING_C0 {1} \
        CONFIG.PORT${n}_1588v2_Operation_MODE_C0 {2-step} \
        CONFIG.PORT${n}_1588v2_Clocking_C0 {Ordinary/Boundary Clock}
    }
    set_property -dict $_cfg [get_bd_cells mrmac_0]
  } elseif {$is_1x40g} {
    set_property -dict [list \
      CONFIG.MRMAC_PRESET_C0 {1x40GE XLAUI-4 Wide} \
      CONFIG.MRMAC_MODE_C0 {MAC+PCS} \
      CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT0_C0 {Independent 256b Non-Segmented} \
      CONFIG.MAC_PORT0_RATE_C0 {40GE} \
      CONFIG.GT_TYPE_C0 $gt_type \
      CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
      CONFIG.MRMAC_IS_GT_WIZ_OLD {0} \
      CONFIG.INCLUDE_AUTO_NEG_LT_LOGIC_C0 {None} \
      CONFIG.MAC_PORT0_TX_FLOW_C0 {1} \
      CONFIG.MAC_PORT0_RX_FLOW_C0 {1} \
      CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {1} \
      CONFIG.PORT0_1588v2_Operation_MODE_C0 {2-step} \
      CONFIG.PORT0_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
      CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0} \
    ] [get_bd_cells mrmac_0]
  } else {
  set_property -dict [list \
    CONFIG.MRMAC_PRESET_C0 {1x100GE CAUI-4 Wide} \
    CONFIG.MRMAC_MODE_C0 {MAC+PCS} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT0_C0 {Independent 384b Non-Segmented} \
    CONFIG.MAC_PORT0_RATE_C0 {100GE} \
    CONFIG.GT_TYPE_C0 $gt_type \
    CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
    CONFIG.MRMAC_IS_GT_WIZ_OLD {0} \
    CONFIG.INCLUDE_AUTO_NEG_LT_LOGIC_C0 {None} \
    CONFIG.MAC_PORT0_TX_FLOW_C0 {1} \
    CONFIG.MAC_PORT0_RX_FLOW_C0 {1} \
    CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {1} \
    CONFIG.PORT0_1588v2_Operation_MODE_C0 {2-step} \
    CONFIG.PORT0_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0} \
  ] [get_bd_cells mrmac_0]
  }

  if {$is_1x40g} {
    set gt_settings [list LR0_SETTINGS [list preset ${gt_type}-Ethernet_10G_RAW GT_TYPE $gt_type TX_DATA_ENCODING RAW RX_DATA_DECODING RAW TX_LINE_RATE 10.3125 RX_LINE_RATE 10.3125 TX_USER_DATA_WIDTH 32 RX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH 32 RX_INT_DATA_WIDTH 32 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 RX_REFCLK_FREQUENCY 156.25 TXPROGDIV_FREQ_VAL 644.531 RXPROGDIV_FREQ_VAL 644.531]]
  } else {
    set gt_settings [list LR0_SETTINGS [list preset ${gt_type}-Ethernet_25G_RAW GT_TYPE $gt_type TX_DATA_ENCODING RAW RX_DATA_DECODING RAW TX_LINE_RATE 25.78125 RX_LINE_RATE 25.78125 TX_USER_DATA_WIDTH 80 RX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 RX_REFCLK_FREQUENCY 156.25 TXPROGDIV_FREQ_VAL 644.531 RXPROGDIV_FREQ_VAL 644.531]]
  }

  create_bd_cell -type ip -vlnv xilinx.com:ip:gtwiz_versal gtwiz_versal
  if {$is_4x25g} {
    set _cfg [list \
      CONFIG.NO_OF_INTERFACE {4} \
      CONFIG.QUAD0_NO_PROT {4} \
      CONFIG.ENABLE_REG_INTERFACE {true} \
      CONFIG.REG_CONF_INTF {AXI_LITE} \
      CONFIG.GT_TYPE $gt_type \
    ]
    for {set c 0} {$c < 4} {incr c} {
      lappend _cfg \
        CONFIG.INTF${c}_NO_OF_LANES {1} \
        CONFIG.QUAD0_PROT${c}_LANES {1} \
        CONFIG.QUAD0_TX${c}_OUTCLK_EN {true} \
        CONFIG.QUAD0_RX${c}_OUTCLK_EN {true} \
        CONFIG.QUAD0_PROT${c}_TXMSTCLK TX${c} \
        CONFIG.QUAD0_PROT${c}_RXMSTCLK RX${c} \
        CONFIG.INTF${c}_GT_SETTINGS $gt_settings
      if {$c > 0} {
        lappend _cfg \
          CONFIG.QUAD0_PROT0_TX${c}_EN {false} \
          CONFIG.QUAD0_PROT0_RX${c}_EN {false} \
          CONFIG.QUAD0_PROT${c}_TX${c}_EN {true} \
          CONFIG.QUAD0_PROT${c}_RX${c}_EN {true}
      }
    }
    set_property -dict $_cfg [get_bd_cells gtwiz_versal]
  } else {
  set_property -dict [list \
    CONFIG.NO_OF_INTERFACE {1} \
    CONFIG.INTF0_NO_OF_LANES {4} \
    CONFIG.QUAD0_NO_PROT {1} \
    CONFIG.QUAD0_PROT0_LANES {4} \
    CONFIG.QUAD0_PROT0_TX1_EN {true} \
    CONFIG.QUAD0_PROT0_TX2_EN {true} \
    CONFIG.QUAD0_PROT0_TX3_EN {true} \
    CONFIG.QUAD0_PROT0_RX1_EN {true} \
    CONFIG.QUAD0_PROT0_RX2_EN {true} \
    CONFIG.QUAD0_PROT0_RX3_EN {true} \
    CONFIG.QUAD0_TX0_OUTCLK_EN {true} \
    CONFIG.QUAD0_RX0_OUTCLK_EN {true} \
    CONFIG.QUAD0_RX1_OUTCLK_EN {true} \
    CONFIG.QUAD0_RX2_OUTCLK_EN {true} \
    CONFIG.QUAD0_RX3_OUTCLK_EN {true} \
    CONFIG.QUAD0_PROT0_TXMSTCLK {TX0} \
    CONFIG.QUAD0_PROT0_RXMSTCLK {RX0} \
    CONFIG.ENABLE_REG_INTERFACE {true} \
    CONFIG.REG_CONF_INTF {AXI_LITE} \
    CONFIG.GT_TYPE $gt_type \
    CONFIG.INTF0_GT_SETTINGS $gt_settings \
  ] [get_bd_cells gtwiz_versal]
  }

  create_bd_cell -type module -reference mrmac_versal_glue mrmac_versal_glue
  set_property -dict [list \
    CONFIG.GT_TYPE $gt_type \
    CONFIG.MRMAC_SERDES_W {80} \
    CONFIG.GT_CH_W {128} \
    CONFIG.RX_PER_LANE_CLK {1} \
    CONFIG.LOOPBACK_ENABLE $loopback_enable \
  ] [get_bd_cells mrmac_versal_glue]
  # The maps are hex.
  if {$is_1x40g} {
    set_property -dict [list \
      CONFIG.MODE $mode \
      CONFIG.PORTS $ports \
      CONFIG.SHIM_W {256} \
      CONFIG.KU_W {44} \
    ] [get_bd_cells mrmac_versal_glue]
  } elseif {$is_4x25g} {
    set_property -dict [list \
      CONFIG.MODE $mode \
      CONFIG.PORTS $ports \
      CONFIG.SHIM_W {64} \
      CONFIG.KU_W {11} \
      CONFIG.TX_CH_MAP [format 0x%02X $tx_ch_map] \
      CONFIG.RX_CH_MAP [format 0x%02X $rx_ch_map] \
    ] [get_bd_cells mrmac_versal_glue]
  }

  create_bd_cell -type module -reference mrmac_init mrmac_init
  set_property CONFIG.RS_FEC_ENABLE [expr {$is_1x40g ? 0 : $rs_fec_enable}] [get_bd_cells mrmac_init]
  if {$is_4x25g || $is_1x40g} {
    set_property -dict [list \
      CONFIG.MODE $mode \
      CONFIG.PORTS $ports \
    ] [get_bd_cells mrmac_init]
  }

  create_bd_cell -type module -reference mrmac_gt_regs mrmac_gt_regs

  ad_connect mrmac_versal_glue/gt_ref_clk_p gt_ref_clk_p
  ad_connect mrmac_versal_glue/gt_ref_clk_n gt_ref_clk_n
  set _pins [list [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK0]]
  if {$is_4x25g} {
    lappend _pins [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK1]
  }
  connect_bd_net [get_bd_pins mrmac_versal_glue/gt_refclk_out] {*}$_pins

  ad_connect mrmac_versal_glue/ptp_refclk_bufg ptp_refclk_bufg

  connect_bd_net [get_bd_pins gt_freerun_clk] \
                 [get_bd_pins gtwiz_versal/gtwiz_freerun_clk] \
                 [get_bd_pins mrmac_0/s_axi_aclk] \
                 [get_bd_pins mrmac_init/clk] \
                 [get_bd_pins mrmac_gt_regs/clk] \
                 [get_bd_pins ethernet_core/gt_drp_clk]

  ad_connect mrmac_versal_glue/axis_clk_in mrmac_axis_clk
  ad_connect mrmac_versal_glue/ts_clk_in   mrmac_ts_clk

  ad_connect mrmac_init/resetn mac_resetn
  ad_connect gtwiz_versal/QUAD0_s_axi_lite_resetn mac_resetn
  ad_connect mrmac_gt_regs/resetn mac_resetn
  ad_connect mrmac_versal_glue/pl_resetn mrmac_init/mac_resetn
  ad_connect mrmac_0/s_axi_aresetn mrmac_init/mac_resetn

  ad_ip_instance ilvector_logic gt_drp_rst_inv [list \
    C_OPERATION {not} \
    C_SIZE 1 \
  ]
  ad_connect gt_drp_rst_inv/Op1 mac_resetn
  ad_connect ethernet_core/gt_drp_rst gt_drp_rst_inv/Res

  # 4x25G: interface c is GT channel c.

  connect_bd_net [get_bd_pins gtwiz_versal/QUAD0_TX0_outclk] \
                 [get_bd_pins mrmac_versal_glue/gt_tx_outclk]
  if {$is_4x25g} {
    for {set c 1} {$c < 4} {incr c} {
      connect_bd_net [get_bd_pins gtwiz_versal/QUAD0_TX${c}_outclk] \
                     [get_bd_pins mrmac_versal_glue/gt_tx_outclk_${c}]
    }
  }
  connect_bd_net [get_bd_pins gtwiz_versal/QUAD0_RX0_outclk] \
                 [get_bd_pins mrmac_versal_glue/gt_rx_outclk]
  for {set ch 1} {$ch < 4} {incr ch} {
    connect_bd_net [get_bd_pins gtwiz_versal/QUAD0_RX${ch}_outclk] \
                   [get_bd_pins mrmac_versal_glue/gt_rx_outclk_${ch}]
  }

  for {set ch 0} {$ch < 4} {incr ch} {
    connect_bd_net [get_bd_pins mrmac_versal_glue/gt_tx_usrclk_${ch}] \
                   [get_bd_pins gtwiz_versal/QUAD0_TX${ch}_usrclk]
    connect_bd_net [get_bd_pins mrmac_versal_glue/gt_rx_usrclk_${ch}] \
                   [get_bd_pins gtwiz_versal/QUAD0_RX${ch}_usrclk] \
                   [get_bd_pins mrmac_gt_regs/rx_prbs_clk_${ch}]
  }
  connect_bd_net [get_bd_pins mrmac_versal_glue/gt_tx_usrclk_0] \
                 [get_bd_pins mrmac_gt_regs/tx_prbs_clk]

  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_TX_clr_out]       [get_bd_pins mrmac_versal_glue/gt_tx_clr]
  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_TX_clrb_leaf_out] [get_bd_pins mrmac_versal_glue/gt_tx_clrb_leaf]
  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_RX_clr_out]       [get_bd_pins mrmac_versal_glue/gt_rx_clr]
  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_RX_clrb_leaf_out] [get_bd_pins mrmac_versal_glue/gt_rx_clrb_leaf]

  if {$is_4x25g} {
    for {set c 1} {$c < 4} {incr c} {
      foreach d {TX RX} {
        set _d [string tolower $d]
        connect_bd_net [get_bd_pins gtwiz_versal/INTF${c}_${d}_clr_out] \
                       [get_bd_pins mrmac_versal_glue/gt_${_d}_clr_${c}]
        connect_bd_net [get_bd_pins gtwiz_versal/INTF${c}_${d}_clrb_leaf_out] \
                       [get_bd_pins mrmac_versal_glue/gt_${_d}_clrb_leaf_${c}]
      }
    }

    # mrmac_init bit n is MRMAC port n.
    foreach d {tx rx} {
      ad_ip_instance ilconcat gt_${d}_reset_done_concat [list NUM_PORTS 4]
      connect_bd_net [get_bd_pins gt_${d}_reset_done_concat/dout] \
                     [get_bd_pins mrmac_init/gt_${d}_reset_done]
    }
    for {set c 0} {$c < 4} {incr c} {
      foreach d {tx rx} {
        set _pins [list [get_bd_pins mrmac_versal_glue/gt_rst_${d}_done$sfx($c)]]
        for {set n 0} {$n < 4} {incr n} {
          if {[set ${d}_ch($n)] == $c} {
            lappend _pins [get_bd_pins gt_${d}_reset_done_concat/In${n}]
          }
        }
        connect_bd_net [get_bd_pins gtwiz_versal/INTF${c}_rst_${d}_done_out] {*}$_pins
      }
    }
  } else {
  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_rst_tx_done_out] \
                 [get_bd_pins mrmac_versal_glue/gt_rst_tx_done] \
                 [get_bd_pins mrmac_init/gt_tx_reset_done]
  connect_bd_net [get_bd_pins gtwiz_versal/INTF0_rst_rx_done_out] \
                 [get_bd_pins mrmac_versal_glue/gt_rst_rx_done] \
                 [get_bd_pins mrmac_init/gt_rx_reset_done]
  }

  ad_connect gtwiz_versal/gtpowergood mrmac_init/gtpowergood
  if {$is_4x25g} {
    connect_bd_net [get_bd_pins mrmac_init/gt_rst_all] \
                   [get_bd_pins gtwiz_versal/INTF0_rst_all_in] \
                   [get_bd_pins gtwiz_versal/INTF1_rst_all_in] \
                   [get_bd_pins gtwiz_versal/INTF2_rst_all_in] \
                   [get_bd_pins gtwiz_versal/INTF3_rst_all_in]
  } else {
  ad_connect mrmac_init/gt_rst_all gtwiz_versal/INTF0_rst_all_in
  }

  # The GTY MRMAC pins tx/rx_serdes_data${n} are 80b, gtwiz ch_{tx,rx}data is
  # 128b: the glue zero-extends TX and takes the low 80b of RX. MRMAC lane n is
  # glue lane n; gt_ch_*data_n is GT channel n.
  for {set n 0} {$n < 4} {incr n} {
    connect_bd_net [get_bd_pins mrmac_0/tx_serdes_data${n}] \
                   [get_bd_pins mrmac_versal_glue/mrmac_txdata_in_${n}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/gt_ch_txdata_${n}] \
                   [get_bd_pins gtwiz_versal/$gt_tx($n)_ch_txdata]
    connect_bd_net [get_bd_pins gtwiz_versal/$gt_rx($n)_ch_rxdata] \
                   [get_bd_pins mrmac_versal_glue/gt_ch_rxdata_${n}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rxdata_out_${n}] \
                   [get_bd_pins mrmac_0/rx_serdes_data${n}]
  }

  # These MRMAC pins are [3:0], one bit per GT lane, independent of the MAC
  # port count.
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_core_clk]      [get_bd_pins mrmac_0/tx_core_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rx_core_clk]      [get_bd_pins mrmac_0/rx_core_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rx_serdes_clk]    [get_bd_pins mrmac_0/rx_serdes_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_alt_serdes_clk] [get_bd_pins mrmac_0/tx_alt_serdes_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rx_alt_serdes_clk] [get_bd_pins mrmac_0/rx_alt_serdes_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_axi_clk] \
                 [get_bd_pins mrmac_0/tx_axi_clk] \
                 [get_bd_pins mrmac_0/rx_axi_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ts_clk] \
                 [get_bd_pins mrmac_0/tx_ts_clk] \
                 [get_bd_pins mrmac_0/rx_ts_clk]

  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_core_reset]   [get_bd_pins mrmac_0/tx_core_reset]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rx_core_reset]   [get_bd_pins mrmac_0/rx_core_reset]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_serdes_reset] [get_bd_pins mrmac_0/tx_serdes_reset]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_rx_serdes_reset] [get_bd_pins mrmac_0/rx_serdes_reset]
  connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_flexif_reset]    [get_bd_pins mrmac_0/rx_flexif_reset]

  # At 4x25G these ethernet_core pins are one bit per port.
  if {$is_4x25g} {
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_axi_clk] \
                   [get_bd_pins ethernet_core/mrmac_tx_axi_clk] \
                   [get_bd_pins ethernet_core/mrmac_rx_axi_clk]
    ad_ip_instance ilconcat shim_axi_reset_concat [list NUM_PORTS $ports]
    for {set n 0} {$n < $ports} {incr n} {
      connect_bd_net [get_bd_pins mrmac_versal_glue/shim_axi_reset] \
                     [get_bd_pins shim_axi_reset_concat/In${n}]
    }
    connect_bd_net [get_bd_pins shim_axi_reset_concat/dout] \
                   [get_bd_pins ethernet_core/mrmac_tx_reset_in] \
                   [get_bd_pins ethernet_core/mrmac_rx_reset_in]
  } else {
  connect_bd_net [get_bd_pins mrmac_axis_clk] \
                 [get_bd_pins ethernet_core/mrmac_tx_axi_clk] \
                 [get_bd_pins ethernet_core/mrmac_rx_axi_clk]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_axi_reset] \
                 [get_bd_pins ethernet_core/mrmac_tx_reset_in] \
                 [get_bd_pins ethernet_core/mrmac_rx_reset_in]
  }

  # 1x100G: one non-segmented port as six 64b words with a single handshake;
  # 1x40G: four words. 4x25G: port p is word 2p with handshake p.
  if {$is_4x25g} {
    set _words {0 2 4 6}
  } elseif {$is_1x40g} {
    set _words {0 1 2 3}
  } else {
    set _words {0 1 2 3 4 5}
  }
  foreach s $_words {
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_axis_tdata${s}]      [get_bd_pins mrmac_0/tx_axis_tdata${s}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_axis_tkeep_user${s}] [get_bd_pins mrmac_0/tx_axis_tkeep_user${s}]
    connect_bd_net [get_bd_pins mrmac_0/rx_axis_tdata${s}]      [get_bd_pins mrmac_versal_glue/mrmac_rx_axis_tdata${s}]
    connect_bd_net [get_bd_pins mrmac_0/rx_axis_tkeep_user${s}] [get_bd_pins mrmac_versal_glue/mrmac_rx_axis_tkeep_user${s}]
  }
  for {set p 0} {$p < $ports} {incr p} {
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_axis_tvalid_${p}] [get_bd_pins mrmac_0/tx_axis_tvalid_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_axis_tlast_${p}]  [get_bd_pins mrmac_0/tx_axis_tlast_${p}]
    connect_bd_net [get_bd_pins mrmac_0/tx_axis_tready_${p}]                 [get_bd_pins mrmac_versal_glue/mrmac_tx_axis_tready_${p}]

    connect_bd_net [get_bd_pins mrmac_0/rx_axis_tvalid_${p}] [get_bd_pins mrmac_versal_glue/mrmac_rx_axis_tvalid_${p}]
    connect_bd_net [get_bd_pins mrmac_0/rx_axis_tlast_${p}]  [get_bd_pins mrmac_versal_glue/mrmac_rx_axis_tlast_${p}]
    set _pins [list [get_bd_pins mrmac_versal_glue/mrmac_stat_rx_status_${p}]]
    if {!$is_4x25g} {
      lappend _pins [get_bd_pins mrmac_init/stat_rx_status]
    }
    connect_bd_net [get_bd_pins mrmac_0/stat_rx_status_${p}] {*}$_pins
  }

  for {set p 0} {$p < $ports} {incr p} {
    connect_bd_net [get_bd_pins mrmac_0/rx_ptp_tstamp_out_${p}]        [get_bd_pins mrmac_versal_glue/mrmac_rx_ptp_tstamp_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_ptp_1588op_${p}]     [get_bd_pins mrmac_0/tx_ptp_1588op_in_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_tx_ptp_tag_field_${p}]  [get_bd_pins mrmac_0/tx_ptp_tag_field_in_${p}]
    connect_bd_net [get_bd_pins mrmac_0/tx_ptp_tstamp_out_${p}]        [get_bd_pins mrmac_versal_glue/mrmac_tx_ptp_tstamp_${p}]
    connect_bd_net [get_bd_pins mrmac_0/tx_ptp_tstamp_tag_out_${p}]    [get_bd_pins mrmac_versal_glue/mrmac_tx_ptp_tstamp_tag_${p}]
    connect_bd_net [get_bd_pins mrmac_0/tx_ptp_tstamp_valid_out_${p}]  [get_bd_pins mrmac_versal_glue/mrmac_tx_ptp_tstamp_valid_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_tx_ptp_systemtimer_${p}]  [get_bd_pins mrmac_0/ctl_tx_ptp_systemtimer_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_tx_ptp_st_sync_${p}]      [get_bd_pins mrmac_0/ctl_tx_ptp_st_sync_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_tx_ptp_st_overwrite_${p}] [get_bd_pins mrmac_0/ctl_tx_ptp_st_overwrite_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_rx_ptp_systemtimer_${p}]  [get_bd_pins mrmac_0/ctl_rx_ptp_systemtimer_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_rx_ptp_st_sync_${p}]      [get_bd_pins mrmac_0/ctl_rx_ptp_st_sync_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_rx_ptp_st_overwrite_${p}] [get_bd_pins mrmac_0/ctl_rx_ptp_st_overwrite_${p}]
  }

  # Each is a 9-bit {lfc, pfc} vector (bit 8 = LFC, bits [7:0] = PFC classes).
  for {set p 0} {$p < $ports} {incr p} {
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_tx_pause_enable_${p}] [get_bd_pins mrmac_0/ctl_tx_pause_enable_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_tx_pause_req_${p}]    [get_bd_pins mrmac_0/ctl_tx_pause_req_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_rx_pause_enable_${p}] [get_bd_pins mrmac_0/ctl_rx_pause_enable_${p}]
    connect_bd_net [get_bd_pins mrmac_versal_glue/mrmac_ctl_rx_pause_ack_${p}]    [get_bd_pins mrmac_0/ctl_rx_pause_ack_${p}]
    connect_bd_net [get_bd_pins mrmac_0/stat_rx_pause_req_${p}]                   [get_bd_pins mrmac_versal_glue/mrmac_stat_rx_pause_req_${p}]
  }

  # Per port one 384b (1x100G) or 64b (4x25G) beat + 66b / 11b tkeep_user per
  # handshake.
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_axis_tdata]      [get_bd_pins mrmac_versal_glue/shim_tx_axis_tdata]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_axis_tkeep_user] [get_bd_pins mrmac_versal_glue/shim_tx_axis_tkeep_user]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_axis_tvalid]     [get_bd_pins mrmac_versal_glue/shim_tx_axis_tvalid]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_axis_tlast]      [get_bd_pins mrmac_versal_glue/shim_tx_axis_tlast]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_tx_axis_tready]  [get_bd_pins ethernet_core/mrmac_tx_axis_tready]

  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_rx_axis_tdata]      [get_bd_pins ethernet_core/mrmac_rx_axis_tdata]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_rx_axis_tkeep_user] [get_bd_pins ethernet_core/mrmac_rx_axis_tkeep_user]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_rx_axis_tvalid]     [get_bd_pins ethernet_core/mrmac_rx_axis_tvalid]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_rx_axis_tlast]      [get_bd_pins ethernet_core/mrmac_rx_axis_tlast]
  set _pins [list [get_bd_pins ethernet_core/mrmac_stat_rx_status]]
  if {$is_4x25g} {
    lappend _pins [get_bd_pins mrmac_init/stat_rx_status]
  }
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_stat_rx_status] {*}$_pins

  # Corundum per-port enables; mrmac_init writes them to CONFIGURATION_{TX,RX}_REG1_n[0].
  ad_connect ethernet_core/mrmac_ctl_tx_enable mrmac_init/ctl_tx_enable
  ad_connect ethernet_core/mrmac_ctl_rx_enable mrmac_init/ctl_rx_enable
  ad_connect mrmac_init/link_ready mrmac_link_ready
  ad_connect mrmac_versal_glue/loopback_en       mrmac_loopback_en
  ad_connect mrmac_versal_glue/loopback_mac_swap mrmac_loopback_mac_swap

  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_rx_ptp_tstamp]        [get_bd_pins ethernet_core/mrmac_rx_ptp_tstamp]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_ptp_1588op]           [get_bd_pins mrmac_versal_glue/shim_tx_ptp_1588op]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_ptp_tag_field]        [get_bd_pins mrmac_versal_glue/shim_tx_ptp_tag_field]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_tx_ptp_tstamp]        [get_bd_pins ethernet_core/mrmac_tx_ptp_tstamp]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_tx_ptp_tstamp_tag]    [get_bd_pins ethernet_core/mrmac_tx_ptp_tstamp_tag]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_tx_ptp_tstamp_valid]  [get_bd_pins ethernet_core/mrmac_tx_ptp_tstamp_valid]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_ptp_systemtimer]      [get_bd_pins mrmac_versal_glue/shim_tx_ptp_systemtimer]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_ptp_st_sync]          [get_bd_pins mrmac_versal_glue/shim_tx_ptp_st_sync]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_tx_ptp_st_overwrite]     [get_bd_pins mrmac_versal_glue/shim_tx_ptp_st_overwrite]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_rx_ptp_systemtimer]      [get_bd_pins mrmac_versal_glue/shim_rx_ptp_systemtimer]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_rx_ptp_st_sync]          [get_bd_pins mrmac_versal_glue/shim_rx_ptp_st_sync]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_rx_ptp_st_overwrite]     [get_bd_pins mrmac_versal_glue/shim_rx_ptp_st_overwrite]

  connect_bd_net [get_bd_pins ethernet_core/mrmac_ctl_tx_pause_enable] [get_bd_pins mrmac_versal_glue/shim_ctl_tx_pause_enable]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_ctl_tx_pause_req]    [get_bd_pins mrmac_versal_glue/shim_ctl_tx_pause_req]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_ctl_rx_pause_enable] [get_bd_pins mrmac_versal_glue/shim_ctl_rx_pause_enable]
  connect_bd_net [get_bd_pins ethernet_core/mrmac_ctl_rx_pause_ack]    [get_bd_pins mrmac_versal_glue/shim_ctl_rx_pause_ack]
  connect_bd_net [get_bd_pins mrmac_versal_glue/shim_stat_rx_pause_req] [get_bd_pins ethernet_core/mrmac_stat_rx_pause_req]

  set _glue_swept {}
  foreach _cell {mrmac_0 mrmac_versal_glue} {
    set _excl [dict create]
    foreach _ip [get_bd_intf_pins -quiet -of [get_bd_cells $_cell]] {
      if {$_ip ne [get_bd_intf_pins -quiet mrmac_0/s_axi] && \
          ![llength [get_bd_intf_nets -quiet -of $_ip]]} continue
      foreach _mp [get_bd_pins -quiet -of $_ip] {
        dict set _excl $_mp 1
      }
    }
    foreach _p [lsort [get_bd_pins -quiet -of [get_bd_cells $_cell]]] {
      if {[get_property DIR $_p] ne "I"} continue
      if {[dict exists $_excl $_p]} continue
      if {[llength [get_bd_nets -quiet -of $_p]]} continue
      set _l [get_property -quiet LEFT $_p]
      set _r [get_property -quiet RIGHT $_p]
      if {$_l eq "" || $_r eq ""} {
        set _w 1
      } else {
        set _w [expr {abs($_l - $_r) + 1}]
      }
      set _gnd [get_bd_cells -quiet mrmac_gnd_$_w]
      if {$_gnd eq ""} {
        ad_ip_instance ilconstant mrmac_gnd_$_w [list \
          CONST_WIDTH $_w \
          CONST_VAL 0 \
        ]
        set _gnd [get_bd_cells mrmac_gnd_$_w]
      }
      connect_bd_net [get_bd_pins $_gnd/dout] $_p
      if {$_cell eq "mrmac_versal_glue"} {
        lappend _glue_swept [get_property NAME $_p]
      }
    }
  }
  puts "corundum_vck190_build_mac: $mode, mrmac_versal_glue inputs tied to 0:\
        [llength $_glue_swept] ([join $_glue_swept {, }])"

  # ch_{tx,rx}rate = 0 selects LR0.
  ad_ip_instance xlconstant gt_line_rate [list \
    CONST_WIDTH 8 \
    CONST_VAL 0 \
  ]
  for {set ch 0} {$ch < 4} {incr ch} {
    connect_bd_net [get_bd_pins gt_line_rate/dout] [get_bd_pins gtwiz_versal/$gt_tx($ch)_ch_txrate]
    connect_bd_net [get_bd_pins gt_line_rate/dout] [get_bd_pins gtwiz_versal/$gt_rx($ch)_ch_rxrate]
  }
  set _intfs [expr {$is_4x25g ? 4 : 1}]
  for {set c 0} {$c < $_intfs} {incr c} {
    ad_connect gtwiz_versal/INTF${c}_rst_tx_datapath_in          GND
    if {!$is_4x25g} {
      ad_connect gtwiz_versal/INTF${c}_rst_rx_datapath_in        GND
    }
    ad_connect gtwiz_versal/INTF${c}_rst_tx_pll_and_datapath_in  GND
    ad_connect gtwiz_versal/INTF${c}_rst_rx_pll_and_datapath_in  GND
  }
  if {$is_4x25g} {
    for {set n 0} {$n < $ports} {incr n} {
      ad_ip_instance ilslice gt_rx_datapath_reset_$n [list \
        DIN_WIDTH $ports \
        DIN_FROM $n \
        DIN_TO $n \
        DOUT_WIDTH 1 \
      ]
      ad_connect mrmac_init/gt_rx_datapath_reset gt_rx_datapath_reset_$n/Din
      ad_connect gt_rx_datapath_reset_$n/Dout \
                 gtwiz_versal/INTF$rx_ch($n)_rst_rx_datapath_in
    }
  }
  ad_connect gtwiz_versal/QUAD0_gpi GND

  for {set n 0} {$n < 4} {incr n} {
    if {($tx_polarity >> $n) & 1} {
      ad_connect gtwiz_versal/$gt_tx($n)_ch_txpolarity VCC
    }
    if {($rx_polarity >> $n) & 1} {
      ad_connect gtwiz_versal/$gt_rx($n)_ch_rxpolarity VCC
    }
  }

  if {[llength $tx_drive]} {
    foreach pin {txdiffctrl txprecursor txpostcursor} code $tx_drive {
      ad_ip_instance xlconstant gt_$pin [list \
        CONST_WIDTH 5 \
        CONST_VAL $code \
      ]
      for {set n 0} {$n < 4} {incr n} {
        connect_bd_net [get_bd_pins gt_$pin/dout] \
                       [get_bd_pins gtwiz_versal/$gt_tx($n)_ch_$pin]
      }
    }
  }

  for {set n 0} {$n < 4} {incr n} {
    connect_bd_net [get_bd_pins mrmac_gt_regs/tx_prbssel_${n}] \
                   [get_bd_pins gtwiz_versal/$gt_tx($n)_ch_txprbssel]
    connect_bd_net [get_bd_pins mrmac_gt_regs/rx_prbssel_${n}] \
                   [get_bd_pins gtwiz_versal/$gt_rx($n)_ch_rxprbssel]
    connect_bd_net [get_bd_pins mrmac_gt_regs/rx_prbscntreset_${n}] \
                   [get_bd_pins gtwiz_versal/$gt_rx($n)_ch_rxprbscntreset]
    connect_bd_net [get_bd_pins gtwiz_versal/$gt_rx($n)_ch_rxprbslocked] \
                   [get_bd_pins mrmac_gt_regs/rx_prbslocked_${n}]
    connect_bd_net [get_bd_pins gtwiz_versal/$gt_rx($n)_ch_rxprbserr] \
                   [get_bd_pins mrmac_gt_regs/rx_prbserr_${n}]
  }
  ad_connect mrmac_gt_regs/prbs_active mrmac_init/prbs_hold

  foreach sig {addr di en we do rdy} {
    connect_bd_net [get_bd_pins ethernet_core/gt_drp_${sig}] \
                   [get_bd_pins mrmac_gt_regs/drp_${sig}]
  }

  ad_connect gtwiz_versal/Quad0_GT_Serial qsfp_serial
  ad_connect s_axi_mac                   mrmac_init/s_axi
  ad_connect mrmac_init/m_axi            mrmac_0/s_axi
  ad_connect s_axi_gt                    mrmac_gt_regs/s_axi
  ad_connect mrmac_gt_regs/m_axi         gtwiz_versal/Quad0_AXI_LITE

  assign_bd_address -offset 0x00000000 \
    -target_address_space [get_bd_addr_spaces -of_objects [get_bd_intf_pins mrmac_init/m_axi]] \
    [get_bd_addr_segs -of_objects [get_bd_cells mrmac_0]]
  assign_bd_address -offset 0x00000000 \
    -target_address_space [get_bd_addr_spaces -of_objects [get_bd_intf_pins mrmac_gt_regs/m_axi]] \
    [get_bd_addr_segs -of_objects [get_bd_intf_pins gtwiz_versal/Quad0_AXI_LITE]]
}
