####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_dmac_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/sync_bits.v
M_DEPS += ../common/sync_gray.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../axi_fifo/axi_fifo.v
M_DEPS += ../axi_fifo/address_gray.v
M_DEPS += ../axi_fifo/address_gray_pipelined.v
M_DEPS += ../axi_fifo/address_sync.v
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
M_DEPS += axi_repack.v
M_DEPS += axi_dmac_constr.xdc


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_dmac.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_dmac.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_dmac_ip.tcl

####################################################################################
####################################################################################
