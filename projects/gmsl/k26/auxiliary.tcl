create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 tca_iic
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 emio_uart

set_property CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0} [get_bd_cells sys_ps8]

set_property -dict [list \
  CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 36 .. 37} \
  CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART0__PERIPHERAL__IO {EMIO} \
] [get_bd_cells sys_ps8]

#ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1}
#ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 36 .. 37}

#set_property -dict [list \
  CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
  CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
  CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
  CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
] [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 38 .. 44}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1}

#ad_ip_parameter sys_ps8 CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1}
#ad_ip_parameter sys_ps8 CONFIG.PSU__UART0__PERIPHERAL__IO {EMIO}

ad_ip_instance axi_iic axi_tca_iic

ad_connect tca_iic axi_tca_iic/iic
ad_connect emio_uart sys_ps8/UART_0

#ad_connect  sys_concat_intc/In11  axi_tca_iic/iic2intc_irpt

ad_cpu_interconnect 0x41620000 axi_tca_iic
