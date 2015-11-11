set orig_dir	.;
set ad_hdl_dir	../../..;

if {[catch {
	close_project;
} result_or_errormsg]} {
	puts "No open projects to close.";
}

# TODO use regular expressions.

cd $ad_hdl_dir/library/axi_ad6676;							source ./axi_ad6676_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9122;							source ./axi_ad9122_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9144;							source ./axi_ad9144_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9152;							source ./axi_ad9152_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9234;							source ./axi_ad9234_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9250;							source ./axi_ad9250_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9265;							source ./axi_ad9265_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9361;							source ./axi_ad9361_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9434;							source ./axi_ad9434_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9467;							source ./axi_ad9467_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9625;							source ./axi_ad9625_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9643;							source ./axi_ad9643_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9652;							source ./axi_ad9652_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9671;							source ./axi_ad9671_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9680;							source ./axi_ad9680_ip.tcl;
cd $ad_hdl_dir/library/axi_ad9739a;							source ./axi_ad9739a_ip.tcl;
cd $ad_hdl_dir/library/axi_adcfifo;							source ./axi_adcfifo_ip.tcl;
cd $ad_hdl_dir/library/axi_clkgen;							source ./axi_clkgen_ip.tcl;
cd $ad_hdl_dir/library/axi_dmac;							source ./axi_dmac_ip.tcl;
cd $ad_hdl_dir/library/axi_generic_adc;						source ./axi_generic_adc_ip.tcl;
cd $ad_hdl_dir/library/axi_hdmi_rx;							source ./axi_hdmi_rx_ip.tcl;
cd $ad_hdl_dir/library/axi_hdmi_tx;							source ./axi_hdmi_tx_ip.tcl;
cd $ad_hdl_dir/library/axi_i2s_adi;							source ./axi_i2s_adi_ip.tcl;
cd $ad_hdl_dir/library/axi_mc_controller;					source ./axi_mc_controller_ip.tcl;
cd $ad_hdl_dir/library/axi_mc_current_monitor;				source ./axi_mc_current_monitor_ip.tcl;
cd $ad_hdl_dir/library/axi_mc_speed;						source ./axi_mc_speed_ip.tcl;
cd $ad_hdl_dir/library/axi_spdif_rx;						source ./axi_spdif_rx_ip.tcl;
cd $ad_hdl_dir/library/axi_spdif_tx;						source ./axi_spdif_tx_ip.tcl;
#cd $ad_hdl_dir/library/axi_jesd_xcvr;						source ./axi_jesd_xcvr_ip.tcl;
cd $ad_hdl_dir/library/cn0363/cn0363_dma_sequencer;			source ./cn0363_dma_sequencer_ip.tcl;
cd $ad_hdl_dir/library/cn0363/cn0363_phase_data_sync;		source ./cn0363_phase_data_sync_ip.tcl;
cd $ad_hdl_dir/library/cordic_demod;						source ./cordic_demod_ip.tcl;
cd $ad_hdl_dir/library/interfaces;							source ./interfaces_ip.tcl;
cd $ad_hdl_dir/library/spi_engine/axi_spi_engine;			source ./axi_spi_engine_ip.tcl;
cd $ad_hdl_dir/library/spi_engine/spi_engine_execution;		source ./spi_engine_execution_ip.tcl;
cd $ad_hdl_dir/library/spi_engine/spi_engine_interconnect;	source ./spi_engine_interconnect_ip.tcl;
cd $ad_hdl_dir/library/spi_engine/spi_engine_offload;		source ./spi_engine_offload_ip.tcl;
cd $ad_hdl_dir/library/util_adcfifo;						source ./util_adcfifo_ip.tcl;
cd $ad_hdl_dir/library/util_adc_pack;						source ./util_adc_pack_ip.tcl;
cd $ad_hdl_dir/library/util_axis_fifo;						source ./util_axis_fifo_ip.tcl;
cd $ad_hdl_dir/library/util_axis_resize;					source ./util_axis_resize_ip.tcl;
cd $ad_hdl_dir/library/util_bsplit;							source ./util_bsplit_ip.tcl;
cd $ad_hdl_dir/library/util_ccat;							source ./util_ccat_ip.tcl;
cd $ad_hdl_dir/library/util_cpack;							source ./util_cpack_ip.tcl;
cd $ad_hdl_dir/library/util_dacfifo;						source ./util_dacfifo_ip.tcl;
cd $ad_hdl_dir/library/util_dac_unpack;						source ./util_dac_unpack_ip.tcl;
cd $ad_hdl_dir/library/util_gmii_to_rgmii;					source ./util_gmii_to_rgmii_ip.tcl;
cd $ad_hdl_dir/library/util_gtlb;							source ./util_gtlb_ip.tcl;
cd $ad_hdl_dir/library/util_i2c_mixer;						source ./util_i2c_mixer_ip.tcl;
cd $ad_hdl_dir/library/util_pmod_adc;						source ./util_pmod_adc_ip.tcl;
cd $ad_hdl_dir/library/util_pmod_fmeter;					source ./util_pmod_fmeter_ip.tcl;
cd $ad_hdl_dir/library/util_rfifo;							source ./util_rfifo_ip.tcl;
cd $ad_hdl_dir/library/util_sigma_delta_spi;				source ./util_sigma_delta_spi_ip.tcl;
cd $ad_hdl_dir/library/util_upack;							source ./util_upack_ip.tcl;
cd $ad_hdl_dir/library/util_wfifo;							source ./util_wfifo_ip.tcl;
cd $ad_hdl_dir/library/util_jesd_gt;						source ./util_jesd_gt_ip.tcl;
cd $ad_hdl_dir/library/axi_jesd_gt;							source ./axi_jesd_gt_ip.tcl;

cd $orig_dir;
