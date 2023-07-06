#!/usr/bin/perl -w

###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
#
# This script is meant to be used together with gtwizard_generator.tcl
# It parses and provides as output a list of unique parameters to a provided GT wizard configuration
# Must be called from the project folder, where the IP instance is (*.gen/sources_1/ip)
###############################################################################

use strict;
use warnings;
# use bigint;

################################################################################
##  Check the status of the required modules
my @modules = qw (
  Cwd
  Data::Dumper
);

for(@modules) {
    eval "use $_";
    if ($@) {
        warn "Module not found : $_ \n Please install it!" if $@;
    }
}

sub print_hash {

  my ($hash_ref) = @_;

  foreach my $key (keys %$hash_ref) {
    print " $key : $$hash_ref{$key}\n ";
  }

}

################################################################################
## SUBROUTINES
################################################################################
# Search for the COMMON and CHANNEL attributes from the generated files
# Required parameters : $_ - file name
################################################################################
sub get_attribute_name {

  my ($pfile) = @_;
  my $myname = (caller(0))[3];

  # Try to open the file
  open(READFILE, "<$pfile") or die print "@[$myname] Can not open file called $pfile for reading.\n";

  my $xcvr_params_str = join('', <READFILE>);
  my @xcvr_params;

  # remove comments //anything
  my $comment_regex = qr/^\s*\/{2}.*\n/mp;
  my $subst = '';
  $xcvr_params_str = $xcvr_params_str=~s/$comment_regex/$subst/rg;

  # return the attribute block from the *_[COMMON|CHANNEL] instance
  # Ultrascale/Ultrascale+ version
  # if ($xcvr_params_str =~ m/#\(((\n(.*\),\n){2,}).*\)\n)/) {
  # Version that works for both 7 series and Ultrascale/Ultrascale+
  # This regex searches for the IP instance in the verilog code. In 7 series there are spaces at the begining of the line, while for Ultrascale there are not. After that searches for the name of the instance followed by spaces (0 or more) and a #. The next characters are maybe a \n followed by spaces and (. Going forward, it accepts \n followed by anything as long as it ends with '),'. Or a space followed by anything. The '?' is there to make the regex be non-greedy. The group after ( is searched for at least 2 times and must be followed by a ')\n'. This regex matches . with \n becouse of the /m at the end.
  my $regex = qr/^\s*[A-Z1-9_]*\s*#\n?\s*\((((\n(.*\),\n)|(\s.*?)){2,}).*\)\n)/mp;
  if ($xcvr_params_str =~ /$regex/ ) {

    @xcvr_params = split ("\n", $1);

    # the first element is not valid
    splice(@xcvr_params, 0, 1);
  } else {
    print "@[$myname] No match in $pfile, check regexp!\n";
  }
  close(READFILE) or die print "@[$myname] Can not close file called $pfile.\n";


  # parse out the attribute names
  foreach my $i (0..$#xcvr_params) {
    # remove leading white space
    $xcvr_params[$i] =~ s/^\s+//;

    # remove trailing text, keep just the first word
    $xcvr_params[$i] =~ s/\s+.*$//;

    # remove leading dot character
    $xcvr_params[$i] =~ s/^\.//;
  }
return @xcvr_params;
}

################################################################################
# Mine the COMMON and CHANNEL attributes into a list
# Required parameters : $1 - file name
#                       $2 - transceiver type (e.g. GTHE4_COMMON)
#                       $3 - parameter name list - reference array
################################################################################
sub get_attribute_value {

  my ($pfile, $xcvr_type, $param_list) = @_;
  my $myname = (caller(0))[3];

  my %params;

  my $path = Cwd::cwd();

  # Try to open the file
  open(READFILE, "<$pfile") or die print "@[$myname] Can not open file called $pfile for reading at $path\n";

  my $xcvr_params_str = join('', <READFILE>);

  # remove comments //anything
  my $comment_regex = qr/^\s*\/{2}.*\n/mp;
  my $subst = '';
  $xcvr_params_str = $xcvr_params_str=~s/$comment_regex/$subst/rg;

  foreach my $param (@$param_list) {
    if ((uc($xcvr_type) eq "GTXE2_GT") or (uc($xcvr_type) eq "GTXE2_COMMON")) {
      my $regex = qr/^\s*[A-Z1-9_]*\s*#\n?\s*\((((\n(.*\),\n)|(\s.*?)){2,}).*\)\n)/mp;
      if ($xcvr_params_str =~ /$regex/ ) {
        my $new_xcvr_params_str = $1;

        if ($new_xcvr_params_str =~ m/($param.*\n)/i) {
          my $value = $1;
          # remove the leading attribute name and \s and '('
          $value =~ s/^.*\(//;

          # remove the trailing '),\n'
          $value =~ s/\).*$//;

          # save the attribute into the hash
          chomp($value);
          $params{$param} = $value;
          # print "$value -> ";
          # print "$params{$param}\n"
      } else {
        print "@[$myname] WARNING: Can not find $param\n";
        }
      }
    } elsif ($xcvr_params_str =~ m/($xcvr_type\_$param.*\n)/i) {
        my $value = $1;
        $value =~ s/${xcvr_type}_//;
        # remove the leading attribute name and \s and '('
        $value =~ s/^.*\(//;

        # remove the trailing '),\n'
        $value =~ s/\).*$//;

        # save the attribute into the hash
        chomp($value);
        $params{$param} = $value;
      } else {
        print "@[$myname] WARNING: Can not find $xcvr_type\_$param\n";
      }

  }
  close(READFILE) or die print "@[$myname] Can not close file called $pfile.\n";
return %params;
}

