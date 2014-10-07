
# create board design
# interface ports

set sys_rst         [create_bd_port -dir I -type rst sys_rst]
set sys_clk_p       [create_bd_port -dir I sys_clk_p]
set sys_clk_n       [create_bd_port -dir I sys_clk_n]
set fan_pwm         [create_bd_port -dir O fan_pwm]

set ddr3_1_p        [create_bd_port -dir O -from 1 -to 0 ddr3_1_p]
set ddr3_1_n        [create_bd_port -dir O -from 2 -to 0 ddr3_1_n]
set ddr3            [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3]

set mdio            [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio]
set mii             [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 mii]

set gpio_sw         [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sw]
set gpio_led        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_led]
set gpio_lcd        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_lcd]

set iic_rstn        [create_bd_port -dir O iic_rstn]
set iic_main        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main]

set uart_sin        [create_bd_port -dir I uart_sin]
set uart_sout       [create_bd_port -dir O uart_sout]

set unc_int0        [create_bd_port -dir I unc_int0]
set unc_int1        [create_bd_port -dir I unc_int1]
set unc_int2        [create_bd_port -dir I unc_int2]
set unc_int3        [create_bd_port -dir I unc_int3]
set unc_int4        [create_bd_port -dir I unc_int4]

set hdmi_out_clk    [create_bd_port -dir O hdmi_out_clk]
set hdmi_hsync      [create_bd_port -dir O hdmi_hsync]
set hdmi_vsync      [create_bd_port -dir O hdmi_vsync]
set hdmi_data_e     [create_bd_port -dir O hdmi_data_e]
set hdmi_data       [create_bd_port -dir O -from 15 -to 0 hdmi_data]

# spdif audio

set spdif           [create_bd_port -dir O spdif]

set_property -dict [list CONFIG.POLARITY {ACTIVE_HIGH}] $sys_rst

# instance: microblaze - processor

set sys_mb [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.2 sys_mb]
set_property -dict [list CONFIG.C_FAULT_TOLERANT {0}] $sys_mb
set_property -dict [list CONFIG.C_D_AXI {1}] $sys_mb
set_property -dict [list CONFIG.C_D_LMB {1}] $sys_mb
set_property -dict [list CONFIG.C_I_LMB {1}] $sys_mb
set_property -dict [list CONFIG.C_DEBUG_ENABLED {1}] $sys_mb
set_property -dict [list CONFIG.C_USE_ICACHE {1}] $sys_mb
set_property -dict [list CONFIG.C_ICACHE_LINE_LEN {8}] $sys_mb
set_property -dict [list CONFIG.C_ICACHE_ALWAYS_USED {1}] $sys_mb
set_property -dict [list CONFIG.C_ICACHE_FORCE_TAG_LUTRAM {1}] $sys_mb
set_property -dict [list CONFIG.C_USE_DCACHE {1}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_LINE_LEN {4}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_ALWAYS_USED {1}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_FORCE_TAG_LUTRAM {1}] $sys_mb
set_property -dict [list CONFIG.C_ICACHE_HIGHADDR {0xBFFFFFFF}] $sys_mb
set_property -dict [list CONFIG.C_ICACHE_BASEADDR {0x80000000}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_HIGHADDR {0xBFFFFFFF}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_BASEADDR {0x80000000}] $sys_mb
set_property -dict [list CONFIG.G_TEMPLATE_LIST {4}] $sys_mb

# instance: microblaze - local memory & bus

set sys_dlmb [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 sys_dlmb]
set sys_ilmb [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 sys_ilmb]

set sys_dlmb_cntlr [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 sys_dlmb_cntlr]
set_property -dict [list CONFIG.C_ECC {0}] $sys_dlmb_cntlr

set sys_ilmb_cntlr [create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 sys_ilmb_cntlr]
set_property -dict [list CONFIG.C_ECC {0}] $sys_ilmb_cntlr

set sys_lmb_bram [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.1 sys_lmb_bram]
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.use_bram_block {BRAM_Controller}] $sys_lmb_bram

