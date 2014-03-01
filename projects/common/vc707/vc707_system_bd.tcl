
set sys_rst         [create_bd_port -dir I -type rst sys_rst]
set sys_clk_p       [create_bd_port -dir I sys_clk_p]
set sys_clk_n       [create_bd_port -dir I sys_clk_n]
set fan_pwm         [create_bd_port -dir O fan_pwm]

set ddr3            [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3]

set phy_rstn        [create_bd_port -dir O -type rst phy_rstn]
set mgt_clk         [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgt_clk]
set sgmii           [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii]
set mdio            [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio]

set gpio_sw         [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sw]
set gpio_led        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_led]
set gpio_lcd        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_lcd]
 
set iic_rstn        [create_bd_port -dir O iic_rstn]
set iic_main        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main]

set uart_sin        [create_bd_port -dir I uart_sin]
set uart_sout       [create_bd_port -dir O uart_sout]

set hdmi_out_clk    [create_bd_port -dir O hdmi_out_clk]
set hdmi_hsync      [create_bd_port -dir O hdmi_hsync]
set hdmi_vsync      [create_bd_port -dir O hdmi_vsync]
set hdmi_data_e     [create_bd_port -dir O hdmi_data_e]
set hdmi_data       [create_bd_port -dir O -from 35 -to 0 hdmi_data]

# spdif audio

set spdif           [create_bd_port -dir O spdif]

set_property -dict [list CONFIG.POLARITY {ACTIVE_HIGH}] $sys_rst

# instance: microblaze - processor

set microblaze_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.2 microblaze_1]
set_property -dict [list CONFIG.C_FAULT_TOLERANT {0}] $microblaze_1
set_property -dict [list CONFIG.C_D_AXI {1}] $microblaze_1
set_property -dict [list CONFIG.C_D_LMB {1}] $microblaze_1
set_property -dict [list CONFIG.C_I_LMB {1}] $microblaze_1
set_property -dict [list CONFIG.C_DEBUG_ENABLED {1}] $microblaze_1
set_property -dict [list CONFIG.C_USE_ICACHE {1}] $microblaze_1
set_property -dict [list CONFIG.C_ICACHE_LINE_LEN {8}] $microblaze_1
set_property -dict [list CONFIG.C_ICACHE_ALWAYS_USED {1}] $microblaze_1
set_property -dict [list CONFIG.C_ICACHE_FORCE_TAG_LUTRAM {1}] $microblaze_1
set_property -dict [list CONFIG.C_USE_DCACHE {1}] $microblaze_1
set_property -dict [list CONFIG.C_DCACHE_LINE_LEN {8}] $microblaze_1
set_property -dict [list CONFIG.C_DCACHE_ALWAYS_USED {1}] $microblaze_1
set_property -dict [list CONFIG.C_DCACHE_FORCE_TAG_LUTRAM {1}] $microblaze_1
set_property -dict [list CONFIG.C_ICACHE_HIGHADDR {0xBFFFFFFF}] $microblaze_1
set_property -dict [list CONFIG.C_ICACHE_BASEADDR {0x80000000}] $microblaze_1
set_property -dict [list CONFIG.C_DCACHE_HIGHADDR {0xBFFFFFFF}] $microblaze_1
set_property -dict [list CONFIG.C_DCACHE_BASEADDR {0x80000000}] $microblaze_1

# instance: microblaze - local memory & bus

set dlmb [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb]
set ilmb [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb]

set dlmb_cntlr [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_cntlr]
set_property -dict [list CONFIG.C_ECC {0}] $dlmb_cntlr

set ilmb_cntlr [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_cntlr]
set_property -dict [list CONFIG.C_ECC {0}] $ilmb_cntlr

set lmb_bram [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.1 lmb_bram]
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.use_bram_block {BRAM_Controller}] $lmb_bram

# instance: microblaze- mdm

set mb_debug [create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.0 mb_debug]
set_property -dict [list CONFIG.C_USE_UART {1}] $mb_debug

# instance: system reset/clocks

set proc_sys_reset_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1]

