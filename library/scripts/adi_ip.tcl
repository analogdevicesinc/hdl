
# ip related stuff

proc adi_ip_create {ip_name} {

  create_project $ip_name . -force

  set proj_dir [get_property directory [current_project]]
  set proj_name [get_projects $ip_name]
}

proc adi_ip_files {ip_name ip_files} {

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset $ip_files
  set_property "top" "$ip_name" $proj_fileset
}

proc adi_ip_properties {ip_name} {

  ipx::package_project -root_dir .
  ipx::remove_memory_map {s_axi} [ipx::current_core]
  ipx::add_memory_map {s_axi} [ipx::current_core]
  set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interface s_axi [ipx::current_core]]

  ipx::add_address_block {axi_lite} [ipx::get_memory_map s_axi [ipx::current_core]]
  set_property range {65536} [ipx::get_address_block axi_lite \
    [ipx::get_memory_map s_axi [ipx::current_core]]]

  set_property vendor {analog.com} [ipx::current_core]
  set_property library {user} [ipx::current_core]
  set_property taxonomy {{/AXI_Infrastructure}} [ipx::current_core]
  set_property vendor_display_name {Analog Devices} [ipx::current_core]
  set_property company_url {www.analog.com} [ipx::current_core]

  set_property value {0xFFFFFFFF} [ipx::get_hdl_parameter C_HIGHADDR [ipx::current_core]]
  set_property value {0x00000000} [ipx::get_hdl_parameter C_BASEADDR [ipx::current_core]]

  set_property supported_families \
    {{virtex7}    {Production} \
     {qvirtex7}   {Production} \
     {kintex7}    {Production} \
     {kintex7l}   {Production} \
     {qkintex7}   {Production} \
     {qkintex7l}  {Production} \
     {artix7}     {Production} \
     {artix7l}    {Production} \
     {aartix7}    {Production} \
     {qartix7}    {Production} \
     {zynq}       {Production} \
     {qzynq}      {Production} \
     {azynq}      {Production}} \
  [ipx::current_core]
}

proc adi_ip_properties_lite {ip_name} {

  ipx::package_project -root_dir .

  set_property vendor {analog.com} [ipx::current_core]
  set_property library {user} [ipx::current_core]
  set_property taxonomy {{/AXI_Infrastructure}} [ipx::current_core]
  set_property vendor_display_name {Analog Devices} [ipx::current_core]
  set_property company_url {www.analog.com} [ipx::current_core]

  set_property supported_families \
    {{virtex7}    {Production} \
     {qvirtex7}   {Production} \
     {kintex7}    {Production} \
     {kintex7l}   {Production} \
     {qkintex7}   {Production} \
     {qkintex7l}  {Production} \
     {artix7}     {Production} \
     {artix7l}    {Production} \
     {aartix7}    {Production} \
     {qartix7}    {Production} \
     {zynq}       {Production} \
     {qzynq}      {Production} \
     {azynq}      {Production}} \
  [ipx::current_core]
}

proc adi_set_ports_dependency {port_prefix dependency} {
	foreach port [ipx::get_ports [format "%s%s" $port_prefix "*"]] {
		set_property ENABLEMENT_DEPENDENCY $dependency $port
	}
}

proc adi_set_bus_dependency {bus prefix dependency} {
	set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_bus_interface $bus [ipx::current_core]]
	adi_set_ports_dependency $prefix $dependency
}

proc adi_add_port_map {bus phys logic} {
	set map [ipx::add_port_map $phys $bus]
	set_property "PHYSICAL_NAME" $phys $map
	set_property "LOGICAL_NAME" $logic $map
}

proc adi_add_bus {bus_name bus_type mode port_maps} {
	set bus [ipx::add_bus_interface $bus_name [ipx::current_core]]
	if { $bus_type == "axis" } {
		set abst_type "axis_rtl"
	} elseif { $bus_type == "aximm" } {
		set abst_type "aximm_rtl"
	} else {
		set abst_type $bus_type
	}

	set_property "ABSTRACTION_TYPE_LIBRARY" "interface" $bus
	set_property "ABSTRACTION_TYPE_NAME" $abst_type $bus
	set_property "ABSTRACTION_TYPE_VENDOR" "xilinx.com" $bus
	set_property "ABSTRACTION_TYPE_VERSION" "1.0" $bus
	set_property "BUS_TYPE_LIBRARY" "interface" $bus
	set_property "BUS_TYPE_NAME" $bus_type $bus
	set_property "BUS_TYPE_VENDOR" "xilinx.com" $bus
	set_property "BUS_TYPE_VERSION" "1.0" $bus
	set_property "CLASS" "bus_interface" $bus
	set_property "INTERFACE_MODE" $mode $bus

	foreach port_map $port_maps {
		adi_add_port_map $bus {*}$port_map
	}
}