# instance: microblaze- mdm

set sys_mb_debug [create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.0 sys_mb_debug]
set_property -dict [list CONFIG.C_USE_UART {1}] $sys_mb_debug

# instance: system reset/clocks

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]

set sys_const_vcc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 sys_const_vcc]

# instance: ddr (mig)

set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.0 axi_ddr_cntrl]
set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $axi_ddr_cntrl]]]
file copy -force $ad_hdl_dir/projects/common/kc705/kc705_system_mig.prj "$axi_ddr_cntrl_dir/"
set_property -dict [list CONFIG.XML_INPUT_FILE {kc705_system_mig.prj}] $axi_ddr_cntrl

set sys_const_ddr3_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 sys_const_ddr3_0]
set_property -dict [list CONFIG.CONST_WIDTH {3}] $sys_const_ddr3_0
set_property -dict [list CONFIG.CONST_VAL {0}] $sys_const_ddr3_0

set sys_const_ddr3_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 sys_const_ddr3_1]
set_property -dict [list CONFIG.CONST_WIDTH {2}] $sys_const_ddr3_1
set_property -dict [list CONFIG.CONST_VAL {1}] $sys_const_ddr3_1

# instance: axi interconnect (lite)

set axi_cpu_aux_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_aux_interconnect]
set_property -dict [list CONFIG.NUM_MI {8}] $axi_cpu_aux_interconnect
set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_aux_interconnect

set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect]
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_interconnect

# instance: axi interconnect

set axi_mem_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_interconnect]
set_property -dict [list CONFIG.NUM_SI {8}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] $axi_mem_interconnect
set_property -dict [list CONFIG.STRATEGY {2}] $axi_mem_interconnect

# instance: default peripherals

set axi_ethernet [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:2.0 axi_ethernet]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_ethernet
set_property -dict [list CONFIG.MII_BOARD_INTERFACE {mii}] $axi_ethernet
set_property -dict [list CONFIG.MDIO_BOARD_INTERFACE {mdio_mdc}] $axi_ethernet

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]

set axi_uart [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uart]
set_property -dict [list CONFIG.C_BAUDRATE {115200}] $axi_uart

set axi_timer [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer]

set axi_gpio_lcd [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_lcd]
set_property -dict [list CONFIG.C_GPIO_WIDTH {7}] $axi_gpio_lcd
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio_lcd

set axi_gpio_sw_led [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_sw_led]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_sw_led
set_property -dict [list CONFIG.C_GPIO_WIDTH {9}] $axi_gpio_sw_led
set_property -dict [list CONFIG.C_GPIO2_WIDTH {8}] $axi_gpio_sw_led
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $axi_gpio_sw_led

# instance: interrupt

set axi_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc]
set_property -dict [list CONFIG.C_HAS_FAST {0}] $axi_intc

set sys_concat_aux_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 sys_concat_aux_intc]
set_property -dict [list CONFIG.NUM_PORTS {9}] $sys_concat_aux_intc
set_property -dict [list CONFIG.IN9_WIDTH {5}] $sys_concat_aux_intc

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {5}] $sys_concat_intc

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
set_property -dict [list CONFIG.USE_LOCKED {false}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {0}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core

set axi_spdif_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_spdif_tx_dma]
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_spdif_tx_dma
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] $axi_spdif_tx_dma

# connections

connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins sys_mb_debug/Debug_SYS_Rst]
connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins sys_rstgen/mb_debug_sys_rst]

connect_bd_net -net sys_rstgen_mb_reset [get_bd_pins sys_rstgen/mb_reset]
connect_bd_net -net sys_rstgen_mb_reset [get_bd_pins sys_mb/Reset]