set proc_sys_clock_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 proc_sys_clock_1]
set_property -dict [list CONFIG.PRIM_IN_FREQ {100.000}] $proc_sys_clock_1
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100}] $proc_sys_clock_1
set_property -dict [list CONFIG.PRIM_SOURCE {No_buffer}] $proc_sys_clock_1
set_property -dict [list CONFIG.USE_RESET {false}] $proc_sys_clock_1
set_property -dict [list CONFIG.CLKOUT2_USED {true}] $proc_sys_clock_1
set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000}] $proc_sys_clock_1

set proc_const_vcc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 proc_const_vcc_1]

# instance: ddr (mig)

set axi_ddr_cntrl_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.0 axi_ddr_cntrl_1]
set axi_ddr_cntrl_1_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $axi_ddr_cntrl_1]]]
file copy -force ../../scripts/vc707_system_mig.prj "$axi_ddr_cntrl_1_dir/"
set_property -dict [list CONFIG.XML_INPUT_FILE {vc707_system_mig.prj}] $axi_ddr_cntrl_1
set_property -dict [list CONFIG.RESET_BOARD_INTERFACE {Custom}] $axi_ddr_cntrl_1

# instance: axi interconnect (lite)

set axi_interconnect_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1]
set_property -dict [list CONFIG.NUM_MI {14}] $axi_interconnect_1

# instance: axi interconnect

set axi_interconnect_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2]
set_property -dict [list CONFIG.NUM_SI {8}] $axi_interconnect_2
set_property -dict [list CONFIG.NUM_MI {1}] $axi_interconnect_2
set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] $axi_interconnect_2
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] $axi_interconnect_2

# instance: default peripherals

set axi_ethernet_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:6.0 axi_ethernet_1]
set_property -dict [list CONFIG.PHY_TYPE {SGMII}] $axi_ethernet_1

set axi_ethernet_dma_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_ethernet_dma_1]
set_property -dict [list CONFIG.c_include_mm2s_dre {1}] $axi_ethernet_dma_1
set_property -dict [list CONFIG.c_sg_use_stsapp_length {1}] $axi_ethernet_dma_1
set_property -dict [list CONFIG.c_include_s2mm_dre {1}] $axi_ethernet_dma_1

set axi_iic_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1]

set axi_uart_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uart_1]
set_property -dict [list CONFIG.C_BAUDRATE {115200}] $axi_uart_1

set axi_timer_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1]

set axi_gpio_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1]
set_property -dict [list CONFIG.C_GPIO_WIDTH {7}] $axi_gpio_1
set_property -dict [list CONFIG.C_ALL_OUTPUTS {1}] $axi_gpio_1
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio_1

set axi_gpio_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_2
set_property -dict [list CONFIG.C_GPIO_WIDTH {13}] $axi_gpio_2
set_property -dict [list CONFIG.C_GPIO2_WIDTH {8}] $axi_gpio_2
set_property -dict [list CONFIG.C_ALL_INPUTS {1}] $axi_gpio_2
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio_2
set_property -dict [list CONFIG.C_ALL_OUTPUTS_2 {1}] $axi_gpio_2

# instance: interrupt

set axi_intc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_1]
set_property -dict [list CONFIG.C_HAS_FAST {0}] $axi_intc_1

set concat_intc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 concat_intc_1]
set_property -dict [list CONFIG.NUM_PORTS {10}] $concat_intc_1

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.1 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

# audio peripherals

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {0}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_HIGHADDR {0xffffffff}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_BASEADDR {0x00000000}] $axi_spdif_tx_core

set axi_spdif_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_spdif_tx_dma]
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_spdif_tx_dma
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] $axi_spdif_tx_dma

# connections

connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug/Debug_SYS_Rst]
connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins proc_sys_reset_1/mb_debug_sys_rst]

connect_bd_net -net proc_sys_reset_1_mb_reset [get_bd_pins proc_sys_reset_1/mb_reset] 
connect_bd_net -net proc_sys_reset_1_mb_reset [get_bd_pins microblaze_1/Reset] 

connect_bd_net -net proc_sys_reset_1_bus_struct_reset [get_bd_pins proc_sys_reset_1/bus_struct_reset] 
connect_bd_net -net proc_sys_reset_1_bus_struct_reset [get_bd_pins dlmb/SYS_Rst] 
connect_bd_net -net proc_sys_reset_1_bus_struct_reset [get_bd_pins ilmb/SYS_Rst] 
connect_bd_net -net proc_sys_reset_1_bus_struct_reset [get_bd_pins dlmb_cntlr/LMB_Rst] 
connect_bd_net -net proc_sys_reset_1_bus_struct_reset [get_bd_pins ilmb_cntlr/LMB_Rst] 

