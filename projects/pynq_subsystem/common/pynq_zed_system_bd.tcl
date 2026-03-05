source ../common/create_pynq_mb_subsystem.tcl



ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE 0



#set sys_cpu_clk           [get_bd_nets sys_cpu_clk]

create_pynq_mb_subsystem IOP1

#ad_connect sys_cpu_resetn IOP1/aux_reset_in

#ad_mem_hp0_interconnect sys_cpu_clk IOP1/M_AXI



#GPIO
create_bd_port -dir O  data_o
ad_connect    data_o   IOP1/data_o

create_bd_port -dir I  reset_IOP
create_bd_port -dir I  intrack_IOP

#IIC

#add SPI

 create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0
 ad_connect SPI_0  IOP1/SPI_0

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC
ad_connect IIC  IOP1/IIC

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART
ad_connect UART  IOP1/UART



ad_connect  intrack_IOP  IOP1/intr_ack
ad_connect  reset_IOP  IOP1/aux_reset_in



#set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]


ad_ip_instance axi_intc system_interrupts [list \
 C_IRQ_CONNECTION 1 \
 ]
ad_connect  sys_cpu_clk system_interrupts/s_axi_aclk 
ad_connect sys_cpu_resetn  system_interrupts/s_axi_aresetn
ad_connect  IOP1/intr_req system_interrupts/intr



ad_cpu_interrupt ps-0 mb-0  system_interrupts/irq  


ad_cpu_interconnect 0x79010000  system_interrupts  

#ad_cpu_interconnect 0x42000000 IOP1
#set_property range 64K [get_bd_addr_segs {sys_ps7/Data/mb_bram_ctrl}]

########################################################
#i3c

create_bd_intf_port -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 i3c

source $ad_hdl_dir/library/i3c_controller/scripts/i3c_controller_bd.tcl

set async_clk 0
set i2c_mod 4
set offload 1
set max_devs 16

i3c_controller_create i3c $async_clk $i2c_mod $offload $max_devs

# pwm to trigger on offload data burst
ad_ip_instance axi_pwm_gen i3c_offload_pwm
ad_ip_parameter i3c_offload_pwm CONFIG.PULSE_0_PERIOD 120
ad_ip_parameter i3c_offload_pwm CONFIG.PULSE_0_WIDTH 1

 # dma to receive offload data stream
ad_ip_instance axi_dmac i3c_offload_dma
ad_ip_parameter i3c_offload_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter i3c_offload_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter i3c_offload_dma CONFIG.CYCLIC 0  
ad_ip_parameter i3c_offload_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter i3c_offload_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter i3c_offload_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter i3c_offload_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter i3c_offload_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter i3c_offload_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect sys_cpu_clk i3c_offload_pwm/ext_clk
ad_connect sys_cpu_clk i3c_offload_pwm/s_axi_aclk
ad_connect sys_cpu_clk i3c/clk
ad_connect sys_cpu_clk i3c/s_axi_aclk
ad_connect sys_cpu_resetn i3c_offload_pwm/s_axi_aresetn
ad_connect i3c_offload_pwm/pwm_0 i3c/trigger

ad_connect i3c_offload_dma/s_axis i3c/offload_sdi

ad_connect i3c/m_i3c i3c


ad_connect sys_cpu_resetn i3c/reset_n

ad_connect sys_cpu_clk i3c_offload_dma/s_axis_aclk
ad_connect sys_cpu_resetn i3c_offload_dma/m_dest_axi_aresetn


ad_cpu_interconnect 0x79030000 i3c/host_interface

ad_cpu_interconnect 0x79040000 i3c_offload_dma
ad_cpu_interconnect 0x79050000 i3c_offload_pwm


ad_cpu_interrupt "ps-13" "mb-13" i3c_offload_dma/irq

ad_cpu_interrupt "ps-12" "mb-12" i3c/irq

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk i3c_offload_dma/m_dest_axi





