###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
    
set interfaces_paths_list [split $env(LATTICE_INTERFACE_SEARCH_PATH) ";"]

foreach path $interfaces_paths_list {
    if {[regexp {^.+\/PropelIPLocal} $path PropelIPLocal_path]} {
        if {$argc > 0} {
            set fpath [lindex $argv 0]
            puts $fpath
            set file [open "$fpath" "w"]
            puts $file $path
            puts $file $PropelIPLocal_path
            puts $file $env(TOOLRTF)
            close $file
        } else {
            puts "No filepath for PropelIPLocal_path save"
        }
    }
}
