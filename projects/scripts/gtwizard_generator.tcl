###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
#
# CPLL - generate reference clocks for a given Lane Rate
#
# Attributes: NOTE lane rate should be define in kHz
#
# Return:     the result will be in millihertz
# E.g.        set value_MHz [format "%.7f" [expr $value / 1e9]]
#
###############################################################################
proc cpll_ref_clk_gen { lane_rate } {

  #
  #  fLineRate = (REF_CLK * (FBDIV * FBDIV_45) / REFCLK_DIV) / OUT_DIV
  #

  set out_div_l { 1 2 4 8 }
  set refclk_div_l { 1 2 }
  set fbdiv_l { 1 2 3 4 5 }
  set fbdiv_45_l { 4 5 }
  set pllclkout_l ""
  set ref_clk_l ""

  ## Calculate the VCO
  for {set i 0} {$i < [llength $out_div_l]} {incr i} {
    ## to get the right resolution which is liked by the Wizard we have to upscale
    ## the value of the Lane Rate
    set pll_out [expr [expr [expr $lane_rate * 1e6] * [lindex $out_div_l $i]] / 2]
    if { ($pll_out >= [expr 2 * 1e12]) && ($pll_out <= [expr 6.25 * 1e12]) } {
      lappend pllclkout_l $pll_out
    }
  }

  ## Calculate the reference clock
  for {set i 0 } {$i < [llength $pllclkout_l]} {incr i} {
    for {set j 0} {$j < [llength $refclk_div_l]} {incr j} {
      for {set k 0} {$k < [llength $fbdiv_l]} {incr k} {
        for {set l 0} {$l < [llength $fbdiv_45_l]} {incr l} {
          set ref_clk [expr [expr [lindex $pllclkout_l $i] * [lindex $refclk_div_l $j]] / [expr [lindex $fbdiv_l $k] * [lindex $fbdiv_45_l $l]]]
          if {[lsearch $ref_clk_l [expr $ref_clk / 1e9]] < 0} {
            ## Apperantly the Wizard support a maximum 800 MHz reference clock
            if { $ref_clk <= [expr 8 * 1e11] } {
              lappend ref_clk_l [expr $ref_clk / 1e9]
            }
          }
        }
      }
    }
  }

  return [lsort -real $ref_clk_l]
}

###############################################################################
# QPLL - generate reference clocks for a given Lane Rate - does not support
#        fractional-N
#
# Attributes: lane rate should be define in kHz
#
# Return:     the result will be in millihertz
# E.g.        set value_MHz [format "%.7f" [expr $value / 1e9]]
#
###############################################################################
proc qpll_ref_clk_gen { gt_type  lane_rate } {

  #
  #  fLineRate = ((REF_CLK * FBDIV) / (REFCLK_DIV * 2)) * 2 / OUT_DIV
  #

  ## OUT_DIV has a wider range in case of GTYs
  if {[string equal $gt_type GTYE3] || [string equal $gt_type GTYE4]} {
    set out_div_l { 1 2 4 8 16 32}
  } else {
    set out_div_l { 1 2 4 8 16 }
  }
  set refclk_div_l { 1 2 3 4 }
  ## NOTE: At GTYE3|4 the range is 16-160
  set fbdiv_l { 16 20 32 40 60 64 66 75 80 84 90 96 100 112 120 125 150 160 }
  set pllclkout_l ""
  set ref_clk_l ""

  ## Calculate the VCO
  for {set i 0} {$i < [llength $out_div_l]} {incr i} {
    ## to get the right resolution which is accepted by the Wizard we have to upscale
    ## the value of the Lane Rate
    set pll_out [expr [expr [expr $lane_rate * 1e6] * [lindex $out_div_l $i]] / 2]
    if { ($pll_out >= [expr 4.9 * 1e12]) && ($pll_out <= [expr 8.1875 * 1e12]) } {
      lappend pllclkout_l $pll_out
    }
  }

  ## Calculate the reference clock
  for {set i 0 } {$i < [llength $pllclkout_l]} {incr i} {
    for {set j 0} {$j < [llength $refclk_div_l]} {incr j} {
      for {set k 0} {$k < [llength $fbdiv_l]} {incr k} {
        set ref_clk [expr [expr [expr [lindex $pllclkout_l $i] * [lindex $refclk_div_l $j]] * 2] / [lindex $fbdiv_l $k]]
        if {[lsearch $ref_clk_l [expr $ref_clk / 1e9]] < 0} {
          ## Apperantly the Wizard support a maximum 800 MHz reference clock
          if { $ref_clk <= [expr 8 * 1e11] } {
            lappend ref_clk_l [expr $ref_clk / 1e9]
          }
        }
      }
    }
  }

  return [lsort -real $ref_clk_l]
}

