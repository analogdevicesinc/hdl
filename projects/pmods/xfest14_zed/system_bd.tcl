
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

set pmod_ja1 [create_bd_port -dir O pmod_ja1]
set pmod_ja2 [create_bd_port -dir O pmod_ja2]
set pmod_ja3 [create_bd_port -dir I pmod_ja3]
set pmod_ja4 [create_bd_port -dir O pmod_ja4]

set pmod_jb1 [create_bd_port -dir O pmod_jb1]
set pmod_jb2 [create_bd_port -dir O pmod_jb2]
set pmod_jb3 [create_bd_port -dir I pmod_jb3]
set pmod_jb4 [create_bd_port -dir O pmod_jb4]

set pmod_jc1 [create_bd_port -dir O pmod_jc1]
set pmod_jc2 [create_bd_port -dir O pmod_jc2]
set pmod_jc3 [create_bd_port -dir I pmod_jc3]
set pmod_jc4 [create_bd_port -dir O pmod_jc4]
set pmod_jc7 [create_bd_port -dir I pmod_jc7]
set pmod_jc8 [create_bd_port -dir O pmod_jc8]
set pmod_jc9 [create_bd_port -dir I pmod_jc9]
set pmod_jc10 [create_bd_port -dir O pmod_jc10]

set pmod_jd1 [create_bd_port -dir O pmod_jd1]
set pmod_jd2 [create_bd_port -dir O pmod_jd2]
set pmod_jd3 [create_bd_port -dir I pmod_jd3]
set pmod_jd4 [create_bd_port -dir O pmod_jd4]

set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {49}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_GRP_FULL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_UART0_IO {EMIO}] $sys_ps7
set_property LEFT 48 [get_bd_ports GPIO_I]
set_property LEFT 48 [get_bd_ports GPIO_O]
set_property LEFT 48 [get_bd_ports GPIO_T]

set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_PORTS {7}] $sys_concat_intc

set sys_const_vcc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_const_vcc]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $sys_const_vcc

set sys_const_gnd [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_const_gnd]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {0}] $sys_const_gnd

connect_bd_net -net net_vcc [get_bd_pins sys_const_vcc/const]
connect_bd_net -net net_gnd [get_bd_pins sys_const_gnd/const]

set axi_spi_pmod_jc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_spi_pmod_jc]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_spi_pmod_jc
set_property -dict [list CONFIG.C_NUM_SS_BITS {1}] $axi_spi_pmod_jc
set_property -dict [list CONFIG.C_SCK_RATIO {16}] $axi_spi_pmod_jc
set_property -dict [list CONFIG.Multiples16 {4}] $axi_spi_pmod_jc

set axi_spi_pmod_jd [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_spi_pmod_jd]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_spi_pmod_jd
set_property -dict [list CONFIG.C_NUM_SS_BITS {1}] $axi_spi_pmod_jd
set_property -dict [list CONFIG.C_SCK_RATIO {16}] $axi_spi_pmod_jd
set_property -dict [list CONFIG.Multiples16 {4}] $axi_spi_pmod_jd

connect_bd_net -net pmod_ja1 [get_bd_ports pmod_ja1] [get_bd_pins sys_ps7/SPI0_SS_O]
connect_bd_net -net pmod_ja2 [get_bd_ports pmod_ja2] [get_bd_pins sys_ps7/SPI0_MOSI_O]
connect_bd_net -net pmod_ja3 [get_bd_ports pmod_ja3] [get_bd_pins sys_ps7/SPI0_MISO_I]
connect_bd_net -net pmod_ja4 [get_bd_ports pmod_ja4] [get_bd_pins sys_ps7/SPI0_SCLK_O]

connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI0_MOSI_I]
connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI0_SCLK_I]
connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI0_SS_I]

