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
proc free_hp_port { sys_ps7 } {

  set hp_port_num 0
  set hp_port 1

  while { $hp_port == 1 } {
    set hp_port_num [expr $hp_port_num + 1]
    set hp_port [get_property "CONFIG.PCW_USE_S_AXI_HP${hp_port_num}" $sys_ps7]
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
  if { $::sys_zynq == 1 } {
    # connect clk and reset for the interconnect
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ACLK"] $::sys_100m_clk_source
      connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ARESETN"] $::sys_100m_resetn_source

    # connect clk and reset for the peripheral port
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "${peripheral_name}/s_axi_aclk"]
      connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "${peripheral_name}/s_axi_aresetn"]
  } else {
    # connect clk and reset for the interconnect
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ACLK"] $::sys_100m_clk_source
      connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_ARESETN"] $::sys_100m_resetn_source

    # connect clk and reset for the peripheral port
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "${peripheral_name}/s_axi_aclk"]
      connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "${peripheral_name}/s_axi_aresetn"]
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
  connect_bd_intf_net -intf_net "axi_cpu_interconnect_m${number_of_master}" \
    [get_bd_intf_pins "$interconnect_bd/M[set_num [expr $number_of_master -1]]_AXI"] \
    [get_bd_intf_pins "${peripheral_name}/${peripheral_port_name}"]
  # define address space for the peripheral
  create_bd_addr_seg -range $peripheral_address_range -offset $peripheral_address \
    $::sys_addr_cntrl_space \
    [get_bd_addr_segs "${peripheral_name}/${peripheral_port_name}/${peripheral_base_name}"] \
    "SEG_data_${peripheral_name}_axi_lite"
}

# Set up the SPI core
proc adi_spi_core { spi_name spi_ss_width spi_base_addr } {

  # define SPI ports
  set spi_sclk_i      [create_bd_port -dir I spi_sclk_i]
  set spi_sclk_o      [create_bd_port -dir O spi_sclk_o]
  set spi_mosi_i      [create_bd_port -dir I spi_mosi_i]
  set spi_mosi_o      [create_bd_port -dir O spi_mosi_o]
  set spi_miso_i      [create_bd_port -dir I spi_miso_i]
  set spi_csn_i       [create_bd_port -dir I spi_csn_i]

  # check processor type, connect system clock and reset to the peripheral
  if { $::sys_zynq == 1 } {

    # add SPI interface to ps7
    set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] [get_bd_cells sys_ps7]
    set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] [get_bd_cells sys_ps7]

    set i 0
    while { $i < $spi_ss_width } {
      if { $i == 0 } {
        set ps7_cs "sys_ps7/SPI0_SS_O"
      } else {
        set ps7_cs "sys_ps7/SPI0_SS${i}_O"
      }
      switch $i {
        0
          { set spi_csn0_o  [create_bd_port -dir O spi_csn0_o]
            connect_bd_net -net "spi_csn${i}" \
              [get_bd_pins $ps7_cs] \
              [get_bd_ports spi_csn0_o]
          }
        1
          { set spi_csn1_o  [create_bd_port -dir O spi_csn1_o]
            connect_bd_net -net "spi_csn${i}" \
              [get_bd_pins $ps7_cs] \
              [get_bd_ports spi_csn1_o]
          }
        2
           { set spi_csn2_o  [create_bd_port -dir O spi_csn2_o]
            connect_bd_net -net "spi_csn${i}" \
              [get_bd_pins $ps7_cs] \
              [get_bd_ports spi_csn2_o]
          }
        3
          { set spi_csn3_o  [create_bd_port -dir O spi_csn3_o]
            connect_bd_net -net "spi_csn${i}" \
              [get_bd_pins $ps7_cs] \
              [get_bd_ports spi_csn3_o]
          }
      }
      incr i
    }
    connect_bd_net -net spi_csn_i \
      [get_bd_ports spi_csn_i] \
      [get_bd_pins sys_ps7/SPI0_SS_I]
    connect_bd_net -net spi_sclk_i  \
      [get_bd_ports spi_sclk_i] \
      [get_bd_pins sys_ps7/SPI0_SCLK_I]
    connect_bd_net -net spi_sclk_o  \
      [get_bd_ports spi_sclk_o] \
      [get_bd_pins sys_ps7/SPI0_SCLK_O]
    connect_bd_net -net spi_mosi_i  \
      [get_bd_ports spi_mosi_i] \
      [get_bd_pins sys_ps7/SPI0_MOSI_I]
    connect_bd_net -net spi_mosi_o  \
      [get_bd_ports spi_mosi_o] \
      [get_bd_pins sys_ps7/SPI0_MOSI_O]
    connect_bd_net -net spi_miso_i \
      [get_bd_ports spi_miso_i] \
      [get_bd_pins sys_ps7/SPI0_MISO_I]
  } else {
      # SPI SS lines
      set spi_csn_o [create_bd_port -dir O -from [expr $spi_ss_width - 1] -to 0 spi_csn_o]

      # instanciate AXI_SPI core
      set spi_name [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 $spi_name]
      set_property -dict [list CONFIG.C_USE_STARTUP {0}] $spi_name

      set_property -dict [list CONFIG.C_SCK_RATIO {16}] $spi_name
      set_property -dict [list CONFIG.Multiples16 {2}] $spi_name
      switch $spi_ss_width {
        1
          {
            set_property -dict [list CONFIG.C_NUM_SS_BITS {1}] $spi_name
          }
        2
          {
            set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] $spi_name
          }
        3
          {
            set_property -dict [list CONFIG.C_NUM_SS_BITS {3}] $spi_name
          }
        4
          {
            set_property -dict [list CONFIG.C_NUM_SS_BITS {4}] $spi_name
          }
      }

      adi_interconnect_lite $spi_name $spi_base_addr
      connect_bd_net -net sys_100m_clk \
        [get_bd_pins "${spi_name}/ext_spi_clk"] \
        $::sys_100m_clk_source

      # spi external ports
      connect_bd_net -net spi_csn_o \
        [get_bd_ports spi_csn_o] \
        [get_bd_pins "${spi_name}/ss_o"]
      connect_bd_net -net spi_csn_i \
        [get_bd_ports spi_csn_i] \
        [get_bd_pins "${spi_name}/ss_i"]
      connect_bd_net -net spi_sclk_o \
        [get_bd_ports spi_sclk_o] \
        [get_bd_pins "${spi_name}/sck_o"]
      connect_bd_net -net spi_sclk_i \
        [get_bd_ports spi_sclk_i] \
        [get_bd_pins "${spi_name}/sck_i"]
      connect_bd_net -net spi_mosi_o \
        [get_bd_ports spi_mosi_o] \
        [get_bd_pins "${spi_name}/io0_o"]
      connect_bd_net -net spi_mosi_i \
        [get_bd_ports spi_mosi_i] \
        [get_bd_pins "${spi_name}/io0_i"]
      connect_bd_net -net spi_miso_i \
        [get_bd_ports spi_miso_i] \
        [get_bd_pins "${spi_name}/io1_i"]
  }
}

