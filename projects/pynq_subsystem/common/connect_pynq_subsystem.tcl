source ../common/create_pynq_mb_subsystem.tcl

proc connect_pynq_subsystem { {iop_base_addr 0x42000000} {intc_base_addr 0x41800000} } {

  create_pynq_mb_subsystem IOP1 $iop_base_addr

  #SPI
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0
  ad_connect SPI_0  IOP1/SPI_0

  #GPIO
  create_bd_port -dir O  data_o
  ad_connect    data_o   IOP1/data_o

  #IIC
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC
  ad_connect IIC  IOP1/IIC

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART
  ad_connect UART  IOP1/UART

  ad_ip_instance xlslice iop_intr_ack [list \
      DIN_FROM 5 \
      DIN_TO 5 \
      DIN_WIDTH 7 \
  ]
  ad_connect  iop_intr_ack/Din  sys_ps7/GPIO_O
  ad_connect  iop_intr_ack/Dout IOP1/intr_ack

  ad_ip_instance xlslice iop_reset [list \
      DIN_FROM 1 \
      DIN_TO 1 \
      DIN_WIDTH 7 \
  ]
  ad_connect  iop_reset/Din   sys_ps7/GPIO_O
  ad_connect  iop_reset/Dout  IOP1/aux_reset_in

  ad_ip_instance proc_sys_reset sys_rstgen [list \
      C_EXT_RST_WIDTH 1 \
  ]
  ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
  ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N
  ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn

  ad_ip_instance axi_intc system_interrupts
  ad_connect  sys_cpu_clk system_interrupts/s_axi_aclk
  ad_connect sys_cpu_resetn  system_interrupts/s_axi_aresetn
  ad_connect  IOP1/intr_req system_interrupts/intr

  ad_ip_instance xlconcat xconcat_0 [list \
      NUM_PORTS {16} \
  ]
  ad_connect xconcat_0/In0  system_interrupts/irq
  ad_connect xconcat_0/dout sys_ps7/IRQ_F2P

  ad_cpu_interconnect $intc_base_addr system_interrupts
  set_property range 64K [get_bd_addr_segs {sys_ps7/Data/SEG_data_system_interrupts}]
}