connect_bd_net -net pmod_jb1 [get_bd_ports pmod_jb1] [get_bd_pins sys_ps7/SPI1_SS_O]
connect_bd_net -net pmod_jb2 [get_bd_ports pmod_jb2] [get_bd_pins sys_ps7/SPI1_MOSI_O]
connect_bd_net -net pmod_jb3 [get_bd_ports pmod_jb3] [get_bd_pins sys_ps7/SPI1_MISO_I]
connect_bd_net -net pmod_jb4 [get_bd_ports pmod_jb4] [get_bd_pins sys_ps7/SPI1_SCLK_O]

connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI1_MOSI_I]
connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI1_SCLK_I]
connect_bd_net -net net_vcc [get_bd_pins sys_ps7/SPI1_SS_I]

connect_bd_net -net pmod_jc1 [get_bd_ports pmod_jc1] [get_bd_pins axi_spi_pmod_jc/ss_o]
connect_bd_net -net pmod_jc2 [get_bd_ports pmod_jc2] [get_bd_pins axi_spi_pmod_jc/io0_o]
connect_bd_net -net pmod_jc3 [get_bd_ports pmod_jc3] [get_bd_pins axi_spi_pmod_jc/io1_i]
connect_bd_net -net pmoc_jc4 [get_bd_ports pmod_jc4] [get_bd_pins axi_spi_pmod_jc/sck_o]
connect_bd_net -net pmod_jc7 [get_bd_ports pmod_jc7] [get_bd_pins sys_ps7/UART0_DCDN]
connect_bd_net -net pmod_jc8 [get_bd_ports pmod_jc8] [get_bd_pins sys_ps7/UART0_TX]
connect_bd_net -net pmod_jc9 [get_bd_ports pmod_jc9] [get_bd_pins sys_ps7/UART0_RX]
connect_bd_net -net pmoc_jc10 [get_bd_ports pmod_jc10] [get_bd_pins sys_ps7/UART0_RTSN]

connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jc/ss_i]
connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jc/sck_i]
connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jc/io0_i]
connect_bd_net -net net_gnd [get_bd_pins sys_ps7/UART0_CTSN]
connect_bd_net -net net_gnd [get_bd_pins sys_ps7/UART0_DSRN]
connect_bd_net -net net_gnd [get_bd_pins sys_ps7/UART0_RIN]

connect_bd_net -net pmod_jd1 [get_bd_ports pmod_jd1] [get_bd_pins axi_spi_pmod_jd/ss_o]
connect_bd_net -net pmod_jd2 [get_bd_ports pmod_jd2] [get_bd_pins axi_spi_pmod_jd/io0_o]
connect_bd_net -net pmod_jd3 [get_bd_ports pmod_jd3] [get_bd_pins axi_spi_pmod_jd/io1_i]
connect_bd_net -net pmoc_jd4 [get_bd_ports pmod_jd4] [get_bd_pins axi_spi_pmod_jd/sck_o]

connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jd/ss_i]
connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jd/sck_i]
connect_bd_net -net net_vcc [get_bd_pins axi_spi_pmod_jd/io0_i]

connect_bd_net -net axi_spi_pmod_jc_irq [get_bd_pins axi_spi_pmod_jc/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In5]
connect_bd_net -net axi_spi_pmod_jd_irq [get_bd_pins axi_spi_pmod_jd/ip2intc_irpt]   [get_bd_pins sys_concat_intc/In6]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_spi_pmod_jc/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spi_pmod_jd/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spi_pmod_jc/ext_spi_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spi_pmod_jd/ext_spi_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spi_pmod_jc/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spi_pmod_jd/s_axi_aresetn]

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_spi_pmod_jc/axi_lite]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_spi_pmod_jd/axi_lite]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source

create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spi_pmod_jc/axi_lite/Reg]    SEG_data_spi_pmod_jc
create_bd_addr_seg -range 0x00010000 -offset 0x44A80000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spi_pmod_jd/axi_lite/Reg]    SEG_data_spi_pmod_jd

