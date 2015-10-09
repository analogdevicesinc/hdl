


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcomms2_zc706 1
adi_project_synth fmcomms2_zc706 "" \
  [list "system_top.v" \
  "$ad_hdl_dir/library/prcfg/common/prcfg_bb.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"] \
  [list "../zc706/system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

adi_project_synth fmcomms2_zc706 "default" \
  [list  "../common/prcfg.v" \
  "$ad_hdl_dir/library/prcfg/common/prcfg_top.v" \
  "$ad_hdl_dir/library/prcfg/default/prcfg_dac.v" \
  "$ad_hdl_dir/library/prcfg/default/prcfg_adc.v"]
adi_project_impl fmcomms2_zc706 "default" \
  [list "../common/prcfg.xdc" \
  "system_constr.xdc"]

adi_project_synth fmcomms2_zc706 "bist" \
  [list "../common/prcfg.v" \
  "$ad_hdl_dir/library/prcfg/common/prcfg_top.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/prcfg/bist/prcfg_dac.v" \
  "$ad_hdl_dir/library/prcfg/bist/prcfg_adc.v"]
adi_project_impl fmcomms2_zc706 "bist" "system_constr.xdc"

adi_project_synth fmcomms2_zc706 "qpsk" \
  [list "../common/prcfg.v" \
  "$ad_hdl_dir/library/prcfg/common/prcfg_top.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/prcfg_dac.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/prcfg_adc.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/qpsk_mod.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/qpsk_demod.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/QPSK_Modulator_Baseband.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/QPSK_Demodulator_Baseband.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/FIR_Interpolation.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/FIR_Decimation.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/Raised_Cosine_Transmit_Filter.v" \
  "$ad_hdl_dir/library/prcfg/qpsk/Raised_Cosine_Receive_Filter.v"]
adi_project_impl fmcomms2_zc706 "qpsk" "system_constr.xdc"

adi_project_verify fmcomms2_zc706

