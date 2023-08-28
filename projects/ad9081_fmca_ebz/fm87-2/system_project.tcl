source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

 adi_project ad9081_fmca_ebz_intel_ip_fm87 [list \
  RX_LANE_RATE       [get_env_param RX_RATE      10 ] \
  TX_LANE_RATE       [get_env_param TX_RATE      10 ] \
  RX_JESD_M          [get_env_param RX_JESD_M    8 ] \
  RX_JESD_L          [get_env_param RX_JESD_L    8 ] \
  RX_JESD_S          [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP         [get_env_param RX_JESD_NP   16 ] \
  RX_NUM_LINKS       [get_env_param RX_NUM_LINKS 1 ] \
  TX_JESD_M          [get_env_param TX_JESD_M    8 ] \
  TX_JESD_L          [get_env_param TX_JESD_L    8 ] \
  TX_JESD_S          [get_env_param TX_JESD_S    1 ] \
  TX_JESD_NP         [get_env_param TX_JESD_NP   16 ] \
  TX_NUM_LINKS       [get_env_param TX_NUM_LINKS 1 ] \
  RX_KS_PER_CHANNEL  [get_env_param RX_KS_PER_CHANNEL 32 ] \
  TX_KS_PER_CHANNEL  [get_env_param TX_KS_PER_CHANNEL 32 ] \
]

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/projects/common/fm87/gpio_slave.v

#execute_flow -compile
