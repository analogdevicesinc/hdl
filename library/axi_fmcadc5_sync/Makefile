####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/up_axi.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../xilinx/common/ad_lvds_out.v
M_DEPS += ../xilinx/common/ad_mul.v
M_DEPS += axi_fmcadc5_sync.v
M_DEPS += axi_fmcadc5_sync_calcor.v
M_DEPS += axi_fmcadc5_sync_constr.xdc
M_DEPS += axi_fmcadc5_sync_ip.tcl

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
all: axi_fmcadc5_sync.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_fmcadc5_sync.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_fmcadc5_sync_ip.tcl  >> axi_fmcadc5_sync_ip.log 2>&1

####################################################################################
####################################################################################