################################################################################
# Save the attribute hash into a file
# Required parameters : $1 - file name
#                       $2 - parameter hash - reference
################################################################################
sub save_to_file {

  my ($pfile, $params_ref) = @_;
  my $myname = (caller(0))[3];

  # Try to open file for write
  open(WRITEFILE, ">$pfile") or die print "@[$myname] Can not open file called $pfile for writing.\n";

  foreach my $key (sort keys %$params_ref){
    print WRITEFILE ".$key  ($$params_ref{$key}),\n";
  }
  close(WRITEFILE) or die print "@[$myname] Can not close file called $pfile.\n";
}

################################################################################
# Update util_adxcvr_xc[m|h] with the generated attributes
# Required parameters : $1 - file name and location of the util_adxcvr_xcm.v
#                       $2 - GT type, valid values {GTXE2, GTHE3, GTHE4}
#                       $3 - generated parameter hash - reference
################################################################################
sub xcvr_diff {

  my ($pfile, $gt_type, $params_ref) = @_;
  my $myname = (caller(0))[3];

  # Try to open file for read
  if (not open(READFILE, "<$pfile")) {
    print "WARNING@[$myname] : Can not update $pfile ...\n";
    return 0;
  }

  my @File = "";
  while (my $fline = <READFILE>) {
    push(@File, $fline);
  }

  # Find the GT's attributes location in the file
  my $gt_paramblock_start = 0;
  my $gt_paramblock_end = 0;
  for my $i (0 .. $#File) {
    if ($File[$i] =~ m/\b$gt_type/i) {
      $gt_paramblock_start = $i;
    }
    if ($File[$i] =~ m/\bi_$gt_type/i) {
      $gt_paramblock_end = $i;
    }
  }
  close(READFILE) or die print "@[$myname] Can not close file called $pfile.\n";

  ## Update the attributes with the generated values
  for my $i ($gt_paramblock_start..$gt_paramblock_end) {
    if ($File[$i] =~ m/\.\w*/) { ## it match a word which starts with a dot
      my $param = $File[$i];
      $param =~ s/^\s*\.//;
      $param =~ s/\s*\(.*$//;
      chomp($param);
      if (exists $$params_ref{$param}) {
        $File[$i] =~ s/\(.*?\)/\($$params_ref{$param}\)/;
      } else {
        ## print "@[$myname] WARNING : Parameter $param does not exist in the generated GT instance!\n"
      }
    }
  }

  # Try to open file for write
  open(WRITEFILE, ">$pfile") or die print "@[$myname] Can not open file called $pfile for writing.\n";

  foreach my $line (@File){
    print WRITEFILE $line;
  }
  close(WRITEFILE) or die print "@[$myname] Can not close file called $pfile.\n";

  ## save the diff between the current and updated XCVR files
  my $file_name = $pfile;
  $file_name =~ s/^.*\///;
  $file_name =~ s/\.v$//;

  my $check_git = `git status`;
  if ($check_git =~ m/On branch/i) {
    system "git diff $pfile > $file_name.diff";
    system "git checkout -- $pfile";
  } else {
    print "WARNING: ADI's util_xcvr's can not be updated, because the current direcotry is NOT an HDL repository!\n";
  }

}

################################################################################
# Parse out the default value of a GT instance
# Required parameters : $1 - file name and location of the util_adxcvr_xc[m|h].v
#                       $2 - GT type, valid values {GTXE2, GTHE3, GTHE4}
################################################################################
sub xcvr_default {

  my ($pfile, $gt_type) = @_;
  my $myname = (caller(0))[3];
  my %parameters;
  my %default_attributes;

  # Try to open file for read
  if (not open(READFILE, "<$pfile")) {
    print "WARNING@[$myname] : Can not update $pfile ...\n";
    return 0;
  }

  # Save file into an array, also save all parameters into a hash
  my @File = "";
  while (my $fline = <READFILE>) {
    push(@File, $fline);
    if ($fline =~ m/\bparameter\b/i) {
      my @param = split '=', $fline;
      (my $param_name) = $param[0] =~ m/\b\w*\s+$/g;
      $param_name =~ s/^\s+|\s+$//g;
      my $param_value = $param[1];
      $param_value =~ s/,.*$//;
      $param_value =~ s/^\s+|\s+$//g;
      $parameters{$param_name} = $param_value;
    }
  }

  # Find the GT's attributes location in the file
  my $gt_paramblock_start = 0;
  my $gt_paramblock_end = 0;
  for my $i (0 .. $#File) {
    if ($File[$i] =~ m/\b$gt_type/i) {
      $gt_paramblock_start = $i;
    }
    if ($File[$i] =~ m/\bi_$gt_type/i) {
      $gt_paramblock_end = $i;
    }
  }
  close(READFILE) or die print "@[$myname] Can not close file called $pfile.\n";

  ## Find all the attribute and save it into a hash
  for my $i ($gt_paramblock_start..$gt_paramblock_end) {
    if ($File[$i] =~ m/\.\w*/) { ## it match a word which starts with a dot
      my $param = $File[$i];
      my $value = $File[$i];
      # parse out the parameter name
      $param =~ s/^\s*\.//;
      $param =~ s/\s*\(.*$//;
      chomp($param);
      # parse out the value name
      $value =~ s/^.*\(//;
      $value =~ s/\).*$//;
      chomp($value);
      ## if it's a module parameter switch to its value
      if (exists $parameters{$value}) {
        $value = $parameters{$value};
      }
      ## convert to hex only if it's a binary number, leave it as it is otherwise
      my $old_value = $value;
      $value =~ s/^.*b//;
      if ($value =~ /^[0-1]+$/) {
        $value = sprintf('0x%X', oct("0b$value"));
        $default_attributes{$param} = $value;
      } else {
        $default_attributes{$param} = $old_value;
      }

    }
  }

return \%default_attributes;
}

################################################################################
# Generate the required DRP sequence for software
# Required parameters : $1 - util_xcvr diff file
#                       $2 - parameter hash - reference
#                       $3 - target file name
################################################################################
sub gen_drp_cmd {

  my ($pfile_rd, $xcvr_params_ref, $pfile_wr) = @_;
  my $myname = (caller(0))[3];
  #my $t3 = Text::SimpleTable::AutoWidth->new( captions => [qw/ DRP_register Value_binary Value_hex /] );
  my %drp_access;

  # Try to open file for read
  open(READFILE, "<$pfile_rd") or die print "@[$myname] Can not open file called $pfile_rd for reading.\n";
  my @File = "";
  while (my $fline = <READFILE>) {
    if ($fline =~ m/^\+\s+/) {
      push(@File, $fline);
    }
  }
  close(READFILE) or die print "@[$myname] Can not close file called $pfile_rd.\n";

  # Try to open file for write
  open(WRITEFILE, ">$pfile_wr") or die print "@[$myname] Can not open file called $pfile_wr for writing.\n";

  # Parse the differences and check if the attribute is valid
  for my $i (0 .. $#File) {
    my $param_name = $File[$i];
    #print "$param_name\n";
    $param_name =~ s/^\+\s*\.//;
    $param_name =~ s/\s+.*$//;
    chomp($param_name);
    #print "$param_name\n\n";

    my $param_value = $File[$i];
    $param_value =~ s/^.*\(//;
    $param_value =~ s/\).*$//;
    chomp($param_value);
    #print "$param_value\n";
    ## ignore all attributes which are related to unused features and
    ## double check attribute validity
    if ($param_name =~ /^(?!ES_)(?!PCIE_)(?!TXPI_)(?!TX_PI_BIASSET)/) {
      if (exists $$xcvr_params_ref{$param_name}) {
        my $param_value_hex = $param_value;
        $param_value_hex =~ s/^.*'b//;
        ## convert to hex only if it's a binary number, leave it as it is otherwise
        if ($param_value_hex =~ /^[0-1]+$/) {
          $param_value_hex = sprintf('0x%X', oct("0b$param_value_hex"));
        }
        #$t3->row($param_name, $param_value, $param_value_hex);
        print WRITEFILE "$param_name - $param_value - $param_value_hex\n";
        $drp_access{$param_name} = $param_value_hex;
      } else {
        if ($param_name ne "") {
          print "@[$myname] WARNING : Parameter $param_name does not exist from $pfile_rd!\n"
        }
      }
     }
  }

  #print WRITEFILE $t3->draw;
  print WRITEFILE "\n";
  close(WRITEFILE) or die print "@[$myname] Can not close file called $pfile_wr.\n";

  return \%drp_access;
}

################################################################################
# Parse all the PLL dividers into a file
# Required parameters : $1 - name of the file
#                       $2 - generated common parameter hash - reference
#                       $3 - generated channel parameter hash - reference
#
# Return value - a hash with the PLL dividers for further processing
#
################################################################################
sub parse_pll_dividers {

  my ($pfile, $cm_params_ref, $ch_params_ref) = @_;
  my $myname = (caller(0))[3];

  ## Hash for storing all the PLL dividers
  my %pll_dividers = (
      "QPLL0_FBDIV" => 0,
      "QPLL0_FBDIV_G3" => 0,
      "QPLL0_REFCLK_DIV" => 0,
      "QPLL0CLKOUT_RATE" => 0,
      "QPLL1_FBDIV" => 0,
      "QPLL1_FBDIV_G3" => 0,
      "QPLL1_REFCLK_DIV" => 0,
      "QPLL1CLKOUT_RATE" => 0,
      "CPLL_FBDIV" => 0,
      "CPLL_FBDIV_45" => 0,
      "CPLL_REFCLK_DIV" => 0,
      "RXOUT_DIV" => 0,
      "TXOUT_DIV" => 0,
      "RX_CLK25_DIV" => 0,
      "TX_CLK25_DIV" => 0
  );
  my %used_pll_dividers;

  # Update the PLL divider hash
  foreach my $pll_dividers_key (keys %pll_dividers) {
    if (exists $$cm_params_ref{$pll_dividers_key}) {
      $used_pll_dividers{$pll_dividers_key} = $$cm_params_ref{$pll_dividers_key};
    }
    if (exists $$ch_params_ref{$pll_dividers_key}) {
      $used_pll_dividers{$pll_dividers_key} = $$ch_params_ref{$pll_dividers_key};
    }
  }

  # Try to open file for write
  open(WRITEFILE, ">$pfile") or die print "@[$myname] Can not open file called $pfile for writing.\n";

  foreach my $pll_dividers_key (keys %used_pll_dividers) {
      print WRITEFILE "$pll_dividers_key = $used_pll_dividers{$pll_dividers_key}\n";
  }

  close(WRITEFILE) or die print "@[$myname] Can not close file called $pfile.\n";

return \%used_pll_dividers;
}

################################################################################
# Parse the generated file returned by the GT Wizard of a given configuration
# and return all the GT attribute and its values
# Required parameters : $1 - XCVR type
#                       $2 - GT Instance type (expected values: 'CHANNEL' or 'COMMON')
#                       $3 - the path to util_adxcvr_xc[m|h]
#
################################################################################
sub parse_gt_attribute {

  my $myname = (caller(0))[3];
  my ($xcvr_type, $xcvr_ins_type, $hdl_path) = @_;

  ## arrays and hashes for the attributes
  my @xcvr_attribute_names;
  my %xcvr_attribute;

  if (uc($xcvr_type) eq "GTXE2"){
    ## common and gt
    my $fp_xcvr_wrapper = `find . -iname '*$xcvr_type*_$xcvr_ins_type.v' -print0 -quit`;
    #chomp($fp_xcvr_wrapper);

    ## hdl's repo util_adxcvr files -- we need this for comparison and default values
    $xcvr_ins_type = lc($xcvr_ins_type);
    my $xcvr_path;
    if ($xcvr_ins_type eq "gt") {
       $xcvr_path = "${hdl_path}/library/xilinx/util_adxcvr/util_adxcvr_xch.v";

    } elsif ($xcvr_ins_type eq "common") {
       $xcvr_path = "${hdl_path}/library/xilinx/util_adxcvr/util_adxcvr_xcm.v";
    } else {
      die print "@[$myname] Invalid instance type. Expected values are GT or COMMON.\n";
    }

    if (($fp_xcvr_wrapper eq "") && ($xcvr_ins_type eq "common")) {
      ## print "NOTE : QPLL is not used in this configuration ...\n";
    } else {

      # extract all the attributes
      # TODO: get name from the fp_xcvr_wrapper file
      my $ls = `pwd`;
      @xcvr_attribute_names = get_attribute_name ($fp_xcvr_wrapper);
      %xcvr_attribute = get_attribute_value ($fp_xcvr_wrapper, "$xcvr_type\_$xcvr_ins_type", \@xcvr_attribute_names);

      # save into a file
      save_to_file("$xcvr_ins_type.txt", \%xcvr_attribute);

      # create a git diff for comparison
      xcvr_diff($xcvr_path, $xcvr_type, \%xcvr_attribute);

    }
  } else{
    ## find the COMMON and CHANNEL instances
    my $fp_xcvr = `find . -iname '*$xcvr_type\_$xcvr_ins_type.v' -print0 -quit`;
    my $fp_xcvr_wrapper = `find . -iname '*gt*_$xcvr_ins_type\_wrapper.v' -print0 -quit`;

    ## hdl's repo util_adxcvr files -- we need this for comparison and default values
    $xcvr_ins_type = lc($xcvr_ins_type);
    my $xcvr_path;
    if ($xcvr_ins_type eq "channel") {
       $xcvr_path = "${hdl_path}/library/xilinx/util_adxcvr/util_adxcvr_xch.v";

    } elsif ($xcvr_ins_type eq "common") {
       $xcvr_path = "${hdl_path}/library/xilinx/util_adxcvr/util_adxcvr_xcm.v";
    } else {
      die print "@[$myname] Invalid instance type. Expected values are CHANNEL or COMMON.\n";
    }

    if (($fp_xcvr eq "") && ($xcvr_ins_type eq "common")) {
      ## print "NOTE : QPLL is not used in this configuration ...\n";
    } else {

      # extract all the attributes
      @xcvr_attribute_names = get_attribute_name ($fp_xcvr);
      %xcvr_attribute = get_attribute_value ($fp_xcvr_wrapper, "$xcvr_type\_$xcvr_ins_type", \@xcvr_attribute_names);

      # save into a file
      save_to_file("$xcvr_ins_type.txt", \%xcvr_attribute);

      # create a git diff for comparison
      xcvr_diff($xcvr_path, $xcvr_type, \%xcvr_attribute);

    }
  }
return \%xcvr_attribute;
}

################################################################################
# Parse the generated file returned by the GT Wizard of a given configuration
# Required parameters : $1 - XCVR type
#                       $2 - the path to the HDL repository
#
# Return value - a hash with the DRP registers for further processing
#
################################################################################
sub parse_gt {

  my ($xcvr_type, $hdl_path) = @_;
  my %gt_drp_access;

  my $xcvr_common;
  my $xcvr_channel;

  ## hash references for the attribute hash
  if (uc($xcvr_type) eq "GTXE2"){
    ## common and gt
    $xcvr_common  = parse_gt_attribute($xcvr_type, "common", $hdl_path);
    $xcvr_channel = parse_gt_attribute($xcvr_type, "gt", $hdl_path);

  } else{
    $xcvr_common  = parse_gt_attribute($xcvr_type, "common", $hdl_path);
    $xcvr_channel = parse_gt_attribute($xcvr_type, "channel", $hdl_path);
  }

    ## create the drp hash with info related to common and channel attributes and
    ## PLL dividers
    if (keys %{ $xcvr_common }) {
      $gt_drp_access{'common'} = gen_drp_cmd("util_adxcvr_xcm.diff", $xcvr_common, "common_drp_access.txt");
    }
    $gt_drp_access{'channel'} = gen_drp_cmd("util_adxcvr_xch.diff", $xcvr_channel, "channel_drp_access.txt");
    $gt_drp_access{'pll_dividers'} = parse_pll_dividers("pll_div.txt", $xcvr_common, $xcvr_channel);

    ## prune out all the PLL dividers from the common/channel hash
    foreach my $key (keys %{ $gt_drp_access{'pll_dividers'}}) {
      if (exists $gt_drp_access{'channel'}{$key}) {
        delete $gt_drp_access{'channel'}{$key};
      }
      if (exists $gt_drp_access{'common'}{$key}) {
        delete $gt_drp_access{'common'}{$key};
      }
    }

return \%gt_drp_access;
}

################################################################################
# Print a table in a CSV supported format
# Required parameters : $1 - DRP hash reference
#                       $1 - File name
#
# Return value - None
#
################################################################################
sub print_table {

  my ($gt_drp_ref, $gt_defcommon_ref, $gt_defchannel_ref, $file_name) = @_;
  my @gt_configs;
  my @gt_attributes;
  my %gt_drp_buf;

  ## save all configuration into an array
  foreach my $config_key (keys %{ $gt_drp_ref }) {
    push(@gt_configs, $config_key);
  }

  ## save all attributes into an array
  foreach my $config_key (keys %{ $gt_drp_ref }) {
    foreach my $type_key (keys %{ $$gt_drp_ref{$config_key} }) {
      if ($type_key ne 'pll_dividers') {
        foreach my $attribute_key (keys %{ $$gt_drp_ref{$config_key}{$type_key} }) {
          my $exist = 0;
          foreach (@gt_attributes) {
            if ($_ eq $attribute_key) {
              $exist = 1;
              last;
            }
          }
          if (not $exist) {
            push (@gt_attributes, $attribute_key);
          }
        }
      }
    }
  }

  ## open file
  open(MYTABLE, ">$file_name.csv") or die print "Can not open file called $file_name.csv for writing.\n";

  print MYTABLE "Attribute_names,\t";
  print MYTABLE "Default_value,\t";

  ## print the header
  foreach my $config_key (keys %{ $gt_drp_ref }) {
    print MYTABLE "$config_key,\t";
  }
  print MYTABLE "\n";

  ## populate the CSV table
  for my $i (0 .. $#gt_attributes) {
    print MYTABLE "$gt_attributes[$i],\t";
    my $default_value = "";
    if (exists $$gt_defcommon_ref{$gt_attributes[$i]}) {
      $default_value = $$gt_defcommon_ref{$gt_attributes[$i]};
      ## convert the default value to a 0xhhhh format
      $default_value = lc($default_value);
      $default_value =~ s/^\d*\'h/0x/gi;
      print MYTABLE "$default_value,\t";
    } elsif (exists $$gt_defchannel_ref{$gt_attributes[$i]}) {
      $default_value = $$gt_defchannel_ref{$gt_attributes[$i]};
      ## convert the default value to a 0xhhhh format
      $default_value = lc($default_value);
      $default_value =~ s/^\d*\'h/0x/gi;
      print MYTABLE "$default_value,\t";
    } else {
      print MYTABLE ",\t";
    }

    for my $j (0 .. $#gt_configs) {
      my $is_exist = 0;
      my $normalized;
      my $value;
      foreach my $type_key (keys %{ $$gt_drp_ref{$gt_configs[$j]}}) {
        if ((exists $$gt_drp_ref{$gt_configs[$j]}{$type_key}{$gt_attributes[$i]}) and ($$gt_drp_ref{$gt_configs[$j]}{$type_key}{$gt_attributes[$i]})) {
          $value = $$gt_drp_ref{$gt_configs[$j]}{$type_key}{$gt_attributes[$i]};
          $normalized = $value;
          $normalized =~ s/^\d*\'h/0x/gi;
          # print "$normalized : $default_value\n";
          #if (oct(lc($value)) != oct(lc($default_value))) {
          #if ((lc($$gt_drp_ref{$gt_configs[$j]}{$type_key}{$gt_attributes[$i]})) eq ($default_value)) {
          if ($normalized ne $default_value){
            print MYTABLE "$normalized,\t";
          } else {
            print MYTABLE ",\t";
          }
          $is_exist = 1;
          last;
        }
      }
      ## if the current attribute does not have a value in the current configuration
      if ($is_exist == 0) {
        print MYTABLE ",\t";
      }
    }
    print MYTABLE "\n";
  }
  close(MYTABLE) or die print "Can not close file called $file_name.csv.\n";

}

################################################################################
# Prune out all the entries which are present in every configuration with the
# same value.
# Required parameters : $1 - GT DRP hash generated by the parser
#
################################################################################
sub prune_drp_access {

  my ($gt_drp_ref) = @_;

  my %gt_generic_drp;
  my $is_generic;

  ## select a random configuration
  my @gt_drp_ref_keys = keys %$gt_drp_ref;
  my $ref_conf = $gt_drp_ref_keys[rand @gt_drp_ref_keys];

  foreach my $gt_ref_conf_type_key (keys %{ $$gt_drp_ref{$ref_conf} }) {
    foreach my $gt_ref_conf_attribute_key (keys %{ $$gt_drp_ref{$ref_conf}{$gt_ref_conf_type_key} }) {
      $is_generic = 1;
      foreach my $gt_drp_config_key (keys %{ $gt_drp_ref }) {

        if ($gt_drp_config_key ne $ref_conf) {
          if (exists $$gt_drp_ref{$gt_drp_config_key}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key}) {
            if ($$gt_drp_ref{$gt_drp_config_key}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key} eq '') {
              delete $$gt_drp_ref{$gt_drp_config_key}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key};
            }
            ## check if a given attribute value is the same in all the configurations
            elsif ($$gt_drp_ref{$ref_conf}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key} ne
                $$gt_drp_ref{$gt_drp_config_key}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key}) {
              $is_generic = 0;
            }
          } else {
            ## if it does not exists, can not be generic
            $is_generic = 0;
          }
        }
      }
      if ($is_generic) {
        # Store it into another hash
        $gt_generic_drp{'gt_global'}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key} = $$gt_drp_ref{$ref_conf}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key};

        ## Delete the attribute from the \%gt_drp_ref
        foreach my $gt_drp_config_key (keys %{ $gt_drp_ref }) {
          delete $$gt_drp_ref{$gt_drp_config_key}{$gt_ref_conf_type_key}{$gt_ref_conf_attribute_key};
        }
      }
    }
  }

  return \%gt_generic_drp;
}

