###############################################################################
## Copyright (C) 2015-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc init {cellpath otherInfo} {
	set ip [get_bd_cells $cellpath]

	bd::mark_propagate_override $ip \
		"ASYNC_CLK_REQ_SRC ASYNC_CLK_SRC_DEST ASYNC_CLK_DEST_REQ ASYNC_CLK_REQ_SG ASYNC_CLK_SRC_SG ASYNC_CLK_DEST_SG"

	bd::mark_propagate_override $ip \
		"DMA_AXI_ADDR_WIDTH"

	# On ZYNQ the core is most likely connected to the AXI3 HP ports so use AXI3
	# as the default.
	set family [string tolower [get_property FAMILY [get_property PART [current_project]]]]
	if {$family == "zynq"} {
		set axi_protocol 1
	} else {
		set axi_protocol 0
	}

	foreach dir {SRC DEST} {
		# Change the protocol by first enabling the parameter - setting the type to AXI MM
		set old [get_property "CONFIG.DMA_TYPE_${dir}" $ip]
		set_property "CONFIG.DMA_TYPE_${dir}" "0" $ip
		set_property "CONFIG.DMA_AXI_PROTOCOL_${dir}" $axi_protocol $ip
		set_property "CONFIG.DMA_TYPE_${dir}" $old $ip
	}

	# Change the protocol by first enabling the parameter - enabling the SG transfers 
	set old [get_property "CONFIG.DMA_SG_TRANSFER" $ip]
	set_property "CONFIG.DMA_SG_TRANSFER" "true" $ip
	set_property "CONFIG.DMA_AXI_PROTOCOL_SG" $axi_protocol $ip
	set_property "CONFIG.DMA_SG_TRANSFER" $old $ip

  # Versions earlier than 2017.3 infer sub-optimal asymmetric memory
  # See https://www.xilinx.com/support/answers/69179.html
  regexp {^[0-9]+\.[0-9]+} [version -short] short_version
  if {[expr $short_version > 2017.2]} {
    set_property "CONFIG.ALLOW_ASYM_MEM" 1 $ip
  }
}

proc post_config_ip {cellpath otherinfo} {
	set ip [get_bd_cells $cellpath]

	# Update AXI interface properties according to configuration
	set max_bytes_per_burst [get_property "CONFIG.MAX_BYTES_PER_BURST" $ip]
	set fifo_size [get_property "CONFIG.FIFO_SIZE" $ip]

	foreach dir {"SRC" "DEST"} {
		set type [get_property "CONFIG.DMA_TYPE_$dir" $ip]
		if {$type != 0} {
			continue
		}

		set axi_protocol [get_property "CONFIG.DMA_AXI_PROTOCOL_$dir" $ip]
		set data_width [get_property "CONFIG.DMA_DATA_WIDTH_$dir" $ip]
		set max_beats_per_burst [expr {int(ceil($max_bytes_per_burst * 8.0 / $data_width))}]

		if {$axi_protocol == 0} {
			set axi_protocol_str "AXI4"
			if {$max_beats_per_burst > 256} {
				set max_beats_per_burst 256
			}
		} else {
			set axi_protocol_str "AXI3"
			if {$max_beats_per_burst > 16} {
				set max_beats_per_burst 16
			}
		}

		set intf [get_bd_intf_pins [format "%s/m_%s_axi" $cellpath [string tolower $dir]]]
		set_property CONFIG.PROTOCOL $axi_protocol_str $intf
		set_property CONFIG.MAX_BURST_LENGTH $max_beats_per_burst $intf

		# The core issues as many requests as the amount of data the FIFO can hold
		if {$dir == "SRC"} {
			set_property CONFIG.NUM_WRITE_OUTSTANDING 0 $intf
			set_property CONFIG.NUM_READ_OUTSTANDING $fifo_size $intf
		} else {
			set_property CONFIG.NUM_WRITE_OUTSTANDING $fifo_size $intf
			set_property CONFIG.NUM_READ_OUTSTANDING 0 $intf
		}
	}

	# SG interface configuration
	set sg_enabled [get_property CONFIG.DMA_SG_TRANSFER $ip]
	if {$sg_enabled == "true"} {
		set axi_protocol [get_property "CONFIG.DMA_AXI_PROTOCOL_SG" $ip]

		if {$axi_protocol == 0} {
			set axi_protocol_str "AXI4"
			set max_beats_per_burst 256
		} else {
			set axi_protocol_str "AXI3"
			set max_beats_per_burst 16
		}

		set intf [get_bd_intf_pins [format "%s/m_sg_axi" $cellpath]]
		set_property CONFIG.PROTOCOL $axi_protocol_str $intf
		set_property CONFIG.MAX_BURST_LENGTH $max_beats_per_burst $intf

		set_property CONFIG.NUM_WRITE_OUTSTANDING 0 $intf
		set_property CONFIG.NUM_READ_OUTSTANDING 0 $intf
	}
}