connect_bd_net -net sys_rstgen_bus_struct_reset [get_bd_pins sys_rstgen/bus_struct_reset]
connect_bd_net -net sys_rstgen_bus_struct_reset [get_bd_pins sys_dlmb/SYS_Rst]
connect_bd_net -net sys_rstgen_bus_struct_reset [get_bd_pins sys_ilmb/SYS_Rst]
connect_bd_net -net sys_rstgen_bus_struct_reset [get_bd_pins sys_dlmb_cntlr/LMB_Rst]
connect_bd_net -net sys_rstgen_bus_struct_reset [get_bd_pins sys_ilmb_cntlr/LMB_Rst]

# microblaze local memory

connect_bd_intf_net -intf_net lmb_cntlr_1_dlmb [get_bd_intf_pins sys_dlmb/LMB_Sl_0] [get_bd_intf_pins sys_dlmb_cntlr/SLMB]
connect_bd_intf_net -intf_net lmb_cntlr_1_ilmb [get_bd_intf_pins sys_ilmb/LMB_Sl_0] [get_bd_intf_pins sys_ilmb_cntlr/SLMB]
connect_bd_intf_net -intf_net lmb_cntlr_1_dlmb_bram [get_bd_intf_pins sys_dlmb_cntlr/BRAM_PORT] [get_bd_intf_pins sys_lmb_bram/BRAM_PORTA]
connect_bd_intf_net -intf_net lmb_cntlr_1_ilmb_bram [get_bd_intf_pins sys_ilmb_cntlr/BRAM_PORT] [get_bd_intf_pins sys_lmb_bram/BRAM_PORTB]
connect_bd_intf_net -intf_net sys_mb_dlmb [get_bd_intf_pins sys_mb/DLMB] [get_bd_intf_pins sys_dlmb/LMB_M]
connect_bd_intf_net -intf_net sys_mb_ilmb [get_bd_intf_pins sys_mb/ILMB] [get_bd_intf_pins sys_ilmb/LMB_M]

# microblaze debug & interrupt

connect_bd_intf_net -intf_net sys_mb_debug_intf [get_bd_intf_pins sys_mb_debug/MBDEBUG_0] [get_bd_intf_pins sys_mb/DEBUG]
connect_bd_intf_net -intf_net sys_mb_interrupt [get_bd_intf_pins axi_intc/interrupt] [get_bd_intf_pins sys_mb/INTERRUPT]
connect_bd_net -net sys_concat_aux_intc_intr [get_bd_pins sys_concat_aux_intc/dout] [get_bd_pins axi_intc/intr]
connect_bd_net -net sys_concat_intc_intr [get_bd_pins sys_concat_intc/dout] [get_bd_pins sys_concat_aux_intc/In8]

# defaults (peripherals)

connect_bd_net -net axi_ddr_cntrl_mmcm_locked [get_bd_pins axi_ddr_cntrl/mmcm_locked] [get_bd_pins sys_rstgen/dcm_locked]

set sys_100m_resetn_source [get_bd_pins sys_rstgen/peripheral_aresetn]
set sys_200m_resetn_source [get_bd_pins sys_rstgen/interconnect_aresetn]
set sys_100m_clk_source [get_bd_pins axi_ddr_cntrl/ui_addn_clk_0]
set sys_200m_clk_source [get_bd_pins axi_ddr_cntrl/ui_clk]

connect_bd_net -net sys_100m_resetn $sys_100m_resetn_source
connect_bd_net -net sys_200m_resetn $sys_200m_resetn_source
connect_bd_net -net sys_100m_clk $sys_100m_clk_source
connect_bd_net -net sys_200m_clk $sys_200m_clk_source

connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M06_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/ARESETN] $sys_200m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M06_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/ACLK] $sys_200m_clk_source

connect_bd_net -net sys_100m_resetn [get_bd_pins sys_mb_debug/S_AXI_ARESETN]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ddr_cntrl/aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ethernet/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_uart/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_timer/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_intc/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_gpio_lcd/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_gpio_sw_led/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_iic_main/s_axi_aresetn]

