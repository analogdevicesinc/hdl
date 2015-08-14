# Script for non-project mode

# activate/deactivate different flow stages
set runInit     1
set runSynth    1
set runImpl     1
set runPrv      1
set runBit      1

# supported carrier ZC706/MITX045
set part "xc7z045ffg900-2"
set board "em.avnet.com:mini_itx_7z045:part0:1.0"

set sys_zynq 1

# Load scripts for env. variables and RP design flow
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_prcfg_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

###############################################################################
#### INIT WORKSPACE ####
###############################################################################
if { $runInit == 1 } {
  prcfg_init_workspace [list  "default" \
                              "bist" \
                              "qpsk"]
}

###############################################################################
#### SYNTHESIS ####
###############################################################################
if { $runSynth == 1 } {

  ###########                  Static part

  prcfg_synth_static [list "./system_top.v" \
                           "${ad_hdl_dir}/library/common/ad_iobuf.v"] \
                           "${ad_hdl_dir}/projects/common/mitx045/mitx045_system_constr.xdc"

  ###########               Reconfigurable part
  # Default
  set prcfg_name "default"
  prcfg_synth_reconf $prcfg_name [list  "../common/prcfg_system_top.v" \
                                        "${ad_hdl_dir}/library/prcfg/common/prcfg_top.v" \
                                        "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_dac.v" \
                                        "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_adc.v"]
  # Bist
  set prcfg_name "bist"
  prcfg_synth_reconf $prcfg_name [list "../common/prcfg_system_top.v" \
                                       "${ad_hdl_dir}/library/prcfg/common/prcfg_top.v" \
                                       "${ad_hdl_dir}/library/common/ad_pnmon.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_dac.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_adc.v"]

  # Qpsk
  set prcfg_name "qpsk"
  prcfg_synth_reconf $prcfg_name [list "../common/prcfg_system_top.v" \
                                       "${ad_hdl_dir}/library/prcfg/common/prcfg_top.v" \
                                       "${ad_hdl_dir}/library/common/ad_pnmon.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_dac.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/prcfg_adc.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/qpsk_mod.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/qpsk_demod.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/QPSK_Modulator_Baseband.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/QPSK_Demodulator_Baseband.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/FIR_Interpolation.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/FIR_Decimation.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/Raised_Cosine_Transmit_Filter.v" \
                                       "${ad_hdl_dir}/library/prcfg/${prcfg_name}/Raised_Cosine_Receive_Filter.v"]
}

###############################################################################
#### IMPLEMENTATION ####
###############################################################################
if { $runImpl == 1 } {
  prcfg_impl "prcfg_constr.xdc" [list "qpsk" \
                                      "bist" \
                                      "default"]
}

###############################################################################
#### PR Verify  ####
###############################################################################
if { $runPrv == 1 } {

  prcfg_verify [list "default" \
                     "bist" \
                     "qpsk"]
}

###############################################################################
#### BITSTREAM GENERATION ####
###############################################################################
if { $runBit == 1} {

  prcfg_gen_bit [list "default" \
                      "bist" \
                      "qpsk"]
}

