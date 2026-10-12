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

# Generates the Versal quad wrapper, its helpers and the reset controller from
# the installed Vivado's Transceivers Wizard. These files are configuration
# independent apart from the module prefix; the GT attributes become parameters
# (unisim defaults) that util_adxcvr sets from the per-project Wizard output.
# Standalone: vivado -mode batch -source util_adxcvr_versal_helpers.tcl -tclargs <out_dir>
# util_adxcvr_ip.tcl sources it and calls util_adxcvr_versal_helpers.

source [file join [file dirname [file normalize [info script]]] .. .. scripts adi_xcvr_versal.tcl]

# GTYP has no memcell arbiter in front of its APB port; GTM has neither the
# arbiter nor the RX/TX function helpers
set types {
  gty  GTY  GTYE5_QUAD xcvc1902-vsva2197-2MP-e-S {quad_base rx_function tx_function apb_memcell_arb axi_lite_apb3_bridge reset_ip}
  gtyp GTYP GTYP_QUAD  xcvp1802-lsvc4072-2MP-e-S {quad_base rx_function tx_function axi_lite_apb3_bridge reset_ip}
  gtm  GTM  GTME5_QUAD xcvp1802-lsvc4072-2MP-e-S {quad_base axi_lite_apb3_bridge reset_ip}
}

proc read_file {name} {
  set fh [open $name]
  set data [read $fh]
  close $fh
  return $data
}

proc write_file {name data} {
  set fh [open $name w]
  puts -nonewline $fh $data
  close $fh
}

