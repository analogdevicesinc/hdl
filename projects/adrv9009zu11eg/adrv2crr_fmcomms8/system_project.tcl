
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xczu11eg-ffvf1517-2-i"
set sys_zynq 2

adi_project fmcomms8_adrv9009zu11eg 0 [list \
  JESD_RX_M 16 \
  JESD_RX_L 8 \
  JESD_RX_S 1 \
  JESD_TX_M 16 \
  JESD_TX_L 16 \
  JESD_TX_S 1 \
  JESD_OBS_M 8 \
  JESD_OBS_L 8 \
  JESD_OBS_S 1 \
]

adi_project_files  fmcomms8_adrv9009zu11eg [list \
  "system_top.v" \
  "fmcomms8_constr.xdc"\
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
 ]

adi_project_run fmcomms8_adrv9009zu11eg
