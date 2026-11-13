###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

global ad_hdl_dir
global ad_project_dir

set sd_name system_lb
set mss_name mss_base
set root_name ${sd_name}::work
# The MSS is generated next to the project directory (project-microchip.mk)
set generated_cxz [file join [file dirname $ad_project_dir] mss ${mss_name}.cxz]

if {![file exists $generated_cxz]} {
  puts "ERROR: Generated Video Kit MSS component not found: $generated_cxz"
  exit 2
}

# Remove existing MSS component from vault before re-importing to avoid conflicts
catch { remove_library_component -library_name work -component_name $mss_name }
import_mss_component -file $generated_cxz
build_design_hierarchy

# One name per core, used as both the component name and the SmartDesign instance name.
set sys_refclk_pad mpfs_fabric_refclk       ;# XCVR refclk input pad/buffer, no frequency synthesis
set sys_pll        mpfs_fabric_ccc          ;# PF_CCC: 148.5 MHz in (XCVR_2B_REFCLK) -> 100 MHz OUT0 / 200 MHz OUT1
set sys_reset      mpfs_fabric_corereset
set sys_monitor    mpfs_fabric_init_monitor
set sys_clk_pin    ${sys_pll}:OUT0_FABCLK_0
set sys_resetn_pin ${sys_reset}:FABRIC_RESET_N

download_core -vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} \
  -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Microsemi:SgCore:PFSOC_INIT_MONITOR:1.0.309} \
  -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_CCC:2.2.220} \
  -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_XCVR_REF_CLK:1.0.103} \
  -location {www.microchip-ip.com/repositories/SgCore}

create_and_configure_core -core_vlnv {Actel:SgCore:PF_XCVR_REF_CLK:1.0.103} \
  -component_name $sys_refclk_pad \
  -params {\
"ENABLE_FAB_CLK_0:true" \
"ENABLE_FAB_CLK_1:false" \
"ENABLE_REF_CLK_0:true" \
"ENABLE_REF_CLK_1:false" \
"REF_CLK_MODE_0:DIFFERENTIAL" \
"REF_CLK_MODE_1:LVCMOS" }

