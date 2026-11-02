####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

PROJECT_NAME := fmcomms2_mpfs_video_kit
DDR_INIT_USER_MEM := verification/fmcomms2_tx_user.mem
SIM_WAVE += verification/wave.do

MSS_CONFIG ?= mss_base.cfg

M_DEPS += $(MSS_CONFIG)
M_DEPS += system_constr.pdc
M_DEPS += system_constr.sdc
M_DEPS += system_lb.tcl
M_DEPS += system_project.tcl
M_DEPS += system_top.v
M_DEPS += ../common/ad_rst_mc.tcl
M_DEPS += ../../../library/common/ad_rst.v
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../common/fmcomms2_lb.tcl
M_DEPS += ../../common/mpfs_video_kit/system_lb.tcl
M_DEPS += ../../common/mpfs_video_kit/mpfs_video_kit_system_lb.tcl

LIB_DEPS += axi_ad9361
LIB_DEPS += axi_dmac
LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom
LIB_DEPS += microchip/util_clkdiv
LIB_DEPS += util_apb_pipe
LIB_DEPS += util_rfifo
LIB_DEPS += util_tdd_sync
LIB_DEPS += util_wfifo
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_pack/util_upack2

include ../../scripts/project-microchip.mk
