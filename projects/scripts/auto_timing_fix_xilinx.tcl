###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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
# If a HOLD violation is present before the ATF loop, route_design is called
# as a workaround for Vivado 2024.x/2025.x hold timing issues.
#

# ATF loop function
# Arguments:
#   prefix - string prefix for checkpoint and log file names
#   max_attempts - maximum number of fix attempts
#   wns_threshold - WNS threshold for automatic fix (should be negative)
# Returns a list: {status attempts_made}
#   status: "success", "failure", "no_paths", "no_violations", "threshold_exceeded", "unknown_type"
proc run_atf_loop {prefix max_attempts wns_threshold} {
    set attempt 0
    set status "unknown"

    write_checkpoint -force "${prefix}_before_system_top_routed.dcp"

    while {$attempt < $max_attempts} {
        # Get the single worst timing path object in the design
        set worst_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min_max]
        if {[llength $worst_path] == 0} {
            set status "no_paths"
            break
        }
        set wns [get_property SLACK $worst_path]
        set delay_type [get_property DELAY_TYPE $worst_path] ;# Returns "max" for Setup, "min" for Hold

        if {$wns >= 0.0} {
            set status "success"
            break
        }

        # Check if autofix should be attempted based on WNS threshold
        if {$wns > $wns_threshold} {
            incr attempt
            puts "INFO: ATF: \[$prefix\] WNS = ${wns} ns of type $delay_type. Attempting automatic fix (${attempt} of ${max_attempts})."
            report_timing_summary -delay_type min_max -max_paths 5 -nworst 1 -file "${prefix}_${attempt}_before_timing_summary.txt"
        } else {
            set status "threshold_exceeded"
            break
        }

        # Attempt fix via phys_opt_design
        if {$delay_type eq "min"} {
            phys_opt_design -hold_fix
        } elseif {$delay_type eq "max"} {
            phys_opt_design
        } else {
            puts "ERROR: ATF: \[$prefix\] Unknown path type '${delay_type}'. Aborting automatic fix."
            set status "unknown_type"
            break
        }

    }

    # Get final timing status after loop
    set worst_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min_max]
    if {[llength $worst_path] > 0} {
        set wns [get_property SLACK $worst_path]
        set delay_type [get_property DELAY_TYPE $worst_path]
        if {$wns >= 0.0} {
            set status "success"
        }
    }

    report_timing_summary -delay_type min_max -max_paths 5 -nworst 1 -file "${prefix}_${attempt}_final_timing_summary.txt"

    # Write appropriate checkpoint based on status
    if {$status eq "success"} {
        puts "INFO: ATF: \[$prefix\] Auto Timing Fix SUCCESS after ${attempt} attempts - final WNS is ${wns} ns."
        write_checkpoint -force "${prefix}_success_system_top_routed.dcp"
    } elseif {$status eq "no_paths"} {
        puts "ERROR: ATF: \[$prefix\] No constrained timing paths found."
    } elseif {$status eq "threshold_exceeded"} {
        puts "WARNING: ATF: \[$prefix\] WNS (${wns} ns) exceeds threshold (${wns_threshold} ns). Automatic fix aborted."
        write_checkpoint -force "${prefix}_aborted_system_top_routed.dcp"
    } else {
        puts "WARNING: ATF: \[$prefix\] Auto Timing Fix FAILURE after ${attempt} attempts - final WNS is ${wns} ns."
        write_checkpoint -force "${prefix}_failure_system_top_routed.dcp"
    }

    return [list $status $attempt]
}

# Main script execution --------------------------------------------------------
puts "INFO: starting Auto Timing Fix (ATF)..."

# Set default values if not provided
if {![info exists ADI_AUTOFIX_WNS_THRESHOLD]} {
    set ADI_AUTOFIX_WNS_THRESHOLD -2.0
    puts "INFO: ATF: ADI_AUTOFIX_WNS_THRESHOLD not set, using default of $ADI_AUTOFIX_WNS_THRESHOLD"
}
if {![info exists ADI_AUTOFIX_MAX_ATTEMPTS]} {
    set ADI_AUTOFIX_MAX_ATTEMPTS 5
    puts "INFO: ATF: ADI_AUTOFIX_MAX_ATTEMPTS not set, using default of $ADI_AUTOFIX_MAX_ATTEMPTS"
}

# Call route_design if hold violation is present
# NOTE: This is a workaround that addresses hold timing issues that appear in
# Vivado 2024.x/2025.x
# This remedy was suggested by an AMD employee through the Xilinx forums.
# References:
# https://adaptivesupport.amd.com/s/question/0D5Pd00000pVOyuKAG/unexpected-hold-errors-when-moving-to-vivado-20251?language=en_US
# https://adaptivesupport.amd.com/s/question/0D5Pd0000153gqkKAA/persistent-hold-timing-violations-after-upgrading-to-vivado-2025x-physoptdesign-holdfix-ineffective?language=en_US
#
# Look for hold timing violations (delay_type = min)
set worst_hold_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min]
if {[llength $worst_hold_path] > 0} {
    set wns [get_property SLACK $worst_hold_path]
    set delay_type [get_property DELAY_TYPE $worst_hold_path] ;# Returns "max" for Setup, "min" for Hold
    if {$wns < 0.0} {
        if {$delay_type eq "min"} {
            # There is a hold timing violation, so run route_design
            puts "INFO: ATF: HOLD violations are present. Calling route_design (Vivado 2024.x/2025.x workaround)..."
            route_design
            puts "INFO: ATF: route_design completed."
        }
    }
}

puts "INFO: ATF: Starting phys_opt_design loops..."
set result [run_atf_loop "ATF" $ADI_AUTOFIX_MAX_ATTEMPTS $ADI_AUTOFIX_WNS_THRESHOLD]

# Print final summary for Jenkins pipeline
set worst_path [get_timing_paths -nworst 1 -max_paths 1 -delay_type min_max]
if {[llength $worst_path] > 0} {
    set wns [get_property SLACK $worst_path]
    set delay_type [get_property DELAY_TYPE $worst_path] ;# Returns "max" for Setup, "min" for Hold
    puts "INFO: ATF: final WNS is ${wns} ns of type ${delay_type}."
    if {$wns < 0.0} {
        puts "WARNING: ATF: Auto Timing Fix FAILURE. Timing closure is NOT achieved."
    } else {
        puts "INFO: ATF: Auto Timing Fix SUCCESS. Timing closure IS achieved."
    }
}
puts "INFO: ATF: Auto Timing Fix finished."
