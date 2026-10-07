###############################################################################
## Copyright (C) 2022-2026 Analog Devices, Inc. All rights reserved.
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

# environment related stuff
set ad_hdl_dir [file normalize [file join [file dirname [info script]] "../"]]

if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
} else {
  set env(ADI_HDL_DIR) $ad_hdl_dir
}

if [info exists ::env(ADI_GHDL_DIR)] {
  set ad_ghdl_dir [file normalize $::env(ADI_GHDL_DIR)]
}

# Define the supported tool version
set required_vivado_version "2025.1"
if {[info exists ::env(REQUIRED_VIVADO_VERSION)]} {
  set required_vivado_version $::env(REQUIRED_VIVADO_VERSION)
} elseif {[info exists REQUIRED_VIVADO_VERSION]} {
  set required_vivado_version $REQUIRED_VIVADO_VERSION
}

# Define the ADI_IGNORE_VERSION_CHECK environment variable to skip version check
if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

# Check $QUARTUS_PRO_ISUSED environment variables
# If it's not defined auto-detect it based on  the project name
set quartus_pro_isused 1
if {[info exists ::env(QUARTUS_PRO_ISUSED)]} {
  set quartus_pro_isused $::env(QUARTUS_PRO_ISUSED)
} elseif {[info exists QUARTUS_PRO_ISUSED]} {
  set quartus_pro_isused $QUARTUS_PRO_ISUSED
} else {
  set quartus_std_carriers {de10nano c5soc}

  foreach carrier $quartus_std_carriers {
    if {[string match "*$carrier*" [pwd]]} {
      set quartus_pro_isused 0
      break
    }
  }
}

# Define the supported tool version
# If the variable is not defined, set it to standard if the carrier requires it
set required_quartus_version "26.1.0"
set required_quartus_std_version "25.1std.0"
if {[info exists ::env(REQUIRED_QUARTUS_VERSION)]} {
  set required_quartus_version $::env(REQUIRED_QUARTUS_VERSION)
} elseif {[info exists REQUIRED_QUARTUS_VERSION]} {
  set required_quartus_version $REQUIRED_QUARTUS_VERSION
} elseif {$quartus_pro_isused == 0} {
  set required_quartus_version $required_quartus_std_version
}

# Define the supported tool version
set required_lattice_version "2025.2"
if {[info exists ::env(REQUIRED_LATTICE_VERSION)]} {
  set required_lattice_version $::env(REQUIRED_LATTICE_VERSION)
} elseif {[info exists REQUIRED_LATTICE_VERSION]} {
  set required_lattice_version $REQUIRED_LATTICE_VERSION
}

# This helper pocedure retrieves the value of varible from environment if exists,
# other case returns the provided default value
#  name - name of the environment variable
#  default_value - returned vale in case environment variable does not exists
proc get_env_param {name default_value} {
  if [info exists ::env($name)] {
    puts "Getting from environment the parameter: $name=$::env($name) "
    return $::env($name)
  } else {
    return $default_value
  }
}
