###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

source ../common/ad9083_vna_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "RX_NUM_OF_LANES=$RX_NUM_OF_LANES \
RX_NUM_OF_CONVERTERS=$RX_NUM_OF_CONVERTERS \
RX_SAMPLES_PER_FRAME=$RX_SAMPLES_PER_FRAME"
sysid_gen_sys_init_file $sys_cstring
