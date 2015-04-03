####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := axi_fifo2s_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mem.v
M_DEPS += ../common/ad_mem_asym.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/ad_axis_inf_rx.v
M_DEPS += axi_fifo2s_adc.v
M_DEPS += axi_fifo2s_dma.v
M_DEPS += axi_fifo2s_wr.v
M_DEPS += axi_fifo2s_rd.v
M_DEPS += axi_fifo2s.v
M_DEPS += axi_fifo2s_constr.xdc

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_fifo2s.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_fifo2s.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_fifo2s_ip.tcl  >> axi_fifo2s_ip.log 2>&1

####################################################################################
####################################################################################