# microblaze local memory

connect_bd_intf_net -intf_net lmb_cntlr_1_dlmb [get_bd_intf_pins dlmb/LMB_Sl_0] [get_bd_intf_pins dlmb_cntlr/SLMB]
connect_bd_intf_net -intf_net lmb_cntlr_1_ilmb [get_bd_intf_pins ilmb/LMB_Sl_0] [get_bd_intf_pins ilmb_cntlr/SLMB]
connect_bd_intf_net -intf_net lmb_cntlr_1_dlmb_bram [get_bd_intf_pins dlmb_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
connect_bd_intf_net -intf_net lmb_cntlr_1_ilmb_bram [get_bd_intf_pins ilmb_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
connect_bd_intf_net -intf_net microblaze_1_dlmb [get_bd_intf_pins microblaze_1/DLMB] [get_bd_intf_pins dlmb/LMB_M]
connect_bd_intf_net -intf_net microblaze_1_ilmb [get_bd_intf_pins microblaze_1/ILMB] [get_bd_intf_pins ilmb/LMB_M]

# microblaze debug & interrupt

connect_bd_intf_net -intf_net microblaze_1_debug [get_bd_intf_pins mb_debug/MBDEBUG_0] [get_bd_intf_pins microblaze_1/DEBUG]
connect_bd_net -net concat_intc_1_intr [get_bd_pins concat_intc_1/dout] [get_bd_pins axi_intc_1/intr]
connect_bd_intf_net -intf_net microblaze_1_interrupt [get_bd_intf_pins axi_intc_1/interrupt] [get_bd_intf_pins microblaze_1/INTERRUPT]

# defaults (peripherals)

connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]

connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins mb_debug/S_AXI_ARESETN] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_ddr_cntrl_1/aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_ethernet_1/s_axi_lite_resetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_uart_1/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_timer_1/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_intc_1/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_gpio_1/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_gpio_2/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_iic_1/s_axi_aresetn] 
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_ethernet_dma_1/axi_resetn] 

connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins proc_sys_clock_1/clk_out1] [get_bd_pins axi_interconnect_1/ACLK] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins proc_sys_reset_1/slowest_sync_clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins microblaze_1/Clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins mb_debug/S_AXI_ACLK] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins dlmb/LMB_Clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins ilmb/LMB_Clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins dlmb_cntlr/LMB_Clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins ilmb_cntlr/LMB_Clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_1/s_axi_lite_clk] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_uart_1/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_timer_1/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_intc_1/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_gpio_1/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_gpio_2/s_axi_aclk]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_iic_1/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_1/axis_clk] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_dma_1/m_axi_sg_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_dma_1/m_axi_mm2s_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_dma_1/m_axi_s2mm_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_ethernet_dma_1/s_axi_lite_aclk] 

connect_bd_net -net proc_sys_clk_1_200mhz [get_bd_pins proc_sys_clock_1/clk_out2] [get_bd_pins axi_interconnect_2/ACLK] 

connect_bd_net -net axi_ddr_cntrl_1_100mhz [get_bd_pins axi_ddr_cntrl_1/ui_clk] 
connect_bd_net -net axi_ddr_cntrl_1_100mhz [get_bd_pins proc_sys_clock_1/clk_in1] 
connect_bd_net -net axi_ddr_cntrl_1_100mhz [get_bd_pins axi_ethernet_1/ref_clk] [get_bd_pins axi_ddr_cntrl_1/ui_clk] 


# defaults (interconnect - processor)

