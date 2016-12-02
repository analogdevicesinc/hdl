
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

add_parameter SYSCLK_FREQUENCY FLOAT 100.0
set_parameter_property SYSCLK_FREQUENCY DISPLAY_NAME SYSCLK_FREQUENCY
set_parameter_property SYSCLK_FREQUENCY TYPE FLOAT
set_parameter_property SYSCLK_FREQUENCY UNITS Megahertz
set_parameter_property SYSCLK_FREQUENCY HDL_PARAMETER false

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
  set m_sysclk_frequency [get_parameter_value "SYSCLK_FREQUENCY"]
  set m_pllclk_frequency [get_parameter_value "PLLCLK_FREQUENCY"]
  set m_refclk_frequency [get_parameter_value "REFCLK_FREQUENCY"]
  set m_coreclk_frequency [get_parameter_value "CORECLK_FREQUENCY"]
  set m_num_of_convs [get_parameter_value "NUM_OF_CONVS"]
  set m_frm_bcnt [get_parameter_value "FRM_BCNT"]
  set m_frm_scnt [get_parameter_value "FRM_SCNT"]
  set m_mf_fcnt [get_parameter_value "MF_FCNT"]
  set m_hd [get_parameter_value "HD"]

  add_instance alt_sys_clk clock_source 16.0
  set_instance_parameter_value alt_sys_clk {clockFrequency} [expr $m_sysclk_frequency*1000000]
  add_interface sys_clk clock sink
  set_interface_property sys_clk EXPORT_OF alt_sys_clk.clk_in
  add_interface sys_resetn reset sink
  set_interface_property sys_resetn EXPORT_OF alt_sys_clk.clk_in_reset

  add_instance alt_ref_clk altera_clock_bridge 16.0
  set_instance_parameter_value alt_ref_clk {EXPLICIT_CLOCK_RATE} [expr $m_refclk_frequency*1000000]
  add_interface ref_clk clock sink
  set_interface_property ref_clk EXPORT_OF alt_ref_clk.in_clk

  if {$m_device_family eq "Arria V"} {

    add_instance alt_core_pll altera_pll 16.0
    set_instance_parameter_value alt_core_pll {gui_en_reconf} {1}
    set_instance_parameter_value alt_core_pll {gui_reference_clock_frequency} $m_refclk_frequency
    set_instance_parameter_value alt_core_pll {gui_use_locked} {1}
    set_instance_parameter_value alt_core_pll {gui_output_clock_frequency0} $m_coreclk_frequency
    add_connection alt_ref_clk.out_clk alt_core_pll.refclk
    add_connection alt_sys_clk.clk_reset alt_core_pll.reset
    add_interface core_pll_locked conduit end
    set_interface_property core_pll_locked EXPORT_OF alt_core_pll.locked

  } else {

    add_instance alt_core_pll altera_iopll 16.0
    set_instance_parameter_value alt_core_pll {gui_en_reconf} {1}
    set_instance_parameter_value alt_core_pll {gui_reference_clock_frequency} $m_refclk_frequency
    set_instance_parameter_value alt_core_pll {gui_use_locked} {1}
    set_instance_parameter_value alt_core_pll {gui_output_clock_frequency0} $m_coreclk_frequency
    add_connection alt_ref_clk.out_clk alt_core_pll.refclk
    add_connection alt_sys_clk.clk_reset alt_core_pll.reset
    add_interface core_pll_locked conduit end
    set_interface_property core_pll_locked EXPORT_OF alt_core_pll.locked
  }

  add_instance alt_core_pll_reconfig altera_pll_reconfig 16.0
  add_connection alt_sys_clk.clk_reset alt_core_pll_reconfig.mgmt_reset
  add_connection alt_sys_clk.clk alt_core_pll_reconfig.mgmt_clk
  add_connection alt_core_pll_reconfig.reconfig_to_pll alt_core_pll.reconfig_to_pll
  add_connection alt_core_pll.reconfig_from_pll alt_core_pll_reconfig.reconfig_from_pll
  add_interface core_pll_reconfig avalon slave
  set_interface_property core_pll_reconfig EXPORT_OF alt_core_pll_reconfig.mgmt_avalon_slave

  add_instance alt_core_clk altera_clock_bridge 16.0
  set_instance_parameter_value alt_core_clk {EXPLICIT_CLOCK_RATE} $m_coreclk_frequency
  add_connection alt_core_pll.outclk0 alt_core_clk.in_clk
  add_interface core_clk clock source
  set_interface_property core_clk EXPORT_OF alt_core_clk.out_clk

  if {$m_tx_or_rx_n == 1} {

    add_instance alt_rst_cntrol altera_xcvr_reset_control 16.0
    set_instance_parameter_value alt_rst_cntrol {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value alt_rst_cntrol {SYS_CLK_IN_MHZ} $m_sysclk_frequency
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

    add_instance alt_ip altera_jesd204 16.0
    set_instance_parameter_value alt_ip {wrapper_opt} {base}
    set_instance_parameter_value alt_ip {DATA_PATH} {TX}
    set_instance_parameter_value alt_ip {lane_rate} $m_lane_rate
    set_instance_parameter_value alt_ip {L} $m_num_of_lanes
    set_instance_parameter_value alt_ip {M} $m_num_of_convs
    set_instance_parameter_value alt_ip {GUI_EN_CFG_F} {1}
    set_instance_parameter_value alt_ip {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value alt_ip {N} {16}
    set_instance_parameter_value alt_ip {N_PRIME} {16}
    set_instance_parameter_value alt_ip {S} $m_frm_scnt
    set_instance_parameter_value alt_ip {K} $m_mf_fcnt
    set_instance_parameter_value alt_ip {SCR} {1}
    set_instance_parameter_value alt_ip {HD} $m_hd
    add_connection alt_core_pll.outclk0 alt_ip.txlink_clk
    add_connection alt_sys_clk.clk_reset alt_ip.txlink_rst_n
    add_interface ip_data avalon_streaming sink
    set_interface_property ip_data EXPORT_OF alt_ip.jesd204_tx_link
    add_connection alt_sys_clk.clk alt_ip.jesd204_tx_avs_clk
    add_connection alt_sys_clk.clk_reset alt_ip.jesd204_tx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF alt_ip.jesd204_tx_avs
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF alt_ip.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF alt_ip.sync_n
    add_connection alt_ip.dev_sync_n alt_ip.mdev_sync_n

    add_instance alt_xphy avl_adxphy 1.0
    set_instance_parameter_value alt_xphy {TX_OR_RX_N} {1}
    set_instance_parameter_value alt_xphy {NUM_OF_LANES} $m_num_of_lanes
    add_connection alt_rst_cntrol.tx_analogreset alt_xphy.tx_core_analogreset
    add_connection alt_rst_cntrol.tx_digitalreset alt_xphy.tx_core_digitalreset
    add_connection alt_xphy.tx_core_cal_busy alt_rst_cntrol.tx_cal_busy
    add_connection alt_xphy.tx_ip_cal_busy alt_ip.tx_cal_busy
    add_connection alt_xphy.tx_ip_pcfifo_full alt_ip.phy_csr_tx_pcfifo_full
    add_connection alt_xphy.tx_ip_pcfifo_empty alt_ip.phy_csr_tx_pcfifo_empty
    add_connection alt_ip.jesd204_tx_pcs_data alt_xphy.tx_ip_pcs_data
    add_connection alt_ip.jesd204_tx_pcs_kchar_data alt_xphy.tx_ip_pcs_kchar_data
    add_connection alt_ip.phy_tx_elecidle alt_xphy.tx_ip_elecidle
    add_connection alt_ip.csr_lane_polarity alt_xphy.tx_ip_csr_lane_polarity
    add_connection alt_ip.csr_lane_powerdown alt_xphy.tx_ip_csr_lane_powerdown
    add_connection alt_ip.csr_bit_reversal alt_xphy.tx_ip_csr_bit_reversal
    add_connection alt_ip.csr_byte_reversal alt_xphy.tx_ip_csr_byte_reversal

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      add_interface tx_ip_s_${n} conduit end
      set_interface_property tx_ip_s_${n} EXPORT_OF alt_xphy.tx_ip_s_${n}
      add_interface tx_ip_d_${n} conduit end
      set_interface_property tx_ip_d_${n} EXPORT_OF alt_xphy.tx_ip_d_${n}
      add_interface tx_phy_s_${n} conduit end
      set_interface_property tx_phy_s_${n} EXPORT_OF alt_xphy.tx_phy_s_${n}
      add_interface tx_phy_d_${n} conduit end
      set_interface_property tx_phy_d_${n} EXPORT_OF alt_xphy.tx_phy_d_${n}

      add_instance alt_phy_${n} altera_jesd204 16.0
      set_instance_parameter_value alt_phy_${n} {wrapper_opt} {phy}
      set_instance_parameter_value alt_phy_${n} {DATA_PATH} {TX}
      set_instance_parameter_value alt_phy_${n} {lane_rate} $m_lane_rate
      set_instance_parameter_value alt_phy_${n} {PCS_CONFIG} $m_pcs_config
      set_instance_parameter_value alt_phy_${n} {bonded_mode} {non_bonded}
      set_instance_parameter_value alt_phy_${n} {pll_reconfig_enable} {1}
      set_instance_parameter_value alt_phy_${n} {set_capability_reg_enable} {1}
      set_instance_parameter_value alt_phy_${n} {set_user_identifier} $m_id
      set_instance_parameter_value alt_phy_${n} {set_csr_soft_logic_enable} {1}
      set_instance_parameter_value alt_phy_${n} {L} 1
      add_connection alt_core_pll.outclk0 alt_phy_${n}.txlink_clk
      add_connection alt_sys_clk.clk_reset alt_phy_${n}.txlink_rst_n
      add_interface tx_data_${n} conduit end
      set_interface_property tx_data_${n} EXPORT_OF alt_phy_${n}.tx_serial_data
      add_connection alt_xphy.tx_phy${n}_analogreset alt_phy_${n}.tx_analogreset
      add_connection alt_xphy.tx_phy${n}_digitalreset alt_phy_${n}.tx_digitalreset
      add_connection alt_lane_pll.tx_serial_clk alt_phy_${n}.tx_serial_clk0

      if {$m_device_family eq "Arria V"} {

        add_instance alt_phy_reconfig_${n} alt_xcvr_reconfig 16.0
        set_instance_parameter_value alt_phy_reconfig_${n} {number_of_reconfig_interfaces} {1}
        add_connection alt_sys_clk.clk alt_phy_reconfig_${n}.mgmt_clk_clk
        add_connection alt_sys_clk.clk_reset alt_phy_reconfig_${n}.mgmt_rst_reset
        add_interface phy_reconfig_${n} avalon slave
        set_interface_property phy_reconfig_${n} EXPORT_OF alt_phy_reconfig_${n}.reconfig_mgmt
        add_connection alt_phy_reconfig_${n}.reconfig_to_xcvr alt_phy_${n}.reconfig_to_xcvr
        add_connection alt_phy_${n}.reconfig_from_xcvr alt_phy_reconfig_${n}.reconfig_from_xcvr

      } else {

        add_connection alt_sys_clk.clk alt_phy_${n}.reconfig_clk
        add_connection alt_sys_clk.clk_reset alt_phy_${n}.reconfig_reset
        add_interface phy_reconfig_${n} avalon slave
        set_interface_property phy_reconfig_${n} EXPORT_OF alt_phy_${n}.reconfig_avmm
      }

      add_connection alt_phy_${n}.tx_cal_busy alt_xphy.tx_phy${n}_cal_busy
      add_connection alt_phy_${n}.phy_csr_tx_pcfifo_full alt_xphy.tx_phy${n}_pcfifo_full
      add_connection alt_phy_${n}.phy_csr_tx_pcfifo_empty alt_xphy.tx_phy${n}_pcfifo_empty
      add_connection alt_xphy.tx_phy${n}_pcs_data alt_phy_${n}.jesd204_tx_pcs_data
      add_connection alt_xphy.tx_phy${n}_pcs_kchar_data alt_phy_${n}.jesd204_tx_pcs_kchar_data
      add_connection alt_xphy.tx_phy${n}_elecidle alt_phy_${n}.phy_tx_elecidle
      add_connection alt_xphy.tx_phy${n}_csr_lane_polarity alt_phy_${n}.csr_lane_polarity
      add_connection alt_xphy.tx_phy${n}_csr_lane_powerdown alt_phy_${n}.csr_lane_powerdown
      add_connection alt_xphy.tx_phy${n}_csr_bit_reversal alt_phy_${n}.csr_bit_reversal
      add_connection alt_xphy.tx_phy${n}_csr_byte_reversal alt_phy_${n}.csr_byte_reversal
    }
  }

  if {$m_tx_or_rx_n == 0} {

    add_instance alt_rst_cntrol altera_xcvr_reset_control 16.0
    set_instance_parameter_value alt_rst_cntrol {CHANNELS} $m_num_of_lanes
    set_instance_parameter_value alt_rst_cntrol {SYS_CLK_IN_MHZ} $m_sysclk_frequency
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

    add_instance alt_ip altera_jesd204 16.0
    set_instance_parameter_value alt_ip {wrapper_opt} {base}
    set_instance_parameter_value alt_ip {DATA_PATH} {RX}
    set_instance_parameter_value alt_ip {lane_rate} $m_lane_rate
    set_instance_parameter_value alt_ip {L} $m_num_of_lanes
    set_instance_parameter_value alt_ip {M} $m_num_of_convs
    set_instance_parameter_value alt_ip {GUI_EN_CFG_F} {1}
    set_instance_parameter_value alt_ip {GUI_CFG_F} $m_frm_bcnt
    set_instance_parameter_value alt_ip {N} {16}
    set_instance_parameter_value alt_ip {N_PRIME} {16}
    set_instance_parameter_value alt_ip {S} $m_frm_scnt
    set_instance_parameter_value alt_ip {K} $m_mf_fcnt
    set_instance_parameter_value alt_ip {SCR} {1}
    set_instance_parameter_value alt_ip {HD} $m_hd
    add_connection alt_core_pll.outclk0 alt_ip.rxlink_clk
    add_connection alt_sys_clk.clk_reset alt_ip.rxlink_rst_n
    add_interface ip_sof conduit end
    set_interface_property ip_sof EXPORT_OF alt_ip.sof
    add_interface ip_data avalon_streaming source
    set_interface_property ip_data EXPORT_OF alt_ip.jesd204_rx_link
    add_connection alt_sys_clk.clk alt_ip.jesd204_rx_avs_clk
    add_connection alt_sys_clk.clk_reset alt_ip.jesd204_rx_avs_rst_n
    add_interface ip_reconfig avalon slave
    set_interface_property ip_reconfig EXPORT_OF alt_ip.jesd204_rx_avs
    add_interface sysref conduit end
    set_interface_property sysref EXPORT_OF alt_ip.sysref
    add_interface sync conduit end
    set_interface_property sync EXPORT_OF alt_ip.dev_sync_n
    add_connection alt_ip.dev_lane_aligned alt_ip.alldev_lane_aligned

    add_instance alt_xphy avl_adxphy 1.0
    set_instance_parameter_value alt_xphy {TX_OR_RX_N} {0}
    set_instance_parameter_value alt_xphy {NUM_OF_LANES} $m_num_of_lanes
    add_connection alt_rst_cntrol.rx_analogreset alt_xphy.rx_core_analogreset
    add_connection alt_rst_cntrol.rx_digitalreset alt_xphy.rx_core_digitalreset
    add_connection alt_xphy.rx_core_is_lockedtodata alt_rst_cntrol.rx_is_lockedtodata
    add_connection alt_xphy.rx_core_cal_busy alt_rst_cntrol.rx_cal_busy
    add_connection alt_xphy.rx_ip_is_lockedtodata alt_ip.rx_islockedtodata
    add_connection alt_xphy.rx_ip_cal_busy alt_ip.rx_cal_busy
    add_connection alt_xphy.rx_ip_pcs_data_valid alt_ip.jesd204_rx_pcs_data_valid
    add_connection alt_xphy.rx_ip_pcs_data alt_ip.jesd204_rx_pcs_data
    add_connection alt_xphy.rx_ip_pcs_disperr alt_ip.jesd204_rx_pcs_disperr
    add_connection alt_xphy.rx_ip_pcs_errdetect alt_ip.jesd204_rx_pcs_errdetect
    add_connection alt_xphy.rx_ip_pcs_kchar_data alt_ip.jesd204_rx_pcs_kchar_data
    add_connection alt_xphy.rx_ip_pcfifo_full alt_ip.phy_csr_rx_pcfifo_full
    add_connection alt_xphy.rx_ip_pcfifo_empty alt_ip.phy_csr_rx_pcfifo_empty
    add_connection alt_xphy.rx_ip_patternalign_en alt_ip.patternalign_en
    add_connection alt_xphy.rx_ip_csr_lane_polarity alt_ip.csr_lane_polarity
    add_connection alt_xphy.rx_ip_csr_lane_powerdown alt_ip.csr_lane_powerdown
    add_connection alt_xphy.rx_ip_csr_bit_reversal alt_ip.csr_bit_reversal
    add_connection alt_xphy.rx_ip_csr_byte_reversal alt_ip.csr_byte_reversal

    for {set n 0} {$n < $m_num_of_lanes} {incr n} {

      add_instance alt_phy_${n} altera_jesd204 16.0
      set_instance_parameter_value alt_phy_${n} {wrapper_opt} {phy}
      set_instance_parameter_value alt_phy_${n} {DATA_PATH} {RX}
      set_instance_parameter_value alt_phy_${n} {lane_rate} $m_lane_rate
      set_instance_parameter_value alt_phy_${n} {PCS_CONFIG} $m_pcs_config
      set_instance_parameter_value alt_phy_${n} {REFCLK_FREQ} $m_refclk_frequency
      set_instance_parameter_value alt_phy_${n} {pll_reconfig_enable} {1}
      set_instance_parameter_value alt_phy_${n} {set_capability_reg_enable} {1}
      set_instance_parameter_value alt_phy_${n} {set_user_identifier} $m_id
      set_instance_parameter_value alt_phy_${n} {set_csr_soft_logic_enable} {1}
      set_instance_parameter_value alt_phy_${n} {L} 1

      if {$m_device_family eq "Arria V"} {

        add_interface phy_reconfig_to_xcvr_${n} conduit end
        set_interface_property phy_reconfig_to_xcvr_${n} EXPORT_OF alt_phy_${n}.reconfig_to_xcvr
        add_interface phy_reconfig_from_xcvr_${n} conduit end
        set_interface_property phy_reconfig_from_xcvr_${n} EXPORT_OF alt_phy_${n}.reconfig_from_xcvr

      } else {

        add_connection alt_sys_clk.clk alt_phy_${n}.reconfig_clk
        add_connection alt_sys_clk.clk_reset alt_phy_${n}.reconfig_reset
        add_interface phy_reconfig_${n} avalon slave
        set_interface_property phy_reconfig_${n} EXPORT_OF alt_phy_${n}.reconfig_avmm
      }

      add_connection alt_ref_clk.out_clk alt_phy_${n}.pll_ref_clk
      add_connection alt_core_pll.outclk0 alt_phy_${n}.rxlink_clk
      add_connection alt_sys_clk.clk_reset alt_phy_${n}.rxlink_rst_n
      add_interface rx_data_${n} conduit end
      set_interface_property rx_data_${n} EXPORT_OF alt_phy_${n}.rx_serial_data
      add_connection alt_xphy.rx_phy${n}_analogreset alt_phy_${n}.rx_analogreset
      add_connection alt_xphy.rx_phy${n}_digitalreset alt_phy_${n}.rx_digitalreset
      add_connection alt_phy_${n}.rx_islockedtodata alt_xphy.rx_phy${n}_is_lockedtodata
      add_connection alt_phy_${n}.rx_cal_busy alt_xphy.rx_phy${n}_cal_busy
      add_connection alt_phy_${n}.jesd204_rx_pcs_data_valid alt_xphy.rx_phy${n}_pcs_data_valid
      add_connection alt_phy_${n}.jesd204_rx_pcs_data alt_xphy.rx_phy${n}_pcs_data
      add_connection alt_phy_${n}.jesd204_rx_pcs_disperr alt_xphy.rx_phy${n}_pcs_disperr
      add_connection alt_phy_${n}.jesd204_rx_pcs_errdetect alt_xphy.rx_phy${n}_pcs_errdetect
      add_connection alt_phy_${n}.jesd204_rx_pcs_kchar_data alt_xphy.rx_phy${n}_pcs_kchar_data
      add_connection alt_phy_${n}.phy_csr_rx_pcfifo_full alt_xphy.rx_phy${n}_pcfifo_full
      add_connection alt_phy_${n}.phy_csr_rx_pcfifo_empty alt_xphy.rx_phy${n}_pcfifo_empty
      add_connection alt_xphy.rx_phy${n}_patternalign_en alt_phy_${n}.patternalign_en
      add_connection alt_xphy.rx_phy${n}_csr_lane_polarity alt_phy_${n}.csr_lane_polarity
      add_connection alt_xphy.rx_phy${n}_csr_lane_powerdown alt_phy_${n}.csr_lane_powerdown
      add_connection alt_xphy.rx_phy${n}_csr_bit_reversal alt_phy_${n}.csr_bit_reversal
      add_connection alt_xphy.rx_phy${n}_csr_byte_reversal alt_phy_${n}.csr_byte_reversal
    }
  }
}

