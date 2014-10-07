
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

proc adi_ip_constraints {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_group xilinx_verilogsynthesis [ipx::current_core]]
  ipx::add_file $ip_constr_files $proj_filegroup
  set_property type {{xdc}} [ipx::get_file $ip_constr_files $proj_filegroup]
  set_property library_name {} [ipx::get_file $ip_constr_files $proj_filegroup]
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

  set_property supported_families \
    {{kintexu}    {Pre-Production} \
     {virtexu}    {Pre-Production} \
     {virtex7}    {Production} \
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
    {{kintexu}    {Pre-Production} \
     {virtexu}    {Pre-Production} \
     {virtex7}    {Production} \
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

proc adi_add_bus_clock {clock_signal_name bus_inf_name {reset_signal_name ""}} {
	set bus_inf_name_clean [string map {":" "_"} $bus_inf_name]
	set clock_inf_name [format "%s%s" $bus_inf_name_clean "_signal_clock"]
	set clock_inf [ipx::add_bus_interface $clock_inf_name [ipx::current_core]]
	set_property abstraction_type_vlnv "xilinx.com:signal:clock_rtl:1.0" $clock_inf
	set_property bus_type_vlnv "xilinx.com:signal:clock:1.0" $clock_inf
	set_property display_name $clock_inf_name $clock_inf
	set clock_map [ipx::add_port_map "CLK" $clock_inf]
	set_property physical_name $clock_signal_name $clock_map

	set assoc_busif [ipx::add_bus_parameter "ASSOCIATED_BUSIF" $clock_inf]
	set_property value $bus_inf_name $assoc_busif

	if { $reset_signal_name != "" } {
		set assoc_reset [ipx::add_bus_parameter "ASSOCIATED_RESET" $clock_inf]
		set_property value $reset_signal_name $assoc_reset

		set reset_inf_name [format "%s%s" $bus_inf_name_clean "_signal_reset"]
		set reset_inf [ipx::add_bus_interface $reset_inf_name [ipx::current_core]]
		set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
		set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
		set_property display_name $reset_inf_name $reset_inf
		set reset_map [ipx::add_port_map "RST" $reset_inf]
		set_property physical_name $reset_signal_name $reset_map

		set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
		set_property value "ACTIVE_LOW" $reset_polarity
	}
}