create_and_configure_core -core_vlnv {Actel:SgCore:PF_CCC:2.2.220} \
  -component_name $sys_pll \
  -params {\
"DLL_CLK_0_BANKCLK_EN:false" \
"DLL_CLK_0_DEDICATED_EN:false" \
"DLL_CLK_0_FABCLK_EN:false" \
"DLL_CLK_1_BANKCLK_EN:false" \
"DLL_CLK_1_DEDICATED_EN:false" \
"DLL_CLK_1_FABCLK_EN:false" \
"DLL_CLK_P_EN:false" \
"DLL_CLK_P_OPTIONS_EN:false" \
"DLL_CLK_REF_OPTION:DIVIDE_BY_1" \
"DLL_CLK_REF_OPTIONS_EN:false" \
"DLL_CLK_S_EN:false" \
"DLL_CLK_S_OPTION:DIVIDE_BY_1" \
"DLL_CLK_S_OPTIONS_EN:false" \
"DLL_DELAY4:0" \
"DLL_DYNAMIC_CODE_EN:false" \
"DLL_DYNAMIC_RECONFIG_INTERFACE_EN:false" \
"DLL_EXPORT_PWRDWN:false" \
"DLL_FB_CLK:Primary" \
"DLL_FB_EN:false" \
"DLL_FINE_PHASE_CODE:0" \
"DLL_IN:133" \
"DLL_JITTER:0" \
"DLL_MODE:PHASE_REF_MODE" \
"DLL_ONLY_EN:false" \
"DLL_OUT_0:1" \
"DLL_OUT_1:1" \
"DLL_PRIM_PHASE:90" \
"DLL_PRIM_PHASE_CODE:0" \
"DLL_SEC_PHASE:90" \
"DLL_SEC_PHASE_CODE:0" \
"DLL_SELECTED_IN:Output2" \
"FF_REQUIRES_LOCK_EN_0:0" \
"GL0_0_BANKCLK_USED:false" \
"GL0_0_BYPASS:0" \
"GL0_0_BYPASS_EN:false" \
"GL0_0_DEDICATED_USED:false" \
"GL0_0_DIV:10" \
"GL0_0_DIVSTART:0" \
"GL0_0_DYNAMIC_PH:false" \
"GL0_0_EXPOSE_EN:false" \
"GL0_0_FABCLK_GATED_USED:false" \
"GL0_0_FABCLK_USED:true" \
"GL0_0_FREQ_SEL:false" \
"GL0_0_IS_USED:true" \
"GL0_0_OUT_FREQ:100" \
"GL0_0_PHASE_INDEX:0" \
"GL0_0_PHASE_SEL:false" \
"GL0_0_PLL_PHASE:0" \
"GL0_1_BANKCLK_USED:false" \
"GL0_1_BYPASS:0" \
"GL0_1_BYPASS_EN:false" \
"GL0_1_DEDICATED_USED:false" \
"GL0_1_DIV:1" \
"GL0_1_DIVSTART:0" \
"GL0_1_DYNAMIC_PH:false" \
"GL0_1_EXPOSE_EN:false" \
"GL0_1_FABCLK_USED:false" \
"GL0_1_FREQ_SEL:false" \
"GL0_1_IS_USED:true" \
"GL0_1_OUT_FREQ:100" \
"GL0_1_PHASE_INDEX:0" \
"GL0_1_PHASE_SEL:false" \
"GL0_1_PLL_PHASE:0" \
"GL1_0_BANKCLK_USED:false" \
"GL1_0_BYPASS:0" \
"GL1_0_BYPASS_EN:false" \
"GL1_0_DEDICATED_USED:false" \
"GL1_0_DIV:5" \
"GL1_0_DIVSTART:0" \
"GL1_0_DYNAMIC_PH:false" \
"GL1_0_EXPOSE_EN:false" \
"GL1_0_FABCLK_GATED_USED:false" \
"GL1_0_FABCLK_USED:true" \
"GL1_0_FREQ_SEL:false" \
"GL1_0_IS_USED:true" \
"GL1_0_OUT_FREQ:200" \
"GL1_0_PHASE_INDEX:0" \
"GL1_0_PHASE_SEL:false" \
"GL1_0_PLL_PHASE:0" \
"GL1_1_BANKCLK_USED:false" \
"GL1_1_BYPASS:0" \
"GL1_1_BYPASS_EN:false" \
"GL1_1_DEDICATED_USED:false" \
"GL1_1_DIV:1" \
"GL1_1_DIVSTART:0" \
"GL1_1_DYNAMIC_PH:false" \
"GL1_1_EXPOSE_EN:false" \
"GL1_1_FABCLK_USED:false" \
"GL1_1_FREQ_SEL:false" \
"GL1_1_IS_USED:false" \
"GL1_1_OUT_FREQ:0" \
"GL1_1_PHASE_INDEX:0" \
"GL1_1_PHASE_SEL:false" \
"GL1_1_PLL_PHASE:0" \
"GL2_0_BANKCLK_USED:false" \
"GL2_0_BYPASS:0" \
"GL2_0_BYPASS_EN:false" \
"GL2_0_DEDICATED_USED:false" \
"GL2_0_DIV:50" \
"GL2_0_DIVSTART:0" \
"GL2_0_DYNAMIC_PH:false" \
"GL2_0_EXPOSE_EN:false" \
"GL2_0_FABCLK_GATED_USED:false" \
"GL2_0_FABCLK_USED:true" \
"GL2_0_FREQ_SEL:false" \
"GL2_0_IS_USED:false" \
"GL2_0_OUT_FREQ:20" \
"GL2_0_PHASE_INDEX:0" \
"GL2_0_PHASE_SEL:false" \
"GL2_0_PLL_PHASE:0" \
"GL2_1_BANKCLK_USED:false" \
"GL2_1_BYPASS:0" \
"GL2_1_BYPASS_EN:false" \
"GL2_1_DEDICATED_USED:false" \
"GL2_1_DIV:1" \
"GL2_1_DIVSTART:0" \
"GL2_1_DYNAMIC_PH:false" \
"GL2_1_EXPOSE_EN:false" \
"GL2_1_FABCLK_USED:false" \
"GL2_1_FREQ_SEL:false" \
"GL2_1_IS_USED:false" \
"GL2_1_OUT_FREQ:0" \
"GL2_1_PHASE_INDEX:0" \
"GL2_1_PHASE_SEL:false" \
"GL2_1_PLL_PHASE:0" \
"GL3_0_BANKCLK_USED:false" \
"GL3_0_BYPASS:0" \
"GL3_0_BYPASS_EN:false" \
"GL3_0_DEDICATED_USED:false" \
"GL3_0_DIV:1" \
"GL3_0_DIVSTART:0" \
"GL3_0_DYNAMIC_PH:false" \
"GL3_0_EXPOSE_EN:false" \
"GL3_0_FABCLK_GATED_USED:false" \
"GL3_0_FABCLK_USED:true" \
"GL3_0_FREQ_SEL:false" \
"GL3_0_IS_USED:false" \
"GL3_0_OUT_FREQ:100" \
"GL3_0_PHASE_INDEX:0" \
"GL3_0_PHASE_SEL:false" \
"GL3_0_PLL_PHASE:0" \
"GL3_1_BANKCLK_USED:false" \
"GL3_1_BYPASS:0" \
"GL3_1_BYPASS_EN:false" \
"GL3_1_DEDICATED_USED:false" \
"GL3_1_DIV:1" \
"GL3_1_DIVSTART:0" \
"GL3_1_DYNAMIC_PH:false" \
"GL3_1_EXPOSE_EN:false" \
"GL3_1_FABCLK_USED:false" \
"GL3_1_FREQ_SEL:false" \
"GL3_1_IS_USED:false" \
"GL3_1_OUT_FREQ:0" \
"GL3_1_PHASE_INDEX:0" \
"GL3_1_PHASE_SEL:false" \
"GL3_1_PLL_PHASE:0" \
"PLL_ALLOW_CCC_EXT_FB:false" \
"PLL_BANDWIDTH_0:2" \
"PLL_BANDWIDTH_1:1" \
"PLL_BYPASS_GO_B_0:false" \
"PLL_BYPASS_GO_B_1:false" \
"PLL_BYPASS_POST_0:0" \
"PLL_BYPASS_POST_0_0:false" \
"PLL_BYPASS_POST_0_1:false" \
"PLL_BYPASS_POST_0_2:false" \
"PLL_BYPASS_POST_0_3:false" \
"PLL_BYPASS_POST_1:0" \
"PLL_BYPASS_POST_1_0:false" \
"PLL_BYPASS_POST_1_1:false" \
"PLL_BYPASS_POST_1_2:false" \
"PLL_BYPASS_POST_1_3:false" \
"PLL_BYPASS_PRE_0:0" \
"PLL_BYPASS_PRE_0_0:false" \
"PLL_BYPASS_PRE_0_1:false" \
"PLL_BYPASS_PRE_0_2:false" \
"PLL_BYPASS_PRE_0_3:false" \
"PLL_BYPASS_PRE_1:0" \
"PLL_BYPASS_PRE_1_0:false" \
"PLL_BYPASS_PRE_1_1:false" \
"PLL_BYPASS_PRE_1_2:false" \
"PLL_BYPASS_PRE_1_3:false" \
"PLL_BYPASS_SEL_0:0" \
"PLL_BYPASS_SEL_0_0:false" \
"PLL_BYPASS_SEL_0_1:false" \
"PLL_BYPASS_SEL_0_2:false" \
"PLL_BYPASS_SEL_0_3:false" \
"PLL_BYPASS_SEL_1:0" \
"PLL_BYPASS_SEL_1_0:false" \
"PLL_BYPASS_SEL_1_1:false" \
"PLL_BYPASS_SEL_1_2:false" \
"PLL_BYPASS_SEL_1_3:false" \
"PLL_DELAY_LINE_REF_FB_0:false" \
"PLL_DELAY_LINE_REF_FB_1:false" \
"PLL_DELAY_LINE_USED_0:false" \
"PLL_DELAY_LINE_USED_1:false" \
"PLL_DELAY_STEPS_0:1" \
"PLL_DELAY_STEPS_1:1" \
"PLL_DLL_CASCADED_EN:false" \
"PLL_DYNAMIC_CONTROL_EN_0:true" \
"PLL_DYNAMIC_CONTROL_EN_1:false" \
"PLL_DYNAMIC_RECONFIG_INTERFACE_EN_0:false" \
"PLL_DYNAMIC_RECONFIG_INTERFACE_EN_1:false" \
"PLL_EXPORT_PWRDWN:false" \
"PLL_EXT_MAX_ADDR_0:128" \
"PLL_EXT_MAX_ADDR_1:128" \
"PLL_EXT_WAVE_SEL_0:0" \
"PLL_EXT_WAVE_SEL_1:0" \
"PLL_FB_CLK_0:GL0_0" \
"PLL_FB_CLK_1:GL0_1" \
"PLL_FEEDBACK_MODE_0:Post-VCO" \
"PLL_FEEDBACK_MODE_1:Post-VCO" \
"PLL_IN_FREQ_0:148.5" \
"PLL_IN_FREQ_1:100" \
"PLL_INT_MODE_EN_0:false" \
"PLL_INT_MODE_EN_1:false" \
"PLL_LOCK_COUNT_0:0" \
"PLL_LOCK_COUNT_1:0" \
"PLL_LP_REQUIRES_LOCK_EN_0:false" \
"PLL_LP_REQUIRES_LOCK_EN_1:false" \
"PLL_PLL_CASCADED_EN:false" \
"PLL_PLL_CASCADED_SELECTED_CLK:Output2" \
"PLL_POSTDIVIDERADDSOFTLOGIC_0:true" \
"PLL_REF_CLK_SEL_0:false" \
"PLL_REF_CLK_SEL_1:false" \
"PLL_REFDIV_0:1" \
"PLL_REFDIV_1:1" \
"PLL_RESET_ON_LOCK_0:true" \
"PLL_SPREAD_MODE_0:false" \
"PLL_SPREAD_MODE_1:false" \
"PLL_SSM_DEPTH_0:5" \
"PLL_SSM_DEPTH_1:5" \
"PLL_SSM_DIVVAL_0:1" \
"PLL_SSM_DIVVAL_1:1" \
"PLL_SSM_FREQ_0:32" \
"PLL_SSM_FREQ_1:32" \
"PLL_SSM_RAND_PATTERN_0:2" \
"PLL_SSM_RAND_PATTERN_1:2" \
"PLL_SSMD_EN_0:false" \
"PLL_SSMD_EN_1:false" \
"PLL_SYNC_CORNER_PLL:false" \
"PLL_SYNC_EN:false" \
"PLL_VCO_MODE_0:MIN_JITTER" \
"PLL_VCO_MODE_1:MIN_JITTER" }

