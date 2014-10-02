
# create board design
# interface ports

set sys_rst         [create_bd_port -dir I -type rst sys_rst]
set sys_clk         [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk]

set c0_ddr4         [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4]

set phy_rst_n       [create_bd_port -dir O -type rst phy_rst_n]
set phy_sd          [create_bd_port -dir I phy_sd]
set phy_clk         [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 phy_clk]
set mdio            [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio]
set sgmii           [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii]

set gpio_sw         [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sw]
set gpio_led        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_led]
set gpio_lcd        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_lcd]

set iic_rstn        [create_bd_port -dir O iic_rstn]
set iic_main        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main]

set uart_sin        [create_bd_port -dir I uart_sin]
set uart_sout       [create_bd_port -dir O uart_sout]

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
set_property -dict [list CONFIG.FREQ_HZ {300000000}] $sys_clk
set_property -dict [list CONFIG.FREQ_HZ {625000000}] $phy_clk

# instance: microblaze - processor

set sys_mb [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 sys_mb]
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

set sys_lmb_bram [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 sys_lmb_bram]
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.use_bram_block {BRAM_Controller}] $sys_lmb_bram

# instance: microblaze- mdm

set sys_mb_debug [create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.1 sys_mb_debug]
set_property -dict [list CONFIG.C_USE_UART {1}] $sys_mb_debug

# instance: system reset/clocks

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]

# instance: ddr (mig)

set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig:5.0 axi_ddr_cntrl]
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl

set axi_ddr_cntrl_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_ddr_cntrl_rstgen]

# instance: axi interconnect (lite)

set axi_cpu_aux_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_aux_interconnect]
set_property -dict [list CONFIG.NUM_MI {8}] $axi_cpu_aux_interconnect
set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_aux_interconnect

set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect]
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_interconnect

# instance: axi interconnect

set axi_mem_aux_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_aux_interconnect]
set_property -dict [list CONFIG.NUM_SI {2}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.STRATEGY {2}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.S00_HAS_REGSLICE {3}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.S01_HAS_REGSLICE {3}] $axi_mem_aux_interconnect
set_property -dict [list CONFIG.M00_HAS_REGSLICE {3}] $axi_mem_aux_interconnect

set axi_mem_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_interconnect]
set_property -dict [list CONFIG.NUM_SI {8}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] $axi_mem_interconnect
set_property -dict [list CONFIG.STRATEGY {2}] $axi_mem_interconnect

# instance: default peripherals

set axi_ethernet_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 axi_ethernet_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {625}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.PRIM_SOURCE {Differential_clock_capable_pin}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT2_USED {true}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {312}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT3_USED {true}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {625}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.CLKOUT4_USED {false}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.USE_LOCKED {true}] $axi_ethernet_clkgen
set_property -dict [list CONFIG.USE_RESET {false}] $axi_ethernet_clkgen

set axi_ethernet_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_ethernet_rstgen]

set axi_ethernet [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:6.1 axi_ethernet]
set_property -dict [list CONFIG.PHY_TYPE {SGMII}] $axi_ethernet
set_property -dict [list CONFIG.ENABLE_LVDS {true}] $axi_ethernet
set_property -dict [list CONFIG.Statistics_Counters {true}] $axi_ethernet
set_property -dict [list CONFIG.MCAST_EXTEND {true}] $axi_ethernet
set_property -dict [list CONFIG.TXVLAN_TRAN {true}] $axi_ethernet
set_property -dict [list CONFIG.TXVLAN_TAG {true}] $axi_ethernet
set_property -dict [list CONFIG.TXVLAN_STRP {true}] $axi_ethernet
set_property -dict [list CONFIG.RXVLAN_TRAN {true}] $axi_ethernet
set_property -dict [list CONFIG.RXVLAN_TAG {true}] $axi_ethernet
set_property -dict [list CONFIG.RXVLAN_STRP {true}] $axi_ethernet
set_property -dict [list CONFIG.TXMEM {32k}] $axi_ethernet
set_property -dict [list CONFIG.TXCSUM {None}] $axi_ethernet
set_property -dict [list CONFIG.RXMEM {32k}] $axi_ethernet
set_property -dict [list CONFIG.RXCSUM {None}] $axi_ethernet
set_property -dict [list CONFIG.SupportLevel {0}] $axi_ethernet

