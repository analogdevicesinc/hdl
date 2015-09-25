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
M_DEPS += ../common/up_axi.v
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
M_DEPS += axi_dmac_constr.ttcl
M_DEPS += bd/bd.tcl
M_DEPS += ../util_axis_resize/util_axis_resize.xpr
M_DEPS += ../util_axis_fifo/util_axis_fifo.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil



.PHONY: all dep clean clean-all
all: dep axi_dmac.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_dmac.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_dmac_ip.tcl  >> axi_dmac_ip.log 2>&1

dep:
	make -C ../util_axis_resize
	make -C ../util_axis_fifo
####################################################################################
####################################################################################
