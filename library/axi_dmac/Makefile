####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_dmac_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/sync_bits.v
M_DEPS += ../common/sync_gray.v
M_DEPS += ../common/up_axi.v
M_DEPS += fifo.v
M_DEPS += address_gray.v
M_DEPS += address_gray_pipelined.v
M_DEPS += address_sync.v
M_DEPS += address_generator.v
M_DEPS += data_mover.v
M_DEPS += request_arb.v
M_DEPS += request_generator.v
M_DEPS += response_handler.v
M_DEPS += axi_register_slice.v
M_DEPS += 2d_transfer.v
M_DEPS += dest_axi_mm.v
M_DEPS += dest_axi_stream.v
M_DEPS += dest_fifo_inf.v
M_DEPS += src_axi_mm.v
M_DEPS += src_axi_stream.v
M_DEPS += src_fifo_inf.v
M_DEPS += splitter.v
M_DEPS += response_generator.v
M_DEPS += axi_dmac.v
M_DEPS += axi_dmac_constr.xdc

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
all: axi_dmac.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


axi_dmac.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_dmac_ip.tcl  >> axi_dmac_ip.log 2>&1

####################################################################################
####################################################################################
