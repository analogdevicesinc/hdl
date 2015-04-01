####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := cn0363_phase_data_sync_ip.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += cn0363_phase_data_sync.v

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil



.PHONY: all clean clean-all
all: cn0363_phase_data_sync.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


cn0363_phase_data_sync.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) cn0363_phase_data_sync_ip.tcl  >> cn0363_phase_data_sync_ip.log 2>&1

####################################################################################
####################################################################################
