###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

foreach inst [get_cells -hier -filter {(ORIG_REF_NAME == mrmac_gty_wrapper || REF_NAME == mrmac_gty_wrapper)}] {
    puts "Inserting timing constraints for mrmac_gty_wrapper instance $inst"

    foreach rst_inst [get_cells -quiet -hier \
            -filter "(ORIG_REF_NAME == sync_reset || REF_NAME == sync_reset)"] {
        if {[string first "$inst/" $rst_inst] != 0} { continue }

        set reset_ffs [get_cells -quiet -hier -regexp ".*/sync_reg_reg\\\[\\d+\\\]" \
                        -filter "PARENT == $rst_inst"]
        if {[llength $reset_ffs]} {
            set_property ASYNC_REG TRUE $reset_ffs
            set_false_path -quiet \
                -to [get_pins -quiet -of_objects $reset_ffs -filter {IS_PRESET || IS_RESET}]
        }
    }

    set ts_capture_cycles 4
    foreach ptp_inst [get_cells -quiet -hier \
            -filter "(ORIG_REF_NAME == mrmac_ptp_sync || REF_NAME == mrmac_ptp_sync)"] {
        if {[string first "$inst/" $ptp_inst] != 0} { continue }

        set st_ffs [get_cells -quiet -hier -filter \
                     "PARENT == $ptp_inst && IS_SEQUENTIAL"]
        if {![llength $st_ffs]} { continue }

        set dst_clk [get_clocks -quiet -of_objects \
                      [get_pins -quiet -hier -filter \
                        {NAME =~ */i_system_mrmac_0_0_top/* && IS_CLOCK \
                         && (REF_PIN_NAME =~ RX_TS_CLK* || REF_PIN_NAME =~ TX_TS_CLK*)}]]
        if {[llength $dst_clk]} {
            set budget [expr {$ts_capture_cycles * [get_property -min PERIOD $dst_clk]}]
        } else {
            set budget [expr {$ts_capture_cycles * 4.0}]
        }

        set_max_delay -quiet -datapath_only $budget -from $st_ffs
    }
}

foreach port_inst [get_cells -hier -filter {(ORIG_REF_NAME == mqnic_port || REF_NAME == mqnic_port)}] {
    puts "Inserting MAC status CDC constraints for mqnic_port instance $port_inst"

    foreach sig {rx_status_sync_1_reg tx_status_sync_1_reg} {
        set ff [get_cells -quiet -hier -filter "NAME == $port_inst/${sig}_reg"]
        if {[llength $ff]} {
            set_property ASYNC_REG TRUE $ff
            set_false_path -quiet -to [get_pins -quiet -of_objects $ff \
                                        -filter {REF_PIN_NAME == D}]
        }
    }
}

foreach init_inst [get_cells -quiet -hier -filter {(ORIG_REF_NAME == mrmac_init || REF_NAME == mrmac_init)}] {
    puts "Inserting timing constraints for mrmac_init instance $init_inst"
    set stage1 [get_cells -quiet -hier -filter \
                 "NAME =~ $init_inst/i_sync_status/cdc_sync_stage1_reg* && IS_SEQUENTIAL"]
    set stage2 [get_cells -quiet -hier -filter \
                 "NAME =~ $init_inst/i_sync_status/cdc_sync_stage2_reg* && IS_SEQUENTIAL"]
    if {[llength $stage1]} {
        set_property ASYNC_REG TRUE [concat $stage1 $stage2]
        set_false_path -quiet -to [get_pins -quiet -of_objects $stage1 -filter {REF_PIN_NAME == D}]
    }
}

foreach regs_inst [get_cells -quiet -hier -filter {(ORIG_REF_NAME == mrmac_gt_regs || REF_NAME == mrmac_gt_regs)}] {
    puts "Inserting timing constraints for mrmac_gt_regs instance $regs_inst"
    set stage1 [get_cells -quiet -hier -filter \
                 "NAME =~ $regs_inst/*cdc_sync_stage1_reg* && IS_SEQUENTIAL"]
    set stage2 [get_cells -quiet -hier -filter \
                 "NAME =~ $regs_inst/*cdc_sync_stage2_reg* && IS_SEQUENTIAL"]
    if {[llength $stage1]} {
        set_property ASYNC_REG TRUE [concat $stage1 $stage2]
        set_false_path -quiet -to [get_pins -quiet -of_objects $stage1 -filter {REF_PIN_NAME == D}]
    }

    set n_sel 0
    foreach sync_inst [get_cells -quiet -hier -filter \
            "NAME =~ $regs_inst/*i_sync_?x_sel && !IS_PRIMITIVE"] {
        set hold [get_cells -quiet -hier -filter \
                   "PARENT == $sync_inst && NAME =~ */cdc_hold_reg* && IS_SEQUENTIAL"]
        set out [get_cells -quiet -hier -filter \
                  "PARENT == $sync_inst && NAME =~ */out_data_reg* && IS_SEQUENTIAL"]
        if {![llength $hold] || ![llength $out]} { continue }

        set dst_clk [get_clocks -quiet -of_objects \
                      [get_pins -quiet -of_objects $out -filter {REF_PIN_NAME == C}]]
        if {[llength $dst_clk]} {
            set budget [get_property -min PERIOD $dst_clk]
        } else {
            set budget 3.103
        }
        puts "Inserting max_delay $budget ns for sync_data instance $sync_inst"
        set_max_delay -quiet -datapath_only $budget \
            -from [get_pins -quiet -of_objects $hold -filter {REF_PIN_NAME == C}] \
            -to [get_pins -quiet -of_objects $out -filter {REF_PIN_NAME == D}]
        incr n_sel
    }
    if {$n_sel != 5} {
        send_msg_id {mrmac_gty_wrapper 1-1} {CRITICAL WARNING} \
            "mrmac_gt_regs instance $regs_inst: select max_delay on $n_sel sync_data instances, expected 5 (4 RX lanes + 1 TX)"
    }
}

foreach glue_inst [get_cells -quiet -hier -filter {(ORIG_REF_NAME == mrmac_versal_glue || REF_NAME == mrmac_versal_glue)}] {
    set stage1 [get_cells -quiet -hier -regexp -filter {IS_SEQUENTIAL} \
                 "$glue_inst/.*i_loopback/(rst|en|swap)_sync_reg\\\[0\\\]"]
    if {![llength $stage1]} {
        puts "No mrmac_axis_loopback in $glue_inst (LOOPBACK_ENABLE 0)"
        continue
    }
    set ports [llength [get_pins -quiet -of_objects $glue_inst \
                         -filter {REF_PIN_NAME =~ shim_rx_axis_tvalid*}]]
    set lb_insts [lsort -unique [lmap c $stage1 {regsub {/[^/]*$} $c {}}]]
    set expected [expr {3 * $ports}]
    if {[llength $stage1] != $expected || [llength $lb_insts] != $ports} {
        send_msg_id {mrmac_gty_wrapper 1-2} {CRITICAL WARNING} \
            "$glue_inst: [llength $stage1] mrmac_axis_loopback synchronizer first stages in [llength $lb_insts] loopback instances, expected $expected in $ports (one per MRMAC port)"
    }
    set_false_path -quiet -to [get_pins -quiet -of_objects $stage1 -filter {REF_PIN_NAME == D}]
}
