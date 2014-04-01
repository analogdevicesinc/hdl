################################################################################
################################################################################

package require ::quartus::flow
project_open fmcjesdadc1
execute_module -tool fit

create_timing_netlist
read_sdc fmcjesdadc1.sdc
update_timing_netlist

report_timing -detail summary -npaths 20 -file timing_summary.rpt
report_timing -detail path_only -npaths 20 -file timing.rpt
report_path -npaths 20 -file timing_paths.rpt
report_sdc -ignored -file timing_sdc.rpt
report_clocks -file timing_clocks.rpt
report_ucp -file timing_ucp.rpt

check_timing -file timing_design.rpt
create_timing_summary -file timing_design_summary.rpt
  
################################################################################
################################################################################
