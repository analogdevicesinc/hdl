#----------------------------------------------------------------------------
# Internal processes
#----------------------------------------------------------------------------

# ensure that in case of a port number less than 10, the number format to be 0X
# usage: get_numstr 2
proc get_numstr {number} {
  if { $number < 10} {
    return "0${number}"
  } else {
    return $number
  }
}

#------------------------------------------------------------------------------
# Integration processes
#------------------------------------------------------------------------------
# usage : adi_interconnect_lite axi_ad9467
#------------------------------------------------------------------------------
proc adi_interconnect_lite { p_name } {

  global sys_100m_clk_source
  global sys_100m_resetn_source

  set axi_cpu_interconnect [get_bd_cells axi_cpu_interconnect]

  # increment the number of the master ports of the interconnect
  set p_port [get_property CONFIG.NUM_MI $axi_cpu_interconnect]
  set i_count [expr $p_port + 1]
  set i_str [get_numstr $p_port]

  set p_seg [get_bd_addr_segs -of_objects [get_bd_cells $p_name]]
  set p_seg_fields [split $p_seg "/"]
  lassign $p_seg_fields no_use p_seg_name p_seg_intf p_seg_base

  set_property CONFIG.NUM_MI $i_count [get_bd_cells axi_cpu_interconnect]

  # connect clk and reset for the interconnect
  connect_bd_net -net sys_100m_clk \
    [get_bd_pins "$axi_cpu_interconnect/M${i_str}_ACLK"] \
    [get_bd_pins "${p_name}/s_axi_aclk"] \
    $sys_100m_clk_source

  connect_bd_net -net sys_100m_resetn \
    [get_bd_pins "${axi_cpu_interconnect}/M${i_str}_ARESETN"] \
    [get_bd_pins "${p_name}/s_axi_aresetn"] \
    $sys_100m_resetn_source

  # make the interface connection
  connect_bd_intf_net -intf_net "${p_name}axi_lite" \
    [get_bd_intf_pins "${axi_cpu_interconnect}/M${i_str}_AXI"] \
    [get_bd_intf_pins "${p_seg_name}/${p_seg_intf}"]

}

#------------------------------------------------------------------------------
# usage: adi_assign_base_address 0x74a00000 axi_ad9467
#------------------------------------------------------------------------------
proc adi_assign_base_address {p_addr p_name} {

  global sys_addr_cntrl_space

  set p_seg [get_bd_addr_segs -of_objects [get_bd_cells $p_name]]
  set p_seg [lsearch -inline -regexp $p_seg (?i)/.*s_axi\/|axi_lite.*/]

  set p_seg_fields [split $p_seg "/"]
  lassign $p_seg_fields no_use p_seg_name p_seg_intf p_seg_base

  set p_seg_range [get_property range $p_seg]

  create_bd_addr_seg -range $p_seg_range \
    -offset $p_addr $sys_addr_cntrl_space \
    $p_seg "SEG_data_${p_name}"
}

#------------------------------------------------------------------------------
# usage : adi_add_interrupt axi_ad9467_dma/irq
#------------------------------------------------------------------------------
proc adi_add_interrupt { intr_port } {

  global sys_zynq

  if { [get_bd_ports unc_int2] != {} } {
    delete_bd_objs [get_bd_nets sys_concat_intc_din_2] [get_bd_ports unc_int2]
    connect_bd_net [get_bd_pins sys_concat_intc/In2] [get_bd_pins $intr_port]
  } elseif { [get_bd_ports unc_int3] != {} } {
    delete_bd_objs [get_bd_nets sys_concat_intc_din_3] [get_bd_ports unc_int3]
    connect_bd_net [get_bd_pins sys_concat_intc/In3] [get_bd_pins $intr_port]
  } else {
    set p_intr [get_property CONFIG.NUM_PORTS [get_bd_cells sys_concat_intc]]
    set i_intr [expr $p_intr + 1]
    set_property CONFIG.NUM_PORTS $i_intr [get_bd_cells sys_concat_intc]
    connect_bd_net -net "sys_concat_intc_din_${i_intr}" \
      [get_bd_pins "sys_concat_intc/In${i_intr}"] \
      [get_bd_pins $intr_port]
  }
  # incrase the auxiliary concat last input port
  if { $sys_zynq == 0 } {
    set p_aux_intr [get_property CONFIG.IN9_WIDTH [get_bd_cells sys_concat_aux_intc]]
    set i_aux_intr [expr $p_aux_intr + 1]
    set_property CONFIG.IN9_WIDTH $i_aux_intr [get_bd_cells sys_concat_aux_intc]
  }
}