################################################################################
# Generate a value distribution hash for each variable
#
# E.g. attribute_name -> %existing_values -> @configuration
#
# Required parameters : $1 - GT DRP hash generated by the parser
#
################################################################################
sub drp_value_distribution {

  my ($gt_drp_ref) = @_;
  my %gt_drp_dist;

  foreach my $config_key (keys %{ $gt_drp_ref }) {
    foreach my $type_key (keys %{ $$gt_drp_ref{$config_key} }) {
      foreach my $attribute_key (keys %{ $$gt_drp_ref{$config_key}{$type_key} }) {
        my $value = $$gt_drp_ref{$config_key}{$type_key}{$attribute_key};
        ## store a new configuration name to a (attribute,value) pair
        push (@{ $gt_drp_dist{$attribute_key}{$value} }, $config_key);
      }
    }
  }

  ## sort the arrays with the GT configuration to improve readability
  foreach my $attribute_key (keys %gt_drp_dist) {
    foreach my $value (keys %{ $gt_drp_dist{$attribute_key} }) {
      my @sorted = sort @{ $gt_drp_dist{$attribute_key}{$value} };
      @{ $gt_drp_dist{$attribute_key}{$value} } = @sorted;
    }
  }

  return \%gt_drp_dist;
}

################################################################################
# Generate a VCO frequency distribution hash for each variable
#
# E.g. attribute_name -> %VCO_freq -> @attribute_value
#
# Required parameters : $1 - GT DRP hash generated by the parser
#
################################################################################
sub uniq {
  my %seen;
  grep !$seen{$_}++, @_;
}

