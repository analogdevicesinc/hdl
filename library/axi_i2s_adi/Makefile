####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
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

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_i2s_adi.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_i2s_adi.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_i2s_adi_ip.tcl  >> axi_i2s_adi_ip.log 2>&1

####################################################################################
####################################################################################
