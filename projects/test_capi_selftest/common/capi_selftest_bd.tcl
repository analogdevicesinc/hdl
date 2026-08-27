###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

delete_bd_objs -quiet [get_bd_intf_nets -quiet -of_objects [get_bd_intf_ports iic_ard]]
delete_bd_objs [get_bd_intf_ports iic_ard]

delete_bd_objs -quiet [get_bd_nets -quiet -of_objects [get_bd_ports spi0_sdi_i]]
delete_bd_objs [get_bd_ports spi0_sdi_i]

delete_bd_objs -quiet [get_bd_nets -quiet -of_objects [get_bd_ports spi0_sdo_o]]
delete_bd_objs [get_bd_ports spi0_sdo_o]

ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_I2C0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE DIRECT
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_UART1 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_EMIO_UART1 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_UART1_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_BAUD_RATE 115200

ad_ip_instance axi_quad_spi axi_spi
ad_ip_parameter axi_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 16

ad_ip_instance axi_uartlite axi_uartlite_0
ad_ip_parameter axi_uartlite_0 CONFIG.C_BAUDRATE 115200

ad_ip_instance axi_timer axi_timer_0

ad_ip_instance axi_gpio axi_gpio_0
ad_ip_parameter axi_gpio_0 CONFIG.C_IS_DUAL 0
ad_ip_parameter axi_gpio_0 CONFIG.C_ALL_OUTPUTS 1
ad_ip_parameter axi_gpio_0 CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_gpio_0 CONFIG.C_INTERRUPT_PRESENT 1

ad_ip_instance axi_gpio axi_gpio_1
ad_ip_parameter axi_gpio_1 CONFIG.C_IS_DUAL 0
ad_ip_parameter axi_gpio_1 CONFIG.C_ALL_INPUTS 1
ad_ip_parameter axi_gpio_1 CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_gpio_1 CONFIG.C_INTERRUPT_PRESENT 1

foreach line {scl sda} {
  ad_ip_instance ilvector_logic iic_ps_${line}_drv
  ad_ip_parameter iic_ps_${line}_drv CONFIG.C_SIZE 1
  ad_ip_parameter iic_ps_${line}_drv CONFIG.C_OPERATION or

  ad_ip_instance ilvector_logic iic_pl_${line}_drv
  ad_ip_parameter iic_pl_${line}_drv CONFIG.C_SIZE 1
  ad_ip_parameter iic_ps_${line}_drv CONFIG.C_OPERATION or

  ad_ip_instance ilvector_logic iic_${line}_wand
  ad_ip_parameter iic_${line}_wand CONFIG.C_SIZE 1
  ad_ip_parameter iic_${line}_wand CONFIG.C_OPERATION and
}

# PS UART1 loopback
ad_connect sys_ps7/UART1_RX sys_ps7/UART1_TX

# PL UART loopback
ad_connect axi_uartlite_0/tx axi_uartlite_0/rx

# PS SPI loopback
ad_connect sys_ps7/SPI0_MOSI_O sys_ps7/SPI0_MISO_I

# PL SPI loopback
ad_connect axi_spi/sck_i GND
ad_connect axi_spi/ss_i  VCC
ad_connect axi_spi/io0_i GND

ad_connect sys_cpu_clk axi_spi/ext_spi_clk
ad_connect axi_spi/io1_i axi_spi/io0_o

# PL GPIO loopback, axi_gpio_0 output -> axi_gpio_1 input
ad_connect axi_gpio_1/gpio_io_i axi_gpio_0/gpio_io_o

# PL timer, unused inputs tied off
ad_connect axi_timer_0/freeze       GND
ad_connect axi_timer_0/capturetrig0 GND
ad_connect axi_timer_0/capturetrig1 GND

# PS & PL IIC loopback 
foreach line {scl sda} {
  ad_connect iic_ps_${line}_drv/Op1 sys_ps7/I2C0_[string toupper $line]_T
  ad_connect iic_ps_${line}_drv/Op2 sys_ps7/I2C0_[string toupper $line]_O

  ad_connect iic_pl_${line}_drv/Op1 axi_iic_ard/${line}_t
  ad_connect iic_pl_${line}_drv/Op2 axi_iic_ard/${line}_o

  ad_connect iic_${line}_wand/Op1 iic_ps_${line}_drv/Res
  ad_connect iic_${line}_wand/Op2 iic_pl_${line}_drv/Res

  ad_connect sys_ps7/I2C0_[string toupper $line]_I iic_${line}_wand/Res
  ad_connect axi_iic_ard/${line}_i                 iic_${line}_wand/Res
}

ad_cpu_interconnect 0x44a00000 axi_spi
ad_cpu_interconnect 0x44a10000 axi_uartlite_0
ad_cpu_interconnect 0x44a20000 axi_timer_0
ad_cpu_interconnect 0x44a30000 axi_gpio_0
ad_cpu_interconnect 0x44a40000 axi_gpio_1

ad_cpu_interrupt  8  8 axi_spi/ip2intc_irpt
ad_cpu_interrupt  9  9 axi_uartlite_0/interrupt
ad_cpu_interrupt 10 10 axi_timer_0/interrupt
ad_cpu_interrupt 12 12 axi_gpio_0/ip2intc_irpt
ad_cpu_interrupt 13 13 axi_gpio_1/ip2intc_irpt
