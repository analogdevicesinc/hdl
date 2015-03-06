
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

set iic_main        [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main]

set uart_sin        [create_bd_port -dir I uart_sin]
set uart_sout       [create_bd_port -dir O uart_sout]

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

set sys_mb [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.4 sys_mb]
set_property -dict [list CONFIG.G_TEMPLATE_LIST {4}] $sys_mb
set_property -dict [list CONFIG.C_DCACHE_FORCE_TAG_LUTRAM {1}] $sys_mb

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

set sys_mb_debug [create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 sys_mb_debug]
set_property -dict [list CONFIG.C_USE_UART {1}] $sys_mb_debug

# instance: system reset/clocks

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]

# instance: ddr (mig)

set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig:6.1 axi_ddr_cntrl]
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl

set axi_ddr_cntrl_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_ddr_cntrl_rstgen]

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

set axi_ethernet [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:6.2 axi_ethernet]
set_property -dict [list CONFIG.PHY_TYPE {SGMII}] $axi_ethernet
set_property -dict [list CONFIG.ENABLE_LVDS {true}] $axi_ethernet
set_property -dict [list CONFIG.SupportLevel {0}] $axi_ethernet
set_property -dict [list CONFIG.TXCSUM {Full}] $axi_ethernet
set_property -dict [list CONFIG.RXCSUM {Full}] $axi_ethernet
set_property -dict [list CONFIG.TXMEM {8k}] $axi_ethernet
set_property -dict [list CONFIG.RXMEM {8k}] $axi_ethernet

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

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {32}] $sys_concat_intc

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

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {0}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core

set axi_spdif_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_spdif_tx_dma]
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_spdif_tx_dma
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] $axi_spdif_tx_dma

# connections

ad_connect  sys_mb_debug/Debug_SYS_Rst sys_rstgen/mb_debug_sys_rst
ad_connect  sys_rstgen/mb_reset sys_mb/Reset
ad_connect  sys_rstgen/bus_struct_reset sys_dlmb/SYS_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_ilmb/SYS_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_dlmb_cntlr/LMB_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_ilmb_cntlr/LMB_Rst

# microblaze local memory

ad_connect  sys_mb/DLMB sys_dlmb/LMB_M
ad_connect  sys_mb/ILMB sys_ilmb/LMB_M
ad_connect  sys_dlmb/LMB_Sl_0 sys_dlmb_cntlr/SLMB
ad_connect  sys_ilmb/LMB_Sl_0 sys_ilmb_cntlr/SLMB
ad_connect  sys_dlmb_cntlr/BRAM_PORT sys_lmb_bram/BRAM_PORTA
ad_connect  sys_ilmb_cntlr/BRAM_PORT sys_lmb_bram/BRAM_PORTB

# microblaze debug & interrupt

ad_connect  sys_mb_debug/MBDEBUG_0 sys_mb/DEBUG
ad_connect  axi_intc/interrupt sys_mb/INTERRUPT
ad_connect  axi_intc/intr sys_concat_intc/dout    

# defaults (peripherals)

ad_connect  sys_mem_clk axi_ddr_cntrl/c0_ddr4_ui_clk
ad_connect  sys_cpu_clk axi_ddr_cntrl/addn_ui_clkout1
ad_connect  sys_200m_clk axi_ddr_cntrl/addn_ui_clkout2
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_mem_resetn axi_ddr_cntrl_rstgen/peripheral_aresetn
ad_connect  sys_mem_resetn axi_ddr_cntrl/c0_ddr4_aresetn

ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_cpu_clk sys_mb/Clk
ad_connect  sys_cpu_clk sys_dlmb/LMB_Clk
ad_connect  sys_cpu_clk sys_ilmb/LMB_Clk
ad_connect  sys_cpu_clk sys_dlmb_cntlr/LMB_Clk
ad_connect  sys_cpu_clk sys_ilmb_cntlr/LMB_Clk
ad_connect  sys_cpu_clk axi_ethernet/axis_clk 

# defaults (interrupts)

