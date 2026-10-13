###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

set ::LANES_PER_QUAD 4
set ::VERSAL_XCVR_SCRIPT_DIR [file dirname [file normalize [info script]]]

# Returns the gtwiz_versal settings dict for one line-rate configuration.
proc versal_xcvr_lr_settings {jesd_mode rx_rate tx_rate ref_clock transceiver {comma_align fabric}} {
  set is_64b66b                [expr {$jesd_mode == "64B66B"}]
  set clk_divider              [expr {$is_64b66b ? 66 : 40}]
  set datapath_width           [expr {$is_64b66b ? 64 : 32}]
  set internal_datapath_width  [expr {$is_64b66b ? 64 : 40}]
  set data_encoding            [expr {$is_64b66b ? "64B66B_ASYNC" : "8B10B"}]
  if {$transceiver == "GTM"} {
    set clk_divider            [expr {$is_64b66b ? 64 : 40}]
  }

  set rx_progdiv_clock [format %.3f [expr {$rx_rate * 1000.0 / $clk_divider}]]
  set tx_progdiv_clock [format %.3f [expr {$tx_rate * 1000.0 / $clk_divider}]]

  set p [dict create]
  dict set p RX_LINE_RATE $rx_rate
  dict set p RX_DATA_DECODING [expr {$transceiver != "GTM" ? $data_encoding : "RAW"}]
  dict set p RX_USER_DATA_WIDTH [expr {$transceiver != "GTM" ? $datapath_width : $internal_datapath_width}]
  dict set p RX_REFCLK_FREQUENCY $ref_clock
  if {$transceiver != "GTM"} {
    dict set p RX_INT_DATA_WIDTH $internal_datapath_width
  }
  dict set p RX_OUTCLK_SOURCE {RXPROGDIVCLK}
  dict set p RXRECCLK_FREQ_VAL $rx_progdiv_clock
  dict set p RXPROGDIV_FREQ_VAL $rx_progdiv_clock
  dict set p RX_PLL_TYPE {LCPLL}
  # comma_align "gt": the GT aligns on commas (enabled through the quad GPI);
  # "fabric": RXSLIDE driven by lane_align (deprecated subsystem path).
  if {!$is_64b66b} {
    set gt_align [expr {$comma_align == "gt"}]
    dict set p RX_COMMA_P_ENABLE [expr {$gt_align ? "true" : "false"}]
    dict set p RX_COMMA_M_ENABLE [expr {$gt_align ? "true" : "false"}]
    dict set p RX_COMMA_SHOW_REALIGN_ENABLE {false}
    dict set p RX_SLIDE_MODE [expr {$gt_align ? "OFF" : "PCS"}]
  }

  dict set p TX_LINE_RATE $tx_rate
  dict set p TX_DATA_ENCODING [expr {$transceiver != "GTM" ? $data_encoding : "RAW"}]
  dict set p TX_USER_DATA_WIDTH [expr {$transceiver != "GTM" ? $datapath_width : $internal_datapath_width}]
  dict set p TX_REFCLK_FREQUENCY $ref_clock
  if {$transceiver != "GTM"} {
    dict set p TX_INT_DATA_WIDTH $internal_datapath_width
  }
  dict set p TX_OUTCLK_SOURCE {TXPROGDIVCLK}
  dict set p TXPROGDIV_FREQ_VAL $tx_progdiv_clock
  dict set p TX_PLL_TYPE {LCPLL}
  return $p
}