proc axi_dmac_detect_async_clk { cellpath ip param_name clk_a clk_b } {
	set param_src [get_property "CONFIG.$param_name.VALUE_SRC" $ip]
	if {[string equal $param_src "USER"]} {
		return;
	}

	set clk_domain_a [get_property CONFIG.CLK_DOMAIN $clk_a]
	set clk_domain_b [get_property CONFIG.CLK_DOMAIN $clk_b]
	set clk_freq_a [get_property CONFIG.FREQ_HZ $clk_a]
	set clk_freq_b [get_property CONFIG.FREQ_HZ $clk_b]
	set clk_phase_a [get_property CONFIG.PHASE $clk_a]
	set clk_phase_b [get_property CONFIG.PHASE $clk_b]

	# Only mark it as sync if we can make sure that it is sync, if the
	# relationship of the clocks is unknown mark it as async
	if {$clk_domain_a != {} && $clk_domain_b != {} && \
		$clk_domain_a == $clk_domain_b && $clk_freq_a == $clk_freq_b && \
		$clk_phase_a == $clk_phase_b} {
		set clk_async 0
	} else {
		set clk_async 1
	}

	set_property "CONFIG.$param_name" $clk_async $ip

#	if {$clk_async == 0} {
#		bd::send_msg -of $cellpath -type INFO -msg_id 1 -text "$clk_a and $clk_b are synchronous"
#	} else {
#		bd::send_msg -of $cellpath -type INFO -msg_id 1 -text "$clk_a and $clk_b are asynchronous"
#	}
}

proc propagate {cellpath otherinfo} {
	set ip [get_bd_cells $cellpath]
	set src_type [get_property CONFIG.DMA_TYPE_SRC $ip]
	set dest_type [get_property CONFIG.DMA_TYPE_DEST $ip]
	set sg_enabled [get_property CONFIG.DMA_SG_TRANSFER $ip]

	set req_clk [get_bd_pins "$ip/s_axi_aclk"]

	if {$src_type == 2} {
		set src_clk [get_bd_pins "$ip/fifo_wr_clk"]
	} elseif {$src_type == 1} {
		set src_clk [get_bd_pins "$ip/s_axis_aclk"]
	} else {
		set src_clk [get_bd_pins "$ip/m_src_axi_aclk"]
	}

	if {$dest_type == 2} {
		set dest_clk [get_bd_pins "$ip/fifo_rd_clk"]
	} elseif {$dest_type == 1} {
		set dest_clk [get_bd_pins "$ip/m_axis_aclk"]
	} else {
		set dest_clk [get_bd_pins "$ip/m_dest_axi_aclk"]
	}

	axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_REQ_SRC" $req_clk $src_clk
	axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_SRC_DEST" $src_clk $dest_clk
	axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_DEST_REQ" $dest_clk $req_clk

	if {$sg_enabled == "true"} {
		set sg_clk [get_bd_pins "$ip/m_sg_axi_aclk"]
		axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_REQ_SG" $req_clk $sg_clk
		axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_SRC_SG" $src_clk $sg_clk
		axi_dmac_detect_async_clk $cellpath $ip "ASYNC_CLK_DEST_SG" $dest_clk $sg_clk
	}
}

proc post_propagate {cellpath otherinfo} {
	set ip [get_bd_cells $cellpath]

	set addr_width 16

	foreach dir {"SRC" "DEST"} {
		set type [get_property "CONFIG.DMA_TYPE_$dir" $ip]
		if {$type != 0} {
			continue
		}

		set intf [get_bd_intf_pins [format "%s/m_%s_axi" $cellpath [string tolower $dir]]]
		set addr_segs [get_bd_addr_segs -of_objects  [get_bd_addr_spaces $intf]]

		if {$addr_segs != {}} {
			foreach addr_seg $addr_segs {
				set range [get_property "range" $addr_seg]
				set offset [get_property "offset" $addr_seg]
				set addr_width [expr max(int(ceil(log($range - 1 + $offset) / log(2))), $addr_width)]
			}
		} else {
			set addr_width 32
		}

	}

	set_property "CONFIG.DMA_AXI_ADDR_WIDTH" $addr_width $ip

	# AXCACHE/AXPROT configuration
        set cache_coherent [get_property "CONFIG.CACHE_COHERENT" $ip]
        set axcache [expr {$cache_coherent == true} ? 0b1111 : 0b0011]
        set axprot [expr {$cache_coherent == true} ? 0b010 : 0b000]
        set_property "CONFIG.AXI_AXCACHE" $axcache $ip
        set_property "CONFIG.AXI_AXPROT" $axprot $ip
}