create_and_configure_core -core_vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} \
  -component_name $sys_reset \
  -params { }

create_and_configure_core -core_vlnv {Microsemi:SgCore:PFSOC_INIT_MONITOR:1.0.309} \
  -component_name $sys_monitor \
  -params {\
"BANK_0_CALIB_STATUS_ENABLED:false" \
"BANK_0_CALIB_STATUS_SIMULATION_DELAY:1" \
"BANK_0_RECALIBRATION_ENABLED:false" \
"BANK_0_VDDI_STATUS_ENABLED:false" \
"BANK_0_VDDI_STATUS_SIMULATION_DELAY:1" \
"BANK_1_CALIB_STATUS_ENABLED:false" \
"BANK_1_CALIB_STATUS_SIMULATION_DELAY:1" \
"BANK_1_RECALIBRATION_ENABLED:false" \
"BANK_1_VDDI_STATUS_ENABLED:false" \
"BANK_1_VDDI_STATUS_SIMULATION_DELAY:1" \
"BANK_7_CALIB_STATUS_ENABLED:true" \
"BANK_7_CALIB_STATUS_SIMULATION_DELAY:1" \
"BANK_7_RECALIBRATION_ENABLED:false" \
"BANK_7_VDDI_STATUS_ENABLED:false" \
"BANK_7_VDDI_STATUS_SIMULATION_DELAY:1" \
"BANK_8_CALIB_STATUS_ENABLED:true" \
"BANK_8_CALIB_STATUS_SIMULATION_DELAY:1" \
"BANK_8_RECALIBRATION_ENABLED:false" \
"BANK_8_VDDI_STATUS_ENABLED:false" \
"BANK_8_VDDI_STATUS_SIMULATION_DELAY:1" \
"BANK_9_CALIB_STATUS_ENABLED:true" \
"BANK_9_CALIB_STATUS_SIMULATION_DELAY:1" \
"BANK_9_RECALIBRATION_ENABLED:false" \
"BANK_9_VDDI_STATUS_ENABLED:false" \
"BANK_9_VDDI_STATUS_SIMULATION_DELAY:1" \
"DEVICE_INIT_DONE_SIMULATION_DELAY:7" \
"FABRIC_DELAY_INCR:3" \
"FABRIC_POR_N_SIMULATION_DELAY:1" \
"LATCH_SC_OUTPUTS:false" \
"PCIE_DELAY_INCR:2" \
"PCIE_INIT_DONE_SIMULATION_DELAY:4" \
"SHOW_BANK_0_CALIB_STATUS_ENABLED:false" \
"SHOW_BANK_0_RECALIBRATION_ENABLED:true" \
"SHOW_BANK_0_VDDI_STATUS_ENABLED:true" \
"SHOW_BANK_1_CALIB_STATUS_ENABLED:false" \
"SHOW_BANK_1_RECALIBRATION_ENABLED:true" \
"SHOW_BANK_1_VDDI_STATUS_ENABLED:true" \
"SHOW_BANK_7_CALIB_STATUS_ENABLED:false" \
"SHOW_BANK_7_RECALIBRATION_ENABLED:false" \
"SHOW_BANK_7_VDDI_STATUS_ENABLED:false" \
"SHOW_BANK_8_CALIB_STATUS_ENABLED:false" \
"SHOW_BANK_8_RECALIBRATION_ENABLED:0" \
"SHOW_BANK_8_VDDI_STATUS_ENABLED:false" \
"SHOW_BANK_9_CALIB_STATUS_ENABLED:false" \
"SHOW_BANK_9_RECALIBRATION_ENABLED:false" \
"SHOW_BANK_9_VDDI_STATUS_ENABLED:false" \
"SRAM_DELAY_INCR:3" \
"SRAM_INIT_DONE_SIMULATION_DELAY:6" \
"URAM_DELAY_INCR:3" \
"USRAM_INIT_DONE_SIMULATION_DELAY:5" }

