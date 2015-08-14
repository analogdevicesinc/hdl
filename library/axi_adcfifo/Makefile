####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_adcfifo_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mem.v
M_DEPS += ../common/ad_mem_asym.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/ad_axis_inf_rx.v
M_DEPS += axi_adcfifo_adc.v
M_DEPS += axi_adcfifo_dma.v
M_DEPS += axi_adcfifo_wr.v
M_DEPS += axi_adcfifo_rd.v
M_DEPS += axi_adcfifo.v
M_DEPS += axi_adcfifo_constr.xdc

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
all: axi_adcfifo.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_adcfifo.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_adcfifo_ip.tcl  >> axi_adcfifo_ip.log 2>&1

####################################################################################
####################################################################################