ad_connect  sys_concat_intc/In0 axi_timer/interrupt
ad_connect  sys_concat_intc/In1 axi_ethernet/interrupt
ad_connect  sys_concat_intc/In2 axi_ethernet_dma/mm2s_introut
ad_connect  sys_concat_intc/In3 axi_ethernet_dma/s2mm_introut
ad_connect  sys_concat_intc/In4 axi_uart/interrupt
ad_connect  sys_concat_intc/In5 axi_gpio_lcd/ip2intc_irpt
ad_connect  sys_concat_intc/In6 axi_gpio_sw_led/ip2intc_irpt
ad_connect  sys_concat_intc/In7 axi_spdif_tx_dma/mm2s_introut
ad_connect  sys_concat_intc/In8 axi_hdmi_dma/mm2s_introut
ad_connect  sys_concat_intc/In9 axi_iic_main/iic2intc_irpt

for {set intc_index 10} {$intc_index < 32} {incr intc_index} {
  set mb_intr_${intc_index} [create_bd_port -dir I mb_intr_${intc_index}]
  ad_connect  sys_concat_intc/In${intc_index} mb_intr_${intc_index}
}

# defaults (ddr)

ad_connect  sys_clk axi_ddr_cntrl/C0_SYS_CLK
ad_connect  c0_ddr4 axi_ddr_cntrl/C0_DDR4
ad_connect  sys_rst axi_ddr_cntrl/sys_rst

ad_connect  axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst sys_rstgen/ext_reset_in
ad_connect  axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst axi_ethernet_rstgen/ext_reset_in
ad_connect  axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst axi_ddr_cntrl_rstgen/ext_reset_in
ad_connect  sys_mem_clk axi_ddr_cntrl_rstgen/slowest_sync_clk

# defaults (ethernet)

ad_connect  phy_clk axi_ethernet_clkgen/CLK_IN1_D
ad_connect  mdio axi_ethernet/mdio
ad_connect  sgmii axi_ethernet/sgmii
ad_connect  axi_ethernet/s_axis_txd axi_ethernet_dma/M_AXIS_MM2S
ad_connect  axi_ethernet/s_axis_txc axi_ethernet_dma/M_AXIS_CNTRL
ad_connect  axi_ethernet/m_axis_rxd axi_ethernet_dma/S_AXIS_S2MM
ad_connect  axi_ethernet/m_axis_rxs axi_ethernet_dma/S_AXIS_STS
ad_connect  phy_sd axi_ethernet/signal_detect
ad_connect  sys_cpu_resetn phy_rst_n                            
ad_connect  axi_ethernet_clkgen/clk_out1 axi_ethernet/clk125m
ad_connect  axi_ethernet_clkgen/clk_out1 axi_ethernet_rstgen/slowest_sync_clk
ad_connect  axi_ethernet_clkgen/clk_out2 axi_ethernet/clk312
ad_connect  axi_ethernet_clkgen/clk_out3 axi_ethernet/clk625
ad_connect  axi_ethernet_clkgen/locked axi_ethernet/mmcm_locked
ad_connect  axi_ethernet_rstgen/peripheral_reset axi_ethernet/rst_125
ad_connect  axi_ethernet/axi_txd_arstn axi_ethernet_dma/mm2s_prmry_reset_out_n
ad_connect  axi_ethernet/axi_txc_arstn axi_ethernet_dma/mm2s_cntrl_reset_out_n
ad_connect  axi_ethernet/axi_rxd_arstn axi_ethernet_dma/s2mm_prmry_reset_out_n
ad_connect  axi_ethernet/axi_rxs_arstn axi_ethernet_dma/s2mm_sts_reset_out_n

# defaults (misc)

ad_connect  gpio_lcd axi_gpio_lcd/gpio
ad_connect  gpio_sw axi_gpio_sw_led/gpio
ad_connect  gpio_led axi_gpio_sw_led/gpio2
ad_connect  iic_main axi_iic_main/iic
ad_connect  uart_sin axi_uart/rx
ad_connect  uart_sout axi_uart/tx

# hdmi

