###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
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

report_timing -detail full_path -npaths 20 -setup -file timing_impl.log
report_timing -detail full_path -npaths 20 -hold -append -file timing_impl.log
report_timing -detail full_path -npaths 20 -recovery -append -file timing_impl.log
report_timing -detail full_path -npaths 20 -removal -append -file timing_impl.log

set worst_path [get_timing_paths -npaths 1 -setup]
foreach_in_collection path $worst_path {
  set slack [get_path_info $path -slack]
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -hold]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -recovery]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -removal]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack < 0} {
  set sof_files [glob *.sof]
  foreach sof_file $sof_files {
    set root_sof_file [file rootname $sof_file]
    set new_sof_file [append root_sof_file "_timing.sof"]
    file rename -force $sof_file $new_sof_file
  }
  return -code error [format "ERROR: Timing Constraints NOT met!"]
}
