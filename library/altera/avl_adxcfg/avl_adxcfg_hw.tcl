
package require -exact qsys 14.0

set_module_property NAME avl_adxcfg
set_module_property DESCRIPTION "Avalon ADXCFG Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME avl_adxcfg
set_module_property ELABORATION_CALLBACK p_avl_adxcfg

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL avl_adxcfg
add_fileset_file avl_adxcfg.v VERILOG PATH avl_adxcfg.v TOP_LEVEL_FILE

# parameters

add_parameter NUM_OF_CORES INTEGER 0
set_parameter_property NUM_OF_CORES DISPLAY_NAME NUM_OF_CORES
set_parameter_property NUM_OF_CORES TYPE INTEGER
set_parameter_property NUM_OF_CORES UNITS None
set_parameter_property NUM_OF_CORES HDL_PARAMETER false

# reconfiguration interfaces

add_interface rcfg_clk  clock sink
add_interface_port rcfg_clk rcfg_clk clk Input 1

add_interface rcfg_reset_n reset end
set_interface_property rcfg_reset_n associatedClock rcfg_clk
add_interface_port rcfg_reset_n rcfg_reset_n reset_n Input 1

proc p_avl_adxcfg {} {

  set m_num_of_cores [get_parameter_value NUM_OF_CORES]

  if {$m_num_of_cores > 8} {
    set m_num_of_cores 8
  }

  for {set n 0} {$n < $m_num_of_cores} {incr n} {

    add_interface rcfg_s${n} avalon slave
    add_interface rcfg_m${n} avalon master

    add_interface_port rcfg_s${n} rcfg_in_read_${n} read Input 1
    add_interface_port rcfg_s${n} rcfg_in_write_${n} write Input 1
    add_interface_port rcfg_s${n} rcfg_in_address_${n} address Input 12
    add_interface_port rcfg_s${n} rcfg_in_writedata_${n} writedata Input 32
    add_interface_port rcfg_s${n} rcfg_in_readdata_${n} readdata Output 32
    add_interface_port rcfg_s${n} rcfg_in_waitrequest_${n} waitrequest Output 1
    add_interface_port rcfg_m${n} rcfg_out_read_${n} read Output 1
    add_interface_port rcfg_m${n} rcfg_out_write_${n} write Output 1
    add_interface_port rcfg_m${n} rcfg_out_address_${n} address Output 12
    add_interface_port rcfg_m${n} rcfg_out_writedata_${n} writedata Output 32
    add_interface_port rcfg_m${n} rcfg_out_readdata_${n} readdata Input 32
    add_interface_port rcfg_m${n} rcfg_out_waitrequest_${n} waitrequest Input 1

    set_interface_property rcfg_s${n} associatedClock rcfg_clk
    set_interface_property rcfg_s${n} associatedReset rcfg_reset_n
    set_interface_property rcfg_s${n} addressUnits WORDS
    set_interface_property rcfg_s${n} burstCountUnits WORDS
    set_interface_property rcfg_s${n} explicitAddressSpan 0
    set_interface_property rcfg_m${n} associatedClock rcfg_clk
    set_interface_property rcfg_m${n} associatedReset rcfg_reset_n
    set_interface_property rcfg_m${n} addressUnits WORDS
    set_interface_property rcfg_m${n} burstCountUnits WORDS
  }
}


