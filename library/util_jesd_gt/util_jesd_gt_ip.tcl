# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_jesd_gt
adi_ip_files util_jesd_gt [list \
  "util_jesd_gt.v" ]

adi_ip_properties_lite util_jesd_gt

ipx::remove_all_bus_interface [ipx::current_core]

adi_if_infer_bus ADI:user:if_gt_qpll master gt_qpll_0 [list \
  "qpll_rst            qpll0_rst              "\
  "qpll_ref_clk        qpll0_ref_clk_in       "]

adi_if_infer_bus ADI:user:if_gt_qpll master gt_qpll_1 [list \
  "qpll_rst            qpll1_rst              "\
  "qpll_ref_clk        qpll1_ref_clk_in       "]

for {set n 0} {$n < 8} {incr n} {

  adi_if_infer_bus ADI:user:if_gt_pll master gt_pll_${n} [list \
    "cpll_rst_m          cpll_rst_m_${n}        "\
    "cpll_ref_clk_in     cpll_ref_clk_in_${n}   "]

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

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports rx_p -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_n -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_out_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sof -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_data -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_rst_done -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sof -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_data -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports tx_p -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_n -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_out_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_data -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_rst_done -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_data -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.QPLL0_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_qpll_0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.QPLL1_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_qpll_1 -of_objects [ipx::current_core]] 

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 0} \
  [ipx::get_bus_interfaces gt_pll_0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 1} \
  [ipx::get_bus_interfaces gt_pll_1 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 2} \
  [ipx::get_bus_interfaces gt_pll_2 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 3} \
  [ipx::get_bus_interfaces gt_pll_3 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 4} \
  [ipx::get_bus_interfaces gt_pll_4 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 5} \
  [ipx::get_bus_interfaces gt_pll_5 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 6} \
  [ipx::get_bus_interfaces gt_pll_6 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 7} \
  [ipx::get_bus_interfaces gt_pll_7 -of_objects [ipx::current_core]] 

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_1 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_2 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_3 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_4 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_5 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_6 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_rx_7 -of_objects [ipx::current_core]] 

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 0 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 1 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_1 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 2 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_2 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 3 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_3 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 4 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_4 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 5 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_5 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 6 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_6 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 7 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_bus_interfaces gt_tx_7 -of_objects [ipx::current_core]] 

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