sub drp_vcof_distribution {

  my ($gt_drp_ref, $gt_default_ref) = @_;
  my %gt_drp_dist;

  foreach my $config_key (keys %{ $gt_drp_ref }) {
    foreach my $type_key (keys %{ $$gt_drp_ref{$config_key} }) {
      if ($type_key ne 'pll_dividers') {
        foreach my $attribute_key (keys %{ $$gt_drp_ref{$config_key}{$type_key} }) {
          my @words = split /_/, $config_key;
          my $lane_rate;
          if ($words[4]) {
            $lane_rate = "$words[2].$words[3]";
          } else {
            $lane_rate = $words[2];
          }
          if ($$gt_drp_ref{$config_key}{'pll_dividers'}{'RXOUT_DIV'}) {
            my $vcof = ($lane_rate * $$gt_drp_ref{$config_key}{'pll_dividers'}{'RXOUT_DIV'}) / 2;
            my $value = $$gt_drp_ref{$config_key}{$type_key}{$attribute_key};
            # my %conf_with_value;
            # $conf_with_lane_ratevalue{$value} = $config_key;
            ## store a new configuration name to a (attribute,value) pair
            ## push (@{ $gt_drp_dist{$attribute_key}{$vcof} }, $value);
            ## push (@{ $gt_drp_dist{$attribute_key}{$vcof} }, %conf_with_value);
            # print "$vcof\n";
            push (@{ $gt_drp_dist{$attribute_key}{$vcof}{$value} }, $config_key);
          }
        }
      }
    }
  }

  ## sort the arrays with the GT configuration to improve readability
  foreach my $attribute_key (keys %gt_drp_dist) {
    # foreach my $vcof (keys %{ $gt_drp_dist{$attribute_key} }) {
    #   my @sorted = sort @{ $gt_drp_dist{$attribute_key}{$vcof} };
    #   my @uniq = uniq(@sorted);
    #   @{ $gt_drp_dist{$attribute_key}{$vcof} } = @uniq;
    # }
    ## add the default value to each attribute
    if (exists $$gt_default_ref{'common'}{$attribute_key}) {
      $gt_drp_dist{$attribute_key}{'default'} = $$gt_default_ref{'common'}{$attribute_key}
    }
    if (exists $$gt_default_ref{'channel'}{$attribute_key}) {
      $gt_drp_dist{$attribute_key}{'default'} = $$gt_default_ref{'channel'}{$attribute_key}
    }
  }

return \%gt_drp_dist;
}

