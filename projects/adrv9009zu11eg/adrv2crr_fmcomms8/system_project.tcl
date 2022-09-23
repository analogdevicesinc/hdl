source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcomms8_adrv9009zu11eg 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M    16 ] \
  RX_JESD_L       [get_env_param RX_JESD_L     8 ] \
  RX_JESD_S       [get_env_param RX_JESD_S     1 ] \
  TX_JESD_M       [get_env_param TX_JESD_M    16 ] \
  TX_JESD_L       [get_env_param TX_JESD_L    16 ] \
  TX_JESD_S       [get_env_param TX_JESD_S     1 ] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  8 ] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  8 ] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1 ] \
] "xczu11eg-ffvf1517-2-i"


adi_project_files fmcomms8_adrv9009zu11eg [list \
  "system_top.v" \
  "fmcomms8_constr.xdc"\
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
 ]

adi_project_run fmcomms8_adrv9009zu11eg
