###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir O reset

ad_connect reset sys_rstgen/peripheral_reset
