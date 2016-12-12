# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_jesd_gt
adi_ip_files axi_jesd_gt [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel.v" \
  "$ad_hdl_dir/library/common/ad_gt_common.v" \
  "$ad_hdl_dir/library/common/ad_gt_es.v" \
  "$ad_hdl_dir/library/common/ad_gt_es_axi.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_common_1.v" \
  "$ad_hdl_dir/library/common/ad_jesd_align.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_gt_channel.v" \
  "$ad_hdl_dir/library/common/up_gt.v" \
  "axi_jesd_gt_constr.xdc" \
  "axi_jesd_gt.v" ]

adi_ip_properties axi_jesd_gt

adi_ip_constraints axi_jesd_gt [list \
  "axi_jesd_gt_constr.xdc" ]

ipx::associate_bus_interfaces -busif m_axi -clock s_axi_aclk [ipx::current_core]

adi_if_infer_bus ADI:user:if_gt_qpll slave gt_qpll_0 [list \
  "qpll_rst            qpll0_rst              "\
  "qpll_ref_clk        qpll0_ref_clk_in       "]

adi_if_infer_bus ADI:user:if_gt_qpll slave gt_qpll_1 [list \
  "qpll_rst            qpll1_rst              "\
  "qpll_ref_clk        qpll1_ref_clk_in       "]

for {set n 0} {$n < 8} {incr n} {

  adi_if_infer_bus ADI:user:if_gt_pll slave gt_pll_${n} [list \
    "cpll_rst_m          cpll_rst_m_${n}        "\
    "cpll_ref_clk_in     cpll_ref_clk_in_${n}   "]

  adi_if_infer_bus ADI:user:if_gt_rx slave gt_rx_${n} [list \
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

  adi_if_infer_bus xilinx.com:display_jesd204:jesd204_rx_bus master gt_rx_ip_${n} [list \
    "rxcharisk           rx_gt_charisk_${n}     "\
    "rxdisperr           rx_gt_disperr_${n}     "\
    "rxnotintable        rx_gt_notintable_${n}  "\
    "rxdata              rx_gt_data_${n}        "]

  adi_if_infer_bus ADI:user:if_gt_rx_ksig master gt_rx_ksig_${n} [list \
    "rx_gt_ilas_f        rx_gt_ilas_f_${n}      "\
    "rx_gt_ilas_q        rx_gt_ilas_q_${n}      "\
    "rx_gt_ilas_a        rx_gt_ilas_a_${n}      "\
    "rx_gt_ilas_r        rx_gt_ilas_r_${n}      "\
    "rx_gt_cgs_k         rx_gt_cgs_k_${n}       "]

  adi_if_infer_bus ADI:user:if_gt_tx slave gt_tx_${n} [list \
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

  adi_if_infer_bus xilinx.com:display_jesd204:jesd204_tx_bus slave gt_tx_ip_${n} [list \
    "txcharisk           tx_gt_charisk_${n}     "\
    "txdata              tx_gt_data_${n}        "]
}

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

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0} \
  [ipx::get_bus_interfaces gt_rx_*0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1} \
  [ipx::get_bus_interfaces gt_rx_*1 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2} \
  [ipx::get_bus_interfaces gt_rx_*2 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3} \
  [ipx::get_bus_interfaces gt_rx_*3 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4} \
  [ipx::get_bus_interfaces gt_rx_*4 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5} \
  [ipx::get_bus_interfaces gt_rx_*5 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6} \
  [ipx::get_bus_interfaces gt_rx_*6 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7} \
  [ipx::get_bus_interfaces gt_rx_*7 -of_objects [ipx::current_core]] 

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 0} \
  [ipx::get_bus_interfaces gt_tx_*0 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 1} \
  [ipx::get_bus_interfaces gt_tx_*1 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 2} \
  [ipx::get_bus_interfaces gt_tx_*2 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 3} \
  [ipx::get_bus_interfaces gt_tx_*3 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 4} \
  [ipx::get_bus_interfaces gt_tx_*4 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 5} \
  [ipx::get_bus_interfaces gt_tx_*5 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 6} \
  [ipx::get_bus_interfaces gt_tx_*6 -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 7} \
  [ipx::get_bus_interfaces gt_tx_*7 -of_objects [ipx::current_core]] 

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0} \
  [ipx::get_ports *rx_*0* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1} \
  [ipx::get_ports *rx_*1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2} \
  [ipx::get_ports *rx_*2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3} \
  [ipx::get_ports *rx_*3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4} \
  [ipx::get_ports *rx_*4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5} \
  [ipx::get_ports *rx_*5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6} \
  [ipx::get_ports *rx_*6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7} \
  [ipx::get_ports *rx_*7* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

