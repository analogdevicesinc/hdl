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
M_DEPS += util_adcfifo_axi_adc.v
M_DEPS += util_adcfifo_axi_dma.v
M_DEPS += util_adcfifo_axi_wr.v
M_DEPS += util_adcfifo_axi_rd.v
M_DEPS += util_adcfifo_axi.v
M_DEPS += util_adcfifo_axi_constr.xdc

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
all: axi_adcfifo.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


axi_adcfifo.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_adcfifo_ip.tcl  >> axi_adcfifo_ip.log 2>&1

####################################################################################
####################################################################################
