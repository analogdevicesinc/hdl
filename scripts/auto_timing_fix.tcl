###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
# This script attempts to automatically fix timing violations after routing
# using phys_opt_design. It will make multiple attempts up to a maximum number
# of tries, or until no violations remain. It can be configured via the
# ADI_AUTOFIX_WNS_THRESHOLD and ADI_AUTOFIX_MAX_ATTEMPTS environment variables.
#
# ADI_AUTOFIX_WNS_THRESHOLD limits the worst negative slack (WNS) that will be
# automatically fixed. If the WNS is worse than this threshold, no automatic fix
# will be attempted. The threshold should be a negative number and the value is
# in nanoseconds. For example, a threshold of -1.0 means that only violations
# where "0 > WNS > -1.0 ns" will be automatically fixed.
#
puts "INFO: starting auto timing fix (ATF)..."
set attempt 0

# Set default values if not provided
if {![info exists ADI_AUTOFIX_WNS_THRESHOLD]} {
    set ADI_AUTOFIX_WNS_THRESHOLD -1.0
    puts "INFO: ATF: ADI_AUTOFIX_WNS_THRESHOLD not set, using default of $ADI_AUTOFIX_WNS_THRESHOLD"
}
if {![info exists ADI_AUTOFIX_MAX_ATTEMPTS]} {
    set ADI_AUTOFIX_MAX_ATTEMPTS 5
    puts "INFO: ATF: ADI_AUTOFIX_MAX_ATTEMPTS not set, using default of $ADI_AUTOFIX_MAX_ATTEMPTS"
}

write_checkpoint -force "AutoTimingFix_before_system_top_placed.dcp"
while {$attempt < $ADI_AUTOFIX_MAX_ATTEMPTS} {
    # Get the single worst timing path object in the design
    set worst_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min_max]
    if {[llength $worst_path] == 0} { break } ; # No paths found
    set wns [get_property SLACK $worst_path]
    if {${wns} >= 0.0} { break } ; # No violations remain
    set delay_type [get_property DELAY_TYPE $worst_path] ;# Returns "max" for Setup, "min" for Hold
    # Check if autofix should attempt based on WNS threshold
    if {$wns > $ADI_AUTOFIX_WNS_THRESHOLD} {
        incr attempt
        puts "INFO: ATF: WNS = ${wns} ns of type $delay_type. Attempting automatic fix (${attempt} of ${ADI_AUTOFIX_MAX_ATTEMPTS})."
        report_timing_summary -delay_type min_max -max_paths 5 -nworst 1 -file "AutoTimingFix_${attempt}_before_timing_summary.txt"
    } else {
        break ; # Abort automatic fix due to WNS threshold
    }
    # Attempt fix via phys_opt_design
    if {$delay_type eq "min"} {
        phys_opt_design -hold_fix
    } elseif {$delay_type eq "max"} {
        phys_opt_design
    } else {
        puts "ERROR: ATF: Unknown path type '${delay_type}'. Aborting automatic fix."
        break
    }
}

report_timing_summary -delay_type min_max -max_paths 5 -nworst 1 -file "AutoTimingFix_${attempt}_final_timing_summary.txt"

# Print a final report
if {[llength $worst_path] == 0} {
    # Loop broke early due to no paths found
    puts "ERROR: ATF: No constrained timing paths found. Exiting."
} elseif {${attempt} == 0 && ${wns} >= 0.0} {
    # Loop broke early due to no violations on first check
    puts "INFO: ATF: No timing violations detected on first check. No action required."
} else {
    # Loop broke after at least one attempt
    set worst_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min_max]
    set final_wns [get_property SLACK $worst_path]
    if {$final_wns >= 0} {
        puts "INFO: ATF: auto timing fix SUCCESS after ${attempt} attempts - final WNS is ${final_wns} ns."
        write_checkpoint -force "AutoTimingFix_success_system_top_placed.dcp"
    } elseif {$final_wns <= $ADI_AUTOFIX_WNS_THRESHOLD} {
        puts "WARNING: ATF: WNS (${wns} ns) exceeds threshold (${ADI_AUTOFIX_WNS_THRESHOLD} ns). Automatic fix aborted."
        write_checkpoint -force "AutoTimingFix_aborted_system_top_placed.dcp"
    } else {
        puts "WARNING: ATF: auto timing fix FAILURE after ${attempt} attempts - final WNS is ${final_wns} ns."
        write_checkpoint -force "AutoTimingFix_failure_system_top_placed.dcp"
    }
}

puts "INFO: auto timing fix (ATF) finished."