# Returns the CONFIG.* dict for a gtwiz_versal instance. rx_rates/tx_rates
# are lists; entry N becomes line-rate configuration LR<N>, selected at run
# time through ch_rxrate/ch_txrate.
proc versal_xcvr_wizard_params {jesd_mode rx_no_lanes tx_no_lanes rx_rates tx_rates ref_clock transceiver direction {comma_align fabric}} {
  global LANES_PER_QUAD

  if {$jesd_mode ni {64B66B 8B10B}} {
    error "Invalid jesd_mode '$jesd_mode'. Must be 64B66B or 8B10B."
  }
  if {$direction ni {RXTX RX TX}} {
    error "Invalid direction '$direction'. Must be RXTX, RX, or TX."
  }
  if {$transceiver ni {GTY GTYP GTM}} {
    error "Invalid transceiver '$transceiver'. Must be GTY, GTYP or GTM."
  }
  if {[llength $rx_rates] == 0} {set rx_rates $tx_rates}
  if {[llength $tx_rates] == 0} {set tx_rates $rx_rates}
  set num_rates [expr {max([llength $rx_rates], [llength $tx_rates])}]
  if {$num_rates < 1 || $num_rates > 8} {
    error "Between 1 and 8 lane rates are supported, got $num_rates."
  }

  set preset ${transceiver}-JESD204_${jesd_mode}
  if {$transceiver == "GTM"} {
    set preset ${transceiver}-NRZ_JESD
  }

  set gt_settings [dict create]
  for {set n 0} {$n < $num_rates} {incr n} {
    set rx_rate [lindex $rx_rates [expr {min($n, [llength $rx_rates] - 1)}]]
    set tx_rate [lindex $tx_rates [expr {min($n, [llength $tx_rates] - 1)}]]
    set lr [versal_xcvr_lr_settings $jesd_mode $rx_rate $tx_rate $ref_clock $transceiver $comma_align]
    # With RXRECCLK_FREQ_VAL in more than one LR the wizard generates
    # RXOUTCLK_FREQ = inf for the quads; RXRECCLKOUT is unused.
    if {$n > 0} {
      dict unset lr RXRECCLK_FREQ_VAL
    }
    dict set gt_settings LR${n}_SETTINGS $lr
  }

  if {$direction == "RXTX"} {
    set no_lanes [expr {max($rx_no_lanes, $tx_no_lanes)}]
  } elseif {$direction == "RX"} {
    set no_lanes $rx_no_lanes
  } else {
    set no_lanes $tx_no_lanes
  }
  set num_quads [expr {int(ceil(1.0 * $no_lanes / $LANES_PER_QUAD))}]

  set phy_params [dict create]
  dict set phy_params CONFIG.ENABLE_REG_INTERFACE {true}
  dict set phy_params CONFIG.REG_CONF_INTF {AXI_LITE}
  dict set phy_params CONFIG.GT_TYPE ${transceiver}
  dict set phy_params CONFIG.NO_OF_QUADS ${num_quads}
  dict set phy_params CONFIG.NO_OF_INTERFACE {1}
  dict set phy_params CONFIG.LOCATE_BUFG {EXAMPLE_DESIGN}
  dict set phy_params CONFIG.INTF0_PRESET ${preset}
  dict set phy_params CONFIG.INTF0_GT_SETTINGS $gt_settings
  if {$direction != "RXTX"} {
    dict set phy_params CONFIG.INTF0_GT_DIRECTION SIMPLEX_${direction}
    dict set phy_params CONFIG.INTF0_NO_OF_LANES ${no_lanes}
  } else {
    # Two interfaces so RX and TX can have different lane counts:
    # interface 0 is RX, interface 1 is TX.
    dict set phy_params CONFIG.NO_OF_INTERFACE {2}
    dict set phy_params CONFIG.INTF0_GT_DIRECTION {SIMPLEX_RX}
    dict set phy_params CONFIG.INTF1_GT_DIRECTION {SIMPLEX_TX}
    dict set phy_params CONFIG.INTF0_NO_OF_LANES $rx_no_lanes
    dict set phy_params CONFIG.INTF1_NO_OF_LANES $tx_no_lanes
    dict set phy_params CONFIG.INTF1_PRESET ${preset}
    dict set phy_params CONFIG.INTF1_GT_SETTINGS $gt_settings
  }

  if {$direction != "RXTX"} {
    dict set phy_params "CONFIG.QUAD0_${direction}0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_PROT0_${direction}MSTCLK" ${direction}0
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_${direction}${lane_idx}_EN" [expr {$i < $no_lanes}]
    }
    for {set i 0} {$i < $num_quads} {incr i} {
      dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" [expr {min($LANES_PER_QUAD, max(0, $no_lanes - $LANES_PER_QUAD * $i))}]
    }
  } else {
    dict set phy_params "CONFIG.QUAD0_RX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_TX0_OUTCLK_EN" {true}
    dict set phy_params "CONFIG.QUAD0_PROT0_RXMSTCLK" {RX0}
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr {min($LANES_PER_QUAD, max(0, $rx_no_lanes - $LANES_PER_QUAD * $i))}]
      if {$lanes != 0} {
        dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" ${lanes}
        dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {1}
      }
    }
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      dict set phy_params "CONFIG.QUAD${quad_idx}_PROT0_RX${lane_idx}_EN" [expr {$i < $rx_no_lanes}]
    }

    dict set phy_params "CONFIG.QUAD0_PROT1_TXMSTCLK" {TX0}
    for {set i 0} {$i < $num_quads} {incr i} {
      set lanes [expr {min($LANES_PER_QUAD, max(0, $tx_no_lanes - $LANES_PER_QUAD * $i))}]
      if {$lanes != 0} {
        if {[dict exists $phy_params "CONFIG.QUAD${i}_PROT0_LANES"]} {
          dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {2}
          dict set phy_params "CONFIG.QUAD${i}_PROT1_LANES" ${lanes}
        } else {
          dict set phy_params "CONFIG.QUAD${i}_NO_PROT" {1}
          dict set phy_params "CONFIG.QUAD${i}_PROT0" {INTF1}
          dict set phy_params "CONFIG.QUAD${i}_PROT0_LANES" ${lanes}
        }
      }
    }
    for {set i 0} {$i < [expr {$LANES_PER_QUAD * $num_quads}]} {incr i} {
      set quad_idx [expr {$i / $LANES_PER_QUAD}]
      set lane_idx [expr {$i % $LANES_PER_QUAD}]
      if {[dict exists $phy_params "CONFIG.QUAD${quad_idx}_NO_PROT"]} {
        set prot_idx [expr {[dict get $phy_params "CONFIG.QUAD${quad_idx}_NO_PROT"] - 1}]
        dict set phy_params "CONFIG.QUAD${quad_idx}_PROT${prot_idx}_TX${lane_idx}_EN" [expr {$i < $tx_no_lanes}]
      }
    }
  }

  for {set i 0} {$i < $num_quads} {incr i} {
    set lanes_in_quad [expr {min($LANES_PER_QUAD, max(0, $no_lanes - $LANES_PER_QUAD * $i))}]
    set needs_hsclk1 [expr {$lanes_in_quad > 2}]
    for {set j 0} {$j < $lanes_in_quad} {incr j} {
      dict set phy_params "CONFIG.QUAD${i}_CH${j}_ILORESET_EN" {true}
    }
    dict set phy_params "CONFIG.QUAD${i}_HSCLK0_LCPLLRESET_EN" {true}
    dict set phy_params "CONFIG.QUAD${i}_HSCLK1_LCPLLRESET_EN" $needs_hsclk1
    dict set phy_params "CONFIG.QUAD${i}_HSCLK0_LCPLL_LOCK_EN" {true}
    dict set phy_params "CONFIG.QUAD${i}_HSCLK1_LCPLL_LOCK_EN" $needs_hsclk1
    if {$comma_align == "gt" && $jesd_mode == "8B10B"} {
      dict set phy_params "CONFIG.QUAD${i}_GT_GPIO_EN" {true}
    }
  }

  return $phy_params
}

