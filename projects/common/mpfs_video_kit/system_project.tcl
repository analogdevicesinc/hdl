###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_microchip.tcl

adi_project template_mpfs_video_kit

source system_lb.tcl

adi_project_files template_mpfs_video_kit \
	-hdl_source ../../../library/common/ad_iobuf.v \
	-hdl_source system_top.v \
	-placeroute {
		-io_pdc mpfs_video_kit_system_constr.pdc
	}

adi_project_run template_mpfs_video_kit \
	-program_design 1 \
	-program_spi_flash 0
