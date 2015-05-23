
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

proc load_fir_filter_vector {filter_file} {
	set fp [open $filter_file r]
	set data [split [read $fp] "\n"]
	set filter ""
	close $fp
	foreach line $data {
		set line [string trim $line]
		if {[string equal -length 1 $line "#"] || $line eq ""} {
			continue
		}
		if {$filter ne ""} {
			append filter ","
		}
		append filter $line
	}

	return $filter
}

set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {35}] $sys_ps7

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]

set axi_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_dma]
set_property -dict [list \
		CONFIG.C_FIFO_SIZE 2 \
		CONFIG.C_DMA_TYPE_SRC 2 \
		CONFIG.C_DMA_TYPE_DEST 0 \
		CONFIG.C_CYCLIC 0 \
		CONFIG.C_SYNC_TRANSFER_START 1 \
		CONFIG.C_AXI_SLICE_SRC 0 \
		CONFIG.C_AXI_SLICE_DEST 0 \
		CONFIG.C_CLKS_ASYNC_DEST_REQ 0 \
		CONFIG.C_CLKS_ASYNC_SRC_DEST 0 \
		CONFIG.C_CLKS_ASYNC_REQ_SRC 0 \
		CONFIG.C_2D_TRANSFER 0 \
		CONFIG.C_DMA_DATA_WIDTH_SRC 32 \
		CONFIG.C_DMA_DATA_WIDTH_DEST 64 \
		CONFIG.C_DMA_AXI_PROTOCOL_DEST 1 \
	] $axi_dma

# Create SPI engine controller with offload
create_bd_cell -type hier spi
current_bd_instance /spi

	create_bd_pin -dir I -type clk clk
	create_bd_pin -dir I -type rst resetn
	create_bd_pin -dir O conv_done
	create_bd_pin -dir O irq
	create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

	set spi_engine [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_execution:1.0 execution]
	set axi_spi_engine [create_bd_cell -type ip -vlnv analog.com:user:axi_spi_engine:1.0 axi]
	set spi_engine_offload [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_offload:1.0 offload]
	set spi_engine_interconnect [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_interconnect:1.0 interconnect]
	set util_sigma_delta_spi [create_bd_cell -type ip -vlnv analog.com:user:util_sigma_delta_spi:1.0 util_sigma_delta_spi]

	set_property -dict [list CONFIG.NUM_CS 2] $spi_engine

	set_property -dict [list CONFIG.NUM_CS 2] $util_sigma_delta_spi

	ad_connect axi/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
	ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
	ad_connect axi/spi_engine_ctrl interconnect/s1_ctrl
	ad_connect interconnect/m_ctrl execution/ctrl
	ad_connect offload/offload_sdi M_AXIS_SAMPLE

	ad_connect util_sigma_delta_spi/data_ready offload/trigger
	ad_connect util_sigma_delta_spi/data_ready conv_done

	ad_connect execution/active util_sigma_delta_spi/spi_active
	ad_connect execution/spi util_sigma_delta_spi/s_spi
	ad_connect util_sigma_delta_spi/m_spi m_spi

	connect_bd_net \
		[get_bd_pins clk] \
		[get_bd_pins offload/spi_clk] \
		[get_bd_pins offload/ctrl_clk] \
		[get_bd_pins execution/clk] \
		[get_bd_pins axi/s_axi_aclk] \
		[get_bd_pins axi/spi_clk] \
		[get_bd_pins interconnect/clk] \
		[get_bd_pins util_sigma_delta_spi/clk]

	connect_bd_net \
		[get_bd_pins axi/spi_resetn] \
		[get_bd_pins offload/spi_resetn] \
		[get_bd_pins execution/resetn] \
		[get_bd_pins interconnect/resetn] \
		[get_bd_pins util_sigma_delta_spi/resetn]

	connect_bd_net [get_bd_pins resetn] [get_bd_pins axi/s_axi_aresetn]
	ad_connect irq axi/irq

current_bd_instance /

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi
ad_connect spi/m_spi spi

set phase_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 phase_gen]
set phase_slice [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 phase_slice]
create_bd_port -dir O excitation

set excitation_freq 1020

set_property -dict [list \
		CONFIG.Output_Width 32 \
		CONFIG.Increment_Value [format "%x" [expr $excitation_freq * (1<<32) / 100000000]] \
	] $phase_gen

