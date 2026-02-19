source ../common/create_pynq_mb_subsystem.tcl

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7 [list \
    PCW_EN_RST1_PORT 0 \
    PCW_USE_DMA0 0 \
    PCW_USE_DMA1 0 \
    PCW_USE_DMA2 0 \
    PCW_USE_S_AXI_GP0 1 \
    PCW_USE_S_AXI_HP0 1 \
    PCW_USE_S_AXI_HP2 1 \
    PCW_GPIO_MIO_GPIO_ENABLE 0 \
    PCW_I2C0_PERIPHERAL_ENABLE 1 \
    PCW_SPI0_PERIPHERAL_ENABLE 0 \
    PCW_SPI1_PERIPHERAL_ENABLE 0 \
    PCW_GPIO_EMIO_GPIO_IO 7 \
    PCW_QSPI_GRP_SINGLE_SS_ENABLE 1 \
    PCW_EN_CLK1_PORT 1 \
    PCW_EN_CLK2_PORT 1 \
    PCW_EN_CLK3_PORT 1 \
    PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0 \
    PCW_FPGA1_PERIPHERAL_FREQMHZ 142.0 \
    PCW_FPGA2_PERIPHERAL_FREQMHZ 200 \
    PCW_FPGA3_PERIPHERAL_FREQMHZ 100 \
    PCW_IMPORT_BOARD_PRESET ZedBoard \
    PCW_TTC0_PERIPHERAL_ENABLE 0 \
    PCW_USE_FABRIC_INTERRUPT 1 \
    PCW_IRQ_F2P_INTR 1 \
    PCW_GPIO_EMIO_GPIO_ENABLE 1 \
    PCW_IRQ_F2P_MODE REVERSE \
    PCW_SPI0_SPI0_IO EMIO \
    PCW_SPI1_SPI1_IO EMIO \
]
ad_connect  ddr           sys_ps7/DDR
ad_connect  fixed_io      sys_ps7/FIXED_IO
ad_connect  sys_cpu_clk  sys_ps7/FCLK_CLK0
ad_connect   sys_ps7/S_AXI_GP0_ACLK             sys_cpu_clk
ad_connect   sys_ps7/S_AXI_HP0_ACLK             sys_ps7/FCLK_CLK1
ad_connect   sys_ps7/S_AXI_HP2_ACLK             sys_ps7/FCLK_CLK3

#set sys_cpu_clk           [get_bd_nets sys_cpu_clk]

create_pynq_mb_subsystem IOP1

#ad_connect sys_cpu_resetn IOP1/aux_reset_in

#ad_mem_hp0_interconnect sys_cpu_clk IOP1/M_AXI
#add SPI
create_bd_port -dir I  SPI_0_io0_i
create_bd_port -dir O  SPI_0_io0_o
create_bd_port -dir O  SPI_0_io0_t
create_bd_port -dir I  SPI_0_io1_i
create_bd_port -dir O  SPI_0_io1_o
create_bd_port -dir O  SPI_0_io1_t
create_bd_port -dir I  SPI_0_sck_i
create_bd_port -dir O  SPI_0_sck_o
create_bd_port -dir O  SPI_0_sck_t
create_bd_port -dir I  SPI_0_ss_i
create_bd_port -dir O  SPI_0_ss_o
create_bd_port -dir O  SPI_0_ss_t


ad_connect    SPI_0_io0_i   IOP1/SPI_0_io0_i
ad_connect    SPI_0_io0_o   IOP1/SPI_0_io0_o
ad_connect    SPI_0_io0_t   IOP1/SPI_0_io0_t
ad_connect    SPI_0_io1_i   IOP1/SPI_0_io1_i
ad_connect    SPI_0_io1_o   IOP1/SPI_0_io1_o
ad_connect    SPI_0_io1_t   IOP1/SPI_0_io1_t
ad_connect    SPI_0_sck_i   IOP1/SPI_0_sck_i
ad_connect    SPI_0_sck_o   IOP1/SPI_0_sck_o
ad_connect    SPI_0_sck_t   IOP1/SPI_0_sck_t
ad_connect    SPI_0_ss_i    IOP1/SPI_0_ss_i
ad_connect    SPI_0_ss_o    IOP1/SPI_0_ss_o
ad_connect    SPI_0_ss_t    IOP1/SPI_0_ss_t

#GPIO
create_bd_port -dir O  data_o
ad_connect    data_o   IOP1/data_o




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


#set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]


ad_ip_instance axi_intc system_interrupts
ad_connect  sys_cpu_clk system_interrupts/s_axi_aclk 
ad_connect sys_cpu_resetn  system_interrupts/s_axi_aresetn
ad_connect  IOP1/intr_req system_interrupts/intr


ad_ip_instance xlconcat xconcat_0 [list \
    NUM_PORTS {16} \
]
ad_connect xconcat_0/In0  system_interrupts/irq
ad_connect xconcat_0/dout sys_ps7/IRQ_F2P

ad_cpu_interconnect 0x41800000  system_interrupts
set_property range 64K [get_bd_addr_segs {sys_ps7/Data/SEG_data_system_interrupts}]
#ad_cpu_interconnect 0x42000000 IOP1
#set_property range 64K [get_bd_addr_segs {sys_ps7/Data/mb_bram_ctrl}]





