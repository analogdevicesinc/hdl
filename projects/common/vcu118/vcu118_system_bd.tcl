
# create board design
# interface ports

create_bd_port -dir I -type rst sys_rst

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4

create_bd_port -dir I phy_sd
create_bd_port -dir O -type rst phy_rst_n

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sgmii_phyclk
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main

create_bd_port -dir I uart_sin
create_bd_port -dir O uart_sout

create_bd_port -dir O -from 7 -to 0 spi_csn_o
create_bd_port -dir I -from 7 -to 0 spi_csn_i
create_bd_port -dir I spi_clk_i
create_bd_port -dir O spi_clk_o
create_bd_port -dir I spi_sdo_i
create_bd_port -dir O spi_sdo_o
create_bd_port -dir I spi_sdi_i

create_bd_port -dir I -from 31 -to 0 gpio0_i
create_bd_port -dir O -from 31 -to 0 gpio0_o
create_bd_port -dir O -from 31 -to 0 gpio0_t
create_bd_port -dir I -from 31 -to 0 gpio1_i
create_bd_port -dir O -from 31 -to 0 gpio1_o
create_bd_port -dir O -from 31 -to 0 gpio1_t

# io settings

set_property -dict [list CONFIG.POLARITY {ACTIVE_HIGH}] [get_bd_ports sys_rst]
set_property -dict [list CONFIG.FREQ_HZ {250000000}] [get_bd_intf_ports sys_clk]
set_property -dict [list CONFIG.FREQ_HZ {625000000}] [get_bd_intf_ports sgmii_phyclk]

# instance: microblaze - processor

ad_ip_instance microblaze sys_mb
ad_ip_parameter sys_mb CONFIG.G_TEMPLATE_LIST 4
ad_ip_parameter sys_mb CONFIG.C_DCACHE_FORCE_TAG_LUTRAM 1

# instance: microblaze - local memory & bus

ad_ip_instance lmb_v10 sys_dlmb
ad_ip_instance lmb_v10 sys_ilmb

ad_ip_instance lmb_bram_if_cntlr sys_dlmb_cntlr
ad_ip_parameter sys_dlmb_cntlr CONFIG.C_ECC {0}

ad_ip_instance lmb_bram_if_cntlr sys_ilmb_cntlr
ad_ip_parameter sys_ilmb_cntlr CONFIG.C_ECC {0}

ad_ip_instance blk_mem_gen sys_lmb_bram
ad_ip_parameter sys_lmb_bram CONFIG.Memory_Type True_Dual_Port_RAM
ad_ip_parameter sys_lmb_bram CONFIG.use_bram_block BRAM_Controller

# instance: microblaze- mdm

ad_ip_instance mdm sys_mb_debug
ad_ip_parameter sys_mb_debug CONFIG.C_USE_UART 1

# instance: system reset/clocks
ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_500m_rstgen
ad_ip_parameter sys_500m_rstgen CONFIG.C_EXT_RST_WIDTH 1

# instance: ddr4

ad_ip_instance ip:ddr4 axi_ddr_cntrl
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE default_250mhz_clk2
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE ddr4_sdram_c2
ad_ip_parameter axi_ddr_cntrl CONFIG.RESET_BOARD_INTERFACE reset
ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ 250
ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ 500

ad_ip_instance proc_sys_reset axi_ddr_cntrl_rstgen

# instance: default peripherals

ad_ip_instance axi_ethernet axi_ethernet_0
ad_ip_parameter axi_ethernet_0 CONFIG.DIFFCLK_BOARD_INTERFACE sgmii_phyclk
ad_ip_parameter axi_ethernet_0 CONFIG.ETHERNET_BOARD_INTERFACE sgmii_lvds
ad_ip_parameter axi_ethernet_0 CONFIG.MDIO_BOARD_INTERFACE mdio_mdc
ad_ip_parameter axi_ethernet_0 CONFIG.PHYRST_BOARD_INTERFACE phy_reset_out
ad_ip_parameter axi_ethernet_0 CONFIG.TXCSUM Full
ad_ip_parameter axi_ethernet_0 CONFIG.RXCSUM Full
ad_ip_parameter axi_ethernet_0 CONFIG.TXMEM 8k
ad_ip_parameter axi_ethernet_0 CONFIG.RXMEM 8k

ad_ip_instance axi_dma axi_ethernet_dma
ad_ip_parameter axi_ethernet_dma CONFIG.c_include_mm2s_dre 1
ad_ip_parameter axi_ethernet_dma CONFIG.c_sg_use_stsapp_length 1
ad_ip_parameter axi_ethernet_dma CONFIG.c_include_s2mm_dre 1

ad_ip_instance axi_iic axi_iic_main

ad_ip_instance axi_uartlite axi_uart
ad_ip_parameter axi_uart CONFIG.C_BAUDRATE 115200