#------------------------------------------------------------------------------
# usage : adi_spi_core 0x41600000 2 ad9467_spi
#------------------------------------------------------------------------------
proc adi_spi_core { spi_addr spi_ss spi_name } {

  global sys_zynq
  global sys_100m_clk_source

  # define SPI ports
  create_bd_port -dir I "${spi_name}_sclk_i"
  create_bd_port -dir O "${spi_name}_sclk_o"
  create_bd_port -dir I "${spi_name}_mosi_i"
  create_bd_port -dir O "${spi_name}_mosi_o"
  create_bd_port -dir I "${spi_name}_miso_i"
  create_bd_port -dir I "${spi_name}_csn_i"
  create_bd_port -dir O -from [expr $spi_ss - 1] -to 0 "${spi_name}_csn_o"

  # check processor type, connect system clock and reset to the peripheral
  if { $sys_zynq == 1 } {
    set sys_ps7 [get_bd_cells sys_ps7]

    # add SPI interface to ps7, first check which SPI is free
    if { [get_property CONFIG.PCW_SPI0_PERIPHERAL_ENABLE [get_bd_cells sys_ps7]] == 0 } {
      set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
      set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
      set if_spi "SPI0"
    } else  {
      set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
      set_property -dict [list CONFIG.PCW_SPI1_SPI0_IO {EMIO}] $sys_ps7
      set if_spi "SPI1"
    }

    # connect chipselect lines to the ports
    if { $spi_ss > 1 } {
      create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 "${spi_name}_csn_concat"
      set_property CONFIG.NUM_PORTS $spi_ss [get_bd_cells "${spi_name}_csn_concat"]

      connect_bd_net -net "${spi_name}_csn_o" \
        [get_bd_ports "${spi_name}_csn_o"] \
        [get_bd_pins "${spi_name}_csn_concat/dout"]

      set i 0
      set j [expr $spi_ss - 1]
      while { $i < $spi_ss } {
        if { $j == 0 } {
          set ss_number SS
        } else {
          set ss_number SS${j}
        }
        connect_bd_net [get_bd_pins "${spi_name}_csn_concat/In${i}"] \
          [get_bd_pins "sys_ps7/${if_spi}_${ss_number}_O"]

        incr i
        incr j -1
      }
    } else {
      connect_bd_net -net "${spi_name}_csn_o" \
        [get_bd_ports "${spi_name}_csn_o"] \
        [get_bd_pins "sys_ps7/${if_spi}_SS_O"]
    }
    # connect remaining nets to the ports
    connect_bd_net -net spi_csn_i \
      [get_bd_ports "${spi_name}_csn_i"] \
      [get_bd_pins "sys_ps7/${if_spi}_SS_I"]
    connect_bd_net -net spi_sclk_i  \
      [get_bd_ports "${spi_name}_sclk_i"] \
      [get_bd_pins "sys_ps7/${if_spi}_SCLK_I"]
    connect_bd_net -net spi_sclk_o  \
      [get_bd_ports "${spi_name}_sclk_o"] \
      [get_bd_pins "sys_ps7/${if_spi}_SCLK_O"]
    connect_bd_net -net spi_mosi_i  \
      [get_bd_ports "${spi_name}_mosi_i"] \
      [get_bd_pins "sys_ps7/${if_spi}_MOSI_I"]
    connect_bd_net -net spi_mosi_o  \
      [get_bd_ports "${spi_name}_mosi_o"] \
      [get_bd_pins "sys_ps7/${if_spi}_MOSI_O"]
    connect_bd_net -net spi_miso_i \
      [get_bd_ports "${spi_name}_miso_i"] \
      [get_bd_pins "sys_ps7/${if_spi}_MISO_I"]
  } else {

      # instanciate AXI_SPI core
      set spi_name [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 $spi_name]
      set_property -dict [list CONFIG.C_USE_STARTUP {0}] $spi_name

      set_property -dict [list CONFIG.C_SCK_RATIO {16}] $spi_name
      set_property -dict [list CONFIG.Multiples16 {2}] $spi_name
      set_property CONFIG.C_NUM_SS_BITS $spi_ss $spi_name

      connect_bd_net -net sys_100m_clk \
        [get_bd_pins "${spi_name}/ext_spi_clk"] \
        $sys_100m_clk_source

      # spi external ports
      connect_bd_net -net spi_csn_o \
        [get_bd_ports "${spi_name}_csn_o"] \
        [get_bd_pins "${spi_name}/ss_o"]
      connect_bd_net -net spi_csn_i \
        [get_bd_ports "${spi_name}_csn_i"] \
        [get_bd_pins "${spi_name}/ss_i"]
      connect_bd_net -net spi_sclk_o \
        [get_bd_ports "${spi_name}_sclk_o"] \
        [get_bd_pins "${spi_name}/sck_o"]
      connect_bd_net -net spi_sclk_i \
        [get_bd_ports "${spi_name}_sclk_i"] \
        [get_bd_pins "${spi_name}/sck_i"]
      connect_bd_net -net spi_mosi_o \
        [get_bd_ports "${spi_name}_mosi_o"] \
        [get_bd_pins "${spi_name}/io0_o"]
      connect_bd_net -net spi_mosi_i \
        [get_bd_ports "${spi_name}_mosi_i"] \
        [get_bd_pins "${spi_name}/io0_i"]
      connect_bd_net -net spi_miso_i \
        [get_bd_ports "${spi_name}_miso_i"] \
        [get_bd_pins "${spi_name}/io1_i"]
  }
}