create_smartdesign -sd_name $sd_name
auto_promote_pad_pins -promote_all 0

sd_create_scalar_port -sd_name $sd_name -port_name {MMUART_0_RXD_F2M} -port_direction {IN}
sd_create_scalar_port -sd_name $sd_name -port_name {MMUART_1_RXD_F2M} -port_direction {IN}
sd_create_scalar_port -sd_name $sd_name -port_name {REFCLK} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {REFCLK_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {REF_CLK_PAD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {REF_CLK_PAD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_RX0_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_RX0_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_RX1_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_RX1_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_CD_EMMC_STRB} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_WP_EMMC_RSTN} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_CLK} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DIR} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_NXT} -port_direction {IN} -port_is_pad {1}

sd_create_scalar_port -sd_name $sd_name -port_name {CKE} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {CK} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {CK_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {CS} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {MAC_0_MDC} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {MMUART_0_TXD_M2F} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {MMUART_1_TXD_M2F} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {ODT} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {RESET_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SDIO_SW_EN_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SDIO_SW_SEL0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SDIO_SW_SEL1} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_CLK_EMMC_CLK} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_POW_EMMC_DATA4} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_VOLT_SEL_EMMC_DATA5} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_VOLT_EN_EMMC_DATA6} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_VOLT_CMD_DIR_EMMC_DATA7} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_VOLT_DIR_0_EMMC_UNUSED} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_VOLT_DIR_1_3_EMMC_UNUSED} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_TX0_P} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_TX0_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_TX1_P} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SGMII_TX1_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_STP} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_ULPI_RESET_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_CMODE3} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_CMODE4} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_CMODE5} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_CMODE6} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_CMODE7} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_RESETN} -port_direction {OUT}
sd_create_scalar_port -sd_name $sd_name -port_name {VSC_8662_SRESET} -port_direction {OUT}

