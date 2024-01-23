###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# environment related stuff
set ad_hdl_dir [file normalize [file join [file dirname [info script]] "../"]]

if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
}

if [info exists ::env(ADI_GHDL_DIR)] {
  set ad_ghdl_dir [file normalize $::env(ADI_GHDL_DIR)]
}

# Define the supported tool version
set required_vivado_version "2023.2"
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

# Define the supported tool version
if {![info exists REQUIRED_QUARTUS_VERSION]} {
  set REQUIRED_QUARTUS_VERSION "23.2.0"
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