###############################################################################
##
## This script can be used to generate multiple GTHE[3|4] PHY with the GT wizard
## for further examination.
## The script should be used in tandem with the gtwiz_parser.pl and must be called
## inside a Ultrascale or Ultrascale+ project.
##
###############################################################################
proc ad_gth_generator { {lane_rate_l {}} {pll_type {}}  {ref_clk_l {}} } {

  set prj_name [get_property NAME [current_project]]

  ## Currently supporting both GTH and GTY's, expected boards are ZCU102/KCU105/VCU108/VCU118
  #TODO: define this switch to be generic and support all Ultrascale/Ultrascale+ devices

  set board [string range [get_property PART [current_project]] 0 6]
  switch $board {
    "xc7z045" {
      set gt_type GTXE2
      # set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      # set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xc7k325" {
      set gt_type GTXE2
      # set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      # set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xc7z020" {
      set gt_type GTXE2
      # set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      # set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xc7vx48" {
      set gt_type GTXE2
      # set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      # set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xc7vx69" {
      # set gt_type GTXE2
      # set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      # set ref_clk "clk1"
      # set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
      puts "ERROR ad_gth_generator: Unsupported device."
      return 1
    }
    "xcku040" {
      set gt_type GTHE3
      set channel_enable [list X0Y16 X0Y17 X0Y18 X0Y19]
      set ref_clk "clk1"
      set ref_clk_source [list X0Y16 $ref_clk X0Y17 $ref_clk X0Y18 $ref_clk X0Y19 $ref_clk]
    }
    "xcvu095" {
      set gt_type GTYE3
      set channel_enable [list X0Y16 X0Y17 X0Y18 X0Y19]
      set ref_clk "clk1"
      set ref_clk_source [list X0Y16 $ref_clk X0Y17 $ref_clk X0Y18 $ref_clk X0Y19 $ref_clk]
    }
    "xczu9eg" {
      set gt_type GTHE4
      set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xcvu9p-" {
      set gt_type GTYE4
      set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }
    "xcvu37p" {
      set gt_type GTYE4
      # ??
      set channel_enable [list X0Y15 X0Y14 X0Y13 X0Y12]
      set ref_clk "clk1"
      # ??
      set ref_clk_source [list X0Y15 $ref_clk X0Y14 $ref_clk X0Y13 $ref_clk X0Y12 $ref_clk]
    }

    default {
      puts "ERROR ad_gth_generator: Unsupported device."
      return 1
    }
  }

  ## define the PLL's min and max range in GHz

  set pll_min_range ""
  set pll_max_range ""

  switch $pll_type {
    CPLL {
      set pll_min_range 0.5
      set pll_max_range 12.5
    }
    QPLL {
      if {[string equal $gt_type GTXE2]} {
        set pll_min_range 0.5
        set pll_max_range 10.3125
      } else {
        puts "Invalid PLL type -- $pll_type"
        return 1
      }
    }
    QPLL0 {
      set pll_min_range 0.6125
      set pll_max_range 16.375
    }
    QPLL1 {
      set pll_min_range 0.5
      set pll_max_range 13.0
    }
    default {
      puts "Invalid PLL type -- $pll_type"
      return 1
    }
  }

  set inst_num 0
  foreach lane_rate $lane_rate_l {

    ## make sure that the lane rate is inside the valid range
    if { ($lane_rate < $pll_min_range) || ($lane_rate > $pll_max_range)} {
      ## TODO: remove the lane rate from the list so that it is not dragged though the parsing script
      ## remove the invalid lane rate from the list
      ## set lane_rate_l [lreplace $lane_rate_l [lsearch $lane_rate] [lsearch $lane_rate]]
      puts "NOTE: $lane_rate is out of $pll_type range. Skipping it..."
      continue
    } else {
      ## generate the reference clock list for each lane rate
      if { [llength $ref_clk_l] == 0 } {
        switch -glob $pll_type {
          CPLL {
            set ref_clk_l [cpll_ref_clk_gen [expr $lane_rate * 1e6]]
          }
          QPLL* {
            set ref_clk_l [qpll_ref_clk_gen $gt_type [expr $lane_rate * 1e6]]
          }
          default {
            Something went wrong with $pll_type
          }
        }
        puts "NOTE: [llength $ref_clk_l] different reference clock were generated. \n $ref_clk_l"
      } else {
        ## use the reference clock
      }

      foreach ref_clk $ref_clk_l {

        set lane_rate_txt [string replace $lane_rate [string first . $lane_rate] [string first . $lane_rate] "_"]
        set ref_clk_txt [lindex [split $ref_clk "."] 0]

        ## format the ref_clk to be wizard compatible - precision must be max
        ## 7 digit with no trailing zeros
        set ref_clk [format "%.7f" $ref_clk]
        set ref_clk_float [split $ref_clk .]
        if {[lindex $ref_clk_float 1] == 0} {
          set ref_clk [lindex $ref_clk_float 0]
        } else {
          scan [lindex $ref_clk_float 1] "%1d%1d%1d%1d%1d%1d%1d" a b c d e f g
          set float_l [list $a $b $c $d $e $f $g]
          while {[lindex $float_l [expr [llength $float_l] - 1]] == 0} {
            set l_index [expr [llength $float_l] - 1]
            set float_l [lreplace $float_l $l_index $l_index]
          }
          set ref_clk [lindex $ref_clk_float 0].[join $float_l ""]
        }

        set ip_name "$gt_type\_$pll_type\_$lane_rate_txt\_$ref_clk_txt"
        incr inst_num

        ## check if it is 7series or ultrascale/ultrascale+

        if {[string equal $gt_type GTXE2]} {
          ## 7 series
          ## create a GT instance with the wizard, if already exist skip it
          if {[lsearch [get_ips] $ip_name] == -1} {

            set float_clk [format "%.3f" [expr {$ref_clk}]]

            create_ip -name gtwizard -vendor xilinx.com -library ip -version 3.6 -module_name $ip_name

            set_property -dict [list \
            CONFIG.identical_protocol_file {JESD204} \
            CONFIG.identical_val_tx_reference_clock $float_clk \
            CONFIG.identical_val_rx_reference_clock $float_clk \
            CONFIG.gt0_val_rx_reference_clock $float_clk \
            CONFIG.gt0_val_tx_reference_clock $float_clk \
            CONFIG.identical_val_tx_line_rate $lane_rate \
            CONFIG.identical_val_rx_line_rate $lane_rate \
            CONFIG.gt0_val_rx_line_rate $lane_rate \
            CONFIG.gt0_val_tx_line_rate $lane_rate \
            CONFIG.gt_val_tx_pll $pll_type \
            CONFIG.gt0_usesharedlogic {1} \
            CONFIG.advanced_clocking {true} \
            CONFIG.gt_val_drp {false} \
            CONFIG.gt0_val_drp_clock {100} \
            CONFIG.gt_val_drp_clock {60} \
            CONFIG.gt0_val_tx_refclk {REFCLK1_Q0} \
            CONFIG.gt0_val_rx_refclk {REFCLK1_Q0} \
            CONFIG.gt1_val_tx_refclk {REFCLK1_Q0} \
            CONFIG.gt1_val_rx_refclk {REFCLK1_Q0} \
            CONFIG.gt2_val_tx_refclk {REFCLK1_Q0} \
            CONFIG.gt2_val_rx_refclk {REFCLK1_Q0} \
            CONFIG.gt3_val_tx_refclk {REFCLK1_Q0} \
            CONFIG.gt3_val_rx_refclk {REFCLK1_Q0} \
            CONFIG.gt4_val_tx_refclk {REFCLK1_Q1} \
            CONFIG.gt4_val_rx_refclk {REFCLK1_Q1} \
            CONFIG.gt5_val_tx_refclk {REFCLK1_Q1} \
            CONFIG.gt5_val_rx_refclk {REFCLK1_Q1} \
            CONFIG.gt6_val_tx_refclk {REFCLK1_Q1} \
            CONFIG.gt6_val_rx_refclk {REFCLK1_Q1} \
            CONFIG.gt7_val_tx_refclk {REFCLK1_Q1} \
            CONFIG.gt7_val_rx_refclk {REFCLK1_Q1} \
            CONFIG.gt8_val_tx_refclk {REFCLK1_Q2} \
            CONFIG.gt8_val_rx_refclk {REFCLK1_Q2} \
            CONFIG.gt9_val_tx_refclk {REFCLK1_Q2} \
            CONFIG.gt9_val_rx_refclk {REFCLK1_Q2} \
            CONFIG.gt10_val_tx_refclk {REFCLK1_Q2} \
            CONFIG.gt10_val_rx_refclk {REFCLK1_Q2} \
            CONFIG.gt11_val_tx_refclk {REFCLK1_Q2} \
            CONFIG.gt11_val_rx_refclk {REFCLK1_Q2} \
            CONFIG.gt12_val_tx_refclk {REFCLK1_Q3} \
            CONFIG.gt12_val_rx_refclk {REFCLK1_Q3} \
            CONFIG.gt13_val_tx_refclk {REFCLK1_Q3} \
            CONFIG.gt13_val_rx_refclk {REFCLK1_Q3} \
            CONFIG.gt14_val_tx_refclk {REFCLK1_Q3} \
            CONFIG.gt14_val_rx_refclk {REFCLK1_Q3} \
            CONFIG.gt15_val_tx_refclk {REFCLK1_Q3} \
            CONFIG.gt15_val_rx_refclk {REFCLK1_Q3} \
            CONFIG.gt0_val_rxusrclk {RXOUTCLK} \
            CONFIG.gt0_val_decoding {8B/10B} \
            CONFIG.gt0_val_encoding {8B/10B} \
            CONFIG.gt0_val_tx_data_width {32} \
            CONFIG.gt0_val_tx_int_datawidth {40} \
            CONFIG.gt0_val_rx_data_width {32} \
            CONFIG.gt0_val_rx_int_datawidth {40} \
            CONFIG.gt0_val_port_rxchariscomma {true} \
            CONFIG.gt0_val_port_rxcharisk {true} \
            CONFIG.gt0_val_align_pcomma_value {0101111100} \
            CONFIG.gt0_val_align_mcomma_value {1010000011} \
            CONFIG.gt0_val_align_comma_enable {1111111111} \
            ] [get_ips $ip_name]

           puts "\n IP generated \n"

            ## generate output products and run synthesis
            generate_target all [get_files  \
                  $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]
            catch { config_ip_cache -export [get_ips -all $ip_name] }
            export_ip_user_files -of_objects [get_files $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci] -no_script -sync -force -quiet
            create_ip_run [get_files -of_objects [get_fileset sources_1] $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci] -force
            ## Synthesis is optional - the generated files already contains all the
            ## attributes
            ## launch_runs -jobs 8 "$ip_name\_synth_1"
          } else {
            puts "NOTE: $ip_name does already exist."
          }

        } else {
          ## Ultrascale/Ultrascale+

          ## create a GT instance with the wizard, if already exist skip it
          if {[lsearch [get_ips] $ip_name] == -1} {

            create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 -module_name $ip_name

            ## TODO: double check if this configuration is OK for JESD204B
            if {[string equal $gt_type GTYE3] || [string equal $gt_type GTYE4]} {
              set gt_preset GTY-JESD204
            } else {
              set gt_preset GTH-JESD204
            }

            set_property -dict [list \
                CONFIG.preset $gt_preset \
                CONFIG.CHANNEL_ENABLE $channel_enable \
                CONFIG.TX_MASTER_CHANNEL [lindex $channel_enable 0] \
                CONFIG.RX_MASTER_CHANNEL [lindex $channel_enable 0] \
                CONFIG.TX_REFCLK_SOURCE $ref_clk_source \
                CONFIG.RX_REFCLK_SOURCE $ref_clk_source \
                CONFIG.TX_LINE_RATE $lane_rate \
                CONFIG.TX_PLL_TYPE $pll_type \
                CONFIG.TX_REFCLK_FREQUENCY $ref_clk \
                CONFIG.TX_DATA_ENCODING {8B10B} \
                CONFIG.TX_INT_DATA_WIDTH {40} \
                CONFIG.RX_LINE_RATE $lane_rate \
                CONFIG.RX_PLL_TYPE $pll_type \
                CONFIG.RX_REFCLK_FREQUENCY $ref_clk \
                CONFIG.RX_DATA_DECODING {8B10B} \
                CONFIG.RX_INT_DATA_WIDTH {40} \
                CONFIG.RX_EQ_MODE {LPM} \
                CONFIG.RX_COMMA_P_ENABLE {true} \
                CONFIG.RX_COMMA_M_ENABLE {true} \
                CONFIG.RX_COMMA_MASK {1111111111} \
            ] [get_ips $ip_name]

           puts "\n IP generated \n"

            ## generate output products and run synthesis
            generate_target all [get_files  \
                  $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]
            catch { config_ip_cache -export [get_ips -all $ip_name] }
            export_ip_user_files -of_objects [get_files $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci] -no_script -sync -force -quiet
            create_ip_run [get_files -of_objects [get_fileset sources_1] $prj_name.srcs/sources_1/ip/$ip_name/$ip_name.xci] -force
            ## Synthesis is optional - the generated files already contains all the
            ## attributes
            ## launch_runs -jobs 8 "$ip_name\_synth_1"
          } else {
            puts "NOTE: $ip_name does already exist."
          }
        }
      }
    }
  }
}