# The rules include becomes one parameter per attribute, defaulting to the
# primitive's unisim default, and the Wizard's own module parameters become
# localparams (they only carry Wizard bookkeeping such as power settings).
proc convert_quad_base {src rules unisim mod} {
  set prim_default [dict create]
  foreach line [split $unisim "\n"] {
    if {[regexp {^\s*parameter\s+(?:\[[^\]]*\]\s*)?(?:real\s+)?(\w+)\s*=\s*([^,]+?)\s*,?\s*$} $line -> name value]} {
      dict set prim_default $name $value
    }
  }
  set attrs {}
  set params {}
  set wizard_local {}
  set local_entries {}
  foreach {- range name value} [regexp -all -inline {localparam\s+(\[[^\]]*\]\s*)?(\w+)\s*=\s*([^;]+);} $rules] {
    set value [string trim $value]
    if {$name eq "MEMORY_INIT_FILE"} {
      lappend params "    parameter MEMORY_INIT_FILE = \"NONE\""
      continue
    }
    # Wizard bookkeeping computed from other settings (GTM: simulation reset
    # speed-up, UB_CFG0) stays local; a translate_off section (the speed-up
    # is on in simulation only) is kept on its own lines
    if {![versal_xcvr_rules_literal [string trim $range] $value]} {
      set end [expr {[string first "//" $value] >= 0 ? "\n  ;" : ";"}]
      lappend wizard_local "  localparam [string trim $range] $name = [string trim $value]$end"
      lappend local_entries [versal_xcvr_local_entry [string trim $range] $name $value]
      continue
    }
    lappend attrs $name
    if {[dict exists $prim_default $name]} {
      set value [dict get $prim_default $name]
    }
    lappend params "    parameter $name = $value"
  }

  regsub {`include\s+"[^"]*_rules_output.vh"\s*\n} $src {} src
  set hs [string first "module $mod # (" $src]
  set he [string first "\n)(" $src $hs]
  if {$hs < 0 || $he < 0} {
    error "ERROR: util_adxcvr_versal_helpers: unexpected header in $mod"
  }
  set head_start [expr {$hs + [string length "module $mod # ("]}]
  set local {}
  foreach line [split [string range $src $head_start [expr {$he - 1}]] "\n"] {
    if {[regexp {^\s*parameter\s+(\w+)\s*=\s*(.*?),?\s*$} $line -> name value]} {
      lappend local "  localparam $name = [string trimright $value ,];"
    }
  }
  set src "[string range $src 0 [expr {$head_start - 1}]]\n[join $params ",\n"]\n[string range $src $he end]"
  set pe [expr {[string first "\n);" $src [string first "module $mod" $src]] + 3}]
  set src "[string range $src 0 [expr {$pe - 1}]]\n[join [concat $wizard_local $local] "\n"]\n[string range $src $pe end]"
  return [list $src $attrs $local_entries]
}

# Returns the generated files; regenerates only when the stamp does not match
# the running Vivado. GT types whose reference part is not installed are skipped.
proc util_adxcvr_versal_helpers {out_dir} {
  global types

  set out_dir [file normalize $out_dir]
  set stamp [file join $out_dir VIVADO_VERSION]
  set stale [expr {![file exists $stamp] || [string trim [read_file $stamp]] ne [version -short]}]
  # a GT type without its complete output (wizard_local.txt is written
  # last), e.g. one added since the last run, is generated on its own
  set missing 0
  foreach {t gt prim part helpers} $types {
    if {![file exists [file join $out_dir $t wizard_local.txt]] && [get_parts -quiet $part] ne ""} {
      set missing 1
    }
  }
  if {$stale || $missing} {
    file mkdir $out_dir
    foreach {t gt prim part helpers} $types {
      if {!$stale && [file exists [file join $out_dir $t wizard_local.txt]]} continue
      if {[get_parts -quiet $part] eq ""} {
        puts "INFO: util_adxcvr_versal_helpers: $part not installed, no $gt support"
        continue
      }
      if {[info exists ::env(EXTRA_HELPER)]} {
        lappend helpers $::env(EXTRA_HELPER)
      }
      set work [file join $out_dir .work_$t]
      file delete -force $work
      set ref adxcvr_ref_$t
      create_project $ref $work -part $part -force
      create_ip -name gtwiz_versal -vendor xilinx.com -library ip -module_name $ref
      set_property -dict [versal_xcvr_wizard_params 64B66B 4 4 {24.75} {24.75} 375 $gt RXTX] [get_ips $ref]
      generate_target {synthesis} [get_ips $ref]
      set gen [file join $work $ref.gen sources_1 ip $ref]
      set q [file join $gen ip_0]
      set qp ${ref}_gt_quad_base_0

      set files [dict create \
        quad_base            [file join $q ${qp}_inst.v] \
        rx_function          [file join $q ${qp}_rx_function.v] \
        tx_function          [file join $q ${qp}_tx_function.v] \
        apb_memcell_arb      [file join $q ${qp}_apb_memcell_arb.v] \
        axi_lite_apb3_bridge [file join $q ${qp}_axi_lite_to_apb3_inst.v] \
        reset_ip             [file join $gen ${ref}_reset_ip.v]]
      foreach h $helpers {
        if {![dict exists $files $h] || ![file exists [dict get $files $h]]} {
          error "ERROR: util_adxcvr_versal_helpers: $h not generated by Vivado [version -short] for $gt"
        }
      }

      set d [file join $out_dir $t]
      file delete -force $d
      file mkdir $d
      set prefix_map [list ${qp}_inst util_adxcvr_${t}_quad_base ${qp}_ util_adxcvr_${t}_ $qp util_adxcvr_${t}_quad_base ${ref}_ util_adxcvr_${t}_]
      foreach h $helpers {
        set f [dict get $files $h]
        set src [string map $prefix_map [read_file $f]]
        if {$h eq "quad_base"} {
          # GTME5_QUAD has a SystemVerilog model only
          set unisim_dir [file join $::env(XILINX_VIVADO) data verilog src unisims]
          set unisim_file [file join $unisim_dir ${prim}.v]
          if {![file exists $unisim_file]} {
            set unisim_file [file join $unisim_dir ${prim}.sv]
          }
          set unisim [read_file $unisim_file]
          lassign [convert_quad_base $src [read_file [file join $q ${qp}_rules_output.vh]] $unisim util_adxcvr_${t}_quad_base] src attrs local_entries
          write_file [file join $d attributes.txt] "[join $attrs "\n"]\n"
        }
        write_file [file join $d util_adxcvr_${t}_$h.v] $src
      }
      # the Wizard entries kept inside the quad base, for
      # versal_xcvr_attribute_params; written last, so a type without it is
      # regenerated
      write_file [file join $d wizard_local.txt] [join [lmap l $local_entries { string cat $l "\n" }] ""]
      close_project
      file delete -force $work
    }
    write_file [file join $out_dir VIVADO_VERSION] "[version -short]\n"
  }
  return [lsort [glob -nocomplain [file join $out_dir * *.v]]]
}

if {[llength $argv] == 1} {
  util_adxcvr_versal_helpers [lindex $argv 0]
}