connect_bd_intf_net -intf_net axi_interconnect_1_s00 [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins microblaze_1/M_AXI_DP]
connect_bd_intf_net -intf_net axi_interconnect_1_m00 [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins mb_debug/S_AXI]
connect_bd_intf_net -intf_net axi_interconnect_1_m01 [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins axi_ethernet_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m02 [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_uart_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m03 [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_timer_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m04 [get_bd_intf_pins axi_interconnect_1/M04_AXI] [get_bd_intf_pins axi_intc_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m05 [get_bd_intf_pins axi_interconnect_1/M05_AXI] [get_bd_intf_pins axi_gpio_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m06 [get_bd_intf_pins axi_interconnect_1/M06_AXI] [get_bd_intf_pins axi_gpio_2/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m07 [get_bd_intf_pins axi_interconnect_1/M07_AXI] [get_bd_intf_pins axi_iic_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m13 [get_bd_intf_pins axi_interconnect_1/M13_AXI] [get_bd_intf_pins axi_ethernet_dma_1/S_AXI_LITE]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M04_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M05_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M06_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M07_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M13_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M04_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M05_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M06_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M07_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M13_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 

# defaults (interconnect - memory)

connect_bd_intf_net -intf_net axi_interconnect_2_m00 [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins axi_ddr_cntrl_1/S_AXI]
connect_bd_intf_net -intf_net axi_interconnect_2_s00 [get_bd_intf_pins axi_interconnect_2/S00_AXI] [get_bd_intf_pins microblaze_1/M_AXI_DC]
connect_bd_intf_net -intf_net axi_interconnect_2_s01 [get_bd_intf_pins axi_interconnect_2/S01_AXI] [get_bd_intf_pins microblaze_1/M_AXI_IC]
connect_bd_intf_net -intf_net axi_interconnect_2_s05 [get_bd_intf_pins axi_interconnect_2/S05_AXI] [get_bd_intf_pins axi_ethernet_dma_1/M_AXI_SG]
connect_bd_intf_net -intf_net axi_interconnect_2_s06 [get_bd_intf_pins axi_interconnect_2/S06_AXI] [get_bd_intf_pins axi_ethernet_dma_1/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_interconnect_2_s07 [get_bd_intf_pins axi_interconnect_2/S07_AXI] [get_bd_intf_pins axi_ethernet_dma_1/M_AXI_S2MM]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S05_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S06_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S07_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net axi_ddr_cntrl_1_100mhz [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_ddr_cntrl_1/ui_clk]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S05_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S06_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S07_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 

# ethernet & ethernet dma

connect_bd_net -net axi_ethernet_dma_1_txd_rstn [get_bd_pins axi_ethernet_1/axi_txd_arstn] [get_bd_pins axi_ethernet_dma_1/mm2s_prmry_reset_out_n]
connect_bd_net -net axi_ethernet_dma_1_txc_rstn [get_bd_pins axi_ethernet_1/axi_txc_arstn] [get_bd_pins axi_ethernet_dma_1/mm2s_cntrl_reset_out_n]
connect_bd_net -net axi_ethernet_dma_1_rxd_rstn [get_bd_pins axi_ethernet_1/axi_rxd_arstn] [get_bd_pins axi_ethernet_dma_1/s2mm_prmry_reset_out_n]
connect_bd_net -net axi_ethernet_dma_1_rxs_rstn [get_bd_pins axi_ethernet_1/axi_rxs_arstn] [get_bd_pins axi_ethernet_dma_1/s2mm_sts_reset_out_n]

connect_bd_intf_net -intf_net axi_ethernet_dma_1_txd [get_bd_intf_pins axi_ethernet_1/s_axis_txd] [get_bd_intf_pins axi_ethernet_dma_1/M_AXIS_MM2S]
connect_bd_intf_net -intf_net axi_ethernet_dma_1_txc [get_bd_intf_pins axi_ethernet_1/s_axis_txc] [get_bd_intf_pins axi_ethernet_dma_1/M_AXIS_CNTRL]
connect_bd_intf_net -intf_net axi_ethernet_dma_1_rxd [get_bd_intf_pins axi_ethernet_1/m_axis_rxd] [get_bd_intf_pins axi_ethernet_dma_1/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axi_ethernet_dma_1_rxs [get_bd_intf_pins axi_ethernet_1/m_axis_rxs] [get_bd_intf_pins axi_ethernet_dma_1/S_AXIS_STS]

# defaults (interrupts)

connect_bd_net -net concat_intc_1_intr_00 [get_bd_pins concat_intc_1/In0] [get_bd_pins axi_timer_1/interrupt]
connect_bd_net -net concat_intc_1_intr_01 [get_bd_pins concat_intc_1/In1] [get_bd_pins axi_ethernet_1/interrupt]
connect_bd_net -net concat_intc_1_intr_02 [get_bd_pins concat_intc_1/In2] [get_bd_pins axi_uart_1/interrupt]
connect_bd_net -net concat_intc_1_intr_03 [get_bd_pins concat_intc_1/In3] [get_bd_pins axi_gpio_1/ip2intc_irpt]
connect_bd_net -net concat_intc_1_intr_04 [get_bd_pins concat_intc_1/In4] [get_bd_pins axi_gpio_2/ip2intc_irpt]
connect_bd_net -net concat_intc_1_intr_05 [get_bd_pins concat_intc_1/In5] [get_bd_pins axi_iic_1/iic2intc_irpt]
connect_bd_net -net concat_intc_1_intr_08 [get_bd_pins concat_intc_1/In8] [get_bd_pins axi_ethernet_dma_1/mm2s_introut]
connect_bd_net -net concat_intc_1_intr_09 [get_bd_pins concat_intc_1/In9] [get_bd_pins axi_ethernet_dma_1/s2mm_introut]

# defaults (external interface)

connect_bd_net -net proc_const_vcc_1_vcc [get_bd_pins proc_const_vcc_1/const] [get_bd_ports fan_pwm] [get_bd_pins axi_ethernet_1/signal_detect]
connect_bd_net -net sys_rst_s [get_bd_ports sys_rst] 
connect_bd_net -net sys_rst_s [get_bd_pins proc_sys_reset_1/ext_reset_in]
connect_bd_net -net sys_rst_s [get_bd_pins axi_ddr_cntrl_1/sys_rst]

connect_bd_net -net sys_clk_p_s [get_bd_ports sys_clk_p] [get_bd_pins axi_ddr_cntrl_1/sys_clk_p]
connect_bd_net -net sys_clk_n_s [get_bd_ports sys_clk_n] [get_bd_pins axi_ddr_cntrl_1/sys_clk_n]

connect_bd_intf_net -intf_net axi_ddr_cntrl_1_ddr3 [get_bd_intf_ports ddr3] [get_bd_intf_pins axi_ddr_cntrl_1/DDR3]
connect_bd_net -net axi_ethernet_1_phy_rstn [get_bd_ports phy_rstn] [get_bd_pins axi_ethernet_1/phy_rst_n]
connect_bd_intf_net -intf_net axi_ethernet_1_mgt_clk [get_bd_intf_ports mgt_clk] [get_bd_intf_pins axi_ethernet_1/mgt_clk]
connect_bd_intf_net -intf_net axi_ethernet_1_sgmii [get_bd_intf_ports sgmii] [get_bd_intf_pins axi_ethernet_1/sgmii]
connect_bd_intf_net -intf_net axi_ethernet_1_mdio [get_bd_intf_ports mdio] [get_bd_intf_pins axi_ethernet_1/mdio]

connect_bd_net -net axi_uart_1_sin [get_bd_ports uart_sin] [get_bd_pins axi_uart_1/rx]
connect_bd_net -net axi_uart_1_sout [get_bd_ports uart_sout] [get_bd_pins axi_uart_1/tx]

connect_bd_intf_net -intf_net axi_gpio_1_gpio [get_bd_intf_ports gpio_lcd] [get_bd_intf_pins axi_gpio_1/gpio]
connect_bd_intf_net -intf_net axi_gpio_2_gpio [get_bd_intf_ports gpio_sw] [get_bd_intf_pins axi_gpio_2/gpio]
connect_bd_intf_net -intf_net axi_gpio_2_gpio2 [get_bd_intf_ports gpio_led] [get_bd_intf_pins axi_gpio_2/gpio2]

connect_bd_net -net axi_iic_1_rstn [get_bd_ports iic_rstn] [get_bd_pins axi_iic_1/gpo]
connect_bd_intf_net -intf_net axi_iic_1_iic [get_bd_intf_ports iic_main] [get_bd_intf_pins axi_iic_1/iic]

# hdmi peripherals

connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_hdmi_clkgen/s_axi_aresetn]
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_hdmi_dma/axi_resetn]
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_hdmi_core/s_axi_aresetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_clkgen/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_clkgen/drp_clk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_core/s_axi_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_hdmi_core/m_axis_mm2s_clk] 
connect_bd_net -net proc_sys_clk_1_200mhz [get_bd_pins axi_hdmi_clkgen/clk] 

connect_bd_intf_net -intf_net axi_interconnect_1_m08 [get_bd_intf_pins axi_interconnect_1/M08_AXI] [get_bd_intf_pins axi_hdmi_clkgen/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m09 [get_bd_intf_pins axi_interconnect_1/M09_AXI] [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m10 [get_bd_intf_pins axi_interconnect_1/M10_AXI] [get_bd_intf_pins axi_hdmi_core/s_axi]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M08_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M09_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M10_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M08_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M09_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M10_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 

connect_bd_intf_net -intf_net axi_interconnect_2_s02 [get_bd_intf_pins axi_interconnect_2/S02_AXI] [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S02_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S02_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 

connect_bd_net -net concat_intc_1_intr_06 [get_bd_pins concat_intc_1/In6] [get_bd_pins axi_hdmi_dma/mm2s_introut]

connect_bd_net -net axi_hdmi_core_hdmi_out_clk  [get_bd_ports hdmi_out_clk] [get_bd_pins axi_hdmi_core/hdmi_out_clk]
connect_bd_net -net axi_hdmi_core_hdmi_hsync    [get_bd_ports hdmi_hsync]   [get_bd_pins axi_hdmi_core/hdmi_36_hsync]
connect_bd_net -net axi_hdmi_core_hdmi_vsync    [get_bd_ports hdmi_vsync]   [get_bd_pins axi_hdmi_core/hdmi_36_vsync]
connect_bd_net -net axi_hdmi_core_hdmi_data_e   [get_bd_ports hdmi_data_e]  [get_bd_pins axi_hdmi_core/hdmi_36_data_e]
connect_bd_net -net axi_hdmi_core_hdmi_data     [get_bd_ports hdmi_data]    [get_bd_pins axi_hdmi_core/hdmi_36_data]

connect_bd_net -net axi_hdmi_clkgen_clk [get_bd_pins axi_hdmi_clkgen/clk_0]           [get_bd_pins axi_hdmi_core/hdmi_clk]
connect_bd_net -net axi_hdmi_core_valid [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tvalid] [get_bd_pins axi_hdmi_core/m_axis_mm2s_tvalid]
connect_bd_net -net axi_hdmi_core_data  [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tdata]  [get_bd_pins axi_hdmi_core/m_axis_mm2s_tdata]
connect_bd_net -net axi_hdmi_core_keep  [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tkeep]  [get_bd_pins axi_hdmi_core/m_axis_mm2s_tkeep]
connect_bd_net -net axi_hdmi_core_last  [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tlast]  [get_bd_pins axi_hdmi_core/m_axis_mm2s_tlast]
connect_bd_net -net axi_hdmi_core_ready [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tready] [get_bd_pins axi_hdmi_core/m_axis_mm2s_tready]
connect_bd_net -net axi_hdmi_core_fsync [get_bd_pins axi_hdmi_dma/mm2s_fsync]         [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync]
connect_bd_net -net axi_hdmi_core_fsync [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync_ret]

# spdif audio

connect_bd_intf_net -intf_net axi_interconnect_1_m11 [get_bd_intf_pins axi_interconnect_1/M11_AXI] [get_bd_intf_pins axi_spdif_tx_core/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m12 [get_bd_intf_pins axi_interconnect_1/M12_AXI] [get_bd_intf_pins axi_spdif_tx_dma/S_AXI_LITE]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M11_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_1/M12_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_spdif_tx_core/S_AXI_ARESETN]
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_spdif_tx_core/S_AXIS_ARESETN]
connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_spdif_tx_dma/axi_resetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M11_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_1/M12_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_spdif_tx_core/S_AXI_ACLK]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_spdif_tx_dma/s_axi_lite_aclk] 

connect_bd_intf_net -intf_net axi_interconnect_2_s03 [get_bd_intf_pins axi_interconnect_2/S03_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_SG]
connect_bd_intf_net -intf_net axi_interconnect_2_s04 [get_bd_intf_pins axi_interconnect_2/S04_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_MM2S]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S03_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_2/S04_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S03_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_interconnect_2/S04_ACLK] [get_bd_pins proc_sys_clock_1/clk_out1] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_spdif_tx_core/S_AXIS_ACLK]
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_spdif_tx_dma/m_axi_mm2s_aclk] 
connect_bd_net -net proc_sys_clk_1_100mhz [get_bd_pins axi_spdif_tx_dma/m_axi_sg_aclk] 

connect_bd_net -net axi_spdif_tx_dma_mm2s_valid [get_bd_pins axi_spdif_tx_core/S_AXIS_TVALID] [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tvalid]
connect_bd_net -net axi_spdif_tx_dma_mm2s_data  [get_bd_pins axi_spdif_tx_core/S_AXIS_TDATA]  [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tdata]
connect_bd_net -net axi_spdif_tx_dma_mm2s_last  [get_bd_pins axi_spdif_tx_core/S_AXIS_TLAST]  [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tlast]
connect_bd_net -net axi_spdif_tx_dma_mm2s_ready [get_bd_pins axi_spdif_tx_core/S_AXIS_TREADY] [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tready]

connect_bd_net -net concat_intc_1_intr_07 [get_bd_pins concat_intc_1/In7] [get_bd_pins axi_spdif_tx_dma/mm2s_introut]
 
connect_bd_net -net proc_sys_clk_1_200mhz [get_bd_pins sys_audio_clkgen/clk_in1]
connect_bd_net -net sys_audio_clkgen_clk [get_bd_pins sys_audio_clkgen/clk_out1] [get_bd_pins axi_spdif_tx_core/spdif_data_clk]
connect_bd_net -net spdif_s [get_bd_ports spdif] [get_bd_pins axi_spdif_tx_core/spdif_tx_o]

# address mapping

create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs dlmb_cntlr/SLMB/Mem]              SEG_data_dlmb_cntlr
create_bd_addr_seg -range 0x00001000 -offset 0x41400000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs mb_debug/S_AXI/Reg]               SEG_data_mb_debug
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr]   SEG_data_ddr_cntrl_1
create_bd_addr_seg -range 0x00040000 -offset 0x40E00000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_ethernet_1/eth_buf/S_AXI/REG] SEG_data_ethernetlite_1
create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_gpio_1/s_axi/Reg]             SEG_data_gpio_1
create_bd_addr_seg -range 0x00010000 -offset 0x40020000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_gpio_2/s_axi/Reg]             SEG_data_gpio_2
create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_iic_1/s_axi/Reg]              SEG_data_iic_1
create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_intc_1/s_axi/Reg]             SEG_data_intc_1
create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_timer_1/s_axi/Reg]            SEG_data_timer_1
create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_uart_1/s_axi/Reg]             SEG_data_uart_1
create_bd_addr_seg -range 0x00010000 -offset 0x41E10000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_ethernet_dma_1/S_AXI_LITE/Reg] SEG_data_ethernet_dma_1

