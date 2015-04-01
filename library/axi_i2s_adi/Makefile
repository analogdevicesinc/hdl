####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_i2s_adi_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/axi_ctrlif.vhd
M_DEPS += ../common/axi_streaming_dma_tx_fifo.vhd
M_DEPS += ../common/axi_streaming_dma_rx_fifo.vhd
M_DEPS += ../common/pl330_dma_fifo.vhd
M_DEPS += ../common/dma_fifo.vhd
M_DEPS += i2s_controller.vhd
M_DEPS += i2s_rx.vhd
M_DEPS += i2s_tx.vhd
M_DEPS += i2s_clkgen.vhd
M_DEPS += fifo_synchronizer.vhd
M_DEPS += axi_i2s_adi.vhd


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_i2s_adi.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_i2s_adi.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_i2s_adi_ip.tcl

####################################################################################
####################################################################################
