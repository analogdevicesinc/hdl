
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/ad6676evb_bd.tcl

ad_connect axi_ad6676_xcvr/gt0_rx axi_ad6676_jesd/rx_phy0
ad_connect axi_ad6676_xcvr/gt1_rx axi_ad6676_jesd/rx_phy1