# Channel ports util_adxcvr drives or reads beyond the preset's defaults, per
# GT type and direction (RX/TX). The GTM Wizard has no LPM, eye scan reset,
# RX slide, 8B/10B control or TX swing ports.
proc versal_xcvr_optional_ports {transceiver dir} {
  set ports {
    GTY,RX {ch_rxprbssel ch_rxprbscntreset ch_rxprbserr ch_rxprbslocked ch_rxlpmen ch_rxpolarity
            ch_rxbufstatus ch_rxresetdone ch_eyescanreset ch_rxslide ch_rxctrl0 ch_rxctrl1
            ch_rxctrl2 ch_rxctrl3}
    GTY,TX {ch_txprbssel ch_txprbsforceerr ch_txdiffctrl ch_txpostcursor ch_txprecursor
            ch_txpolarity ch_txbufstatus ch_txresetdone ch_txctrl0 ch_txctrl1 ch_txctrl2}
    GTM,RX {ch_rxprbssel ch_rxprbscntreset ch_rxprbserr ch_rxprbslocked ch_rxpolarity
            ch_rxbufstatus ch_rxresetdone}
    GTM,TX {ch_txprbssel ch_txprbsforceerr ch_txpostcursor ch_txprecursor ch_txpolarity
            ch_txbufstatus ch_txresetdone}
  }
  set t [expr {$transceiver eq "GTYP" ? "GTY" : $transceiver}]
  return [string trim [regsub -all {\s+} [dict get $ports $t,$dir] " "]]
}

# Attributes the Wizard sets per quad position; all others must match quad 0.
set ::VERSAL_QUAD_POS_ATTRS {RXRSTDONE_DIST_SEL TXRSTDONE_DIST_SEL}
foreach c {0 1 2 3} {
  foreach a {PIPE_CTRL_CFG1 PIPE_CTRL_CFG6 PIPE_CTRL_CFG9 RX_PHALIGN_CFG0 RX_PHALIGN_CFG1
      TX_PHALIGN_CFG0 TX_PHALIGN_CFG1} {
    lappend ::VERSAL_QUAD_POS_ATTRS CH${c}_$a
  }
}

# Runs the Wizard for one link and writes quad<N>.attr (NAME VALUE per line,
# from the generated quad rules) and quad<N>.mem. Needs no open project.
proc versal_xcvr_extract_attributes {out_dir jesd_mode rx_lanes tx_lanes rx_rates tx_rates ref_clock transceiver {part ""}} {
  if {$part eq ""} {
    set part [dict get {GTY xcvc1902-vsva2197-2MP-e-S GTYP xcvp1802-lsvc4072-2MP-e-S GTM xcvp1802-lsvc4072-2MP-e-S} $transceiver]
  }
  set direction [expr {$rx_lanes > 0 && $tx_lanes > 0 ? "RXTX" : ($rx_lanes > 0 ? "RX" : "TX")}]
  set comma_align [expr {$jesd_mode eq "8B10B" ? "gt" : "fabric"}]
  set work [file join $out_dir .work]
  file delete -force $work
  file mkdir $out_dir
  create_project wiz $work -part $part -force
  create_ip -name gtwiz_versal -vendor xilinx.com -library ip -module_name wiz
  set_property -dict [versal_xcvr_wizard_params $jesd_mode $rx_lanes $tx_lanes $rx_rates $tx_rates \
    $ref_clock $transceiver $direction $comma_align] [get_ips wiz]
  set intf 0
  foreach {lanes ports} [list $rx_lanes [versal_xcvr_optional_ports $transceiver RX] \
                              $tx_lanes [versal_xcvr_optional_ports $transceiver TX]] {
    if {$lanes == 0} continue
    set d {}
    foreach x $ports { lappend d $x true }
    set_property CONFIG.INTF${intf}_OPTIONAL_PORTS $d [get_ips wiz]
    incr intf
  }
  generate_target {synthesis} [get_ips wiz]
  set gen [file join $work wiz.gen sources_1 ip wiz]
  set n 0
  while {[file exists [file join $gen ip_$n wiz_gt_quad_base_${n}_rules_output.vh]]} {
    set fh [open [file join $gen ip_$n wiz_gt_quad_base_${n}_rules_output.vh]]
    set rules [read $fh]
    close $fh
    set lines {}
    set local {}
    foreach {- range name value} [regexp -all -inline {localparam\s+(\[[^\]]*\]\s*)?(\w+)\s*=\s*([^;]+);} $rules] {
      if {$name eq "MEMORY_INIT_FILE"} continue
      set range [string trim $range]
      set value [string trim $value]
      if {![versal_xcvr_rules_literal $range $value]} {
        lappend local [versal_xcvr_local_entry $range $name $value]
        continue
      }
      regsub {^'d} $value {} value
      lappend lines "$name [string trim $value \"]"
    }
    set fh [open [file join $out_dir quad$n.attr] w]
    puts $fh [join $lines "\n"]
    close $fh
    set fh [open [file join $out_dir quad$n.local] w]
    puts -nonewline $fh [join [lmap l $local { string cat $l "\n" }] ""]
    close $fh
    file copy -force [file join $gen ip_$n wiz_gt_quad_base_$n.mem] [file join $out_dir quad$n.mem]
    incr n
  }
  close_project
  file delete -force $work
  if {$n == 0} {
    error "ERROR: versal_xcvr_extract_attributes: the Wizard generated no quads"
  }
  return $n
}