sd_create_scalar_port -sd_name $sd_name -port_name {MAC_0_MDIO} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_CMD_EMMC_CMD} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_DATA0_EMMC_DATA0} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_DATA1_EMMC_DATA1} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_DATA2_EMMC_DATA2} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {SD_DATA3_EMMC_DATA3} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA0} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA1} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA2} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA3} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA4} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA5} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA6} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name $sd_name -port_name {USB_DATA7} -port_direction {INOUT} -port_is_pad {1}
sd_create_bus_port -sd_name $sd_name -port_name {CA} -port_direction {OUT} -port_range {[5:0]} -port_is_pad {1}
sd_create_bus_port -sd_name $sd_name -port_name {DM} -port_direction {OUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name $sd_name -port_name {DQ} -port_direction {INOUT} -port_range {[31:0]} -port_is_pad {1}
sd_create_bus_port -sd_name $sd_name -port_name {DQS} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name $sd_name -port_name {DQS_N} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}

foreach port_def {
  {spi0_clk OUT 0}
  {spi0_csn OUT 0}
  {spi0_mosi OUT 0}
  {spi0_miso IN 0}
  {spi1_clk OUT 0}
  {spi1_csn OUT 0}
  {spi1_mosi OUT 0}
  {spi1_miso IN 0}
} {
  lassign $port_def port_name port_dir is_pad
  sd_create_scalar_port -sd_name $sd_name -port_name $port_name -port_direction $port_dir -port_is_pad $is_pad
}

