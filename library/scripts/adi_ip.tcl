
# check tool version

if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2014.4.1"
}

if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

# ip related stuff

proc adi_ip_create {ip_name} {
  global ad_hdl_dir
  global ad_phdl_dir

  global REQUIRED_VIVADO_VERSION
  global IGNORE_VERSION_CHECK

  if {!$IGNORE_VERSION_CHECK && [string compare [version -short] $REQUIRED_VIVADO_VERSION] != 0} {
    return -code error [format "ERROR: This library requires Vivado %s." $REQUIRED_VIVADO_VERSION]
  }

  create_project $ip_name . -force

  set lib_dirs $ad_hdl_dir/library
  if {$ad_hdl_dir ne $ad_phdl_dir} {
    lappend lib_dirs $ad_phdl_dir/library
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  set proj_dir [get_property directory [current_project]]
  set proj_name [get_projects $ip_name]
}

proc adi_ip_files {ip_name ip_files} {

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset $ip_files
  set_property "top" "$ip_name" $proj_fileset
}

proc adi_ip_constraints {ip_name ip_constr_files {processing_order late}} {

  set proj_filegroup [ipx::get_file_groups xilinx_v*synthesis -of_objects [ipx::current_core]]
  set f [ipx::add_file $ip_constr_files $proj_filegroup]
  set_property -dict [list \
    type xdc \
    library_name {} \
    processing_order $processing_order \
  ] $f
}

proc adi_ip_ttcl {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_groups xilinx_v*synthesis -of_objects [ipx::current_core]]
  set f [ipx::add_file $ip_constr_files $proj_filegroup]
  set_property -dict [list \
    type ttcl \
  ] $f
}

proc adi_ip_properties {ip_name} {

  ipx::package_project -root_dir .
  ipx::remove_memory_map {s_axi} [ipx::current_core]
  ipx::add_memory_map {s_axi} [ipx::current_core]
  set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]

  ipx::add_address_block {axi_lite} [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]
  set_property range {65536} [ipx::get_address_blocks axi_lite \
    -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]

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
	set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
	adi_set_ports_dependency $prefix $dependency
}

proc adi_add_port_map {bus phys logic} {
	set map [ipx::add_port_map $phys $bus]
	set_property "PHYSICAL_NAME" $phys $map
	set_property "LOGICAL_NAME" $logic $map
}

proc adi_add_bus {bus_name mode abs_type bus_type port_maps} {
	set bus [ipx::add_bus_interface $bus_name [ipx::current_core]]

	set_property "ABSTRACTION_TYPE_VLNV" $abs_type $bus
	set_property "BUS_TYPE_VLNV" $bus_type $bus
	set_property "INTERFACE_MODE" $mode $bus

	foreach port_map $port_maps {
		adi_add_port_map $bus {*}$port_map
	}
}

proc adi_add_bus_clock {clock_signal_name bus_inf_name {reset_signal_name ""} {reset_signal_mode "slave"}} {
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
		set_property interface_mode $reset_signal_mode $reset_inf
		set reset_map [ipx::add_port_map "RST" $reset_inf]
		set_property physical_name $reset_signal_name $reset_map

		set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
		set_property value "ACTIVE_LOW" $reset_polarity
	}
}

proc adi_ip_add_core_dependencies {vlnvs} {
	foreach file_group [ipx::get_file_groups * -of_objects [ipx::current_core]] {
		foreach vlnv $vlnvs {
			ipx::add_subcore $vlnv $file_group
		}
	}
}
