#Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ ipgui::add_page $IPINST  -name "Page 0" -layout vertical]
	set canvas_spec [ipgui::get_canvasspec -of $IPINST]
	set_property ip_logo "sysgen_icon_100.png" $canvas_spec
	set iconfile [ipgui::find_file [ipgui::get_coredir] "sysgen_icon_100.png"]
	set image [ipgui::add_image -width 100 -height 100 -parent $Page0 -name $iconfile $IPINST]
	set_property load_image $iconfile $image
	set Component_Name [ ipgui::add_param  $IPINST  -parent  $Page0  -name Component_Name ]
}

