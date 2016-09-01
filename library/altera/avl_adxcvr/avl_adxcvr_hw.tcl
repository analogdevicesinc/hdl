
package require -exact qsys 14.0

set_module_property NAME avl_adxcvr
set_module_property DESCRIPTION "Avalon ADXCVR Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME avl_adxcvr
set_module_property COMPOSITION_CALLBACK p_avl_adxcvr

# parameters

add_parameter DEVICE_FAMILY STRING 
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false

add_parameter TX_OR_RX_N INTEGER 0
set_parameter_property TX_OR_RX_N DISPLAY_NAME TX_OR_RX_N
set_parameter_property TX_OR_RX_N TYPE INTEGER
set_parameter_property TX_OR_RX_N UNITS None
set_parameter_property TX_OR_RX_N HDL_PARAMETER false

add_parameter ID INTEGER 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE INTEGER
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER false

add_parameter PCS_CONFIG STRING "JESD_PCS_CFG2"
set_parameter_property PCS_CONFIG DISPLAY_NAME PCS_CONFIG
set_parameter_property PCS_CONFIG TYPE STRING
set_parameter_property PCS_CONFIG UNITS None
set_parameter_property PCS_CONFIG HDL_PARAMETER false

add_parameter LANE_RATE FLOAT 10000
set_parameter_property LANE_RATE DISPLAY_NAME LANE_RATE
set_parameter_property LANE_RATE TYPE FLOAT
set_parameter_property LANE_RATE UNITS None
set_parameter_property LANE_RATE DISPLAY_UNITS "Mbps"
set_parameter_property LANE_RATE HDL_PARAMETER false

add_parameter PLLCLK_FREQUENCY FLOAT 5000.0
set_parameter_property PLLCLK_FREQUENCY DISPLAY_NAME PLLCLK_FREQUENCY
set_parameter_property PLLCLK_FREQUENCY TYPE FLOAT
set_parameter_property PLLCLK_FREQUENCY UNITS Megahertz
set_parameter_property PLLCLK_FREQUENCY HDL_PARAMETER false

add_parameter REFCLK_FREQUENCY FLOAT 500.0
set_parameter_property REFCLK_FREQUENCY DISPLAY_NAME REFCLK_FREQUENCY
set_parameter_property REFCLK_FREQUENCY TYPE FLOAT
set_parameter_property REFCLK_FREQUENCY UNITS Megahertz
set_parameter_property REFCLK_FREQUENCY HDL_PARAMETER false

add_parameter CORECLK_FREQUENCY FLOAT 250.0
set_parameter_property CORECLK_FREQUENCY DISPLAY_NAME CORECLK_FREQUENCY
set_parameter_property CORECLK_FREQUENCY TYPE FLOAT
set_parameter_property CORECLK_FREQUENCY UNITS Megahertz
set_parameter_property CORECLK_FREQUENCY HDL_PARAMETER false

add_parameter NUM_OF_LANES INTEGER 4
set_parameter_property NUM_OF_LANES DISPLAY_NAME NUM_OF_LANES
set_parameter_property NUM_OF_LANES TYPE INTEGER
set_parameter_property NUM_OF_LANES UNITS None
set_parameter_property NUM_OF_LANES HDL_PARAMETER false

add_parameter NUM_OF_CONVS INTEGER 2
set_parameter_property NUM_OF_CONVS DISPLAY_NAME NUM_OF_CONVS
set_parameter_property NUM_OF_CONVS TYPE INTEGER
set_parameter_property NUM_OF_CONVS UNITS None
set_parameter_property NUM_OF_CONVS HDL_PARAMETER false

add_parameter FRM_BCNT INTEGER 1
set_parameter_property FRM_BCNT DISPLAY_NAME FRM_BCNT
set_parameter_property FRM_BCNT TYPE INTEGER
set_parameter_property FRM_BCNT UNITS None
set_parameter_property FRM_BCNT HDL_PARAMETER false

add_parameter FRM_SCNT INTEGER 1
set_parameter_property FRM_SCNT DISPLAY_NAME FRM_SCNT
set_parameter_property FRM_SCNT TYPE INTEGER
set_parameter_property FRM_SCNT UNITS None
set_parameter_property FRM_SCNT HDL_PARAMETER false

add_parameter MF_FCNT INTEGER 32
set_parameter_property MF_FCNT DISPLAY_NAME MF_FCNT
set_parameter_property MF_FCNT TYPE INTEGER
set_parameter_property MF_FCNT UNITS None
set_parameter_property MF_FCNT HDL_PARAMETER false