################################################################################
# MAIN program
################################################################################

## Hash for storing all the DRP register values
my %gt_drp;
my %gt_default;

## Valid transceiver types are: GTHE3, GTHE4, GTYE3, GTYE4
my $xcvr_type = $ARGV[0];

## Check the ADI_HDL_DIR environment variable, exist if it does not exist
my $hdl_path = "";
if (defined $ENV{ADI_HDL_DIR}) {
  $hdl_path = $ENV{ADI_HDL_DIR};
} else {
  # print `pwd`;
  my $curr_dir = `pwd`;
  my $new_str = chop($curr_dir);
  my $relative_path = "/../../../../../..";
  $hdl_path = $curr_dir.$relative_path;
  # print "ERROR: ADI_HDL_DIR is undefined! Please define this environment variable.\n";
  # exit;
}

## Currently only GTXE2, GTHE3, GTYE3, GTHE4 and GTYE4 is supported
print "NOTE: To parse the generated GT IP, change directory to *.gen/sources_1/ip/ ...\n";
if (not defined $xcvr_type) {
  die "ERROR Need to define an XCVR type. (GTXE2, GTHE3, GTHE4, GTYE3, GTYE4)";
} elsif ((uc($xcvr_type) ne "GTHE3") and (uc($xcvr_type) ne "GTHE4") and (uc($xcvr_type) ne "GTYE3") and (uc($xcvr_type) ne "GTYE4") and (uc($xcvr_type) ne "GTXE2")) {
  die "ERROR Wrong XCVR type, should be GTXE2, GTHE3, GTHE4, GTYE3, GTYE4";
}

