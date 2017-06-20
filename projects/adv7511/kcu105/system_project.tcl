
## This project requires the following patches.
## The setup we use is listed below, you may change it to suit your needs.
## AR66031
##    1.  Download the zip file from www.xilinx.com/support/answers/66031.html
##    2.  mkdir -p /opt/Xilinx/Vivado/2015.4/KCU105/AR66031
##    3.  unzip ~/Downloads/AR66031_Vivado_2015_4_preliminary_rev66031.zip \
##          -d /opt/Xilinx/Vivado/2015.4/KCU105/AR66031/
##    4.  export MYVIVADO=/opt/Xilinx/Vivado/2015.4/KCU105/AR66031/vivado
## AR66052
##    1.  Download the verilog file from www.xilinx.com/support/answers/66052.html
##    2.  mkdir -p /opt/Xilinx/Vivado/2015.4/KCU105/AR66052
##    3.  cp ~/Downloads/gig_ethernet_pcs_pma_1_serdes_1_to_10_ser8.v \
##          /opt/Xilinx/Vivado/2015.4/KCU105/AR66052/bd_0_pcs_pma_0_serdes_1_to_10_ser8.v 
##    4.  sed -i 's/gig_ethernet_pcs_pma_1/bd_0_pcs_pma_0/g' \
##          /opt/Xilinx/Vivado/2015.4/KCU105/AR66052/bd_0_pcs_pma_0_serdes_1_to_10_ser8.v 
 
set REQUIRED_VIVADO_VERSION "2015.4.2_AR66031"

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create adv7511_kcu105
adi_project_files adv7511_kcu105 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" ]

file copy -force $::env(MYVIVADO)/../../AR66052/bd_0_pcs_pma_0_serdes_1_to_10_ser8.v \
  adv7511_kcu105.srcs/sources_1/bd/system/ip/system_axi_ethernet_0/bd_0/ip/ip_2/synth/sgmii_lvds_transceiver/bd_0_pcs_pma_0_serdes_1_to_10_ser8.v

adi_project_run adv7511_kcu105