connect_bd_net -net sys_100m_clk [get_bd_pins sys_rstgen/slowest_sync_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_mb/Clk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_mb_debug/S_AXI_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_dlmb/LMB_Clk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ilmb/LMB_Clk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_dlmb_cntlr/LMB_Clk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ilmb_cntlr/LMB_Clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ethernet/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_uart/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_timer/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_intc/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_gpio_lcd/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_gpio_sw_led/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_iic_main/s_axi_aclk]

# defaults (interconnect - processor)

connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_s00 [get_bd_intf_pins axi_cpu_aux_interconnect/S00_AXI] [get_bd_intf_pins axi_cpu_interconnect/M06_AXI]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m00 [get_bd_intf_pins axi_cpu_aux_interconnect/M00_AXI] [get_bd_intf_pins sys_mb_debug/S_AXI]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m01 [get_bd_intf_pins axi_cpu_aux_interconnect/M01_AXI] [get_bd_intf_pins axi_ethernet/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m03 [get_bd_intf_pins axi_cpu_aux_interconnect/M03_AXI] [get_bd_intf_pins axi_uart/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m04 [get_bd_intf_pins axi_cpu_aux_interconnect/M04_AXI] [get_bd_intf_pins axi_timer/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m05 [get_bd_intf_pins axi_cpu_aux_interconnect/M05_AXI] [get_bd_intf_pins axi_intc/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m06 [get_bd_intf_pins axi_cpu_aux_interconnect/M06_AXI] [get_bd_intf_pins axi_gpio_lcd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m07 [get_bd_intf_pins axi_cpu_aux_interconnect/M07_AXI] [get_bd_intf_pins axi_gpio_sw_led/s_axi]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M01_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M02_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M03_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M04_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M05_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M06_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_aux_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M01_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M02_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M03_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M04_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M05_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M06_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_aux_interconnect/M07_ACLK] $sys_100m_clk_source

connect_bd_intf_net -intf_net axi_cpu_interconnect_s00 [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_mb/M_AXI_DP]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m00 [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_iic_main/s_axi]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M00_ACLK] $sys_100m_clk_source

# defaults (interconnect - memory)

connect_bd_intf_net -intf_net axi_mem_interconnect_m00 [get_bd_intf_pins axi_mem_interconnect/M00_AXI] [get_bd_intf_pins axi_ddr_cntrl/S_AXI]
connect_bd_intf_net -intf_net axi_mem_interconnect_s00 [get_bd_intf_pins axi_mem_interconnect/S00_AXI] [get_bd_intf_pins sys_mb/M_AXI_DC]
connect_bd_intf_net -intf_net axi_mem_interconnect_s01 [get_bd_intf_pins axi_mem_interconnect/S01_AXI] [get_bd_intf_pins sys_mb/M_AXI_IC]
connect_bd_net -net sys_200m_resetn [get_bd_pins axi_mem_interconnect/M00_ARESETN] $sys_200m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S01_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S05_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S06_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/M00_ACLK] $sys_200m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S01_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S05_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S06_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S07_ACLK] $sys_100m_clk_source

# defaults (interrupts)

connect_bd_net -net sys_concat_aux_intc_intr_00 [get_bd_pins sys_concat_aux_intc/In0] [get_bd_pins axi_timer/interrupt]
connect_bd_net -net sys_concat_aux_intc_intr_01 [get_bd_pins sys_concat_aux_intc/In1] [get_bd_pins axi_ethernet/ip2intc_irpt]
connect_bd_net -net sys_concat_aux_intc_intr_02 [get_bd_pins sys_concat_aux_intc/In2] [get_bd_ports unc_int0]
connect_bd_net -net sys_concat_aux_intc_intr_03 [get_bd_pins sys_concat_aux_intc/In3] [get_bd_ports unc_int1]
connect_bd_net -net sys_concat_aux_intc_intr_04 [get_bd_pins sys_concat_aux_intc/In4] [get_bd_pins axi_uart/interrupt]
connect_bd_net -net sys_concat_aux_intc_intr_05 [get_bd_pins sys_concat_aux_intc/In5] [get_bd_pins axi_gpio_lcd/ip2intc_irpt]
connect_bd_net -net sys_concat_aux_intc_intr_06 [get_bd_pins sys_concat_aux_intc/In6] [get_bd_pins axi_gpio_sw_led/ip2intc_irpt]
connect_bd_net -net sys_concat_aux_intc_intr_07 [get_bd_pins sys_concat_aux_intc/In7] [get_bd_pins axi_spdif_tx_dma/mm2s_introut]
connect_bd_net -net sys_concat_intc_din_0 [get_bd_pins sys_concat_intc/In0] [get_bd_pins axi_hdmi_dma/mm2s_introut]
connect_bd_net -net sys_concat_intc_din_1 [get_bd_pins sys_concat_intc/In1] [get_bd_pins axi_iic_main/iic2intc_irpt]
connect_bd_net -net sys_concat_intc_din_2 [get_bd_pins sys_concat_intc/In2] [get_bd_ports unc_int2]
connect_bd_net -net sys_concat_intc_din_3 [get_bd_pins sys_concat_intc/In3] [get_bd_ports unc_int3]
connect_bd_net -net sys_concat_intc_din_4 [get_bd_pins sys_concat_intc/In4] [get_bd_ports unc_int4]

# defaults (external interface)

connect_bd_net -net sys_const_vcc_vcc [get_bd_pins sys_const_vcc/const] [get_bd_ports fan_pwm]
connect_bd_net -net sys_rst_s [get_bd_ports sys_rst]
connect_bd_net -net sys_rst_s [get_bd_pins sys_rstgen/ext_reset_in]
connect_bd_net -net sys_rst_s [get_bd_pins axi_ddr_cntrl/sys_rst]

connect_bd_net -net sys_clk_p_s [get_bd_ports sys_clk_p] [get_bd_pins axi_ddr_cntrl/sys_clk_p]
connect_bd_net -net sys_clk_n_s [get_bd_ports sys_clk_n] [get_bd_pins axi_ddr_cntrl/sys_clk_n]

connect_bd_net -net sys_const_ddr3_0_const [get_bd_ports ddr3_1_n] [get_bd_pins sys_const_ddr3_0/const]
connect_bd_net -net sys_const_ddr3_1_const [get_bd_ports ddr3_1_p] [get_bd_pins sys_const_ddr3_1/const]
connect_bd_intf_net -intf_net axi_ddr_cntrl_ddr3 [get_bd_intf_ports ddr3] [get_bd_intf_pins axi_ddr_cntrl/DDR3]
connect_bd_intf_net -intf_net axi_ethernet_mdio [get_bd_intf_ports mdio] [get_bd_intf_pins axi_ethernet/mdio]
connect_bd_intf_net -intf_net axi_ethernet_mii [get_bd_intf_ports mii] [get_bd_intf_pins axi_ethernet/mii]

connect_bd_net -net axi_uart_sin [get_bd_ports uart_sin] [get_bd_pins axi_uart/rx]
connect_bd_net -net axi_uart_sout [get_bd_ports uart_sout] [get_bd_pins axi_uart/tx]

connect_bd_intf_net -intf_net axi_gpio_lcd_gpio [get_bd_intf_ports gpio_lcd] [get_bd_intf_pins axi_gpio_lcd/gpio]
connect_bd_intf_net -intf_net axi_gpio_sw_led_gpio [get_bd_intf_ports gpio_sw] [get_bd_intf_pins axi_gpio_sw_led/gpio]
connect_bd_intf_net -intf_net axi_gpio_sw_led_gpio2 [get_bd_intf_ports gpio_led] [get_bd_intf_pins axi_gpio_sw_led/gpio2]

connect_bd_net -net axi_iic_main_rstn [get_bd_ports iic_rstn] [get_bd_pins axi_iic_main/gpo]
connect_bd_intf_net -intf_net axi_iic_main_iic [get_bd_intf_ports iic_main] [get_bd_intf_pins axi_iic_main/iic]

# hdmi

connect_bd_net -net sys_200m_clk [get_bd_pins axi_hdmi_clkgen/clk]

connect_bd_intf_net -intf_net axi_cpu_interconnect_m01 [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] [get_bd_intf_pins axi_hdmi_clkgen/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m02 [get_bd_intf_pins axi_cpu_interconnect/M02_AXI] [get_bd_intf_pins axi_hdmi_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m03 [get_bd_intf_pins axi_cpu_interconnect/M03_AXI] [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE]

connect_bd_intf_net -intf_net axi_mem_interconnect_s02 [get_bd_intf_pins axi_mem_interconnect/S02_AXI] [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M01_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M02_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M03_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S02_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_clkgen/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_clkgen/drp_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_core/m_axis_mm2s_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk]

connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M01_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M02_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M03_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S02_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_clkgen/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_dma/axi_resetn]

connect_bd_net -net axi_hdmi_tx_core_hdmi_clk      [get_bd_pins axi_hdmi_core/hdmi_clk]              [get_bd_pins axi_hdmi_clkgen/clk_0]
connect_bd_net -net axi_hdmi_tx_core_hdmi_out_clk  [get_bd_pins axi_hdmi_core/hdmi_out_clk]          [get_bd_ports hdmi_out_clk]
connect_bd_net -net axi_hdmi_tx_core_hdmi_hsync    [get_bd_pins axi_hdmi_core/hdmi_16_hsync]         [get_bd_ports hdmi_hsync]
connect_bd_net -net axi_hdmi_tx_core_hdmi_vsync    [get_bd_pins axi_hdmi_core/hdmi_16_vsync]         [get_bd_ports hdmi_vsync]
connect_bd_net -net axi_hdmi_tx_core_hdmi_data_e   [get_bd_pins axi_hdmi_core/hdmi_16_data_e]        [get_bd_ports hdmi_data_e]
connect_bd_net -net axi_hdmi_tx_core_hdmi_data     [get_bd_pins axi_hdmi_core/hdmi_16_data]          [get_bd_ports hdmi_data]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tvalid   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tvalid]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tvalid]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tdata    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tdata]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tdata]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tkeep    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tkeep]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tkeep]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tlast    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tlast]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tlast]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tready   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tready]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tready]
connect_bd_net -net axi_hdmi_tx_core_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync]     [get_bd_pins axi_hdmi_dma/mm2s_fsync]
connect_bd_net -net axi_hdmi_tx_core_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync_ret]

