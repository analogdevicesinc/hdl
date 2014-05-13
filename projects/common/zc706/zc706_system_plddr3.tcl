
# pl ddr3 (use only when dma is not capable of keeping up)

set axi_plddr3 [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.0 axi_plddr3]
set_property -dict [list CONFIG.XML_INPUT_FILE {kc705_system_mig.prj}] $axi_plddr3


