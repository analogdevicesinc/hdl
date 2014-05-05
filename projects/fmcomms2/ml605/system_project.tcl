
set project_name "fmcomms2_ml605"
set project_part "xc6vlx240tff1156-1"
set project_board "ml605"
set project_system_dir "./$project_name.srcs/sources_1/edk/$project_board"

create_project $project_name . -part $project_part  -force
set_property board $project_board [current_project]

import_files -norecurse ../../common/ml605/system.xmp

generate_target  {synthesis implementation}  [get_files $project_system_dir/system.xmp]
make_wrapper -files [get_files $project_system_dir/system.xmp] -top
import_files -force -norecurse -fileset sources_1 $project_system_dir/system_stub.v

add_files -norecurse c:/github/hdl/library/common/ad_rst.v
add_files -norecurse c:/github/hdl/library/common/ad_mul_u16.v
add_files -norecurse c:/github/hdl/library/common/ad_dds_sine.v
add_files -norecurse c:/github/hdl/library/common/ad_dds_1.v
add_files -norecurse c:/github/hdl/library/common/ad_dds.v
add_files -norecurse c:/github/hdl/library/common/ad_datafmt.v
add_files -norecurse c:/github/hdl/library/common/ad_dcfilter.v
add_files -norecurse c:/github/hdl/library/common/ad_iqcor.v
add_files -norecurse c:/github/hdl/library/common/up_axi.v
add_files -norecurse c:/github/hdl/library/common/up_xfer_cntrl.v
add_files -norecurse c:/github/hdl/library/common/up_xfer_status.v
add_files -norecurse c:/github/hdl/library/common/up_clock_mon.v
add_files -norecurse c:/github/hdl/library/common/up_delay_cntrl.v
add_files -norecurse c:/github/hdl/library/common/up_drp_cntrl.v
add_files -norecurse c:/github/hdl/library/common/up_adc_common.v
add_files -norecurse c:/github/hdl/library/common/up_adc_channel.v
add_files -norecurse c:/github/hdl/library/common/up_dac_common.v
add_files -norecurse c:/github/hdl/library/common/up_dac_channel.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_dev_if.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_pnlb.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_rx_pnmon.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_rx_channel.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_rx.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_tx_dds.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_tx_channel.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361_tx.v
add_files -norecurse c:/github/hdl/library/axi_ad9361/axi_ad9361.v

add_files -norecurse c:/github/hdl/library/common/sync_bits.v
add_files -norecurse c:/github/hdl/library/common/sync_gray.v
add_files -norecurse c:/github/hdl/library/axi_fifo/axi_fifo.v
add_files -norecurse c:/github/hdl/library/axi_fifo/address_gray.v
add_files -norecurse c:/github/hdl/library/axi_fifo/address_gray_pipelined.v
add_files -norecurse c:/github/hdl/library/axi_dmac/address_generator.v
add_files -norecurse c:/github/hdl/library/axi_dmac/data_mover.v
add_files -norecurse c:/github/hdl/library/axi_dmac/request_arb.v
add_files -norecurse c:/github/hdl/library/axi_dmac/request_generator.v
add_files -norecurse c:/github/hdl/library/axi_dmac/response_handler.v
add_files -norecurse c:/github/hdl/library/axi_dmac/axi_register_slice.v
add_files -norecurse c:/github/hdl/library/axi_dmac/2d_transfer.v
add_files -norecurse c:/github/hdl/library/axi_dmac/dest_axi_mm.v
add_files -norecurse c:/github/hdl/library/axi_dmac/dest_axi_stream.v
add_files -norecurse c:/github/hdl/library/axi_dmac/dest_fifo_inf.v
add_files -norecurse c:/github/hdl/library/axi_dmac/src_axi_mm.v
add_files -norecurse c:/github/hdl/library/axi_dmac/src_axi_stream.v
add_files -norecurse c:/github/hdl/library/axi_dmac/src_fifo_inf.v
add_files -norecurse c:/github/hdl/library/axi_dmac/splitter.v
add_files -norecurse c:/github/hdl/library/axi_dmac/response_generator.v
add_files -norecurse c:/github/hdl/library/axi_dmac/axi_dmac.v
add_files -norecurse c:/github/hdl/library/axi_dmac/axi_repack.v

add_files -norecurse system_constr.ucf
add_files -norecurse system_top.v
set_property top system_top [current_fileset]

set_property strategy MapTiming [get_runs impl_1]
set_property strategy TimingWithIOBPacking [get_runs synth_1]

launch_runs synth_1
wait_on_run synth_1
open_run synth_1
report_timing_summary -file timing_synth.log

launch_runs impl_1 -to_step bitgen
wait_on_run impl_1
open_run impl_1
report_timing_summary -file timing_impl.log

if [expr [get_property SLACK [get_timing_paths]] < 0] {
  puts "ERROR: Timing Constraints NOT met."
  use_this_invalid_command_to_crash
}

export_hardware [get_files $project_system_dir/system.xmp] [get_runs impl_1] -bitstream
