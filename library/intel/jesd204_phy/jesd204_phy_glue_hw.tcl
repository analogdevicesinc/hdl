#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2017, Analog Devices, Inc.”
#

package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

#
# For whatever strange reason all the interface of the native PHY become
# conduits when it is instantiated in a compose callback. This glue logic module
# converts the interfaces to their proper type.
#

ad_ip_create jesd204_phy_glue {Native PHY to JESD204 glue logic} \
 jesd204_phy_glue_elab
set_module_property INTERNAL true

# files

ad_ip_files jesd204_glue [list \
  jesd204_phy_glue.v \
]

# parameters

ad_ip_parameter TX_OR_RX_N BOOLEAN false false
ad_ip_parameter SOFT_PCS BOOLEAN false false
ad_ip_parameter NUM_OF_LANES POSITIVE 4 true
ad_ip_parameter LANE_INVERT INTEGER 0 true
ad_ip_parameter WIDTH NATURAL 20 true { \
  DERIVED true \
}
ad_ip_parameter CONST_WIDTH NATURAL 1 true { \
  DERIVED true \
}

proc glue_add_if {num name type dir {bcast false}} {
  if {$bcast} {
    add_interface ${name} $type $dir
  } else {
    for {set i 0} {$i < $num} {incr i} {
      add_interface ${name}_${i} $type $dir
    }
  }
  add_interface phy_${name} conduit end
}

proc glue_add_if_port {num ifname port role dir width {bcast false}} {
  variable sig_offset

  set phy_width [expr $num * $width]
  if {$dir == "Input"} {
    set sig "in"
    set phy_dir "Output"
    set phy_sig "out"
  } else {
    set sig "out"
    set phy_dir "Input"
    set phy_sig "in"
  }

  if {$bcast} {
    add_interface_port ${ifname} ${port} $role $dir $width
    set_port_property ${port} fragment_list \
      [format "%s(%d:%d)" $sig [expr $sig_offset + $width - 1] $sig_offset]
  } else {
    for {set i 0} {$i < $num} {incr i} {
      set base [expr $sig_offset + $width * $i]

      add_interface_port ${ifname}_${i} ${port}_${i} $role $dir $width
      set_port_property ${port}_${i} fragment_list \
        [format "%s(%d:%d)" $sig [expr $base + $width - 1] $base]
    }
  }

  add_interface_port phy_${ifname} phy_${port} $role $phy_dir $phy_width

  if {$bcast} {
    set _frag [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $width - 1] $sig_offset]
    set sig_offset [expr $sig_offset + $width]
    set frag "${_frag}"
    for {set i 1} {$i < $num} {incr i} {
      set frag [concat ${frag} ${_frag}]
    }
  } else {
    set frag [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $phy_width - 1] $sig_offset]
    set sig_offset [expr $sig_offset + $phy_width]
  }

  set_port_property phy_${port} fragment_list $frag
}

proc glue_add_tx_serial_clk {num_of_lanes} {
  variable sig_offset

  # The serial clock is special. The first 6 transceivers use the x1 connection
  # since they are in the same bank as the PLL. The others have to use the xN
  # connection through the CGB.

  if {$num_of_lanes > 6} {
    set clk0_width 6
    set clk1_width [expr $num_of_lanes - 6]

  } else {
    set clk0_width $num_of_lanes
    set clk1_width 0
  }

  add_interface tx_serial_clk_x1 hssi_serial_clock sink
  add_interface_port tx_serial_clk_x1 tx_serial_clk_x1 clk Input 1
  set_port_property tx_serial_clk_x1 fragment_list \
    [format "in(%d:%d)" $sig_offset $sig_offset]

  add_interface phy_tx_serial_clk0 conduit end
  add_interface_port phy_tx_serial_clk0 phy_tx_serial_clk0 clk Output $num_of_lanes

  set _frag [format "out(%d:%d)" $sig_offset $sig_offset]
  set sig_offset [expr $sig_offset + 1]
  set frag "${_frag}"
  for {set i 1} {$i < $clk0_width} {incr i} {
    set frag [concat ${_frag} ${frag}]
  }

  if {$num_of_lanes > 6} {
    add_interface tx_serial_clk_xN hssi_serial_clock sink
    add_interface_port tx_serial_clk_xN tx_serial_clk_xN clk Input 1
    set_port_property tx_serial_clk_xN fragment_list \
      [format "in(%d:%d)" $sig_offset $sig_offset]

    set _frag [format "out(%d:%d)" $sig_offset $sig_offset]
    set sig_offset [expr $sig_offset + 1]
    for {set i 0} {$i < $clk1_width} {incr i} {
      set frag [concat ${_frag} ${frag}]
    }
  }

  set_port_property phy_tx_serial_clk0 fragment_list $frag
}

