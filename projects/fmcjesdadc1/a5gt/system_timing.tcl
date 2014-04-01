
package require ::quartus::flow
project_open fmcjesdadc1_a5gt
execute_module -tool fit

create_timing_netlist
read_sdc system_constr.sdc
update_timing_netlist

report_timing -detail path_only -npaths 20 -file timing_impl.log
  