foreach port_def {
  {i2c0_scl_i IN 0}
  {i2c0_sda_i IN 0}
  {i2c0_scl_oe OUT 0}
  {i2c0_sda_oe OUT 0}
  {i2c1_scl_i IN 0}
  {i2c1_sda_i IN 0}
  {i2c1_scl_oe OUT 0}
  {i2c1_sda_oe OUT 0}
} {
  lassign $port_def port_name port_dir is_pad
  sd_create_scalar_port -sd_name $sd_name -port_name $port_name -port_direction $port_dir -port_is_pad $is_pad
}

sd_create_bus_port -sd_name $sd_name -port_name {gpio2_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name $sd_name -port_name {gpio2_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name $sd_name -port_name {gpio2_oe} -port_direction {OUT} -port_range {[31:0]}

sd_instantiate_component -sd_name $sd_name -component_name ${mss_name} -instance_name {MSS}
sd_instantiate_component -sd_name $sd_name -component_name $sys_refclk_pad -instance_name $sys_refclk_pad
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_refclk_pad}:REF_CLK]
sd_instantiate_component -sd_name $sd_name -component_name $sys_pll -instance_name $sys_pll
sd_instantiate_component -sd_name $sd_name -component_name $sys_reset -instance_name $sys_reset
sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list ${sys_reset}:BANK_x_VDDI_STATUS] -value {VCC}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list ${sys_reset}:BANK_y_VDDI_STATUS] -value {VCC}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list ${sys_reset}:SS_BUSY] -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list ${sys_reset}:FF_US_RESTORE] -value {GND}
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_reset}:PLL_POWERDOWN_B]
sd_instantiate_component -sd_name $sd_name -component_name $sys_monitor -instance_name $sys_monitor
sd_create_pin_group -sd_name $sd_name -group_name {mpfs_fabric_init_monitor_status} -instance_name $sys_monitor -pin_names {"USRAM_INIT_FROM_SNVM_DONE" "USRAM_INIT_DONE" "SRAM_INIT_FROM_UPROM_DONE" "USRAM_INIT_FROM_UPROM_DONE" "SRAM_INIT_FROM_SPI_DONE" "SRAM_INIT_DONE" "USRAM_INIT_FROM_SPI_DONE" "SRAM_INIT_FROM_SNVM_DONE" "AUTOCALIB_DONE" "PCIE_INIT_DONE" "XCVR_INIT_DONE"}
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:PCIE_INIT_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:USRAM_INIT_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:SRAM_INIT_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:USRAM_INIT_FROM_SNVM_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:USRAM_INIT_FROM_UPROM_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:USRAM_INIT_FROM_SPI_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:SRAM_INIT_FROM_SNVM_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:SRAM_INIT_FROM_UPROM_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:SRAM_INIT_FROM_SPI_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:AUTOCALIB_DONE]
sd_mark_pins_unused -sd_name $sd_name -pin_names [list ${sys_monitor}:XCVR_INIT_DONE]

sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_CMODE3} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_CMODE4} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_CMODE5} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_CMODE6} -value {VCC}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_CMODE7} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {VSC_8662_SRESET} -value {VCC}

sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:MSS_INT_F2M} -value {GND}
# as in the Microchip reference design, the fabric reset waits for the fabric
# PLL only; the FIC DLL locks are not used
sd_connect_pins -sd_name $sd_name -pin_names [list ${sys_pll}:PLL_LOCK_0 ${sys_reset}:PLL_LOCK]
sd_connect_pins -sd_name $sd_name -pin_names [list MSS:MSS_RESET_N_M2F ${sys_reset}:EXT_RST_N]
sd_connect_pins -sd_name $sd_name -pin_names [list ${sys_reset}:INIT_DONE ${sys_monitor}:DEVICE_INIT_DONE]
sd_connect_pins -sd_name $sd_name -pin_names [list ${sys_reset}:FPGA_POR_N ${sys_monitor}:FABRIC_POR_N MSS:MSS_RESET_N_F2M]
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_clk_pin ${sys_reset}:CLK MSS:FIC_0_ACLK MSS:FIC_1_ACLK MSS:FIC_2_ACLK MSS:FIC_3_PCLK]

