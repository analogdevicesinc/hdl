# imageon iic

set axi_iic_imageon [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_imageon]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_iic_imageon
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_imageon

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_imageon
ad_connect iic_imageon axi_iic_imageon/iic
ad_cpu_interconnect 0x43C40000 axi_iic_imageon
ad_cpu_interrupt ps-11 mb-11 axi_iic_imageon/iic2intc_irpt
