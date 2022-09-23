source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=2
#      make RX_JESD_L=4 RX_JESD_M=4 

# Parameter description:
#   RX_JESD_M : Number of converters per link
#   RX_JESD_L : Number of lanes per link
#   RX_JESD_S : Number of samples per frame
#   RX_JESD_NP : Number of bits per sample

adi_project fmcjesdadc1_kc705 0 [list \
  RX_JESD_M    [get_env_param RX_JESD_M    4 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP   16] \
]

adi_project_files fmcjesdadc1_kc705 [list \
  "../common/fmcjesdadc1_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "$ad_hdl_dir/projects/common/kc705/kc705_system_constr.xdc" ]

adi_project_run fmcjesdadc1_kc705