foreach unused_pin {
  MSS:MMUART_0_TXD_OE_M2F
  MSS:MMUART_1_TXD_OE_M2F
  MSS:PLL_CPU_LOCK_M2F
  MSS:PLL_DDR_LOCK_M2F
  MSS:PLL_SGMII_LOCK_M2F
  MSS:MSS_INT_M2F
  MSS:CRYPTO_DLL_LOCK_M2F
  MSS:FIC_0_DLL_LOCK_M2F
  MSS:FIC_1_DLL_LOCK_M2F
  MSS:CRYPTO_BUSY_M2F
  MSS:SPI_0_SS1_OE_M2F
  MSS:SPI_0_DO_OE_M2F
  MSS:SPI_0_CLK_OE_M2F
  MSS:SPI_1_SS1_OE_M2F
  MSS:SPI_1_DO_OE_M2F
  MSS:SPI_1_CLK_OE_M2F
} {
  sd_mark_pins_unused -sd_name $sd_name -pin_names $unused_pin
}

sd_connect_pins -sd_name $sd_name -pin_names {CK MSS:CK}
sd_connect_pins -sd_name $sd_name -pin_names {CKE MSS:CKE}
sd_connect_pins -sd_name $sd_name -pin_names {CK_N MSS:CK_N}
sd_connect_pins -sd_name $sd_name -pin_names {CS MSS:CS}
sd_connect_pins -sd_name $sd_name -pin_names {MAC_0_MDC MSS:MAC_0_MDC}
sd_connect_pins -sd_name $sd_name -pin_names {MAC_0_MDIO MSS:MAC_0_MDIO}
sd_connect_pins -sd_name $sd_name -pin_names {MMUART_0_RXD_F2M MSS:MMUART_0_RXD_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {MMUART_0_TXD_M2F MSS:MMUART_0_TXD_M2F}
sd_connect_pins -sd_name $sd_name -pin_names {MMUART_1_RXD_F2M MSS:MMUART_1_RXD_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {MMUART_1_TXD_M2F MSS:MMUART_1_TXD_M2F}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:GPIO_1_12_OUT USB_ULPI_RESET_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:GPIO_1_16_OUT SDIO_SW_SEL0}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:GPIO_1_20_OUT SDIO_SW_SEL1}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:GPIO_1_23_OUT SDIO_SW_EN_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:MSS_RESET_N_M2F VSC_8662_RESETN}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:ODT ODT}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:REFCLK REFCLK}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:REFCLK_N REFCLK_N}
sd_connect_pins -sd_name $sd_name -pin_names [list REF_CLK_PAD_P ${sys_refclk_pad}:REF_CLK_PAD_P]
sd_connect_pins -sd_name $sd_name -pin_names [list REF_CLK_PAD_N ${sys_refclk_pad}:REF_CLK_PAD_N]
sd_connect_pins -sd_name $sd_name -pin_names [list ${sys_refclk_pad}:FAB_REF_CLK ${sys_pll}:REF_CLK_0]
sd_connect_pins -sd_name $sd_name -pin_names {MSS:RESET_N RESET_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_CD_EMMC_STRB SD_CD_EMMC_STRB}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_CLK_EMMC_CLK SD_CLK_EMMC_CLK}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_CMD_EMMC_CMD SD_CMD_EMMC_CMD}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_DATA0_EMMC_DATA0 SD_DATA0_EMMC_DATA0}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_DATA1_EMMC_DATA1 SD_DATA1_EMMC_DATA1}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_DATA2_EMMC_DATA2 SD_DATA2_EMMC_DATA2}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_DATA3_EMMC_DATA3 SD_DATA3_EMMC_DATA3}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_POW_EMMC_DATA4 SD_POW_EMMC_DATA4}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_VOLT_SEL_EMMC_DATA5 SD_VOLT_SEL_EMMC_DATA5}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_VOLT_EN_EMMC_DATA6 SD_VOLT_EN_EMMC_DATA6}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_VOLT_CMD_DIR_EMMC_DATA7 SD_VOLT_CMD_DIR_EMMC_DATA7}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_VOLT_DIR_0_EMMC_UNUSED SD_VOLT_DIR_0_EMMC_UNUSED}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_VOLT_DIR_1_3_EMMC_UNUSED SD_VOLT_DIR_1_3_EMMC_UNUSED}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SD_WP_EMMC_RSTN SD_WP_EMMC_RSTN}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_RX0_N SGMII_RX0_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_RX0_P SGMII_RX0_P}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_RX1_N SGMII_RX1_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_RX1_P SGMII_RX1_P}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_TX0_N SGMII_TX0_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_TX0_P SGMII_TX0_P}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_TX1_N SGMII_TX1_N}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SGMII_TX1_P SGMII_TX1_P}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_CLK USB_CLK}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA0 USB_DATA0}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA1 USB_DATA1}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA2 USB_DATA2}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA3 USB_DATA3}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA4 USB_DATA4}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA5 USB_DATA5}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA6 USB_DATA6}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DATA7 USB_DATA7}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_DIR USB_DIR}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_NXT USB_NXT}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:USB_STP USB_STP}