#------------------------------------------------------------------------------
# adi_dma_interconnect axi_ad9467_dma/m_dest_axi sys_200m_clk axi_mem_interconnect
#------------------------------------------------------------------------------
proc adi_dma_interconnect { dma_if dma_clk ic_name } {

  global sys_100m_resetn_source

  set dma_atrb [split $dma_if "/"]
  lassign $dma_atrb dma_name dma_if_port

  # increment the number of the slave ports of the interconnect
  set p_port [get_property CONFIG.NUM_SI [get_bd_cells $ic_name]]
  if { $p_port == 1} {
    if { [get_bd_intf_nets -of_object [get_bd_intf_pins "${ic_name}/S00_AXI"]] eq {} } {
      set i_count 1
      set i_str [get_numstr 0]
    } else {
      set i_count [expr $p_port + 1]
      set i_str [get_numstr $p_port]
    }
  } else {
    set i_count [expr $p_port + 1]
    set i_str [get_numstr $p_port]
  }

  set_property CONFIG.NUM_SI $i_count [get_bd_cells $ic_name]

  # connect clk and reset for the interconnect
  connect_bd_net [get_bd_pins "${ic_name}/S${i_str}_ACLK"] \
    ${dma_clk}
  connect_bd_net [get_bd_pins "${ic_name}/S${i_str}_ARESETN"] \
    $sys_100m_resetn_source

  # connect clk and reset for the peripheral port
  connect_bd_net [get_bd_pins "${dma_name}/${dma_if_port}_aclk"] \
    ${dma_clk}
  connect_bd_net [get_bd_pins "${dma_name}/${dma_if_port}_aresetn"] \
    $sys_100m_resetn_source

  # make the port connection
  connect_bd_intf_net -intf_net "${dma_name}_${i_str}" \
    [get_bd_intf_pins "${ic_name}/S${i_str}_AXI"] \
    [get_bd_intf_pins "${dma_name}/${dma_if_port}"]

  # define address space for the peripheral
  assign_bd_address
}

#------------------------------------------------------------------------------
# usage : adi_hp_assign 1
#------------------------------------------------------------------------------
proc adi_hp_assign { hp_port hp_clk } {

  global sys_100m_resetn_source

  # check is hp port is enabled
  if { [get_property "CONFIG.PCW_USE_S_AXI_HP${hp_port}" [get_bd_cells sys_ps7]] == 1 } {
    #return the interconnect of the hp port
    set hp_net [get_bd_intf_nets -of_objects [get_bd_intf_pins "sys_ps7/S_AXI_HP${hp_port}"]]
    set hp_net_cells [get_bd_cells -of_obkects $hp_net]
    set idx [lsearch $hp_net_cells "/sys_ps7"]
    set ic_hp [lreplace $hp_net_cells $idx $idx]
  } else {
    set_property -dict [list "CONFIG.PCW_USE_S_AXI_HP${hp_port}" {1}] [get_bd_cells sys_ps7]

    set ic_hp "axi_hp${hp_port}_interconnect"
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $ic_hp
    set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells $ic_hp]

    connect_bd_intf_net -intf_net "${ic_hp}_m00_axi" \
      [get_bd_intf_pins "${ic_hp}/M00_AXI"] \
      [get_bd_intf_pins "sys_ps7/S_AXI_HP${hp_port}"]

    # connect interconnect clock and reset
    connect_bd_net [get_bd_pins "${ic_hp}/ACLK"] \
      [get_bd_pins "${ic_hp}/M00_ACLK"] \
      [get_bd_pins "sys_ps7/S_AXI_HP${hp_port}_ACLK"] \
      $hp_clk
    connect_bd_net [get_bd_pins "${ic_hp}/ARESETN"] \
      [get_bd_pins "${ic_hp}/M00_ARESETN"] \
      $sys_100m_resetn_source
  }

return $ic_hp
}