###############################################################################
##
## This script combines the previous one with the gtwiz_parser.pl, as they are meant to work.
## It generates a PHY configuration with GT wizard, that is parsed afterwards.
## That results in a list of parameters that are specific to the configuration, but different from the default one.
## This output should then overwrite the existing instance in the system_bd.tcl.
## The output products can be found at <project_name>.gen/sources_1/ip (*_cfng.txt)
## It must be called inside a Ultrascale or Ultrascale+ project.
## GitHub documentation: https://analogdevicesinc.github.io/hdl/library/jesd204/xgt_wizard/index.html
##
###############################################################################
proc get_diff_params { {lane_rate_l {}} {pll_type {}}  {ref_clk_l {}} {keep_ip "true"} } {

  ## Get the gt_type for the board
  set board [string range [get_property PART [current_project]] 0 6]
  switch $board {
    "xc7z045" {
      set gt_type GTXE2
    }
    "xc7k325" {
      set gt_type GTXE2
    }
    "xc7z020" {
      set gt_type GTXE2
    }
    "xc7vx48" {
      set gt_type GTXE2
    }
    "xc7vx69" {
      #set gt_type GTHE2
      puts "ERROR ad_gth_generator: Unsupported device."
      return 1
    }
    "xcku040" {
      set gt_type GTHE3
    }
    "xcvu095" {
      set gt_type GTYE3
    }
    "xczu9eg" {
      set gt_type GTHE4
    }
    "xcvu9p-" {
      set gt_type GTYE4
    }
    "xcvu37p" {
      set gt_type GTYE4
    }

    default {
      puts "ERROR ad_gth_generator: Unsupported device."
      return 1
    }
  }

  set current_dir [pwd]
  set project_name [get_property NAME [current_project]]

  ## Generate configurations
  ad_gth_generator $lane_rate_l $pll_type $ref_clk_l

  ## Call parser script gtwiz_parser.pl
  cd $project_name\.gen/sources_1/ip
  # exec $::env(ADI_HDL_DIR)/projects/scripts/gtwiz_parser.pl $gt_type
  # catch exception for the next line. If it catches something, come back to $current_dir
  if { [catch { exec ../../../../../scripts/gtwiz_parser.pl $gt_type } e] } {
    cd $current_dir
    puts "Some error has occured: \n$e";
  } else {
    exec ../../../../../scripts/gtwiz_parser.pl $gt_type
    cd $current_dir

    ## if keep_ip not true, remove from the project the generated IPs and delete them
    if {$keep_ip ne "true"} {
      foreach lane_rate $lane_rate_l {
        foreach ref_clk  $ref_clk_l {
          set lane_rate_txt [string replace $lane_rate [string first . $lane_rate] [string first . $lane_rate] "_"]
          set ref_clk_txt [lindex [split $ref_clk "."] 0]

          ## Get the paths to generated IP so that it can be removed
          set src_path $current_dir/$project_name\.srcs/sources_1/ip
          set gen_path $current_dir/$project_name\.gen/sources_1/ip
          set ip_name [eval exec ls $src_path | grep $gt_type\_$pll_type\_$lane_rate_txt\_$ref_clk_txt]
          set ip_path_src $src_path\/$ip_name
          set ip_path_gen $gen_path\/$ip_name
          set xci_file $ip_path_src/$ip_name\.xci

          ## Remove the generated IP after the differences were written
          export_ip_user_files -of_objects  [get_files $xci_file] -no_script -reset -force -quiet
          remove_files  -fileset $ip_name $xci_file
          file delete -force $ip_path_src
          file delete -force $ip_path_gen
        }
      }
    } else {
    puts "\ngenerated files can be find at $project_name\.gen/sources_1/ip"
    }


    puts "\nconfiguration file for the tranciever is $project_name\.gen/sources_1/ip/$gt_type\_cfng.txt"
  }

}
