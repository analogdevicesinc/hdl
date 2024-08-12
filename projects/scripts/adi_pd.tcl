###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Initialize global variables

set mem_init_sys_file_path [pwd]
if {[info exists ::env(ADI_PROJECT_DIR)]} {
  set mem_init_sys_file_path [string trimright [pwd]/$::env(ADI_PROJECT_DIR) "/"]
}

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
  return [format %0.2x [expr 255 - [expr "0x[string range [format %0.2x $chks] [expr [string length [format %0.2x $chks]] -2] [expr [string length [format %0.2x $chks]] -1]]"] +1]];
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

## Generates a file used for initializing the system ROM.
#
# \param[custom_string] - string input
#

proc sysid_gen_sys_init_file {{custom_string {}} {address_bits {9}}} {
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

  set git_branch_hex [hexstr_flip [stringtohex $gitbranch_string 28]];
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
  set comh_ver_hex "00000002";

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

  set memory_size [expr int(pow(2, $address_bits)) * 8]
  set sys_mem_hex [format %0-${memory_size}s [concat $comh_hex$verh_hex$projname_hex$boardname_hex$custom_hex]];

  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    set mem_init_sys_file_path [pwd]/$::env(ADI_PROJECT_DIR)mem_init_sys.txt
  } else {
    set mem_init_sys_file_path "mem_init_sys.txt"
  }
  set sys_mem_file [open ${mem_init_sys_file_path} "w"];

  for {set i 0} {$i < [string length $sys_mem_hex]} {incr i} {
    if { ($i+1) % 8 == 0} {
      puts $sys_mem_file [string index $sys_mem_hex $i];
    } else {
      puts -nonewline $sys_mem_file [string index $sys_mem_hex $i];
    }
  };
  close $sys_mem_file;
}

## Generates a file used for initializing the PR ROM.
#
# \param[custom_string] - string input
#

proc sysid_gen_pr_init_file {custom_string} {

  set custom_hex [stringtohex $custom_string 64];
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    set mem_init_pr_file_path $::env(ADI_PROJECT_DIR)mem_init_pr.txt
  } else {
    set mem_init_pr_file_path "mem_init_pr.txt"
  }

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
