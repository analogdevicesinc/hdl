####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_axis_resize_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += 
M_DEPS += adi_ip_properties_liteutil_axis_resize
M_DEPS += 
M_DEPS += adi_add_buss_axisslave
M_DEPS += xilinx.com:interface:axis_rtl:1.0
M_DEPS += xilinx.com:interface:axis:1.0
M_DEPS += {
M_DEPS += {s_validTVALID}
M_DEPS += {s_readyTREADY}
M_DEPS += {s_dataTDATA}
M_DEPS += }
M_DEPS += 
M_DEPS += adi_add_busm_axismaster
M_DEPS += xilinx.com:interface:axis_rtl:1.0
M_DEPS += xilinx.com:interface:axis:1.0
M_DEPS += {
M_DEPS += {m_validTVALID}
M_DEPS += {m_readyTREADY}
M_DEPS += {m_dataTDATA}
M_DEPS += }
M_DEPS += 
M_DEPS += adi_add_bus_clockclks_axis:m_axisresetn
M_DEPS += 
M_DEPS += ipx::save_core[ipx::current_core

M_VIVADO := vivado -mode batch -source

M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `


.PHONY: all
all: util_axis_resize.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


util_axis_resize.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_axis_resize_ip.tcl  >> util_axis_resize_ip.log 2>&1

####################################################################################
####################################################################################
