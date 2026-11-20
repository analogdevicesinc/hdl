###############################################################################
## Copyright (C) 2020-2024, 2026 Analog Devices, Inc. All rights reserved.
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

## Returns the absolute path of the folder where the ROM initialization files
# are written: the build sub-folder when one is used, otherwise the current
# folder. Quartus already runs inside the build sub-folder and passes its
# absolute path in ad_project_dir, Vivado runs in the project folder.
#
# \return - absolute path
#

proc sysid_mem_init_dir {} {

  global ad_project_dir
  if {[info exists ad_project_dir] && $ad_project_dir != ""} {
    return [file join [pwd] $ad_project_dir]
  }
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    return [file join [pwd] $::env(ADI_PROJECT_DIR)]
  }
  return [pwd]
}

## Returns the project parameters as a "NAME=value NAME=value" string, in the
# order in which they are passed to adi_project.
#
# \return - string
#

proc sysid_project_params_string {} {

  global ad_project_param_list
  set params {}
  if {[info exists ad_project_param_list]} {
    foreach {param value} $ad_project_param_list {
      lappend params "$param=$value"
    }
  }
  return [join $params " "]
}

## Initialize global variables

set mem_init_sys_file_path [sysid_mem_init_dir]

## Converts a string input to hex and adds whitespace as padding to obtain the size defined by
# the blocksize parameter.
#
# \param[str] - string input
# \param[blocksize] - size of hex output in bytes
#
# \return - hex
#

proc stringtohex {str blocksize} {

  binary scan $str H* hex;
  return [format %0-[expr $blocksize * 2]s $hex];
}

## Generates the 8 bit checksum for the input hex string
#
# \param[hex] - string input
#
# \return - 8 bit checksum
#

proc checksum8bit {hex} {

  set byte {};
  set chks 0;
  for {set i 0} {$i < [string length $hex]} {incr i} {
    if { ($i+1) % 2 == 0} {
      append byte [string index $hex $i];
      set chks [expr $chks + "0x$byte"];
    } else {
      set byte [string index $hex $i];
      }
  };
  return [format %02x [expr {(256 - ($chks & 0xFF)) & 0xFF}]];
}

## Flips the characters of a string, four at a time. Used to fix endianness.
#
# \param[str] - string input
#
# \return - string
#

proc hexstr_flip {str} {

  set line {};
  set fstr {};
  set byte {};
  for {set i 0} {$i < [string length $str]} {incr i} {
    if {[expr ($i+1) % 8] == 0} {
      append line [string index $str $i];
      set line_d $line;
      set fline {};
      for {set j 0} {$j < [string length $line]} {incr j} {
        if {[expr ($j+1) % 2] == 0} {
          append fline [rev_by_string [append byte [string index $line $j]]];
        } else {
          set byte [string index $line $j];
        }
      };
      append fstr [rev_by_string $fline];
      set line {};
    } else {
      append line [string index $str $i];
    }
  };
  return $fstr;
}

## Reverses the character order of a string
#
# \param[str] - string input
#
# \return - string
#

proc rev_by_string {str} {

  set rev "";
  set length [string length $str];
  for {set i 0} {$i < $length} {incr i} {
    set rev "[string index $str $i]$rev";
  };
  return $rev;
}

## Builds the content of the system ROM, without the padding to the ROM size.
#
# \param[custom_string] - string input
#
# \return - hex
#

proc sysid_sys_rom_hex {{custom_string {}}} {
  global project_name;
  if {[info exists project_name]} {
    puts "project_name: $project_name";
  } else {
    set project_name [current_project];
    puts "project_name: $project_name";
  }

  if {[catch {exec git rev-parse HEAD} gitsha_string] != 0} {
    set gitsha_string 0;
  }
  set gitsha_hex [hexstr_flip [stringtohex $gitsha_string 44]];
  puts "gitsha_string: $gitsha_string";
  puts "gitsha_hex: $gitsha_hex";

  set git_clean_string "f";
  if {$gitsha_string != 0} {
    if {[catch {exec git status} gitstat_string] == 0} {
      if [expr [string match *modified* $gitstat_string] == 0] {
        set git_clean_string "t";
      }
    }
    if {[catch {exec git branch --no-color} gitbranch_string] != 0} {
      set gitbranch_string "";
    } else {
      set gitbranch_string [lindex $gitbranch_string [expr [lsearch -exact $gitbranch_string "*"] + 1]];
	}
  } else {
    set gitbranch_string "";
  }

  set git_clean_hex [hexstr_flip [stringtohex $git_clean_string 4]];
  puts "git_clean_string: $git_clean_string";
  puts "git_clean_hex: $git_clean_hex";

  set git_branch_hex [hexstr_flip [stringtohex $gitbranch_string 128]];
  puts "gitbranch_string: $gitbranch_string";
  puts "git_branch_hex: $git_branch_hex";

  set vadj_check_string "vadj";
  set vadj_check_hex [hexstr_flip [stringtohex $vadj_check_string 4]];
  puts "vadj_check_string: $vadj_check_string";
  puts "vadj_check_hex: $vadj_check_hex";

  set thetime [clock seconds];
  set timedate_hex [hexstr_flip [stringtohex $thetime 12]];
  puts "thetime: $thetime";
  puts "timedate_hex: $timedate_hex";

  set verh_hex {};
  set verh_size 448;

  append verh_hex $git_branch_hex $gitsha_hex $git_clean_hex $vadj_check_hex $timedate_hex;
  append verh_hex "00000000" [checksum8bit $verh_hex] "000000";

  set verh_hex [format %0-[expr [expr $verh_size] * 8]s $verh_hex];
  set table_size 16;
  set comh_size [expr 8 * $table_size];
  set comh_ver_hex "00000003";

  set boardname_string [lindex [split $project_name _] [expr [llength [split $project_name _]] - 1]];
  set boardname_hex [hexstr_flip [stringtohex $boardname_string 32]];

  puts "boardname_string: $boardname_string";
  puts "boardname_hex: $boardname_hex";

  set projname_string [lindex [split [string trimright [string trimright $project_name $boardname_string] _] /] end]
  set projname_hex [hexstr_flip [stringtohex $projname_string 32]];

  puts "projname_string: $projname_string";
  puts "projname_hex: $projname_hex";

  set custom_string_length [expr ([string length $custom_string] + 3) / 4 * 4]
  # Can't use max function on quartus
  if {$custom_string_length < 64} {
    set custom_string_length 64
  }
  set custom_hex [hexstr_flip [stringtohex $custom_string $custom_string_length]];

  puts "custom_string: $custom_string";
  puts "custom_hex: $custom_hex";

  set pr_offset "00000000";

  set comh_hex {};
  append comh_hex $comh_ver_hex;

  set offset $table_size;
  append comh_hex [format %08s [format %0.2x $offset]];

  set offset [expr $table_size + $verh_size];
  append comh_hex [format %08s [format %0.2x $offset]];

  set offset [expr $offset + [expr [string length $projname_hex] / 8]];
  append comh_hex [format %08s [format %0.2x $offset]];

  set offset [expr $offset + [expr [string length $boardname_hex] / 8]];
  append comh_hex [format %08s [format %0.2x $offset]];

  set offset $pr_offset;
  append comh_hex [format %08s $offset];

  set comh_hex [format %0-[expr [expr $table_size - 2] * 8]s $comh_hex];
  append comh_hex "00000000" [checksum8bit $comh_hex] "000000";

  return $comh_hex$verh_hex$projname_hex$boardname_hex$custom_hex;
}

