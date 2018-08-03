###################################################################################################
###################################################################################################
# keep interface-mess out of the way - keeping it pretty is a waste of time

proc ad_alt_intf {type name dir width {arg_1 ""} {arg_2 ""}} {

  if {([string equal -nocase ${type} "clock"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} clock sink
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {([string equal -nocase ${type} "clock"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} clock source
    add_interface_port if_${name} ${name} clk ${dir} ${width}
    return
  }

  if {([string equal -nocase ${type} "reset"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {([string equal -nocase ${type} "reset"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {([string equal -nocase ${type} "reset-n"]) && ([string equal -nocase ${dir} "input"])} {
    add_interface if_${name} reset sink
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  if {([string equal -nocase ${type} "reset-n"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} reset source
    add_interface_port if_${name} ${name} reset_n ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    set_interface_property if_${name} associatedResetSinks ${arg_2}
    return
  }

  if {([string equal -nocase ${type} "intr"]) && ([string equal -nocase ${dir} "output"])} {
    add_interface if_${name} interrupt source
    add_interface_port if_${name} ${name} irq ${dir} ${width}
    set_interface_property if_${name} associatedclock ${arg_1}
    return
  }

  set remap $arg_1
  if {$arg_1 eq ""} {
    set remap $name
  }

  if {[string equal -nocase ${type} "signal"]} {
    add_interface if_${name} conduit end
    add_interface_port if_${name} ${name} ${remap} ${dir} ${width}
    return
  }
}

proc ad_conduit {if_name if_port port dir width} {

  add_interface $if_name conduit end
  add_interface_port $if_name $port $if_port $dir $width
}

proc ad_generate_module_inst { inst_name mark source_file target_file } {

  set fp_source [open $source_file "r"]
  set fp_target [open $target_file "w+"]

  fconfigure $fp_source -buffering line

  while { [gets $fp_source data] >= 0 } {

    # update the required module name
    regsub $inst_name $data "&_$mark" data
    puts $data
    puts $fp_target $data
  }

  close $fp_source
  close $fp_target
}

###################################################################################################
###################################################################################################

proc ad_ip_create {pname pdisplay_name {pelabfunction ""} {pcomposefunction ""}} {

  set_module_property NAME $pname
  set_module_property DISPLAY_NAME $pdisplay_name
  set_module_property DESCRIPTION $pdisplay_name
  set_module_property VERSION 1.0
  set_module_property GROUP "Analog Devices"
  
  if {$pelabfunction ne ""} {
    set_module_property ELABORATION_CALLBACK $pelabfunction
  }

  if {$pcomposefunction ne ""} {
    set_module_property COMPOSITION_CALLBACK $pcomposefunction
  }
}

###################################################################################################
###################################################################################################

proc ad_ip_parameter {pname ptype pdefault {phdl true} {properties {}}} {

  if {$pname eq "DEVICE_FAMILY"} {
    add_parameter DEVICE_FAMILY STRING
    set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
    set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
    set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
    set_parameter_property DEVICE_FAMILY ENABLED true
  } else {
    add_parameter $pname $ptype $pdefault
    set_parameter_property $pname HDL_PARAMETER $phdl
    set_parameter_property $pname ENABLED true
  }

  foreach {key value} $properties {
    set_parameter_property $pname $key $value
  }
}

###################################################################################################
###################################################################################################

proc ad_ip_addfile {pname pfile} {

  set pmodule [file tail $pfile]  

  regsub {\..$} $pmodule {} mname
  if {$pname eq $mname} {
    add_fileset_file $pmodule VERILOG PATH $pfile TOP_LEVEL_FILE
    return
  }

  set ptype [file extension $pfile]
  if {$ptype eq ".v"} {
    add_fileset_file $pmodule VERILOG PATH $pfile
    return
  }
  if {$ptype eq ".vh"} {
    add_fileset_file $pmodule VERILOG_INCLUDE PATH $pfile
    return
  }
  if {$ptype eq ".sdc"} {
    add_fileset_file $pmodule SDC PATH $pfile
    return
  }
  if {$ptype eq ".tcl"} {
    add_fileset_file $pmodule OTHER PATH $pfile
    return
  }
}

proc ad_ip_files {pname pfiles {pfunction ""}} {

  add_fileset quartus_synth QUARTUS_SYNTH $pfunction ""
  set_fileset_property quartus_synth TOP_LEVEL $pname
  foreach pfile $pfiles {
    ad_ip_addfile $pname $pfile
  }

  add_fileset quartus_sim SIM_VERILOG $pfunction ""
  set_fileset_property quartus_sim TOP_LEVEL $pname
  foreach pfile $pfiles {
    ad_ip_addfile $pname $pfile
  }
}

###################################################################################################
###################################################################################################

proc ad_ip_intf_s_axi {aclk arstn {addr_width 16}} {

  add_interface s_axi_clock clock end
  add_interface_port s_axi_clock ${aclk} clk Input 1

  add_interface s_axi_reset reset end
  set_interface_property s_axi_reset associatedClock s_axi_clock
  add_interface_port s_axi_reset ${arstn} reset_n Input 1

  add_interface s_axi axi4lite end
  set_interface_property s_axi associatedClock s_axi_clock
  set_interface_property s_axi associatedReset s_axi_reset
  add_interface_port s_axi s_axi_awvalid awvalid Input 1
  add_interface_port s_axi s_axi_awaddr awaddr Input $addr_width
  add_interface_port s_axi s_axi_awprot awprot Input 3
  add_interface_port s_axi s_axi_awready awready Output 1
  add_interface_port s_axi s_axi_wvalid wvalid Input 1
  add_interface_port s_axi s_axi_wdata wdata Input 32
  add_interface_port s_axi s_axi_wstrb wstrb Input 4
  add_interface_port s_axi s_axi_wready wready Output 1
  add_interface_port s_axi s_axi_bvalid bvalid Output 1
  add_interface_port s_axi s_axi_bresp bresp Output 2
  add_interface_port s_axi s_axi_bready bready Input 1
  add_interface_port s_axi s_axi_arvalid arvalid Input 1
  add_interface_port s_axi s_axi_araddr araddr Input $addr_width
  add_interface_port s_axi s_axi_arprot arprot Input 3
  add_interface_port s_axi s_axi_arready arready Output 1
  add_interface_port s_axi s_axi_rvalid rvalid Output 1
  add_interface_port s_axi s_axi_rresp rresp Output 2
  add_interface_port s_axi s_axi_rdata rdata Output 32
  add_interface_port s_axi s_axi_rready rready Input 1
}

###################################################################################################
###################################################################################################

proc ad_ip_modfile {ifile ofile flist} {

  global ad_hdl_dir

  set srcfile [open ${ad_hdl_dir}/library/altera/common/${ifile} r]
  set dstfile [open ${ofile} w]

  regsub {\..$} $ifile {} imodule
  regsub {\..$} $ofile {} omodule

  while {[gets $srcfile srcline] >= 0} {
    regsub __${imodule}__ $srcline $omodule dstline
    set index 0
    foreach fword $flist {
      incr index
      regsub __${imodule}_${index}__ $dstline $fword dstline
    }
    puts $dstfile $dstline
  }

  close $srcfile
  close $dstfile

  ad_ip_addfile ad_ip_addfile $ofile
}

###################################################################################################
###################################################################################################