proc glue_add_if_port_conduit {num ifname port phy_port dir width} {
  variable sig_offset

  set phy_width [expr $num * $width]
  if {$dir == "Input"} {
    set sig "in"
    set phy_dir "Output"
    set phy_sig "out"
  } else {
    set sig "out"
    set phy_dir "Input"
    set phy_sig "in"
  }

  for {set i 0} {$i < $num} {incr i} {
    set base [expr $sig_offset + $width * $i]

    add_interface_port ${ifname}_${i} ${ifname}_${port}_${i} $port $dir $width
    set_port_property ${ifname}_${port}_${i} fragment_list \
      [format "%s(%d:%d)" $sig [expr $base + $width - 1] $base]
  }

  add_interface phy_${phy_port} conduit end
  add_interface_port phy_${phy_port} phy_${phy_port} $phy_port $phy_dir $phy_width

  set_port_property phy_${phy_port} fragment_list \
    [format "%s(%d:%d)" $phy_sig [expr $sig_offset + $phy_width - 1] $sig_offset]

  set sig_offset [expr $sig_offset + $phy_width]
}

proc glue_add_const_conduit {port width} {
  variable const_offset

  set ifname phy_${port}
  add_interface $ifname conduit end
  add_interface_port $ifname $ifname $port Output $width
  set_port_property $ifname fragment_list [format "const_out(%d:%d)" \
    [expr $const_offset + $width - 1] $const_offset]

  set const_offset [expr $const_offset + $width]
}

proc jesd204_phy_glue_elab {} {
  variable sig_offset
  variable const_offset

  set soft_pcs [get_parameter SOFT_PCS]
  set num_of_lanes [get_parameter NUM_OF_LANES]

  set sig_offset 0
  set const_offset 0

  glue_add_if $num_of_lanes reconfig_clk clock sink true
  glue_add_if_port $num_of_lanes reconfig_clk reconfig_clk clk Input 1 true

  glue_add_if $num_of_lanes reconfig_reset reset sink true
  glue_add_if_port $num_of_lanes reconfig_reset reconfig_reset reset Input 1 true

  glue_add_if $num_of_lanes reconfig_avmm avalon sink
  for {set i 0} {$i < $num_of_lanes} {incr i} {
    set_interface_property reconfig_avmm_${i} associatedClock reconfig_clk
    set_interface_property reconfig_avmm_${i} associatedReset reconfig_reset
  }
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_address address Input 10
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_read read Input 1
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_readdata readdata Output 32
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_waitrequest waitrequest Output 1
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_write write Input 1
  glue_add_if_port $num_of_lanes reconfig_avmm reconfig_writedata writedata Input 32

  if {[get_parameter TX_OR_RX_N]} {
    glue_add_if $num_of_lanes tx_clkout clock source
    glue_add_if_port $num_of_lanes tx_clkout tx_clkout clk Output 1

    glue_add_if $num_of_lanes tx_coreclkin clock sink true
    glue_add_if_port $num_of_lanes tx_coreclkin tx_coreclkin clk Input 1 true

    glue_add_tx_serial_clk $num_of_lanes

    if {$soft_pcs} {
      set unused_width [expr $num_of_lanes * 88]

      glue_add_const_conduit tx_enh_data_valid $num_of_lanes

      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface tx_raw_data_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes tx_raw_data raw_data tx_parallel_data Input 40
    } else {
      set unused_width [expr $num_of_lanes * 92]

      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface tx_phy_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes tx_phy char tx_parallel_data Input 32
      glue_add_if_port_conduit $num_of_lanes tx_phy charisk tx_datak Input 4
    }

    glue_add_const_conduit unused_tx_parallel_data $unused_width

    add_interface phy_tx_polinv conduit end
    add_interface_port phy_tx_polinv polinv tx_polinv Output $num_of_lanes
    set_port_property polinv TERMINATION $soft_pcs
  } else {
    glue_add_if 1 rx_cdr_refclk0 clock sink true
    glue_add_if_port 1 rx_cdr_refclk0 rx_cdr_refclk0 clk Input 1 true

    glue_add_if $num_of_lanes rx_coreclkin clock sink true
    glue_add_if_port $num_of_lanes rx_coreclkin rx_coreclkin clk Input 1 true

    glue_add_if $num_of_lanes rx_clkout clock source
    glue_add_if_port $num_of_lanes rx_clkout rx_clkout clk Output 1

    if {$soft_pcs} {
      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface rx_raw_data_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes rx_raw_data raw_data rx_parallel_data Output 40
    } else {
      for {set i 0} {$i < $num_of_lanes} {incr i} {
        add_interface rx_phy_${i} conduit start
      }
      glue_add_if_port_conduit $num_of_lanes rx_phy char rx_parallel_data Output 32
      glue_add_if_port_conduit $num_of_lanes rx_phy charisk rx_datak Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy disperr rx_disperr Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy notintable rx_errdetect Output 4
      glue_add_if_port_conduit $num_of_lanes rx_phy patternalign_en rx_std_wa_patternalign Input 1
    }

    add_interface const_out conduit end
    add_interface_port const_out const_out const_out Output 1
    set_port_property const_out TERMINATION true
    set const_offset 1

    add_interface phy_rx_polinv conduit end
    add_interface_port phy_rx_polinv polinv rx_polinv Output $num_of_lanes
    set_port_property polinv TERMINATION $soft_pcs
  }

  set_interface_property reconfig_reset associatedClock reconfig_clk
  set_interface_property reconfig_reset synchronousEdges DEASSERT

  set_parameter_value WIDTH $sig_offset
  set_parameter_value CONST_WIDTH $const_offset
}
