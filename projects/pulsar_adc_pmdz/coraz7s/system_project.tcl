source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project pulsar_adc_pmdz_coraz7s

adi_project_files pulsar_adc_pmdz_coraz7s [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc"]

adi_project_run pulsar_adc_pmdz_coraz7s

