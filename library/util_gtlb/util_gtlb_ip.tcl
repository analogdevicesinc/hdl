# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_gtlb
adi_ip_files util_gtlb [list \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "util_gtlb_constr.xdc" \
  "util_gtlb.v" ]

adi_ip_properties_lite util_gtlb
adi_ip_constraints util_gtlb [list \
  "util_gtlb_constr.xdc" ]

ipx::remove_all_bus_interface [ipx::current_core]

adi_if_infer_bus ADI:user:if_gt_qpll master gt_qpll_0 [list \
  "qpll_rst            qpll0_rst              "\
  "qpll_ref_clk        qpll0_ref_clk_in       "]

for {set n 0} {$n < 1} {incr n} {

  adi_if_infer_bus ADI:user:if_gt_pll master gt_pll_${n} [list \
    "cpll_rst_m          cpll_rst_m_${n}        "\
    "cpll_ref_clk_in     cpll_ref_clk_in_${n}   "]

  adi_if_infer_bus xilinx.com:display_jesd204:jesd204_rx_bus slave gt_rx_ip_${n} [list \
    "rxcharisk           rx_gt_charisk_${n}     "\
    "rxdisperr           rx_gt_disperr_${n}     "\
    "rxnotintable        rx_gt_notintable_${n}  "\
    "rxdata              rx_gt_data_${n}        "]

  adi_if_infer_bus ADI:user:if_gt_rx master gt_rx_${n} [list \
    "rx_p                rx_${n}_p              "\
    "rx_n                rx_${n}_n              "\
    "rx_rst              rx_rst_${n}            "\
    "rx_rst_m            rx_rst_m_${n}          "\
    "rx_pll_rst          rx_pll_rst_${n}        "\
    "rx_gt_rst           rx_gt_rst_${n}         "\
    "rx_gt_rst_m         rx_gt_rst_m_${n}       "\
    "rx_pll_locked       rx_pll_locked_${n}     "\
    "rx_pll_locked_m     rx_pll_locked_m_${n}   "\
    "rx_user_ready       rx_user_ready_${n}     "\
    "rx_user_ready_m     rx_user_ready_m_${n}   "\
    "rx_rst_done         rx_rst_done_${n}       "\
    "rx_rst_done_m       rx_rst_done_m_${n}     "\
    "rx_out_clk          rx_out_clk_${n}        "\
    "rx_clk              rx_clk_${n}            "\
    "rx_sysref           rx_sysref_${n}         "\
    "rx_sync             rx_sync_${n}           "\
    "rx_sof              rx_sof_${n}            "\
    "rx_data             rx_data_${n}           "\
    "rx_ip_rst           rx_ip_rst_${n}         "\
    "rx_ip_sof           rx_ip_sof_${n}         "\
    "rx_ip_data          rx_ip_data_${n}        "\
    "rx_ip_sysref        rx_ip_sysref_${n}      "\
    "rx_ip_sync          rx_ip_sync_${n}        "\
    "rx_ip_rst_done      rx_ip_rst_done_${n}    "]

  adi_if_infer_bus xilinx.com:display_jesd204:jesd204_tx_bus master gt_tx_ip_${n} [list \
    "txcharisk           tx_gt_charisk_${n}     "\
    "txdata              tx_gt_data_${n}        "]

  adi_if_infer_bus ADI:user:if_gt_tx master gt_tx_${n} [list \
    "tx_p                tx_${n}_p              "\
    "tx_n                tx_${n}_n              "\
    "tx_rst              tx_rst_${n}            "\
    "tx_rst_m            tx_rst_m_${n}          "\
    "tx_pll_rst          tx_pll_rst_${n}        "\
    "tx_gt_rst           tx_gt_rst_${n}         "\
    "tx_gt_rst_m         tx_gt_rst_m_${n}       "\
    "tx_pll_locked       tx_pll_locked_${n}     "\
    "tx_pll_locked_m     tx_pll_locked_m_${n}   "\
    "tx_user_ready       tx_user_ready_${n}     "\
    "tx_user_ready_m     tx_user_ready_m_${n}   "\
    "tx_rst_done         tx_rst_done_${n}       "\
    "tx_rst_done_m       tx_rst_done_m_${n}     "\
    "tx_out_clk          tx_out_clk_${n}        "\
    "tx_clk              tx_clk_${n}            "\
    "tx_sysref           tx_sysref_${n}         "\
    "tx_sync             tx_sync_${n}           "\
    "tx_data             tx_data_${n}           "\
    "tx_ip_rst           tx_ip_rst_${n}         "\
    "tx_ip_data          tx_ip_data_${n}        "\
    "tx_ip_sysref        tx_ip_sysref_${n}      "\
    "tx_ip_sync          tx_ip_sync_${n}        "\
    "tx_ip_rst_done      tx_ip_rst_done_${n}    "]
}

ipx::save_core [ipx::current_core]


