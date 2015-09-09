####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl-notrace
M_DEPS += ../../scripts/adi_project.tcl-notrace
M_DEPS += ../../scripts/adi_board.tcl-notrace
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../../pzsdr/rfsom/system_constr.xdc
M_DEPS += ../../common/rfsom/rfsom_system_constr.xdc

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.runs
M_FLIST += *.srcs
M_FLIST += *.sdk
M_FLIST += .Xil



.PHONY: all lib clean clean-all
all: lib pzslb_rfsom.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean


pzslb_rfsom.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> pzslb_rfsom_vivado.log 2>&1


lib:

####################################################################################
####################################################################################
