# create_pynq_mb_subsystem.tcl
# Creates a PYNQ-style MicroBlaze IOP subsystem
# Based on ADI scripts style using ad_ip_instance, ad_ip_parameter, ad_connect

proc create_pynq_mb_subsystem { iop_name {base_addr 0x40000000} } {
  # Creates IOP subsystem with peripherals: GPIO, IIC, SPI
  # GPIO is directly connected to data pins for simple control
  # base_addr: Base address for BRAM controller (default 0x40000000)

  # -----------------------
  # Create hierarchy
  # -----------------------
  set hier_obj [create_bd_cell -type hier $iop_name]
  set oldCurInst [current_bd_instance .]
  current_bd_instance $hier_obj

  # -----------------------
  # Create interface pins
  # -----------------------
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0

  # -----------------------
  # Create pins
  # -----------------------
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 1 -to 0 data_i
  create_bd_pin -dir O -from 1 -to 0 data_o
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 1 -to 0 tri_o

  # -----------------------
  # Processor System Reset
  # -----------------------
  ad_ip_instance proc_sys_reset ${iop_name}_rst
  ad_ip_parameter ${iop_name}_rst CONFIG.C_AUX_RESET_HIGH 0

  ad_connect clk_100M ${iop_name}_rst/slowest_sync_clk
  ad_connect aux_reset_in ${iop_name}_rst/aux_reset_in
  ad_connect mb_debug_sys_rst ${iop_name}_rst/mb_debug_sys_rst
  ad_connect ${iop_name}_rst/peripheral_aresetn peripheral_aresetn

  # -----------------------
  # MicroBlaze
  # -----------------------
  ad_ip_instance microblaze ${iop_name}_mb
  ad_ip_parameter ${iop_name}_mb CONFIG.C_ADDR_TAG_BITS 17
  ad_ip_parameter ${iop_name}_mb CONFIG.C_DCACHE_ADDR_TAG 17
  ad_ip_parameter ${iop_name}_mb CONFIG.C_DEBUG_ENABLED 1
  ad_ip_parameter ${iop_name}_mb CONFIG.C_D_AXI 1
  ad_ip_parameter ${iop_name}_mb CONFIG.C_D_LMB 1
  ad_ip_parameter ${iop_name}_mb CONFIG.C_I_LMB 1
  ad_ip_parameter ${iop_name}_mb CONFIG.C_ENABLE_CONVERSION 0

  ad_connect clk_100M ${iop_name}_mb/Clk
  ad_connect ${iop_name}_rst/mb_reset ${iop_name}_mb/Reset
  ad_connect DEBUG ${iop_name}_mb/DEBUG

  # -----------------------
  # LMB - Data Local Memory Bus
  # -----------------------
  ad_ip_instance lmb_v10 ${iop_name}_dlmb

  ad_connect clk_100M ${iop_name}_dlmb/LMB_Clk
  ad_connect ${iop_name}_rst/bus_struct_reset ${iop_name}_dlmb/SYS_Rst
  ad_connect ${iop_name}_mb/DLMB ${iop_name}_dlmb/LMB_M

  # -----------------------
  # LMB - Instruction Local Memory Bus
  # -----------------------
  ad_ip_instance lmb_v10 ${iop_name}_ilmb

  ad_connect clk_100M ${iop_name}_ilmb/LMB_Clk
  ad_connect ${iop_name}_rst/bus_struct_reset ${iop_name}_ilmb/SYS_Rst
  ad_connect ${iop_name}_mb/ILMB ${iop_name}_ilmb/LMB_M

  # -----------------------
  # LMB BRAM Controller (handles both I and D)
  # -----------------------
  ad_ip_instance lmb_bram_if_cntlr ${iop_name}_lmb_bram_cntlr
  ad_ip_parameter ${iop_name}_lmb_bram_cntlr CONFIG.C_ECC 0
  ad_ip_parameter ${iop_name}_lmb_bram_cntlr CONFIG.C_NUM_LMB 2

  ad_connect clk_100M ${iop_name}_lmb_bram_cntlr/LMB_Clk
  ad_connect ${iop_name}_rst/bus_struct_reset ${iop_name}_lmb_bram_cntlr/LMB_Rst
  ad_connect ${iop_name}_dlmb/LMB_Sl_0 ${iop_name}_lmb_bram_cntlr/SLMB1
  ad_connect ${iop_name}_ilmb/LMB_Sl_0 ${iop_name}_lmb_bram_cntlr/SLMB

  # -----------------------
  # LMB BRAM (shared instruction and data memory)
  # -----------------------
  ad_ip_instance blk_mem_gen ${iop_name}_lmb_bram
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Enable_B Use_ENB_Pin
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Memory_Type True_Dual_Port_RAM
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Port_B_Clock 100
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Port_B_Enable_Rate 100
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Port_B_Write_Rate 50
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.Use_RSTB_Pin true
  ad_ip_parameter ${iop_name}_lmb_bram CONFIG.use_bram_block BRAM_Controller

  ad_connect ${iop_name}_lmb_bram_cntlr/BRAM_PORT ${iop_name}_lmb_bram/BRAM_PORTA

  # -----------------------
  # AXI BRAM Controller for PS access to LMB BRAM Port B
  # -----------------------
  ad_ip_instance axi_bram_ctrl ${iop_name}_ps_bram_ctrl
  ad_ip_parameter ${iop_name}_ps_bram_ctrl CONFIG.SINGLE_PORT_BRAM 1

  ad_connect clk_100M ${iop_name}_ps_bram_ctrl/s_axi_aclk
  ad_connect s_axi_aresetn ${iop_name}_ps_bram_ctrl/s_axi_aresetn
  ad_connect S_AXI ${iop_name}_ps_bram_ctrl/S_AXI
  ad_connect ${iop_name}_ps_bram_ctrl/BRAM_PORTA ${iop_name}_lmb_bram/BRAM_PORTB

  # -----------------------
  # AXI Interconnect for MicroBlaze peripherals
  # -----------------------
  # 6 master interfaces: SPI, IIC, GPIO, INTC, INTR, M_AXI
  set num_mi 6

  ad_ip_instance axi_interconnect ${iop_name}_axi_periph
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.NUM_MI $num_mi
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M00_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M01_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M02_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M03_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M04_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.M05_HAS_REGSLICE 1
  ad_ip_parameter ${iop_name}_axi_periph CONFIG.S00_HAS_REGSLICE 1

  ad_connect clk_100M ${iop_name}_axi_periph/ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/S00_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M00_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M01_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M02_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M03_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M04_ACLK
  ad_connect clk_100M ${iop_name}_axi_periph/M05_ACLK
  ad_connect ${iop_name}_rst/interconnect_aresetn ${iop_name}_axi_periph/ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/S00_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M00_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M01_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M02_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M03_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M04_ARESETN
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_axi_periph/M05_ARESETN
  ad_connect ${iop_name}_mb/M_AXI_DP ${iop_name}_axi_periph/S00_AXI

  set mi_index 0

  # -----------------------
  # AXI Quad SPI
  # -----------------------
  ad_ip_instance axi_quad_spi ${iop_name}_spi
  ad_ip_parameter ${iop_name}_spi CONFIG.C_USE_STARTUP 0

  ad_connect clk_100M ${iop_name}_spi/s_axi_aclk
  ad_connect clk_100M ${iop_name}_spi/ext_spi_clk
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_spi/s_axi_aresetn
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI ${iop_name}_spi/AXI_LITE
  ad_connect ${iop_name}_spi/SPI_0 SPI_0
  incr mi_index

  # -----------------------
  # AXI IIC
  # -----------------------
  ad_ip_instance axi_iic ${iop_name}_iic

  ad_connect clk_100M ${iop_name}_iic/s_axi_aclk
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_iic/s_axi_aresetn
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI ${iop_name}_iic/S_AXI
  ad_connect ${iop_name}_iic/IIC IIC
  incr mi_index

  # -----------------------
  # AXI GPIO - Direct connection to data pins (2 bits: data_bd[7:6])
  # -----------------------
  ad_ip_instance axi_gpio ${iop_name}_gpio
  ad_ip_parameter ${iop_name}_gpio CONFIG.C_GPIO_WIDTH 2
  ad_ip_parameter ${iop_name}_gpio CONFIG.C_IS_DUAL 0
  ad_ip_parameter ${iop_name}_gpio CONFIG.C_ALL_OUTPUTS 0
  ad_ip_parameter ${iop_name}_gpio CONFIG.C_ALL_INPUTS 0

  ad_connect clk_100M ${iop_name}_gpio/s_axi_aclk
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_gpio/s_axi_aresetn
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI ${iop_name}_gpio/S_AXI

  # Connect GPIO directly to data pins
  ad_connect ${iop_name}_gpio/gpio_io_i data_i
  ad_connect ${iop_name}_gpio/gpio_io_o data_o
  ad_connect ${iop_name}_gpio/gpio_io_t tri_o
  incr mi_index

  # -----------------------
  # AXI Interrupt Controller
  # -----------------------
  ad_ip_instance axi_intc ${iop_name}_intc

  ad_connect clk_100M ${iop_name}_intc/s_axi_aclk
  ad_connect ${iop_name}_rst/peripheral_aresetn ${iop_name}_intc/s_axi_aresetn
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI ${iop_name}_intc/s_axi
  ad_connect ${iop_name}_intc/interrupt ${iop_name}_mb/INTERRUPT
  incr mi_index

  # -----------------------
  # Interrupt GPIO (for interrupt request output)
  # -----------------------
  ad_ip_instance axi_gpio ${iop_name}_intr
  ad_ip_parameter ${iop_name}_intr CONFIG.C_ALL_OUTPUTS 1
  ad_ip_parameter ${iop_name}_intr CONFIG.C_GPIO_WIDTH 1

  ad_connect clk_100M ${iop_name}_intr/s_axi_aclk
  ad_connect s_axi_aresetn ${iop_name}_intr/s_axi_aresetn
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI ${iop_name}_intr/S_AXI
  incr mi_index

  # -----------------------
  # M_AXI connection
  # -----------------------
  ad_connect ${iop_name}_axi_periph/M[format "%02d" $mi_index]_AXI M_AXI
  incr mi_index

  # -----------------------
  # Interrupt Concatenation
  # -----------------------
  ad_ip_instance xlconcat ${iop_name}_intr_concat
  ad_ip_parameter ${iop_name}_intr_concat CONFIG.NUM_PORTS 2

  ad_connect ${iop_name}_iic/iic2intc_irpt ${iop_name}_intr_concat/In0
  ad_connect ${iop_name}_spi/ip2intc_irpt ${iop_name}_intr_concat/In1
  ad_connect ${iop_name}_intr_concat/dout ${iop_name}_intc/intr

  # -----------------------
  # Logic 1 constant for reset
  # -----------------------
  ad_ip_instance xlconstant ${iop_name}_logic_1

  ad_connect ${iop_name}_logic_1/dout ${iop_name}_rst/ext_reset_in

  # Simple interrupt request - directly from interrupt GPIO
  ad_connect ${iop_name}_intr/gpio_io_o intr_req

  # -----------------------
  # Return to parent instance
  # -----------------------
  current_bd_instance $oldCurInst

  # Connect external clock and reset from PS
  ad_connect sys_cpu_clk ${iop_name}/clk_100M
  ad_connect sys_cpu_resetn ${iop_name}/s_axi_aresetn

  # -----------------------
  # CPU Interconnect for PS access
  # -----------------------
  ad_cpu_interconnect $base_addr ${iop_name}/${iop_name}_ps_bram_ctrl

  # Address assignment
  assign_bd_address
}
