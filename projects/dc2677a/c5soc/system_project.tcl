set REQUIRED_QUARTUS_VERSION 21.1.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project dc2677a_c5soc

source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

# ltc235x interface

set_location_assignment PIN_K12 -to lvds_cmos_n ; # lvds_cmos_n 54 lvds_rxp1
set_location_assignment PIN_G12 -to cnv         ; # cnv 48 lvds_rxp0
set_location_assignment PIN_F9 -to busy         ; # busy 90 lvds_rxp7
set_location_assignment PIN_F8 -to cs_n         ; # cs_n 92 lvds_rxn7
set_location_assignment PIN_G11 -to pd          ; # pd 50 lvds_rxn0

set_location_assignment PIN_J12 -to sdo_0       ; # sdo_0 56 lvds_rxn1
set_location_assignment PIN_G10 -to sdo_1       ; # sdo_1 60 lvds_rxp2 / sdi_p
set_location_assignment PIN_F10 -to sdo_2       ; # sdo_2 62 lvds_rxn2 / sdi_n
set_location_assignment PIN_J10 -to sdo_3       ; # sdo_3 66 lvds_rxp3 / scki_p
set_location_assignment PIN_K8 -to sdo_4        ; # sdo_4 74 lvds_rxn4 / scko_n
set_location_assignment PIN_J7 -to sdo_5        ; # sdo_5 78 lvds_rxp5 / sdo_p
set_location_assignment PIN_H7 -to sdo_6        ; # sdo_6 80 lvds_rxn5 / sdo_n
set_location_assignment PIN_H8 -to sdo_7        ; # sdo_7 84 lvds_rxp6
set_location_assignment PIN_J9 -to scki         ; # scki 68 lvds_rxn3 / scki_n
set_location_assignment PIN_K7 -to scko         ; # scko 72 lvds_rxp4 / scko_p
set_location_assignment PIN_G8 -to sdi          ; # sdi 86 lvds_rxn6

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to lvds_cmos_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cnv
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to busy
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cs_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pd

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_4
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_5
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_6
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdo_7

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to scki
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to scko
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdi

execute_flow -compile
