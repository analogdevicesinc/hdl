
load_package flow

source ../../scripts/adi_env.tcl
project_new usdrx1_a5gt -overwrite

source $ad_hdl_dir/projects/common/a5gt/a5gt_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/altera/ad_jesd_align.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/altera/ad_xcvr_rx_rst.v
set_global_assignment -name VERILOG_FILE ../common/usdrx1_spi.v

# reference clock

set_location_assignment PIN_AB9   -to ref_clk
set_location_assignment PIN_AB8   -to "ref_clk(n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to ref_clk
set_instance_assignment -name XCVR_REFCLK_PIN_TERMINATION AC_COUPLING -to ref_clk
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to ref_clk

# lane data

set_location_assignment PIN_AE1   -to rx_data[0]
set_location_assignment PIN_AE2   -to "rx_data[0](n)"
set_location_assignment PIN_AA1    -to rx_data[1]
set_location_assignment PIN_AA2   -to "rx_data[1](n)"
set_location_assignment PIN_U1    -to rx_data[2]
set_location_assignment PIN_U2    -to "rx_data[2](n)"
set_location_assignment PIN_R1    -to rx_data[3]
set_location_assignment PIN_R2    -to "rx_data[3](n)"
set_location_assignment PIN_J1    -to rx_data[4]
set_location_assignment PIN_J2    -to "rx_data[4](n)"
set_location_assignment PIN_N1    -to rx_data[5]
set_location_assignment PIN_N2    -to "rx_data[5](n)"
set_location_assignment PIN_L1    -to rx_data[6]
set_location_assignment PIN_L2    -to "rx_data[6](n)"
set_location_assignment PIN_G1    -to rx_data[7]
set_location_assignment PIN_G2    -to "rx_data[7](n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[7]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[0]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[1]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[2]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[3]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[4]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[5]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[6]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[7]

# jesd signals

set_location_assignment PIN_AL22   -to rx_sync
set_location_assignment PIN_AK22   -to "rx_sync(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sync

set_location_assignment PIN_AW18   -to rx_sysref
set_location_assignment PIN_AV18   -to "rx_sysref(n)"
set_instance_assignment -name IO_STANDARD LVDS -to rx_sysref

set_location_assignment PIN_AL23   -to afe_rst
set_location_assignment PIN_AK23   -to "afe_rst(n)"
set_instance_assignment -name IO_STANDARD LVDS -to afe_rst

set_location_assignment PIN_AK25   -to afe_trig
set_location_assignment PIN_AJ25   -to "afe_trig(n)"
set_instance_assignment -name IO_STANDARD LVDS -to afe_trig

# spi

set_location_assignment PIN_AM9   -to spi_fout_clk
set_location_assignment PIN_AL9   -to spi_fout_sdio
set_location_assignment PIN_AV6   -to spi_fout_enb_clk
set_location_assignment PIN_AV7   -to spi_fout_enb_mlo
set_location_assignment PIN_AU13  -to spi_fout_enb_rst
set_location_assignment PIN_AT13  -to spi_fout_enb_sync
set_location_assignment PIN_AD16  -to spi_fout_enb_sysref
set_location_assignment PIN_AC16  -to spi_fout_enb_trig
set_location_assignment PIN_AW13  -to spi_afe_clk
set_location_assignment PIN_AV13  -to spi_afe_sdio
set_location_assignment PIN_AP7   -to spi_afe_csn[0]
set_location_assignment PIN_AN7   -to spi_afe_csn[1]
set_location_assignment PIN_AH17  -to spi_afe_csn[2]
set_location_assignment PIN_AG17  -to spi_afe_csn[3]
set_location_assignment PIN_AW14  -to spi_clk_csn
set_location_assignment PIN_AN9   -to spi_clk_clk
set_location_assignment PIN_AP9   -to spi_clk_sdio
set_location_assignment PIN_AJ16  -to clk_resetn
set_location_assignment PIN_AK16  -to clk_syncn
set_location_assignment PIN_AL24  -to clk_status

set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_mlo
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_rst
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_sync
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_sysref
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_enb_trig
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_fout_sdio
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_csn[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_csn[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_csn[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_csn[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_afe_sdio
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk_sdio
set_instance_assignment -name IO_STANDARD "2.5 V" -to clk_resetn
set_instance_assignment -name IO_STANDARD "2.5 V" -to clk_syncn
set_instance_assignment -name IO_STANDARD "2.5 V" -to clk_status

# gpio

set_location_assignment PIN_AL14  -to afe_pdn
set_location_assignment PIN_AK14  -to afe_stby
set_location_assignment PIN_AK24  -to amp_disbn
set_location_assignment PIN_AT16  -to prc_sck
set_location_assignment PIN_AR16  -to prc_cnv
set_location_assignment PIN_AC22  -to prc_sdo_i
set_location_assignment PIN_AD21  -to prc_sdo_q
set_location_assignment PIN_AW15  -to dac_sleep
set_location_assignment PIN_AG22  -to dac_data[0]
set_location_assignment PIN_AH22  -to dac_data[1]
set_location_assignment PIN_AV22  -to dac_data[2]
set_location_assignment PIN_AW22  -to dac_data[3]
set_location_assignment PIN_AL16  -to dac_data[4]
set_location_assignment PIN_AM16  -to dac_data[5]
set_location_assignment PIN_AK15  -to dac_data[6]
set_location_assignment PIN_AL15  -to dac_data[7]
set_location_assignment PIN_AU6   -to dac_data[8]
set_location_assignment PIN_AT6   -to dac_data[9]
set_location_assignment PIN_AK8   -to dac_data[10]
set_location_assignment PIN_AL8   -to dac_data[11]
set_location_assignment PIN_AT15  -to dac_data[12]
set_location_assignment PIN_AU15  -to dac_data[13]

set_instance_assignment -name IO_STANDARD "2.5 V" -to afe_pdn
set_instance_assignment -name IO_STANDARD "2.5 V" -to afe_stby
set_instance_assignment -name IO_STANDARD "2.5 V" -to amp_disbn
set_instance_assignment -name IO_STANDARD "2.5 V" -to prc_sck
set_instance_assignment -name IO_STANDARD "2.5 V" -to prc_cnv
set_instance_assignment -name IO_STANDARD "2.5 V" -to prc_sdo_i
set_instance_assignment -name IO_STANDARD "2.5 V" -to prc_sdo_q
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_sleep
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[7]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[8]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[9]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[10]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[11]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[12]
set_instance_assignment -name IO_STANDARD "2.5 V" -to dac_data[13]

execute_flow -compile

