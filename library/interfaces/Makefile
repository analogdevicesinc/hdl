####################################################################################
####################################################################################
## Copyright (c) 2018 - 2021 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################
####################################################################################

include ../../quiet.mk

M_DEPS := interfaces_ip.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip_xilinx.tcl

M_VIVADO := vivado -mode batch -source

M_FLIST := *.log
M_FLIST += *.jou
M_FLIST += *.sv
M_FLIST += if_xcvr_cm.xml
M_FLIST += if_xcvr_cm_rtl.xml
M_FLIST += if_xcvr_ch.xml
M_FLIST += if_xcvr_ch_rtl.xml
M_FLIST += if_gt_qpll.xml
M_FLIST += if_gt_qpll_rtl.xml
M_FLIST += if_gt_pll.xml
M_FLIST += if_gt_pll_rtl.xml
M_FLIST += if_gt_rx.xml
M_FLIST += if_gt_rx_rtl.xml
M_FLIST += if_gt_tx.xml
M_FLIST += if_gt_tx_rtl.xml
M_FLIST += if_gt_rx_ksig.xml
M_FLIST += if_gt_rx_ksig_rtl.xml


.PHONY: all xilinx clean clean-all
all: xilinx
xilinx: if_xcvr_cm.xml if_xcvr_cm_rtl.xml if_xcvr_ch.xml if_xcvr_ch_rtl.xml if_gt_qpll.xml if_gt_qpll_rtl.xml if_gt_pll.xml if_gt_pll_rtl.xml if_gt_rx.xml if_gt_rx_rtl.xml if_gt_tx.xml if_gt_tx_rtl.xml if_gt_rx_ksig.xml if_gt_rx_ksig_rtl.xml 

clean:clean-all

clean-all:
	$(call clean, \
		$(M_FLIST), \
		interface definitions)

%.xml: $(M_DEPS)
	$(call build, \
		$(M_VIVADO) interfaces_ip.tcl, \
		interfaces_ip.log, \
		interface definitions)

####################################################################################
####################################################################################
