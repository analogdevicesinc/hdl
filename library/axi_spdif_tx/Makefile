####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_spdif_tx_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/axi_ctrlif.vhd
M_DEPS += ../common/axi_streaming_dma_tx_fifo.vhd
M_DEPS += ../common/pl330_dma_fifo.vhd
M_DEPS += ../common/dma_fifo.vhd
M_DEPS += tx_package.vhd
M_DEPS += tx_encoder.vhd
M_DEPS += axi_spdif_tx.vhd
M_DEPS += axi_spdif_tx_constr.xdc

M_VIVADO := vivado -mode batch -source

M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name '*.xml'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `M_FLIST += component.xml 


.PHONY: all
all: axi_spdif_tx.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


axi_spdif_tx.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_spdif_tx_ip.tcl  >> axi_spdif_tx_ip.log 2>&1

####################################################################################
####################################################################################
