
# create a SPI Engine architecture
create_bd_cell -type hier spi
current_bd_instance /spi

	create_bd_pin -dir I -type clk clk
	create_bd_pin -dir I -type rst resetn
	create_bd_pin -dir O irq
	create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi

	set spi_engine [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_execution:1.0 execution]
	set axi_spi_engine [create_bd_cell -type ip -vlnv analog.com:user:axi_spi_engine:1.0 axi]
	set spi_engine_interconnect [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_interconnect:1.0 interconnect]

	set_property -dict [list CONFIG.NUM_OF_CS 1] $spi_engine

	ad_connect axi/spi_engine_ctrl interconnect/s0_ctrl
	ad_connect interconnect/m_ctrl execution/ctrl
        ad_connect m_spi execution/spi

	connect_bd_net \
		[get_bd_pins clk] \
		[get_bd_pins execution/clk] \
		[get_bd_pins axi/s_axi_aclk] \
		[get_bd_pins axi/spi_clk] \
		[get_bd_pins interconnect/clk]

	connect_bd_net \
		[get_bd_pins axi/spi_resetn] \
		[get_bd_pins execution/resetn] \
		[get_bd_pins interconnect/resetn]

	connect_bd_net [get_bd_pins resetn] [get_bd_pins axi/s_axi_aresetn]
	ad_connect irq axi/irq

current_bd_instance /

ad_connect  sys_cpu_clk spi/clk
ad_connect  sys_cpu_resetn spi/resetn

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi
ad_connect spi/m_spi spi

ad_cpu_interconnect 0x44a00000 /spi/axi

ad_cpu_interrupt "ps-12" "mb-12" /spi/irq