set_property -dict [list \
		CONFIG.DIN_TO {31} \
		CONFIG.DIN_FROM {31} \
		CONFIG.DOUT_WIDTH {1} \
	] $phase_slice

ad_connect /phase_gen/Q /phase_slice/Din
ad_connect /phase_slice/Dout excitation

create_bd_cell -type hier processing
current_bd_instance /processing

	create_bd_pin -dir I -type clk clk
	create_bd_pin -dir I -type rst resetn
	create_bd_pin -dir I conv_done
	create_bd_pin -dir I -from 31 -to 0 phase
	create_bd_pin -dir O overflow
	create_bd_pin -dir I -from 13 -to 0 channel_enable
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_SAMPLE
	create_bd_intf_pin -mode Master -vlnv analog.com:interface:fifo_wr_rtl:1.0 DMA_WR 

	create_bd_cell -type ip -vlnv analog.com:user:cn0363_phase_data_sync:1.0 phase_data_sync
	create_bd_cell -type ip -vlnv analog.com:user:cn0363_dma_sequencer:1.0 sequencer
	create_bd_cell -type ip -vlnv analog.com:user:cordic_demod:1.0 cordic_demod

	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 phase_broadcast
	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 sample_broadcast
	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 sample_filtered_broadcast
	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 i_q_broadcast
	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 phase_sample_combine
	set i_q_resize [create_bd_cell -type ip -vlnv analog.com:user:util_axis_resize:1.0 i_q_resize]

	set_property -dict [list \
		CONFIG.C_M_DATA_WIDTH 32 \
		CONFIG.C_S_DATA_WIDTH 64 \
	] $i_q_resize

	set hpf [create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 hpf]
	set lpf [create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 lpf]

	set_property -dict [list \
		CONFIG.Data_Fractional_Bits.VALUE_SRC USER \
		CONFIG.Data_Sign.VALUE_SRC USER \
		CONFIG.Data_Width.VALUE_SRC USER \
		CONFIG.M_DATA_Has_TREADY true \
		CONFIG.Number_Channels 2 \
		CONFIG.Sample_Frequency 0.025 \
		CONFIG.Clock_Frequency 100 \
		CONFIG.Coefficient_Width 16 \
		CONFIG.Data_Width 24 \
		CONFIG.Output_Width 32 \
		CONFIG.Output_Rounding_Mode Truncate_LSBs \
		CONFIG.Has_ARESETn true \
		CONFIG.Reset_Data_Vector false \
		CONFIG.CoefficientVector [load_fir_filter_vector "filters/hpf.mat"] \
	] $hpf

	set_property -dict [list \
		CONFIG.Data_Fractional_Bits.VALUE_SRC USER \
		CONFIG.Data_Sign.VALUE_SRC USER \
		CONFIG.Data_Width.VALUE_SRC USER \
		CONFIG.M_DATA_Has_TREADY true \
		CONFIG.Number_Channels 4 \
		CONFIG.Sample_Frequency 0.025 \
		CONFIG.Clock_Frequency 100 \
		CONFIG.Coefficient_Width 24 \
		CONFIG.Data_Width 32 \
		CONFIG.Output_Width 32 \
		CONFIG.Output_Rounding_Mode Truncate_LSBs \
		CONFIG.Has_ARESETn true \
		CONFIG.Reset_Data_Vector false \
		CONFIG.CoefficientVector [load_fir_filter_vector "filters/lpf.mat"] \
	] $lpf

	set overflow_or [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 overflow_or]
	set_property -dict [list \
		CONFIG.C_SIZE 1 \
		CONFIG.C_OPERATION {or} \
	] $overflow_or

	ad_connect S_AXIS_SAMPLE phase_data_sync/S_AXIS_SAMPLE
	ad_connect conv_done phase_data_sync/conv_done
	ad_connect phase phase_data_sync/phase

	ad_connect phase_data_sync/M_AXIS_PHASE phase_broadcast/S_AXIS
	ad_connect phase_broadcast/M00_AXIS sequencer/phase
	ad_connect phase_broadcast/M01_AXIS phase_sample_combine/S01_AXIS

	ad_connect phase_data_sync/M_AXIS_SAMPLE sample_broadcast/S_AXIS
	ad_connect sample_broadcast/M00_AXIS sequencer/data
	ad_connect sample_broadcast/M01_AXIS hpf/S_AXIS_DATA

	ad_connect hpf/M_AXIS_DATA sample_filtered_broadcast/S_AXIS
	ad_connect sample_filtered_broadcast/M00_AXIS sequencer/data_filtered
	ad_connect sample_filtered_broadcast/M01_AXIS phase_sample_combine/S00_AXIS

	ad_connect phase_sample_combine/M_AXIS cordic_demod/S_AXIS
	ad_connect cordic_demod/M_AXIS i_q_resize/s_axis

	ad_connect i_q_resize/m_axis i_q_broadcast/S_AXIS
	ad_connect i_q_broadcast/M00_AXIS sequencer/i_q
	ad_connect i_q_broadcast/M01_AXIS lpf/S_AXIS_DATA

	ad_connect lpf/M_AXIS_DATA sequencer/i_q_filtered

	connect_bd_net \
		[get_bd_pins clk] \
		[get_bd_pins phase_data_sync/clk] \
		[get_bd_pins sequencer/clk] \
		[get_bd_pins cordic_demod/clk] \
		[get_bd_pins phase_broadcast/aclk] \
		[get_bd_pins sample_broadcast/aclk] \
		[get_bd_pins sample_filtered_broadcast/aclk] \
		[get_bd_pins i_q_broadcast/aclk] \
		[get_bd_pins phase_sample_combine/aclk] \
		[get_bd_pins i_q_resize/clk] \
		[get_bd_pins hpf/aclk] \
		[get_bd_pins lpf/aclk]

	connect_bd_net \
		[get_bd_pins resetn] \
		[get_bd_pins sequencer/resetn] \
		[get_bd_pins phase_data_sync/resetn] \

	connect_bd_net \
		[get_bd_pins sequencer/processing_resetn] \
		[get_bd_pins phase_data_sync/processing_resetn] \
		[get_bd_pins cordic_demod/resetn] \
		[get_bd_pins phase_broadcast/aresetn] \
		[get_bd_pins sample_broadcast/aresetn] \
		[get_bd_pins sample_filtered_broadcast/aresetn] \
		[get_bd_pins i_q_broadcast/aresetn] \
		[get_bd_pins phase_sample_combine/aresetn] \
		[get_bd_pins i_q_resize/resetn] \
		[get_bd_pins hpf/aresetn] \
		[get_bd_pins lpf/aresetn]

	ad_connect channel_enable sequencer/channel_enable
	ad_connect sequencer/dma_wr DMA_WR

	ad_connect phase_data_sync/overflow overflow_or/Op1
	ad_connect sequencer/overflow overflow_or/Op2
	ad_connect overflow_or/Res overflow

	ad_connect phase_data_sync/sample_has_stat GND
	
