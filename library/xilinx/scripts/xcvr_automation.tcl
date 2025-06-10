###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc adi_xcvr_parameters {file_paths parameters} {

    set default_parameters {
        "RX_NUM_OF_LANES" "8"
        "TX_NUM_OF_LANES" "8"
        "RX_LANE_RATE" "12.5"
        "TX_LANE_RATE" "12.5"
        "LINK_MODE" "1"
        "RX_LANE_INVERT" "0"
        "TX_LANE_INVERT" "0"
        "QPLL_REFCLK_DIV" "1"
        "QPLL_FBDIV_RATIO" "1"
        "POR_CFG" "16'b0000000000000110"
        "PPF0_CFG" "16'b0000011000000000"
        "PPF1_CFG" "16'b0000011000000000"
        "QPLL_CFG" "27'h0680181"
        "QPLL_FBDIV" "10'b0000110000"
        "QPLL_CFG0" "16'b0011001100011100"
        "QPLL_CFG1" "16'b1101000000111000"
        "QPLL_CFG1_G3" "16'b1101000000111000"
        "QPLL_CFG2" "16'b0000111111000000"
        "QPLL_CFG2_G3" "16'b0000111111000000"
        "QPLL_CFG3" "16'b0000000100100000"
        "QPLL_CFG4" "16'b0000000000000011"
        "QPLL_CP_G3" "10'b0000011111"
        "QPLL_LPF" "10'b0100110111"
        "QPLL_CP" "10'b0001111111"
        "CPLL_FBDIV" "2"
        "CPLL_FBDIV_4_5" "5"
        "CPLL_CFG0" "16'b0000000111111010"
        "CPLL_CFG1" "16'b0000000000100011"
        "CPLL_CFG2" "16'b0000000000000010"
        "CPLL_CFG3" "16'b0000000000000000"
        "CH_HSPMUX" "16'b0010010000100100"
        "PREIQ_FREQ_BST" "0"
        "RXPI_CFG0" "16'b0000000000000010"
        "RXPI_CFG1" "16'b0000000000010101"
        "RTX_BUF_CML_CTRL" "3'b011"
        "TX_OUT_DIV" "1"
        "TX_CLK25_DIV" "20"
        "TX_PI_BIASSET" "1"
        "TXPI_CFG" "16'b0000000001010100"
        "A_TXDIFFCTRL" "5'b10110"
        "RX_OUT_DIV" "1"
        "RX_CLK25_DIV" "20"
        "RX_DFE_LPM_CFG" "16'h0104"
        "RX_PMA_CFG" "32'h001e7080"
        "RX_CDR_CFG" "72'h0b000023ff10400020"
        "RXCDR_CFG0" "16'b0000000000000010"
        "RXCDR_CFG2" "16'b0000001001101001"
        "RXCDR_CFG2_GEN2" "10'b1001100101"
        "RXCDR_CFG2_GEN4" "16'b0000000010110100"
        "RXCDR_CFG3" "16'b0000000000010010"
        "RXCDR_CFG3_GEN2" "6'b011010"
        "RXCDR_CFG3_GEN3" "16'b0000000000010010"
        "RXCDR_CFG3_GEN4" "16'b0000000000100100"
        "RXDFE_KH_CFG2" "16'h0200"
        "RXDFE_KH_CFG3" "16'h4101"
        "RX_WIDEMODE_CDR" "2'b00"
        "RX_XMODE_SEL" "1'b1"
        "TXDRV_FREQBAND" "0"
        "TXFE_CFG0" "16'b0000001111000010"
        "TXFE_CFG1" "16'b0110110000000000"
        "TXFE_CFG2" "16'b0110110000000000"
        "TXFE_CFG3" "16'b0110110000000000"
        "TXPI_CFG0" "16'b0000001100000000"
        "TXPI_CFG1" "16'b0001000000000000"
        "TXSWBST_EN" "0"
    }

    set correction_map {
        "TXOUT_DIV" "TX_OUT_DIV"
        "RXOUT_DIV" "RX_OUT_DIV"
        "CPLL_FBDIV_45" "CPLL_FBDIV_4_5"
        "RXCDR_CFG" "RX_CDR_CFG"
    }

    set updated_params {}
    set param_file_path [dict get $file_paths param_file_path]
    set cfng_file_path [dict get $file_paths cfng_file_path]

    if {$param_file_path ne ""} {

        set param_file_content [read [open $param_file_path r]]

        # Define a regex pattern for extracting the value of QPLL_FBDIV_TOP from $param_file_path
        set param_pattern {QPLL_FBDIV_TOP =  ([0-9]+);}
        set match [regexp -inline $param_pattern $param_file_content]
        set QPLL_FBDIV_TOP [lindex $match 1]

        switch $QPLL_FBDIV_TOP {
            16 {set QPLL_FBDIV_IN "10'b0000100000"}
            20 {set QPLL_FBDIV_IN "10'b0000110000"}
            32 {set QPLL_FBDIV_IN "10'b0001100000"}
            40 {set QPLL_FBDIV_IN "10'b0010000000"}
            64 {set QPLL_FBDIV_IN "10'b0011100000"}
            66 {set QPLL_FBDIV_IN "10'b0101000000"}
            80 {set QPLL_FBDIV_IN "10'b0100100000"}
            100 {set QPLL_FBDIV_IN "10'b0101110000"}
            default {set QPLL_FBDIV_IN "10'b0000000000"}
        }

        switch $QPLL_FBDIV_TOP {
            66 {set QPLL_FBDIV_RATIO "1'b0"}
            default {set QPLL_FBDIV_RATIO "1'b1"}
        }
    }

    set file_content [read [open $cfng_file_path r]]
    set match ""
    regexp {QPLL[0-9]+} $cfng_file_path match

    # Define a regex pattern for extracting parameters and their values
    set pattern {'([^']+)' => '([^']+\\?'?[0-9a-hA-H]*)'}
    set results {}
    set matches [regexp -all -inline $pattern $file_content]

    for {set i 0} {$i < [llength $matches]} {incr i 3} {

        set param [lindex $matches $i+1]
        set value [lindex $matches $i+2]

        set cleaned_value [string map {"\\" ""} $value]
        set corrected_param $param

        if {[dict exists $correction_map $param]} {
            set corrected_param [dict get $correction_map $param]
        }

         if {[string first $match $param] == 0} {

            if {[regexp {^(QPLL)[0-9]+(.*)} $param _ prefix rest]} {
                set corrected_param "${prefix}${rest}"
            }
        }

        if {[dict exists $default_parameters $corrected_param]} {

            set default_value [dict get $default_parameters $corrected_param]

            if {$cleaned_value != $default_value} {

                if {[string equal $cleaned_value "QPLL_FBDIV_IN"]} {
                    set cleaned_value $QPLL_FBDIV_IN
                }
                if {[string equal $cleaned_value "QPLL_FBDIV_RATIO"]} {
                    set cleaned_value $QPLL_FBDIV_RATIO
                }
                if {[string equal $corrected_param "PREIQ_FREQ_BST"]} {
                    set cleaned_value [expr {$cleaned_value}]
                }

                dict set updated_params $corrected_param $cleaned_value
            }
        }
        lappend results [list $corrected_param $cleaned_value]
    }

    if {[llength $parameters] > 0} {
        foreach {key value} $parameters {

            if {[dict exists $default_parameters $key]} {
                set default_value [dict get $default_parameters $key]

                if {$value != $default_value} {
                    dict set updated_params $key $value
                }
            }
            if {[dict exists $updated_params $key]} {
                set default_value [dict get $updated_params $key]

                if {$value != $default_value} {
                    dict set updated_params $key $value
                }
            }
        }
    }

    return $updated_params
}
