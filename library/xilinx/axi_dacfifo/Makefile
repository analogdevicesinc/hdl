####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../common/ad_axis_inf_rx.v
M_DEPS += ../../common/ad_mem_asym.v
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += ../../util_axis_resize/util_axis_resize.v
M_DEPS += axi_dacfifo.v
M_DEPS += axi_dacfifo_constr.xdc
M_DEPS += axi_dacfifo_dac.v
M_DEPS += axi_dacfifo_ip.tcl
M_DEPS += axi_dacfifo_rd.v
M_DEPS += axi_dacfifo_wr.v
M_DEPS += axi_dacfifo_bypass.v

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.ip_user_files
M_FLIST += *.srcs
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil



.PHONY: all clean clean-all
all: axi_dacfifo.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_dacfifo.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_dacfifo_ip.tcl  >> axi_dacfifo_ip.log 2>&1

####################################################################################
####################################################################################
