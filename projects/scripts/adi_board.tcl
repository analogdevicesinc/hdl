#----------------------------------------------------------------------------
# Internal processes
#----------------------------------------------------------------------------

# ensure that in case of a port number less than 10, the number format to be 0X
proc set_num {number} {
    if { $number < 10} {
        return "0${number}"
    } else {
        return $number
    }
}
# search the first free HP port in case of a Zynq device
proc free_hp_port {} {

    set hp_port_num 0
    set hp_port 1

    while(hp_port) {
        set hp_port_num [expr hp_port_num + 1]
        set hp_port [get_property "CONFIG.PCW_USE_S_AXI_HP${hp_port_num}" [get_bd_cells sys_ps7]]
    }

    return $hp_port_num
}

#----------------------------------------------------------------------------
# Integration processes
#----------------------------------------------------------------------------
# For AXI_LITE interconnect connections
proc adi_interconnect_lite { peripheral_name peripheral_address } {

    set peripheral_port_name "s_axi"
    set peripheral_base_name "axi_lite"
    set peripheral_address_range 0x00010000
    set interconnect_bd [get_bd_cells axi_cpu_interconnect]

    # increment the number of the master ports of the interconnect
    set number_of_master [get_property CONFIG.NUM_MI $interconnect_bd]
    set number_of_master [expr $number_of_master + 1]
    set_property CONFIG.NUM_MI $number_of_master $interconnect_bd

    # check processor type, connect system clock and reset to the peripheral
    if { [get_bd_cells sys_ps7] != {} } {
        # sys_proc is a zynq
        set sys_proc [get_bd_cells sys_ps7]

        # connect clk and reset for the interconnect
        connect_bd_net -net sys_100m_clk [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ACLK"] $::sys_100m_clk_source
        connect_bd_net -net sys_100m_resetn [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ARESETN"] $::sys_100m_resetn_source

        # connect clk and reset for the peripheral port
        connect_bd_net -net sys_100m_clk [get_bd_pins "${peripheral_name}/s_axi_aclk"]
        connect_bd_net -net sys_100m_resetn [get_bd_pins "${peripheral_name}/s_axi_aresetn"]
    } else {
        # sys_proc is a micorblaze
        set sys_proc [get_bd_cells sys_mb]

        # connect clk and reset for the interconnect
        connect_bd_net -net sys_100m_clk [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ACLK"] $::sys_100m_clk_source
        connect_bd_net -net sys_100m_resetn_intc [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ARESETN"] $::sys_100m_resetn_source

        # connect clk and reset for the peripheral port
        connect_bd_net -net sys_100m_clk [get_bd_pins "${peripheral_name}/s_axi_aclk"]
        connect_bd_net -net sys_100m_resetn [get_bd_pins "${peripheral_name}/s_axi_aresetn"]
    }

    # if peripheral is a Xilinx core
    if { [regexp "^analog*" [get_property VLNV [get_bd_cells $peripheral_name]]] == 0 } {
        set peripheral_base_name "Reg"
        if { [regexp "^xilinx.*spi*" [get_property VLNV [get_bd_cells $peripheral_name]]] } {
            set peripheral_port_name "axi_lite"
        } elseif { [regexp "^xilinx.*dma*" [get_property VLNV [get_bd_cells $peripheral_name]]] } {
            set peripheral_port_name "S_AXI_LITE"
        } else {
            set peripheral_port_name "s_axi"
        }
    }

    # make the port connection
    connect_bd_intf_net -intf_net "axi_cpu_interconnect_m${number_of_master}" [get_bd_intf_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_AXI"] [get_bd_intf_pins "${peripheral_name}/${peripheral_port_name}"]
    # define address space for the peripheral
    create_bd_addr_seg -range $peripheral_address_range -offset $peripheral_address $::sys_addr_cntrl_space [get_bd_addr_segs "${peripheral_name}/${peripheral_port_name}/${peripheral_base_name}"] "SEG_data_${peripheral_name}_axi_lite"

}

# Set up the SPI core
proc adi_spi_core { spi_name spi_ss_width spi_base_addr } {

    # define SPI ports
    set spi_csn_i       [create_bd_port -dir I -from [expr spi_ss_width - 1] -to 0 spi_csn_i]
    set spi_csn_o       [create_bd_port -dir O -from [expr spi_ss_width - 1] -to 0 spi_csn_o]
    set spi_sclk_i      [create_bd_port -dir I spi_sclk_i]
    set spi_sclk_o      [create_bd_port -dir O spi_sclk_o]
    set spi_mosi_i      [create_bd_port -dir I spi_mosi_i]
    set spi_mosi_o      [create_bd_port -dir O spi_mosi_o]
    set spi_miso_i      [create_bd_port -dir I spi_miso_i]

    # check processor type, connect system clock and reset to the peripheral
    if { [get_bd_cells sys_ps7] != {} } {

        # add SPI interface to ps7
        set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
        set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
        # connect the interface to the ports
        connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o] [get_bd_pins sys_ps7/SPI0_SS_O]
        connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i] [get_bd_pins sys_ps7/SPI0_SS_I]
        connect_bd_net -net spi_sclk_i [get_bd_ports spi_sclk_i] [get_bd_pins sys_ps7/SPI0_SCLK_I]
        connect_bd_net -net spi_sclk_o [get_bd_ports spi_sclk_o] [get_bd_pins sys_ps7/SPI0_SCLK_O]
        connect_bd_net -net spi_mosi_i [get_bd_ports spi_mosi_i] [get_bd_pins sys_ps7/SPI0_MOSI_I]
        connect_bd_net -net spi_mosi_o [get_bd_ports spi_mosi_o] [get_bd_pins sys_ps7/SPI0_MOSI_O]
        connect_bd_net -net spi_miso_i [get_bd_ports spi_miso_i] [get_bd_pins sys_ps7/SPI0_MISO_I]

    } else {

        # instanciate AXI_SPI core
        set spi_name [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 $spi_name]
        set_property -dict [list CONFIG.C_USE_STARTUP {0}] $spi_name
        set_property -dict [list CONFIG.C_NUM_SS_BITS {$spi_ss_width}] $spi_name
        set_property -dict [list CONFIG.C_SCK_RATIO {16}] $spi_name
        set_property -dict [list CONFIG.Multiples16 {2}] $spi_name

        # spi external ports
        connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o] [get_bd_pins "${spi_name}/ss_i"]
        connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i] [get_bd_pins "${spi_name}/ss_o"]
        connect_bd_net -net spi_sclk_o [get_bd_ports spi_clk_o] [get_bd_pins "${spi_name}/sck_o"]
        connect_bd_net -net spi_sclk_i [get_bd_ports spi_clk_i] [get_bd_pins "${spi_name}/sck_i"]
        connect_bd_net -net spi_mosi_o [get_bd_pins spi_sdo_o] [get_bd_pins "${spi_name}/io0_o"]
        connect_bd_net -net spi_mosi_i [get_bd_pins spi_sdo_i] [get_bd_pins "${spi_name}/io0_i"]
        connect_bd_net -net spi_miso_i [get_bd_ports spi_sdi_i] [get_bd_pins "${spi_name}/io1_i"]
        create_bd_addr_seg -range 0x00010000 -offset $spi_base_addr $::sys_addr_cntrl_space [get_bd_addr_segs "${spi_name}/axi_lite/Reg"] "SEG_data_${spi_name}"
    }
    #TODO: - Interrupts
    #
}

# For AXI interconnect connections between dma and 'ddr controller'/HP port
proc adi_dma_interconnect { dma_name port_name} {

    # check processor type, connect system clock and reset to the peripheral
    if { [get_bd_cells sys_ps7] != {} } {
        set hp_port [free_hp_port]
        set_property -dict [list "CONFIG.PCW_USE_S_AXI_HP${hp_port}" {1}] $sys_ps7
        set axi_dma_interconnect_($hp_port) [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_interconnect_($hp_port)]
        set_property -dict [list CONFIG.NUM_MI {1}] $axi_dma_interconnect_($hp_port)

        # connect the master port of the interconnect to the HP1, and connect aditional clock/reset signals
        connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
        connect_bd_net -net sys_100m_clk [get_bd_pins axi_ddr_interconnect/M00_ACLK] $::sys_100m_clk_source
        connect_bd_net -net sys_100m_resetn [get_bd_pins "axi_dma_interconnect_${hp_port}/M00_ARESETN"] $::sys_100m_resetn_source
        connect_bd_net -net sys_100m_clk [get_bd_pins "axi_dma_interconnect_${hp_port}/ACLK"] $::sys_100m_clk_source
        connect_bd_net -net sys_100m_resetn [get_bd_pins "axi_dma_interconnect_${hp_port}/ARESETN"] $::sys_100m_resetn_source
        connect_bd_intf_net -intf_net axi_ddr_interconnect_m00_axi [get_bd_intf_pins "axi_dma_interconnect_${hp_port}/M00_AXI"] [get_bd_intf_pins sys_ps7/S_AXI_HP1]

        # connect clk and reset for the interconnect
        connect_bd_net -net sys_200m_clk [get_bd_pins "${axi_dma_interconnect_($hp_port)}/S00_ACLK"] [get_bd_pins $clk]
        connect_bd_net -net sys_100m_resetn_intc [get_bd_pins "$axi_dma_interconnect_($hp_port)/S00_ARESETN"] [get_bd_pins $reset_i]

        # connect clk and reset for the peripheral port
        puts "${dma_name}/${peripheral_port}_aclk"
        connect_bd_net -net sys_200m_clk [get_bd_pins "${dma_name}/${peripheral_port}_aclk"]
        connect_bd_net -net sys_200m_resetn [get_bd_pins "${dma_name}/${peripheral_port}_aresetn"]

        # Connect the interconnect to the dma
        connect_bd_intf_net -intf_net ${dma_name}_interconnect_s00_axi [get_bd_intf_pins "axi_dma_interconnect_${hp_port}/S00_AXI"] [get_bd_intf_pins "${dma_name}/${port_name}"]

        # Definte address space
        create_bd_addr_seg -range $::sys_mem_size -offset 0x00000000 [get_bd_addr_spaces "${dma_name}/${port_name}"] [get_bd_addr_segs "sys_ps7/S_AXI_HP${hp_port}/HP${hp_port}_DDR_LOWOCM"] "SEG_sys_ps7_hp${hp_port}_ddr_lowocm"
    } else {

        set axi_ddr_interconnect [get_bd_cells axi_ddr_interconnect]

        # increment the number of the master ports of the interconnect
        set number_of_slave [get_property CONFIG.NUM_SI $axi_ddr_interconnect]
        set number_of_slave [expr $number_of_slave + 1]
        set_property CONFIG.NUM_SI $number_of_slave $axi_ddr_interconnect

        # sys_proc is a micorblaze
        set sys_ddr [get_bd_cells axi_ddr_cntrl_1]
        set clk "/axi_ddr_cntrl_1/ui_clk"
        set reset "/proc_sys_reset_1/peripheral_aresetn"
        set reset_i "/proc_sys_reset_1/interconnect_aresetn"

        # connect clk and reset for the interconnect
        connect_bd_net -net sys_200m_clk [get_bd_pins "${axi_ddr_interconnect}/S0[expr $number_of_slave-1]_ACLK"] [get_bd_pins $clk]
        connect_bd_net -net sys_100m_resetn_intc [get_bd_pins "$axi_ddr_interconnect/S0[expr $number_of_slave -1]_ARESETN"] [get_bd_pins $reset_i]

        # connect clk and reset for the peripheral port
        puts "${dma_name}/${peripheral_port}_aclk"
        connect_bd_net -net sys_200m_clk [get_bd_pins "${dma_name}/${peripheral_port}_aclk"]
        connect_bd_net -net sys_200m_resetn [get_bd_pins "${dma_name}/${peripheral_port}_aresetn"]
    }
    # make the port connection
    connect_bd_intf_net -intf_net "axi_ddr_interconnect_s${number_of_slave}" [get_bd_intf_pins "$axi_ddr_interconnect/S0[expr $number_of_slave -1]_AXI"] [get_bd_intf_pins "${dma_name}/${peripheral_port}"]
    # define address space for the peripheral
    create_bd_addr_seg -range $peripheral_address_range -offset $peripheral_address [get_bd_addr_spaces "${dma_name}/${peripheral_port}"] [get_bd_addr_segs "${sys_ddr}/memmap/memaddr"] "SEG_data_${dma_name}_2_ddr"
}
