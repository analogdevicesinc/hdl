###############################################################################
## Copyright (C) 2016-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 spi

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

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 35

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]

ad_ip_instance axi_dmac axi_dma
ad_ip_parameter axi_dma CONFIG.FIFO_SIZE 2
ad_ip_parameter axi_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_dma CONFIG.DMA_AXI_PROTOCOL_DEST 1

# Create SPI engine controller with offload

set data_width    8
set async_spi_clk 0
set num_cs        2
set num_sdi       1
set num_sdo       1
set sdi_delay     1
set echo_sclk     0

set hier_spi_engine spi_cn0363

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn

ad_ip_instance util_sigma_delta_spi util_sigma_delta_spi
ad_ip_parameter util_sigma_delta_spi CONFIG.NUM_OF_CS $num_cs

ad_connect $hier_spi_engine/clk util_sigma_delta_spi/clk
ad_connect util_sigma_delta_spi/resetn $hier_spi_engine/resetn

ad_connect $hier_spi_engine/m_spi util_sigma_delta_spi/s_spi
ad_connect util_sigma_delta_spi/data_ready $hier_spi_engine/trigger
ad_connect $hier_spi_engine/${hier_spi_engine}_execution/active util_sigma_delta_spi/spi_active
ad_connect util_sigma_delta_spi/m_spi spi

ad_ip_instance c_counter_binary phase_gen
ad_ip_instance xlslice phase_slice
create_bd_port -dir O excitation

set excitation_freq 1020

ad_ip_parameter phase_gen	CONFIG.Output_Width 32
ad_ip_parameter phase_gen	CONFIG.Increment_Value [format "%x" [expr $excitation_freq * (1<<32) / 100000000]]

ad_ip_parameter phase_slice	CONFIG.DIN_TO 31
ad_ip_parameter phase_slice	CONFIG.DIN_FROM 31
ad_ip_parameter phase_slice	CONFIG.DOUT_WIDTH 1

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

  ad_ip_instance cn0363_phase_data_sync phase_data_sync
  ad_ip_instance cn0363_dma_sequencer sequencer
  ad_ip_instance cordic_demod cordic_demod

  ad_ip_instance axis_broadcaster phase_broadcast
  ad_ip_instance axis_broadcaster sample_broadcast
  ad_ip_instance axis_broadcaster sample_filtered_broadcast
  ad_ip_instance axis_broadcaster i_q_broadcast
  ad_ip_instance axis_combiner phase_sample_combine
  ad_ip_instance util_axis_resize i_q_resize

	ad_ip_parameter i_q_resize	CONFIG.MASTER_DATA_WIDTH 32
	ad_ip_parameter i_q_resize	CONFIG.SLAVE_DATA_WIDTH 64

  ad_ip_instance fir_compiler hpf
  ad_ip_instance fir_compiler lpf

	ad_ip_parameter hpf	CONFIG.CoefficientVector [load_fir_filter_vector "../common/filters/hpf.mat"]
	ad_ip_parameter hpf	CONFIG.Data_Fractional_Bits.VALUE_SRC USER
	ad_ip_parameter hpf	CONFIG.Data_Sign.VALUE_SRC USER
	ad_ip_parameter hpf	CONFIG.Data_Width.VALUE_SRC USER
	ad_ip_parameter hpf	CONFIG.M_DATA_Has_TREADY true
	ad_ip_parameter hpf	CONFIG.Number_Channels 2
	ad_ip_parameter hpf	CONFIG.Sample_Frequency 0.025
	ad_ip_parameter hpf	CONFIG.Clock_Frequency 100
	ad_ip_parameter hpf	CONFIG.Coefficient_Width 16
	ad_ip_parameter hpf	CONFIG.Data_Width 24
	ad_ip_parameter hpf	CONFIG.Output_Rounding_Mode Truncate_LSBs
	ad_ip_parameter hpf	CONFIG.Output_Width 32
	ad_ip_parameter hpf	CONFIG.Has_ARESETn true
	ad_ip_parameter hpf	CONFIG.Reset_Data_Vector false

	ad_ip_parameter lpf	CONFIG.CoefficientVector [load_fir_filter_vector "../common/filters/lpf.mat"]
	ad_ip_parameter lpf	CONFIG.Data_Fractional_Bits.VALUE_SRC USER
	ad_ip_parameter lpf	CONFIG.Data_Sign.VALUE_SRC USER
	ad_ip_parameter lpf	CONFIG.Data_Width.VALUE_SRC USER
	ad_ip_parameter lpf	CONFIG.M_DATA_Has_TREADY true
	ad_ip_parameter lpf	CONFIG.Number_Channels 4
	ad_ip_parameter lpf	CONFIG.Sample_Frequency 0.025
	ad_ip_parameter lpf	CONFIG.Clock_Frequency 100
	ad_ip_parameter lpf	CONFIG.Coefficient_Width 24
	ad_ip_parameter lpf	CONFIG.Data_Width 32
	ad_ip_parameter lpf	CONFIG.Output_Rounding_Mode Truncate_LSBs
	ad_ip_parameter lpf	CONFIG.Output_Width 32
	ad_ip_parameter lpf	CONFIG.Has_ARESETn true
	ad_ip_parameter lpf	CONFIG.Reset_Data_Vector false

  ad_ip_instance util_vector_logic overflow_or
	ad_ip_parameter overflow_or	CONFIG.C_SIZE 1
	ad_ip_parameter overflow_or	CONFIG.C_OPERATION or

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

ad_connect /processing/S_AXIS_SAMPLE $hier_spi_engine/M_AXIS_SAMPLE
ad_connect /phase_gen/Q /processing/phase
ad_connect util_sigma_delta_spi/data_ready /processing/conv_done

ad_ip_instance axi_generic_adc axi_adc
ad_ip_parameter axi_adc	CONFIG.NUM_OF_CHANNELS 14

ad_connect processing/overflow axi_adc/adc_dovf
ad_connect axi_adc/adc_enable processing/channel_enable

connect_bd_net -net $sys_cpu_clk \
	[get_bd_pins /processing/clk] \
	[get_bd_pins /axi_dma/m_dest_axi_aclk] \
	[get_bd_pins /axi_dma/fifo_wr_clk] \
	[get_bd_pins /phase_gen/CLK] \
	[get_bd_pins /axi_adc/adc_clk]

connect_bd_net -net $sys_cpu_resetn \
	[get_bd_pins /processing/resetn] \
	[get_bd_pins /axi_dma/m_dest_axi_aresetn]

ad_connect /processing/dma_wr /axi_dma/fifo_wr

ad_cpu_interconnect 0x43c00000 /axi_adc
ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 /axi_dma

ad_cpu_interrupt "ps-13" "mb-13" /axi_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_dma/m_dest_axi
