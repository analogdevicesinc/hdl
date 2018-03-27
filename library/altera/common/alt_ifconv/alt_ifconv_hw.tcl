
package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_alt.tcl

ad_ip_create alt_ifconv {Altera Interface Translator} alt_ifconv_elab
ad_ip_files alt_ifconv { \
  $ad_hdl_dir/library/altera/common/alt_ifconv/alt_ifconv.v \
}

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter WIDTH INTEGER 1
ad_ip_parameter INTERFACE_NAME_IN STRING {input-interface-name}
ad_ip_parameter INTERFACE_NAME_OUT STRING {output-interface-name}
ad_ip_parameter SIGNAL_NAME_IN STRING {input-signal-name}
ad_ip_parameter SIGNAL_NAME_OUT STRING {output-signal-name}

proc alt_ifconv_elab {} {

  set m_width [get_parameter_value "WIDTH"]
  set m_if_name_in [get_parameter_value "INTERFACE_NAME_IN"]
  set m_if_name_out [get_parameter_value "INTERFACE_NAME_OUT"]
  set m_sig_name_in [get_parameter_value "SIGNAL_NAME_IN"]
  set m_sig_name_out [get_parameter_value "SIGNAL_NAME_OUT"]

  add_interface $m_if_name_in conduit end
  add_interface_port $m_if_name_in din $m_sig_name_in input $m_width
  add_interface $m_if_name_out conduit end
  add_interface_port $m_if_name_out dout $m_sig_name_out output $m_width
}