## save the default values into $gt_drp->'default'
$gt_default{'common'}  = xcvr_default("$hdl_path/library/xilinx/util_adxcvr/util_adxcvr_xcm.v", $xcvr_type);
$gt_default{'channel'} = xcvr_default("$hdl_path/library/xilinx/util_adxcvr/util_adxcvr_xch.v", $xcvr_type);

## iterate through all the configurations
my @gt_config_list = `ls`;
foreach my $gt_config (@gt_config_list) {
  chomp($gt_config);
  $gt_config =~ s/^\s+|\s+$//g;
  if (-d $gt_config) {
    chdir $gt_config;
    $gt_drp{$gt_config} = parse_gt($xcvr_type, $hdl_path);
    chdir "../";
  }
}

## prune the DRP access which is generic for all the configuration
my $gt_generic_drp = prune_drp_access(\%gt_drp);

open(WRITEFILE, ">$xcvr_type\_cfng.txt") or die print "Can not open file called $xcvr_type\_cfng.txt for writing.\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE "Unique configuration/attribute values\n";
print WRITEFILE "The following attribute/value pairs are unique for one or more configuration\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE Dumper(%gt_drp);
print WRITEFILE "========================================================================\n";
print WRITEFILE "Common configuration/attribute values\n";
print WRITEFILE "The following attribute/value pairs are the same for each configuration \n";
print WRITEFILE "========================================================================\n";
print WRITEFILE Dumper(%{ $gt_generic_drp });
close(WRITEFILE) or die print "Can not close file called daq2_gthe4.txt.\n";

