# Create only the RX path
set INTF_CFG RX

# Dummy parameters for TX
set ad_project_params(TX_LANE_RATE) 0
set ad_project_params(TX_JESD_M) 1
set ad_project_params(TX_JESD_L) 1
set ad_project_params(TX_JESD_S) 1
set ad_project_params(TX_JESD_NP) 12
set ad_project_params(TX_NUM_LINKS) 1
set ad_project_params(TX_TPL_WIDTH) {}
set ad_project_params(SHARED_DEVCLK) 0

source $ad_hdl_dir/projects/ad9081_fmca_ebz/zcu102/system_bd.tcl