set axi_ethernet_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_ethernet_dma]
set_property -dict [list CONFIG.c_include_mm2s_dre {1}] $axi_ethernet_dma
set_property -dict [list CONFIG.c_sg_use_stsapp_length {1}] $axi_ethernet_dma
set_property -dict [list CONFIG.c_include_s2mm_dre {1}] $axi_ethernet_dma

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

set sys_concat_aux_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_aux_intc]
set_property -dict [list CONFIG.NUM_PORTS {9}] $sys_concat_aux_intc
set_property -dict [list CONFIG.IN8_WIDTH {5}] $sys_concat_aux_intc

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {5}] $sys_concat_intc

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]
set_property -dict [list CONFIG.PCORE_DEVICE_TYPE {1}] $axi_hdmi_core

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma]
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

set sys_reset_source [get_bd_pins sys_rstgen/peripheral_reset]
set sys_resetn_source [get_bd_pins sys_rstgen/peripheral_aresetn]
set sys_mem_resetn_source [get_bd_pins axi_ddr_cntrl_rstgen/peripheral_aresetn]
set sys_mem_clk_source [get_bd_pins axi_ddr_cntrl/c0_ddr4_ui_clk]
set sys_cpu_clk_source [get_bd_pins axi_ddr_cntrl/addn_ui_clkout1]
set sys_200m_clk_source [get_bd_pins axi_ddr_cntrl/addn_ui_clkout2]

connect_bd_net -net sys_cpu_rst $sys_reset_source
connect_bd_net -net sys_cpu_rstn $sys_resetn_source
connect_bd_net -net sys_mem_rstn $sys_mem_resetn_source
connect_bd_net -net sys_cpu_clk $sys_cpu_clk_source
connect_bd_net -net sys_mem_clk $sys_mem_clk_source
connect_bd_net -net sys_200m_clk $sys_200m_clk_source

connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M06_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_aux_interconnect/ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_clk  [get_bd_pins axi_cpu_interconnect/M06_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk  [get_bd_pins axi_cpu_aux_interconnect/ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk  [get_bd_pins axi_cpu_interconnect/ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/ACLK] $sys_200m_clk_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_aux_interconnect/ACLK] $sys_200m_clk_source

connect_bd_net -net sys_cpu_rstn [get_bd_pins sys_mb_debug/S_AXI_ARESETN]
connect_bd_net -net sys_mem_rstn [get_bd_pins axi_ddr_cntrl/c0_ddr4_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_ethernet/s_axi_lite_resetn] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_uart/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_timer/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_intc/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_gpio_lcd/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_gpio_sw_led/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_iic_main/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_ethernet_dma/axi_resetn]

connect_bd_net -net sys_cpu_clk [get_bd_pins sys_rstgen/slowest_sync_clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_mb/Clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_mb_debug/S_AXI_ACLK]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_dlmb/LMB_Clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_ilmb/LMB_Clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_dlmb_cntlr/LMB_Clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins sys_ilmb_cntlr/LMB_Clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet/s_axi_lite_clk] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet/axis_clk] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet_dma/m_axi_sg_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet_dma/m_axi_s2mm_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ethernet_dma/s_axi_lite_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_uart/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_timer/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_intc/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_gpio_lcd/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_gpio_sw_led/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_iic_main/s_axi_aclk]

# defaults (interconnect - processor)

connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_s00 [get_bd_intf_pins axi_cpu_aux_interconnect/S00_AXI] [get_bd_intf_pins axi_cpu_interconnect/M06_AXI]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m00 [get_bd_intf_pins axi_cpu_aux_interconnect/M00_AXI] [get_bd_intf_pins sys_mb_debug/S_AXI]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m01 [get_bd_intf_pins axi_cpu_aux_interconnect/M01_AXI] [get_bd_intf_pins axi_ethernet/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m02 [get_bd_intf_pins axi_cpu_aux_interconnect/M02_AXI] [get_bd_intf_pins axi_ethernet_dma/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m03 [get_bd_intf_pins axi_cpu_aux_interconnect/M03_AXI] [get_bd_intf_pins axi_uart/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m04 [get_bd_intf_pins axi_cpu_aux_interconnect/M04_AXI] [get_bd_intf_pins axi_timer/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m05 [get_bd_intf_pins axi_cpu_aux_interconnect/M05_AXI] [get_bd_intf_pins axi_intc/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m06 [get_bd_intf_pins axi_cpu_aux_interconnect/M06_AXI] [get_bd_intf_pins axi_gpio_lcd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_aux_interconnect_m07 [get_bd_intf_pins axi_cpu_aux_interconnect/M07_AXI] [get_bd_intf_pins axi_gpio_sw_led/s_axi]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/S00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M01_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M02_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M03_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M04_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M05_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M06_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_aux_interconnect/M07_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/S00_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M00_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M01_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M02_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M03_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M04_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M05_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M06_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_aux_interconnect/M07_ACLK] $sys_cpu_clk_source

connect_bd_intf_net -intf_net axi_cpu_interconnect_s00 [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_mb/M_AXI_DP]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m00 [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_iic_main/s_axi]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/S00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/S00_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M00_ACLK] $sys_cpu_clk_source

# defaults (interconnect - memory)

connect_bd_intf_net -intf_net axi_mem_aux_interconnect_m00 [get_bd_intf_pins axi_mem_aux_interconnect/M00_AXI] [get_bd_intf_pins axi_ddr_cntrl/C0_DDR4_S_AXI] 
connect_bd_intf_net -intf_net axi_mem_aux_interconnect_s00 [get_bd_intf_pins axi_mem_aux_interconnect/S00_AXI] [get_bd_intf_pins axi_mem_interconnect/M00_AXI]
connect_bd_net -net sys_mem_rstn [get_bd_pins axi_mem_aux_interconnect/M00_ARESETN] $sys_mem_resetn_source
connect_bd_net -net sys_mem_clk [get_bd_pins axi_mem_aux_interconnect/M00_ACLK] $sys_mem_clk_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_aux_interconnect/S00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_aux_interconnect/S00_ACLK] $sys_200m_clk_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_aux_interconnect/S01_ARESETN] $sys_resetn_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_aux_interconnect/S01_ACLK] $sys_200m_clk_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/M00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_200m_clk [get_bd_pins axi_mem_interconnect/M00_ACLK] $sys_200m_clk_source

connect_bd_intf_net -intf_net axi_mem_interconnect_s00 [get_bd_intf_pins axi_mem_interconnect/S00_AXI] [get_bd_intf_pins sys_mb/M_AXI_DC]
connect_bd_intf_net -intf_net axi_mem_interconnect_s01 [get_bd_intf_pins axi_mem_interconnect/S01_AXI] [get_bd_intf_pins sys_mb/M_AXI_IC]
connect_bd_intf_net -intf_net axi_mem_interconnect_s05 [get_bd_intf_pins axi_mem_interconnect/S05_AXI] [get_bd_intf_pins axi_ethernet_dma/M_AXI_SG]
connect_bd_intf_net -intf_net axi_mem_interconnect_s06 [get_bd_intf_pins axi_mem_interconnect/S06_AXI] [get_bd_intf_pins axi_ethernet_dma/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_mem_interconnect_s07 [get_bd_intf_pins axi_mem_interconnect/S07_AXI] [get_bd_intf_pins axi_ethernet_dma/M_AXI_S2MM]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S00_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S01_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S05_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S06_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S07_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S00_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S01_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S05_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S06_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S07_ACLK] $sys_cpu_clk_source

# defaults (interrupts)

connect_bd_net -net sys_concat_aux_intc_intr_00 [get_bd_pins sys_concat_aux_intc/In0] [get_bd_pins axi_timer/interrupt]
connect_bd_net -net sys_concat_aux_intc_intr_01 [get_bd_pins sys_concat_aux_intc/In1] [get_bd_pins axi_ethernet/interrupt]
connect_bd_net -net sys_concat_aux_intc_intr_02 [get_bd_pins sys_concat_aux_intc/In2] [get_bd_pins axi_ethernet_dma/mm2s_introut]
connect_bd_net -net sys_concat_aux_intc_intr_03 [get_bd_pins sys_concat_aux_intc/In3] [get_bd_pins axi_ethernet_dma/s2mm_introut]
connect_bd_net -net sys_concat_aux_intc_intr_04 [get_bd_pins sys_concat_aux_intc/In4] [get_bd_pins axi_uart/interrupt]
connect_bd_net -net sys_concat_aux_intc_intr_05 [get_bd_pins sys_concat_aux_intc/In5] [get_bd_pins axi_gpio_lcd/ip2intc_irpt]
connect_bd_net -net sys_concat_aux_intc_intr_06 [get_bd_pins sys_concat_aux_intc/In6] [get_bd_pins axi_gpio_sw_led/ip2intc_irpt]
connect_bd_net -net sys_concat_aux_intc_intr_07 [get_bd_pins sys_concat_aux_intc/In7] [get_bd_pins axi_spdif_tx_dma/mm2s_introut]
connect_bd_net -net sys_concat_intc_din_0 [get_bd_pins sys_concat_intc/In0] [get_bd_pins axi_hdmi_dma/mm2s_introut]
connect_bd_net -net sys_concat_intc_din_1 [get_bd_pins sys_concat_intc/In1] [get_bd_pins axi_iic_main/iic2intc_irpt]
connect_bd_net -net sys_concat_intc_din_2 [get_bd_pins sys_concat_intc/In2] [get_bd_ports unc_int2]
connect_bd_net -net sys_concat_intc_din_3 [get_bd_pins sys_concat_intc/In3] [get_bd_ports unc_int3]
connect_bd_net -net sys_concat_intc_din_4 [get_bd_pins sys_concat_intc/In4] [get_bd_ports unc_int4]

# defaults (ddr)

connect_bd_intf_net -intf_net sys_clk   [get_bd_intf_ports sys_clk] [get_bd_intf_pins axi_ddr_cntrl/C0_SYS_CLK]
connect_bd_intf_net -intf_net c0_ddr4   [get_bd_intf_ports c0_ddr4] [get_bd_intf_pins axi_ddr_cntrl/C0_DDR4]

connect_bd_net -net sys_rst             [get_bd_ports sys_rst]      [get_bd_pins axi_ddr_cntrl/sys_rst]

connect_bd_net -net axi_ddr_cntrl_rst   [get_bd_pins axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst]
connect_bd_net -net axi_ddr_cntrl_rst   [get_bd_pins sys_rstgen/ext_reset_in]
connect_bd_net -net axi_ddr_cntrl_rst   [get_bd_pins axi_ethernet_rstgen/ext_reset_in] 
connect_bd_net -net axi_ddr_cntrl_rst   [get_bd_pins axi_ddr_cntrl_rstgen/ext_reset_in] 
connect_bd_net -net sys_mem_clk         [get_bd_pins axi_ddr_cntrl_rstgen/slowest_sync_clk]

# defaults (ethernet)

connect_bd_intf_net -intf_net phy_clk                   [get_bd_intf_ports phy_clk]                         [get_bd_intf_pins axi_ethernet_clkgen/CLK_IN1_D]
connect_bd_intf_net -intf_net mdio                      [get_bd_intf_ports mdio]                            [get_bd_intf_pins axi_ethernet/mdio]
connect_bd_intf_net -intf_net sgmii                     [get_bd_intf_ports sgmii]                           [get_bd_intf_pins axi_ethernet/sgmii]
connect_bd_intf_net -intf_net axi_ethernet_dma_txd      [get_bd_intf_pins axi_ethernet/s_axis_txd]          [get_bd_intf_pins axi_ethernet_dma/M_AXIS_MM2S]
connect_bd_intf_net -intf_net axi_ethernet_dma_txc      [get_bd_intf_pins axi_ethernet/s_axis_txc]          [get_bd_intf_pins axi_ethernet_dma/M_AXIS_CNTRL]
connect_bd_intf_net -intf_net axi_ethernet_dma_rxd      [get_bd_intf_pins axi_ethernet/m_axis_rxd]          [get_bd_intf_pins axi_ethernet_dma/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axi_ethernet_dma_rxs      [get_bd_intf_pins axi_ethernet/m_axis_rxs]          [get_bd_intf_pins axi_ethernet_dma/S_AXIS_STS]

connect_bd_net -net phy_sd                         [get_bd_ports phy_sd]                               [get_bd_pins axi_ethernet/signal_detect]
connect_bd_net -net phy_rst_n                      [get_bd_ports phy_rst_n]                            [get_bd_pins axi_ethernet/phy_rst_n]
connect_bd_net -net axi_ethernet_clkgen_125m_clk   [get_bd_pins axi_ethernet_clkgen/clk_out1]          [get_bd_pins axi_ethernet/clk125m]
connect_bd_net -net axi_ethernet_clkgen_312m_clk   [get_bd_pins axi_ethernet_clkgen/clk_out2]          [get_bd_pins axi_ethernet/clk312] 
connect_bd_net -net axi_ethernet_clkgen_625m_clk   [get_bd_pins axi_ethernet_clkgen/clk_out3]          [get_bd_pins axi_ethernet/clk625] 
connect_bd_net -net axi_ethernet_clkgen_locked     [get_bd_pins axi_ethernet_clkgen/locked]            [get_bd_pins axi_ethernet/mmcm_locked] 
connect_bd_net -net axi_ethernet_rstgen_rst        [get_bd_pins axi_ethernet_rstgen/peripheral_reset]  [get_bd_pins axi_ethernet/rst_125]
connect_bd_net -net axi_ethernet_dma_txd_rstn      [get_bd_pins axi_ethernet/axi_txd_arstn]            [get_bd_pins axi_ethernet_dma/mm2s_prmry_reset_out_n]
connect_bd_net -net axi_ethernet_dma_txc_rstn      [get_bd_pins axi_ethernet/axi_txc_arstn]            [get_bd_pins axi_ethernet_dma/mm2s_cntrl_reset_out_n]
connect_bd_net -net axi_ethernet_dma_rxd_rstn      [get_bd_pins axi_ethernet/axi_rxd_arstn]            [get_bd_pins axi_ethernet_dma/s2mm_prmry_reset_out_n]
connect_bd_net -net axi_ethernet_dma_rxs_rstn      [get_bd_pins axi_ethernet/axi_rxs_arstn]            [get_bd_pins axi_ethernet_dma/s2mm_sts_reset_out_n]
connect_bd_net -net axi_ethernet_clkgen_125m_clk   [get_bd_pins axi_ethernet_rstgen/slowest_sync_clk]

# defaults (misc)

connect_bd_intf_net -intf_net gpio_lcd  [get_bd_intf_ports gpio_lcd]  [get_bd_intf_pins axi_gpio_lcd/gpio]
connect_bd_intf_net -intf_net gpio_sw   [get_bd_intf_ports gpio_sw]   [get_bd_intf_pins axi_gpio_sw_led/gpio]
connect_bd_intf_net -intf_net gpio_led  [get_bd_intf_ports gpio_led]  [get_bd_intf_pins axi_gpio_sw_led/gpio2]
connect_bd_intf_net -intf_net iic_main  [get_bd_intf_ports iic_main]  [get_bd_intf_pins axi_iic_main/iic]
connect_bd_net -net uart_sin       [get_bd_ports uart_sin]       [get_bd_pins axi_uart/rx]
connect_bd_net -net uart_sout      [get_bd_ports uart_sout]      [get_bd_pins axi_uart/tx]
connect_bd_net -net iic_rstn       [get_bd_ports iic_rstn]       [get_bd_pins axi_iic_main/gpo]

# hdmi

connect_bd_net -net sys_200m_clk [get_bd_pins axi_hdmi_clkgen/clk]

connect_bd_intf_net -intf_net axi_cpu_interconnect_m01 [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] [get_bd_intf_pins axi_hdmi_clkgen/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m02 [get_bd_intf_pins axi_cpu_interconnect/M02_AXI] [get_bd_intf_pins axi_hdmi_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m03 [get_bd_intf_pins axi_cpu_interconnect/M03_AXI] [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE]

connect_bd_intf_net -intf_net axi_mem_interconnect_s02 [get_bd_intf_pins axi_mem_interconnect/S02_AXI] [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S]

connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M01_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M02_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M03_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S02_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_clkgen/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_clkgen/drp_clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_core/s_axi_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_core/m_axis_mm2s_clk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk]

connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M01_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M02_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M03_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S02_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_hdmi_clkgen/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_hdmi_core/s_axi_aresetn]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_hdmi_dma/axi_resetn]

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
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M04_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_cpu_interconnect/M05_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_spdif_tx_core/S_AXI_ACLK]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_spdif_tx_core/S_AXIS_ACLK]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_spdif_tx_dma/s_axi_lite_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_spdif_tx_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_spdif_tx_dma/m_axi_sg_aclk]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M04_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_cpu_interconnect/M05_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_spdif_tx_core/S_AXI_ARESETN]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_spdif_tx_core/S_AXIS_ARESETN]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_spdif_tx_dma/axi_resetn]