create_bd_addr_seg -range 0x00010000 -offset 0x79000000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_hdmi_clkgen/s_axi/axi_lite]   SEG_data_hdmi_clkgen
create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg]      SEG_data_hdmi_dma
create_bd_addr_seg -range 0x00010000 -offset 0x70e00000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_hdmi_core/s_axi/axi_lite]     SEG_data_hdmi_core

create_bd_addr_seg -range 0x00010000 -offset 0x75c00000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_spdif_tx_core/S_AXI/reg0]     SEG_data_spdif_tx_core
create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 [get_bd_addr_spaces microblaze_1/Data]          [get_bd_addr_segs axi_spdif_tx_dma/S_AXI_LITE/Reg]  SEG_data_spdif_tx_dma

create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces microblaze_1/Instruction]   [get_bd_addr_segs ilmb_cntlr/SLMB/Mem]              SEG_instr_ilmb_cntlr
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_1/Instruction]   [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr]   SEG_instr_ddr_cntrl_1

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr]   SEG_mem_ddr_cntrl_1
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_SG]   [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr]   SEG_axi_ddr_cntrl_1
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_MM2S] [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr]   SEG_axi_ddr_cntrl_1

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma_1/Data_SG]   [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr] SEG_axi_ddr_cntrl_1
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma_1/Data_MM2S] [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr] SEG_axi_ddr_cntrl_1
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma_1/Data_S2MM] [get_bd_addr_segs axi_ddr_cntrl_1/memmap/memaddr] SEG_axi_ddr_cntrl_1