## Writes the system ROM content, padded to the ROM size, to mem_init_sys.txt.
#
# \param[sys_mem_hex] - ROM content, as returned by sysid_sys_rom_hex
# \param[address_bits] - ROM address width
#
# \return - absolute path of the written file
#

proc sysid_write_sys_init_file {sys_mem_hex address_bits} {

  set memory_size [expr int(pow(2, $address_bits)) * 8]
  if {[string length $sys_mem_hex] > $memory_size} {
    error "System ID ROM content needs [expr [string length $sys_mem_hex] / 8] words,\
      ROM_ADDR_BITS=$address_bits provides only [expr $memory_size / 8]."
  }
  set sys_mem_hex [format %0-${memory_size}s $sys_mem_hex];

  set mem_init_sys_file [file join [sysid_mem_init_dir] mem_init_sys.txt]
  set sys_mem_file [open $mem_init_sys_file "w"];

  for {set i 0} {$i < [string length $sys_mem_hex]} {incr i} {
    if { ($i+1) % 8 == 0} {
      puts $sys_mem_file [string index $sys_mem_hex $i];
    } else {
      puts -nonewline $sys_mem_file [string index $sys_mem_hex $i];
    }
  };
  close $sys_mem_file;
  return $mem_init_sys_file
}

## Generates a file used for initializing the system ROM.
#
# \param[custom_string] - string input
# \param[address_bits] - ROM address width
#
# \return - absolute path of the written file
#

proc sysid_gen_sys_init_file {{custom_string {}} {address_bits {9}}} {

  return [sysid_write_sys_init_file [sysid_sys_rom_hex $custom_string] $address_bits]
}

## Sets up the system ID: generates mem_init_sys.txt, with the project
# parameters and the optional custom string, and configures axi_sysid_0 and
# rom_sys_0 to use it. The ROM address width is the smallest one, starting
# from address_bits, that fits the content.
#
# \param[custom_string] - extra information, appended after the project parameters
# \param[address_bits] - minimum ROM address width
#

proc ad_sysid_init {{custom_string {}} {address_bits {9}}} {

  set sys_cstring [string trim "[sysid_project_params_string] $custom_string"]
  set sys_mem_hex [sysid_sys_rom_hex $sys_cstring]
  while {[string length $sys_mem_hex] > [expr int(pow(2, $address_bits)) * 8]} {
    incr address_bits
  }
  puts "System ID ROM_ADDR_BITS: $address_bits"
  set mem_init_sys_file [sysid_write_sys_init_file $sys_mem_hex $address_bits]

  if {[info commands set_instance_parameter_value] != ""} {
    set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} $address_bits
    set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} $address_bits
    set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} $mem_init_sys_file
  } else {
    ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS $address_bits
    ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE $mem_init_sys_file
    ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS $address_bits
  }
}

## Generates a file used for initializing the PR ROM.
#
# \param[custom_string] - string input
#

proc sysid_gen_pr_init_file {custom_string} {

  set custom_hex [stringtohex $custom_string 64];
  set mem_init_pr_file_path [file join [sysid_mem_init_dir] mem_init_pr.txt]

  set pr_mem_file [open $mem_init_pr_file_path "w"];
  for {set i 0} {$i < [string length $custom_hex]} {incr i} {
    if { ($i+1) % 8 == 0} {
      puts $pr_mem_file [string index $custom_hex $i];
    } else {
      puts -nonewline $pr_mem_file [string index $custom_hex $i];
    }
  };
  close $pr_mem_file;
}
