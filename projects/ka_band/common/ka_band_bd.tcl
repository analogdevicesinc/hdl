
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_ka_band

ad_ip_instance axi_iic axi_iic_ka_band
ad_connect iic_ka_band axi_iic_ka_band/iic

# AXI address definitions

ad_cpu_interconnect 0x44a40000 axi_iic_ka_band

# interrupts

ad_cpu_interrupt "ps-12" "mb-12" axi_iic_ka_band/iic2intc_irpt