ad_ip_instance axi_timer axi_timer

ad_ip_instance axi_quad_spi axi_spi
ad_ip_parameter axi_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 8

ad_ip_instance axi_gpio axi_gpio
ad_ip_parameter axi_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_gpio CONFIG.C_INTERRUPT_PRESENT 1

# instance: interrupt

ad_ip_instance axi_intc axi_intc
ad_ip_parameter axi_intc CONFIG.C_HAS_FAST 0

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

# ddr4

ad_connect sys_rst axi_ddr_cntrl/sys_rst
ad_connect sys_clk axi_ddr_cntrl/C0_SYS_CLK
ad_connect ddr4 axi_ddr_cntrl/C0_DDR4
ad_connect axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst axi_ddr_cntrl_rstgen/ext_reset_in
ad_connect axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst sys_rstgen/ext_reset_in
ad_connect axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst sys_250m_rstgen/ext_reset_in
ad_connect axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst sys_500m_rstgen/ext_reset_in
ad_connect sys_mem_clk axi_ddr_cntrl/c0_ddr4_ui_clk
ad_connect sys_mem_clk axi_ddr_cntrl_rstgen/slowest_sync_clk
ad_connect sys_cpu_clk axi_ddr_cntrl/addn_ui_clkout1
ad_connect sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect sys_mem_resetn axi_ddr_cntrl_rstgen/peripheral_aresetn
ad_connect sys_mem_resetn axi_ddr_cntrl/c0_ddr4_aresetn
ad_connect sys_250m_clk axi_ddr_cntrl/addn_ui_clkout2
ad_connect sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect sys_500m_clk axi_ddr_cntrl/addn_ui_clkout3
ad_connect sys_500m_clk sys_500m_rstgen/slowest_sync_clk
ad_connect sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect sys_250m_resetn sys_250m_rstgen/peripheral_aresetn
ad_connect sys_500m_reset sys_500m_rstgen/peripheral_reset
ad_connect sys_500m_resetn sys_500m_rstgen/peripheral_aresetn

# generic system clocks pointers

set sys_cpu_clk      [get_bd_nets sys_cpu_clk]
set sys_dma_clk      [get_bd_nets sys_250m_clk]
set sys_iodelay_clk  [get_bd_nets sys_500m_clk]

set sys_cpu_reset         [get_bd_nets sys_cpu_reset]
set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]
set sys_dma_reset         [get_bd_nets sys_250m_reset]
set sys_dma_resetn        [get_bd_nets sys_250m_resetn]
set sys_iodelay_reset     [get_bd_nets sys_500m_reset]
set sys_iodelay_resetn    [get_bd_nets sys_500m_resetn]

# microblaze debug & interrupt

ad_connect sys_cpu_clk sys_mb/Clk
ad_connect sys_cpu_clk sys_dlmb/LMB_Clk
ad_connect sys_cpu_clk sys_ilmb/LMB_Clk
ad_connect sys_cpu_clk sys_dlmb_cntlr/LMB_Clk
ad_connect sys_cpu_clk sys_ilmb_cntlr/LMB_Clk
ad_connect sys_rstgen/mb_reset sys_mb/Reset
ad_connect sys_rstgen/bus_struct_reset sys_dlmb/SYS_Rst
ad_connect sys_rstgen/bus_struct_reset sys_ilmb/SYS_Rst
ad_connect sys_rstgen/bus_struct_reset sys_dlmb_cntlr/LMB_Rst
ad_connect sys_rstgen/bus_struct_reset sys_ilmb_cntlr/LMB_Rst
ad_connect sys_mb/DLMB sys_dlmb/LMB_M
ad_connect sys_mb/ILMB sys_ilmb/LMB_M
ad_connect sys_dlmb/LMB_Sl_0 sys_dlmb_cntlr/SLMB
ad_connect sys_ilmb/LMB_Sl_0 sys_ilmb_cntlr/SLMB
ad_connect sys_dlmb_cntlr/BRAM_PORT sys_lmb_bram/BRAM_PORTA
ad_connect sys_ilmb_cntlr/BRAM_PORT sys_lmb_bram/BRAM_PORTB
ad_connect sys_mb_debug/Debug_SYS_Rst sys_rstgen/mb_debug_sys_rst
ad_connect sys_mb_debug/MBDEBUG_0 sys_mb/DEBUG
ad_connect axi_intc/interrupt sys_mb/INTERRUPT
ad_connect axi_intc/intr sys_concat_intc/dout

# ethernet