connect_bd_intf_net -intf_net axi_mem_interconnect_s03 [get_bd_intf_pins axi_mem_interconnect/S03_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_SG]
connect_bd_intf_net -intf_net axi_mem_interconnect_s04 [get_bd_intf_pins axi_mem_interconnect/S04_AXI] [get_bd_intf_pins axi_spdif_tx_dma/M_AXI_MM2S]
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S03_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_rstn [get_bd_pins axi_mem_interconnect/S04_ARESETN] $sys_resetn_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S03_ACLK] $sys_cpu_clk_source
connect_bd_net -net sys_cpu_clk [get_bd_pins axi_mem_interconnect/S04_ACLK] $sys_cpu_clk_source

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

create_bd_addr_seg -range 0x00020000 -offset 0x00000000 $sys_addr_cntrl_space [get_bd_addr_segs sys_dlmb_cntlr/SLMB/Mem]          SEG_data_dlmb_cntlr
create_bd_addr_seg -range 0x00001000 -offset 0x41400000 $sys_addr_cntrl_space [get_bd_addr_segs sys_mb_debug/S_AXI/Reg]           SEG_data_mb_debug
create_bd_addr_seg -range 0x00040000 -offset 0x40E00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ethernet/eth_buf/S_AXI/REG]   SEG_data_ethernet
create_bd_addr_seg -range 0x00010000 -offset 0x41E10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ethernet_dma/S_AXI_LITE/Reg]  SEG_data_ethernet_dma
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

create_bd_addr_seg -range 0x00020000 -offset 0x00000000 [get_bd_addr_spaces sys_mb/Instruction] [get_bd_addr_segs sys_ilmb_cntlr/SLMB/Mem] SEG_instr_ilmb_cntlr
create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet/eth_buf/S_AXI_2TEMAC] [get_bd_addr_segs axi_ethernet/eth_mac/s_axi/Reg] SEG_ethernet_mac

create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces sys_mb/Data]                [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces sys_mb/Instruction]         [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma/Data_SG]   [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma/Data_MM2S] [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_dma/Data_S2MM] [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_SG]   [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl
create_bd_addr_seg -range $sys_mem_size -offset 0x80000000 [get_bd_addr_spaces axi_spdif_tx_dma/Data_MM2S] [get_bd_addr_segs axi_ddr_cntrl/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_mem_ddr_cntrl


