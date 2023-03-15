# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

exec python3 ../../submodules/open5G_rx/tools/generate_FFT_demod_tap_file.py --NFFT=8 --CP_LEN=18 --CP_ADVANCE=9

adi_ip_create open5G_rx
adi_ip_files open5G_rx [list \
  "hdl/receiver.sv" \
  "hdl/dot_product.sv" \
  "hdl/Peak_detector.sv" \
  "hdl/atan.sv" \
  "hdl/atan2.sv" \
  "hdl/div.sv" \
  "hdl/LFSR/LFSR.sv" \
  "hdl/AXI_lite_interface.sv" \
  "hdl/AXIS_FIFO.sv" \
  "hdl/CFO_calc.sv" \
  "hdl/frame_sync.sv" \
  "hdl/channel_estimator.sv" \
  "hdl/demap.sv" \
  "hdl/PSS_correlator.sv" \
  "hdl/PSS_detector.sv" \
  "hdl/PSS_detector_regmap.sv" \
  "hdl/ressource_grid_subscriber.sv" \
  "hdl/SSS_detector.sv" \
  "hdl/axis_axil_fifo.sv" \
  "hdl/FFT_demod.sv" \
  "hdl/FFT/fft/fft.v" \
  "hdl/FFT/fft/int_fftNk.v" \
  "hdl/FFT/fft/int_dif2_fly.v" \
  "hdl/FFT/math/cmult/int_cmult_dsp48.v" \
  "hdl/FFT/math/cmult/int_cmult18x25_dsp48.v" \
  "hdl/FFT/math/cmult/int_cmult_dbl18_dsp48.v" \
  "hdl/FFT/math/cmult/int_cmult_dbl35_dsp48.v" \
  "hdl/FFT/math/cmult/int_cmult_trpl18_dsp48.v" \
  "hdl/FFT/math/cmult/int_cmult_trpl52_dsp48.v" \
  "hdl/FFT/math/mults/mlt35x25_dsp48e1.v" \
  "hdl/FFT/math/mults/mlt35x27_dsp48e2.v" \
  "hdl/FFT/math/mults/mlt42x18_dsp48e1.v" \
  "hdl/FFT/math/mults/mlt44x18_dsp48e2.v" \
  "hdl/FFT/math/mults/mlt52x25_dsp48e1.v" \
  "hdl/FFT/math/mults/mlt52x27_dsp48e2.v" \
  "hdl/FFT/math/mults/mlt59x18_dsp48e1.v" \
  "hdl/FFT/math/mults/mlt61x18_dsp48e2.v" \
  "hdl/FFT/math/int_addsub_dsp48.v" \
  "hdl/FFT/buffers/dynamic_block_scaling.v" \
  "hdl/FFT/buffers/inbuf_half_path.v" \
  "hdl/FFT/buffers/outbuf_half_path.v" \
  "hdl/FFT/buffers/int_bitrev_order.v" \
  "hdl/FFT/twiddle/rom_twiddle_int.v" \
  "hdl/FFT/twiddle/row_twiddle_tay.v" \
  "hdl/FFT/delay/int_align_fft.v" \
  "hdl/FFT/delay/int_delay_line.v" \
  "hdl/CIC/cic_d.sv" \
  "hdl/CIC/comb.sv" \
  "hdl/CIC/integrator.sv" \
  "hdl/CIC/downsampler.sv" \
  "hdl/CIC/downsampler_variable.sv" \
  "hdl/DDS/dds.sv" \
  "hdl/complex_multiplier/complex_multiplier.v" \
  "hdl/axil_interconnect_wrap_1x4.v" \
  "hdl/verilog-axi/axil_interconnect.v" \
  "hdl/verilog-axi/arbiter.v" \
  "hdl/verilog-axi/priority_encoder.v" \
  "open5G_rx_constr.ttcl" ]

set_property top receiver [current_fileset]
update_compile_order -fileset sources_1

adi_ip_properties_lite open5G_rx
adi_ip_ttcl open5G_rx "open5G_rx_constr.ttcl"

set_property display_name "Open5G receiver" [ipx::current_core]
set_property description "Open5G receiver" [ipx::current_core]

adi_add_bus "m_axis_out" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_out_tvalid" "TVALID"} \
		{"m_axis_out_tdata"  "TDATA"} \
	}
adi_ip_infer_mm_interfaces open5G_rx

adi_add_bus_clock "clk_i" "m_axis_out:s_axi_if" "reset_ni"

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]