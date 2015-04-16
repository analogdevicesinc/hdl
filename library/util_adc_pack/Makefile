####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_adc_pack_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_adc_pack.v

M_VIVADO := vivado -mode batch -source

M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name '*.xml'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `M_FLIST += component.xml 


.PHONY: all
all: util_adc_pack.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


util_adc_pack.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_adc_pack_ip.tcl  >> util_adc_pack_ip.log 2>&1

####################################################################################
####################################################################################
