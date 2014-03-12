# ila debug

proc adi_ila_probe {w_obj w_msb w_lsb w_name} {

  add_wave_virtual_bus -radix hex $w_name
  for {set b $w_lsb} {$b <= $w_msb} {incr b} {
    add_wave -into $w_name "$w_obj[$b]"
  }
}

adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data    5    0   tx_data_n
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   11    6   tx_data_p
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   23   12   tx_data_i1_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   35   24   tx_data_q1_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   47   36   tx_data_i2_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   59   48   tx_data_q2_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   63   60   tx_data_sel_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   66   64   tx_data_cnt
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   67   67   tx_frame
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   68   68   dac_r1_mode
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   69   69   dac_valid
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   81   70   dac_data_i1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data   93   82   dac_data_q1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  105   94   dac_data_i2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  117  106   dac_data_q2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  118  118   rx_frame_p_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  119  119   rx_frame_n_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  120  120   rx_frame_n
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  122  121   rx_frame
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  124  123   rx_frame_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  128  125   rx_frame_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  134  129   rx_data_p_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  140  135   rx_data_n_s
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  146  141   rx_data_n
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  158  147   rx_data
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  170  159   rx_data_d
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  171  171   rx_error_r1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  172  172   rx_valid_r1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  184  173   rx_data_i_r1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  196  185   rx_data_q_r1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  197  197   rx_error_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  198  198   rx_valid_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  210  199   rx_data_i1_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  222  211   rx_data_q1_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  234  223   rx_data_i2_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  246  235   rx_data_q2_r2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  247  247   adc_r1_mode
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  248  248   adc_status
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  249  249   adc_valid
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  261  250   adc_data_i1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  273  262   adc_data_q1
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  285  274   adc_data_i2
adi_ila_probe system_i/axi_ad9361_1_dev_dbg_data  297  286   adc_data_q2

