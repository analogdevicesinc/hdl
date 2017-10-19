
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl

ad_connect axi_fmcadc1_xcvr/gt0_rx axi_fmcadc1_jesd/rx_phy0
ad_connect axi_fmcadc1_xcvr/gt1_rx axi_fmcadc1_jesd/rx_phy1
ad_connect axi_fmcadc1_xcvr/gt2_rx axi_fmcadc1_jesd/rx_phy2
ad_connect axi_fmcadc1_xcvr/gt3_rx axi_fmcadc1_jesd/rx_phy3