# spdif audio

connect_bd_intf_net -intf_net axi_cpu_interconnect_m04 [get_bd_intf_pins axi_cpu_interconnect/M04_AXI] [get_bd_intf_pins axi_spdif_tx_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m05 [get_bd_intf_pins axi_cpu_interconnect/M05_AXI] [get_bd_intf_pins axi_spdif_tx_dma/S_AXI_LITE]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M04_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M05_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_core/S_AXI_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_core/S_AXIS_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_dma/s_axi_lite_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_dma/m_axi_sg_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M04_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M05_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spdif_tx_core/S_AXI_ARESETN]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spdif_tx_core/S_AXIS_ARESETN]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spdif_tx_dma/axi_resetn]

connect_bd_intf_net -intf_net axi_mem_interconnect_s03 [get_bd_intf_pins axi_mem_interconnect/S03_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_SG]
connect_bd_intf_net -intf_net axi_mem_interconnect_s04 [get_bd_intf_pins axi_mem_interconnect/S04_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_MM2S]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S03_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_mem_interconnect/S04_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S03_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_mem_interconnect/S04_ACLK] $sys_100m_clk_source

connect_bd_net -net axi_spdif_tx_dma_mm2s_valid [get_bd_pins axi_spdif_tx_core/S_AXIS_TVALID] [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tvalid]
connect_bd_net -net axi_spdif_tx_dma_mm2s_data  [get_bd_pins axi_spdif_tx_core/S_AXIS_TDATA]  [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tdata]
connect_bd_net -net axi_spdif_tx_dma_mm2s_last  [get_bd_pins axi_spdif_tx_core/S_AXIS_TLAST]  [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tlast]
connect_bd_net -net axi_spdif_tx_dma_mm2s_ready [get_bd_pins axi_spdif_tx_core/S_AXIS_TREADY] [get_bd_pins axi_spdif_tx_dma/m_axis_mm2s_tready]