ad_connect  sys_200m_clk axi_hdmi_clkgen/clk
ad_connect  sys_cpu_clk axi_hdmi_clkgen/drp_clk
ad_connect  sys_cpu_clk axi_hdmi_core/m_axis_mm2s_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_data
ad_connect  axi_hdmi_core/m_axis_mm2s_tvalid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/m_axis_mm2s_tdata axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/m_axis_mm2s_tkeep axi_hdmi_dma/m_axis_mm2s_tkeep
ad_connect  axi_hdmi_core/m_axis_mm2s_tlast axi_hdmi_dma/m_axis_mm2s_tlast
ad_connect  axi_hdmi_core/m_axis_mm2s_tready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_core/m_axis_mm2s_fsync_ret

# spdif audio

ad_connect  axi_spdif_tx_core/S_AXIS_TVALID axi_spdif_tx_dma/m_axis_mm2s_tvalid
ad_connect  axi_spdif_tx_core/S_AXIS_TDATA axi_spdif_tx_dma/m_axis_mm2s_tdata
ad_connect  axi_spdif_tx_core/S_AXIS_TLAST axi_spdif_tx_dma/m_axis_mm2s_tlast
ad_connect  axi_spdif_tx_core/S_AXIS_TREADY axi_spdif_tx_dma/m_axis_mm2s_tready
ad_connect  sys_200m_clk sys_audio_clkgen/clk_in1
ad_connect  sys_audio_clkgen/clk_out1 axi_spdif_tx_core/spdif_data_clk
ad_connect  sys_cpu_clk axi_spdif_tx_core/S_AXIS_ACLK
ad_connect  sys_cpu_resetn axi_spdif_tx_core/S_AXIS_ARESETN
ad_connect  spdif axi_spdif_tx_core/spdif_tx_o

# defaults (interconnect - processor)

ad_cpu_interconnect 0x41400000 sys_mb_debug
ad_cpu_interconnect 0x40E00000 axi_ethernet
ad_cpu_interconnect 0x41E10000 axi_ethernet_dma
ad_cpu_interconnect 0x40600000 axi_uart
ad_cpu_interconnect 0x41C00000 axi_timer
ad_cpu_interconnect 0x41200000 axi_intc
ad_cpu_interconnect 0x40010000 axi_gpio_lcd
ad_cpu_interconnect 0x40020000 axi_gpio_sw_led
ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_cpu_interconnect 0x41E00000 axi_spdif_tx_dma

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ddr_interconnect
set_property CONFIG.NUM_MI {1} [get_bd_cells axi_ddr_interconnect]
set_property CONFIG.NUM_SI {1} [get_bd_cells axi_ddr_interconnect]

ad_connect axi_ddr_interconnect/M00_AXI axi_ddr_cntrl/C0_DDR4_S_AXI
ad_connect sys_mem_clk axi_ddr_interconnect/ACLK
ad_connect sys_mem_clk axi_ddr_interconnect/M00_ACLK
ad_connect sys_mem_resetn axi_ddr_interconnect/ARESETN
ad_connect sys_mem_resetn axi_ddr_interconnect/M00_ARESETN
ad_connect sys_cpu_resetn axi_ddr_interconnect/S00_ARESETN

ad_mem_hp0_interconnect sys_cpu_clk axi_ddr_interconnect/S00_AXI
ad_mem_hp0_interconnect sys_cpu_clk sys_mb/M_AXI_DC
ad_mem_hp0_interconnect sys_cpu_clk sys_mb/M_AXI_IC
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_S2MM
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_spdif_tx_dma/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_spdif_tx_dma/M_AXI_MM2S

create_bd_addr_seg -range 0x00020000 -offset 0x00000000 [get_bd_addr_spaces sys_mb/Data]        [get_bd_addr_segs sys_dlmb_cntlr/SLMB/Mem] SEG_dlmb_cntlr
create_bd_addr_seg -range 0x00020000 -offset 0x00000000 [get_bd_addr_spaces sys_mb/Instruction] [get_bd_addr_segs sys_ilmb_cntlr/SLMB/Mem] SEG_ilmb_cntlr