add_parameter HD INTEGER 1
set_parameter_property HD DISPLAY_NAME HD
set_parameter_property HD TYPE INTEGER
set_parameter_property HD UNITS None
set_parameter_property HD HDL_PARAMETER false

proc p_avl_adxcvr {} {

  set m_id [get_parameter_value "ID"]
  set m_lane_rate [get_parameter_value "LANE_RATE"]
  set m_pcs_config [get_parameter_value "PCS_CONFIG"]
  set m_tx_or_rx_n [get_parameter_value "TX_OR_RX_N"]
  set m_num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set m_device_family [get_parameter_value "DEVICE_FAMILY"]
  set m_pllclk_frequency [get_parameter_value "PLLCLK_FREQUENCY"]
  set m_refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set m_coreclk_frequency [get_parameter_value "CORECLK_FREQUENCY"]
  set m_num_of_convs [get_parameter_value "NUM_OF_CONVS"]
  set m_frm_bcnt [get_parameter_value "FRM_BCNT"]
  set m_frm_scnt [get_parameter_value "FRM_SCNT"]
  set m_mf_fcnt [get_parameter_value "MF_FCNT"]
  set m_hd [get_parameter_value "HD"]

  add_instance alt_sys_clk clock_source 16.0
  set_instance_parameter_value alt_sys_clk {clockFrequency} {100000000.0}
  add_interface sys_clk clock sink
  set_interface_property sys_clk EXPORT_OF alt_sys_clk.clk_in
  add_interface sys_resetn reset sink
  set_interface_property sys_resetn EXPORT_OF alt_sys_clk.clk_in_reset

  add_instance alt_ref_clk altera_clock_bridge 16.0
  set_instance_parameter_value alt_ref_clk {EXPLICIT_CLOCK_RATE} [expr $m_refclk_frequency*1000000]
  add_interface ref_clk clock sink
  set_interface_property ref_clk EXPORT_OF alt_ref_clk.in_clk

  add_instance alt_ref_pll altera_iopll 16.0
  set_instance_parameter_value alt_ref_pll {gui_en_reconf} {1}
  set_instance_parameter_value alt_ref_pll {gui_reference_clock_frequency} $m_refclk_frequency
  set_instance_parameter_value alt_ref_pll {gui_use_locked} {1}
  set_instance_parameter_value alt_ref_pll {gui_output_clock_frequency0} $m_coreclk_frequency
  add_connection alt_ref_clk.out_clk alt_ref_pll.refclk
  add_connection alt_sys_clk.clk_reset alt_ref_pll.reset
  add_interface ref_pll_locked conduit end
  set_interface_property ref_pll_locked EXPORT_OF alt_ref_pll.locked

  add_instance alt_ref_pll_reconfig altera_pll_reconfig 16.0
  add_connection alt_sys_clk.clk_reset alt_ref_pll_reconfig.mgmt_reset
  add_connection alt_sys_clk.clk alt_ref_pll_reconfig.mgmt_clk
  add_connection alt_ref_pll_reconfig.reconfig_to_pll alt_ref_pll.reconfig_to_pll
  add_connection alt_ref_pll.reconfig_from_pll alt_ref_pll_reconfig.reconfig_from_pll
  add_interface ref_pll_reconfig avalon slave
  set_interface_property ref_pll_reconfig EXPORT_OF alt_ref_pll_reconfig.mgmt_avalon_slave

  add_instance alt_core_clk altera_clock_bridge 16.0
  set_instance_parameter_value alt_core_clk {EXPLICIT_CLOCK_RATE} $m_coreclk_frequency
  add_connection alt_ref_pll.outclk0 alt_core_clk.in_clk
  add_interface core_clk clock source
  set_interface_property core_clk EXPORT_OF alt_core_clk.out_clk

  if {$m_tx_or_rx_n == 1} {

    add_instance alt_rst_cntrol altera_xcvr_reset_control 16.0
    set_instance_parameter_value alt_rst_cntrol {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value alt_rst_cntrol {SYS_CLK_IN_MHZ} {100}
    set_instance_parameter_value alt_rst_cntrol {TX_PLL_ENABLE} {1}
    set_instance_parameter_value alt_rst_cntrol {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value alt_rst_cntrol {TX_ENABLE} {1}
    set_instance_parameter_value alt_rst_cntrol {T_TX_ANALOGRESET} {70000}
    set_instance_parameter_value alt_rst_cntrol {T_TX_DIGITALRESET} {70000}
    set_instance_parameter_value alt_rst_cntrol {gui_pll_cal_busy} {1}
    set_instance_parameter_value alt_rst_cntrol {RX_ENABLE} {0}
    add_connection alt_sys_clk.clk alt_rst_cntrol.clock
    add_interface rst reset sink
    set_interface_property rst EXPORT_OF alt_rst_cntrol.reset
    add_interface ready conduit end
    set_interface_property ready EXPORT_OF alt_rst_cntrol.tx_ready

    add_instance alt_lane_pll altera_xcvr_atx_pll_a10 16.0
    set_instance_parameter_value alt_lane_pll {enable_pll_reconfig} {1}
    set_instance_parameter_value alt_lane_pll {rcfg_separate_avmm_busy} {1}
    set_instance_parameter_value alt_lane_pll {set_capability_reg_enable} {1}
    set_instance_parameter_value alt_lane_pll {set_user_identifier} $m_id
    set_instance_parameter_value alt_lane_pll {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value alt_lane_pll {set_output_clock_frequency} $m_pllclk_frequency
    set_instance_parameter_value alt_lane_pll {set_auto_reference_clock_frequency} $m_refclk_frequency
    add_connection alt_rst_cntrol.pll_powerdown alt_lane_pll.pll_powerdown
    add_connection alt_lane_pll.pll_locked alt_rst_cntrol.pll_locked
    add_connection alt_lane_pll.pll_cal_busy alt_rst_cntrol.pll_cal_busy
    add_connection alt_ref_clk.out_clk alt_lane_pll.pll_refclk0
    add_connection alt_sys_clk.clk alt_lane_pll.reconfig_clk0
    add_connection alt_sys_clk.clk_reset alt_lane_pll.reconfig_reset0
    add_interface lane_pll_reconfig avalon slave
    set_interface_property lane_pll_reconfig EXPORT_OF alt_lane_pll.reconfig_avmm0

    add_instance alt_xcvr altera_jesd204 16.0
    set_instance_parameter_value alt_xcvr {wrapper_opt} {base_phy}
    set_instance_parameter_value alt_xcvr {DATA_PATH} {TX}
    set_instance_parameter_value alt_xcvr {lane_rate} $m_lane_rate
    set_instance_parameter_value alt_xcvr {PCS_CONFIG} $m_pcs_config
    set_instance_parameter_value alt_xcvr {bonded_mode} {non_bonded}
    set_instance_parameter_value alt_xcvr {pll_reconfig_enable} {1}
    set_instance_parameter_value alt_xcvr {set_capability_reg_enable} {1}
    set_instance_parameter_value alt_xcvr {set_user_identifier} $m_id
    set_instance_parameter_value alt_xcvr {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value alt_xcvr {L} $m_num_of_lanes
    set_instance_parameter_value alt_xcvr {M} $m_num_of_convs
    set_instance_parameter_value alt_xcvr {GUI_EN_CFG_F} {1}
    set_instance_parameter_value alt_xcvr {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value alt_xcvr {N} {16}
    set_instance_parameter_value alt_xcvr {N_PRIME} {16}
    set_instance_parameter_value alt_xcvr {S} $m_frm_scnt
    set_instance_parameter_value alt_xcvr {K} $m_mf_fcnt
    set_instance_parameter_value alt_xcvr {SCR} {1}
    set_instance_parameter_value alt_xcvr {HD} $m_hd
    add_connection alt_rst_cntrol.tx_digitalreset alt_xcvr.tx_digitalreset
    add_connection alt_rst_cntrol.tx_analogreset alt_xcvr.tx_analogreset
    add_connection alt_xcvr.tx_cal_busy alt_rst_cntrol.tx_cal_busy
    add_connection alt_xcvr.dev_sync_n alt_xcvr.mdev_sync_n
    add_connection alt_sys_clk.clk alt_xcvr.reconfig_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.reconfig_reset
    add_interface phy_reconfig avalon slave
    set_interface_property phy_reconfig EXPORT_OF alt_xcvr.reconfig_avmm
    add_connection alt_sys_clk.clk alt_xcvr.jesd204_tx_avs_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.jesd204_tx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF alt_xcvr.jesd204_tx_avs
    add_connection alt_ref_pll.outclk0 alt_xcvr.txlink_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.txlink_rst_n
    add_interface ip_data avalon_streaming sink
    set_interface_property ip_data EXPORT_OF alt_xcvr.jesd204_tx_link
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF alt_xcvr.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF alt_xcvr.sync_n
    add_interface tx_data conduit end
    set_interface_property tx_data EXPORT_OF alt_xcvr.tx_serial_data
    for {set n 0} {$n < $m_num_of_lanes} {incr n} {
      add_connection alt_lane_pll.tx_serial_clk alt_xcvr.tx_serial_clk0_ch${n}
    }
  }

  if {$m_tx_or_rx_n == 0} {

    add_instance alt_rst_cntrol altera_xcvr_reset_control 16.0
    set_instance_parameter_value alt_rst_cntrol {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value alt_rst_cntrol {SYS_CLK_IN_MHZ} {100}
    set_instance_parameter_value alt_rst_cntrol {TX_PLL_ENABLE} {0}
    set_instance_parameter_value alt_rst_cntrol {TX_ENABLE} {0}
    set_instance_parameter_value alt_rst_cntrol {RX_ENABLE} {1}
    set_instance_parameter_value alt_rst_cntrol {T_RX_ANALOGRESET} {70000}
    set_instance_parameter_value alt_rst_cntrol {T_RX_DIGITALRESET} {4000}
    add_connection alt_sys_clk.clk alt_rst_cntrol.clock
    add_interface rst reset sink
    set_interface_property rst EXPORT_OF alt_rst_cntrol.reset
    add_interface ready conduit end
    set_interface_property ready EXPORT_OF alt_rst_cntrol.rx_ready

    add_instance alt_xcvr altera_jesd204 16.0
    set_instance_parameter_value alt_xcvr {wrapper_opt} {base_phy}
    set_instance_parameter_value alt_xcvr {DATA_PATH} {RX}
    set_instance_parameter_value alt_xcvr {lane_rate} $m_lane_rate
    set_instance_parameter_value alt_xcvr {PCS_CONFIG} $m_pcs_config
    set_instance_parameter_value alt_xcvr {REFCLK_FREQ} $m_refclk_frequency
    set_instance_parameter_value alt_xcvr {pll_reconfig_enable} {1}
    set_instance_parameter_value alt_xcvr {set_capability_reg_enable} {1}
    set_instance_parameter_value alt_xcvr {set_user_identifier} $m_id
    set_instance_parameter_value alt_xcvr {set_csr_soft_logic_enable} {1}
    set_instance_parameter_value alt_xcvr {L} $m_num_of_lanes
    set_instance_parameter_value alt_xcvr {M} $m_num_of_convs
    set_instance_parameter_value alt_xcvr {GUI_EN_CFG_F} {1}
    set_instance_parameter_value alt_xcvr {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value alt_xcvr {N} {16}
    set_instance_parameter_value alt_xcvr {N_PRIME} {16}
    set_instance_parameter_value alt_xcvr {S} $m_frm_scnt
    set_instance_parameter_value alt_xcvr {K} $m_mf_fcnt
    set_instance_parameter_value alt_xcvr {SCR} {1}
    set_instance_parameter_value alt_xcvr {HD} $m_hd
    add_connection alt_rst_cntrol.rx_digitalreset alt_xcvr.rx_digitalreset
    add_connection alt_rst_cntrol.rx_analogreset alt_xcvr.rx_analogreset
    add_connection alt_xcvr.rx_cal_busy alt_rst_cntrol.rx_cal_busy
    add_connection alt_xcvr.rx_islockedtodata alt_rst_cntrol.rx_is_lockedtodata
    add_connection alt_xcvr.dev_lane_aligned alt_xcvr.alldev_lane_aligned
    add_connection alt_sys_clk.clk alt_xcvr.reconfig_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.reconfig_reset
    add_interface phy_reconfig avalon slave
    set_interface_property phy_reconfig EXPORT_OF alt_xcvr.reconfig_avmm
    add_connection alt_sys_clk.clk alt_xcvr.jesd204_rx_avs_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.jesd204_rx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF alt_xcvr.jesd204_rx_avs
    add_connection alt_ref_clk.out_clk alt_xcvr.pll_ref_clk
    add_connection alt_ref_pll.outclk0 alt_xcvr.rxlink_clk
    add_connection alt_sys_clk.clk_reset alt_xcvr.rxlink_rst_n
    add_interface ip_data avalon_streaming source
    set_interface_property ip_data EXPORT_OF alt_xcvr.jesd204_rx_link
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF alt_xcvr.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF alt_xcvr.dev_sync_n
    add_interface ip_sof conduit end
    set_interface_property ip_sof EXPORT_OF alt_xcvr.sof
    add_interface rx_data conduit end
    set_interface_property rx_data EXPORT_OF alt_xcvr.rx_serial_data
  }
}

