###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# MRMAC + GTY wrapper CDC / timing constraints.

foreach inst [get_cells -hier -filter {(ORIG_REF_NAME == mrmac_gty_wrapper || REF_NAME == mrmac_gty_wrapper)}] {
    puts "Inserting timing constraints for mrmac_gty_wrapper instance $inst"

    foreach rst_inst [get_cells -quiet -hier \
            -filter "(ORIG_REF_NAME == sync_reset || REF_NAME == sync_reset)"] {
        # keep only the sync_reset cells that live under THIS wrapper.
        # string first, NOT string match -- see the glob warning in the header.
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
            # ts_clk is 250 MHz (clk_wizard clk_out2, matching the IP's
            # CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0}). Fallback only, for passes
            # where the destination clock is not yet resolvable (e.g. OOC synth).
            set budget [expr {$ts_capture_cycles * 4.0}]
        }

        set_max_delay -quiet -datapath_only $budget -from $st_ffs
    }
}

# Status-bit crossings into mqnic_port's first synchronizer stage. Kept OUTSIDE
# the wrapper loop because the target cells are in corundum_core.
foreach port_inst [get_cells -hier -filter {(ORIG_REF_NAME == mqnic_port || REF_NAME == mqnic_port)}] {
    puts "Inserting MAC status CDC constraints for mqnic_port instance $port_inst"

    # -hier -filter with ==, NOT a glob pattern: $port_inst contains iface[0] and
    # port[0], whose brackets Tcl reads as glob character classes. See the header.
    foreach sig {rx_status_sync_1_reg tx_status_sync_1_reg} {
        set ff [get_cells -quiet -hier -filter "NAME == $port_inst/${sig}_reg"]
        if {[llength $ff]} {
            set_property ASYNC_REG TRUE $ff
            set_false_path -quiet -to [get_pins -quiet -of_objects $ff \
                                        -filter {REF_PIN_NAME == D}]
        }
    }
}