# A Wizard rules entry (localparam [range] name = value) is a quad attribute
# when it is untyped with a literal value; otherwise it is bookkeeping computed
# from other settings (GTM: UB_CFG0, simulation reset speed-up) that stays
# inside the quad base. versal_xcvr_local_entry gives such an entry as one
# "NAME [range] value" line, whitespace collapsed, for comparing the Wizard
# output with the quad base (versal_gen/<type>/wizard_local.txt).
proc versal_xcvr_rules_literal {range value} {
  expr {$range eq "" && [regexp {^(\d*'[bhdBHD][0-9a-fA-F_]+|"[^"]*"|-?\d+(\.\d+)?)$} $value]}
}

proc versal_xcvr_local_entry {range name value} {
  return [regsub -all {\s+} [string trim "$name $range $value"] " "]
}

# Same as versal_xcvr_extract_attributes, in a child Vivado so it can run
# while a project is open. Reuses out_dir when it holds the same configuration.
proc versal_xcvr_run_extraction {out_dir jesd_mode rx_lanes tx_lanes rx_rates tx_rates ref_clock transceiver {part ""}} {
  set key [list [version -short] attr2 $jesd_mode $rx_lanes $tx_lanes $rx_rates $tx_rates $ref_clock $transceiver $part]
  set key_file [file join $out_dir config.txt]
  if {[file exists $key_file]} {
    set fh [open $key_file]
    set old [string trim [read $fh]]
    close $fh
    if {$old eq $key} {
      return [llength [glob -nocomplain [file join $out_dir quad*.attr]]]
    }
  }
  file delete -force $out_dir
  file mkdir $out_dir
  set script [file join $::VERSAL_XCVR_SCRIPT_DIR adi_xcvr_versal_extract.tcl]
  exec [file join $::env(XILINX_VIVADO) bin vivado] -mode batch -nojournal -nolog \
    -log [file join $out_dir extract.log] -source $script \
    -tclargs $out_dir $jesd_mode $rx_lanes $tx_lanes $rx_rates $tx_rates $ref_clock $transceiver $part
  set fh [open $key_file w]
  puts $fh $key
  close $fh
  return [llength [glob -nocomplain [file join $out_dir quad*.attr]]]
}

# util_adxcvr CONFIG values. quad_files: 8 entries, {} for an unused quad or
# {<attr file> <mem file>}. QA_<attr> from the first used quad, Q<n>_<attr>
# for the per-quad attributes of every used quad, QUAD<n>_MEM_FILE.
# The packed attribute list (written by the util_adxcvr generator): one entry
# per attribute, {scope idx name kind types width default}; scope shared/quad,
# kind vec (32-bit slot idx of QA_ATTRS / Q<n>_ATTRS, width in bits), str or
# real (own parameter, width -).
proc versal_xcvr_attribute_list {} {
  if {![info exists ::VERSAL_XCVR_PACKED]} {
    set fh [open [file join $::VERSAL_XCVR_SCRIPT_DIR adi_xcvr_versal_packed.txt]]
    set ::VERSAL_XCVR_PACKED {}
    foreach line [split [string trim [read $fh]] "\n"] {
      lappend ::VERSAL_XCVR_PACKED [list {*}$line]
    }
    close $fh
  }
  return $::VERSAL_XCVR_PACKED
}

proc versal_xcvr_type_tag {transceiver} {
  return [dict get {GTY gty GTYP gtyp GTM gtm} $transceiver]
}

# Number from a Wizard (decimal) or Verilog (<w>'h/'b/'d) literal.
proc versal_xcvr_number {v} {
  if {[regexp {^(\d*)'([bhdBHD])([0-9a-fA-F_]+)$} $v -> - base digits]} {
    set digits [string map {_ {}} $digits]
    switch -nocase $base {
      h { return [expr "0x$digits"] }
      b { return [expr "0b$digits"] }
      d { return [expr {$digits + 0}] }
    }
  }
  return [expr {$v + 0}]
}

# The slot value of a bit-vector attribute from file f; it must fit the
# attribute (0 .. 2^width-1, a 32-bit attribute also negative integers).
proc versal_xcvr_slot {name v width f} {
  set n [versal_xcvr_number $v]
  set lo [expr {$width >= 32 ? -(1 << 31) : 0}]
  if {$n < $lo || $n >= (1 << $width)} {
    error "ERROR: versal_xcvr_attribute_params: $name of $f is $v, wider than $width bit(s)"
  }
  return $n
}

proc versal_xcvr_pack {slots} {
  set hex ""
  for {set i [expr {[llength $slots] - 1}]} {$i >= 0} {incr i -1} {
    append hex [format %08X [expr {[lindex $slots $i] & 0xffffffff}]]
  }
  return "[expr {[llength $slots] * 32}]'h$hex"
}

# util_adxcvr parameters for the quads: the Wizard attributes of quad n are in
# the n-th {attr_file mem_file} pair ({} for an unused quad); the attributes
# outside the per-quad set must match between quads.
# The Wizard entries the quad base keeps as local parameters
# (versal_xcvr_local_entry) must be the ones util_adxcvr was built with.
# Attribute files without a .local file (not from versal_xcvr_extract_attributes)
# are not checked.
proc versal_xcvr_check_local {attr_file transceiver} {
  set local_file "[file rootname $attr_file].local"
  if {![file exists $local_file]} return
  set ref_file [file join $::VERSAL_XCVR_SCRIPT_DIR .. util_adxcvr versal_gen \
    [string tolower $transceiver] wizard_local.txt]
  if {![file exists $ref_file]} {
    error "ERROR: versal_xcvr_attribute_params: $ref_file missing, package util_adxcvr"
  }
  foreach {var f} [list got $local_file want $ref_file] {
    set fh [open $f]
    set $var [dict create]
    foreach line [split [string trim [read $fh]] "\n"] {
      if {$line ne ""} { dict set $var [lindex [split $line] 0] [join [lrange [split $line] 1 end]] }
    }
    close $fh
  }
  dict for {k v} $want {
    if {![dict exists $got $k]} {
      error "ERROR: versal_xcvr_attribute_params: $k missing from $local_file"
    }
    if {[dict get $got $k] ne $v} {
      error "ERROR: versal_xcvr_attribute_params: $k of $attr_file is [dict get $got $k], util_adxcvr has $v (kept inside the $transceiver quad base)"
    }
  }
  dict for {k v} $got {
    if {![dict exists $want $k]} {
      error "ERROR: versal_xcvr_attribute_params: $k of $attr_file is not in the $transceiver quad base ($ref_file)"
    }
  }
}

proc versal_xcvr_attribute_params {quad_files {transceiver GTY}} {
  set tag [versal_xcvr_type_tag $transceiver]
  set known [dict create]
  set nshared 0
  set nquad 0
  foreach e [versal_xcvr_attribute_list] {
    lassign $e scope idx name kind types width default
    dict set known $name $e
    if {$kind eq "vec"} {
      if {$scope eq "shared"} { set nshared [expr {max($nshared, $idx + 1)}] } else { set nquad [expr {max($nquad, $idx + 1)}] }
    }
  }
  set d [dict create]
  set ref -1
  for {set n 0} {$n < [llength $quad_files]} {incr n} {
    set e [lindex $quad_files $n]
    if {$e eq {}} continue
    lassign $e attr_file mem_file
    set fh [open $attr_file]
    set q [dict create]
    foreach line [split [string trim [read $fh]] "\n"] {
      dict set q [lindex $line 0] [lrange $line 1 end]
    }
    close $fh
    dict for {k v} $q {
      if {![dict exists $known $k]} {
        error "ERROR: versal_xcvr_attribute_params: $k from $attr_file is not a util_adxcvr attribute"
      }
      if {[lsearch -exact [split [lindex [dict get $known $k] 4] ,] $tag] < 0} {
        error "ERROR: versal_xcvr_attribute_params: $k from $attr_file is not a $transceiver attribute"
      }
    }
    versal_xcvr_check_local $attr_file $transceiver
    dict for {k e} $known {
      if {[lsearch -exact [split [lindex $e 4] ,] $tag] >= 0 && ![dict exists $q $k]} {
        error "ERROR: versal_xcvr_attribute_params: $k missing from $attr_file"
      }
    }
    if {$ref < 0} {
      set ref $n
      set q0 $q
    } else {
      dict for {k v} $q {
        if {[lindex [dict get $known $k] 0] ne "quad" && $v ne [dict get $q0 $k]} {
          error "ERROR: versal_xcvr_attribute_params: $k differs between quad$ref and quad$n"
        }
      }
    }
    set slots [lrepeat [expr {max($nquad, 1)}] 0]
    dict for {k e} $known {
      lassign $e scope idx name kind types width default
      if {$scope ne "quad"} continue
      set v [expr {[dict exists $q $k] ? [dict get $q $k] : $default}]
      if {$kind eq "vec"} {
        lset slots $idx [versal_xcvr_slot $k $v $width $attr_file]
      } elseif {[dict exists $q $k]} {
        dict set d CONFIG.Q${n}_$k $v
      }
    }
    dict set d CONFIG.Q${n}_ATTRS [versal_xcvr_pack $slots]
    dict set d CONFIG.QUAD${n}_MEM_FILE [file normalize $mem_file]
  }
  if {$ref >= 0} {
    set slots [lrepeat [expr {max($nshared, 1)}] 0]
    dict for {k e} $known {
      lassign $e scope idx name kind types width default
      if {$scope ne "shared"} continue
      set v [expr {[dict exists $q0 $k] ? [dict get $q0 $k] : $default}]
      if {$kind eq "vec"} {
        lset slots $idx [versal_xcvr_slot $k $v $width [lindex $quad_files $ref 0]]
      } elseif {[dict exists $q0 $k]} {
        dict set d CONFIG.QA_$k $v
      }
    }
    dict set d CONFIG.QA_ATTRS [versal_xcvr_pack $slots]
  }
  return $d
}

# Attribute values from util_adxcvr parameters ({CONFIG.<name> value ...}):
# {QA_<attr> value Q<n>_<attr> value ...}, vectors as 32'h literals; only the
# attributes of the GT type and the quads with a QUAD<n>_MEM_FILE.
proc versal_xcvr_unpack_dict {params {transceiver GTY}} {
  set tag [versal_xcvr_type_tag $transceiver]
  set used {}
  for {set q 0} {$q < 8} {incr q} {
    set k CONFIG.QUAD${q}_MEM_FILE
    if {[dict exists $params $k] && [dict get $params $k] ni {NONE ""}} { lappend used Q$q }
  }
  set out [dict create]
  set vec [dict create]
  foreach k [dict keys $params CONFIG.Q*_ATTRS] {
    regexp {^CONFIG\.(Q[A0-9])_ATTRS$} $k -> pre
    # set as <bits>'h<hex>, read back from a cell as 0x<hex>
    regsub {^(\d+'[hH]|0[xX])} [dict get $params $k] {} h
    dict set vec $pre $h
  }
  foreach e [versal_xcvr_attribute_list] {
    lassign $e scope idx name kind types width default
    if {[lsearch -exact [split $types ,] $tag] < 0} continue
    set pres [expr {$scope eq "shared" ? {QA} : $used}]
    foreach pre $pres {
      if {$kind eq "vec"} {
        if {![dict exists $vec $pre]} continue
        set h [dict get $vec $pre]
        set e1 [expr {[string length $h] - 8 * $idx}]
        if {$e1 < 8} continue
        dict set out ${pre}_$name "32'h[string range $h [expr {$e1 - 8}] [expr {$e1 - 1}]]"
      } elseif {[dict exists $params CONFIG.${pre}_$name]} {
        dict set out ${pre}_$name [dict get $params CONFIG.${pre}_$name]
      }
    }
  }
  return $out
}

proc versal_xcvr_unpack {cell} {
  set c [get_bd_cells $cell]
  set p [dict create]
  foreach k [list_property $c CONFIG.Q*] { dict set p $k [get_property $k $c] }
  set transceiver [dict get {11 GTY 12 GTYP 13 GTM} [get_property CONFIG.XCVR_TYPE $c]]
  return [versal_xcvr_unpack_dict $p $transceiver]
}

# Attribute values equal: numbers by value, reals numerically, else as text.
proc versal_xcvr_value_eq {a b} {
  set a [string trim $a \"]
  set b [string trim $b \"]
  if {[catch {set na [versal_xcvr_number $a]}] == 0 && [catch {set nb [versal_xcvr_number $b]}] == 0 &&
      [string is wideinteger -strict $na] && [string is wideinteger -strict $nb]} {
    return [expr {($na & 0xffffffff) == ($nb & 0xffffffff)}]
  }
  if {[string is double -strict $a] && [string is double -strict $b]} {
    return [expr {abs($a - $b) < 1e-9}]
  }
  return [expr {$a eq $b}]
}

# Per-quad lane counts from the physical slots each direction uses. Within a
# quad the used channels must start at 0 (the Wizard packs them).
proc versal_xcvr_quad_lanes {rx_slots tx_slots} {
  set d [dict create]
  foreach dir {rx tx} slots [list $rx_slots $tx_slots] {
    set used [lrepeat 32 0]
    foreach s $slots {
      if {$s < 0 || $s > 31} {
        error "ERROR: versal_xcvr_quad_lanes: [string toupper $dir] slot $s out of range"
      }
      if {[lindex $used $s]} {
        error "ERROR: versal_xcvr_quad_lanes: [string toupper $dir] slot $s used twice"
      }
      lset used $s 1
    }
    set counts {}
    for {set q 0} {$q < 8} {incr q} {
      set c 0
      while {$c < 4 && [lindex $used [expr {4 * $q + $c}]]} { incr c }
      for {set k $c} {$k < 4} {incr k} {
        if {[lindex $used [expr {4 * $q + $k}]]} {
          error "ERROR: versal_xcvr_quad_lanes: quad $q [string toupper $dir]: holes within a quad are not supported"
        }
      }
      lappend counts $c
    }
    dict set d $dir $counts
  }
  return $d
}

# 1 if both directions use the Wizard's packing of their totals.
proc versal_xcvr_is_packing {rx_counts tx_counts} {
  foreach counts [list $rx_counts $tx_counts] {
    set total [::tcl::mathop::+ {*}$counts]
    for {set q 0} {$q < 8} {incr q} {
      set want [expr {min(4, max(0, $total - 4 * $q))}]
      if {[lindex $counts $q] != $want} { return 0 }
    }
  }
  return 1
}

# LANE_SLOTS value for axi_adxcvr: logical lane i's slot in bits [8i+7:8i].
proc versal_xcvr_lane_slots_hex {slots} {
  set hex ""
  for {set i 31} {$i >= 0} {incr i -1} {
    append hex [format %02x [expr {$i < [llength $slots] ? [lindex $slots $i] : 0}]]
  }
  return "256'h$hex"
}

proc ad_xcvr_versal_rates {cell dir} {
  set rates [string map {, " "} [get_property CONFIG.${dir}_LANE_RATES $cell]]
  if {[llength $rates] == 0} {
    set rates [list [get_property CONFIG.${dir}_LANE_RATE $cell]]
  }
  return $rates
}

# Copies the util_adxcvr configuration that axi_adxcvr reports to software,
# decides which axi_adxcvr PLL reset owns the shared LCPLLs and records the
# transceiver slots this link uses (slot = quad * 4 + channel).
proc ad_xcvr_versal_prepare {u_xcvr a_xcvr tx_or_rx_n qpll_enable slots index} {
  global xcvr_versal_qpll_owner
  global xcvr_versal_slots

  if {[llength $slots] == 0} {
    error "ERROR: ad_xcvr_versal_prepare: $a_xcvr has no lanes"
  }
  set base [expr {$index / 4 * 4}]
  set rel {}
  foreach s $slots {
    if {$s < $base} {
      error "ERROR: ad_xcvr_versal_prepare: $a_xcvr: slot $s is below quad [expr {$base / 4}], the first quad of this link"
    }
    lappend rel [expr {$s - $base}]
  }

  set cell [get_bd_cells $u_xcvr]
  set rates [ad_xcvr_versal_rates $cell [expr {$tx_or_rx_n ? "TX" : "RX"}]]
  if {[llength $rates] > 8} {
    error "ERROR: $u_xcvr: at most 8 lane rates are supported"
  }
  set hex ""
  for {set n 7} {$n >= 0} {incr n -1} {
    set khz [expr {$n < [llength $rates] ? int(round([lindex $rates $n] * 1000000.0)) : 0}]
    append hex [format %08x $khz]
  }
  ad_ip_parameter $a_xcvr CONFIG.XCVR_TYPE [get_property CONFIG.XCVR_TYPE $cell]
  ad_ip_parameter $a_xcvr CONFIG.NUM_RATES [llength $rates]
  ad_ip_parameter $a_xcvr CONFIG.LANE_RATES_KHZ "256'h$hex"
  ad_ip_parameter $a_xcvr CONFIG.REF_CLK_KHZ [expr {int(round([get_property CONFIG.REF_CLK_RATE $cell] * 1000))}]

  if {$qpll_enable == 1} {
    set xcvr_versal_qpll_owner($u_xcvr) 1
  }
  ad_ip_parameter $u_xcvr CONFIG.PLL_RST_SEL [expr {[info exists xcvr_versal_qpll_owner($u_xcvr)] ? 0 : 1}]
  ad_ip_parameter $a_xcvr CONFIG.NUM_OF_QUADS [expr {[::tcl::mathfunc::max {*}$rel] / 4 + 1}]
  ad_ip_parameter $a_xcvr CONFIG.LANE_SLOTS [versal_xcvr_lane_slots_hex $rel]
  lappend xcvr_versal_slots($u_xcvr,[expr {$tx_or_rx_n ? "tx" : "rx"}]) {*}$slots
}

# Configures the quad primitives of every Versal util_adxcvr connected by
# ad_xcvrcon, once both directions are known (called after system_bd.tcl):
# per-quad lane counts from the recorded slots, then the Wizard's attributes
# for the whole link (chained) or per quad shape (independent).
# GTM: Vivado adds the data of the part's restricted lanes to the quad firmware
# during implementation, in the .mem files the design holds as STATIC MEMORY
# FILE scoped to the quad cell, as the Wizard's quad IP does; without them DRC
# GTMCHK-6 stops write_device_image. Each used quad gets its own copy in
# base_dir; returns quad_files with those copies.
proc versal_xcvr_gtm_mem_files {cell base_dir quad_files} {
  set ref [get_property CONFIG.Component_Name $cell]
  set old [get_files -quiet -all -filter "FILE_TYPE == {STATIC MEMORY FILE} && SCOPED_TO_REF == $ref"]
  if {$old ne ""} {
    remove_files $old
  }
  file mkdir $base_dir
  for {set q 0} {$q < [llength $quad_files]} {incr q} {
    set e [lindex $quad_files $q]
    if {$e eq {}} continue
    set mem [file join $base_dir quad$q.mem]
    file copy -force [lindex $e 1] $mem
    # base_dir belongs to the util_adxcvr cell name: the last finalize owns it
    set old [get_files -quiet -all $mem]
    if {$old ne ""} {
      remove_files $old
    }
    set f [add_files -norecurse -fileset sources_1 $mem]
    set_property FILE_TYPE {STATIC MEMORY FILE} $f
    set_property SCOPED_TO_REF $ref $f
    set_property SCOPED_TO_CELLS "inst/g_versal.g_quad_$q.i_quad/g_gtm.i_quad/quad_inst" $f
    lset quad_files $q [list [lindex $e 0] $mem]
  }
  return $quad_files
}

proc ad_xcvr_versal_finalize {} {
  global xcvr_versal_qpll_owner
  global xcvr_versal_slots
  set utils {}
  foreach k [array names xcvr_versal_slots] {
    set u [lindex [split $k ,] 0]
    if {[lsearch -exact $utils $u] < 0} { lappend utils $u }
  }
  foreach u [lsort $utils] {
    set cell [get_bd_cells $u]
    set xcvr_type [get_property CONFIG.XCVR_TYPE $cell]
    set codes {11 GTY 12 GTYP 13 GTM}
    if {![dict exists $codes $xcvr_type]} {
      error "ERROR: ad_xcvr_versal_finalize: $u has XCVR_TYPE $xcvr_type, expected 11, 12 or 13"
    }
    set transceiver [dict get $codes $xcvr_type]
    set part [get_parts [get_property PART [current_project]]]
    set part_prop [dict get {11 GTYE5_TRANSCEIVERS 12 GTYP_TRANSCEIVERS 13 GTME5_TRANSCEIVERS} $xcvr_type]
    if {[lsearch [list_property $part] $part_prop] < 0 || [get_property $part_prop $part] == 0} {
      error "ERROR: ad_xcvr_versal_finalize: [get_property NAME $part] has no $transceiver transceivers (TRANSCEIVER_TYPE)"
    }
    set ref_clock [get_property CONFIG.REF_CLK_RATE $cell]
    if {$ref_clock <= 0} {
      error "ERROR: ad_xcvr_versal_finalize: REF_CLK_RATE of $u is not set"
    }
    set rx_slots [expr {[info exists xcvr_versal_slots($u,rx)] ? $xcvr_versal_slots($u,rx) : {}}]
    set tx_slots [expr {[info exists xcvr_versal_slots($u,tx)] ? $xcvr_versal_slots($u,tx) : {}}]
    set counts [versal_xcvr_quad_lanes $rx_slots $tx_slots]
    set rxc [dict get $counts rx]
    set txc [dict get $counts tx]
    set p [dict create]
    for {set q 0} {$q < 8} {incr q} {
      dict set p CONFIG.Q${q}_RX_LANES [lindex $rxc $q]
      dict set p CONFIG.Q${q}_TX_LANES [lindex $txc $q]
    }
    set_property -dict $p $cell

    set jesd_mode [expr {[get_property CONFIG.LINK_MODE $cell] == 2 ? "64B66B" : "8B10B"}]
    set rx_rates [ad_xcvr_versal_rates $cell RX]
    set tx_rates [ad_xcvr_versal_rates $cell TX]
    # GTM 64B/66B: the link clock (lane rate / 66) is the reference clock
    # (link_refclk) unless EXTERNAL_LINK_CLK, so one lane rate only
    if {$transceiver eq "GTM" && $jesd_mode eq "64B66B"} {
      if {[llength $rx_rates] > 1 || [llength $tx_rates] > 1} {
        error "ERROR: ad_xcvr_versal_finalize: $u: GTM 64B/66B supports one lane rate"
      }
      if {[get_property CONFIG.EXTERNAL_LINK_CLK $cell] == 0} {
        foreach dir {RX TX} rates [list $rx_rates $tx_rates] c [list $rxc $txc] {
          if {[::tcl::mathop::+ {*}$c] > 0 && abs($ref_clock * 66 / 1000.0 - [lindex $rates 0]) > 1e-6} {
            error "ERROR: ad_xcvr_versal_finalize: $u: GTM 64B/66B needs REF_CLK_RATE x 66 = $dir lane rate ([lindex $rates 0]) or EXTERNAL_LINK_CLK"
          }
        }
      }
    }
    set base_dir [file join [get_property DIRECTORY [current_project]] versal_xcvr $u]
    set independent [expr {[get_property CONFIG.NON_CONSECUTIVE_QUADS $cell] == 1 ||
                           ![versal_xcvr_is_packing $rxc $txc]}]
    set files {}
    if {$independent} {
      for {set q 0} {$q < 8} {incr q} {
        set r [lindex $rxc $q]
        set t [lindex $txc $q]
        if {$r + $t == 0} { lappend files {}; continue }
        set dir [file join $base_dir q${r}x$t]
        versal_xcvr_run_extraction $dir $jesd_mode $r $t $rx_rates $tx_rates \
          $ref_clock $transceiver [get_property NAME $part]
        lappend files [list [file join $dir quad0.attr] [file join $dir quad0.mem]]
      }
    } else {
      set dir [file join $base_dir chained]
      set n [versal_xcvr_run_extraction $dir $jesd_mode [::tcl::mathop::+ {*}$rxc] \
        [::tcl::mathop::+ {*}$txc] $rx_rates $tx_rates $ref_clock $transceiver [get_property NAME $part]]
      for {set q 0} {$q < 8} {incr q} {
        lappend files [expr {$q < $n ? [list [file join $dir quad$q.attr] [file join $dir quad$q.mem]] : {}}]
      }
    }
    if {$transceiver eq "GTM"} {
      set files [versal_xcvr_gtm_mem_files $cell $base_dir $files]
    }
    set_property -dict [versal_xcvr_attribute_params $files $transceiver] $cell
  }
  array unset xcvr_versal_slots
  array unset xcvr_versal_qpll_owner
}
