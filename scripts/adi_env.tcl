###############################################################################
## Copyright (C) 2022-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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
set required_quartus_version "25.1.0"
set required_quartus_std_version "24.1std.0"
if {[info exists ::env(REQUIRED_QUARTUS_VERSION)]} {
  set required_quartus_version $::env(REQUIRED_QUARTUS_VERSION)
} elseif {[info exists REQUIRED_QUARTUS_VERSION]} {
  set required_quartus_version $REQUIRED_QUARTUS_VERSION
} elseif {$quartus_pro_isused == 0} {
  set required_quartus_version $required_quartus_std_version
}

# Define the supported tool version
set required_lattice_version "2024.2"
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