print_table(\%gt_drp, $gt_default{'common'}, $gt_default{'channel'}, "table_unique");
print_table($gt_generic_drp, $gt_default{'common'}, $gt_default{'channel'}, "table_common");

# create a hash table which reflects the value distribution of each DRP attribute
# in function of lane rates and reference clock
my $gt_drp_var_dist = drp_value_distribution(\%gt_drp);

open(WRITEFILE, ">$xcvr_type\_var_dist.txt") or die print "Can not open file called $xcvr_type\_var_dist.txt for writing.\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE "Value distribution of each DRP attribute in function of lane rates\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE Dumper(%{ $gt_drp_var_dist });
close(WRITEFILE) or die print "Can not close file called $xcvr_type\_var_dist.txt.\n";

# create a hash table which reflects the value distribution of each DRP attribute
# in function of VCO frequency
my $gt_drp_vco_dist = drp_vcof_distribution (\%gt_drp, \%gt_default);

open(WRITEFILE, ">$xcvr_type\_vco_dist.txt") or die print "Can not open file called $xcvr_type\_vco_dist.txt for writing.\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE "Value distribution of each DRP attribute in function of VCO frequency\n";
print WRITEFILE "========================================================================\n";
print WRITEFILE Dumper(%{ $gt_drp_vco_dist });
close(WRITEFILE) or die print "Can not close file called $xcvr_type\_vco_dist.txt.\n";