# For AXI interconnect connections between dma and 'ddr controller'/HP port
proc adi_dma_interconnect { dma_name port_name} {

  # check processor type, connect system clock and reset to the peripheral
  if { $::sys_zynq == 1 } {

    set hp_port [free_hp_port [get_bd_cells sys_ps7]]
    set_property -dict [list "CONFIG.PCW_USE_S_AXI_HP${hp_port}" {1}] [get_bd_cells sys_ps7]
    switch $hp_port {
      1
        {
          set axi_dma_interconnect_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_interconnect_1]
          set_property -dict [list CONFIG.NUM_MI {1}] $axi_dma_interconnect_1
        }
      2
        {
          set axi_dma_interconnect_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_interconnect_2]
          set_property -dict [list CONFIG.NUM_MI {1}] $axi_dma_interconnect_2
        }
      3
        {
          set axi_dma_interconnect_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_interconnect_3]
          set_property -dict [list CONFIG.NUM_MI {1}] $axi_dma_interconnect_3
        }
    }

    # connect the master port of the interconnect to the HP1, and connect aditional clock/reset signals
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/M00_ACLK"] $::sys_100m_clk_source
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/M00_ARESETN"] $::sys_100m_resetn_source
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/ACLK"] $::sys_100m_clk_source
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/ARESETN"] $::sys_100m_resetn_source
    connect_bd_intf_net -intf_net axi_dma_interconnect_m00_axi \
      [get_bd_intf_pins "axi_dma_interconnect_${hp_port}/M00_AXI"] \
      [get_bd_intf_pins sys_ps7/S_AXI_HP1]

    # connect clk and reset for the interconnect
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/S00_ACLK"] \
      $::sys_100m_clk_source
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "axi_dma_interconnect_${hp_port}/S00_ARESETN"] \
      $::sys_100m_resetn_source

    # connect clk and reset for the peripheral port
    puts "${dma_name}/${port_name}_aclk"
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "${dma_name}/${port_name}_aclk"]
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "${dma_name}/${port_name}_aresetn"]

    # Connect the interconnect to the dma
    connect_bd_intf_net -intf_net "axi_dma_interconnect_${hp_port}_s00_axi" \
      [get_bd_intf_pins "axi_dma_interconnect_${hp_port}/S00_AXI"] \
      [get_bd_intf_pins "${dma_name}/${port_name}"]

    # Definte address space
    create_bd_addr_seg -range $::sys_mem_size -offset 0x00000000 \
      [get_bd_addr_spaces "${dma_name}/${port_name}"] \
      [get_bd_addr_segs "sys_ps7/S_AXI_HP${hp_port}/HP${hp_port}_DDR_LOWOCM"] \
      "SEG_sys_ps7_hp${hp_port}_ddr_lowocm"
  } else {

    set axi_mem_interconnect [get_bd_cells axi_mem_interconnect]

    # increment the number of the master ports of the interconnect
    set number_of_slave [get_property CONFIG.NUM_SI $axi_mem_interconnect]
    set number_of_slave [expr $number_of_slave + 1]
    set_property CONFIG.NUM_SI $number_of_slave $axi_mem_interconnect

    # connect clk and reset for the interconnect
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "${axi_mem_interconnect}/S0[expr $number_of_slave-1]_ACLK"] \
      $::sys_100m_clk_source
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "$axi_mem_interconnect/S0[expr $number_of_slave -1]_ARESETN"] \
      $::sys_100m_resetn_source

    # connect clk and reset for the peripheral port
    connect_bd_net -net sys_100m_clk \
      [get_bd_pins "${dma_name}/${port_name}_aclk"]
    connect_bd_net -net sys_100m_resetn \
      [get_bd_pins "${dma_name}/${port_name}_aresetn"]

    # make the port connection
    connect_bd_intf_net -intf_net "axi_mem_interconnect_s${number_of_slave}" \
      [get_bd_intf_pins "$axi_mem_interconnect/S0[expr $number_of_slave -1]_AXI"] \
      [get_bd_intf_pins "${dma_name}/${port_name}"]
    # define address space for the peripheral
    create_bd_addr_seg -range $::sys_mem_size -offset 0x00000000 \
      [get_bd_addr_spaces "${dma_name}/${port_name}"] \
      [get_bd_addr_segs "axi_ddr_cntrl/memmap/memaddr"] \
      "SEG_data_${dma_name}_2_ddr"
  }
}
