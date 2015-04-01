####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
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


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_fifo2s.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_fifo2s.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_fifo2s_ip.tcl

####################################################################################
####################################################################################