current_bd_instance /

ad_connect /spi/M_AXIS_SAMPLE /processing/S_AXIS_SAMPLE
ad_connect /spi/conv_done /processing/conv_done
ad_connect /phase_gen/Q /processing/phase

set axi_adc [create_bd_cell -type ip -vlnv analog.com:user:axi_generic_adc:1.0 axi_adc]
set_property -dict [list \
		CONFIG.NUM_CHANNELS 14 \
	] $axi_adc

ad_connect processing/overflow axi_adc/adc_dovf
ad_connect axi_adc/adc_enable processing/channel_enable

connect_bd_net -net sys_cpu_clk \
	[get_bd_pins /spi/clk] \
	[get_bd_pins /processing/clk] \
	[get_bd_pins /axi_dma/m_dest_axi_aclk] \
	[get_bd_pins /axi_dma/fifo_wr_clk] \
	[get_bd_pins /phase_gen/CLK] \
	[get_bd_pins /axi_adc/adc_clk]

connect_bd_net -net sys_cpu_resetn \
	[get_bd_pins /spi/resetn] \
	[get_bd_pins /processing/resetn] \
	[get_bd_pins /axi_dma/m_dest_axi_aresetn]

ad_connect /processing/dma_wr /axi_dma/fifo_wr

ad_cpu_interconnect 0x43c00000 /axi_adc
ad_cpu_interconnect 0x44a00000 /spi/axi
ad_cpu_interconnect 0x44a30000 /axi_dma

ad_cpu_interrupt "ps-13" "mb-13" /axi_dma/irq 
ad_cpu_interrupt "ps-12" "mb-12" /spi/irq 

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_dma/m_dest_axi
