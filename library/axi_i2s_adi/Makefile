####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
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
M_DEPS += axi_i2s_adi_constr.xdc

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
all: axi_i2s_adi.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_i2s_adi.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_i2s_adi_ip.tcl  >> axi_i2s_adi_ip.log 2>&1

####################################################################################
####################################################################################