sd_connect_pins -sd_name $sd_name -pin_names {i2c0_scl_i MSS:I2C_0_SCL_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {i2c0_sda_i MSS:I2C_0_SDA_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:I2C_0_SCL_OE_M2F i2c0_scl_oe}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:I2C_0_SDA_OE_M2F i2c0_sda_oe}
sd_connect_pins -sd_name $sd_name -pin_names {i2c1_scl_i MSS:I2C_1_SCL_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {i2c1_sda_i MSS:I2C_1_SDA_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:I2C_1_SCL_OE_M2F i2c1_scl_oe}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:I2C_1_SDA_OE_M2F i2c1_sda_oe}

sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:SPI_0_SS_F2M} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:SPI_0_CLK_F2M} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:SPI_1_SS_F2M} -value {GND}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:SPI_1_CLK_F2M} -value {GND}

sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_0_CLK_M2F spi0_clk}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_0_DO_M2F spi0_mosi}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_0_DI_F2M spi0_miso}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_0_SS1_M2F spi0_csn}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_1_CLK_M2F spi1_clk}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_1_DO_M2F spi1_mosi}
sd_connect_pins -sd_name $sd_name -pin_names {spi1_miso MSS:SPI_1_DI_F2M}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:SPI_1_SS1_M2F spi1_csn}

for {set gpio_idx 0} {$gpio_idx < 32} {incr gpio_idx} {
  set gpio_slice [format {[%d:%d]} $gpio_idx $gpio_idx]
  set gpio_m2f [format {MSS:GPIO_2_M2F_%d} $gpio_idx]
  set gpio_f2m [format {MSS:GPIO_2_F2M_%d} $gpio_idx]
  set gpio_oe_m2f [format {MSS:GPIO_2_OE_M2F_%d} $gpio_idx]
  sd_create_pin_slices -sd_name $sd_name -pin_name {gpio2_i} -pin_slices $gpio_slice
  sd_create_pin_slices -sd_name $sd_name -pin_name {gpio2_o} -pin_slices $gpio_slice
  sd_create_pin_slices -sd_name $sd_name -pin_name {gpio2_oe} -pin_slices $gpio_slice
  sd_connect_pins -sd_name $sd_name -pin_names [format {gpio2_i[%d:%d] %s} $gpio_idx $gpio_idx $gpio_f2m]
  sd_connect_pins -sd_name $sd_name -pin_names [format {%s gpio2_o[%d:%d]} $gpio_m2f $gpio_idx $gpio_idx]
  sd_connect_pins -sd_name $sd_name -pin_names [format {%s gpio2_oe[%d:%d]} $gpio_oe_m2f $gpio_idx $gpio_idx]
}

sd_connect_pins -sd_name $sd_name -pin_names {CA MSS:CA}
sd_connect_pins -sd_name $sd_name -pin_names {DM MSS:DM}
sd_connect_pins -sd_name $sd_name -pin_names {DQ MSS:DQ}
sd_connect_pins -sd_name $sd_name -pin_names {DQS MSS:DQS}
sd_connect_pins -sd_name $sd_name -pin_names {DQS_N MSS:DQS_N}