connect_bd_net -net sys_200m_clk [get_bd_pins sys_audio_clkgen/clk_in1]
connect_bd_net -net sys_100m_resetn [get_bd_pins sys_audio_clkgen/resetn] $sys_100m_resetn_source
connect_bd_net -net sys_audio_clkgen_clk [get_bd_pins sys_audio_clkgen/clk_out1] [get_bd_pins axi_spdif_tx_core/spdif_data_clk]
connect_bd_net -net spdif_s [get_bd_ports spdif] [get_bd_pins axi_spdif_tx_core/spdif_tx_o]

# address map

set sys_zynq 0
set sys_mem_size 0x40000000
set sys_addr_cntrl_space [get_bd_addr_spaces sys_mb/Data]

create_bd_addr_seg -range 0x00002000 -offset 0x00000000 $sys_addr_cntrl_space [get_bd_addr_segs sys_dlmb_cntlr/SLMB/Mem]          SEG_data_dlmb_cntlr
create_bd_addr_seg -range 0x00001000 -offset 0x41400000 $sys_addr_cntrl_space [get_bd_addr_segs sys_mb_debug/S_AXI/Reg]           SEG_data_mb_debug
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]     SEG_data_ddr_cntrl
create_bd_addr_seg -range 0x00002000 -offset 0x40E00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ethernet/s_axi/Reg]           SEG_data_ethernetlite
create_bd_addr_seg -range 0x00010000 -offset 0x40010000 $sys_addr_cntrl_space [get_bd_addr_segs axi_gpio_lcd/s_axi/Reg]           SEG_data_gpio_lcd
create_bd_addr_seg -range 0x00010000 -offset 0x40020000 $sys_addr_cntrl_space [get_bd_addr_segs axi_gpio_sw_led/s_axi/Reg]        SEG_data_gpio_sw_led
create_bd_addr_seg -range 0x00010000 -offset 0x41200000 $sys_addr_cntrl_space [get_bd_addr_segs axi_intc/s_axi/Reg]               SEG_data_intc
create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_timer/s_axi/Reg]              SEG_data_timer
create_bd_addr_seg -range 0x00010000 -offset 0x40600000 $sys_addr_cntrl_space [get_bd_addr_segs axi_uart/s_axi/Reg]               SEG_data_uart