ad_connect sgmii axi_ethernet_0/sgmii
ad_connect sgmii_phyclk axi_ethernet_0/lvds_clk
ad_connect mdio axi_ethernet_0/mdio
ad_connect phy_sd axi_ethernet_0/signal_detect
ad_connect phy_rst_n axi_ethernet_0/phy_rst_n
ad_connect sys_cpu_clk axi_ethernet_0/axis_clk
ad_connect  axi_ethernet_0/s_axis_txd axi_ethernet_dma/M_AXIS_MM2S
ad_connect  axi_ethernet_0/s_axis_txc axi_ethernet_dma/M_AXIS_CNTRL
ad_connect  axi_ethernet_0/m_axis_rxd axi_ethernet_dma/S_AXIS_S2MM
ad_connect  axi_ethernet_0/m_axis_rxs axi_ethernet_dma/S_AXIS_STS
ad_connect  axi_ethernet_0/axi_txd_arstn axi_ethernet_dma/mm2s_prmry_reset_out_n
ad_connect  axi_ethernet_0/axi_txc_arstn axi_ethernet_dma/mm2s_cntrl_reset_out_n
ad_connect  axi_ethernet_0/axi_rxd_arstn axi_ethernet_dma/s2mm_prmry_reset_out_n
ad_connect  axi_ethernet_0/axi_rxs_arstn axi_ethernet_dma/s2mm_sts_reset_out_n

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

# iic, spi and gpio

ad_connect iic_main axi_iic_main/iic
ad_connect uart_sin axi_uart/rx
ad_connect uart_sout axi_uart/tx
ad_connect spi_csn_i axi_spi/ss_i
ad_connect spi_csn_o axi_spi/ss_o
ad_connect spi_clk_i axi_spi/sck_i
ad_connect spi_clk_o axi_spi/sck_o
ad_connect spi_sdo_i axi_spi/io0_i
ad_connect spi_sdo_o axi_spi/io0_o
ad_connect spi_sdi_i axi_spi/io1_i
ad_connect gpio0_i axi_gpio/gpio_io_i
ad_connect gpio0_o axi_gpio/gpio_io_o
ad_connect gpio0_t axi_gpio/gpio_io_t
ad_connect gpio1_i axi_gpio/gpio2_io_i
ad_connect gpio1_o axi_gpio/gpio2_io_o
ad_connect gpio1_t axi_gpio/gpio2_io_t
ad_connect sys_cpu_clk axi_spi/ext_spi_clk

# defaults (interrupts)

ad_connect sys_concat_intc/In0    axi_timer/interrupt
ad_connect sys_concat_intc/In1    axi_ethernet_0/interrupt
ad_connect sys_concat_intc/In2    axi_ethernet_dma/mm2s_introut
ad_connect sys_concat_intc/In3    axi_ethernet_dma/s2mm_introut
ad_connect sys_concat_intc/In4    axi_uart/interrupt
ad_connect sys_concat_intc/In5    GND
ad_connect sys_concat_intc/In6    GND
ad_connect sys_concat_intc/In7    GND
ad_connect sys_concat_intc/In8    GND
ad_connect sys_concat_intc/In9    axi_iic_main/iic2intc_irpt
ad_connect sys_concat_intc/In10   axi_spi/ip2intc_irpt
ad_connect sys_concat_intc/In11   axi_gpio/ip2intc_irpt
ad_connect sys_concat_intc/In12   GND
ad_connect sys_concat_intc/In13   GND
ad_connect sys_concat_intc/In14   GND
ad_connect sys_concat_intc/In15   GND

# interconnect - processor

ad_cpu_interconnect 0x40C00000 axi_ethernet_0
ad_cpu_interconnect 0x41E10000 axi_ethernet_dma
ad_cpu_interconnect 0x40000000 axi_gpio
ad_cpu_interconnect 0x40600000 axi_uart
ad_cpu_interconnect 0x41200000 axi_intc
ad_cpu_interconnect 0x41C00000 axi_timer
ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x45000000 axi_sysid_0
ad_cpu_interconnect 0x44A70000 axi_spi
ad_cpu_interconnect 0x41400000 sys_mb_debug

# interconnect - memory

ad_mem_hp0_interconnect sys_mem_clk axi_ddr_cntrl/C0_DDR4_S_AXI
ad_mem_hp0_interconnect sys_cpu_clk sys_mb/M_AXI_DC
ad_mem_hp0_interconnect sys_cpu_clk sys_mb/M_AXI_IC
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_ethernet_dma/M_AXI_S2MM

create_bd_addr_seg -range 0x80000 -offset 0x0 [get_bd_addr_spaces sys_mb/Data] \
  [get_bd_addr_segs sys_dlmb_cntlr/SLMB/Mem] SEG_dlmb_cntlr
create_bd_addr_seg -range 0x80000 -offset 0x0 [get_bd_addr_spaces sys_mb/Instruction] \
  [get_bd_addr_segs sys_ilmb_cntlr/SLMB/Mem] SEG_ilmb_cntlr

