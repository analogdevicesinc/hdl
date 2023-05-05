
source ../../../../hdl/scripts/adi_env.tcl
source ../../../../hdl/projects/scripts/adi_project_xilinx.tcl
source ../../../../hdl/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   RX_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
#   TX_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links
#

adi_project ad_xband16_ebz_vcu118 0 [list \
  JESD_MODE    [get_env_param JESD_MODE           64B66B] \
  RX_LANE_RATE [get_env_param RX_RATE              26.4 ] \
  TX_LANE_RATE [get_env_param TX_RATE              26.4 ] \
  RX_JESD_M    [get_env_param RX_JESD_M               8 ] \
  RX_JESD_L    [get_env_param RX_JESD_L               4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S               1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP             16 ] \
  RX_NUM_LINKS [get_env_param RX_NUM_LINKS            4 ] \
  TX_JESD_M    [get_env_param TX_JESD_M               8 ] \
  TX_JESD_L    [get_env_param TX_JESD_L               4 ] \
  TX_JESD_S    [get_env_param TX_JESD_S               1 ] \
  TX_JESD_NP   [get_env_param TX_JESD_NP             16 ] \
  TX_NUM_LINKS [get_env_param TX_NUM_LINKS            4 ] \
  RX_KS_PER_CHANNEL [get_env_param RX_KS_PER_CHANNEL 16 ] \
  TX_KS_PER_CHANNEL [get_env_param TX_KS_PER_CHANNEL 16 ] \
]

adi_project_files ad_xband16_ebz_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../../hdl/library/common/ad_3w_spi.v" \
  "../../../../hdl/library/common/ad_iobuf.v" \
  "../../../../hdl/projects/common/vcu118/vcu118_system_constr.xdc" ]

# Avoid critical warning in OOC mode from the clock definitions
# since at that stage the submodules are not stiched together yet
if {$ADI_USE_OOC_SYNTHESIS == 1} {
  set_property used_in_synthesis false [get_files timing_constr.xdc]
}

set_property strategy Performance_RefinePlacement [get_runs impl_1]

adi_project_run ad_xband16_ebz_vcu118