create_bd_addr_seg -range 0x00010000 -offset 0x41600000 $sys_addr_cntrl_space [get_bd_addr_segs axi_iic_main/s_axi/Reg]           SEG_data_iic_main
create_bd_addr_seg -range 0x00010000 -offset 0x79000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_clkgen/s_axi/axi_lite]   SEG_data_hdmi_clkgen
create_bd_addr_seg -range 0x00010000 -offset 0x43000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg]      SEG_data_hdmi_dma
create_bd_addr_seg -range 0x00010000 -offset 0x70e00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_core/s_axi/axi_lite]     SEG_data_hdmi_core
create_bd_addr_seg -range 0x00010000 -offset 0x75c00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spdif_tx_core/S_AXI/reg0]     SEG_data_spdif_core
create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spdif_tx_dma/S_AXI_LITE/Reg]  SEG_data_spdif_tx_dma

create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces sys_mb/Instruction]   [get_bd_addr_segs sys_ilmb_cntlr/SLMB/Mem]        SEG_instr_ilmb_cntlr
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces sys_mb/Instruction]   [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]   SEG_instr_ddr_cntrl

create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]   SEG_axi_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_SG]   [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]   SEG_axi_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_MM2S] [get_bd_addr_segs axi_ddr_cntrl/memmap/memaddr]   SEG_axi_ddr_cntrl



