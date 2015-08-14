# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

proc adi_if_ports {dir width name {type none}} {

  ipx::add_bus_abstraction_port $name [ipx::current_busabs]
  set_property master_presence required [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  set_property slave_presence  required [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  set_property master_width $width [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  set_property slave_width  $width [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]

  set m_dir "in"
  set s_dir "out"
  if {$dir eq "output"} {
    set m_dir "out"
    set s_dir "in"
  }

  set_property master_direction $m_dir [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  set_property slave_direction  $s_dir [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]

  if {$type ne "none"} {
    set_property is_${type} true [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
  }
}


ipx::create_abstraction_definition ADI user if_gt_rx_rtl 1.0
ipx::create_bus_definition ADI user if_gt_rx 1.0

set_property xml_file_name if_gt_rx_rtl.xml [ipx::current_busabs]
set_property xml_file_name if_gt_rx.xml [ipx::current_busdef]
set_property bus_type_vlnv ADI:user:if_gt_rx:1.0 [ipx::current_busabs]

ipx::save_abstraction_definition [ipx::current_busabs]
ipx::save_bus_definition [ipx::current_busdef]

adi_if_ports  output   1  rx_p            
adi_if_ports  output   1  rx_n            
adi_if_ports  input    1  rx_rst              reset
adi_if_ports  output   1  rx_rst_m            reset
adi_if_ports  input    1  rx_gt_rst           reset
adi_if_ports  output   1  rx_gt_rst_m         reset
adi_if_ports  input    1  rx_pll_locked     
adi_if_ports  output   1  rx_pll_locked_m   
adi_if_ports  input    1  rx_user_ready     
adi_if_ports  output   1  rx_user_ready_m   
adi_if_ports  input    1  rx_rst_done       
adi_if_ports  output   1  rx_rst_done_m     
adi_if_ports  input    1  rx_out_clk          clock
adi_if_ports  output   1  rx_clk              clock
adi_if_ports  output   1  rx_sysref         
adi_if_ports  input    1  rx_sync           
adi_if_ports  input    1  rx_sof            
adi_if_ports  input   32  rx_data           
adi_if_ports  input    1  rx_ip_rst           reset
adi_if_ports  output   4  rx_ip_sof         
adi_if_ports  output  32  rx_ip_data        
adi_if_ports  input    1  rx_ip_sysref      
adi_if_ports  output   1  rx_ip_sync        
adi_if_ports  input    1  rx_ip_rst_done    

ipx::save_bus_definition [ipx::current_busdef]
ipx::save_abstraction_definition [ipx::current_busabs]

